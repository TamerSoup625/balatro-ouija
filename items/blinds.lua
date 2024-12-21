Ouija_new_item(SMODS.Blind, "arm", {
    debuff_hand = function(_, cards, hand, handname, check)
        local blind = G.GAME.blind
        blind.triggered = false
        if G.GAME.hands[handname].level > 0 then
            blind.triggered = true
            if not check then
                -- e.g. 6 -> 4 -> 2 -> 1 -> 0
                level_up_hand(blind.children.animatedSprite, handname, nil, -math.ceil(G.GAME.hands[handname].level / 3))
                blind:wiggle()
            end
        end 
    end,
}, OUIJA_REWORK_LIGHT)


Ouija_new_item(SMODS.Blind, "eye", {
    name = "Ouija-The Eye", -- will prevent old calculation code from working
	cry_cap_score = function(self, score)
        if G.GAME.current_round.hands_played == 0 then
            return -2 * score
        end
        return score
	end,
	in_pool = function()
		return G.GAME.round_resets.hands >= 2 and (not next(SMODS.find_card("j_cry_maze"))) and G.GAME.round_resets.ante >= 2
	end,
}, OUIJA_REWORK_HEAVY)