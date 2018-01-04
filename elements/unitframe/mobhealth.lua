

    local var   = MODUI_VAR['elements']['unit']

    if  (not MobHealth3) or IsAddOnLoaded'MobInfo2' then 
        print'no mobhealth'
        return 
    end

    local events = {
         'PLAYER_ENTERING_WORLD',
         'CVAR_UPDATE'
    }

    local AddFont = function()
        for _, v in pairs (
            {
                MobHealth3BlizzardHealthText,
                MobHealth3BlizzardPowerText
            }
        ) do
            v:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
            v:SetShadowOffset(0, 0)
            v:SetJustifyV'MIDDLE'
        end
    end

    local AddGradient = function(v, t, min, max)
        if  var.colour then
            if v < min or v > max then return end
            if (max - min) > 0 then
                v = (v - min)/(max - min)
            else
                v = 0
            end
            if v > .5 then
                r = (1 - v)*2
                g = 1
            else
                r = 1
                g = v*2
            end
            b = 0
            t:SetTextColor(r*1.5, g*1.5, b*1.5)
        else
            t:SetTextColor(1, 1, 1)
        end
    end

    function MH3Blizz:HealthUpdate()
        local v, max  = MobHealth3:GetUnitHealth('target', UnitHealth'target', UnitHealthMax'target')
        local percent = math.floor(v/max*100)
        local minus   = v < max and '  |cffff0000-'..(max - v)..'|r' or ''
        local string  = MobHealth3BlizzardHealthText

        AddFont()

        if  MH3BlizzConfig.healthAbs then
            if max == 100 then
                -- Do nothing!
            else
                v = math.floor(v)
            end
        end

        AddGradient(v, string, 0, max)

        if  var['value'].truth and not var['value'].both then
            local logic = MH3BlizzConfig.healthPerc and v <= 100 and percent == v
            local t = v == 0 and 'Dead' or logic and true_format(v)..'%' or true_format(v)
            string:SetText(t)
        else
            -- string:SetText(percent..'%'..minus)
            string:SetText(percent..'%')
        end

        if  var['value'].both then
            if max == 100 then
                string:SetText(percent..'%')
            else
                string:SetText(true_format(v)..'/'..true_format(max)..' — '..percent..'%')
            end
            string:SetPoint('RIGHT', -8, 0)
        end
    end

    function MH3Blizz:PowerUpdate()
        local _, class = UnitClass'target'
        local v, max   = UnitMana'target', UnitManaMax'target'
        local pp       = UnitPowerType'target'
        local percent  = math.floor(v/max*100)
        local string   = MobHealth3BlizzardPowerText
        
        AddFont()

        if max == 0 or cur == 0 or percent == 0 then string:SetText() return end
        if MH3BlizzConfig.powerAbs then v = math.floor(v) end

        if  var['value'].colour then
            if class == 'ROGUE' or (class == 'DRUID' and pp == 3) then
                string:SetTextColor(250/255, 240/255, 200/255)
            elseif (UnitIsPlayer'target' and class == 'WARRIOR') -- NPCs are classed as warriors by default
                or (class == 'DRUID' and pp == 1)
                then
                string:SetTextColor(250/255, 108/255, 108/255)
            else
                string:SetTextColor(.6, .65, 1)
            end
        else
            string:SetTextColor(1, 1, 1)
        end

        if  var['value'].truth and not var['value'].both then
            local logic = MH3BlizzConfig.powerPerc and v <= 100 and percent == v and pp == 0
            local t = logic and true_format(v)..'%' or true_format(v)
            string:SetText(t)
        else
            string:SetText(percent..'%')
        end

        if  var['value'].both then
            if  max == 100 then
                string:SetText(percent..'%')
            else
                string:SetText(true_format(v)..'/'..true_format(max)..' — '..percent..'%')
            end
            string:SetPoint('RIGHT', -8, 0)
        end
    end

    local HealthOnEnter = function()
        MobHealth3BlizzardHealthText:Show()
    end

    local HealthOnLeave = function()
        MobHealth3BlizzardHealthText:Hide()
    end

    local PowerOnEnter  = function()
        MobHealth3BlizzardPowerText:Show()
    end

    local PowerOnLeave  = function()
        MobHealth3BlizzardPowerText:Hide()
    end

    local OnEvent = function()
        if  arg1 == 'STATUS_BAR_TEXT' or event == 'PLAYER_ENTERING_WORLD' then
            if  gcV'statusBarText' then
                MobHealth3BlizzardHealthText:Hide() 
                MobHealth3BlizzardPowerText:Hide()

                TargetFrameHealthBar:SetScript('OnEnter',   HealthOnEnter)
                TargetFrameHealthBar:SetScript('OnLeave',   HealthOnLeave)

                TargetFrameManaBar:SetScript('OnEnter',     PowerOnEnter)
                TargetFrameManaBar:SetScript('OnLeave',     PowerOnLeave)
            else
                MobHealth3BlizzardHealthText:Show() 
                MobHealth3BlizzardPowerText:Show()
            end
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)


    --
