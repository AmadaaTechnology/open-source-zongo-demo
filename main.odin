package main

import rl "vendor:raylib"

SCREEN_WIDTH :: 1024
SCREEN_HEIGHT :: 768
WINDOW_TITLE :: "Open Source Zongo"

MIDX :: SCREEN_WIDTH/2
MIDY :: SCREEN_HEIGHT/2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, WINDOW_TITLE)
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}