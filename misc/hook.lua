local league_length = 10

local basegame_get_new_boss = get_new_boss
function get_new_boss(blind)
	-- TODO: Special blind for ante < 1?
	if not pkrm_gym_config.setting_only_gym or G.GAME.round_resets.ante < 1 then
		return basegame_get_new_boss()
	end

	-- Get new league and set up winning ante
	if not G.GAME.pkrm_league then
		G.GAME.pkrm_league = generate_league()
		G.GAME.win_ante = 10
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

	return selected_boss
end

-- Override for Elite Four blinds at ante 9 and 10
local basegame_reset_blinds = reset_blinds
function reset_blinds()
	basegame_reset_blinds()

	if pkrm_gym_config.setting_only_gym then
		local league_index = G.GAME.round_resets.ante % league_length

		if league_index == 9 then
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

local base_game_end_round = end_round
function end_round()
	-- Save the status to recover them later
	-- Elite 4 isn't skippable and does not give tag
	-- G.GAME.current_round.voucher = SMODS.get_next_vouchers()
	local boss_status = G.GAME.round_resets.blind_states.Boss
	local abilities_played_this_ante = {}
	for k, v in ipairs(G.playing_cards) do
		abilities_played_this_ante[k] = v.ability.played_this_ante
	end

	base_game_end_round()

	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			G.E_MANAGER:add_event(Event({
				trigger = 'immediate',
				func = function()
					if G.GAME.round_resets.blind_type_override and G.GAME.round_resets.blind_type_override[G.GAME.blind_on_deck] then
						G.GAME.round_resets.blind_states[G.GAME.blind_on_deck] = 'Defeated'

						-- Revert changes made by base game
						G.GAME.round_resets.blind_states.Boss = boss_status
						for k, v in ipairs(G.playing_cards) do
							v.ability.played_this_ante = abilities_played_this_ante[k]
						end
					end
				
					return true
				end
			}))
			return true
		end
	}))

end

local basegame_blind_get_type = Blind.get_type
function Blind:get_type()
	local valid_types = { Small = true, Big = true, Boss = true }

	-- sendTraceMessage(G.GAME.blind_on_deck, "Check type blind 2")

	if G.GAME.round_resets.blind_type_override and G.GAME.round_resets.blind_type_override[G.GAME.blind_on_deck] then
		return G.GAME.blind_on_deck
	end

	return basegame_blind_get_type(self)
end

-- Change ante stuffs
-- TODO: Work with SMODS.get_blind_amount
local basegame_get_blind_amount = get_blind_amount
function get_blind_amount(ante)
	if pkrm_gym_config.setting_reduce_scaling and (ante == 9 or ante == 10) then
		if not G.GAME.modifiers.scaling or G.GAME.modifiers.scaling == 1 then
			local amounts = { 100000, 250000 }
			return amounts[ante - 8]
		elseif G.GAME.modifiers.scaling == 2 then
			local amounts = { 200000, 500000 }
			return amounts[ante - 8]
		elseif G.GAME.modifiers.scaling == 3 then
			local amounts = { 500000, 1000000 }
			return amounts[ante - 8]
		end
	end

	return basegame_get_blind_amount(ante)
end
