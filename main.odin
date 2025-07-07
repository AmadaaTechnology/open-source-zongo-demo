package main

import rl "vendor:raylib"

SCREEN_WIDTH :: 1024
SCREEN_HEIGHT :: 768
WINDOW_TITLE :: "Open Source Zongo"

MIDX :: SCREEN_WIDTH/2
MIDY :: SCREEN_HEIGHT/2

AmadaaIntroState :: struct {
    initialized: bool,
    logo: rl.Texture,
    done: bool,
}

TitleScreenState :: struct {
    initialized: bool,
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

    state: DemoState = AmadaaIntroState{} 

    for !rl.WindowShouldClose() {
        switch &s in state {
        case AmadaaIntroState:
            if !s.initialized {
                s.logo = amadaa_logo
                s.initialized = true
            }

            amadaa_intro_input(&s)
            amadaa_intro_update(&s)

        case TitleScreenState:
            if !s.initialized {
                s.logo = osz_logo
                s.initialized = true
            }

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


