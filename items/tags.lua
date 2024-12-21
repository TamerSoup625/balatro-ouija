Ouija_new_item(SMODS.Tag, "voucher", {
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
}, OUIJA_REWORK_LIGHT)

local Card_set_cost_ref = Card.set_cost
function Card:set_cost()
    Card_set_cost_ref(self)
    if self.area and self.ability.couponed and (self.area == G.shop_vouchers) then self.cost = 0 end
end


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
Ouija_new_item(SMODS.Tag, "d_six", {
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
		info_queue[#info_queue + 1] = { set = "Other", key = "ouija_dice_jokers" }
		return { vars = {} }
	end,
}, OUIJA_REWORK_HEAVY)