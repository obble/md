

    local _, class  = UnitClass'Player'
    local colour    = RAID_CLASS_COLORS[class]
    local addon     = {}
    local var       = MODUI_VAR['who']
    local e         = CreateFrame'Frame'
    local money, lastmoney, xp, startxp, lastxp, gotxp, sessionxp = 0

    local events = {
        'PLAYER_ENTERING_WORLD',
        'PLAYER_MONEY',
        'PLAYER_XP_UPDATE',
        'PLAYER_LEVEL_UP'
    }

    local BACKDROP  = {  
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
        insets = {
            left    = -1, 
            right   = -1, 
            top     = -1, 
            bottom  = -1
        }
    }


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
        text = gsub(text, '(.+) Found', '%1')
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

    local OnEnter = function()
        local hourlyxp, time = AddSessionTime()
        local f = MainMenuBarPerformanceBarFrame

        GameTooltip:ClearLines()
        GameTooltip:SetOwner(f, 'ANCHOR_TOPLEFT')

            -- HEADER
        GameTooltip:AddDoubleLine('modui stats', ':)', colour.r, colour.g, colour.b)
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

        f.hover = 1
        GameTooltip:Show()
    end

    local Init = function()
        local f     = MainMenuBarPerformanceBarFrameButton

        lastmoney   = GetMoney()
        lastxp      = UnitXP'player'
        startxp     = GetTime()
        money       = 0
        sessionxp   = 0
        gotxp       = 0

        f:SetScript('OnEnter', OnEnter)
    end

    local OnEvent = function()
        if  event == 'WHO_LIST_UPDATE' then
            HideUIPanel(FriendsFrame)
            e:UnregisterEvent'WHO_LIST_UPDATE'
            var = false
        end

        if      event == 'PLAYER_ENTERING_WORLD'    then Init()
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

    --
