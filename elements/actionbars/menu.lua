    local _, class = UnitClass'player'
    local skin = MODUI_VAR['elements']['bu_skin']
     local colour    = RAID_CLASS_COLORS[class]
    local addon     = {}
    local var       = MODUI_VAR['who']
    local e = CreateFrame'Frame'
    local money, lastmoney, xp, startxp, lastxp, gotxp, sessionxp = 0
    
    local events = {
        'PLAYER_LOGIN',
        'PLAYER_MONEY',
        'PLAYER_XP_UPDATE',
        'PLAYER_LEVEL_UP'
    }

    local CLASS_ICON_TCOORDS = {
    	['WARRIOR']		= {0, .25, .025, .225},
    	['MAGE']		= {.26, .5, .025, .225},
    	['ROGUE']		= {.49609375, 0.7421875, .025, .225},
    	['DRUID']		= {.7421875, 0.98828125, .025, .225},
    	['HUNTER']		= {.01, .249, .275, .475},
    	['SHAMAN']	 	= {.25, .49609375, .275, .475},
    	['PRIEST']		= {.497, .741, .275, .475},
    	['WARLOCK']		= {.7421875, .98828125, .275, .475},
    	['PALADIN']		= {0, .25, .525, .725},
    }

    local buttons = {
        ['CharacterMicroButton']    = {{-12, 10}, {-12, 10}},
        ['SpellbookMicroButton']    = {{ 12, 10}, { 12, 10}},
        ['TalentMicroButton']       = {{-12, 40}, {-12, 40}},
        ['QuestLogMicroButton']     = {{-12, 40}, { 12, 40}},
        ['SocialsMicroButton']      = {{ 12, 40}, {-12, 70}},
        ['WorldMapMicroButton']          = {{-12, 70}, { 12, 70}},
        ['MainMenuMicroButton']     = {{ 12, 70}, {-12, 100}},
        ['HelpMicroButton']         = {{-12, 100}, {12, 100}},
    }

    local menu = CreateFrame('Button', 'modmenuButton', MainMenuBarArtFrame)
    menu:SetWidth(26)
    menu:SetHeight(26)
    menu:SetPoint('BOTTOM', MainMenuBarLeftEndCap, 12, 8)
    menu:RegisterForClicks'AnyUp'
    
    if skin.enable then
        modSkin(menu)
        modSkinColor(menu, skin.r, skin.g, skin.b)
    end

    menu.t = menu:CreateTexture(nil, 'ARTWORK')
    menu.t:SetTexture[[Interface\GLUES\CHARACTERCREATE\UI-CHARACTERCREATE-CLASSES]]
    menu.t:SetTexCoord(unpack(CLASS_ICON_TCOORDS[class]))
    menu.t:SetPoint('TOPLEFT', menu)
    menu.t:SetPoint('BOTTOMRIGHT', 0, 5)

    menu.arrow = menu:CreateTexture(nil, 'OVERLAY')
    menu.arrow:SetTexture[[Interface\MoneyFrame\Arrow-Right-Up]]
    menu.arrow:SetHeight(16)
    menu.arrow:SetWidth(16)
    menu.arrow:SetTexCoord(1,0,0,0,1,1,0,1)
    menu.arrow:SetPoint('BOTTOM', menu, 'TOP', 2, 1)

    menu.mouseover = CreateFrame('Button', nil, menu)
    menu.mouseover:SetWidth(60)
    menu.mouseover:SetHeight(300)
    menu.mouseover:SetPoint('BOTTOM', menu, 'TOP')
    menu.mouseover:SetFrameLevel(10)
    
    menu.sb = CreateFrame('StatusBar', nil, menu)
    menu.sb:SetStatusBarTexture[[Interface\AddOns\md\customise\statusbar\statusbar.tga]]
    menu.sb:SetPoint('BOTTOMLEFT', 2, 3)
    menu.sb:SetPoint('BOTTOMRIGHT', -2, 3)
    menu.sb:SetHeight(3)
    menu.sb:SetStatusBarColor(0, 1, 0)
    menu.sb:SetBackdrop(
        {bgFile = [[Interface\Buttons\WHITE8x8]],
        insets = {
           left     =  -1,
           right    =  -1,
           top      =  -1,
           bottom   =  -1,
            }
        }
    )
    menu.sb:SetBackdropColor(0, 0, 0)
    menu.sb.updateInterval = 0

    MicroButtonPortrait:SetWidth(14)
    MicroButtonPortrait:SetHeight(21)
    MicroButtonPortrait:SetPoint('TOP', 0, -22)

    KeyRingButton:SetParent(ContainerFrame1)
    KeyRingButton:ClearAllPoints()
    KeyRingButton:SetPoint('TOPLEFT', ContainerFrame1, -25, -2)

    UpdateTalentButton = function() end
    
        local AddLatency = function()
        local _, _, home = GetNetStats()
        return  '|c00ffffff'..home..'|r ms'
    end

    local AddFPS = function()
        return '|c00ffffff'..floor(GetFramerate())..'|r fps'
    end

    local AddFormattedMoney = function()
        local g = floor(money/(100*100))
        local s = floor((money - (g*100*100))/100)
        local c = mod(money, 100)
        return format('%d\|cfff3ac00g|r %d\|cffc6c6c6s|r %d\|cff954e2fc|r', g, s, c)
    end

    local AddSessionTime = function()
        local session     = GetTime() - startxp
        local perhour     = sessionxp/session*3600
        local hourlyxp    = '|c00ffffff'..math.floor(perhour)..'|r xp'
        local time        = session > 0 and session or 0
        return hourlyxp, time
    end

    local AddPopulation = function()
        SendWho''
        var = true
        e:RegisterEvent'WHO_LIST_UPDATE'
        local n, t = GetNumWhoResults()
        local text = format(GetText('WHO_FRAME_TOTAL_TEMPLATE', nil, t), t)
        text = t == 50 and 'Hidden' or gsub(text, '(.+) Found', '%1')
        return text
    end

    local UpdateAddOns = function()
        addon = {}
        for i = 1, GetNumAddOns() do
            local n = GetAddOnInfo(i)
            if  not string.find(n, 'Blizzard_(.+)') then 
                if IsAddOnLoaded(n) then table.insert(addon, n) end
            end
        end
    end

    local UpdateMoney = function()
        local m = GetMoney()
        if  m > lastmoney then
            local increase = (m - lastmoney)
            money = money + increase
            lastmoney = m
        end
    end

    local UpdateLevel = function()
        gotxp   = gotxp + UnitXPMax'player' - lastxp
        lastxp  = 0
    end

    local UpdateXP = function()
        sessionxp  = UnitXP'player' - lastxp + gotxp
    end

    local ShowMenu = function()
        menu.arrow:SetPoint('BOTTOM', menu, 'TOP', 2, 4)
        for i, v in pairs(buttons) do
            local bu = _G[i]
            bu:SetAlpha(1)
            bu:EnableMouse(true)
        end
    end

    local HideMenu = function()
        GameTooltip:Hide()
        menu.arrow:SetPoint('BOTTOM', menu, 'TOP', 2, 1)
        for i, v in pairs(buttons) do
            local bu = _G[i]
            bu:SetAlpha(0)
            bu:EnableMouse(false)
        end
    end

    local AddMenu = function()
        local l = UnitLevel'player'
        for i, v in pairs(buttons) do
            local bu = _G[i]
            bu:SetHeight(48)
            bu:SetWidth(23)
            bu:ClearAllPoints()
            bu:SetPoint('BOTTOM', menu, 'TOP', l < 10 and v[1][1] or v[2][1], l < 10 and v[1][2] or v[2][2])
            bu:SetAlpha(0)
            bu:EnableMouse(false)
            bu:SetFrameLevel(11)
            bu.HOnEnter = bu:GetScript'OnEnter'
            bu.HOnLeave = bu:GetScript'OnLeave'

            bu:SetScript('OnEnter', function()
                bu:HOnEnter()
                ShowMenu()
            end)
            bu:SetScript('OnLeave', function()
                bu:HOnLeave()
                HideMenu()
            end)
        end
    end

    menu:SetScript('OnEnter', function()
        local hourlyxp, time = AddSessionTime()
        
        ShowMenu()
        
        GameTooltip:ClearLines()
        GameTooltip:SetOwner(menu, 'ANCHOR_RIGHT', 25, 75)
        
        -- header
        GameTooltip:AddLine(MAINMENU_BUTTON, colour.r, colour.g, colour.b) 
        GameTooltip:AddLine' '
        
          -- TOTAL ONLINE
        GameTooltip:AddDoubleLine('Total Users Online', AddPopulation(), colour.r, colour.g, colour.b, 1, .8, 0)
        GameTooltip:AddLine' '

            -- LATENCY
        GameTooltip:AddDoubleLine('Ping', AddLatency(), colour.r, colour.g, colour.b)
        if  SHOW_NEWBIE_TIPS then
            GameTooltip:AddLine' '
            GameTooltip:AddLine(NEWBIE_TOOLTIP_LATENCY, 1, .8, 0, 1)
        end

            -- FPS
        GameTooltip:AddLine' '
        GameTooltip:AddDoubleLine('Framerate', AddFPS(), colour.r, colour.g, colour.b, 1, .8, 0)

            -- SESSION GOLD
        GameTooltip:AddLine' '
        GameTooltip:AddDoubleLine('Money earned this session', AddFormattedMoney(), colour.r, colour.g, colour.b, 1, .8, 0)

            -- SESSION PLAYED
        GameTooltip:AddLine' '
        GameTooltip:AddDoubleLine('Time played this session', SecondsToTimeAbbrev(math.floor(time)), colour.r, colour.g, colour.b)

            -- HOURLY XP
        GameTooltip:AddDoubleLine('EXP earned this session', '|cffffffff'..sessionxp..'|r xp', colour.r, colour.g, colour.b, 1, .8, 0)
        GameTooltip:AddDoubleLine('EXP rate per hour', hourlyxp, colour.r, colour.g, colour.b, 1, .8, 0)

            -- ADDONS
        UpdateAddOns()

        GameTooltip:AddLine' '
        GameTooltip:AddLine('AddOns Loaded', colour.r, colour.g, colour.b)

        local l = tlength(addon)
        for k, v in pairs(addon) do
            if k < 20 then 
                GameTooltip:AddDoubleLine(' ', v, 1, 1, 1) 
            elseif k == l then
                GameTooltip:AddDoubleLine(' ', '+ '..k..' more that could not be displayed', 1, 1, 1)
            end
        end

        GameTooltip:Show()
    end)
    
	menu:SetScript('OnLeave',      HideMenu)
	
    menu.mouseover:SetScript('OnEnter', ShowMenu)
    menu.mouseover:SetScript('OnLeave', HideMenu)

    menu:SetScript('OnClick', function()
        ToggleCharacter'PaperDollFrame'
    end)
    
    menu.sb:SetScript('OnUpdate', function(self)
        if  this.updateInterval > 0 then
            this.updateInterval = this.updateInterval - arg1
        else
			this.updateInterval = PERFORMANCEBAR_UPDATE_INTERVAL
			local _, _, latency = GetNetStats()
			if  latency > PERFORMANCEBAR_MEDIUM_LATENCY then
				menu.sb:SetStatusBarColor(1, 0, 0)
			elseif latency > PERFORMANCEBAR_LOW_LATENCY then
				menu.sb:SetStatusBarColor(1, 1, 0)
			else
				menu.sb:SetStatusBarColor(0, 1, 0)
            end
		end
    end)
    
    local OnEvent = function()
        if  event == 'WHO_LIST_UPDATE' then
            HideUIPanel(FriendsFrame)
            e:UnregisterEvent'WHO_LIST_UPDATE'
            var = false
        end

        if      event == 'PLAYER_LOGIN' then 
            AddMenu()
            lastmoney   = GetMoney()
             lastmoney   = GetMoney()
            lastxp      = UnitXP'player'
            startxp     = GetTime()
            money       = 0
            sessionxp   = 0
            gotxp       = 0
        elseif  event == 'PLAYER_MONEY'             then UpdateMoney()
        elseif  event == 'PLAYER_LEVEL_UP'          then UpdateLevel()
        elseif  event == 'PLAYER_XP_UPDATE'         then UpdateXP()
        end
    end

    local OnShow = function()
        FriendsFrame.showFriendsList    = 1
        FriendsFrame_Update()

        UpdateMicroButtons()

        GuildFrame.selectedGuildMember  = 0
        SetGuildRosterSelection(0)
        InGuildCheck()

        if not var then PlaySound'igMainMenuOpen' end
    end

    local OnHide = function()
        UpdateMicroButtons()

        SetGuildRosterSelection(0)
        GuildFrame.selectedGuildMember = 0

        for _, v in pairs (
            {
                GuildControlPopupFrame, 
                GuildMemberDetailFrame, 
                GuildInfoFrame, 
                RaidInfoFrame
            }
        ) do
            v:Hide()
        end
        for _, v in FRIENDSFRAME_SUBFRAMES do 
            _G[v]:Hide() 
        end

        if not var then PlaySound'igMainMenuClose' end
   end
    
    FriendsFrame_OnShow = OnShow
    FriendsFrame_OnHide = OnHide

    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)
    
    