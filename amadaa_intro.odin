package main

import rl "vendor:raylib"

amadaa_intro_input :: proc(state: ^AmadaaIntroState) {

}

amadaa_intro_update :: proc(state: ^AmadaaIntroState) -> bool {
    state.logo_zoom *= 1.07
    if state.logo_zoom > 1 {
        state.logo_zoom = 1
        state.height += 1
    }

    if state.height > SCREEN_HEIGHT do return true
    return false
}

amadaa_intro_draw :: proc(state: ^AmadaaIntroState) {
    rl.ClearBackground(rl.BLACK)
    iw := f32(state.logo.width)
    ih := f32(state.logo.height)
    w := iw * state.logo_zoom
    h := ih * state.logo_zoom
    src := rl.Rectangle{0, 0, iw, ih}
    dest := rl.Rectangle{MIDX, MIDY, w, h}
    origin := rl.Vector2{w/2, h/2}
    rl.DrawTexturePro(state.logo, src, dest, origin, 0, rl.WHITE)
    rl.DrawRectangle(0, 0, SCREEN_WIDTH, state.height, rl.WHITE)
}
