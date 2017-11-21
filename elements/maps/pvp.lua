

    local var     = MODUI_VAR['elements']['map']
    local skin    = MODUI_VAR['elements']['bu_skin']
    local faction = UnitFactionGroup'player'
    local cities  = {
        'Stormwind City',
        'Ironforge',
        'Darnassus',
        'Orgrimmar',
        'Undercity',
        'Thunder Bluff'
    }

    local H = {}

    local AddMap = function()
        local bu = CreateFrame('Frame', 'modbmap_border', BattlefieldMinimap)
        bu:SetPoint('TOPLEFT', BattlefieldMinimap2, -2, 0)
        bu:SetPoint('BOTTOMRIGHT', BattlefieldMinimap11, 0, 20)

        if  skin.enable then
            modSkin(bu)
            modSkinColor(bu, skin.r, skin.g, skin.b)
        end

        BattlefieldMinimap:SetScale(1.05)
        BattlefieldMinimap:SetPoint('TOPLEFT', BattlefieldMinimapTab, 'BOTTOMLEFT', -52, 0)

        BattlefieldMinimapCloseButton:SetScale(.8)
        BattlefieldMinimapCloseButton:SetPoint('TOPRIGHT', BattlefieldMinimap3)

        BattlefieldMinimapCorner:Hide()

        BattlefieldMinimapBackground:Hide()

        for _, v in pairs (
            {
                BattlefieldMinimap1,
                BattlefieldMinimap5,
                BattlefieldMinimap9,
                BattlefieldMinimap4,
                BattlefieldMinimap8,
                BattlefieldMinimap12
            }
        ) do
            v:Hide()
        end
    end

    local ShowWorldMap = function()
        for i = 1, 12 do _G['BattlefieldMinimap'..i]:Hide() end

        BattlefieldMinimap:SetScale(1.6)

        BattlefieldMinimapCloseButton:SetScale(.7)
        BattlefieldMinimapCloseButton:SetAlpha(0)
        BattlefieldMinimapCloseButton:SetScript('OnEnter', function() this:SetAlpha(1) end)
        BattlefieldMinimapCloseButton:SetScript('OnLeave', function() this:SetAlpha(0) end)

        if skin.enable then modSkinHide(_G['modbmap_border']) end
    end

    local ShowBattleMap = function()
        for i = 1, 12 do _G['BattlefieldMinimap'..i]:Show() end

        BattlefieldMinimap:SetScale(1.05)

        BattlefieldMinimapCloseButton:SetScale(.8)
        BattlefieldMinimapCloseButton:SetAlpha(1)
        BattlefieldMinimapCloseButton:SetScript('OnEnter', nil)
        BattlefieldMinimapCloseButton:SetScript('OnLeave', nil)

        if skin.enable then modSkinShow(_G['modbmap_border']) end

        for _, v in pairs (
            {
                BattlefieldMinimap1,
                BattlefieldMinimap5,
                BattlefieldMinimap9,
                BattlefieldMinimap4,
                BattlefieldMinimap8,
                BattlefieldMinimap12,
            }
        ) do
            v:Hide()
        end
    end

    local HideCityMap = function(map)
        local  z  = GetRealZoneText()
        for _, v in pairs(cities) do
            if string.find(z, v) and map:IsVisible() then map:Hide() end
        end
    end

    local UpdateMap = function()
        local map = BattlefieldMinimap
        HideCityMap(map)
        if  MiniMapBattlefieldFrame.status == 'active' or GetNumWorldStateUI() > 0 then
            ShowBattleMap()
        else
            ShowWorldMap()
        end
        --  reset map tiles
        if  map:IsVisible() then
            map:Hide() map:Show()
        end
    end

    local UpdateBlips = function()
        for i = 1, 40 do
            local  blip = _G['BattlefieldMinimapRaid'..i]
            local  icon = _G['BattlefieldMinimapRaid'..i..'Icon']
            local  name = blip.name or UnitName(blip.unit)
            if not name then break end

            blip:SetWidth(24) blip:SetHeight(24)

            if  string.find(blip.unit, 'raid', 1, true) then
                local _, _, sub = GetRaidRosterInfo(string.sub(blip.unit, 5))
                local _, class  = UnitClass(blip.unit)
                local c         = RAID_CLASS_COLORS[class]
                icon:SetTexture(string.format('Interface\\AddOns\\md\\art\\blips\\raid'..'%d', sub))
                icon:SetPoint('CENTER', blip)

                if  math.ceil(GetTime()) < .5 then
                    if UnitAffectingCombat(unit) then       icon:SetVertexColor(.8,  0,  0)
                    elseif MapUnit_IsInactive(unit) then    icon:SetVertexColor( 1, .8,  0)
                    elseif UnitIsDeadOrGhost(unit) then     icon:SetVertexColor(.2, .2, .2)
                    end
                elseif c then
                    icon:SetVertexColor(c.r, c.g, c.b)
                end

                for  _, v in pairs(MODUI_CARRIERS) do
                    if  v == name then
                        local x = UnitFactionGroup'player' == 'Alliance' and 'Horde' or 'Alliance'
                        icon:SetTexture('Interface\\WorldStateFrame\\'..x..'Flag')
                        icon:SetPoint('CENTER', 8, 8)
                        icon:SetVertexColor(1, 1, 1)
                    end
                end
            end
        end
    end

    local Toggle  = function()
        local map = BattlefieldMinimap
        local z   = GetZoneText()

        if  map:IsVisible() then
            map:Hide()
            SHOW_BATTLEFIELD_MINIMAP = '0'
        else
            if  z == 'Silithus' or z == 'Eastern Plaguelands' then
                SHOW_BATTLEFIELD_MINIMAP = '1'
                map:Show()
                ShowWorldMap()
            elseif MiniMapBattlefieldFrame.status == 'active' or GetNumWorldStateUI() > 0 then
                SHOW_BATTLEFIELD_MINIMAP = '1'
                map:Show()
                ShowBattleMap()
            else
                SHOW_BATTLEFIELD_MINIMAP = '1'
                map:Show()
                ShowWorldMap()
            end
        end
        HideCityMap(map)
    end

    local OnUpdate = function(elapsed)
        UpdateBlips()
        H.BattlefieldMinimap_OnUpdate(elapsed)
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'ADDON_LOADED'
    e:SetScript('OnEvent', function()
        if  e.loaded then UpdateMap() end
        if  arg1 == 'Blizzard_BattlefieldMinimap' then
            if  var.pvp then
                AddMap()

                H.BattlefieldMinimap_OnUpdate   = BattlefieldMinimap_OnUpdate

                this:RegisterEvent'ZONE_CHANGED_NEW_AREA'
                this:UnregisterEvent'ADDON_LOADED'

                BattlefieldMinimap_Toggle       = Toggle
                BattlefieldMinimap_OnUpdate     = OnUpdate
                e.loaded = true
            end
        end
    end)

    --
