

    local OnEvent = function()
        if arg1 == 'Blizzard_MacroUI' then
            this:UnregisterEvent(event)
            for i = 1, 18 do
                local bu        = _G['MacroButton'..i]
                local ic        = _G['MacroButton'..i..'Icon']
                local _, slot   = bu:GetRegions()

                MODUI_BU(bu)

                slot:SetWidth(60) slot:SetHeight(60)
            end

            local bu = _G['MacroFrameSelectedMacroButton']
            local bg = _G['MacroFrameSelectedMacroBackground']

            if  bu then
                local _, slot = bu:GetRegions()

                MODUI_BU(bu, -.5)

                slot:SetWidth(60) 
                slot:SetHeight(60)

                bg:SetAlpha(0)
            end

            for i = 1, 20 do
                local bu = _G['MacroPopupButton'..i]

                if  bu then
                    local _, slot = bu:GetRegions()
                    MODUI_BU(bu, -.5)

                    slot:SetWidth(60) 
                    slot:SetHeight(60)

                    bg:SetAlpha(0)
                end
            end
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'ADDON_LOADED'
    e:SetScript('OnEvent', OnEvent)

    --
