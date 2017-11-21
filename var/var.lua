

    MODUI_VAR = {
        --  uiparent position delegate
        --          nb: this could be extended into a table of elements to toggle
        --              on and off individually.
        ['align']           = true,
        --  aura
        ['aura']            = {
            format          = false,
        },
        --  ux colours
        ['colour']          = {
            r               = 1,
            g               = 1,
            b               = 1,
        },
        ['chat']            = {
            editbox         = true,      --  editbox on top of chat
            ilink           = true,      --  strip [brackets] off've items in chat
            tformat         = true,      --  custom text strings
            tstamps         = true,      --  timestamps
        },
        --  combat text
        --      MODUI_VAR['elements'].combattext dependent
        ['combattext']      = {
            healing         = false,     --  outgoing healing
            damage          = false,     --  outgoing damage
        },
        --  enable/disable
        ['elements']        = {
            targetaura      = false,     --  true: 16 buffs on target always, false: 16 on mouseover
            actionbar       = true,
            inventory       = true,
            castbar         = false,
            chat            = true,
            clock           = {
                twentyfour  = true,
                stopwatch   = true,
            },
            questchat       = true,
            combattext      = true,
            cooldown_text   = true,
            e_castbar       = true,
            hotkeys         = true,
            keypress        = {
                onself      = true,
                down        = true,
            },
            map             = {
                mini        = true,
                dungeon     = true,
                pvp         = true,
                world       = true,
            },
            nameplate       = {
                enable      = true,
                pets        = false,
            },
            pvp             = true,
            quest           = true,
            skin            = true,
            bu_skin         = {
                enable      = true,
                r           = .7,
                g           = .7,
                b           = .7,
            },
            tooltip         = true,
            unit            = {
                enable      = true,
                player      = true,
                target      = true,
                party       = true,
                tot         = true,
                pet         = true,
                raid        = true,
                value       = {
                    percent = true,
                    truth   = true,
                    both    = false,    -- overrides 'truth' values
                    colour  = true,
                },
                auras       = false,    -- true: target auras above frame
                                        -- false: below (default)
            },
        },
        ['statusbar']       = {
            texture         = true,     --  custom statusbar texture on unitframe etc
            smooth          = true,     --  smooth animating value changes
        },
        --  population query switch
        ['who'] = false,
    }

    local cV = function(var, j, event)
        SetCVar(var, j, event)
    end

     --
