#ifndef __TILE_MANAGER_H__
#define __TILE_MANAGER_H__

#include "complex.h"
#include "tile.h"
#include "tile_request_heap.h"
#include "tile_client.h"
#include "viewport.h"
#include <algorithm>
#include <chrono>
#include <mutex>
#include <condition_variable>
#include <thread>
#include <unordered_map>
#include <unordered_set>
#include <set>


class TileManager {
private:
    int _cache_size;
    int _request_depth;

    int16_t iterations;

    int next_request_index;
    std::vector<TileClient> clients;

    TileRequestHeap _request_heap;
    std::unordered_set<std::shared_ptr<TileHeader>, TileHeader::Hasher, TileHeader::Comparator> _outstanding_requests;

    std::mutex _mutex;
    std::condition_variable _requests_nonempty;
    std::condition_variable _requests_available;
    std::thread _tile_requesting_thread;
    std::vector<std::thread> receiving_threads;

    static void tileRequestingTask(TileManager* tile_manager);

    bool isTileRequested(std::shared_ptr<TileHeader> header);

    void cacheInsert(std::shared_ptr<Tile> tile);

    bool cacheContains(std::shared_ptr<TileHeader> header);

    void cacheEvictOldest();

    struct CachedTile {
        std::shared_ptr<Tile> tile;
        std::chrono::time_point<std::chrono::system_clock> last_hit;
    };

    std::unordered_map<std::shared_ptr<TileHeader>, CachedTile, TileHeader::Hasher, TileHeader::Comparator> _cache;

public:
    TileManager(std::vector<std::tuple<std::string, int>> ip_addrs, int cache_size, int request_depth = 30);

    std::shared_ptr<Tile> requestTile(std::shared_ptr<TileHeader> header, int depth);

    std::set<std::shared_ptr<Tile>> loadViewport(Viewport viewport);

    int16_t getIterations() { return iterations; }
    void setIterations(int16_t iterations) { this->iterations = iterations; }

    void clearRequests();

    bool isFinished() { return _outstanding_requests.size() + _request_heap.size() == 0; }
};


#endif
