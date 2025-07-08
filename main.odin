package main

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
    FINAL_COUNTER,
    FADE_OUT,
}

AmadaaIntroState :: struct {
    step: AmadaaIntroSteps,
    ghana_flag_map: rl.Texture,
    ghana_flag_map_rot: f32,
    logo: rl.Texture,
    logo_zoom: f32,
    fade_counter: f32,
    fade_color: rl.Color,
    font: rl.Font,
    msg1_counter: i32,
    msg2_counter: i32,
    msg1_color: rl.Color,
    msg2_color: rl.Color,
    final_counter: i32,
    done: bool,
}

TitleScreenState :: struct {
    logo: rl.Texture,
}

DemoState :: union {
    AmadaaIntroState,
    TitleScreenState,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, WINDOW_TITLE)
    rl.SetTargetFPS(60)

    osz_logo := rl.LoadTexture("res/osz-logo.png")
    amadaa_logo := rl.LoadTexture("res/amadaa-logo.png")
    ghana_flag_map := rl.LoadTexture("res/ghana-flag-map.png")
    friendly_sans := rl.LoadFontEx("res/FriendlySans.ttf", 60, nil, 0)

    amadaa_intro := AmadaaIntroState{}
    amadaa_intro.logo = amadaa_logo
    amadaa_intro.ghana_flag_map = ghana_flag_map
    amadaa_intro.logo_zoom = 0.01
    amadaa_intro.font = friendly_sans
    amadaa_intro.msg1_counter = -20
    amadaa_intro.msg2_counter = -20
    amadaa_intro.fade_counter = -100
    amadaa_intro.fade_color = {255, 255, 255, 0}
    state: DemoState = amadaa_intro
   
    for !rl.WindowShouldClose() {
        switch &s in state {
        case AmadaaIntroState:
            amadaa_intro_input(&s)
            if amadaa_intro_update(&s) {
                title_screen := TitleScreenState{}
                title_screen.logo = osz_logo
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

    rl.UnloadFont(friendly_sans)
    rl.UnloadTexture(osz_logo)
    rl.UnloadTexture(amadaa_logo)
    rl.UnloadTexture(ghana_flag_map)
    rl.CloseWindow()
}


