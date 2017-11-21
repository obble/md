

    local H = {}

    H.PartyMemberFrame_OnEvent = PartyMemberFrame_OnEvent
    H.PetFrame_OnEvent         = PetFrame_OnEvent

    local OnEvent = function ()
        for i = 1, 5 do
            local n = 'PartyMemberFrame'..i
            for j = 1, 4 do
                local bu = _G[n..'Debuff'..j]
                if  bu then
                    MODUI_BU(bu)
                    MODUI_BUBorder(bu)
                    MODUI_BUElements(bu)
                end
            end
        end

        for i = 1, 3 do
            local bu = _G['PetFrameDebuff'..i]
            if  bu then
                MODUI_BU(bu)
                MODUI_BUBorder(bu)
                MODUI_BUElements(bu)
                if i == 1 then bu:SetPoint('TOPLEFT', 48, -46) end
            end
        end
    end

    local PartyOnEvent = function(event)
        H.PartyMemberFrame_OnEvent(event)
        if  event == 'UNIT_AURA' then
            for i = 1, 5 do
                local n = 'PartyMemberFrame'..i
                for j = 1, 4 do
                    local f  = n..'Debuff'..j
                    local bu = _G[f]
                    local d  = _G[f..'Border']

                    if  bu then
                        bu.bo:SetBackdropBorderColor(0, 0, 0, 0)
                        if  d then
                            local r, g, b = d:GetVertexColor()
                            bu.bo:SetBackdropBorderColor(r, g, b, 1)
                            d:SetAlpha(0)
                        end
                    end
                end
            end
        end
    end

    local PetOnEvent = function(event)
        H.PetFrame_OnEvent(event)
        if  event == 'UNIT_AURA' then
            for i = 1, 3 do
                local f  = 'PetFrameDebuff'..i
                local bu = _G[f]
                local d  = _G[f..'Border']

                if  bu then
                    bu.bo:SetBackdropBorderColor(0, 0, 0, 0)
                    if  d then
                        local r, g, b = d:GetVertexColor()
                        bu.bo:SetBackdropBorderColor(r, g, b, 1)
                        d:SetAlpha(0)
                    end
                end
            end
        end
    end

    PartyMemberFrame_OnEvent    = PartyOnEvent
    PetFrame_OnEvent            = PetOnEvent

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    --
