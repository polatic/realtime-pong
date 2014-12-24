function initialize_interaction() 
	player_1_identity = ""
	player_2_identity = ""
	identity_color = {255, 255, 255}
end

function update_interaction(dt)
	if #current_player == 2 then
		game_status = 1
		state = "play"
	else 
		state = "pause"		
		game_status = 0
	end

	-- set auto play with keyboard
	-- game_status = 1
	-- state = "play"
end

function draw_interaction()
	love.graphics.setColor(identity_color)
	love.graphics.print(player_1_identity, (screen_width / 4), (screen_height / 4))
	love.graphics.print(player_2_identity, (screen_width / 2) + (screen_width / 4),
						(screen_height / 4))
end