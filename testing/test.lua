
local success, dpAPI = pcall(require, 'debugplus-api')

if success and dpAPI.isVersionCompatible(1) then -- Make sure DebugPlus is available and compatible
	local debugplus = dpAPI.registerID('GGGG')

	debugplus.addCommand {
		name = 'test1',
		shortDesc = 'Testing command',
		desc = 'This command is an example from the docs.',
		exec = function(args, rawArgs, dp)
			for _, card in pairs(G.playing_cards) do
				if pseudorandom('temporary') < G.GAME.probabilities.normal/2 then 
					SMODS.Stickers["pkrm_gym_temporary"]:apply(card, true)
				end
			end


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