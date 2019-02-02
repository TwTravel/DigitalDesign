#ifndef __SOCKET_UTIL_H__
#define __SOCKET_UTIL_H__

#include "tile_header.h"


class SocketUtil {
private:
    static void sendData(int sock, unsigned char* data, int size);

    static int receiveData(int sock, unsigned char* buffer, int size);

public:
    static void sendPacket(int sock, std::vector<uint8_t> data);

    static std::vector<uint8_t> receivePacket(int sock);
};


#endif
