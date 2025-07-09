package main

import "core:math"
import rl "vendor:raylib"

amadaa_intro_input :: proc(state: ^AmadaaIntroState) {
    if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) && state.step != .FADE_OUT {
        state.step = .FADE_OUT
    }
}

amadaa_intro_update :: proc(state: ^AmadaaIntroState) -> bool {
    state.ghana_flag_map_rot += 1

    switch state.step {
    case .FADE_IN_MSG1:
        state.msg1_counter += 3
        if state.msg1_counter > 0 && state.msg1_counter <= 255 {
            c := u8(state.msg1_counter)
            state.msg1_color = {c, c, c, 150}
        }
        if state.msg1_counter > 255 do state.step = .FADE_IN_MSG2
    case .FADE_IN_MSG2:
        state.msg2_counter += 3
        if state.msg2_counter > 0 && state.msg2_counter < 255 {
            c := u8(state.msg2_counter)
            state.msg2_color = {c, c, c, 150}
        }
        if state.msg2_counter > 255 do state.step = .ZOOM_IN_LOGO

    case .ZOOM_IN_LOGO:
        state.logo_zoom *= 1.07
        if state.logo_zoom > 1 {
            state.logo_zoom = 1
            state.step = .BOTTOM_MESSAGES
            state.bottom_msg_index = 1
            state.bottom_msg_dir = 1
        }
    
    case .BOTTOM_MESSAGES:
        state.bottom_msg_counter += state.bottom_msg_dir
        if state.bottom_msg_counter > 400 {
            state.bottom_msg_counter = 400
            state.bottom_msg_dir *= -1
        }

        if state.bottom_msg_counter <= 0 {
            state.bottom_msg_counter = 0
            state.bottom_msg_dir *= -1
            state.bottom_msg_index += 1

            if state.bottom_msg_index > 3 do state.step = .FINAL_COUNTER
        }

    case .FINAL_COUNTER:
        state.final_counter += 1
        if state.final_counter > 1000 do state.step = .FADE_OUT

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

    t := f32(rl.GetTime()) * 0.5

    for i in 0..<15 {
        d := f32(i) * 0.03
        c := u8(15*i)
        iw := f32(state.ghana_flag_map.width)
        ih := f32(state.ghana_flag_map.height)

        x := MIDX + 500 * math.sin(3.0 * (t+d) + math.PI/2)
        y := MIDY + 300 * math.sin(4.0 * (t+d))
        src := rl.Rectangle{0, 0, iw, ih}
        dest := rl.Rectangle{x, y, iw, ih}
        origin := rl.Vector2{iw/2, ih/2}
        rl.DrawTexturePro(state.ghana_flag_map, src, dest, origin, state.ghana_flag_map_rot+f32(i*3), {c, c, c, 255})
    }

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
    rl.DrawTexturePro(state.logo, src, dest, origin, 0, {255, 255, 255, 150})
    rl.DrawRectangleV({0, 0}, {SCREEN_WIDTH, SCREEN_HEIGHT}, state.fade_color)

    text_color := u8(state.bottom_msg_counter > 255 ? 255 : state.bottom_msg_counter)
    switch state.bottom_msg_index {
    case 1:
        tw := rl.MeasureTextEx(state.font, "Coding by Lorenzo Cabrini", 60, 1)
        rl.DrawTextPro(state.font, "Coding by Lorenzo Cabrini", {MIDX-tw.x/2, SCREEN_HEIGHT-70.0}, {0, 0}, 0, 60, 1, {0, text_color, 0, text_color})
    case 2:
        tw := rl.MeasureTextEx(state.font, "Made with Odin + Raylib", 60, 1)
        rl.DrawTextPro(state.font, "Made with Odin + Raylib", {MIDX-tw.x/2, SCREEN_HEIGHT-70.0}, {0, 0}, 0, 60, 1, {0, text_color, 0, 255})
        rl.DrawTextureV(state.odin_logo, {MIDX-tw.x/2 - f32(state.odin_logo.width) - 50, SCREEN_HEIGHT-70}, {text_color, text_color, text_color, text_color})
        rl.DrawTextureV(state.raylib_logo, {MIDX+tw.x/2 + 50, SCREEN_HEIGHT-70}, {text_color, text_color, text_color, text_color})
    case 3:
        tw := rl.MeasureTextEx(state.font, "Click left mouse button to begin", 60, 1)
        rl.DrawTextPro(state.font, "Click left mouse button to begin", {MIDX-tw.x/2, SCREEN_HEIGHT-70.0}, {0, 0}, 0, 60, 1, {0, text_color, 0, text_color})
    }
}
