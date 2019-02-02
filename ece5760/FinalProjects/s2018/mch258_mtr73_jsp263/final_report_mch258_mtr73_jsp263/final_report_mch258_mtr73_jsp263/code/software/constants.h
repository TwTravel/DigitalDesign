#ifndef __CONSTANTS_H__
#define __CONSTANTS_H__


class Constants {
public:
    static constexpr const char* WINDOW_TITLE = "Mandelbrot Renderer";
    static const int TARGET_FPS         = 60;

    static const int SCREEN_WIDTH       = 1600;
    static const int SCREEN_HEIGHT      = 900;

    static const int TILE_SIZE_BITS     = 6;
    static const int TILE_WIDTH         = 1 << TILE_SIZE_BITS;
    static const int TILE_HEIGHT        = 1 << TILE_SIZE_BITS;

    static const int ITERATIONS             = 10000;
    static const int MIN_ITERS              = 4;
    static const int MAX_ITERS              = 16384;
    static const int MPF_PRECISION          = 64;
    static const int TILE_REQUEST_HEAP_SIZE = 128;
    static const int CACHE_SIZE             = 10000;
    static const int TEXTURE_CACHE_SIZE     = 2048;

    static const int SCREEN_PIXELS      = SCREEN_WIDTH * SCREEN_HEIGHT;
    static const int TILE_PIXELS        = TILE_WIDTH * TILE_HEIGHT;
};


#endif
