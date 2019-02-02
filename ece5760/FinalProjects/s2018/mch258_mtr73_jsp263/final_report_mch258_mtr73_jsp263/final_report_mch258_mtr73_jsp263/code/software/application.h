#ifndef __APPLICATION_H__
#define __APPLICATION_H__

#include "renderer.h"
#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>


class Application {
private:
    bool _running;
    complex _origin;
    double _zoom;
    double _fps;
    double control_rate;

    TileManager _tile_manager;
    Renderer _renderer;

    SDL_Window*     _window;
    SDL_Surface*    _window_surface;
    SDL_Renderer*   _sdl_renderer;

    TTF_Font*   _font_regular;
    TTF_Font*   _font_bold;

    SDL_Color   color_clear;
    SDL_Color   color_text_highlight;
    SDL_Color   color_white;
    SDL_Color   color_grey;

    void handleEvents();
    void handleInput(double timestep);
    void drawFrame();
    void drawHUD();

    void setDrawColor(const SDL_Color& color);
    void drawText(std::string message, int x, int y);

    void moveTo(mpf_class x, mpf_class y, double z);

public:
    Application(std::vector<std::tuple<std::string, int>> ip_addrs);

    void init();
    void run();
};


#endif
