    

    --  todo: DR/decay
    MODUI_BUFFS_TO_TRACK = {
            -- misc
        ['Invulnerability']        = {
            [[Interface\Icons\Spell_holy_divineintervention]],
            6
        },
        ['Ward of the Eye']        = {
            [[Interface\Icons\spell_totem_wardofdraining]],
            6
        },
            -- racials
        ['Perception']             = {
            [[Interface\Icons\Spell_nature_sleep]],
            20
        },
        ['Stoneform']              = {
            [[Interface\Icons\Spell_shadow_unholystrength]],
            8
        },
        ['Will of the Forsaken']   = {
            [[Interface\Icons\Spell_shadow_raisedead]],
            5
        },
            -- alchemy
        ['Free Action']            = {
            [[Interface\Icons\Inv_potion_04]],
            30
        },
        ['Invulnerability']        = {
            [[Interface\Icons\Inv_potion_04]],
            6
        },
        ['Living Free Action']     = {
            [[Interface\Icons\Inv_potion_07]],
            5
        },
            -- engineering
        ['Flash Bomb']             = {
            [[Interface\Icons\Spell_Shadow_Darksummoning]],
            10
        },
        ['Frost Reflector']        = {
            [[Interface\Icons\Spell_frost_frostward]],
            5
        },
        ['Fire Reflector']         = {
            [[Interface\Icons\Spell_fire_sealoffire]],
            5
        },
        ['Shadow Reflector']       = {
            [[Interface\Icons\Spell_shadow_antishadow]],
            5
        },
            -- druid
        ['Abolish Poison']         = {
            [[Interface\Icons\Spell_nature_nullifypoison_02]],
            8
        },
        ['Nature\'s Grasp']        = {
            [[Interface\Icons\Spell_nature_natureswrath]],
            45
        },
        ['Innervate']              = {
            [[Interface\Icons\Spell_nature_lightning]],
            20
        },
        --['Rejuvenation']           = {[[Interface\Icons\Spell_nature_rejuvenation]], 12},
            -- hunter
        ['Feign Death']            = {
            [[Interface\Icons\Ability_rogue_feigndeath]],
            360
        },
        ['Improved Concussive Shot'] = {
            [[Interface\Icons\Spell_frost_stun]],
            3
        },
            -- mage
        ['Frost Ward']             = {
            [[Interface\Icons\Spell_frost_frostward]],
            30
        },
        ['Fire Ward']              = {
            [[Interface\Icons\Spell_fire_firearmor]],
            30
        },
        ['Ice Block']              = {
            [[Interface\Icons\Spell_frost_frost]],
            10
        },
        --['Ice Barrier']            = {
        --    [[Interface\Icons\Spell_ice_lament]],
        --    60
        --},
            -- paladin
        ['Blessing of Protection'] = {
            [[Interface\Icons\Spell_holy_sealofprotection]],
            8
        },
        ['Blessing of Freedom']    = {
            [[Interface\Icons\Spell_holy_sealofvalor]],
            10
        },
        ['Divine Protection']      = {
            [[Interface\Icons\Spell_holy_restoration]],
            8
        },
            -- priest
        ['Power Infusion']         = {
            [[Interface\Icons\Spell_holy_powerinfusion]], 
            20
        },
        ['Power Word: Shield']     = {
            [[Interface\Icons\Spell_holy_powerwordshield]],
            30
        },
            -- rogue
        ['Vanish']                 = {
            [[Interface\Icons\Ability_vanish]],
            10
        },
        ['Gouge']                  = {
            [[Interface\Icons\Ability_gouge]],
            5
        }
            -- warlock
        -- ['Shadow Trance'] = {'Interface\\Icons\\Spell_shadow_twilight', 10},
    }

     MODUI_DEBUFFS_TO_TRACK = {
            -- MISC
        ['Flee']                     = {[[Interface\Icons\spell_magic_polymorphchicken]], 10},
        ['Reckless Charge']          = {[[Interface\Icons\Spell_nature_astralrecal]], 12},
        ['Sleep']                    = {[[Interface\Icons\Spell_nature_sleep]], 12},
        ['Tidal Charm']              = {[[Interface\Icons\Spell_frost_summonwaterelemental]], 3},
            -- BLACKWING LAIR
        ['Burning Adrenaline']       = {[[Interface\Icons\Spell_shadow_unholystrength]], 20, 'None'},
            -- MOLTEN CORE
        ['Living Bomb']              = {[[Interface\Icons\Inv_enchant_essenceastralsmall]], 8, 'None'},
            -- ENGINEERING
        ['Iron Grenade']             = {[[Interface\Icons\Spell_fire_selfdestruct]], 3, 'None'},
        ['Net-o-Matic']              = {[[Interface\Icons\ability_ensnare]], 10},
        ['Thorium Grenade']          = {[[Interface\Icons\Spell_fire_selfdestruct]], 3, 'None'},
            -- DRUID
        ['Hibernate']                = {[[Interface\Icons\Spell_nature_sleep]], 40, 'Magic'},
            -- HUNTER
        ['Freezing Trap']            = {[[Interface\Icons\Spell_frost_chainsofice]], 20, 'Magic'},
        ['Scare Beast']              = {[[Interface\Icons\Ability_druid_cower]], 20, 'Magic'},
            -- MAGE
        ['Polymorph']                = {[[Interface\Icons\Spell_nature_polymorph]], 50, 'Magic'},
        ['Polymorph: Pig']           = {[[Interface\Icons\Spell_magic_polymorphpig]], 50, 'Magic'},
        ['Polymorph: Turtle']        = {[[Interface\Icons\Ability_hunter_pet_turtle]], 50, 'Magic'},
            -- PALADIN
        ['Hammer of Justice']        = {[[Interface\Icons\Spell_holy_sealofmight]], 6, 'Magic'},
        ['Repentance']               = {[[Interface\Icons\Spell_holy_prayerofhealing]], 6, 'Magic'},
            -- PRIEST
        ['Mind Control']             = {[[Interface\Icons\Spell_shadow_siphonmana]], 3, 'None'},
        ['Mind Vision']              = {[[Interface\Icons\Spell_holy_mindvision]], 60, 'None'},
        ['Psychic Scream']           = {[[Interface\Icons\Spell_shadow_psychicscream]], 8, 'None'},
            -- ROGUE
        ['Blind']                    = {[[Interface\Icons\Spell_shadow_mindsteal]], 10, 'Poison'},
        ['Cheap Shot']               = {[[Interface\Icons\Ability_cheapshot]], 5, 'None'},
        ['Gouge']                    = {[[Interface\Icons\Ability_gouge]], 4, 'None'},
        ['Kidney Shot']              = {[[Interface\Icons\Ability_rogue_kidneyshot]], 6, 'None'},
        ['Sap']                      = {[[Interface\Icons\Ability_sap]], 11},
            -- WARLOCK
        ['Curse of Exhaustion']      = {[[Interface\Icons\Spell_shadow_grimward]], 12, 'Curse'},
        ['Curse of Tongues']         = {[[Interface\Icons\Spell_shadow_curseoftounges]], 30, 'Curse'},
        ['Death Coil']               = {[[Interface\Icons\Spell_shadow_deathcoil]], 3, 'Magic'},
        ['Drain Mana']               = {[[Interface\Icons\Spell_shadow_siphonmana]], 5, 'Magic'},
        ['Fear']                     = {[[Interface\Icons\Spell_shadow_possession]], 20, 'Magic'},
        ['Howl of Terror']           = {[[Interface\Icons\Spell_shadow_deathscream]], 15, 'Magic'},
            -- WARRIOR
        ['Charge Stun']              = {[[Interface\Icons\Spell_frost_stun]], 1, 'None'},
        ['Intercept Stun']           = {[[Interface\Icons\Spell_frost_stun]], 3, 'None'},
    }

    MODUI_DEBUFF_REFRESHING_SPELLS = {
            -- druid
            ['Moonfire']                    = {
                'Moonfire'
            },
            ['Rake']                        = {
                'Rake'
            },
            -- hunter
            ['Wing Clip']                   = {
                'Wing Clip',
            },
            -- mage
            ['Fireball']                    = {
                'Fireball',
            },       
            ['Blizzard']                    = {
                'Winter\'s Chill',
            },
            ['Cone of Cold']                = {
                'Winter\'s Chill',
            },
            ['Frost Nova']                  = {
                'Winter\'s Chill',
            },
            ['Frostbolt']                   = {
                'Frostbolt', 
                'Winter\'s Chill',
            },
            ['Scorch']                      = {
                'Improved Scorch',
            },
            -- paladin
            ['Judgement of the Crusader']   = {
                'Judgement of the Crusader',
                }, 
            ['Judgement of Justice']        = {
                'Judgement of Justice',
            }, 
            ['Judgement of Light']          = {
                'Judgement of Light',
            },
            ['Judgement of Wisdom']         = {
                'Judgement of Wisdom',
            },
            -- PRIEST
            ['Mind Flay']                   = {
                'Shadow Vulnerability',
            },
            ['Mind Blast']                  = {
                'Shadow Vulnerability',
            },
            ['Shadow Vulnerability']        = {
                'Shadow Vulnerability',
            },
            -- ROGUE
            ['Hemorrhage']                  = {
                'Hemorrhage',
            },
            ['Wound Poison IV']             = {
                'Wound Poison IV',
            },
            ['Deadly Poison V']             = {
                'Deadly Poison V',
            },
            -- SHAMAN
            ['Flame Shock']                 = {
                'Flame Shock',
            },
            ['Frost Shock']                 = {
                'Frost Shock',
            },
            -- WARLOCK
            ['Immolate']                    = {
                'Immolate',
            },
            -- WARRRIOR
            ['Hamstring']                   = {
                'Hamstring',
            },
            ['Mortal Strike']               = {
                'Mortal Strike',
            },
        }

    --
