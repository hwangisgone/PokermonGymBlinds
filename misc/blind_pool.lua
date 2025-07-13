local kanto_league = {
	gym = {
		'boulder',
		'cascade',
		'thunder',
		'rainbow',
		'soul',
		'marsh',
		'volcano',
		'earth',
	},
	e4 = {
		'e4_lorelei',
		'e4_bruno',
		'e4_agatha',
		'e4_lance',
	},
	champion = 'champion_kanto',
}

local johto_league = {
	gym = {
		'zephyr',
		'hive',
		'plain',
		'fog',
		'storm',
		'mineral',
		'glacier',
		'rising',
	},
	e4 = {
		'e4_will',
		'e4_koga',
		'e4_bruno',
		'e4_karen',
	},
	champion = 'champion_johto',
}

local hoenn_league = {
	gym = {
		'stone',
		'knuckle',
		'dynamo',
		'heat',
		'balance',
		'feather',
		'mind',
		'rain',
	},
	e4 = {
		'e4_sidney',
		'e4_phoebe',
		'e4_glacia',
		'e4_drake',
	},
	champion = 'champion_hoenn',
}

local all_leagues = {
	kanto = kanto_league,
	johto = johto_league,
	hoenn = hoenn_league,
}

-- I'm too lazy to add that to strings so here's automation for that
local blind_prefix = 'bl_' .. SMODS.current_mod.prefix .. '_'

for k, league in pairs(all_leagues) do
	for j, gym in pairs(league.gym) do
		all_leagues[k].gym[j] = blind_prefix .. gym
	end
	for j, e4 in pairs(league.e4) do
		all_leagues[k].e4[j] = blind_prefix .. e4
	end
	all_leagues[k].champion = blind_prefix .. league.champion
end

-- API Used for randomization. Can be used to add your own blinds to the league here.
pkrm_gym = {}
pkrm_gym.ALL_LEAGUES = all_leagues
pkrm_gym.ALL_GYMS = {}
pkrm_gym.ALL_E4 = {}
pkrm_gym.ALL_CHAMPIONS = {}
pkrm_gym.TRAINER_CLASS = {}

for _, league in pairs(all_leagues) do
	for _, gym in pairs(league.gym) do
		table.insert(pkrm_gym.ALL_GYMS, gym)
		pkrm_gym.TRAINER_CLASS[gym] = 'gym'
	end
	for _, e4 in pairs(league.e4) do
		if not pkrm_gym.TRAINER_CLASS[e4] then -- Deduplicate for Bruno
			table.insert(pkrm_gym.ALL_E4, e4)
			pkrm_gym.TRAINER_CLASS[e4] = 'e4'
		end
	end
	pkrm_gym.TRAINER_CLASS[league.champion] = 'champion'
	table.insert(pkrm_gym.ALL_CHAMPIONS, league.champion)
end

-- -- League generation -- --
-- Special cases swapping
local swap_rules = {
	['soul'] = {
		if_encountered = 'e4_koga',
		replace_with = 'soul_janine',
	},
}

local function process_blind(blind, encountered)
	encountered[blind] = (encountered[blind] or 0) + 1

	local rule = swap_rules[blind]
	if rule and encountered[rule.if_encountered] then return rule.replace_with end

	return blind
end

local function process_special_cases_in_timeline(pool)
	local encountered = {}

	for _, league in ipairs(pool) do
		-- Process arrays in-place
		for i = 1, #league.gym do
			league.gym[i] = process_blind(league.gym[i], encountered)
		end
		for i = 1, #league.e4 do
			league.e4[i] = process_blind(league.e4[i], encountered)
		end

		league.champion = process_blind(league.champion, encountered)
	end
end

-- Generating pool
local mod_id = SMODS.current_mod.id

function get_gym_boss(gym_type, gym_index)
	local seed = pseudoseed('pokermon_league')

	if G.GAME.modifiers.pkrm_gym_forced_region then
		-- Challenge only
		local region = G.GAME.modifiers.pkrm_gym_forced_region

		local selected_league = all_leagues[region]

		if not selected_league then
			sendErrorMessage('Region not defined: ' .. region, 'Gym Blinds')
			selected_league = kanto_league
		end

		if gym_type == 'champion' then
			return selected_league.champion
		elseif gym_type == 'e4' then
			return selected_league.e4[gym_index]
		else
			return selected_league.gym[gym_index]
		end
	elseif pkrm_gym_config.setting_only_gym and pkrm_gym_config.setting_ordered_gym then
		-- Case 1: Gym, Ordered

		local league_index = G.GAME.pkrm_league_pool
				and (math.floor((G.GAME.round_resets.ante - 1) / G.GAME.win_ante) % #G.GAME.pkrm_league_pool + 1)
			or 1

		if not G.GAME.pkrm_league_pool or (league_index == 1 and gym_type == 'gym' and gym_index == 1) then -- Reset
			G.GAME.pkrm_league_pool = {}

			for _, league in pairs(all_leagues) do
				local added_league = copy_table(league)

				if pkrm_gym_config.setting_random_elite4_order then pseudoshuffle(added_league.e4, seed) end

				table.insert(G.GAME.pkrm_league_pool, added_league)
			end

			pseudoshuffle(G.GAME.pkrm_league_pool, seed)
		end

		local current_league = G.GAME.pkrm_league_pool[league_index]

		if gym_type == 'champion' then
			return current_league.champion
		elseif gym_type == 'e4' then
			return current_league.e4[gym_index]
		else
			return current_league.gym[gym_index]
		end
	else
		-- Case 2: Gym, Random
		-- Case 3: No Gym, Ordered (Random all)
		-- Case 3: No Gym, Random  (Random all) (same as above)

		if not G.GAME.pkrm_league_all_pool then
			G.GAME.pkrm_league_all_pool = {
				gym = {},
				e4 = {},
				champion = {},
			}

			-- Populate pools based on boss blinds
			for k, v in pairs(G.P_BLINDS) do
				if v.boss then
					local trainer_class = pkrm_gym.TRAINER_CLASS[k]
					if trainer_class then
						G.GAME.pkrm_league_all_pool[trainer_class][k] = {
							used = false,
							min = v.boss.min or 1,
							max = v.boss.max,
						}
					else
						-- Case 3: Only add vanilla + other modded blinds if only gym is disabled
						if not pkrm_gym_config.setting_only_gym then
							local category = v.boss.showdown and 'e4' or 'gym'
							G.GAME.pkrm_league_all_pool[category][k] = {
								used = false,
								min = v.boss.min or 1,
								max = v.boss.max,
							}
						end
					end
				end
			end
		end

		local pool_type = gym_type == 'champion' and 'champion' or (gym_type == 'e4' and 'e4' or 'gym')
		local pool = G.GAME.pkrm_league_all_pool[pool_type]
		local current_ante = math.max(1, G.GAME.round_resets.ante)

		local available_bosses = {}
		local unused_count = 0

		for k, boss in pairs(pool) do
			if not boss.used then
				unused_count = unused_count + 1

				if boss.min <= current_ante then available_bosses[k] = true end
			end
		end

		if unused_count == 0 then
			-- print('Resetting pool')

			for k, boss in pairs(pool) do
				boss.used = false

				if boss.min <= current_ante then available_bosses[k] = true end
			end
		end

		local _, chosen_boss = pseudorandom_element(available_bosses, pseudoseed('boss'))
		G.GAME.pkrm_league_all_pool[pool_type][chosen_boss].used = true

		return chosen_boss
	end
end

-- TODO: Make reroll work in random mode
