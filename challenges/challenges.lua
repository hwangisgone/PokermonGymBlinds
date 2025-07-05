local all_starters = {
	kanto = {
		'j_poke_bulbasaur',
		'j_poke_charmander',
		'j_poke_squirtle',
		'j_poke_pikachu',
		'j_poke_eevee',
	},
	johto = {
		'j_poke_chikorita',
		'j_poke_cyndaquil',
		'j_poke_totodile',
	},
	hoenn = {
		'j_poke_treecko',
		'j_poke_torchic',
		'j_poke_mudkip',
	},
	sinnoh = {
		'j_poke_turtwig',
		'j_poke_chimchar',
		'j_poke_piplup',
	},
	unova = {
		'j_poke_snivy',
		'j_poke_tepig',
		'j_poke_oshawott',
	},
	kalos = {
		'j_poke_chespin',
		'j_poke_fennekin',
		'j_poke_froakie',
	},
	alola = {
		'j_poke_rowlet',
		'j_poke_litten',
		'j_poke_popplio',
	},
	galar = {
		'j_poke_grookey',
		'j_poke_scorbunny',
		'j_poke_sobble',
	},
	paldea = {
		'j_poke_sprigatito',
		'j_poke_foecoco',
		'j_poke_quaxly',
	},
}

local function get_starter_cards()
	if G.GAME.modifiers.pkrm_gym_forced_region then
		local starters = all_starters[G.GAME.modifiers.pkrm_gym_forced_region:lower()]

		if starters then return starters end
	end

	return {
		'j_poke_bulbasaur',
		'j_poke_chikorita',
		'j_poke_treecko',
	}
end

SMODS.Atlas {
	key = 'gympack',
	path = 'packs.png',
	px = 71,
	py = 95,
}

SMODS.Booster {
	name = 'Starter Pack',
	key = 'starter_pack',

	kind = 'Spectral',
	atlas = 'gympack',
	pos = { x = 0, y = 0 },
	config = { extra = 3, choose = 1, starter_cards = {} },

	cost = 999,
	order = 4,
	weight = 0,
	draw_hand = false,
	unlocked = true,
	discovered = false,
	no_collection = false,
	
	in_pool = function(self)
		return false
	end,

	set_ability = function(self, card, initial, delay_sprites)
		if initial then
			card.ability.starter_cards = get_starter_cards()
			card.ability.extra = #card.ability.starter_cards
		end

		if card.T.h > G.CARD_H then return end -- Is in Collection & also not in Challenge

		card.T.w = card.T.w * 1.27
		card.T.h = card.T.h * 1.27

		G.E_MANAGER:add_event(Event {
			func = function()
				-- Run later to reset cost
				card.cost = 0
				return true
			end,
		})
		card.from_tag = true

		-- Copied, modified from create_shop_card_ui
		card.children.buy_button = UIBox {
			definition = {
				n = G.UIT.ROOT,
				config = {
					ref_table = card,
					minw = 1.1,
					maxw = 1.3,
					padding = 0.1,
					align = 'bm',
					colour = G.C.GREEN,
					shadow = true,
					r = 0.08,
					minh = 0.94,
					one_press = true,
					button = 'use_card',
					hover = true,
				},
				nodes = {
					{ n = G.UIT.T, config = { text = localize('b_open'), colour = G.C.WHITE, scale = 0.5 } },
				},
			},
			config = {
				align = 'bm',
				offset = { x = 0, y = -0.4 },
				major = card,
				bond = 'Weak',
				parent = card,
			},
		}
	end,

	create_card = function(self, card, i)
		-- force pack_choices to 1
		G.GAME.pack_choices = 1

		local starter_cards = card.ability.starter_cards

		local temp_card = {
			area = G.pack_cards,
			key = starter_cards[1 + (i - 1) % #starter_cards],
			skip_materialize = true,
		}

		return SMODS.create_card(temp_card)
	end,

	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,

	group_key = 'k_pkrm_gym_starter_pack',
}

SMODS.Gradient {
	key = 'RBY',
	colours = {
		G.C.MULT,
		G.C.CHIPS,
		G.C.FILTER, -- attention / hand_size color
	}
}

SMODS.Gradient {
	key = 'GSC',
	colours = {
		G.C.GOLD,
		G.C.GREY,
		G.C.BLUE,
	}
}

SMODS.Gradient {
	key = 'RSE',
	colours = {
		HEX('D13B26'),
		HEX('0077BF'),
		HEX('408962'),
	}
}


local all_challenges = {
	kanto = { available = true, colour = SMODS.Gradients.pkrm_gym_RBY },
	johto = { available = true, colour = SMODS.Gradients.pkrm_gym_GSC },
	hoenn = { available = true, colour = SMODS.Gradients.pkrm_gym_RSE },
}

local function normalize_string(str)
	return str:sub(1, 1):upper() .. str:sub(2):lower()
end

for region_id, challenge in pairs(all_challenges) do
	if challenge.available then
		SMODS.Challenge {
			key = region_id,
			rules = {
				custom = {
					{ id = 'pkrm_gym_forced_regional_jokers', value = normalize_string(region_id) },
					{ id = 'pkrm_gym_forced_region', value = normalize_string(region_id) },
				},
			},
			consumeables = {
				{ id = 'p_pkrm_gym_starter_pack' },
			},
			button_colour = challenge.colour
		}
	end
end
