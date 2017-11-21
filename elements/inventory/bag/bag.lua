

    local OnDragStart = function()
        if  IsShiftKeyDown() then 
            this:StartMoving()
        end
    end

    local OnDragStop  = function()
        this:StopMovingOrSizing()
    end

    local OnEvent = function()
        local bag = CreateFrame('Frame', 'modbag' , UIParent)
        MODUI_ButtonTemplate(bag)
        -- MODUI_DELEGATE_FRAMES_TO_POSITION[bag] = {'BOTTOMRIGHT', -25, 70}
        bag:SetPoint('BOTTOMRIGHT', -110, 120) -- temporary!!
        bag:SetFrameLevel(0)
        bag:Hide()

        bag.portrait = bag:CreateTexture(nil, 'BORDER', nil, 7)
        bag.portrait:SetWidth(64)
        bag.portrait:SetHeight(64)
        bag.portrait:SetPoint('TOPLEFT', -8, 8)
        bag.portrait:SetAlpha(1)

        bag.name = bag:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
        bag.name:SetFont(STANDARD_TEXT_FONT, 12)
        bag.name:SetText'Bag'
        bag.name:SetPoint('TOPLEFT', 66, -5)
        bag.name:SetTextColor(1, .7, 0)

        bag.close = bag.ButtonTemplate.Inset.CloseButton
        bag.close:SetFrameLevel(4)

        local money = ContainerFrame1MoneyFrame
        money:SetParent(bag)
        money:ClearAllPoints()
        money:SetPoint('BOTTOMRIGHT', bag, 0, 10)
        money:SetFrameStrata'MEDIUM'
        money:SetFrameLevel(3)

        KeyRingButton:SetWidth(39)
        KeyRingButton:SetHeight(18)
        KeyRingButton:SetParent(bag)
        KeyRingButton:ClearAllPoints() KeyRingButton:SetPoint('TOPRIGHT', bag, -28, -2)
        KeyRingButton:SetFrameLevel(4)
        KeyRingButton:GetNormalTexture():SetTexCoord(.61,0,0,0,.61,.59,0,.59)
        KeyRingButton:GetPushedTexture():SetTexCoord(.61,0,0,0,.61,.59,0,.59)
        KeyRingButton:SetHighlightTexture''

        for _, v in pairs(
            {
                ContainerFrame1MoneyFrameCopperButtonText,
                ContainerFrame1MoneyFrameSilverButtonText,
                ContainerFrame1MoneyFrameGoldButtonText
            }
        ) do
            v:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
            v:SetShadowOffset(0, 0)
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)


    --