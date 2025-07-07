package main

import rl "vendor:raylib"

title_screen_input :: proc(state: ^TitleScreenState) {

}

title_screen_update :: proc(state: ^TitleScreenState) {

}

title_screen_draw :: proc(state: ^TitleScreenState) {
    rl.ClearBackground(rl.WHITE)
    rl.DrawTexture(state.logo, 0, 0, rl.WHITE)
}
