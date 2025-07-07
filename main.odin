package main

import rl "vendor:raylib"

SCREEN_WIDTH :: 1024
SCREEN_HEIGHT :: 768
WINDOW_TITLE :: "Open Source Zongo"

MIDX :: SCREEN_WIDTH/2
MIDY :: SCREEN_HEIGHT/2

AmadaaIntroState :: struct {
    logo: rl.Texture,
    height: i32,
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

    osz_logo := rl.LoadTexture("osz-logo.png")
    amadaa_logo := rl.LoadTexture("amadaa-logo.png")

    amadaa_intro := AmadaaIntroState{}
    amadaa_intro.logo = amadaa_logo
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

    rl.UnloadTexture(osz_logo)
    rl.UnloadTexture(amadaa_logo)
    rl.CloseWindow()
}


