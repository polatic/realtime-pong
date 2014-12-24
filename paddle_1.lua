function initialize_paddle_1()
    paddle_1_width = 20
    paddle_1_height = (screen_height / 3)
    paddle_1_x = 0
    paddle_1_y = (screen_height / 2) -  (paddle_1_height / 2)
    paddle_1_speed = 400
    paddle_1_color = {255, 255, 255}
    player_1_score = 0
    dest_1_y = paddle_1_y    
end

function update_paddle_1(dt)
    if paddle_1_y > dest_1_y then
        paddle_1_y = paddle_1_y - (paddle_1_speed * dt)
    end

    if paddle_1_y < dest_1_y then
        paddle_1_y = paddle_1_y + (paddle_1_speed * dt)
    end

    if paddle_1_y < 0 then
        paddle_1_y = 0
    elseif (paddle_1_y + paddle_1_height) > screen_height then
        paddle_1_y = screen_height - paddle_1_height
    end
end

function draw_paddle_1()
    love.graphics.setColor(paddle_1_color)
    love.graphics.rectangle('fill', paddle_1_x, paddle_1_y, paddle_1_width, paddle_1_height)
    love.graphics.print(player_1_score, (screen_width/ 4),(screen_height / 2))
end
