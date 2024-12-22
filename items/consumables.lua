Ouija_new_item(SMODS.Spectral, "hex", {
    use = function (_, card, area, copier)
        local temp_pool = card.eligible_editionless_jokers
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            local over = false
            local eligible_card = pseudorandom_element(temp_pool, pseudoseed("hex"))
            local edition = {cry_astral = true} -- Change is here
            eligible_card:set_edition(edition, true)
            check_for_unlock({type = 'have_edition'})
            local _first_dissolve = nil
            for k, v in pairs(G.jokers.cards) do
                if v ~= eligible_card and (not v.ability.eternal) then v:start_dissolve(nil, _first_dissolve);_first_dissolve = true end
            end
            (copier or card):juice_up(0.3, 0.5)
        return true end }))
    end,
    loc_vars = function(_, info_queue, center)
        if not center.edition or (center.edition and not center.edition.cry_astral) then
            info_queue[#info_queue + 1] = G.P_CENTERS.e_cry_astral
        end
    end,
}, OUIJA_REWORK_LIGHT)


Ouija_new_item(SMODS.Spectral, "black_hole", {
    use = function (_, card, area, copier)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = true
            return true end }))
        update_hand_text({delay = 0}, {mult = '+', StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            return true end }))
        update_hand_text({delay = 0}, {chips = '+', StatusText = true})
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
            play_sound('tarot1')
            card:juice_up(0.8, 0.5)
            G.TAROT_INTERRUPT_PULSE = nil
            return true end }))
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+3'}) -- Change is here
        delay(1.3)
        for k, v in pairs(G.GAME.hands) do
            level_up_hand(card, k, true, 3) -- Change is here
        end
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
    end
}, OUIJA_REWORK_LIGHT)


-- Idea from Luigicat11
Ouija_new_item(SMODS.Tarot, "wheel_of_fortune", {
    use = function (_, card, area, copier)
        local used_tarot = copier or card
        if pseudorandom('wheel_of_fortune') < G.GAME.probabilities.normal/card.ability.extra then
            card.cry_wheel_success = true
            local temp_pool = card.eligible_strength_jokers
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                local over = false
                local eligible_card = pseudorandom_element(temp_pool, pseudoseed("wheel_of_fortune"))
                -- If I use wheel_of_fortune key it wouldn't change anything
                -- https://github.com/Steamopollys/Steamodded/blob/cedabe545f2c51547dcbfb7e981e2cedf3c7524a/core/overrides.lua#L1567
                local edition = poll_edition('ouija_wheel_of_fortune', nil, nil, true)
                eligible_card:set_edition(edition, true)
                check_for_unlock({type = 'have_edition'})
                used_tarot:juice_up(0.3, 0.5)
            return true end }))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3,
                    hold = 1.4,
                    major = used_tarot,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4);
                used_tarot:juice_up(0.3, 0.5)
            return true end }))
        end
    end,
    loc_vars = function (self, info_queue, card)
        if card then
            return {vars = {G.GAME.probabilities.normal, card.ability.extra}}
        else
            -- It would break with Wheel of Hope if we always did card.ability
            return {vars = {G.GAME.probabilities.normal, self.config.extra}}
        end
    end,
}, OUIJA_REWORK_LIGHT)


Ouija_new_item(SMODS.Spectral, "soul", {
    use = function (_, card, area, copier)
        local used_tarot = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            local new_card = create_card('Joker', G.jokers, true, nil, nil, nil, nil, 'sou')
            new_card:set_edition({negative = true}, true)
            new_card:add_to_deck()
            G.jokers:emplace(new_card)
            check_for_unlock{type = 'spawn_legendary'}
            used_tarot:juice_up(0.3, 0.5)
            return true end }))
        delay(0.6)
    end,
    can_use = function(self, card)
        return true
    end,
}, OUIJA_REWORK_LIGHT)


Ouija_new_item(SMODS.Tarot, "sun", {
    config = {max_highlighted = 1},
    loc_vars = function (self, info_queue, card)
        if card then
            return {vars = {card.ability.max_highlighted}}
        else
            return {vars = {self.config.max_highlighted}}
        end
    end,
    use = function (_, card, area, copier)
        local used_tarot = copier or card
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            used_tarot:juice_up(0.3, 0.5)
            return true end }))
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                G.hand.highlighted[i]:change_suit("Hearts")
                assert(SMODS.change_base(G.hand.highlighted[i], nil, 'King')) -- Change here
                return true
            end }))
        end
        for i=1, #G.hand.highlighted do
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2,func = function() G.hand:unhighlight_all(); return true end }))
        delay(0.5)
    end
}, OUIJA_REWORK_HEAVY)