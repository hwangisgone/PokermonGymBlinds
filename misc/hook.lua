-- Loading pool-related functions
local chunk, load_error = SMODS.load_file('misc/blind_pool.lua')
if load_error then
	sendDebugMessage('The error is: ' .. load_error)
else
	chunk()
end

local league_length = 10

-- Boss configuration table for each win ante cases
local boss_configs = {
	-- Default, win_ante = 10
	[10] = {
		[9] = {
			big = { 'e4', 1 },
			boss = { 'e4', 2 },
		},
		[10] = {
			small = { 'e4', 3 },
			big = { 'e4', 4 },
			boss = { 'champion' },
		},
	},
	[11] = {
		[9] = {
			big = { 'e4', 1 },
			boss = { 'e4', 2 },
		},
		[10] = {
			big = { 'e4', 3 },
			boss = { 'e4', 4 },
		},
		[11] = { boss = { 'champion' } },
	},
	[12] = {
		[9] = { boss = { 'e4', 1 } },
		[10] = { boss = { 'e4', 2 } },
		[11] = { boss = { 'e4', 3 } },
		[12] = {
			big = { 'e4', 4 },
			boss = { 'champion' },
		},
	},
	[13] = {
		[9] = { boss = { 'e4', 1 } },
		[10] = { boss = { 'e4', 2 } },
		[11] = { boss = { 'e4', 3 } },
		[12] = { boss = { 'e4', 4 } },
		[13] = { boss = { 'champion' } },
	},
}

local basegame_get_new_boss = get_new_boss
function get_new_boss(blind)
	-- TODO: Special blind for ante < 1?
	if G.GAME.round_resets.ante < 1 then return basegame_get_new_boss() end

	print(pkrm_gym_config.setting_pokermon_league)

	-- Setting or Challenge
	if pkrm_gym_config.setting_pokermon_league or G.GAME.modifiers.pkrm_gym_forced_region then
		local win_ante = G.GAME.win_ante
		local gym_index = (G.GAME.round_resets.ante - 1) % win_ante + 1

		local selected_boss

		if gym_index >= 9 then
			-- Elite Four & Champion
			local ante_config = boss_configs[win_ante][gym_index] or boss_configs[10][gym_index]
			local current_boss_config = ante_config[blind] or ante_config.boss

			selected_boss = get_gym_boss(current_boss_config[1], current_boss_config[2])
		else
			selected_boss = get_gym_boss('gym', gym_index)
		end

		G.GAME.bosses_used[selected_boss] = G.GAME.bosses_used[selected_boss] + 1

		return selected_boss
	else
		if pkrm_gym_config.setting_only_gym then
			for k, v in pairs(G.P_BLINDS) do
				if not pkrm_gym.TRAINER_CLASS[k] and not G.GAME.banned_keys[k] then G.GAME.banned_keys[k] = true end
			end
		end

		return basegame_get_new_boss()
	end
end

-- Override for Elite Four blinds at ante 9 and 10
local basegame_reset_blinds = reset_blinds
function reset_blinds()
	local boss_defeated = G.GAME.round_resets.blind_states.Boss == 'Defeated'

	basegame_reset_blinds()

	if not boss_defeated then return end

	if pkrm_gym_config.setting_pokermon_league then
		local win_ante = G.GAME.win_ante
		local gym_index = (G.GAME.round_resets.ante - 1) % win_ante + 1

		if gym_index >= 9 then
			-- Handle generating bosses in place of Small, Big Blinds
			local ante_config = boss_configs[win_ante][gym_index] or boss_configs[10][gym_index]

			G.GAME.round_resets.blind_type_override = {}

			if ante_config.big then
				G.GAME.round_resets.blind_type_override.Big = true
				G.GAME.round_resets.blind_tags.Big = nil
				G.GAME.round_resets.blind_choices.Big = get_new_boss('big')
			end

			if ante_config.small then
				G.GAME.round_resets.blind_type_override.Small = true
				G.GAME.round_resets.blind_tags.Small = nil
				G.GAME.round_resets.blind_choices.Small = get_new_boss('small')
			end
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

	G.E_MANAGER:add_event(Event {
		trigger = 'immediate',
		func = function()
			G.E_MANAGER:add_event(Event {
				trigger = 'immediate',
				func = function()
					-- If current blind is an Elite Four (Boss)
					if
						G.GAME.round_resets.blind_type_override
						and G.GAME.round_resets.blind_type_override[G.GAME.blind_on_deck]
					then
						G.GAME.round_resets.blind_states[G.GAME.blind_on_deck] = 'Defeated'

						-- Revert changes made by base game (if Showdown/Boss is Defeated then it won't go new ante)
						G.GAME.round_resets.blind_states.Boss = boss_status
						for k, v in ipairs(G.playing_cards) do
							v.ability.played_this_ante = abilities_played_this_ante[k]
						end
					end

					return true
				end,
			})
			return true
		end,
	})
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

-- Challenge Pool modification

-- Modify default spawn (when out of things to generate)
local basegame_get_current_pool = get_current_pool
function get_current_pool(_type, _rarity, legendary, key_append)
	local _pool, _pool_key = basegame_get_current_pool(_type, _rarity, legendary, key_append)

	if _type == 'Joker' and #_pool == 1 then
		if G.GAME.modifiers.pkrm_gym_forced_region then
			-- Magikarp in regional challenges
			_pool = EMPTY(G.ARGS.TEMP_POOL)
			_pool[#_pool + 1] = 'j_poke_magikarp'
		elseif G.GAME.modifiers.pkrm_gym_bug_catching_contest then
			-- Caterpie in Bug Catching Contest
			_pool = EMPTY(G.ARGS.TEMP_POOL)
			_pool[#_pool + 1] = 'j_poke_caterpie'
		end
	end

	return _pool, _pool_key
end

local all_regional_pokedexes = {}
local load_pokedex, load_error = SMODS.load_file('challenges/regional_pokedex.lua')
if load_error then
	sendDebugMessage('The error is: ' .. load_error)
else
	all_regional_pokedexes = load_pokedex()
end

local all_pokedexes = {}
local load_pokedex, load_error = SMODS.load_file('challenges/pokedex.lua')
if load_error then
	sendDebugMessage('The error is: ' .. load_error)
else
	all_pokedexes = load_pokedex()
end

function SMODS.current_mod.reset_game_globals(run_start)
	if run_start then
		if pkrm_gym_config.setting_pokermon_league and G.GAME.win_ante < 10 then
			G.GAME.win_ante = 10
		end

		if G.GAME.modifiers.pkrm_gym_forced_region then
			G.GAME.ALLOWED_POKE_POOLS = {
				all_regional_pokedexes[G.GAME.modifiers.pkrm_gym_forced_region],
				all_pokedexes.other,
			}

			G.GAME.win_ante = 10
		elseif G.GAME.modifiers.pkrm_gym_bug_catching_contest then
			G.GAME.ALLOWED_POKE_POOLS = {
				all_pokedexes.bug_contest,
				all_pokedexes.other,
			}
		end
	end
end

-- HOOKING POKERMON FUNCTIONS

-- Function pokemon_in_pool also sets the .in_pool of that pokemon
-- Modify for Pokeballs, Egg and the like
local basegame_pokermon_pokemon_in_pool = pokemon_in_pool
function pokemon_in_pool(self)
	local allowed_pools = G.GAME.ALLOWED_POKE_POOLS

	if type(allowed_pools) == 'table' then
		for _, pool in pairs(allowed_pools) do
			if pool[self.name] then return basegame_pokermon_pokemon_in_pool(self) end
		end

		-- Return false if not in any pool
		return false
	end

	return basegame_pokermon_pokemon_in_pool(self)
end

-- Tooltip for when Agatha drains energy so hard it goes to negative
local basegame_pokermon_type_tooltip = type_tooltip
type_tooltip = function(self, info_queue, center)
	basegame_pokermon_type_tooltip(self, info_queue, center)

	if
		center.ability
		and center.ability.extra
		and type(center.ability.extra) == 'table'
		and ((center.ability.extra.energy_count or 0) + (center.ability.extra.c_energy_count or 0) < 0)
	then
		info_queue[#info_queue + 1] = {
			set = 'Other',
			key = 'energy_drained',
			vars = {
				(center.ability.extra.energy_count or 0) + (center.ability.extra.c_energy_count or 0),
				energy_max + (G.GAME.energy_plus or 0),
			},
		}
	elseif center.ability and ((center.ability.energy_count or 0) + (center.ability.c_energy_count or 0) < 0) then
		info_queue[#info_queue + 1] = {
			set = 'Other',
			key = 'energy_drained',
			vars = {
				(center.ability.energy_count or 0) + (center.ability.c_energy_count or 0),
				energy_max + (G.GAME.energy_plus or 0),
			},
		}
	end
end
