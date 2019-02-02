#ifndef __TILE_CLIENT_H__
#define __TILE_CLIENT_H__

#include "tile.h"
#include "tile_header.h"
#include <unistd.h>
#include <stdio.h>
#include <sys/socket.h>
#include <stdlib.h>
#include <netinet/in.h>
#include <string.h>

typedef struct sockaddr_in sockaddr_in;
typedef struct sockaddr sockaddr;


class TileClient {
private:
    std::string ip_addr;
    int _port;
    int _socket_fd;
    sockaddr_in _address;
    sockaddr_in _server_address;

public:
    TileClient(std::string ip_addr, int port);

    void init();

    void requestTile(std::shared_ptr<TileHeader> header);

    std::unique_ptr<Tile> receiveTile();
};


#endif
