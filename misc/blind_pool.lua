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
	kanto_league,
	johto_league,
	hoenn_league,
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


print(G.P_BLINDS)

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

function get_league_pool()
	local pool = {}
	local seed = pseudoseed('pokermon_league')

	if G.GAME.modifiers.pkrm_gym_forced_region then
		-- Challenge only
		local region_map = {
			kanto = kanto_league,
			johto = johto_league,
			hoenn = hoenn_league,
		}

		local selected_region = region_map[G.GAME.modifiers.pkrm_gym_forced_region]

		if not selected_region then
			sendErrorMessage('Region not defined: ' .. G.GAME.modifiers.pkrm_gym_forced_region, 'Gym Blinds')
			select_region = copy_table(kanto_league)
		end

		pool = { selected_region }
	elseif pkrm_gym_config.setting_only_gym and pkrm_gym_config.setting_ordered_gym then 
        -- Case 1: Gym, Ordered

		pool = copy_table(all_leagues)
		pseudoshuffle(pool, seed)

		if pkrm_gym_config.setting_random_elite4_order then
			for _, league in ipairs(pool) do
				pseudoshuffle(league.e4, seed)
			end
		end
    else
        -- Case 2: Gym, Random
        -- Case 3: No Gym, Ordered (Random all)
        -- Case 3: No Gym, Random  (Random all) (same as above)

		-- setting_pokermon_league
		local shuffled_gyms = copy_table(pkrm_gym.ALL_GYMS)
		local shuffled_e4 = copy_table(pkrm_gym.ALL_E4)
		local shuffled_champions = copy_table(pkrm_gym.ALL_CHAMPIONS)

		-- Case 3: Add all other blinds (vanilla & modded)
        if not pkrm_gym_config.setting_only_gym then
            for k, v in pairs(G.P_BLINDS) do
                if not pkrm_gym.TRAINER_CLASS[k] then
                    if v.boss then
                        if v.boss.showdown then
                            table.insert(shuffled_e4, k)
                        else
                            table.insert(shuffled_gyms, k)
                        end
                    end
                end
            end
        end

        -- TODO: Min, Max of each boss Doesn't work

		pseudoshuffle(shuffled_gyms, seed)
		pseudoshuffle(shuffled_e4, seed)
		pseudoshuffle(shuffled_champions, seed)

        -- We have 3 leagues and some blind are duplicated
        -- so -1 to not end up with missing blind
		local count = #all_leagues - 1
		for i = 1, count do
			local league = {
				gym = { -- 8 gyms
					table.remove(shuffled_gyms),
					table.remove(shuffled_gyms),
					table.remove(shuffled_gyms),
					table.remove(shuffled_gyms),
					table.remove(shuffled_gyms),
					table.remove(shuffled_gyms),
					table.remove(shuffled_gyms),
					table.remove(shuffled_gyms),
				},
				e4 = { -- elite four
					table.remove(shuffled_e4),
					table.remove(shuffled_e4),
					table.remove(shuffled_e4),
					table.remove(shuffled_e4),
				},
				champion = table.remove(shuffled_champions),
			}

			table.insert(pool, league)
		end
	end

	return pool
end


-- TODO: Make reroll work in random mode