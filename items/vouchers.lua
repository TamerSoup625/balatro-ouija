Ouija_new_item(SMODS.Voucher, "crystal_ball", {
	loc_vars = function(self, info_queue)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
		return { vars = {} }
	end,
}, OUIJA_REWORK_LIGHT)


local create_card_for_shop_ref = create_card_for_shop
function create_card_for_shop(area)
    local ret = create_card_for_shop_ref(area)
    if
        ret.config.center.key == "c_base" and
        G.GAME.used_vouchers["v_magic_trick"] and
        (not G.GAME.used_vouchers["v_illusion"])
    then
        -- Modifications code and chances are from Standard Packs, but cards can also be negative
        if pseudorandom(pseudoseed('magic_enhance'..G.GAME.round_resets.ante)) > 0.6 then
            ret:set_ability(pseudorandom_element(G.P_CENTER_POOLS["Enhanced"], pseudoseed("magic_enhance_what"..G.GAME.round_resets.ante)))
        end
        local edition_rate = 2
        local edi = ret.edition or {}
        if edi.type and not (G.GAME.modifiers.cry_force_edition and G.GAME.modifiers.cry_force_edition ~= 'random') then
            ret:set_edition({[edi.type] = true})
        elseif not G.GAME.modifiers.cry_force_random_edition then
            local edition = poll_edition('magic_edition'..G.GAME.round_resets.ante, edition_rate)
            ret:set_edition(edition)
        end
        ret:set_seal(SMODS.poll_seal({mod = 10}))
    end
    return ret
end

Ouija_new_item(SMODS.Voucher, "magic_trick", {}, OUIJA_REWORK_LIGHT)
Ouija_new_item(SMODS.Voucher, "illusion", {}, OUIJA_REWORK_LIGHT)