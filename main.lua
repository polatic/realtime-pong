Class = require 'libs.class'
require 'libs.LUBE'
require 'background'
require 'ball'
require 'constants'
require 'paddle_1'
require 'paddle_2'
require 'pause'
require 'interaction'
require 'libs.utils'

local conn
local cron = require 'libs.cron'
local game_status = 0
local startup_text =  "Open http://www.pongmob.com\n\nFrom your smartphone browser\n"

current_player = {}
-- current_player = {"hula", "helo"}
winner = startup_text


local function clientRecv(data)
    if data then
        print("Input: " .. tostring(data))
        t = {}

        for k, v in string.gmatch(data, "(%w+)") do
            table.insert(t, k)
        end

        if data == "TCPCLIENTOK" then
            print("[Connection] Billboard and Server Website connected " ..
                  "successfully!")
        end

        if #t > 2 then
            if t[1] == "j" then
                if t[2] == "1" then
                    for key,value in pairs(t) do
                        if key > 2 then
                            player_1_identity = player_1_identity .. " " .. titlecase(value)
                        end
                    end

                    table.insert(current_player, player_1_identity)
                    print("Player 1 joined : " .. player_1_identity)
                    winner = ""

                elseif t[2] == "2" then
                    for key,value in pairs(t) do
                        if key > 2 then
                            player_2_identity = player_2_identity .. " " .. titlecase(value)
                        end
                    end

                    table.insert(current_player, player_2_identity)
                    print("Player 2 joined : " .. player_2_identity)
                    initialize_ball()
                else
                    print("Data can't processed : " .. data)
                end
            end
        elseif #t == 2 then
            if t[1] == "p1" and t[2] == "1" then
                dest_1_y = paddle_1_y - (screen_height / 3)
            elseif t[1] == "p1" and t[2] == "2" then
                dest_1_y = paddle_1_y + (screen_height / 3)
            elseif t[1] == "p2" and t[2] == "1" then
                dest_2_y = paddle_2_y - (screen_height / 3) 
            elseif t[1] == "p2" and t[2] == "2" then
                dest_2_y = paddle_2_y + (screen_height / 3)
            else
                print("This data not processed : " .. tostring(data))
            end
        end
    end
end

local function prepareNetwork(args)
    conn = lube.tcpClient()

    -- ping server
    conn.handshake = "TCPCLIENTBILLBOARD"
    server_port = 4005
    assert(conn:connect("127.0.0.1", server_port, true))
    -- assert(conn:connect("122.248.232.186", server_port, true))
    print("[Connection] Building TCP connection with Server on port " ..
           tostring(server_port) .. " ...")

    conn.callbacks.recv = clientRecv
end

function love.load()
    initialize_paddle_1()
    initialize_paddle_2()
    initialize_interaction()
    initialize_ball()

    state = 'pause'

    love.graphics.setCaption('PONG!')
    love.graphics.setMode(screen_width, screen_height)

    prepareNetwork()

    initTime = love.timer.getTime()
    displayString = true

    -- set fonts
    local font = love.graphics.newFont("font.ttf", 38)
    love.graphics.setFont(font)

    bg = love.graphics.newImage("bg.jpg")

end


function love.update(dt)
    -- update tcp client
    conn:update(dt)
    cron.update(dt)

    update_interaction(dt)
    update_paddle_1(dt)
    update_paddle_2(dt)
    update_ball(dt)

    if state ~= 'play' then
        game_status = 0
        return
    else
        game_status = 1

        -- if(player_1_score == 0) then
        --     cron.after(2, function() 
        --        player_1_score = 10
        --     end)
        -- end

        -- reset game if one of player became winnner
        if player_1_score > 3 or player_2_score > 3 then
            stop_ball()
            current_player = {}

            if player_1_score > player_2_score then
                winner = "The winner is " .. tostring(player_1_identity)
            else
                winner = "The winner is " .. tostring(player_2_identity)
            end
            initialize_interaction()

            cron.after(3, function()
                initialize_paddle_1()
                initialize_paddle_2()
                winner = startup_text
                print("send game stop " .. tostring(game_status))
                conn:send("g,0")
            end)
        else
            reset_ball_if_offscreen()
            bounce_ball_if_it_hits_top_of_screen()
            bounce_ball_if_it_hits_bottom_of_screen()
            bounce_ball_if_it_hits_paddle_1()
            bounce_ball_if_it_hits_paddle_2()
        end
    end
end

function love.draw()
    set_background()
    draw_paddle_1()
    draw_paddle_2()
    draw_ball()
    draw_interaction()

    love.graphics.print(winner, (screen_width/4), (screen_height / 5))

    if state == 'pause' then
        draw_pause_overlay()
    end
end

function love.keypressed(key)
    if key == 'q' or key == 'escape' then
        love.event.push('q')
    end

    -- set fullscreen toggle using "f"
    if key == "f" then
        love.graphics.toggleFullscreen()
    end

    if key == 'p' then
        if state == 'play' then
            state = 'pause'
        else
            state = 'play'
        end
    end

    if key == 'w' then
        dest_1_y = paddle_1_y - (screen_height / 3)
    end
    if key == 's' then
        dest_1_y = paddle_1_y + (screen_height / 3)
    end

    if key == 'up' then
        dest_2_y = paddle_2_y - (screen_height / 3)
    end
    if key == 'down' then
        dest_2_y = paddle_2_y + (screen_height / 3)
    end

end
