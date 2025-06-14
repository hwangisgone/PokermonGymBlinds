GYM_BLINDS_TYPE_CLR = {
	fire = HEX('E62829'),
	grass = HEX('70CC50'),
	water = HEX('009CFD'),
	electric = HEX('FAC000'),
	bug = HEX('91A119'),
	normal = HEX('BBBBAA'),
	flying = HEX('81B9EF'),
	fighting = HEX('FF8000'),
	ghost = HEX('704170'),
	poison = HEX('9141CB'),
	psychic = HEX('F85888'),
	dark = HEX('624D4E'),
	dragon = HEX('5060E1'),
	fairy = HEX('EF70EF'),
	ice = HEX('3DCEF3'),
	ground = HEX('915121'),
	rock = HEX('AFA981'),
	steel = HEX('60A1B8'),
}

GYM_SHOWDOWN_CLR = {
	blue = G.C.UI_CHIPS,
	will = HEX('BC2649'), -- Viva Magenta
	lance = HEX('AC3C26'),
	-- 'steven'
}
-- NOTE: green needs to be slightly darker

-- Convention for naming:
-- + Debuff name: <gym leader>_<badge>_debuff | e.g. erika_rainbow_debuff
-- + Pseudoseed: <gym leader>                 | e.g. pseudoseed('misty')

SMODS.Atlas {
	key = 'stickers',
	path = 'stickers.png',
	px = 71,
	py = 95,
}

-- TODO:
-- TOCHECK:

-- Utilities:
function get_current_dollars()
	if (SMODS.Mods['Talisman'] or {}).can_load then
		return to_number(G.GAME.dollars)
	else
		return G.GAME.dollars
	end
end

function gymblind_get_random_ranks(count, seed)
	local rank_ids = {
		{ rank = '2', id = 2 },
		{ rank = '3', id = 3 },
		{ rank = '4', id = 4 },
		{ rank = '5', id = 5 },
		{ rank = '6', id = 6 },
		{ rank = '7', id = 7 },
		{ rank = '8', id = 8 },
		{ rank = '9', id = 9 },
		{ rank = '10', id = 10 },
		{ rank = 'Jack', id = 11 },
		{ rank = 'Queen', id = 12 },
		{ rank = 'King', id = 13 },
		{ rank = 'Ace', id = 14 },
	}

	pseudoshuffle(rank_ids, seed)

	local to_return = {}
	for i = 1, count do
		table.insert(to_return, rank_ids[i])
	end

	return to_return
end

function remove_debuff_all_jokers(source)
	for _, card in pairs(G.jokers.cards) do
		SMODS.debuff_card(card, false, source)
	end
end
function remove_debuff_all_playing_cards(source)
	for _, card in pairs(G.playing_cards) do
		SMODS.debuff_card(card, false, source)
	end
end

function card_is_even(card)
	-- Lua has modulo???
	return not card:is_face() and card:get_id() % 2 == 0
end

function card_is_odd(card)
	return not card:is_face() and card:get_id() % 2 == 1
end

function pkrm_gym_attention_text(args)
	args = args or {}

	if not args.text or not args.backdrop_colour or not args.major then
		print('Syntax: pkrm_gym_attention_text({text, backdrop_colour, major, scale, hold, align})')
		return
	end

	args.scale = args.scale or 0.75
	args.hold = args.hold or 1.4
	args.align = args.align or 'tm'

	local offset_y
	if args.major == G.play then
		offset_y = -0.1
	elseif args.major == G.hand then
		offset_y = -0.3
	else
		offset_y = -0.1
	end

	attention_text {
		text = args.text,
		scale = args.scale,
		hold = args.hold,
		backdrop_colour = args.backdrop_colour,
		align = args.align,
		major = args.major,
		offset = { x = 0, y = offset_y * G.CARD_H },
	}
end

function champion_no_disable_attention_text()
	attention_text {
		text = localize('pkrm_gym_champion_no_disable'),
		scale = 0.75,
		hold = 10,
		align = 'tm',
		major = G.play,
		offset = { x = 0, y = -0.1 * G.CARD_H },
	}
end

local files_to_load = {
	-- Loading blind hooks
	'misc/blind_hook.lua',
	-- Loading blinds
	'blinds/kanto.lua',
	'blinds/johto.lua',
	'blinds/hoenn.lua',
}

for k, file_path in pairs(files_to_load) do
	local load_the_file, load_error = SMODS.load_file(file_path)
	if load_error then
		sendDebugMessage('The error is: ' .. load_error)
	else
		load_the_file()
	end
end

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

local all_gyms = {}
local all_e4 = {}
local all_champions = {}
local blind_prefix = 'bl_' .. SMODS.current_mod.prefix .. '_'

for k, league in pairs(all_leagues) do
	for j, gym in pairs(league.gym) do
		all_leagues[k].gym[j] = blind_prefix .. gym
		table.insert(all_gyms, gym)
	end
	for j, e4 in pairs(league.e4) do
		all_leagues[k].e4[j] = blind_prefix .. e4
		table.insert(all_e4, e4)
	end
	all_leagues[k].champion = blind_prefix .. league.champion
	table.insert(all_champions, league.champion)
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
function get_league_pool()
	local pool = {}
	local seed = pseudoseed('pokermon_league')

	if pkrm_gym_config.setting_random_gym then
		local shuffled_gyms = copy_table(all_gyms)
		local shuffled_e4 = copy_table(all_e4)
		local shuffled_champions = copy_table(all_champions)

		pseudoshuffle(shuffled_gyms, seed)
		pseudoshuffle(shuffled_e4, seed)
		pseudoshuffle(shuffled_champions, seed)

		local count = #shuffled_champions
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
	else
		pool = copy_table(all_leagues)
		pseudoshuffle(pool, seed)

		if pkrm_gym_config.setting_random_elite4 then
			for _, league in ipairs(pool) do
				pseudoshuffle(league.e4, seed)
			end
		end
	end

	return pool
end




-- UI Config stuff
local modtag = 'pkrm_gym'
pkrm_gym_config = SMODS.current_mod.config

local create_menu_checkbox = function(ref_value, tooltip)
	return {
		n = G.UIT.R,
		config = { align = 'cm', tooltip = { title = 'Explanation', text = tooltip } },
		nodes = {
			-- Localize here
			create_toggle {
				label = localize(modtag .. '_' .. ref_value),
				ref_table = pkrm_gym_config,
				ref_value = ref_value,
			},
		},
	}
end

local pkrm_gym_config_ui_nodes = function()
	return {
		{
			n = G.UIT.C,
			config = { align = 'cm', padding = 0.1 },
			nodes = {
				create_menu_checkbox(
					'setting_only_gym',
					{ 'Testing 1', '' .. tostring(pkrm_gym_config.setting_only_gym) }
				),
				create_menu_checkbox('setting_random_gym', { 'Testing 2' }),
				create_menu_checkbox('setting_random_elite4', { 'Testing 3' }),
				create_menu_checkbox('setting_reduce_scaling', { 'Testing 4' }),
			},
		},
	}
end

SMODS.current_mod.config_tab = function()
	return { n = G.UIT.ROOT, config = {}, nodes = pkrm_gym_config_ui_nodes() }
end

-- Loading hooks
local util_hooks, load_error = SMODS.load_file('misc/hook.lua')
if load_error then
	sendDebugMessage('The error is: ' .. load_error)
else
	util_hooks()
end

-- Mod icon
SMODS.Atlas {
	key = 'modicon',
	px = 34,
	py = 34,
	path = 'modicon.png',
}
-- TODO: Edit this icon, make it bigger and remove outline (because outline blends with bg)

local DEBUG = true
if DEBUG then
	if Balatest then
		assert(SMODS.load_file('testing/kanto.lua'))()
		assert(SMODS.load_file('testing/johto.lua'))()
	end
	assert(SMODS.load_file('testing/temp/test.lua'))()
end
