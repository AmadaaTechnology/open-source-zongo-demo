package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

title_screen_input :: proc(state: ^TitleScreenState) {

}

title_screen_update :: proc(state: ^TitleScreenState) {
    switch state.step {
    case .SETUP:
        osz_title_setup(state)
    case .TITLE:
        osz_title_update(state)
    case .MISSION:
        osz_mission_update(state)
    case .VISION:

    case .TEARDOWN:
        osz_title_teardown(state)
    }
}

osz_title_setup :: proc(state: ^TitleScreenState) {
    s: cstring = "We are on a mission to bridge the digital literacy gap in Zongo Communities."
    tw := rl.MeasureTextEx(state.font, s, 40, 1) 
    image := rl.GenImageColor(i32(tw.x), i32(tw.y), rl.BLANK)
    rl.ImageDrawTextEx(&image, state.font, s, {0, 0}, 40, 1, rl.BLACK)
    state.mission_texture = rl.LoadTextureFromImage(image)
    rl.UnloadImage(image)
    state.mission_amp = 50
    state.mission_tint = {255, 255, 255, 0}
    state.step = .TITLE
}

osz_title_teardown :: proc(state: ^TitleScreenState) {
    rl.UnloadTexture(state.mission_texture)
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

    if done do state.step = .MISSION
}

osz_mission_update :: proc(state: ^TitleScreenState) {
    if state.mission_tint != {255, 255, 255, 255} do state.mission_tint += {0, 0, 0, 1}

    state.mission_angle += 1
    state.mission_amp -= 0.05
    if state.mission_amp < 0 do state.mission_amp = 0

    if state.mission_amp == 0 do state.step = .VISION
}

title_screen_draw :: proc(state: ^TitleScreenState) {
    rl.ClearBackground(rl.WHITE)

    for i := 0; i < len(state.particles); i += 1 {
        rl.DrawPixelV(state.particles[i].pos, state.particles[i].color)    
    }

    if state.step >= .MISSION {
        for i in 0..<state.mission_texture.width {
            src := rl.Rectangle{f32(i), 0, 1, f32(state.mission_texture.height)}
            y := MIDY+100 + state.mission_amp * math.sin((state.mission_angle+f32(i))*rl.DEG2RAD)
            dest := rl.Vector2{MIDX-f32(state.mission_texture.width/2) + f32(i), y}
            rl.DrawTextureRec(state.mission_texture, src, dest, state.mission_tint)
        } 
    }
}
