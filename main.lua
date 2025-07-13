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
	bruno = HEX('636068'), -- Slate
	blue = G.C.UI_CHIPS,
	will = HEX('BC2649'), -- Viva Magenta
	koga = HEX('D712A7'), -- Pinkish Fuchsia
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

-- SMODS configs
-- Allows self destroying card to actually destroy themselves in deck
SMODS.current_mod.optional_features = function()
	return { cardareas = { deck = true } }
end

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
	args.offset_x = args.offset_x or 0

	local offset_y = args.offset_y

	if not offset_y then
		if args.major == G.play then
			offset_y = -0.1 * G.CARD_H
		elseif args.major == G.hand then
			offset_y = -0.3 * G.CARD_H
		else
			offset_y = -0.1 * G.CARD_H
		end
	end

	attention_text {
		text = args.text,
		scale = args.scale,
		hold = args.hold,
		backdrop_colour = args.backdrop_colour,
		align = args.align,
		major = args.major,
		offset = { x = args.offset_x, y = offset_y },
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
	'misc/hook_blind.lua',
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

-- UI Config stuff
local modtag = 'pkrm_gym'
pkrm_gym_config = SMODS.current_mod.config

local create_menu_checkbox = function(ref_value, tooltip, can_display)
	if can_display == false then return {
		n = G.UIT.R,
		config = { align = 'cm' },
	} end

	local tooltip_obj = tooltip and { text = localize(modtag .. '_' .. ref_value, 'tooltips') }
	local extra_indent = can_display == true and 0.5

	return {
		n = G.UIT.R,
		config = { align = 'cl', tooltip = tooltip_obj },
		nodes = {
			-- Padding
			{ n = G.UIT.C, config = { minw = extra_indent } },

			create_toggle {
				label = localize(modtag .. '_' .. ref_value),
				ref_table = pkrm_gym_config,
				ref_value = ref_value,
				callback = function(e)
					-- Refresh Tab config (required to make update with can_display)
					G.FUNCS.change_tab(G.OVERLAY_MENU:get_UIE_by_ID('tab_but_Config'))
				end,
			},
		},
	}
end

SMODS.current_mod.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = { colour = G.C.UI.TEXT_DARK },
		nodes = {
			{
				n = G.UIT.C,
				config = { align = 'cl', padding = 0.1 },
				nodes = {
					create_menu_checkbox('setting_only_gym', true),
					create_menu_checkbox('setting_ordered_gym', true, pkrm_gym_config.setting_only_gym),
					create_menu_checkbox('setting_pokermon_league', true),
					create_menu_checkbox('setting_random_elite4_order', nil, pkrm_gym_config.setting_pokermon_league),
					create_menu_checkbox('setting_reduce_scaling', nil, pkrm_gym_config.setting_pokermon_league),
				},
			},
		},
	}
end

-- Loading hooks
local util_hooks, load_error = SMODS.load_file('misc/hook.lua')
if load_error then
	sendDebugMessage('The error is: ' .. load_error)
else
	util_hooks()
end

-- Loading challenges
local load_challenges, load_error = SMODS.load_file('challenges/challenges.lua')
if load_error then
	sendDebugMessage('The error is: ' .. load_error)
else
	load_challenges()
end

-- Mod icon
SMODS.Atlas {
	key = 'modicon',
	px = 34,
	py = 34,
	path = 'modicon.png',
}

local DEBUG = true
if DEBUG then
	if Balatest then
		assert(SMODS.load_file('testing/kanto.lua'))()
		assert(SMODS.load_file('testing/johto.lua'))()
	end

	local chunk, load_error = SMODS.load_file('testing/temp/test.lua')
	if load_error then
		sendDebugMessage('Did not load Debugging file')
	else
		chunk()
	end
end
