#include "tile_client.h"
#include "constants.h"
#include "socket_util.h"
#include <arpa/inet.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>
#include <iostream>


TileClient::TileClient(std::string ip_addr, int port) : ip_addr(ip_addr), _port(port) {

}


void TileClient::init() {
    std::cout << "starting tile client on port " << _port << std::endl;

    if ((_socket_fd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        std::cout << "socket error" << std::endl;
    }
  
    memset(&_server_address, '0', sizeof(_server_address));
  
    _server_address.sin_family = AF_INET;
    _server_address.sin_port = htons(_port);
      
    if (inet_pton(AF_INET, ip_addr.c_str(), &_server_address.sin_addr) <= 0) {
        std::cout << "invalid address" << std::endl;
    }

    if (connect(_socket_fd, (sockaddr*) &_server_address, sizeof(_server_address)) < 0) {
        std::cout << "connect failed" << std::endl;
    }
}


void TileClient::requestTile(std::shared_ptr<TileHeader> header) {
    std::vector<uint8_t> data = header->serialize();
    SocketUtil::sendPacket(_socket_fd, data);
}


std::unique_ptr<Tile> TileClient::receiveTile() {
    std::vector<uint8_t> header_data = SocketUtil::receivePacket(_socket_fd);
    std::unique_ptr<TileHeader> unique_header = TileHeader::deserialize(header_data);
    std::shared_ptr<TileHeader> header = std::move(unique_header);
    std::vector<uint8_t> tile_bytes = SocketUtil::receivePacket(_socket_fd);

    std::vector<uint16_t> tile_data;
    for (int i = 0; i < tile_bytes.size(); i += 2) {
        tile_data.push_back(ntohs(*((uint16_t*) (&tile_bytes[0] + i))));
    }

    return std::unique_ptr<Tile>(new Tile(header, tile_data));
}
