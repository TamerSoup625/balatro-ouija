-- TODO: Check if Cryptid features are enabled or not


local function new_item(smods_gameobject, key, table)
    smods_gameobject:take_ownership(key, table)
end


new_item(SMODS.Spectral, "hex", {
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
})


-- Makes mod badge show up
new_item(SMODS.Joker, "ancient", {})

function reset_ancient_card()
    G.GAME.current_round.ancient_card.suit = 'Spades'
    local valid_ancient_cards = {}
    for k, v in ipairs(G.playing_cards) do
        if v.ability.effect ~= 'Stone Card' then
            valid_ancient_cards[#valid_ancient_cards+1] = v
        end
    end
    if valid_ancient_cards[1] then 
        local ancient_card = pseudorandom_element(valid_ancient_cards, pseudoseed('anc'..G.GAME.round_resets.ante))
        G.GAME.current_round.ancient_card.suit = ancient_card.base.suit
    end
end


new_item(SMODS.Joker, "flower_pot", {
    calculate = function (_, card, context)
        if context.joker_main and (to_big(card.ability.extra) > to_big(1)) then
            local suits = {
                ['Hearts'] = 0,
                ['Diamonds'] = 0,
                ['Spades'] = 0,
                ['Clubs'] = 0
            }
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0 then suits["Hearts"] = suits["Hearts"] + 1 end
                if context.scoring_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0 then suits["Diamonds"] = suits["Diamonds"] + 1 end
                if context.scoring_hand[i]:is_suit('Spades') and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1 end
                if context.scoring_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0  then suits["Clubs"] = suits["Clubs"] + 1 end
            end
            if suits["Hearts"] > 0 and
            suits["Diamonds"] > 0 and
            suits["Spades"] > 0 and
            suits["Clubs"] > 0 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra}},
                    Xmult_mod = card.ability.extra
                }
            end
        end
    end
})


new_item(SMODS.Joker, "four_fingers", {
    config = {extra = 4},
    loc_vars = function (_, info_queue, card)
        return {vars = {card.ability.extra}}
    end,
})

-- https://github.com/Steamopollys/Steamodded/blob/a6d4f684cf9b21637adce3228229f8ac28cce694/core/overrides.lua#L578
local get_straight_ref = get_straight
function get_straight(hand)
    if not next(SMODS.find_card("j_four_fingers")) then
        return get_straight_ref(hand)
    end
    local ret = {}

    local min_size = 5
    for _, value in pairs(SMODS.find_card("j_four_fingers")) do
        if value.ability.extra < min_size then
            min_size = value.ability.extra
        end
    end

    local can_skip = next(SMODS.find_card('j_shortcut'))
    if #hand < min_size then return ret end
    local t = {}
    local RANKS = {}
    for i = 1, #hand do
        if hand[i]:get_id() > 0 then
            local rank = hand[i].base.value
            RANKS[rank] = RANKS[rank] or {}
            RANKS[rank][#RANKS[rank] + 1] = hand[i]
        end
    end
    local straight_length = 0
    local straight = false
    local skipped_rank = false
    local vals = {}
    for k, v in pairs(SMODS.Ranks) do
        if v.straight_edge then
            table.insert(vals, k)
        end
    end
    local init_vals = {}
    for _, v in ipairs(vals) do
        init_vals[v] = true
    end
    if not next(vals) then table.insert(vals, 'Ace') end
    local initial = true
    local br = false
    local end_iter = false
    local i = 0
    while 1 do
        end_iter = false
        if straight_length >= min_size then
            straight = true
        end
        i = i + 1
        if br or (i > #SMODS.Rank.obj_buffer + 1) then break end
        if not next(vals) then break end
        for _, val in ipairs(vals) do
            if init_vals[val] and not initial then br = true end
            if RANKS[val] then
                straight_length = straight_length + 1
                skipped_rank = false
                for _, vv in ipairs(RANKS[val]) do
                    t[#t + 1] = vv
                end
                vals = SMODS.Ranks[val].next
                initial = false
                end_iter = true
                break
            end
        end
        if not end_iter then
            local new_vals = {}
            for _, val in ipairs(vals) do
                for _, r in ipairs(SMODS.Ranks[val].next) do
                    table.insert(new_vals, r)
                end
            end
            vals = new_vals
            if can_skip and not skipped_rank then
                skipped_rank = true
            else
                straight_length = 0
                skipped_rank = false
                if not straight then t = {} end
                if straight then break end
            end
        end
    end
    if not straight then return ret end
    table.insert(ret, t)
    return ret
end


new_item(SMODS.Blind, "arm", {
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
})


table.insert(Cryptid.memepack, "j_matador")

new_item(SMODS.Joker, "matador", {
    config = {extra = {dollar_bonus = 8, odds = 4}},
    name = "ouija-Matador", -- will prevent old calculation code from working
    loc_vars = function (_, info_queue, card)
        return {vars = {card.ability.extra.dollar_bonus}}
    end,
    calculate = function (_, card, context)
        if (context.joker_main or context.debuffed_hand) and G.GAME.blind.boss then
            if pseudorandom("matador_lol") < G.GAME.probabilities.normal / card.ability.extra.odds then
                ease_dollars(card.ability.extra.dollar_bonus)
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollar_bonus
                G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
                return {
                    message = localize('$')..card.ability.extra.dollar_bonus,
                    dollars = card.ability.extra.dollar_bonus,
                    colour = G.C.MONEY
                }
            end
        end
    end,
})


new_item(SMODS.Joker, "hit_the_road", {
    config = {extra = {x_mult = 1.5, jack_count = 0}},
    name = "ouija-Hit the Road", -- will prevent old calculation code from working
    loc_vars = function (_, info_queue, card)
        return {vars = {card.ability.extra.x_mult, card.ability.extra.jack_count}}
    end,
    calculate = function (_, card, context)
        if context.discard and not context.other_card.debuff and context.other_card:get_id() == 11 and not context.blueprint then
            card.ability.extra.jack_count = card.ability.extra.jack_count + 1
            return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.RED,
            }
        end
        if context.cardarea == G.jokers and context.after then
            if card.ability.extra.jack_count == 0 then return end
            card.ability.extra.jack_count = 0
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
        -- Not only there's bug that "Again!" does not show up,
        -- it ends up being retriggered WAY too much if we don't check for retrigger_joker
        -- Default Chad would basically make it nine times as powerful
        if context.joker_main and not context.retrigger_joker and card.ability.extra.jack_count > 0 then
            for i = 1, card.ability.extra.jack_count - 1, 1 do
                context.callback(context.blueprint_card or card, {
                        message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
                        Xmult_mod = card.ability.extra.x_mult
                }, context.retrigger_joker)
            end
            -- Keeping the best compat possible
            return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.x_mult}},
                    Xmult_mod = card.ability.extra.x_mult
            }
        end
    end,
})


new_item(SMODS.Spectral, "black_hole", {
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
})


new_item(SMODS.Enhancement, "stone", {
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
})


new_item(SMODS.Joker, "credit_card", {
    config = {extra = {max_debt = 20, ouija_interest_start = -10}},
    name = "ouija-Credit Card", -- will prevent old calculation code from working
    loc_vars = function (_, info_queue, card)
        return {vars = {card.ability.extra.max_debt, -card.ability.extra.ouija_interest_start}}
    end,
    add_to_deck = function(_, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at - card.ability.extra.max_debt
        G.GAME.ouija_interest_start = G.GAME.ouija_interest_start or 0
        G.GAME.ouija_interest_start = G.GAME.ouija_interest_start + card.ability.extra.ouija_interest_start
    end,
    remove_from_deck = function(_, card, from_debuff)
        G.GAME.bankrupt_at = G.GAME.bankrupt_at + card.ability.extra.max_debt
        G.GAME.ouija_interest_start = G.GAME.ouija_interest_start - card.ability.extra.ouija_interest_start
    end,
})


new_item(SMODS.Back, "magic", {
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
})


new_item(SMODS.Joker, "midas_mask", {
    config = {extra = "Pair", jolly = { t_mult = 8, type = "Pair" }},
    effect = "M Joker",
    name = "ouija-Midas Mask", -- will prevent old calculation code from working
    loc_vars = function (self, info_queue, card)
		info_queue[#info_queue + 1] = {
			set = "Joker",
			key = "j_jolly",
			specific_vars = { self.config.jolly.t_mult, localize(self.config.jolly.type, "poker_hands") },
		}
        if not card.edition or (card.edition and not card.edition.cry_gold) then
            info_queue[#info_queue + 1] = G.P_CENTERS.e_cry_gold
        end
    end,
    calculate = function (_, card, context)
        if
            context.cardarea == G.jokers and
            context.before and
            not context.blueprint and
            not context.retrigger_joker and
            next(context.poker_hands[card.ability.extra])
        then
            local triggered = false
            for i = 1, #G.jokers.cards do
                local joker = G.jokers.cards[i]
                if joker:is_jolly() and not (joker.edition and joker.edition.cry_gold == true) then
                    triggered = true
                    -- Calling it silent so it doesn't mess up with controller locks
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            joker:set_edition({cry_gold = true}, true, true)
                            joker:juice_up(1, 0.5)
                            play_sound("cry_e_golden", 1, 0.3)
                            return true
                        end
                    }))
                end
            end
            if triggered then
                return {
                    message = localize('k_gold'),
                    colour = G.C.MONEY,
                    card = card,
                }
            end
        end
    end
})

Cryptid.M_jokers["j_midas_mask"] = true


new_item(SMODS.Tag, "voucher", {
    name = "ouija-Voucher Tag", -- will prevent old calculation code from working
    apply = function (tag, context)
		if context.type == "voucher_add" then
			tag:yep('+', G.C.SECONDARY_SET.Voucher, function() 
                G.ARGS.voucher_tag = G.ARGS.voucher_tag or {}
                local voucher_key = get_next_voucher_key(true)
                G.ARGS.voucher_tag[voucher_key] = true
                G.shop_vouchers.config.card_limit = G.shop_vouchers.config.card_limit + 1
                local card = Card(G.shop_vouchers.T.x + G.shop_vouchers.T.w/2,
                G.shop_vouchers.T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[voucher_key],{bypass_discovery_center = true, bypass_discovery_ui = true})
                cry_misprintize(card)
                create_shop_card_ui(card, 'Voucher', G.shop_vouchers)
                card:start_materialize()

                if G.GAME.modifiers.cry_force_edition and not G.GAME.modifiers.cry_force_random_edition then
                    card:set_edition(nil, true)
                elseif G.GAME.modifiers.cry_force_random_edition then
                    local edition = cry_poll_random_edition()
                    card:set_edition(edition, true)
                end
            
                if G.GAME.modifiers.cry_force_sticker == 'eternal' or G.GAME.modifiers.cry_sticker_sheet_plus then
                    card:set_eternal(true)
                    card.ability.eternal = true
                end
                if G.GAME.modifiers.cry_force_sticker == 'perishable' or G.GAME.modifiers.cry_sticker_sheet_plus then
                    card:set_perishable(true)
                    card.ability.perishable = true
                end
                if G.GAME.modifiers.cry_force_sticker == 'rental' or G.GAME.modifiers.cry_sticker_sheet_plus then
                    card:set_rental(true)
                    card.ability.rental = true
                end
                if G.GAME.modifiers.cry_force_sticker == 'pinned' or G.GAME.modifiers.cry_sticker_sheet_plus then
                    card.pinned = true
                end
                if G.GAME.modifiers.cry_force_sticker == 'banana' or G.GAME.modifiers.cry_sticker_sheet_plus then
                    card.ability.banana = true
                end
                if G.GAME.modifiers.cry_sticker_sheet_plus then
                    if G.GAME.modifiers.cry_sticker_sheet then
                        for k, v in pairs(SMODS.Stickers) do
                            v:set_sticker(card, true)
                        end
                    end
                end
                G.shop_vouchers:emplace(card)
                G.ARGS.voucher_tag = nil

                card.ability.couponed = true
                card:set_cost()
                
                return true
            end)
            tag.triggered = true
		end
    end
})

local Card_set_cost_ref = Card.set_cost
function Card:set_cost()
    Card_set_cost_ref(self)
    if self.area and self.ability.couponed and (self.area == G.shop_vouchers) then self.cost = 0 end
end


new_item(SMODS.Joker, "dna", {
    name = "ouija-DNA", -- will prevent old calculation code from working
    calculate = function (_, card, context)
        if context.ending_shop and G.deck.cards[1] then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local new_card = copy_card(pseudorandom_element(G.deck.cards, pseudoseed('dna')), nil, nil, G.playing_card)
                    new_card:set_edition({negative = true}, true)
                    new_card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, new_card)
                    G.deck:emplace(new_card)
                    playing_card_joker_effects({true})
                    return true
                end}))
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
            return nil, true
        end
    end
})


new_item(SMODS.Blind, "eye", {
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
})


new_item(SMODS.Joker, "constellation", {
    name = "Ouija-Constellation", -- will prevent old calculation code from working
    config = {extra = {chip_mod = 8, chips = 0}},
    loc_vars = function (_, info_queue, card)
        return {vars = {card.ability.extra.chip_mod, card.ability.extra.chips}}
    end,
    calculate = function (_, card, context)
        if context.joker_main then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        elseif context.ouija_level_up_hand and context.amount >= 1 and not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod * context.amount
            -- Avoids status text from appearing multiple times
            card.ability.status_text_appeared = false
            G.E_MANAGER:add_event(Event({
                func = function()
                    if not card.ability.status_text_appeared then
                        card_eval_status_text(card, 'extra', nil, nil, nil, {
                                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                                colour = G.C.CHIPS
                        })
                        card.ability.status_text_appeared = true
                    end
                    return true
                end}))
            return nil, true
        end
    end
})

local level_up_hand_ref = level_up_hand
function level_up_hand(card, hand, instant, amount)
    local ret = level_up_hand_ref(card, hand, instant, amount)
    for i = 1, #G.jokers.cards do
        G.jokers.cards[i]:calculate_joker({ouija_level_up_hand = true, hand = hand, amount = amount or 1})
    end
    return ret
end


-- Idea from Luigicat11
new_item(SMODS.Tarot, "wheel_of_fortune", {
    use = function (_, card, area, copier)
        local used_tarot = copier or card
        if pseudorandom('wheel_of_fortune') < G.GAME.probabilities.normal/card.ability.extra then
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
})


-- Thanks Tizio a cui Piacciono Cose for giving me ideas for sans
new_item(SMODS.Joker, "mr_bones", {
    name = "Ouija-Mr. Bones",
    calculate = function (_, card, context)
        if context.end_of_round and (not context.blueprint) and context.game_over and not context.retrigger_joker then
            if to_big(G.GAME.chips) / G.GAME.blind.chips >= to_big(0.26) then
                -- Cycles editions like ://REWORK
                local found_index = 1
                if card.edition then
                    for i, v in ipairs(G.P_CENTER_POOLS.Edition) do
                        if v.key == card.edition.key then
                            found_index = i
                            break
                        end
                    end
                end
                found_index = found_index + 1
                if found_index > #G.P_CENTER_POOLS.Edition then
                    found_index = found_index - #G.P_CENTER_POOLS.Edition
                end
                local new_edition = G.P_CENTER_POOLS.Edition[found_index].key
                card:set_edition((new_edition or "e_foil"), true)
                return {
                        message = localize('ouija_last_breath' .. math.random(13)),
                        saved = true,
                        colour = G.C.RED,
                }
            end
        end
    end,
    cost = 1,
})

local G_FUNCS_sell_card_ref = G.FUNCS.sell_card
G.FUNCS.sell_card = function (e)
    local sans = e.config.ref_table
    if sans.config.center.key == "j_mr_bones" then
        G.jokers:unhighlight_all()
        if #G.jokers.cards > 1 then
            local sans_index = nil
            for key, value in pairs(G.jokers.cards) do
                if value == sans then
                    sans_index = key
                    break
                end
            end
            assert(sans_index ~= nil, "Couldn't find sans in G.jokers.cards. Please report this issue")
            local new_index = sans_index - 1
            if sans_index == 1 then
                new_index = 2
            end
            local card_to_swap = G.jokers.cards[new_index]
            G.jokers.cards[sans_index] = nil
            G.jokers.cards[new_index] = nil
            G.jokers.cards[sans_index] = card_to_swap
            G.jokers.cards[new_index] = sans
            G.jokers:set_ranks()
        end
        card_eval_status_text(sans, 'extra', nil, nil, nil, {
                message = localize('ouija_miss'),
                colour = G.C.SECONDARY_SET.Tarot,
        })
        return
    end
    return G_FUNCS_sell_card_ref(e)
end


-- I have to add a variable to playing cards so that they're not drawn "twice" with duplicate jokers
new_item(SMODS.Joker, "walkie_talkie", {
    name = "Ouija-Walkie Talkie",
    config = {},
    loc_vars = function (_, info_queue, card)
        return {vars = {}}
    end,
    calculate = function (_, card, context)
        -- never nesters gonna love this code
        if context.cardarea == G.jokers and context.after then
            G.GAME.ouija_walkie_buffer = G.GAME.ouija_walkie_buffer or 0
            local is_triggered = false
            for index, value in ipairs(context.full_hand) do
                if #G.hand.cards + G.GAME.ouija_walkie_buffer >= G.hand.config.card_limit then
                    -- Reached max hand size, no more room
                    break
                end
                local card_id = value:get_id()
                if (card_id == 10 or card_id == 4) and (not value.debuff) then

                    local id_to_draw = ({[10] = 4, [4] = 10})[card_id]
                    for i = 1, #G.deck.cards do
                        -- draw_card is deferred, so must avoid trying to draw the same card multiple times
                        local card_to_draw = G.deck.cards[i]
                        if card_to_draw:get_id() == id_to_draw and not card_to_draw.ouija_being_drawn then
                            draw_card(G.deck, G.hand, nil, nil, true, card_to_draw)
                            is_triggered = true
                            card_to_draw.ouija_being_drawn = true
                            G.GAME.ouija_walkie_buffer = G.GAME.ouija_walkie_buffer + 1
                            G.E_MANAGER:add_event(Event({func = (function()
                                card_to_draw.ouija_being_drawn = false
                                G.GAME.ouija_walkie_buffer = 0
                                return true
                            end)}))
                            break
                        end
                    end

                end
            end

            if is_triggered then
                return {
                    message = localize('k_received_ex')
                }
            end
        end
    end,
})


-- If a mod wants to add compatibility, ensure it initializes Ouija_dice_jokers by adding this line:
--[[
Ouija_dice_jokers = Ouija_dice_jokers or {}
]]
Ouija_dice_jokers = Ouija_dice_jokers or {}
table.insert(Ouija_dice_jokers, "j_oops")
table.insert(Ouija_dice_jokers, "j_cry_chocolate_dice")

local function get_dice_joker(seed)
    local dice_keys = {}
    for k, v in pairs(Ouija_dice_jokers) do
        if not G.GAME.banned_keys[v] and G.P_CENTERS[v] then
            table.insert(dice_keys, v)
        end
    end
    if #dice_keys <= 0 then
	    return "j_cry_cube"
    else
    	return pseudorandom_element(dice_keys, pseudoseed(seed))
    end
end

-- TODO: Add tooltip for what are dice jokers
new_item(SMODS.Tag, "d_six", {
    config = {type = "store_joker_create"},
    name = "ouija-D6 Tag", -- will prevent old calculation code from working
	apply = function(tag, context)
		if context.type == "store_joker_create" then
			local card
			card = create_card(
				"Joker",
				context.area,
				nil,
				nil,
				nil,
				nil,
				get_dice_joker("ouija_d6")
			)
			create_shop_card_ui(card, "Joker", context.area)
			card.states.visible = false
			tag:yep("+", G.C.GREEN, function()
				card:start_materialize()
				card.ability.couponed = true
                card:set_cost()
				return true
			end)
			tag.triggered = true
			return card
		end
	end,
	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = { set = "Other", key = "dice_jokers" }
		return { vars = {} }
	end,
})


new_item(SMODS.Voucher, "crystal_ball", {
	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
		return { vars = {} }
	end,
})


new_item(SMODS.Joker, "hallucination", {
    loc_vars = function (_, info_queue, card)
        return {vars = {G.GAME.probabilities.normal, card.ability.extra}}
    end,
    name = "ouija-Hallucination", -- will prevent old calculation code from working
    calculate = function (_, card, context)
        if
            context.open_booster and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit and
            pseudorandom('halu'..G.GAME.round_resets.ante) < G.GAME.probabilities.normal/card.ability.extra
        then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.0,
                func = (function()
                    local forced_key = get_random_consumable("hallu")
                    local new_card = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, forced_key.config.center_key, 'hal')
                    new_card:add_to_deck()
                    G.consumeables:emplace(new_card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)}))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_plus_consumeable')})
        end
    end
})


local sinful_jokers = {
    {"greedy_joker", "Diamonds"},
    {"lusty_joker", "Hearts"},
    {"gluttenous_joker", "Clubs"},
}
for _, value in pairs(sinful_jokers) do
    new_item(SMODS.Joker, value[1], {
        config = {extra = {suit_mult = 6, suit = value[2]}},
        effect = "Almost Suit Mult",
        name = "ouija-" .. value[2] .. " Sin Joker", -- will prevent old calculation code from working
        loc_vars = function (_, info_queue, card)
            return {vars = {card.ability.extra.suit_mult, localize(card.ability.extra.suit, 'suits_singular')}}
        end,
        calculate = function (_, card, context)
            if
                context.individual and
                context.cardarea == G.play and
                context.other_card:is_suit(card.ability.extra.suit) and
                context.scoring_name ~= "Flush"
            then
                return {
                    mult = card.ability.extra.suit_mult,
                    card = card,
                }
            end
        end,
    })
end


new_item(SMODS.Joker, "half", {
    cost = 1,
    config = {},
    -- Don't override name since sprite scaling is based on it
    loc_vars = function (_, info_queue, card)
        return {vars = {}}
    end,
    calculate = function (_, card, context)
        if context.cardarea == G.jokers then
            return nil, true
        end
    end,
})

local Blind_set_blind_ref = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
    local ret = Blind_set_blind_ref(self, blind, reset, silent)
    if next(SMODS.find_card("j_half")) then
        -- Background spin
        G.ARGS.spin.real = (G.SETTINGS.reduced_motion and 0 or 1) * (
                self.boss and ((self.config.blind.boss and self.config.blind.boss.showdown) and 0.5 or 0.25) or 0
        )
    end
    return ret
end


new_item(SMODS.Spectral, "soul", {
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
})


-- pseudorandom\((.*?)\) ?< ?G\.GAME\.probabilities\.normal ?\/ ?(.*?)( |\)|$)
-- listed_chance($1, $2)$3