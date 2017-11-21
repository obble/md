
    local var    = MODUI_VAR['elements']['bu_skin']

    local events = {
        'PLAYER_LOGIN',
        'UNIT_INVENTORY_CHANGED'
    }

    local slots = {
    	[0] = 'Ammo', 
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
        'Tabard'
    }

    local PLAYER_LOGIN = function()
        for _, v in pairs(slots) do
            local bu =  _G['Character'..v..'Slot']
            MODUI_ITEMS(bu)
            bu:SetNormalTexture''
        end
    end

    local UNIT_INVENTORY_CHANGED = function()
        for i, v in pairs(slots) do
            local  bu   = _G['Character'..v..'Slot']
            if not bu.bo then return end
            local  q    = GetInventoryItemQuality('player', i)

            bu.bo:SetBackdropBorderColor(0, 0, 0, 0)
            if  var.enable then
                modSkinColor(bu, var.r, var.g, var.b)
            end

            if  q and q > 1 then
                local r, g, b = GetItemQualityColor(q)
                bu.bo:SetBackdropBorderColor(r, g, b, 1)
                if  var.enable then
                    modSkinColor(bu, r, g, b)
                end
            end
        end
    end

    local OnEvent = function()
        if  event == 'UNIT_INVENTORY_CHANGED' then
            UNIT_INVENTORY_CHANGED()
        else
            PLAYER_LOGIN()
        end
    end

    local  e = CreateFrame('Frame', nil, CharacterFrame)
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnShow',  UNIT_INVENTORY_CHANGED)
    e:SetScript('OnEvent', OnEvent)

    --
