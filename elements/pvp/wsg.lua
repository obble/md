
    local e = CreateFrame'Frame'
    local T = 0

    local events = {
        'PLAYER_ENTERING_WORLD',
        'ZONE_CHANGED_NEW_AREA',
        'CHAT_MSG_BG_SYSTEM_ALLIANCE',
        'CHAT_MSG_BG_SYSTEM_HORDE'
    }

    local AddCarriers = function()
        WorldStateAlwaysUpFrame.h = WorldStateAlwaysUpFrame:CreateFontString(nil, 'OVERLAY')
        WorldStateAlwaysUpFrame.h:SetFontObject(GameFontNormalSmall)
        WorldStateAlwaysUpFrame.h:SetTextColor(0, .8, .5)
        WorldStateAlwaysUpFrame.h:SetJustifyH'LEFT'
        WorldStateAlwaysUpFrame.h:SetPoint('TOPLEFT', UIParent, 'TOP', 40, -32)
        WorldStateAlwaysUpFrame.h:Hide()

        local ho = CreateFrame('Button', 'modui_hordeFC', WorldStateAlwaysUpFrame)
        ho:SetFrameLevel(2)
        ho:SetAllPoints(WorldStateAlwaysUpFrame.h)
        ho:EnableMouse(true)
        ho:Hide()

        WorldStateAlwaysUpFrame.a = WorldStateAlwaysUpFrame:CreateFontString(nil, 'OVERLAY')
        WorldStateAlwaysUpFrame.a:SetFontObject(GameFontNormalSmall)
        WorldStateAlwaysUpFrame.a:SetTextColor(1, 0, 0)
        WorldStateAlwaysUpFrame.a:SetJustifyH'LEFT'
        WorldStateAlwaysUpFrame.a:SetPoint('TOPLEFT', UIParent, 'TOP', 40, -55)
        WorldStateAlwaysUpFrame.a:Hide()

        local al = CreateFrame('Button', 'modui_allianceFC', WorldStateAlwaysUpFrame)
        al:SetFrameLevel(2)
        al:SetAllPoints(WorldStateAlwaysUpFrame.a)
        al:EnableMouse(true)
        al:Hide()
    end

    local AddTitleCasing = function(first, rest)
        return string.upper(first)..string.lower(rest)
    end

    local UpdateCarriers = function()
        local  f = WorldStateAlwaysUpFrame
        for _, v in pairs(
            {
                f.a, 
                f.h
            }
        ) do 
            v:SetText''
            v:Hide()
        end
        for k, v in pairs(MODUI_CARRIERS) do
            local t = k == 'Alliance' and f.a or f.h
            local n = gsub(v, '(%a)([%w_\']*)', AddTitleCasing)
            t:SetText(n)
            t:Show()
        end
    end

    local OnUpdate = function()
        if  GetTime() > T then
            e:SetScript('OnUpdate', nil)
            UpdateCarriers()
        end
    end

    local OnEvent = function()
        if  event == 'PLAYER_ENTERING_WORLD' then
            AddCarriers()
        end
        T = GetTime() + .1
        e:SetScript('OnUpdate', OnUpdate)
    end

    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)

    --
