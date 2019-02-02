#include "tile.h"


Tile::Tile(std::shared_ptr<TileHeader> header) :
        _header(header) {
    _has_data = false;
}


Tile::Tile(std::shared_ptr<TileHeader> header, std::vector<uint16_t> data) :
        _header(header),
        _data(data) {
    _has_data = true;
}


std::vector<uint16_t> Tile::getData() const {
    if (!_has_data) throw std::runtime_error("tried to get invalid tile data");
    return _data;
}


uint16_t Tile::getPoint(int x, int y) const {
    if (!_has_data) throw std::runtime_error("tried to get point from invalid tile data");
    return _data[x + y * Constants::TILE_WIDTH];
}


void Tile::setPoint(int x, int y, uint16_t value) {
    if (!_has_data) throw std::runtime_error("tried to set point from invalid tile data");
    _data[x + y * Constants::TILE_WIDTH] = value;
}
