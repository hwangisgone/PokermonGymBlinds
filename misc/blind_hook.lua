-- Extra blind functionalities, set by setting the name to look for in BL_FUNCTION_TABLE
-- Blind:
-- after_scoring = function(scoring_hand) end,
-- redraw_UI = function() end,

-- For persistent variables between run, e.g. Blaine's quizzes, use G.GAME.BL_PERSISTENCE


BL_FUNCTION_TABLE = {}

-- For saving/loading blinds
local hook_blind_set_blind = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
	G.GAME.BL_EXTRA = {
		pre_discard = nil,
		after_scoring = nil,
		reload = nil,
		temp_table = {},
	}

	hook_blind_set_blind(self, blind, reset, silent)
end

local hook_smods_calculate_destroying_cards = SMODS.calculate_destroying_cards
function SMODS.calculate_destroying_cards(context, cards_destroyed, scoring_hand)
	hook_smods_calculate_destroying_cards(context, cards_destroyed, scoring_hand)


	if scoring_hand and not G.GAME.blind.disabled then
		if G.GAME.BL_EXTRA and G.GAME.BL_EXTRA.after_scoring then
			local after_scoring_func = BL_FUNCTION_TABLE[G.GAME.BL_EXTRA.after_scoring]
			if type(after_scoring_func) == 'function' then
				after_scoring_func(scoring_hand)
			end
		end
	end
end

local hook_blind_load = Blind.load
function Blind:load(blindTable)
	hook_blind_load(self, blindTable)

	if G.GAME.BL_EXTRA and G.GAME.BL_EXTRA.reload then
		local reload_func = BL_FUNCTION_TABLE[G.GAME.BL_EXTRA.reload]
		if type(reload_func) == 'function' then
			reload_func(G.GAME.BL_EXTRA.temp_table)
			print("RELOAD CALCULATED")
		end
	end
end