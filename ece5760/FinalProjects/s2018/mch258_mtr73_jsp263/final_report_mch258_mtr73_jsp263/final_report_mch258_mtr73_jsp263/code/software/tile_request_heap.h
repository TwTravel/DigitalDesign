#ifndef __TILE_REQUEST_HEAP_H__
#define __TILE_REQUEST_HEAP_H__

#include "tile_header.h"
#include <iostream>
#include <functional>
#include <vector>


class TileRequestHeap {
private:
    int _max_size;

    std::function<double(std::shared_ptr<TileHeader>)> _priority;

    std::function<bool(std::shared_ptr<TileHeader>, std::shared_ptr<TileHeader>)> _compare;

    std::vector<std::shared_ptr<TileHeader>> _heap;

public:
    TileRequestHeap(int max_size);

    void push(std::shared_ptr<TileHeader> header);

    void pop();

    std::shared_ptr<TileHeader> front();

    void clear() { _heap.clear(); }

    void rebuild(std::function<double(std::shared_ptr<TileHeader>)> priority);

    bool contains(std::shared_ptr<TileHeader> header);

    unsigned int size() { return _heap.size(); }
};


#endif
