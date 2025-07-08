package main

import rl "vendor:raylib"

amadaa_intro_input :: proc(state: ^AmadaaIntroState) {

}

amadaa_intro_update :: proc(state: ^AmadaaIntroState) -> bool {
    switch state.step {
    case .FADE_IN_MSG1:
        state.msg1_counter += 3
        if state.msg1_counter > 0 && state.msg1_counter <= 255 {
            c := u8(state.msg1_counter)
            state.msg1_color = {c, c, c, 255}
        }
        if state.msg1_counter > 255 do state.step = .FADE_IN_MSG2
    case .FADE_IN_MSG2:
        state.msg2_counter += 3
        if state.msg2_counter > 0 && state.msg2_counter < 255 {
            c := u8(state.msg2_counter)
            state.msg2_color = {c, c, c, 255}
        }
        if state.msg2_counter > 255 do state.step = .ZOOM_IN_LOGO

    case .ZOOM_IN_LOGO:
        state.logo_zoom *= 1.07
        if state.logo_zoom > 1 {
            state.logo_zoom = 1
            state.step = .FADE_OUT
        }
    case .FADE_OUT:
        if state.fade_counter <= 0 {
            state.fade_counter += 5
        } else if state.fade_counter > 0 && state.fade_counter <= 255 {
            state.fade_counter *= 1.05
            a := u8(state.fade_counter)
            state.fade_color.a = a
        } 

        if state.fade_counter > 255 {
            state.fade_counter = 255
            state.done = true
        }
    }

    return state.done
}

amadaa_intro_draw :: proc(state: ^AmadaaIntroState) {
    rl.ClearBackground(rl.BLACK)
    iw := f32(state.logo.width)
    ih := f32(state.logo.height)
    ts1 := rl.MeasureTextEx(state.font, "AN", 60, 1)
    ts2 := rl.MeasureTextEx(state.font, "PRODUCTION", 60, 1)
    tx1 := f32(MIDX)
    ty1 := f32(130)
    tx2 := f32(MIDX)
    ty2 := f32(SCREEN_HEIGHT - ts2.y - 130)

    rl.DrawTextPro(state.font, "AN", {tx1, ty1}, {ts1.x/2, 0}, 0, 60, 1, state.msg1_color)
    rl.DrawTextPro(state.font, "PRODUCTION", {tx2, ty2}, {ts2.x/2, 0}, 0, 60, 1, state.msg2_color)
    w := iw * state.logo_zoom
    h := ih * state.logo_zoom
    src := rl.Rectangle{0, 0, iw, ih}
    dest := rl.Rectangle{MIDX, MIDY, w, h}
    origin := rl.Vector2{w/2, h/2}
    rl.DrawTexturePro(state.logo, src, dest, origin, 0, rl.WHITE)
    rl.DrawRectangleV({0, 0}, {SCREEN_WIDTH, SCREEN_HEIGHT}, state.fade_color)
}
