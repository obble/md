
    local _, class  = UnitClass'Player'
    local colour    = RAID_CLASS_COLORS[class]
    local H         = {}
    local var       = MODUI_VAR['colour']
    local sbar      = MODUI_VAR['statusbar']

    local events    = {
        'PLAYER_LOGIN',
        'PLAYER_ENTERING_WORLD',
        'UPDATE_EXHAUSTION',
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

    H.ReputationWatchBar_Update = ReputationWatchBar_Update

    local AddBar = function()
        MainMenuExpBar:SetWidth(1021) 
        MainMenuExpBar:SetHeight(5)
        MainMenuExpBar:ClearAllPoints()
        MainMenuExpBar:SetPoint('TOP', MainMenuBar, 0, -4)
        MainMenuExpBar:SetBackdrop(BACKDROP)
        MainMenuExpBar:SetBackdropColor(0, 0, 0, 1)

        MainMenuExpBar.bg = MainMenuExpBar:CreateTexture(nil, 'OVERLAY', nil, 7)
        MainMenuExpBar.bg:SetPoint('TOPLEFT', MainMenuExpBar, 0, -1)
        MainMenuExpBar.bg:SetPoint('BOTTOMRIGHT', MainMenuExpBar, 0, 1)

        MainMenuExpBar.spark = MainMenuExpBar:CreateTexture(nil, 'OVERLAY', nil, 7)
        MainMenuExpBar.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
        MainMenuExpBar.spark:SetWidth(35) MainMenuExpBar.spark:SetHeight(35)
        MainMenuExpBar.spark:SetBlendMode'ADD'

        MainMenuExpBar.rep = MainMenuExpBar:CreateFontString(nil, 'OVERLAY')
        MainMenuExpBar.rep:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
        MainMenuExpBar.rep:SetPoint('RIGHT', MainMenuBarExpText, 'LEFT')

        ReputationWatchBar:SetParent(MainMenuBar)
        ReputationWatchBar:SetFrameStrata'HIGH'

        ReputationWatchStatusBar:SetWidth(1021)
        ReputationWatchStatusBar:SetBackdrop(BACKDROP)
        ReputationWatchStatusBar:SetBackdropColor(0, 0, 0, 1)

        ReputationWatchStatusBar.bg = ReputationWatchStatusBar:CreateTexture(nil, 'OVERLAY', nil, 7)
        ReputationWatchStatusBar.bg:SetAllPoints()
        ReputationWatchStatusBar.bg:SetPoint('TOPLEFT', ReputationWatchStatusBar, 0, -1)
        ReputationWatchStatusBar.bg:SetPoint('BOTTOMRIGHT', ReputationWatchStatusBar, 0, .5)

        ReputationWatchStatusBar.spark = ReputationWatchStatusBar:CreateTexture(nil, 'OVERLAY', nil, 7)
        ReputationWatchStatusBar.spark:SetTexture[[Interface\CastingBar\UI-CastingBar-Spark]]
        ReputationWatchStatusBar.spark:SetWidth(35) ReputationWatchStatusBar.spark:SetHeight(35)
        ReputationWatchStatusBar.spark:SetBlendMode'ADD'
        ReputationWatchStatusBar.spark:SetVertexColor(colour.r*1.3, colour.g*1.3, colour.b*1.3, .6)

        for _, v in pairs(
            {
                MainMenuExpBar,
                ReputationWatchBar
            }
        ) do
            v.cap0 = v:CreateTexture(nil, 'BACKGROUND')
            v.cap0:SetWidth(256)
            v.cap0:SetHeight(2)
            v.cap0:SetPoint('BOTTOM', v, 'TOP', -384, 1)
            v.cap0:SetTexture[[Interface\MainMenuBar\UI-MainMenuBar-MaxLevel]]
            v.cap0:SetTexCoord(0, 1, 0, .21875)
            v.cap0:SetVertexColor(
                var.r, 
                var.g, 
                var.b
            )

            v.cap1 = v:CreateTexture(nil, 'BACKGROUND')
            v.cap1:SetWidth(256)
            v.cap1:SetHeight(2)
            v.cap1:SetPoint('LEFT', v.cap0, 'RIGHT')
            v.cap1:SetTexture[[Interface\MainMenuBar\UI-MainMenuBar-MaxLevel]]
            v.cap1:SetTexCoord(0, 1, .25, .46875)
            v.cap1:SetVertexColor(
                var.r, 
                var.g, 
                var.b
            )

            v.cap2 = v:CreateTexture(nil, 'BACKGROUND')
            v.cap2:SetWidth(256)
            v.cap2:SetHeight(2)
            v.cap2:SetPoint('LEFT', v.cap1, 'RIGHT')
            v.cap2:SetTexture[[Interface\MainMenuBar\UI-MainMenuBar-MaxLevel]]
            v.cap2:SetTexCoord(0, 1, .5, .71875)
            v.cap2:SetVertexColor(
                var.r, 
                var.g, 
                var.b
            )

            v.cap3 = v:CreateTexture(nil, 'BACKGROUND')
            v.cap3:SetWidth(256)
            v.cap3:SetHeight(2)
            v.cap3:SetPoint('LEFT', v.cap2, 'RIGHT')
            v.cap3:SetTexture[[Interface\MainMenuBar\UI-MainMenuBar-MaxLevel]]
            v.cap3:SetTexCoord(0, 1, .75, .96875)
            v.cap3:SetVertexColor(
                var.r, 
                var.g, 
                var.b
            )
        end

        for i = 0, 3 do
            for _, v in pairs(
                {
                    _G['MainMenuXPBarTexture'..i],
                    _G['ReputationWatchBarTexture'..i],
                    _G['ReputationXPBarTexture'..i]
                }
            ) do
                local x = {v:GetPoint()}
                v:SetTexCoord(0, 1, .82, .83)
                v:SetHeight(5)
                v:ClearAllPoints()
                v:SetPoint(x[1], x[2], x[3], x[4], x[5] - 5)
            end

            local f = _G['MainMenuXPBarTexture'..i]
            f:SetParent(MainMenuExpBar)

            f =  _G['ReputationXPBarTexture'..i]
            f:SetParent(MainMenuBar)
        end
    end

    local XPUpdate = function()
        local xp, max = UnitXP'player', UnitXPMax'player'
        local x = (xp/max)*MainMenuExpBar:GetWidth()
        local rest = GetRestState()

        MainMenuExpBar:SetMinMaxValues(min(0, xp), max)
        MainMenuExpBar:SetValue(math.floor(xp))
        MainMenuExpBar.spark:SetPoint('CENTER', MainMenuExpBar, 'LEFT', x, -1)

        if      rest == 1 then
            MainMenuExpBar.bg:SetTexture(0, .39, .88, .35)
        elseif  rest == 2 then
            MainMenuExpBar.bg:SetTexture(.58, 0, .55, .35)
        end
    end

    local RepUpdate = function(new)
        if not new then new = UnitLevel'player' end

        H.ReputationWatchBar_Update(new)

        local name, standing, min, max, v = GetWatchedFactionInfo()
        local aura      = MODUI_VAR['aura']
        local percent   = math.floor((v - min)/(max - min)*100)
        local bar       = ReputationWatchBar
        local sb        = ReputationWatchStatusBar
        local text      = ReputationWatchStatusBarText
        local xp        = MainMenuExpBar
        local x

        if v > 0 then x = ((v - min)/(max - min))*bar:GetWidth() end

        bar:SetFrameStrata'LOW'
        bar:SetHeight(new < MAX_PLAYER_LEVEL and 4 or 5)

        if  new == MAX_PLAYER_LEVEL then
            bar:ClearAllPoints()
            bar:SetPoint('TOP', MainMenuBar, 0, -4)

            text:SetPoint('CENTER', ReputationWatchBarOverlayFrame, 0, 3)
            text:SetDrawLayer('OVERLAY', 7)

            if  name then
                text:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
                if  aura.format then
                    text:SetText(name..': '..true_format((v - min))..' / '..true_format((max - min)))
                else
                    text:SetText(name..': '..percent..'% into '.._G['FACTION_STANDING_LABEL'..standing])
                end
            end

            if xp.spark then xp.spark:Hide() end
        else
            bar:ClearAllPoints()
            bar:SetPoint('TOP', MainMenuBar, 0, 3)
            text:SetText''
            TextStatusBar_UpdateTextString(MainMenuExpBar)
            if  xp.spark then 
                xp.spark:Show() 
            end
        end

        sb:SetHeight(new < MAX_PLAYER_LEVEL and 4 or 5)
        sb:SetStatusBarColor(colour.r, colour.g, colour.b, 1)


        if  sb.bg then 
            sb.bg:SetTexture(colour.r, colour.g, colour.b, .25)
        end
        
        if  sb.spark then
            sb.spark:SetPoint('CENTER', sb, 'LEFT', x, -1)
        end
    end

    local OnEvent = function()
        local rest = GetRestState()
        if event  == 'PLAYER_LOGIN' then  AddBar() end
        if rest == 1 then
            MainMenuExpBar.spark:SetVertexColor(0*1.5, .39*1.5, .88*1.5, 1)
        elseif rest == 2 then
            MainMenuExpBar.spark:SetVertexColor(.58*1.5, 0*1.5, .55*1.5, 1)
        end
    end

    MainMenuExpBar_Update       = XPUpdate
    ReputationWatchBar_Update   = RepUpdate

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)

    --
