--- STEAMODDED HEADER
--- MOD_NAME: Ouija
--- MOD_ID: Ouija
--- PREFIX: ouija
--- MOD_AUTHOR: [TamerSoup625]
--- MOD_DESCRIPTION: Extension for Cryptid which focuses on modifying vanilla features.
--- BADGE_COLOUR: 0000ff
--- DEPENDENCIES: [Cryptid>=0.5.0, Steamodded>=1.0.0~ALPHA-1030e]
--- VERSION: 0.0.0
--- PRIORITY: 999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999

----------------------------------------------
------------MOD CODE -------------------------


-- TODO: Check if Cryptid features are enabled or not


-- REWORK_HEAVY is when the change is so big it may as well be a new item
-- All decks should always be REWORK_HEAVY
OUIJA_REWORK_LIGHT = 0
OUIJA_REWORK_HEAVY = 1

function Ouija_new_item(smods_gameobject, key, table, rework_val)
    assert(rework_val ~= nil, "Must have a rework value (REWORK_PARTIAL or REWORK_FULL)")
    local loc_vars_func = table.loc_vars or function (self, info_queue, card) return {} end
    table.loc_vars = function (self, info_queue, card)
        -- HACK: This overrides return key
        local ret = loc_vars_func(self, info_queue, card) or {}
        local first_underscore_pos = 0
        for i = 1, string.len(self.key), 1 do
            if string.sub(self.key, i, i) == "_" then
                first_underscore_pos = i
                break
            end
        end
        -- Includes underscore
        local prefix = string.sub(self.key, 1, first_underscore_pos)
        local suffix = string.sub(self.key, first_underscore_pos + 1)
        ret["key"] = prefix .. "ouija_" .. suffix
        return ret
    end
    smods_gameobject:take_ownership(key, table)
end


SMODS.load_file("items/jokers.lua")()
SMODS.load_file("items/consumables.lua")()
SMODS.load_file("items/tags.lua")()
SMODS.load_file("items/vouchers.lua")()
SMODS.load_file("items/blinds.lua")()
SMODS.load_file("items/misc.lua")()


-- pseudorandom\((.*?)\) ?< ?G\.GAME\.probabilities\.normal ?\/ ?(.*?)( |\)|$)
-- listed_chance($1, $2)$3


----------------------------------------------
------------MOD CODE END----------------------