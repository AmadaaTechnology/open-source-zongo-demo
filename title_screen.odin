package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

title_screen_input :: proc(state: ^TitleScreenState) {

}

title_screen_update :: proc(state: ^TitleScreenState) {
    switch state.step {
    case .TITLE:
        osz_title_update(state)
    case .MISSION:
    
    }
}

osz_title_update :: proc(state: ^TitleScreenState) {
    done := true
    for i := 0; i < len(state.particles); i += 1 {
        if state.particles[i].v != {0, 0} do done = false
        state.particles[i].pos += state.particles[i].v
        if state.particles[i].color.r > state.particles[i].dest_color.r do state.particles[i].color.r -= 1
        if state.particles[i].color.g > state.particles[i].dest_color.g do state.particles[i].color.g -= 1
        if state.particles[i].color.b > state.particles[i].dest_color.b do state.particles[i].color.b -= 1
        if state.particles[i].color.a > state.particles[i].dest_color.a do state.particles[i].color.a -= 1
        if state.particles[i].counter > 0 do state.particles[i].counter -= 1

        if state.particles[i].pos.x < 0 {
            state.particles[i].pos.x = 0
            state.particles[i].v.x *= -1
        }

        if state.particles[i].pos.x > SCREEN_WIDTH {
            state.particles[i].pos.x = SCREEN_WIDTH
            state.particles[i].v.x *= -1
        }

        if state.particles[i].pos.y < 0 {
            state.particles[i].pos.y = 0
            state.particles[i].v.y *= -1
        }

        if state.particles[i].pos.y > SCREEN_HEIGHT {
            state.particles[i].pos.y = SCREEN_HEIGHT
            state.particles[i].v.y *= -1
        }

        if state.particles[i].counter <= 0 {
            heading: f32 = math.atan2(
                         state.particles[i].dest.y-state.particles[i].pos.y,
                         state.particles[i].dest.x-state.particles[i].pos.x)
            state.particles[i].v.x = 10.0 * math.cos(heading)
            state.particles[i].v.y = 10.0 * math.sin(heading)
        }

        xp: f32 = math.pow(state.particles[i].pos.x-state.particles[i].dest.x, 2)
        yp: f32 = math.pow(state.particles[i].pos.y-state.particles[i].dest.y, 2)
        d := math.sqrt(xp + yp)
        if d < 10 {
            state.particles[i].pos = state.particles[i].dest
            state.particles[i].v = {0, 0}
        }
    }
}

title_screen_draw :: proc(state: ^TitleScreenState) {
    rl.ClearBackground(rl.WHITE)
    //rl.DrawTexture(state.logo, 0, 0, rl.WHITE)

    for i := 0; i < len(state.particles); i += 1 {
        rl.DrawPixelV(state.particles[i].pos, state.particles[i].color)    
    }
}
