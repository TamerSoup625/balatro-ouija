Ouija_new_item(SMODS.Enhancement, "stone", {
    replace_base_card = true,
    config = {
        x_chips = 1.5,
    },
    loc_vars = function (self, info_queue, card)
        if card then
            return {vars = {card.ability.x_chips}}
        else
            -- Seems like it would break with Stone Joker if we always did card.ability
            return {vars = {self.config.x_chips}}
        end
    end,
}, OUIJA_REWORK_LIGHT)


Ouija_new_item(SMODS.Back, "magic", {
    config = {},
    loc_vars = function (_, info_queue, card)
        return {vars = {}}
    end,
    apply = function(self)
        delay(0.4)
        G.E_MANAGER:add_event(Event({
            func = function()
                for i = 1, 2 do
                    local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, "c_fool", 'deck')
                    card:add_to_deck()
                    card:set_edition({negative = true})
                    G.consumeables:emplace(card)
                end
            return true
            end
        }))
        G.GAME.joker_rate = 0
        G.GAME.planet_rate = 0
        G.GAME.tarot_rate = 1e100
    end
}, OUIJA_REWORK_HEAVY)


Ouija_new_item(SMODS.Back, "erratic", {
    config = {},
    apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
                local ten_of_spades = pseudorandom_element(G.P_CARDS, pseudoseed('ouija_erratic'))
                for _, card in ipairs(G.playing_cards) do
					card:set_base(ten_of_spades)
				end
				return true
			end
		}))
    end
}, OUIJA_REWORK_HEAVY)


-- Make Standard Packs have a chance to contain Negative cards
local poll_edition_ref = poll_edition
function poll_edition(_key, _mod, _no_neg, _guaranteed)
    if string.find(_key, "^standard_edition") ~= nil then
        print("Poll with negative")
        return poll_edition_ref(_key, _mod, false, _guaranteed)
    end
    return poll_edition_ref(_key, _mod, _no_neg, _guaranteed)
end