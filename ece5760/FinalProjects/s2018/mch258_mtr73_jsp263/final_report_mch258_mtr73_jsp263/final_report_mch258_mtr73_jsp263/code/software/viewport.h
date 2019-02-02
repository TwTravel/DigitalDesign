#ifndef __VIEWPORT_H__
#define __VIEWPORT_H__

#include "complex.h"


class Viewport {
public:
    mpz_class origin_x;
    mpz_class origin_y;

    int width;
    int height;
    int zoom;

    double partial_x;
    double partial_y;
    double partial_zoom;

    Viewport(complex origin, double zoom, int mipmap_shift);

    static double screenWidth(double zoom);
    static double screenHeight(double zoom);
};


#endif
