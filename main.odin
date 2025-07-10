package main

import "core:fmt"
import rl "vendor:raylib"

SCREEN_WIDTH :: 1024
SCREEN_HEIGHT :: 768
WINDOW_TITLE :: "Open Source Zongo"

MIDX :: SCREEN_WIDTH/2
MIDY :: SCREEN_HEIGHT/2

AmadaaIntroSteps :: enum {
    FADE_IN_MSG1,
    FADE_IN_MSG2,
    ZOOM_IN_LOGO,
    BOTTOM_MESSAGES,
    FINAL_COUNTER,
    FADE_OUT,
}

AmadaaIntroState :: struct {
    step: AmadaaIntroSteps,
    ghana_flag_map: rl.Texture,
    ghana_flag_map_rot: f32,
    logo: rl.Texture,
    odin_logo: rl.Texture,
    raylib_logo: rl.Texture,
    logo_zoom: f32,
    fade_counter: f32,
    fade_color: rl.Color,
    font: rl.Font,
    msg1_counter: i32,
    msg2_counter: i32,
    msg1_color: rl.Color,
    msg2_color: rl.Color,
    bottom_msg_index: i32,
    bottom_msg_counter: i32,
    bottom_msg: cstring,
    bottom_msg_dir: i32,
    final_counter: i32,
    done: bool,
}

TitleScreenSteps :: enum {
    SETUP,
    TITLE,
    MISSION,
    TEARDOWN,
}

TitleScreenState :: struct {
    step: TitleScreenSteps,
    particles: [dynamic]Particle,
    font: rl.Font,
    mission_texture: rl.Texture,
}

DemoState :: union {
    AmadaaIntroState,
    TitleScreenState,
}

Particle :: struct {
    pos: rl.Vector2,
    color: rl.Color,
    dest_color: rl.Color,
    v: rl.Vector2,
    dest: rl.Vector2,
    counter: i32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, WINDOW_TITLE)
    rl.SetTargetFPS(60)
    rl.InitAudioDevice()

    osz_logo := rl.LoadImage("res/osz-logo.png")
    amadaa_logo := rl.LoadTexture("res/amadaa-logo.png")
    ghana_flag_map := rl.LoadTexture("res/ghana-flag-map.png")
    odin_logo := rl.LoadTexture("res/odin-logo.png")
    raylib_logo := rl.LoadTexture("res/raylib-logo.png")
    friendly_sans := rl.LoadFontEx("res/FriendlySans.ttf", 60, nil, 0)
    league_gothic := rl.LoadFontEx("res/LeagueGothic-Regular.ttf", 72, nil, 0)
    music := rl.LoadMusicStream("res/ootd-upbeat-summer-house.mp3")
    rl.PlayMusicStream(music)

    amadaa_intro := AmadaaIntroState{}
    amadaa_intro.logo = amadaa_logo
    amadaa_intro.odin_logo = odin_logo
    amadaa_intro.raylib_logo = raylib_logo
    amadaa_intro.ghana_flag_map = ghana_flag_map
    amadaa_intro.logo_zoom = 0.01
    amadaa_intro.font = friendly_sans
    amadaa_intro.msg1_counter = -20
    amadaa_intro.msg2_counter = -20
    amadaa_intro.fade_counter = -100
    amadaa_intro.fade_color = {255, 255, 255, 0}
    state: DemoState = amadaa_intro
   
    title_screen := TitleScreenState{}
    colors := rl.LoadImageColors(osz_logo)
    title_screen.font = league_gothic
    oszw := osz_logo.width
    oszh := osz_logo.height
    for i: i32 = 0; i < osz_logo.width * osz_logo.height; i += 1 {
        p := Particle{}
        p.pos.x = f32(rl.GetRandomValue(0, SCREEN_WIDTH))
        p.pos.y = f32(rl.GetRandomValue(0, SCREEN_HEIGHT))
        p.color = rl.WHITE
        p.dest_color = colors[i]
        p.v.x = f32(rl.GetRandomValue(-5, 5)) 
        if p.v.x == 0 do p.v.x = 10
        p.v.y = f32(rl.GetRandomValue(-5, 5))
        if p.v.y == 0 do p.v.x = -10
        p.counter = rl.GetRandomValue(300, 500)
        p.dest.x = f32(i % oszw) + MIDX - f32(oszw/2)
        p.dest.y = 100 + f32(i / oszw)
        append(&title_screen.particles, p)
    }

    for !rl.WindowShouldClose() {
        rl.UpdateMusicStream(music)
        switch &s in state {
        case AmadaaIntroState:
            amadaa_intro_input(&s)
            if amadaa_intro_update(&s) {
                state = title_screen
            }

        case TitleScreenState:
            title_screen_input(&s)
            title_screen_update(&s)
        }

        rl.BeginDrawing()
        switch &s in state {
        case AmadaaIntroState:
            amadaa_intro_draw(&s)

        case TitleScreenState:
            title_screen_draw(&s)
        }

        rl.EndDrawing()
    }

    rl.StopMusicStream(music)
    rl.CloseAudioDevice()
    rl.UnloadFont(friendly_sans)
    rl.UnloadFont(league_gothic)
    rl.UnloadImage(osz_logo)
    rl.UnloadTexture(amadaa_logo)
    rl.UnloadTexture(ghana_flag_map)
    rl.UnloadMusicStream(music)
    rl.CloseWindow()
}


