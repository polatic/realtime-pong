function initialize_paddle_2()
    paddle_2_width = 20
    paddle_2_height = (screen_height / 3)
    paddle_2_x = screen_width - paddle_2_width
    paddle_2_y = (screen_height / 2) -  (paddle_2_height / 2)
    paddle_2_speed = 400
    paddle_2_color = {255, 255, 255}
    player_2_score = 0
    dest_2_y = paddle_2_y
end

function update_paddle_2(dt)
    if paddle_2_y > dest_2_y then
        paddle_2_y = paddle_2_y - (paddle_2_speed * dt)
    end

    if paddle_2_y < dest_2_y then
        paddle_2_y = paddle_2_y + (paddle_2_speed * dt)
    end

    if paddle_2_y < 0 then
        paddle_2_y = 0
    elseif (paddle_2_y + paddle_2_height) > screen_height then
        paddle_2_y = screen_height - paddle_2_height
    end
end

function draw_paddle_2()
    love.graphics.setColor(paddle_2_color)
    love.graphics.rectangle('fill', paddle_2_x, paddle_2_y, paddle_2_width, paddle_2_height)
    love.graphics.print(player_2_score, (screen_width/2) + (screen_width/4),(screen_height / 2))
end
