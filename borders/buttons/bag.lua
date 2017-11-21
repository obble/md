

    local OnEvent = function()
        MODUI_BU(MainMenuBarBackpackButton)
        MODUI_BUElements(MainMenuBarBackpackButton)

        for i = 0, 3 do
            local bu = _G['CharacterBag'..i..'Slot']
            MODUI_BU(bu)
            MODUI_BUElements(bu)
        end

        for i = 1, 12 do                    -- BAG
            for k = 1, MAX_CONTAINER_ITEMS do
                local bu = _G['ContainerFrame'..i..'Item'..k]
                local cd = _G['ContainerFrame'..i..'Item'..k..'Cooldown']
                MODUI_ITEMS(bu)
                cd:SetFrameLevel(bu:GetFrameLevel() + 1) 
                cd:SetFrameStrata'HIGH'
            end
        end
    end

    local  e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    --
