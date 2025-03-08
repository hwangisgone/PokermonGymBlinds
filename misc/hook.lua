local league_length = 10

local _get_new_boss = get_new_boss
function get_new_boss(blind)
	if not pkrm_gym_config.setting_only_gym or G.GAME.round_resets.ante < 1 then
		return _get_new_boss()
	end

	-- Get new league
	if not G.GAME.pkrm_league then
		G.GAME.pkrm_league = generate_league()
	end

	local league_index = G.GAME.round_resets.ante % league_length

	if league_index == 9 then
		-- Elite four
		if blind == 'big' then
			selected_boss = G.GAME.pkrm_league.e4[1]
		else
			selected_boss = G.GAME.pkrm_league.e4[2]
		end
	elseif league_index == 0 then
		-- Elite four & champion
		if blind == 'small' then
			selected_boss = G.GAME.pkrm_league.e4[3]
		elseif blind == 'big' then
			selected_boss = G.GAME.pkrm_league.e4[4]
		else
			selected_boss = G.GAME.pkrm_league.champion
		end
	else
		selected_boss = G.GAME.pkrm_league.gym[league_index]
	end

	-- Reset league
	if league_index == 0 then
		G.GAME.league = nil
	end

	-- sendTraceMessage("Getting new boss", "AAAAAAAAAAAA")

	return selected_boss
end

local _reset_blinds = reset_blinds
function reset_blinds()
	_reset_blinds()

	if pkrm_gym_config.setting_only_gym then 
		local league_index = G.GAME.round_resets.ante % league_length

		if league_index == 9 then
			-- G.GAME.round_resets.blind_choices.Small = 'bl_small'
			G.GAME.round_resets.blind_type_override = { Big = true }

			G.GAME.round_resets.blind_tags.Big = nil
			G.GAME.round_resets.blind_choices.Big = get_new_boss('big')
		elseif league_index == 0 then
			G.GAME.round_resets.blind_type_override = { Big = true, Small = true }

			G.GAME.round_resets.blind_tags.Small = nil
			G.GAME.round_resets.blind_choices.Small = get_new_boss('small')
			
			G.GAME.round_resets.blind_tags.Big = nil
			G.GAME.round_resets.blind_choices.Big = get_new_boss('big')
		else
			-- Reset to normal
			G.GAME.round_resets.blind_type_override = nil
			G.GAME.round_resets.blind_choices.Small = 'bl_small'
			G.GAME.round_resets.blind_choices.Big = 'bl_big'
		end
	end
end

local _blind_get_type = Blind.get_type
function Blind:get_type()
	local valid_types = { Small = true, Big = true, Boss = true }

	-- sendTraceMessage(G.GAME.blind_on_deck, "Check type blind 2")

	if G.GAME.round_resets.blind_type_override and G.GAME.round_resets.blind_type_override[G.GAME.blind_on_deck] then 
		return G.GAME.blind_on_deck
	end

	return _blind_get_type(self)
end