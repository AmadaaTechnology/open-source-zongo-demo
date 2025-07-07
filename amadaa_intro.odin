package main

import rl "vendor:raylib"

amadaa_intro_input :: proc(state: ^AmadaaIntroState) {

}

amadaa_intro_update :: proc(state: ^AmadaaIntroState) -> bool {
    state.height += 1
    if state.height > SCREEN_HEIGHT do return true
    return false
}

amadaa_intro_draw :: proc(state: ^AmadaaIntroState) {
    rl.ClearBackground(rl.BLACK)
    rl.DrawTexture(state.logo, MIDX - state.logo.width/2, MIDY - state.logo.width/2, rl.WHITE)
    rl.DrawRectangle(0, 0, SCREEN_WIDTH, state.height, rl.WHITE)
}
