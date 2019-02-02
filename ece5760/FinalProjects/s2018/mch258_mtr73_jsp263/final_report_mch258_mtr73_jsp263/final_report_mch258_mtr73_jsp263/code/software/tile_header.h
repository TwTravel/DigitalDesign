#ifndef __TILE_HEADER_H__
#define __TILE_HEADER_H__

#include "complex.h"

#include <cmath>
#include <gmpxx.h>
#include <iostream>
#include <sstream>
#include <memory>
#include <netinet/in.h>
#include <vector>


class TileHeader {
public:
    mpz_class x;
    mpz_class y;
    int32_t z;
    int16_t iter_lim;

    // Delete copy constructor.
    TileHeader(const TileHeader&) = delete;

    TileHeader(mpz_class x_in, mpz_class y_in, uint32_t z_in, int16_t iter_lim) : x(x_in), y(y_in), z(z_in), iter_lim(iter_lim) {};

    complex getOrigin() const {
        mpf_class f_header_x(x, z + 64);
        mpf_class f_header_y(y, z + 64);
        double size = getSize();
        return {f_header_x * size, f_header_y * size};
    }

    double getSize() const {
        // TODO: precision
        return pow(2.0, (double) -z);
    }

    bool operator==(const TileHeader& other) const {
        return (x == other.x) && (y == other.y) && (z == other.z) && iter_lim == other.iter_lim;
    }

    struct Hasher {
        std::size_t operator()(const std::shared_ptr<TileHeader>& header) const {
            size_t h = 0;
            // TODO: smarter way of hashing big ints would be good.
            h = header->x.get_si() + (h << 6) + (h << 16) - h;
            h = header->y.get_si() + (h << 6) + (h << 16) - h;
            h = header->z + (h << 6) + (h << 16) - h;
            h = header->iter_lim + (h << 6) + (h << 16) - h;
            return h;
        }
    };

    struct Comparator {
        bool operator()(const std::shared_ptr<TileHeader>& a, const std::shared_ptr<TileHeader>& b) const {
            return (a->x == b->x) && (a->y == b->y) && (a->z == b->z) && (a->iter_lim == b->iter_lim);
        }
    };

    std::vector<uint8_t> serialize() {
        std::string x_str = x.get_str();
        std::string y_str = y.get_str();

        uint32_t x_size = x_str.length() + 1;
        uint32_t y_size = y_str.length() + 1;
        int serialized_size = x_size + y_size + sizeof(x_size) + sizeof(y_size) + sizeof(z) + sizeof(iter_lim);

        uint8_t buffer [serialized_size];

        const uint8_t* x_cstr = (uint8_t*) x_str.c_str();
        const uint8_t* y_cstr = (uint8_t*) y_str.c_str();

        // Put x_size and y_size into buffer.
        ((uint32_t*) buffer)[0] = htonl(x_size);
        ((uint32_t*) buffer)[1] = htonl(y_size);
        int offset = 8;

        // Put x and y into buffer.
        std::memcpy(buffer + offset, x_cstr, x_size);
        offset += x_size;

        std::memcpy(buffer + offset, y_cstr, y_size);
        offset += y_size;

        // Put z into buffer.
        *((uint32_t*) (buffer + offset)) = htonl(z);
        offset += sizeof(z);

        // Put iter_lim into buffer
        *((int16_t*) (buffer + offset)) = htons(iter_lim);

        std::vector<uint8_t> result(buffer, buffer + serialized_size);
        return result;
    }

    static std::unique_ptr<TileHeader> deserialize(const std::vector<uint8_t>& data) {
        const uint8_t* buffer = &data[0];

        // Read x_size and y_size from buffer.
        uint32_t x_size = ntohl(((uint32_t*) buffer)[0]);
        uint32_t y_size = ntohl(((uint32_t*) buffer)[1]);
        int offset = 8;

        // Make sure buffer is correct size.
        if (data.size() != x_size + y_size + sizeof(x_size) + sizeof(y_size) + sizeof(z) + sizeof(iter_lim)) {
            throw std::runtime_error("tille header deserialization size mismatch");
        }

        // Read x and y from buffer.
        mpz_class x = mpz_class((char*) (buffer + offset));
        offset += x_size;
        mpz_class y = mpz_class((char*) (buffer + offset));
        offset += y_size;

        // Read z from buffer;
        uint32_t z = ntohl(*((uint32_t*) (buffer + offset)));
        offset += sizeof(z);

        // Read iter_lim from buffer
        int16_t iter_lim = ntohs(*((int16_t*) (buffer + offset)));

        return std::unique_ptr<TileHeader>(new TileHeader(x, y, z, iter_lim));
    }

    std::string get_str() {
        std::ostringstream ss;
        ss << "(" << x.get_str() << ", " << y.get_str() << ", " << z << ", " << iter_lim << ")";
        return ss.str();
    }
};


#endif
