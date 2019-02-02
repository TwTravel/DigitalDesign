#ifndef __SDL_INPUT_CONTROLLER_H__
#define __SDL_INPUT_CONTROLLER_H__

#include "model/Input.h"

class SdlInputController {
public:
    model::Input getInput();
};

#endif
