-- Extra blind functionalities, set by setting the name to look for in BL_FUNCTION_TABLE
-- Blind:
-- after_scoring = function(scoring_hand) end,
-- redraw_UI = function() end,

-- For persistent variables between run, e.g. Blaine's quizzes, use G.GAME.BL_PERSISTENCE

BL_FUNCTION_TABLE = {}

-- For saving/loading blinds
local basegame_blind_set_blind = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
	if not reset then
		G.GAME.BL_EXTRA = {
			reload = nil,
			ease_dollars = nil,
			temp_table = {},
		}
		-- print("BL_EXTRA reset")
	end

	basegame_blind_set_blind(self, blind, reset, silent)
end

local basegame_blind_load = Blind.load
function Blind:load(blindTable)
	basegame_blind_load(self, blindTable)

	if G.GAME.BL_EXTRA and G.GAME.BL_EXTRA.reload then
		local reload_func = BL_FUNCTION_TABLE[G.GAME.BL_EXTRA.reload]
		if type(reload_func) == 'function' then
			reload_func(G.GAME.BL_EXTRA.temp_table)
		end
	end
end

local _ease_dollars = ease_dollars
function ease_dollars(mod, instant)
	_ease_dollars(mod, instant)

	if G.GAME.BL_EXTRA and G.GAME.BL_EXTRA.ease_dollars then
		local ease_dollars_func = BL_FUNCTION_TABLE[G.GAME.BL_EXTRA.ease_dollars]
		if type(ease_dollars_func) == 'function' then
			if instant then
				ease_dollars_func(mod)
			else
				G.E_MANAGER:add_event(Event {
					trigger = 'immediate',
					func = function()
						ease_dollars_func(mod)
						return true
					end,
				})
			end
		end
	end
end
