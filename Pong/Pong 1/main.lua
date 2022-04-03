--[[This is Pong using Lua in Love.2d
Added Keyboard escape button and push libray to create retro visual asthetic]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic

--https://github.com/Ulydev/push

push = require 'push'

-- Window Dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtul Window Dimensions
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Initial Game window render
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })
end


-- Function to check current pressed button stored in key 
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- Intial graphics render inside Game window
function love.draw()
    -- this one prints in original window resolution
    -- love.graphics.printf("Pong By Shishu", 0, WINDOW_HEIGHT/2 - 4, WINDOW_WIDTH, 'center')
    
    -- start push 
    push:apply('start')
    
    -- love.graphics.printf("Pong By Shishu", 0, WINDOW_HEIGHT/4 - 4, WINDOW_WIDTH/4, 'center')
    love.graphics.printf("Pong By Shishu", 0, VIRTUAL_HEIGHT/2 - 4, VIRTUAL_WIDTH, 'center')
    
    -- end push
    push:apply('end')
end