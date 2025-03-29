GYM_BLINDS_TYPE_CLR = {
	fire = HEX('E62829'),
	grass = HEX('3FA129'),
	water = HEX('009CFD'),
	electric = HEX('FAC000'),
	bug = HEX('91A119'),
	normal = HEX('C1C2C1'),
	flying = HEX('81B9EF'),
	fighting = HEX('FF8000'),
	ghost = HEX('704170'),
	poison = HEX('9141CB'),
	psychic = HEX('EF4179'),
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
	will = HEX('EF4179'),
	lance = HEX('AC3C26'),
	-- 'steven'
}
-- TODO: Note: green needs to be brighter
-- Psychic too intense, suitable for Will but not anyone else
--  Maybe darken normal

-- TODO: Use this??? SMODS.juice_up_blind()

-- SMODS.Back {
-- 	key = 'testing1',
-- 	loc_txt = "TESTING DECK 1",
-- 	discovered = true,
-- 	apply = function(self, back)
-- 		SMODS.create_card({
-- 			set = 'Joker',
-- 			area = G.jokers,
-- 			key = 'j_chicot'
-- 		})

-- 		SMODS.create_card({
-- 			set = 'Joker',
-- 			area = G.jokers,
-- 			key = 'j_poke_weezing'
-- 		})
-- 	end
-- }


-- Utilities:
function get_current_dollars()
	if (SMODS.Mods["Talisman"] or {}).can_load then
		return to_number(G.GAME.dollars)
	else
		return G.GAME.dollars
	end
end

function gymblind_get_random_ranks(count, seed)
	local rank_ids = {
		{rank = '2', id = 2},
		{rank = '3', id = 3},
		{rank = '4', id = 4},
		{rank = '5', id = 5},
		{rank = '6', id = 6},
		{rank = '7', id = 7},
		{rank = '8', id = 8},
	    {rank = '9', id = 9},
	    {rank = '10', id = 10},
	    {rank = 'Jack', id = 11},
	    {rank = 'Queen', id = 12},
	    {rank = 'King', id = 13},
	    {rank = 'Ace', id = 14},
	}

	pseudoshuffle(rank_ids, seed)

	local to_return = {}
	for i = 1, count do
		table.insert(to_return, rank_ids[i])
	end

	return to_return
end


function card_is_even(card)
	local id = card:get_id()
	return id == 2 or 
			id == 4 or 
			id == 6 or 
			id == 8 or 
			id == 10
end

function card_is_odd(card)
	local id = card:get_id()
	return id == 3 or 
			id == 5 or 
			id == 7 or 
			id == 8 or 
			id == 14
end

-- Loading blind hooks
local blind_hooks, load_error = SMODS.load_file('misc/blind_hook.lua')
if load_error then sendDebugMessage ("The error is: "..load_error)
else blind_hooks()
end


-- Loading blinds
local kanto_load, load_error = SMODS.load_file('blinds/kanto.lua')
if load_error then sendDebugMessage ("The error is: "..load_error)
else kanto_load()
end

local johto_load, load_error = SMODS.load_file('blinds/johto.lua')
if load_error then sendDebugMessage ("The error is: "..load_error)
else johto_load()
end

local hoenn_load, load_error = SMODS.load_file('blinds/hoenn.lua')
if load_error then sendDebugMessage ("The error is: "..load_error)
else hoenn_load() 
end




-- TODO: Testing
local success, dpAPI = pcall(require, "debugplus-api")

if success and dpAPI.isVersionCompatible(1) then -- Make sure DebugPlus is available and compatible
	local debugplus = dpAPI.registerID("GGGG")

	debugplus.addCommand({
		name = "test1",
		shortDesc = "Testing command",
		desc = "This command is an example from the docs.",
		exec = function (args, rawArgs, dp)
				-- UIBox{
				--     definition = 
				--       {n=G.UIT.ROOT, config = {align = 'cm', colour = G.C.CLEAR, padding = 0.2}, nodes={
				--         {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
				--             {n=G.UIT.O, config={object = DynaText({scale = 0.7, string = localize('ph_unscored_hand'), maxw = 9, colours = {G.C.WHITE},float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})}},
				--         }},
				--         {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
				--             {n=G.UIT.O, config={object = DynaText({scale = 0.65, string = localize('ph_unscored_hand'), maxw = 9, colours = {G.C.WHITE},float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})}},
				--         }},
				--         {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
				--             {n=G.UIT.O, config={object = DynaText({scale = 0.6, string = localize('ph_unscored_hand'), maxw = 9, colours = {G.C.WHITE},float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})}},
				--         }},
				--         {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
				--             {n=G.UIT.O, config={object = DynaText({scale = 0.5, string = localize('ph_unscored_hand'), maxw = 9, colours = {G.C.WHITE},float = true, shadow = true, silent = true, pop_in = 0, pop_in_rate = 6})}},
				--         }},
				--     }}, 

				--   }
				print(BL_FUNCTION_TABLE)
				print(BL_FUNCTION_TABLE['test'])
				print(G.GAME.BL_EXTRA)
		end
	})

	debugplus.addCommand({
		name = "test_disable",
		shortDesc = "Add disabling jokers",
		desc = "Add disabling jokers",
		exec = function (args, rawArgs, dp)
			SMODS.add_card({
				set = 'Joker',
				key = 'j_chicot',
			})

			SMODS.add_card({
				set = 'Joker',
				key = 'j_poke_weezing',
			})
		end
	})

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
	champion = 'champion_kanto'
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
	champion = 'champion_johto'
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
	champion = 'champion_hoenn'
}

local all_leagues = {
	kanto_league,
	johto_league,
	hoenn_league,
}

local	all_gyms = {}
local	all_e4 = {}
local	all_champions = {}
local blind_prefix = 'bl_'..SMODS.current_mod.prefix..'_'


for k, league in pairs(all_leagues) do
	for j, gym in pairs(league.gym) do
		all_leagues[k].gym[j] = blind_prefix..gym
		table.insert(all_gyms, gym)
	end
	for j, e4 in pairs(league.e4) do
		all_leagues[k].e4[j] = blind_prefix..e4
		table.insert(all_e4, e4)
	end
	all_leagues[k].champion = blind_prefix..league.champion
	table.insert(all_champions, league.champion)
end

function generate_league()
	local selected_league = {
		gym = {},
		e4 = {},
		champion = ''
	}

	if pkrm_gym_config.setting_random_gym then
		local shuffled_gyms = copy_table(all_gyms)
		local shuffled_e4   = copy_table(all_e4) 
		pseudoshuffle(all_gyms, pseudoseed('pokermon_league'))
		pseudoshuffle(all_e4, pseudoseed('pokermon_league'))

		for i = 1, 8 do
			table.insert(selected_league.gym, shuffled_gyms[i])
		end

		for i = 1, 4 do
			table.insert(selected_league.e4, shuffled_e4[i])
		end
		
		selected_league.champion = pseudorandom_element(all_champions, pseudoseed('pokermon_league'))
	else
		selected_league = pseudorandom_element(all_leagues, pseudoseed('pokermon_league'))
	end

	if pkrm_gym_config.setting_random_elite4 then
		pseudoshuffle(selected_league.e4)
	end

	return selected_league
end

-- Testing stage
function table_to_string(tbl)
	local result = '{'
	
	for k, v in pairs(tbl) do
		-- Handle the key
		if type(k) == "string" then
			result = result .. '["' .. k .. '"]='
		else
			result = result .. "[" .. tostring(k) .. "]="
		end
		
		-- Handle the value
		if type(v) == "table" then
			result = result .. table_to_string(v) -- Recursive call for nested tables
		elseif type(v) == "string" then
			result = result .. '"' .. v .. '"'
		else
			result = result .. tostring(v)
		end
		
		result = result .. ","
	end
	
	-- Remove trailing comma and close the table
	if result ~= "{" then
		result = result:sub(1, -2)
	end
	return result .. "}"
end


-- UI Config stuff
local modtag = "pkrm_gym"
pkrm_gym_config = SMODS.current_mod.config


local create_menu_checkbox = function(ref_value, tooltip)
	return {n = G.UIT.R, config = {align = "cm", tooltip = {title = "Explanation", text = tooltip}}, nodes = {
		-- Localize here
		create_toggle({
			label = localize(modtag.."_"..ref_value),
			ref_table = pkrm_gym_config,
			ref_value = ref_value,
		})
	}}
end

local pkrm_gym_config_ui_nodes = function()
	return {{n = G.UIT.C, config = {align = "cm", padding = 0.1}, nodes = {
		create_menu_checkbox("setting_only_gym",           {"Testing 1", ''..tostring(pkrm_gym_config.setting_only_gym)}),
		create_menu_checkbox("setting_random_gym",         {"Testing 2"}),
		create_menu_checkbox("setting_random_elite4",      {"Testing 3"}),
		create_menu_checkbox("setting_reduce_scaling",  {"Testing 4"}),
	}}}
end

SMODS.current_mod.config_tab = function()
	return {n = G.UIT.ROOT, config = {}, 
		nodes = pkrm_gym_config_ui_nodes() 
	}
end


-- Loading hooks
local util_hooks, load_error = SMODS.load_file('misc/hook.lua')
if load_error then
	sendDebugMessage ("The error is: "..load_error)
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
