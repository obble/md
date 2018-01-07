

    local  var = MODUI_VAR['elements']['map']
    if not var.world then return end

    local _OnShow

    local dSubZones = {
        ['blackwinglair']   = true,
        ['thedeadmines']    = true,
    }

    local dPos      = {
        ['moddungeonmap1']  = {
            'TOPLEFT',
            'WorldMapButton',
            'TOPLEFT',
        },
        ['moddungeonmap2']  = {
            'TOPLEFT',
            'moddungeonmap1',
            'TOPRIGHT',
        },
        ['moddungeonmap3']  = {
            'TOPLEFT',
            'moddungeonmap2',
            'TOPRIGHT',
        },
        ['moddungeonmap4']  = {
            'TOPLEFT',
            'moddungeonmap3',
            'TOPRIGHT',
        },
        ['moddungeonmap5']  = {
            'TOPLEFT',
            'moddungeonmap1',
            'BOTTOMLEFT',
        },
        ['moddungeonmap6']  = {
            'TOPLEFT',
            'moddungeonmap5',
            'TOPRIGHT',
        },
        ['moddungeonmap7']  = {
            'TOPLEFT',
            'moddungeonmap6',
            'TOPRIGHT',
        },
        ['moddungeonmap8']  = {
            'TOPLEFT',
            'moddungeonmap7',
            'TOPRIGHT',
        },
        ['moddungeonmap9']  = {
            'TOPLEFT',
            'moddungeonmap5',
            'BOTTOMLEFT',
        },
        ['moddungeonmap10'] = {
            'TOPLEFT',
            'moddungeonmap9',
            'TOPRIGHT',
        },
        ['moddungeonmap11'] = {
            'TOPLEFT',
            'moddungeonmap10',
            'TOPRIGHT',
        },
        ['moddungeonmap12'] = {
            'TOPLEFT',
            'moddungeonmap11',
            'TOPRIGHT',
        },
    }

    local AddQuestieSupport = function()
        if  IsAddOnLoaded'!Questie' then
            local bu = _G['Questie_Toggle']
            bu:SetHeight(22)
            bu:ClearAllPoints()
            bu:SetPoint('TOP', -217, -133)
        end
    end

    local OnUpdate = function(self, elapsed)
        local width     = WorldMapDetailFrame:GetWidth()
        local height    = WorldMapDetailFrame:GetHeight()
        local mx, my    = WorldMapDetailFrame:GetCenter()
        local scale     = WorldMapDetailFrame:GetEffectiveScale()
        local px, py    = GetPlayerMapPosition'player'
        local player    = _G['modui_xyplayer']
        local cursor    = _G['modui_xycursor']
        local x,  y     = GetCursorPosition()

        mx = ((x / scale) - (mx - width / 2) ) / width
        my = ((my + height / 2) - (y / scale)) / height

        if  mx >= 0 and my >= 0 and mx <= 1 and my <= 1 then
            cursor:SetText('•  Mouse'..format(': %.0f / %.0f', mx*100, my*100))
        else
            cursor:SetText''
        end

        if  px ~= 0 and py ~= 0 then
            player:SetText(PLAYER..format(': %.0f / %.0f', px*100, py*100))
        else
            player:SetText'X / X'
        end
    end

    local AddCoordinates = function()
        local f = CreateFrame('Frame', 'modui_coordinates', WorldMapButton)

        local player = f:CreateFontString('modui_xyplayer', 'OVERLAY')
        player:SetFont(STANDARD_TEXT_FONT, 18, 'OUTLINE')
        player:SetShadowOffset(0, -0)
        player:SetJustifyH'LEFT'
        player:SetPoint('BOTTOMRIGHT', WorldMapButton, 'BOTTOM', -12, 12)
        player:SetTextColor(1, 1, 1)

        local cursor = f:CreateFontString('modui_xycursor', 'OVERLAY')
        cursor:SetFont(STANDARD_TEXT_FONT, 18, 'OUTLINE')
        cursor:SetShadowOffset(0, -0)
        cursor:SetJustifyH'LEFT'
        cursor:SetPoint('LEFT', player, 'RIGHT', 3, 0)
        cursor:SetTextColor(1, 1, 1)

        f:SetScript('OnUpdate', OnUpdate)
    end

    local UpdateBlips = function(hide)
        if  hide then
            for i = 1, 4 do
                local f = _G['WorldMapParty'..i..'Icon']
                f:SetAlpha(0)
            end
            for i = 1,40 do
                local f = _G['WorldMapRaid'..i..'Icon']
                f:SetAlpha(0)
            end
        else
            for i = 1,12 do
                _G['moddungeonmap'..i]:Hide()
            end
            for i = 1, 4 do
                local f = _G['WorldMapParty'..i..'Icon']
                f:SetAlpha(1)
            end
            for i = 1,40 do
                local f = _G['WorldMapRaid'..i..'Icon']
                f:SetAlpha(1)
            end
        end
    end

    local AddDungeons = function()
        local d = CreateFrame('Frame', nil, WorldMapFrame)
        d:SetFrameLevel(2)
        d:SetAllPoints()

        for i = 1, 12 do
            local n   = 'moddungeonmap'..i
            local d12 = d:CreateTexture(n, 'OVERLAY')
            d12:SetWidth(256) d12:SetHeight(256)
            d12:Hide()
            d12:SetPoint(dPos[n][1], _G[dPos[n][2]], dPos[n][3])
        end
    end

    local UpdateSubZones = function(z, sz)
        if  z == 'blackwinglair' then
            if sz == 'dragonmawgarrison' or sz == 'shadowwinglair' then
                return '1'
            elseif sz == 'hallsofstrife' then
                return '2'
            elseif sz == 'crimsonlaboratories' then
                return '3'
            elseif sz == 'nefarianslair' then
                return '4'
            else
                return ''
            end
        elseif z == 'thedeadmines' then
            if sz == 'ironcladcove' or sz == 'goblinfoundry' then
                return '2'
            else
                return '1'
            end
        end
    end

    local UpdateDungeons = function(z)
        if  dSubZones[z] then
            local sz = string.gsub(string.lower(GetSubZoneText()), '%W', '')
            if  sz then
                for i = 1, 12 do
                    local d12 = _G['moddungeonmap'..i]
                    d12:SetTexture('Interface\\AddOns\\md\\art\\instances\\'..z..'\\'..UpdateSubZones(z, sz)..'\\'..z..i)
                    d12:Show()
                end
            end
        else
            for i = 1, 12 do
                local d12 = _G['moddungeonmap'..i]
                d12:SetTexture('Interface\\AddOns\\md\\art\\instances\\'..z..'\\'..z..i)
                d12:Show()
            end
        end
    end

    local ToggleDungeon = function()
        if  var.dungeon then
            local x, y  = GetPlayerMapPosition'player'
            local z     = string.gsub(string.lower(GetZoneText()), '%W', '')
            local j     = {
                WorldMapFrameAreaLabel,
                WorldMapFrameAreaDescription,
                _G['modui_coordinates']
            }

            if (x or y) == 0 then
                UpdateBlips(true)
                UpdateDungeons(z)
                for _, v in pairs(j) do v:Hide() end
            else
                UpdateBlips(false)
                for _, v in pairs(j) do v:Show() end
            end
        end
    end

    local UpdateBlipColour = function(icon, unit)
        if  not (icon and unit) then return end
        local _, class  = UnitClass(unit)
        local name      = UnitName(unit)

        if  string.find(unit, 'raid', 1, true) then
            local _, _, subgroup = GetRaidRosterInfo(string.sub(unit, 5))
            if not subgroup then return end
            icon:SetTexture(string.format([[Interface\AddOns\md\art\blips\raid]]..'%d', subgroup))
            icon:GetParent():SetWidth(30)
            icon:GetParent():SetHeight(30)
        end

        for  _, v in pairs(MODUI_CARRIERS) do
            if  string.find(v, string.lower(name)) then
                local x = UnitFactionGroup'player' == 'Alliance' and 'Horde' or 'Alliance'
                icon:SetTexture('Interface\\WorldStateFrame\\'..x..'Flag')
                icon:SetPoint('CENTER', 8, 8)
                icon:SetVertexColor(1, 1, 1)
                return
            end
         end

        local c = RAID_CLASS_COLORS[class]
        if  math.ceil(GetTime()) < .5 then
            if      UnitAffectingCombat(unit)   then    bu:SetVertexColor(.8,  0,  0)
            elseif  MapUnit_IsInactive(unit)    then    bu:SetVertexColor( 1, .8,  0)
            elseif  UnitIsDeadOrGhost(unit)     then    bu:SetVertexColor(.2, .2, .2)
            end
        elseif c then
             icon:SetVertexColor(c.r, c.g, c.b)
        else icon:SetVertexColor(.8, .8, .8)
        end
    end

    local UpdateBlip = function()
        local icon  = _G[this:GetName()..'Icon']
        if icon then UpdateBlipColour(icon, this.unit) end
    end

    local AddBlip = function(unit, state, isNormal)
        local f     = _G[unit]
        local icon  = _G[unit..'Icon']
        if  state then
            f:SetScript('OnUpdate', function() UpdateBlip(icon, unit) end)
            if  isNormal then
                icon:SetTexture[[Interface\AddOns\md\art\blips\party]]
                icon:GetParent():SetWidth(30)
                icon:GetParent():SetHeight(30)
            end
        end
    end

    local OnShow = function()
        this:SetScale(.8)
        this:EnableKeyboard(false)

        BlackoutWorld:Hide()

        ToggleDungeon()
        UpdateMicroButtons()
        SetMapToCurrentZone()
        CloseDropDownMenus()
        WorldMapFrame_PingPlayerPosition()
        PlaySound'igQuestLogOpen'
    end

    local PLAYER_LOGIN  = function()
        UIPanelWindows['WorldMapFrame'] = {
            area        = 'center',
            pushable    = 9
        }

        for i = 1, 4  do AddBlip(string.format('WorldMapParty%d', i), true, true) end
        for i = 1, 40 do AddBlip(string.format('WorldMapRaid%d', i),  true) end

        WorldMapFrame:SetScript('OnShow', OnShow)

        AddDungeons()
        AddCoordinates()
        AddQuestieSupport()
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', PLAYER_LOGIN)

    --
