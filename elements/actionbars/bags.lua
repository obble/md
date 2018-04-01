
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

     local bp        = _G['MainMenuBarBackpackButton']
     local bpicon    = _G['MainMenuBarBackpackButtonIconTexture']
     local count     = _G['MainMenuBarBackpackButtonCount']
    
    bp:SetWidth(26)
    bp:SetHeight(26)
    bp:ClearAllPoints()
    bp:SetNormalTexture''
    bp:ClearAllPoints()
    bp:SetPoint('BOTTOM', MainMenuBarRightEndCap, 14, 8)
    bp.HOnEnter = bp:GetScript'OnEnter'
    bp.HOnLeave = bp:GetScript'OnLeave'

    bpicon:SetTexCoord(.1, .9, .1, .9)

    count:ClearAllPoints()
    count:SetPoint('BOTTOM', bp, 1, 0)

    bp.arrow = bp:CreateTexture(nil, 'OVERLAY')
    bp.arrow:SetTexture[[Interface\MoneyFrame\Arrow-Right-Up]]
    bp.arrow:SetHeight(16)
    bp.arrow:SetWidth(16)
    bp.arrow:SetTexCoord(1,0,0,0,1,1,0,1)
    bp.arrow:SetPoint('BOTTOM', bp, 'TOP', 2, 1)

    bp.mouseover = CreateFrame('Button', nil, bp)
    bp.mouseover:SetWidth(30)
    bp.mouseover:SetHeight(100)
    bp.mouseover:SetPoint('BOTTOM', bp, 'TOP')
    bp.mouseover:SetFrameLevel(10)
    
     local ShowBags = function()
        bp.arrow:SetPoint('BOTTOM', bp, 'TOP', 2, 4)
        for i = 0, 3 do
            local s = _G['CharacterBag'..i..'Slot']
            s:SetAlpha(1)
            s:EnableMouse(true)
        end
    end

    local HideBags = function()
        bp.arrow:SetPoint('BOTTOM', bp, 'TOP', 2, 1)
        for i = 0, 3 do
            local s = _G['CharacterBag'..i..'Slot']
            s:SetAlpha(0)
            s:EnableMouse(false)
        end
    end

    local SetBagToggle = function(min, max, toggle)
        for i = min, max do
            if toggle == 'open' then OpenBag(i) else CloseBag(i) end
        end
    end

    ToggleBackpack = function()
        if  IsBagOpen(0) then
			CloseBankFrame()
			SetBagToggle(0, 11)
		else
            SetBagToggle(0, 4, 'open')
        end
    end

    bp:SetScript('OnEnter', function()
        --bp:HOnEnter()
        ShowBags()
    end)
    bp:SetScript('OnLeave', function()
        --bp:HOnLeave()
        HideBags()
    end)
    
    bp.mouseover:SetScript('OnEnter', ShowBags)
    bp.mouseover:SetScript('OnLeave', HideBags)
    
    for i = 0, 3 do
        local s = _G['CharacterBag'..i..'Slot']
        local t = _G['CharacterBag'..i..'SlotIconTexture']
        local c = _G['CharacterBag'..i..'SlotCount']
        s:SetWidth(18)
        s:SetHeight(18)
        s:SetNormalTexture''
        s:SetAlpha(0)
        s:EnableMouse(false)
        s:SetFrameLevel(11)
        s.HOnEnter = s:GetScript'OnEnter'
        s.HOnLeave = s:GetScript'OnLeave'

        c:SetFont(STANDARD_TEXT_FONT, 9, 'OUTLINE')
        c:ClearAllPoints()
        c:SetPoint('LEFT', s, 'RIGHT', 6, 1)

        t:SetTexCoord(.1, .9, .1, .9)

        if i == 0 then
            s:ClearAllPoints()
            s:SetPoint('BOTTOM', MainMenuBarBackpackButton, 'TOP', 0, 14)
        else
            s:ClearAllPoints()
            s:SetPoint('BOTTOM', _G['CharacterBag'..(i - 1)..'Slot'], 'TOP', 0, 6)
        end

        s:SetScript('OnEnter', function()
            s:HOnEnter()
            ShowBags()
        end)
        s:SetScript('OnLeave', function()
            s:HOnLeave()
            HideBags()
        end)
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)

    --
