
    local OnEvent = function()
        for i = 1, 4 do
            local bu = _G['LootButton'..i]
            MODUI_ITEMS(bu)
            bu:SetNormalTexture''
        end

        for i = 1, 4 do
            local bu    = _G['GroupLootFrame'..i..'IconFrame']
            local slot  = _G['GroupLootFrame'..i..'SlotTexture']

            bu.f = CreateFrame('Frame', nil, bu)
            bu.f:SetFrameLevel(bu:GetFrameLevel() + 1)
            bu.f:SetAllPoints()
            bu.f:EnableMouse(false)
            
            modSkin(bu.f, 1)
            modSkinColor(bu.f, .7, .7, .7)
            
            slot:SetAlpha(0)
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    --
