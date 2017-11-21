

    MODUI_BERSERK = 0

    MODUI_PLAYERSPELLCAST_MODIFIERS = {
        ['Interface\\Icons\\Ability_Warrior_InnerRage']     = 1.3,
        ['Interface\\Icons\\Ability_Hunter_RunningShot']    = 1.4,
        ['Interface\\Icons\\Racial_Troll_Berserk']          = MODUI_BERSERK,
        ['Interface\\Icons\'Inv_Trinket_Naxxramas04']       = 1.2,
        ['Interface\\Icons\\Spell_Shadow_CurseOfTounges']   = .5
    }


    MODUI_TIME_MODIFIER_BUFFS_TO_TRACK = {
        ['Barkskin']                    = {1.4, {'all'}},
        ['Burning Adrenaline']          = {0,   {'all'}},
        ['Curse of Tongues']            = {1.6, {'all'}},
        ['Curse of the Eye']            = {1.2, {'all'}},
        ['Fang of the Crystal Spider']  = {1.1, {'all'}},
        ['Fel Domination']              = {.05,
            {
	            'Summon Felhunter',
	            'Summon Imp',
	            'Summon Succubus',
	            'Summon Voidwalker',
        	}
        },
        ['Mind-numbing Poison']         = {1.6, {'all'}},
        ['Nature\'s Swiftness']         = {0,
            {   -- shaman
	            'Chain Heal',
	            'Far Sight',
	            'Ghost Wolf',
	            'Healing Wave',
	            'Lesser Healing Wave', 
	            'Lightning Bolt',
	            -- druid
	            'Entangling Roots',
	            'Healing Touch',
	            'Hibernate',
	            'Rebirth',
	            'Regrowth',
	            'Soothe Animal',
	            'Wrath',
	       	}
        },
        ['Rapid Fire']	              = {.6, 	{'Aimed Shot'}},
        ['Shadow Trance']             = {0,  	{'Shadow Bolt'}},
        ['Presence of Mind']          = {0,
            {
	           	'Conjure Food', 
	           	'Conjure Water', 
	           	'Conjure Mana Agate', 
	           	'Conjure Mana Citrine', 
	           	'Conjure Mana Jade', 
	           	'Conjure Mana Ruby',
	            'Fireball', 
	            'Frostbolt', 
	            'Flamestrike',
	            'Polymorph', 
	            'Polymorph: Pig', 
	            'Polymorph: Turtle', 
	            'Pyroblast',
	            'Scorch',
        	}
        },
        ['Mind Quickening']          = {.66,
           {
	           	'Conjure Food', 
	           	'Conjure Water', 
	           	'Conjure Mana Agate', 
	           	'Conjure Mana Citrine', 
	           	'Conjure Mana Jade', 
	           	'Conjure Mana Ruby',
	            'Fireball', 
	            'Frostbolt', 
	            'Flamestrike',
	            'Polymorph', 
	            'Polymorph: Pig', 
	            'Polymorph: Turtle', 
	            'Pyroblast',
	            'Scorch',
        	}
    }

    --