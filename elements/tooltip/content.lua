

    local classifications = {
        worldboss  = 'Boss',
        rareelite  = 'Rare Elite',
        rare       = 'Rare',
        elite      = 'Elite',
    }

    GameTooltip.faction = GameTooltip:CreateTexture(nil, 'ARTWORK')
    GameTooltip.faction:SetWidth(26)
    GameTooltip.faction:SetHeight(16)
    GameTooltip.faction:SetTexCoord(0, 1, 0, .6)
    GameTooltip.faction:SetPoint('LEFT', GameTooltipTextLeft1, -2, 0)

    for i = 1, 6 do     -- add tooltips to quest progress items in quest window
        local p = _G['QuestProgressItem'..i]
        p:SetScript('OnEnter', function()
            if  GameTooltip then
                GameTooltip:SetOwner(p, 'ANCHOR_RIGHT')
                if  GetNumQuestItems() > 0 then 
                    GameTooltip:SetQuestItem(p.type, p:GetID()) 
                end
            end
        end)
    end

    local AddFaction = function(n)
        local _, faction = UnitFactionGroup'mouseover'
        GameTooltipTextLeft1:SetText('    '..n) -- add space for icon
        GameTooltip.faction:SetTexture('Interface\\TargetingFrame\\UI-PVP-'..faction)
        GameTooltip.faction:Show()
    end

    local AddTarget = function()
        local unit = 'mouseovertarget'
        if  UnitIsUnit('player', unit) then
            return '|cffff0000You!|r'
        else
            if  UnitPlayerControlled(unit) then
                local _, class = UnitClass(unit)
                local r, g, b = RAID_CLASS_COLORS[class]
                GameTooltip:AddLine('|cfffec500Target:|r '..UnitName(unit), r, g, b)
            else
                local r, g, b = GameTooltip_UnitColor'mouseovertarget'
                GameTooltip:AddLine('|cfffec500Target:|r '..UnitName(unit), r, g, b)
            end
        end
    end

    local AddClassification = function(n, string)
        local level          = UnitLevel'mouseover'
        local race           = UnitIsPlayer and UnitRace'mouseover' or ''
        local classification = classifications[UnitClassification'mouseover'] or ''
        string:SetText('Level '..level..' '..'|cffffc800'..classification..'|r'..race)
    end

    local AddClass = function(n, c)
        if  string.find(n, '(Player)') then
                --  this is the ugliest god damn capture sequence
                --  but im too tired to make it pretty atm
            local t = gsub(n, 'Level (.+) (.+) (.+)', '%2')
            if  t then 
                local colour = RAID_CLASS_COLORS[string.upper(t)]
                if  colour then -- account for dead guys
                    GameTooltipTextLeft1:SetTextColor(colour.r, colour.g, colour.b)
                    GameTooltipStatusBar:SetStatusBarColor(colour.r, colour.g, colour.b)
                end
            else
                local r, g, b = GameTooltip_UnitColor'mouseover'
                GameTooltipTextLeft1:SetTextColor(r, g, b)
                GameTooltipStatusBar:SetStatusBarColor(r, g, b)
            end
        else
            local r, g, b = GameTooltip_UnitColor'mouseover'
            GameTooltipTextLeft1:SetTextColor(r, g, b)
            GameTooltipStatusBar:SetStatusBarColor(r, g, b)
        end
    end

    local AddGuild = function(t)
        GameTooltip:AddLine('<'..t..'>', 0, 1, .5)
    end

    local OnValueChanged = function()
        local r, g, b = this:GetStatusBarColor()
        HealthBar_OnValueChanged(arg1)
        this:SetStatusBarColor(r, g, b)
    end

    local OnEvent = function()
        local t1    = GameTooltipTextLeft1:GetText()
        local t2    = GameTooltipTextLeft2:GetText()
        local t3    = GameTooltipTextLeft3:GetText()    -- world boss support -___-
        local n2    = string.find(t2, 'Level (.+)')
        local n3    = t3 and string.find(t3, 'Level (.+)') or nil
        local Guild = GetGuildInfo'mouseover'

        GameTooltip.faction:Hide()
        GameTooltipStatusBar:SetScript('OnValueChanged', OnValueChanged)

        if  UnitIsPlayer'mouseover' then
            AddFaction(t1)
        end

        if  n2 or n3 then
            AddClassification(n2 and t2 or n3 and t3, n2 and GameTooltipTextLeft2 or GameTooltipTextLeft3)
            AddClass(n2 and t2 or t3)
        end

        if  Guild then 
            AddGuild(Guild)
        end

        if  UnitExists'mouseovertarget' then
            AddTarget()
        end

        GameTooltip:Show()
    end

    local OnShow = function()
        GameTooltip.faction:Hide()
    end

    GameTooltip:SetScript('OnShow', OnShow)

    local e = CreateFrame'Frame'
    e:RegisterEvent'UPDATE_MOUSEOVER_UNIT'
    e:SetScript('OnEvent', OnEvent)


    --
