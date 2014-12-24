vector = require "libs.hump.vector"

systems = {}
current = 1
angle = 0

function initialize_ball()
    ball = {}
    reflection = {30, 35, -10, 20, -30, -35, -20}

    ball.img = love.graphics.newImage("green_ball.png")
    ball.width = ball.img:getWidth()
    ball.height = ball.img:getHeight()
    ball.width = ball.width * (1 + 0.5)
    ball.height= ball.height * (1 + 0.5)

    ball_x = (screen_width / 2) + (ball.width)
    ball_y = (screen_height / 2) + (ball.height)
    ball.position = vector(ball_x, ball_y)
    ball.velocity = vector(-200, 200)

    local p = love.graphics.newParticleSystem(ball.img, 1000)
        p:setEmissionRate(100)
        p:setSpeed(100, 100)
        p:setGravity(0)
        p:setPosition(0, 0)
        p:setParticleLife(0.4)
        p:setSizes(0.8, 0.1)
        p:setSpread(1)
        p:stop()
        table.insert(systems, p)
end

function stop_ball()
    systems = {} 
end

function bounce_ball_if_it_hits_top_of_screen()
    if ball.position.y - ball.height * 0.3 < ball.height then
        ball_temp = ball.velocity:perpendicular()
        ball.velocity.y = math.abs(ball_temp.y)
    end
end

function bounce_ball_if_it_hits_bottom_of_screen()
    if ball.position.y - ball.height * 0.7 > screen_height  then
        ball_temp = ball.velocity:perpendicular()
        ball.velocity.y = -math.abs(ball_temp.y)
    end
end

function bounce_ball_if_it_hits_paddle_1()
    if ball.position.x <= (paddle_1_width + ball.width + 5) and
       ball.position.y >= (paddle_1_y + ball.height) and
       ball.position.y <= (paddle_1_y + paddle_1_height + ball.height)
    then
        -- ball.velocity.x = math.abs(ball.velocity.x)
        rand = math.random(1, 7)
        ball.velocity = ball.velocity:rotated(math.rad(180 + reflection[rand]))
    end
end

function bounce_ball_if_it_hits_paddle_2()
    if (ball.position.x >= (screen_width - paddle_2_width + ball.width * 0.9) and
        ball.position.y >= (paddle_2_y + ball.height) and 
        ball.position.y < (paddle_2_y + paddle_2_height + ball.height))
    then
        rand = math.random(1, 7)
        ball.velocity = ball.velocity:rotated(math.rad(180 + reflection[rand]))
        -- ball.velocity.x = -math.abs(ball.velocity.x)
    end
end

function reset_ball_if_offscreen()
    if ball.position.x - ball.width < 0 or ball.position.x - ball.width  > screen_width then
        -- player 1 lose
        if ball.position.x <  ball.width then
            player_2_score = player_2_score + 1
        end

        -- player 2 lose
        if ball.position.x > screen_width then
            player_1_score = player_1_score + 1
        end

        initialize_ball()
    end
end

function update_ball(dt)
    if(#systems > 0) then
        local delta = vector(0,0)

        if ball.velocity.y < 0 then
            delta.y = -1
        else 
            delta.y = 1
        end

        if ball.velocity.x < 0 then
            delta.x = -1
        else 
            delta.x = 1
        end

        ball.velocity = ball.velocity + delta * 10 * dt

        x1 = ball.position.x
        y1 = ball.position.y

        ball.position = ball.position + ball.velocity * dt

        -- get angle of two points
        ball_angle = math.atan2(ball.position.y - y1, ball.position.x - x1)
        -- print(tostring(ball.position.x) .. "," .. tostring(ball.position.y) .. " " .. tostring(x1) .. "," .. tostring(y1) .. " Angle: " .. tostring(ball_angle))

        systems[current]:setPosition(ball.position:unpack())
        systems[current]:setDirection(math.pi+ball_angle)
        systems[current]:start()

        systems[current]:update(dt)
        angle = ball_angle
    end
end

function draw_ball()
    love.graphics.setColorMode("modulate")
    love.graphics.setBlendMode("additive")
    love.graphics.setColor(255, 255, 255)

    if(#systems > 0) then
        love.graphics.draw(systems[current], 0, 0, 0, 1, 1, ball.width, ball.height)
    end
end
