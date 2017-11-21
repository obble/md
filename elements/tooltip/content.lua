

    local H = {}

    local classifications = {
        worldboss  = 'Boss',
        rareelite  = 'Rare Elite',
        rare       = 'Rare',
        elite      = 'Elite',
    }

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
        local t = gsub(n, 'Level (.+) ((.+))', '%1')
        local classification = classifications[UnitClassification'mouseover'] or ''
        string:SetText('Level '..t..' '..'|cffffc800'..classification..'|r')
    end

    local AddClass = function(n, c)
        if  string.find(n, '(Player)') then
                --  this is the ugliest god damn capture sequence
                --  but im too tired to make it pretty atm
            local t = gsub(n, 'Level (.+) (.+) (.+)', '%2')
            if  t then 
                local colour = RAID_CLASS_COLORS[string.upper(t)]
                GameTooltipTextLeft1:SetTextColor(colour.r, colour.g, colour.b)
                GameTooltipStatusBar:SetStatusBarColor(colour.r, colour.g, colour.b)
            else
                local r, g, b = GameTooltip_UnitColor'mouseover'
                GameTooltipTextLeft1:SetTextColor(r, g, b)
                GameTooltipStatusBar:SetStatusBarColor(r, g, b)
            end
        end
    end

    local AddGuild = function(t)
        GameTooltip:AddLine('<'..t..'>', 0, 1, .5)
    end

    local OnEvent = function()
        local t2    = GameTooltipTextLeft2:GetText()
        local t3    = GameTooltipTextLeft3:GetText()    -- world boss support -___-
        local n2    = string.find(t2, 'Level (.+)')
        local n3    = t3 and string.find(t3, 'Level (.+)') or nil
        local Guild = GetGuildInfo'mouseover'

        if  n2 or n3 then
            AddClassification(n2 and t2 or t3, n2 and GameTooltipTextLeft2 or GameTooltipTextLeft3)
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

    local e = CreateFrame'Frame'
    e:RegisterEvent'UPDATE_MOUSEOVER_UNIT'
    e:SetScript('OnEvent', OnEvent)


    --
