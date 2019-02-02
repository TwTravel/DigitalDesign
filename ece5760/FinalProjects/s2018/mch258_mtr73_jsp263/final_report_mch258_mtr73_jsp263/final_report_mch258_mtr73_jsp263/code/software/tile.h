#ifndef __TILE_H__
#define __TILE_H__

#include "complex.h"
#include "constants.h"
#include "tile_header.h"
#include <math.h>


class Tile {
private:
    std::shared_ptr<TileHeader> _header;
    std::vector<uint16_t> _data;
    bool _has_data;

public:
    Tile(std::shared_ptr<TileHeader> header);

    Tile(std::shared_ptr<TileHeader> header, std::vector<uint16_t> data);

    complex getOrigin() const { return _header->getOrigin(); }

    double getSize() const { return _header->getSize(); }

    bool hasData() const { return _has_data; }

    std::shared_ptr<TileHeader> getHeader() const { return _header; }

    std::vector<uint16_t> getData() const;

    uint16_t getPoint(int x, int y) const;

    void setPoint(int x, int y, uint16_t value);
};


#endif
