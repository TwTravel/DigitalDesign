#include "tile_server.h"

#include "cpu_solver.h"
#include "fpga_solver.h"
#include "constants.h"
#include "socket_util.h"
#include "tile.h"

#include <chrono>
#include <iostream>
#include <memory>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>


TileServer::TileServer(int port) : _port(port), solver(
#ifndef HPS
        new CPUSolver()
#else
        new FPGASolver()
#endif
) {
    _tile_poll_thread = std::thread(tilePollTask, this);
}


void TileServer::init() {
    std::cout << "starting tile server on port " << _port << std::endl;

    _address_len = sizeof(_address);
      
    if ((_socket_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        std::cout << "socket failed" << std::endl;
    }

    int opt = 1;

    /*
    if (setsockopt(_socket_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT, &opt, sizeof(opt))) {
        std::cout << "setsockopt failed" << std::endl;
    }
    */

    _address.sin_family = AF_INET;
    _address.sin_addr.s_addr = INADDR_ANY;
    _address.sin_port = htons(_port);
      
    if (bind(_socket_fd, (sockaddr*) &_address, _address_len) < 0) {
        std::cout << "bind failed" << std::endl;
    }
}


int TileServer::awaitConnection() {
    int socket;

    if (listen(_socket_fd, 3) < 0) {
        std::cout << "listen failed" << std::endl;
    }

    if ((socket = accept(_socket_fd, (sockaddr*) &_address, &_address_len)) < 0) {
        std::cout << "accept failed" << std::endl;
    }

    return socket;
}


void TileServer::tilePollTask(TileServer* tile_server) {
    while(true) {
        std::shared_ptr<TileHeader> header;

        {
            std::unique_lock<std::mutex> lock(tile_server->_mutex);

            for (auto it = tile_server->requests.begin(); it != tile_server->requests.end(); ) {
                std::shared_ptr<TileHeader> header = std::get<0>(*it);
                int connection = std::get<1>(*it);
                Solver::data tile_data = tile_server->solver->retrieve(header);
                if (tile_data != nullptr) {
                    it = tile_server->requests.erase(it);

                    std::vector<uint8_t> tile_bytes;
                    for (int i = 0; i < Constants::TILE_WIDTH * Constants::TILE_HEIGHT; i++) {
                        uint8_t buffer[2];
                        ((uint16_t*) buffer)[0] = htons(tile_data[i]);
                        tile_bytes.push_back(buffer[0]);
                        tile_bytes.push_back(buffer[1]);
                    }

                    std::vector<uint8_t> header_data = header->serialize();

                    SocketUtil::sendPacket(connection, header_data);
                    SocketUtil::sendPacket(connection, tile_bytes);
                } else {
                    ++it;
                }
            }
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }
}


void TileServer::serveForever() {
    while (true) {
        int connection = awaitConnection();
        client_listeners.emplace_back([connection] (TileServer* server) {
            while (true) {
                try {
                    std::vector<uint8_t> header_data = SocketUtil::receivePacket(connection);
                    if (header_data.size() == 0) return;

                    std::unique_ptr<TileHeader> unique_header = TileHeader::deserialize(header_data);
                    std::shared_ptr<TileHeader> header = std::move(unique_header);

                    {
                        std::unique_lock<std::mutex> lock(server->_mutex);
                        server->requests.insert(std::tuple<std::shared_ptr<TileHeader>, int>(header, connection));
                    }
                    server->solver->sumbit(header);
                } catch (std::runtime_error& e) {
                    std::cout << e.what() << std::endl;
                    return;
                }
            }
        }, this);
    }


}
