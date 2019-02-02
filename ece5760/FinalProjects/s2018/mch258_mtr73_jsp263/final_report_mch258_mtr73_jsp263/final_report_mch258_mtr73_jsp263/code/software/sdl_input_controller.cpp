#include "sdl_input_controller.h"

#include <SDL2/SDL.h>

model::Input SdlInputController::getInput() {
    model::Input input;

    const Uint8 *keys = SDL_GetKeyboardState(NULL);

    const double shift_speed = 1.0;
    if (keys[SDL_SCANCODE_RIGHT])   input.dx += shift_speed;
    if (keys[SDL_SCANCODE_LEFT])    input.dx -= shift_speed;
    if (keys[SDL_SCANCODE_UP])      input.dy += shift_speed;
    if (keys[SDL_SCANCODE_DOWN])    input.dy -= shift_speed;

    const double zoom_speed = 1.0;
    if (keys[SDL_SCANCODE_W])       input.dz += zoom_speed;
    if (keys[SDL_SCANCODE_S])       input.dz -= zoom_speed;

    return input;
}
