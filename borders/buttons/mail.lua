
    local skin = MODUI_VAR['elements']['bu_skin']

    local OnEvent = function()
        if not skin.enable then return end

        local bu = SendMailPackageButton:GetRegions()
        bu:ClearAllPoints()
        bu:SetAllPoints(SendMailPackageButton)

        for i = 1, 7 do
            local bu = _G['MailItem'..i]
            local tx = _G['MailItem'..i..'ButtonIcon']
            local ic = bu:GetRegions()
            if  bu then
                local f = CreateFrame('Frame', nil, bu)
                f:SetPoint('TOPLEFT', ic, 0, 0) 
                f:SetPoint('BOTTOMRIGHT', ic, 0, 6)

                modSkin(f, 1)
                modSkinColor(f, skin.r, skin.g, skin.b)

                tx:SetPoint('TOPLEFT', f)
                tx:SetPoint('BOTTOMRIGHT', f)
            end
        end

        for _, v in pairs(
            {
                SendMailPackageButton,
                OpenMailPackageButton,
                OpenMailMoneyButton
            }
        ) do
            MODUI_BU(v, 1)
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    --
