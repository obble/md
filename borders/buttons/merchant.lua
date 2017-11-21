
    local OnEvent = function()
        for i = 1, 12 do
            local bu   = _G['MerchantItem'..i..'ItemButton']
            local slot = _G['MerchantItem'..i..'SlotTexture']
            if  bu then
                MODUI_ITEM(bu)
                slot:Hide()
            end
        end

        for _, v in pairs(
            {
                _G['MerchantRepairItemButton'],
                _G['MerchantRepairAllButton']
            }
        ) do
            if v then MODUI_BU(v) end
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    --
