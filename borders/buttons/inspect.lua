

    local H     = {}
    local slots = {
    	'Head', 
        'Neck', 
        'Shoulder',
    	'Shirt', 
        'Chest', 
        'Waist', 
        'Legs', 
        'Feet',
    	'Wrist', 
        'Hands', 
        'Finger0', 
        'Finger1',
    	'Trinket0',
        'Trinket1',
    	'Back',
        'MainHand',
        'SecondaryHand',
        'Ranged',
        'Tabard',
    }

    local Update = function(button)
        H.InspectPaperDollItemSlotButton_Update(button)
        for i, v in pairs(slots) do
            local bu    = _G['Inspect'..v..'Slot']
            local link  = GetInventoryItemLink('target', i)

            bu.bo:SetBackdropBorderColor(0, 0, 0, 0)

            if  link then
                local _, _, istring = string.find(link, '|H(.+)|h')
                local _, _, q = GetItemInfo(istring)
                if  q and q > 1 then
                    local r, g, b = GetItemQualityColor(q)
                    bu.bo:SetBackdropBorderColor(r, g, b, 1)
                end
            end
        end
    end

    local ADDON_LOADED = function()
        for i, v in pairs(slots) do
            local bu =  _G['Inspect'..v..'Slot']
            if  bu then
                MODUI_ITEMS(bu)
                bu:SetNormalTexture''
            end
        end
    end

    local OnEvent = function()
        if arg1 == 'Blizzard_InspectUI' then
            this:UnregisterEvent(event)
            ADDON_LOADED()
            H.InspectPaperDollItemSlotButton_Update = InspectPaperDollItemSlotButton_Update
            InspectPaperDollItemSlotButton_Update   = Update
        end
    end

    local e = CreateFrame'Frame'
    e:SetScript('OnEvent', OnEvent)
    e:RegisterEvent'ADDON_LOADED'

    --
