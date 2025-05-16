
-- TODO: Testing
local success, dpAPI = pcall(require, 'debugplus-api')

if success and dpAPI.isVersionCompatible(1) then -- Make sure DebugPlus is available and compatible
	local debugplus = dpAPI.registerID('GGGG')

	debugplus.addCommand {
		name = 'test1',
		shortDesc = 'Testing command',
		desc = 'This command is an example from the docs.',
		exec = function(args, rawArgs, dp)
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
			-- print(G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'))
			attention_text {
				text = 'X' .. (100),
				scale = 0.8,
				hold = 2,
				cover = G.HUD_blind:get_UIE_by_ID('HUD_blind_debuff'),
				cover_colour = G.C.GOLD,
				align = 'cm',
			}


		end,
	}

	debugplus.addCommand {
		name = 'test_disable',
		shortDesc = 'Add disabling jokers',
		desc = 'Add disabling jokers',
		exec = function(args, rawArgs, dp)
			SMODS.add_card {
				set = 'Joker',
				key = 'j_chicot',
			}

			SMODS.add_card {
				set = 'Joker',
				key = 'j_poke_weezing',
			}
		end,
	}

	debugplus.addCommand {
		name = 'test_hazard',
		shortDesc = 'Add hazard jokers',
		desc = 'Add hazard jokers',
		exec = function(args, rawArgs, dp)
			SMODS.add_card {
				set = 'Joker',
				key = 'j_poke_skarmory',
			}

			SMODS.add_card {
				set = 'Joker',
				key = 'j_poke_qwilfish',
			}

			SMODS.add_card {
				set = 'Joker',
				key = 'j_poke_roggenrola',
			}
		end,
	}

	debugplus.addCommand {
		name = 'test_sort',
		shortDesc = 'Add disabling jokers',
		desc = 'Add disabling jokers',
		exec = function(args, rawArgs, dp)
			local list_rank = {}
			for _, card in pairs(G.deck.cards) do
				table.insert(list_rank, card:get_id())
			end

			print(table.concat(list_rank, ' '))
		end,
	}
end