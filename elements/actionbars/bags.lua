
    local events = {'PLAYER_ENTERING_WORLD', 'BAG_UPDATE'}
    local t

    local OnEvent = function()
        if  not t then
            t = MainMenuBarBackpackButton:CreateFontString('mod_btext', 'OVERLAY', 'NumberFontNormal')
            t:SetPoint('BOTTOM', MainMenuBarBackpackButton, 1, 1)
        end

        local n = MOD_GetSlots()
        if n == 0 then t:SetText'|cffff0000Full!|r' else t:SetText(n) end
    end

    for i = 0, 4 do
        --
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)

    --
