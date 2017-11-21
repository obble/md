

    local offset    = 222                  -- X OFFSET FOR TEXT
    local gsub      = string.gsub
    local f         = CreateFrame'Frame'
    local msgType, dType, modType, message, info, colour

    local H = {}

    local textoverrides = {
        ['*'] = {
            isStaggered = nil,
        },
        ['AURA_END'] = {
            r = .4,
            g = .7,
            b = .4,
        },
        ['AURA_END_HARMFUL'] = {
            r = .7,
            g = .4,
            b = .4,
         },
    }

    local textsubs = {
        ['*'] = {                       -- all msgs
            ['<'] = '',                 -- remove brackets
            ['>'] = '',                 --
        },
        ['AURA_START'] = {
            APPEND = {'+ ', ''},        -- + buff
        },
        ['AURA_END'] = {
            APPEND = {'- ', ''},        -- - buff
            [' fades'] = '',
        },
        ['AURA_START_HARMFUL'] = {
            APPEND = {'+ ', ''},        -- + debuff
        },
        ['AURA_END_HARMFUL'] = {
            APPEND = {'- ', ''},        -- - debuff
            [' fades'] = '',
        },
        ['ENTERING_COMBAT'] = {
            APPEND = {'+ ', ''},        -- + combat
            ['Entering '] = '',
        },
        ['LEAVING_COMBAT'] = {
            APPEND = {'- ', ''},        -- - combat
            ['Leaving '] = '',
        },
        ['INCOMING_MANA'] = {
            APPEND = {'+ ', ''},        -- + mana
        },
        ['OUTGOING_DMG'] = {
            APPEND = {'>> ', ''},       -- >> yr dmg
        },
        ['OUTGOING_DMG_CRIT'] = {
            APPEND = {'!> ', ''},       -- !> yr critical dmg
        },
        ['OUTGOING_HEALING'] = {
            APPEND = {'+> ', ''},       -- +> yr heal
        },
        ['OUTGOING_HEALING_CRIT'] = {
            APPEND = {'+!> ', ''},      -- +!> yr critical heal
        },
    }

    local events = {
        ['UNIT_HEALTH']             = 'HEALTH_LOW',
        ['UNIT_MANA']               = 'MANA_LOW',
        ['PLAYER_REGEN_DISABLED']   = 'ENTERING_COMBAT',
        ['PLAYER_REGEN_ENABLED']    = 'LEAVING_COMBAT',
        ['PLAYER_COMBO_POINTS']     = 'COMBO_POINTS',
    }

    local GetDmg = function(arg1, arg2)
        local h = 'Your (.+) hits (.+) for (.+)'  local hit  = string.find(arg1, h)
        local c = 'Your (.+) crits (.+) for (.+)' local crit = string.find(arg1, c)

        if  hit or crit then
            local m = hit and h or crit and c
            local t = gsub(arg1, '(.+) (.+) damage.', '%2')

            if t then colour = SPELL_SCHOOL_COLORS[t] else colour = {r =  1, g =  1, b =  0} end

            arg2    = gsub(arg1, m, '%3')  arg2 = gsub(arg2, '(.+) (.+) damage.', '%1')
            msgType = crit and 'OUTGOING_DMG_CRIT' or 'OUTGOING_DMG'
            info    = crit and COMBAT_TEXT_TYPE_INFO['OUTGOING_DMG_CRIT'] or COMBAT_TEXT_TYPE_INFO['OUTGOING_DMG']
            message = arg2
        end

        return msgType, colour, info, message
    end

    local GetHeal = function(arg1, arg2)
        local h    = 'Your (.+) heals (.+) for (.+).'            local heal = string.find(arg1, h)
        local c    = 'Your (.+) critically heals (.+) for (.+).' local crit = string.find(arg1, c)
        local hot  = '(.+) gains (.+) health from your (.+).'

        if  heal or crit then
            arg2 = gsub(arg1, h, '%3 — %2')

            if string.find(arg2, '(.+) — you') then return end

            msgType = crit and 'OUTGOING_HEALING_CRIT' or 'OUTGOING_HEALING'
            colour  = {r = .1, g = .7, b = .65}
            info    = crit and COMBAT_TEXT_TYPE_INFO['OUTGOING_HEALING_CRIT'] or COMBAT_TEXT_TYPE_INFO['OUTGOING_HEALING']
            message = arg2
        end

        return msgType, colour, info, message
    end

    local logic = function(msg, k, v)
        if  type(v) == 'table' and k == 'APPEND' then
            msg = (v[1] or '')..msg..(v[2] or '')
        elseif type(v) == 'function' and k == 'FUNC' then
            msg = v(msg) or msg
        else
            msg = gsub(msg, k, v)
        end
        return msg
    end


    local handler = function(e)
        local var = MODUI_VAR['combattext']

        if  events[e] then
            msgType = events[e]
        elseif event == 'COMBAT_TEXT_UPDATE' then
            msgType = arg1
        elseif event == 'CHAT_MSG_SPELL_SELF_DAMAGE' then
            if  var.damage then
                msgType, colour, info, message = GetDmg(arg1, arg1)
            end
        elseif event == 'CHAT_MSG_SPELL_SELF_BUFF' then
            if  var.healing then
                msgType, colour, info, message = GetHeal(arg1, arg2)
            end
        else
            msgType = e
        end

        if  message and colour then
        	CombatText_AddMessage(message, COMBAT_TEXT_SCROLL_FUNCTION, colour.r, colour.g, colour.b, dType, isStaggered)
            message = nil info = nil colour = nil
        end
    end

    local update = function(e)
        for  i, v in COMBAT_TEXT_TO_ANIMATE do
            if  v.scrollTime >= COMBAT_TEXT_SCROLLSPEED then
                CombatText_RemoveMessage(v)
                if v.dType then v.dType = nil end
            else
                v.scrollTime = v.scrollTime + e

                    -- insert dtype
                if  not v.dType then
                    local t = v:GetText()
                    if string.find(t, '-') then
                        v.dType = 'minus'
                    elseif string.find(t, '+') or string.find(t, '>') then
                        v.dType = 'plus'
                    else
                        v.dType = 'minus'
                    end
                end

                local x
                local _, y = v.scrollFunction(v)

                if  v.dType == 'minus' then
                    x = offset
                elseif v.dType == 'plus' then
                    x =  -offset
                else
                    x = 0
                end

                v:SetPoint('TOP', UIParent, 'BOTTOM', x, y)
            end
        end
    end

    function f:AddGlobals()
        H.CombatText_UpdateDisplayedMessages            = CombatText_UpdateDisplayedMessages
        H.CombatText_AddMessage                         = CombatText_AddMessage
        H.CombatText_OnEvent                            = CombatText_OnEvent
        H.CombatText_GetAvailableString                 = CombatText_GetAvailableString
        H.CombatText_OnUpdate                           = CombatText_OnUpdate

        COMBAT_TEXT_HEIGHT                             = 18  -- SIZE
        COMBAT_TEXT_SCROLLSPEED                        = 3   -- ANIMSPEED
        COMBAT_TEXT_FADEOUT_TIME                       = 2   -- FADE
        COMBAT_TEXT_CRIT_MAXHEIGHT                     = 30  -- CRIT SIZE MAX
        COMBAT_TEXT_CRIT_MINHEIGHT                     = 20  -- CRIT SIZE MIN

        COMBAT_TEXT_TYPE_INFO['OUTGOING_DMG']          = {r = .9, g = .7, b = .1,  show = 1}
        COMBAT_TEXT_TYPE_INFO['OUTGOING_DMG_CRIT']     = {r = .9, g = .7, b = .1,  show = 1}
        COMBAT_TEXT_TYPE_INFO['OUTGOING_HEALING']      = {r = .1, g = .7, b = .65, show = 1}
        COMBAT_TEXT_TYPE_INFO['OUTGOING_HEALING_CRIT'] = {r = .1, g = .7, b = .65, show = 1}

        CombatText:RegisterEvent'CHAT_MSG_SPELL_SELF_BUFF'
        CombatText:RegisterEvent'CHAT_MSG_SPELL_SELF_DAMAGE'
    end

    function f:ApplyOverrides()
        for type,table in pairs(COMBAT_TEXT_TYPE_INFO) do
            for k,v in pairs(textoverrides['*']) do
                table[k] = v
            end
            if textoverrides[type] then
                for k,v in pairs(textoverrides[type]) do
                    table[k] = v
                end
            end
        end
    end

    function f:AddStyle()
        for i = 1, 20 do
            local f     = _G['CombatText'..i]
            local font  = _G['SystemFont']
            f:SetFontObject(font)
        end
    end

    function f:AddSubs(msg, msgType)
        for k, v in pairs(textsubs['*']) do msg = logic(msg, k, v) end
        if  textsubs[msgType] then
            for k, v in pairs(textsubs[msgType]) do msg = logic(msg, k, v) end
        end
        return msg
    end

    local OnEvent = function(e)
        handler(e)
        H.CombatText_OnEvent(e)
    end

    local AddMessage = function(msg, scrollFunction, r, g, b, dType, isStaggered)
        local msg = f:AddSubs(msg, msgType)
        H.CombatText_AddMessage(msg, scrollFunction, r, g, b, dType, isStaggered)
    end

    local OnUpdate = function(e)
        H.CombatText_OnUpdate(e)
        update(e)
    end

    local UpdateDisplayedMessages = function()
        H.CombatText_UpdateDisplayedMessages()
        if  SHOW_COMBAT_TEXT == '0' then
            CombatText:UnregisterEvent'CHAT_MSG_SPELL_SELF_BUFF'
            CombatText:UnregisterEvent'CHAT_MSG_SPELL_SELF_DAMAGE'
        else
            CombatText:RegisterEvent'CHAT_MSG_SPELL_SELF_BUFF'
            CombatText:RegisterEvent'CHAT_MSG_SPELL_SELF_DAMAGE'
        end
    end

    f:RegisterEvent'ADDON_LOADED'
    f:SetScript('OnEvent', function()
        if  event == 'ADDON_LOADED' then
            if  arg1 == 'Blizzard_CombatText' then
                -- modify or add globals, register new events
                f:AddGlobals()
                -- initialise string subs
                f:ApplyOverrides()
                -- style strings
                f:AddStyle()
                -- insert functions
                CombatText_AddMessage                = AddMessage
                CombatText_OnEvent                   = OnEvent
                CombatText_OnUpdate                  = OnUpdate
                CombatText_UpdateDisplayedMessages   = UpdateDisplayedMessages
            end
        end
    end)

    --
