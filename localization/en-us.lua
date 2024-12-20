return {
    descriptions = {
        Back = {
            b_magic={
                name="Magic Deck",
                text={
                    "Start run with",
                    "{C:attention}2{} {C:dark_edition}Negative{} copies",
                    "of {C:tarot,T:c_fool}The Fool{}",
                    "Only {C:tarot}Tarot Cards{} appear in shop",
                },
            },
            b_erratic={
                name="Erratic Deck",
                text={
                    "All {C:attention}cards{} in deck",
                    "are of the same",
                    "{C:attention}Suit{} and {C:attention}Rank{}",
                },
            },
        },
        Blind = {
            bl_arm={
                name="The Arm",
                text={
                    "Multiply level of played",
                    "poker hand by 2/3",
                },
            },
            bl_eye={
                name="The Eye",
                text={
                    "-2X score on",
                    "first hand of round",
                },
            },
        },
        Joker = {
            j_ancient = {
                name="Ancient Joker",
                text={
                    "Each played card with",
                    "{V:1}#2#{} suit gives",
                    "{X:mult,C:white} X#1# {} Mult when scored,",
                    -- Reference to Castle/Mail/Idol, since suit is now deck-based
                    "{s:0.8}suit changes every round",
                },
            },
            j_flower_pot={
                name="Flower Pot",
                text={
                    "{X:mult,C:white} X#1# {} Mult if scoring cards",
                    "of played hand contain",
                    "all {C:attention}4{} suits in total",
                },
                unlock={
                    "Reach Ante",
                    "level {E:1,C:attention}#1#",
                },
            },
            j_four_fingers={
                name="Four Fingers",
                text={
                    "All {C:attention}Flushes{} and",
                    "{C:attention}Straights{} can be made",
                    "with {C:attention}#1#{} or more cards",
                },
            },
            j_matador={
                name="Matador",
                text={
                    "Earn {C:money}$#1#{} if played",
                    "hand triggers the",
                    "{C:attention}Boss Blind{} ability",
                    "{C:inactive,s:0.8}But when, exactly?",
                },
                unlock={
                    "Defeat a Boss Blind",
                    "in {E:1,C:attention}1 hand{} without",
                    "using any discards",
                },
            },
            j_hit_the_road={
                name="Hit the Road",
                text={
                    "Each discarded {C:attention}Jack{} gives",
                    "{X:mult,C:white} X#1# {} Mult for the next hand",
                    "{C:inactive}(Currently {C:attention}#2#{C:inactive} Jacks)",
                },
                unlock={
                    "Discard {E:1,C:attention}5",
                    "{E:1,C:attention}Jacks{} at the",
                    "same time",
                },
            },
            j_credit_card={
                name="Credit Card",
                text={
                    "Go up to {C:red}-$#1#{} in debt",
                    "Start gaining interest at {C:red}-$#2#"
                },
            },
            j_midas_mask={
                name="Midas Mask",
                text={
                    "All {C:attention}Jolly Jokers{} become",
                    "{C:dark_edition}Golden{} if played hand",
                    "contains a {C:attention}Pair",
                    "{C:inactive,s:0.8}m",
                },
            },
            j_dna={
                name="DNA",
                text={
                    "Creates a {C:dark_edition}Negative{} copy of",
                    "{C:attention}1{} random {C:attention}playing card{}",
                    "in your possession",
                    "at the end of the {C:attention}shop",
                },
            },
            j_constellation={
                name="Constellation",
                text={
                    "This Joker gains",
                    "{C:chips}+#1#{} Chips for each",
                    "{C:attention}poker hand{} level up",
                    "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)",
                },
            },
            j_mr_bones={
                name="Mr. Bones",
                text={
                    "Prevents Death",
                    "if chips scored",
                    "are at least {C:attention}26%",
                    "of required chips",
                    "{S:1.1,C:red,E:2}self destructs?{}",
                },
                unlock={
                    "Lose {C:attention,E:1}#1#{} runs",
                    "{C:inactive}(#2#)",
                },
            },
            j_walkie_talkie={
                name="Walkie Talkie",
                text={
                    "Draw a {C:attention}10{} for each played {C:attention}4",
                    "Draw a {C:attention}4{} for each played {C:attention}10",
                    "{C:inactive}(Must have room, draw if possible)"
                },
            },
            j_hallucination={
                name="Hallucination",
                text={
                    "{C:green}#1# in #2#{} chance to create a",
                    "random {C:attention}consumable{} when",
                    "any {C:attention}Booster Pack{} is opened",
                    "{C:inactive}(Must have room)",
                },
            },
            j_greedy_joker={
                name="Greedy Joker",
                text={
                    "Played cards with {C:diamonds}#2#{} suit",
                    "give {C:mult}+#1#{} Mult when scored",
                    "if played hand is {C:red}not{} a {C:attention}Flush",
                },
            },
            j_lusty_joker={
                name="Lusty Joker",
                text={
                    "Played cards with {C:hearts}#2#{} suit",
                    "give {C:mult}+#1#{} Mult when scored",
                    "if played hand is {C:red}not{} a {C:attention}Flush",
                },
            },
            j_gluttenous_joker={
                name="Gluttonous Joker",
                text={
                    "Played cards with {C:clubs}#2#{} suit",
                    "give {C:mult}+#1#{} Mult when scored",
                    "if played hand is {C:red}not{} a {C:attention}Flush",
                },
            },
            j_half={
                name="Half Joker",
                text={
                    "All {C:attention}Blinds{} count",
                    "as {C:attention}Boss Blinds",
                },
            },
            j_seeing_double={
                name="Seeing Double",
                text={
                    "If {C:attention}first hand{} of round is",
                    "a single {C:attention}7{} of {C:clubs}Clubs{},",
                    "destroy it and create",
                    "an {C:red}ULTRAKILL{} Joker",
                },
                unlock={
                    "Play a hand",
                    "that contains",
                    "{E:1,C:attention}#1#",
                },
            },
            j_chicot={
                name="Chicot",
                text={
                    "Disables effect of",
                    "every {C:attention}Boss Blind",
                    "{X:dark_edition,C:white}^#1#{} Mult against {C:attention}Boss Blinds",
                },
                unlock={
                    "{E:1,s:1.3}?????",
                },
            },
        },
        Tag = {
            tag_voucher={
                name="Voucher Tag",
                text={
                    "Adds one free {C:voucher}Voucher",
                    "to the next shop",
                },
            },
            tag_d_six={
                name="D6 Tag",
                text={
                    "Shop has a free",
                    "{C:green}Dice{} Joker",
                },
            },
        },
        Tarot = {
            c_wheel_of_fortune={
                name="The Wheel of Fortune",
                text={
                    "{C:green}#1# in #2#{} chance to add",
                    "a random {C:dark_edition}Edition",
                    "to a random {C:attention}Joker",
                },
            },
            c_sun={
                name="The Sun",
                text={
                    "Converts up to",
                    "{C:attention}#1#{} selected card(s)",
                    "to a {C:attention}King{} of {C:hearts}Hearts",
                },
            },
        },
        Spectral = {
            c_hex = {
                name = "Hex",
                text = {
                    "Add {C:dark_edition}Astral{} to a",
                    "random {C:attention}Joker{}, destroy",
                    "all other Jokers",
                },
            },
            c_black_hole={
                name="Black Hole",
                text={
                    "Upgrade every",
                    "{C:legendary,E:1}poker hand",
                    "by {C:attention}3{} levels",
                },
            },
            c_soul={
                name="The Soul",
                text={
                    "Creates a {C:dark_edition}Negative",
                    "{C:legendary,E:1}Legendary{} Joker",
                },
            },
        },
        Enhanced = {
            m_stone = {
                name="Stone Card",
                text={
                    "{X:chips,C:white}X#1#{} Chips",
                    "no rank or suit",
                },
            }
        },
        Voucher = {
            v_crystal_ball={
                name="Crystal Ball",
                text={
                    "{C:attention}+1{} consumable slot",
                    "{C:tarot}The Fool{} is more likely",
                    "to appear in shop",
                },
            },
            v_magic_trick={
                name="Magic Trick",
                text={
                    "{C:attention}Playing cards{} can be",
                    "purchased from the {C:attention}shop",
                    "and may have {C:green}modifications",
                    "{C:inactive,s:0.7}(ex. Enhancements, Seals, Editions)",
                },
            },
            v_illusion={
                name="Illusion",
                text={
                    "{C:attention}Playing cards{} cannot",
                    "have a {C:attention}Seal{} in shop",
                    "{C:cry_code,s:0.5}(https://discord.com/channels/1116389027176787968/1214601062166822983)",
                },
                unlock={
                    "Buy a total of",
                    "{C:attention}#1#{} playing cards",
                    "from the shop",
                    "{C:inactive}(#2#)",
                },
            },
        },
        Other = {
            dice_jokers = {
                name = "Dice Jokers",
                text = {
                    "{s:0.8}Oops! All 6s,",
                    "{s:0.8}Chocolate Die,",
                    "{s:0.8}etc.",
                },
            },
            ultrakill_jokers = {
                name = "ULTRAKILL Jokers",
                text = {
                    "Set of {C:red}Rare{} Jokers:",
                    "{s:0.8}Garden of Forking Paths,",
                    "{s:0.8}Light Up the Night,",
                    "{s:0.8}No Sound, No Memory,",
                    "{s:0.8}...Like Antennas to Heaven",
                },
            },
        },
    },
    misc = {
        dictionary = {
            ouija_last_breath1  = "Last Breath!",
            ouija_last_breath2  = "heh.",
            ouija_last_breath3  = "get ready...",
            ouija_last_breath4  = "get dunked on!",
            ouija_last_breath5  = "poder político!",
            ouija_last_breath6  = "i have to continue...",
            ouija_last_breath7  = "this is your punishment.",
            ouija_last_breath8  = "don't you get it?",
            ouija_last_breath9  = "not my final form...",
            ouija_last_breath10 = "prepare for the worst!",
            ouija_last_breath11 = "i remember you're genocides",
            ouija_last_breath12 = "Saved!",
            ouija_last_breath13 = "¤¤¤¤¤¤¤¤¤¤",
            ouija_miss = "Miss",
            k_received_ex = "Received!",
            k_plus_consumeable = "+1 Consumable",
        },
    },
}