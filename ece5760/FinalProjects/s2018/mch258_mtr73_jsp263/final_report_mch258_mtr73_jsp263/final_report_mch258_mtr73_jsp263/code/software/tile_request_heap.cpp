#include "tile_request_heap.h"
#include <algorithm>


TileRequestHeap::TileRequestHeap(int max_size) {
    // TODO: actually enforce max size.
    _max_size = max_size;

    _priority = [](std::shared_ptr<TileHeader> header) { 
        return 0; 
    };

    _compare = [this](std::shared_ptr<TileHeader> a, std::shared_ptr<TileHeader> b) {
        return _priority(a) > _priority(b);
    };
}


void TileRequestHeap::push(std::shared_ptr<TileHeader> header) {
    _heap.push_back(header);
    std::push_heap(_heap.begin(), _heap.end(), _compare);
}


std::shared_ptr<TileHeader> TileRequestHeap::front() {
    return _heap.front();
}


void TileRequestHeap::pop() {
    std::pop_heap(_heap.begin(), _heap.end(), _compare);
    _heap.pop_back();
}


void TileRequestHeap::rebuild(std::function<double(std::shared_ptr<TileHeader>)> priority) {
    _priority = priority;
    std::make_heap(_heap.begin(), _heap.end(), _compare);
}


bool TileRequestHeap::contains(std::shared_ptr<TileHeader> header) {
    auto find_result = std::find_if(_heap.begin(), _heap.end(), [header](std::shared_ptr<TileHeader> other) {
        return header->x == other->x && header->y == other->y && header->z == other->z;
    });
    return find_result != _heap.end();
}