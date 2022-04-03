--[[This is Pong using Lua in Love.2d
Ball Movement Update and boundary Restriction update on paddles]]

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

-- Paddle Speed
PADDLE_SPEED = 200

-- initialize score variables, used for rendering on the screen and keeping
-- track of the winner
player1Score = 0
player2Score = 0

-- paddle positions on the Y axis (they can only move up or down)
player1Y = 10
player2Y = VIRTUAL_HEIGHT - 30
player1X = 10
player2X = VIRTUAL_WIDTH - 10
playerWidth = 5 
playerHeight = 20

-- Initial Game window render
function love.load()
    -- Filter to make clear graphics
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- provide randomness to random function calls
    math.randomseed(os.time())
    
    -- more "retro-looking" font object we can use for any text
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- larger font for drawing the score on the screen
    scoreFont = love.graphics.newFont('font.ttf', 20)
    mainMFont = love.graphics.newFont('font.ttf', 40)
    -- set LÖVE2D's active font to the smallFont obect
    love.graphics.setFont(smallFont)

        
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = false
    })

    -- velocity and position variables for our ball when play starts
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2
    ballSize = 5

    -- math.random returns a random value between the left and right number
    -- ballDX will either be 100 or -100
    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50)

    -- sound addition
    sound = {
        ['paddle'] = love.audio.newSource('Sounds/paddle.wav','static'),
        ['Score'] = love.audio.newSource('Sounds/Score.wav','static')
    }

    -- game state variable used to transition between different parts of the game
    -- (used for beginning, menus, main game, high score list, etc.)
    -- we will use this to determine behavior during render and update
    gameState = 'start'
end

function love.update(dt)
        -- player 1 movement
        if love.keyboard.isDown('w') then
            -- add negative paddle speed to current Y scaled by deltaTime
            player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
        elseif love.keyboard.isDown('s') then
            -- add positive paddle speed to current Y scaled by deltaTime
            player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
        end
    
        -- player 2 movement
        if love.keyboard.isDown('up') then
            -- add negative paddle speed to current Y scaled by deltaTime
            player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
        elseif love.keyboard.isDown('down') then
            -- add positive paddle speed to current Y scaled by deltaTime
            player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
        end
        -- ball velocity update
        if gameState == 'start' then
            player1Score = 0
            player2Score = 0
        end
        
        -- scale the velocity by dt so movement is framerate-independent
        if gameState == "play" then 
            ballX = ballX + ballDX * dt
            ballY = ballY + ballDY * dt
            collide = true
            --check collision player 1
            if ballX > player1X + playerWidth or player1X > ballX + ballSize then 
                collide = false
            end
            if ballY > player1Y + playerHeight or player1Y > ballY + ballSize then 
                collide = false
            end
            if collide then
                ballDX = - ballDX * 1.03
                ballX = player1X + 5 
                sound['paddle']:play()
                collide = false
            end
            --check collision player 2
            collide = true
            if ballX > player2X + playerWidth or player2X > ballX + ballSize then 
                collide = false
            end
            if ballY > player2Y + playerHeight or player2Y > ballY + ballSize then 
                collide = false
            end
            if collide then
                ballDX = - ballDX * 1.03
                ballX = player2X - 5
                sound['paddle']:play()
                collide = false
            end
            if ballY + ballSize > VIRTUAL_HEIGHT then 
                ballDY = - ballDY
                ballY = VIRTUAL_HEIGHT - 5
                sound['paddle']:play()
            end
            if ballY < 0 then 
                ballDY = - ballDY
                ballY = 5
                sound['paddle']:play()
            end
            if ballX < 0 then 
                ballDX = math.random(2) == 1 and 100 or -100
                ballDY = math.random(-50, 50)
                ballX = VIRTUAL_WIDTH / 2 - 2
                ballY = VIRTUAL_HEIGHT / 2 - 2
                player2Score = player2Score + 1
                sound['Score']:play()
            end
    
            if ballX + ballSize > VIRTUAL_WIDTH then 
                ballDX = math.random(2) == 1 and 100 or -100
                ballDY = math.random(-50, 50)
                ballX = VIRTUAL_WIDTH / 2 - 2
                ballY = VIRTUAL_HEIGHT / 2 - 2
                player1Score = player1Score + 1
                sound['Score']:play()
            end
            if player1Score == 7 or player2Score == 7 then
                gameState = 'end'
            end
            if gameState == 'end' then
                ballDX = 0
                ballDY = 0
            end
        end

    end
    -- function collision(ballX, ballY)

-- Function to check current pressed button stored in key 
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then 
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'end' then
            -- Restart the game
            gameState = 'start'

            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5

        end
    end
end

-- Intial graphics render inside Game window
function love.draw()
    -- this one prints in original window resolution
    -- love.graphics.printf("Pong By Shishu", 0, WINDOW_HEIGHT/2 - 4, WINDOW_WIDTH, 'center')
    
    -- start push 
    push:apply('start')
    if gameState == 'start' then
        love.graphics.clear(40/255, 45/255, 52/255, 255/255)
        love.graphics.setFont(mainMFont)
        love.graphics.printf("Pong By Shishu", 0, VIRTUAL_HEIGHT/2 - 30, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter To Start", 0, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        love.graphics.printf("Pong By Shishu", 0, 10, VIRTUAL_WIDTH, 'center')
        -- clear the screen with a specific color; in this case, a color similar
        -- to some versions of the original Pong
        love.graphics.clear(40/255, 45/255, 52/255, 255/255)

        love.graphics.setFont(smallFont)
        love.graphics.printf("Pong By Shishu", 0, 10, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 20)
        love.graphics.print(tostring(player2Score),VIRTUAL_WIDTH / 2 + 50, 20)
            
        -- adding paddle and ball 
            
        --left paddle
        love.graphics.rectangle('fill', player1X, player1Y, playerWidth, playerHeight)
            
        --right paddle
        love.graphics.rectangle('fill', player2X, player2Y, playerWidth, playerHeight)
            
        --ze ball
        love.graphics.rectangle('fill', ballX, ballY, ballSize, ballSize)
    elseif gameState == 'end' then
        love.graphics.setFont(smallFont)
        love.graphics.printf("Pong By Shishu", 0, 10, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(scoreFont)
        love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 20)
        love.graphics.print(tostring(player2Score),VIRTUAL_WIDTH / 2 + 50, 20)
            
        -- adding paddle and ball 
            
        --left paddle
        love.graphics.rectangle('fill', player1X, player1Y, playerWidth, playerHeight)
            
        --right paddle
        love.graphics.rectangle('fill', player2X, player2Y, playerWidth, playerHeight)
            
        --ze ball
        love.graphics.rectangle('fill', ballX, ballY, ballSize, ballSize)
        -- Game END
        love.graphics.setFont(mainMFont)
        love.graphics.printf("END", 0, VIRTUAL_HEIGHT/2 - 30, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf("Press Enter To Return To Main Menu", 0, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH, 'center')

    end

    -- end push
    push:apply('end')
end