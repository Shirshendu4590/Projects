--[[This is Pong using Lua in Love.2d
Game Window and Playing Window Update]]

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })
end

function love.draw()
    love.graphics.printf("Pong By Shishu", 0, WINDOW_HEIGHT/2 - 4, WINDOW_WIDTH, 'center')
end