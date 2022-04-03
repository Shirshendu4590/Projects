--[[This is Pong using Lua in Love.2d
Added Custom Font from font.ttf file]]

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
    -- Filter to make clear graphics
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- more "retro-looking" font object we can use for any text
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- set LÖVE2D's active font to the smallFont obect
    love.graphics.setFont(smallFont)
    
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
    -- love.graphics.printf("Pong By Shishu", 0, VIRTUAL_HEIGHT/2 - 4, VIRTUAL_WIDTH, 'center')

    -- clear the screen with a specific color; in this case, a color similar
    -- to some versions of the original Pong
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.printf("Pong By Shishu", 0, 10, VIRTUAL_WIDTH, 'center')
    
    -- adding paddle and ball
    love.graphics.rectangle('fill', 10, 10, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2, 5, 5)
    
    -- end push
    push:apply('end')
end