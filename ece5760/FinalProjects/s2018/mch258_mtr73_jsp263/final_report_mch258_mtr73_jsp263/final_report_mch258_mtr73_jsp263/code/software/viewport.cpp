#include "viewport.h"
#include "constants.h"

#include <cmath>
#include <iostream>

Viewport::Viewport(complex origin_in, double zoom_in, int mipmap_shift) {
    zoom = std::ceil(zoom_in) + mipmap_shift;
    partial_zoom = pow(2, -(zoom - zoom_in));

    double tile_length = pow(2, -zoom);
    double screen_width = pow(2, -zoom_in) * Constants::SCREEN_WIDTH / Constants::TILE_WIDTH;
    double screen_height = pow(2, -zoom_in) * Constants::SCREEN_HEIGHT / Constants::TILE_HEIGHT;

    mpf_class left_float    = origin_in.real / tile_length;
    mpf_class bottom_float  = origin_in.imag / tile_length;
    mpf_class right_float   = (origin_in.real + screen_width) / tile_length;
    mpf_class top_float     = (origin_in.imag + screen_height) / tile_length;

    mpz_class left_int      (floor(left_float));
    mpz_class right_int     (floor(right_float));
    mpz_class bottom_int    (floor(bottom_float));
    mpz_class top_int       (floor(top_float));

    origin_x = left_int;
    origin_y = bottom_int;

    mpz_class mp_width = right_int - left_int + 1;
    mpz_class mp_height = top_int - bottom_int + 1;

    width = mp_width.get_si();
    height = mp_height.get_si();

    mpf_class mp_partial_x = left_float - left_int;
    mpf_class mp_partial_y = bottom_float - bottom_int;

    partial_x = mp_partial_x.get_d();
    partial_y = mp_partial_y.get_d();
}


double Viewport::screenWidth(double zoom) {
    return pow(2, -zoom) * Constants::SCREEN_WIDTH / Constants::TILE_WIDTH;
}


double Viewport::screenHeight(double zoom) {
    return pow(2, -zoom) * Constants::SCREEN_HEIGHT / Constants::TILE_HEIGHT;
}
