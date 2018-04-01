

    for _, v in pairs(
        {
            PetActionBarFrameSlidingActionBarTexture0,
            PetActionBarFrameSlidingActionBarTexture1,
        }
    ) do
        v:SetAlpha(0)
    end
    
    for _, v in pairs(
        {
            ShapeshiftBarLeft,
            ShapeshiftBarMiddle,
            ShapeshiftBarRight,
        }
    ) do
        v:SetTexture''
    end
    
    MainMenuBarTexture2:SetAlpha(0)
    local new_bg1 = MainMenuBarArtFrame:CreateTexture(nil, 'BACKGROUND')
    new_bg1:SetAllPoints(MainMenuBarTexture2)
    new_bg1:SetTexture[[Interface\MainMenuBar\UI-MainMenuBar-Dwarf]]
    new_bg1:SetTexCoord(0, 1, .83203125, 1)
    
     MainMenuBarTexture3:SetAlpha(0)
    local new_bg2 = MainMenuBarArtFrame:CreateTexture(nil, 'BACKGROUND')
    new_bg2:SetAllPoints(MainMenuBarTexture3)
    new_bg2:SetTexture[[Interface\MainMenuBar\UI-MainMenuBar-Dwarf]]
    new_bg2:SetTexCoord(0, 1, .58203125, .75)

    
    MainMenuBarPerformanceBarFrameButton:SetScript('OnEnter', nil)
    MainMenuBarPerformanceBarFrame:SetScript('OnUpdate', nil)
    for _, v in pairs({MainMenuBarPerformanceBarFrame:GetRegions()}) do
	    v:Hide()
    end
    
    ActionBarUpButton:ClearAllPoints()
    ActionBarUpButton:SetPoint('BOTTOM', MainMenuBarRightEndCap, -20, 16)
    ActionBarDownButton:ClearAllPoints()
    ActionBarDownButton:SetPoint('BOTTOM', MainMenuBarRightEndCap, -20, -3)
    MainMenuBarPageNumber:ClearAllPoints()
    MainMenuBarPageNumber:SetPoint('BOTTOM', MainMenuBarRightEndCap, -21, 45)
        
    MultiBarRightButton1:ClearAllPoints()
    MultiBarRightButton1:SetPoint('LEFT', ActionButton12, 'RIGHT', 12, 0)
    
    for i = 2, 12 do
        _G['MultiBarRightButton'..i]:ClearAllPoints()
        _G['MultiBarRightButton'..i]:SetPoint('LEFT', _G['MultiBarRightButton'..(i - 1)], 'RIGHT', 6, 0)
    end

    --


    