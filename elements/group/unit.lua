

    local bg                    = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
    }
    local e, u                  = CreateFrame'Frame', CreateFrame'Frame'
    local xx                    = 4
    local a_offset, y_offset    = 0, 0

    local var                   = MODUI_VAR['elements']['unit']['raid']
    local skin                  = MODUI_VAR['elements']['bu_skin']

    local cursed, bu            = {}, {}

    local decurse = {           -- we should scoop this up from the spellbook maybe?
        ['MAGE']    = 'Remove Lesser Curse',
        ['DRUID']   = 'Abolish Poison',
        ['DRUID']   = 'Remove Curse',
        ['PALADIN'] = 'Cleanse',
        ['PRIEST']  = 'Abolish Disease',
        ['PRIEST']  = 'Dispel Magic',
        ['SHAMAN']  = 'Cleanse Toxins',
        ['SHAMAN']  = 'Cleane Spirit',
    }

    local events = {
        'PLAYER_LOGIN',
        'PLAYER_ENTERING_WORLD',
        'CHAT_MSG_SYSTEM',
        'RAID_ROSTER_UPDATE',
    }

    local roster = {
        [1] = {},
        [2] = {},
        [3] = {},
        [4] = {},
        [5] = {},
        [6] = {},
        [7] = {},
        [8] = {},
    }

    local healcomm  = AceLibrary'HealComm-1.0'      -- healcomm
    e.proximity     = ProximityLib:GetInstance'1'   -- proximitylib
    e.throttle      = 0

    local CacheRaid = function(num)
        if  num < 1 then
            for i = 1,  8 do _G['modraid_grp'..i]:Hide() end
            for i = 1, 40 do _G['modraid'..i]:Hide() end
        elseif  RAID_SUBGROUP_LISTS then
            for i = 1,  8 do roster[i] = {} end
            for i = 1,  8 do
                for j = 1, 5 do
                    if  RAID_SUBGROUP_LISTS[i][j] then
                        roster[i][j] = 'raid'..RAID_SUBGROUP_LISTS[i][j]
                    else
                        roster[i][j] = nil
                    end
				end
                table.sort(roster[i], function(a, b) 
                    return a < b 
                end)
            end
        end
    end

    local AddUnit = function(index)
        for i = 1, 8 do
            local header = _G['modraid_grp'..i]
            if  getn(roster[i]) > 0 then
                header:Show() 
                header.text:SetText(i)
            else
                header:Hide()
            end
            for j, v in pairs(roster[i]) do
                local raid = bu[index]
                raid.unit  = v
                if  raid.unit then
                    raid:Show()
                end
                index = index + 1
            end
        end
        for i = index, 40 do
            local raid = bu[index]
            raid:Hide()
            -- raid.unit  = nil
        end
    end

    local AddLayout = function(index)
        for i = 1, 8 do
            local header = _G['modraid_grp'..i]
            for j = 1, getn(roster[i]) do
                local raid = bu[index]
                if  j == 1 then
                    raid:ClearAllPoints()
                    raid:SetPoint('TOP', header, 'BOTTOM', 0, -10)
                else
                    raid:ClearAllPoints()
                    raid:SetPoint('TOP', bu[index - 1], 'BOTTOM', 0, -10)
                end
                index = index + 1
            end
        end
    end

    local UpdateRoster = function()
        CacheRaid(GetNumRaidMembers())
        AddUnit(1)  AddLayout(1)
    end

    local GetBuffs = function(bu)
        local v = MODUI_GetBuffs(UnitName(bu.unit))[1]  -- first buff only
        if  v and v.icon then
            bu.aura:Show()
            bu.aura.icon:SetTexture(v.icon)
            --modSkinColor(bu.aura, v.border.r, v.border.g, v.border.b) -- ADDDD COLOUR
        else
            bu.aura:Hide()
            bu.aura.icon:SetTexture''
        end
    end

    local GetDebuffs = function()
        if this.unit ~= arg1 or not this.unit then return end
        local _, _, dtype = UnitDebuff(this.unit, 1, 1)

        if  dtype then
            local colour = DebuffTypeColor[dtype]
            if  skin.enable then 
                modSkinColor(this, colour.r, colour.g, colour.b) 
            end
            tinsert(cursed, this.unit)
        else
            if  skin.enable then 
                modSkinColor(this, .7, .7, .7) 
            end
            if  cursed[this.unit] then 
                tremove(cursed, this.unit) 
            end
        end

        for i = 1, 2 do
            local texture, _, dtype = UnitDebuff(this.unit, i)
            if  texture and var.debuff then
                local colour = DebuffTypeColor[dtype] or DebuffTypeColor['none']
                this.debuffs[i]:SetTexture(texture)
                this.debuffs[i]:Show()
                this.debuffs[i].border:SetVertexColor(colour.r, colour.g, colour.b)
                this.debuffs[i].border:Show()
            else
                this.debuffs[i]:SetTexture''
                this.debuffs[i]:Hide()
                this.debuffs[i].border:Hide()
            end
        end
    end

    local DecurseUnit = function(unit)
        local class  = UnitClass'player'
        local target = nil
        -- target player
        -- castspellbyname
        -- retarget og. target if exists
        if  UnitExists'target' then
            target  = UnitName'target'                               -- might need to be id instead
        end

        if  decurse[class] then                         -- this is never defuned
            CastSpellByName(decurse[class])
        end  -- where is the key specified?

        if  target then
            TargetUnitByName(target)                                -- target by name?
            target  = nil
        end
    end

    local AddRaidIcon = function(bu)
        bu.name:Show()
        bu.raidicon:Hide()
        if  bu.flag:IsShown() or bu.healv:IsShown() or bu.rez:IsShown() then
            bu.name:Hide() 
            return 
        end
        if  UnitExists(bu.unit) then
            local i = GetRaidTargetIndex(bu.unit)
            if  i then
                bu.name:Hide()
                bu.raidicon:Show()
                SetRaidTargetIconTexture(bu.raidicon, i)
            end
        end
    end

    local AddRange = function(bu, time, seen, r, g, b)
        if  time and seen < 3 then
            bu.hp:SetStatusBarColor(r, g, b)
        else
            bu.hp:SetStatusBarColor(r*.375, g*.375, b*.375)
        end
    end

    local AddHealComm = function(bu)
        local name         = UnitName(bu.unit)
    	local heal         = healcomm:getHeal(name)
        local rez          = healcomm:UnitisResurrecting(name)
    	local v, max       = UnitHealth(bu.unit),  UnitHealthMax(bu.unit)
    	local bu_w, bu_h   = bu.hp:GetWidth(),     bu.hp:GetHeight()
    	local hp_w, hp_h   = bu_w*(v/max),         bu_h*(v/max)

        if  rez then 
            bu.rez:Show() 
        else 
            bu.rez:Hide() 
        end

    	if  heal > 0  and v < max and not UnitIsDeadOrGhost(bu.unit) then
            local  w = bu_w*(heal/max)
    		if (hp_w + w) > bu_w then w = bu_w - hp_w end
    		bu.heal:Show()
    		bu.heal:SetWidth(w)
    		bu.heal:SetHeight(bu_h)
    		bu.heal:ClearAllPoints()
    		bu.heal:SetPoint('TOPLEFT', bu.hp, hp_w, 0)
        else
            bu.heal:Hide()
    	end
    end

    local AddHeal = function(bu)
        local v = MODUI_GetHeal(UnitName(bu.unit))
        bu.healv:Hide()
        if  v then
            if  GetTime() < v.timeEnd then
                local y = -4
                if  v.crit == 1 then y = 0 end
                y = y + v.y
                if  y + v.y < y + 8 then 
                    v.y = v.y + .5 
                end

                if  (v.timeEnd - GetTime()) < .6 then
                    bu.healv:SetAlpha(mod((v.timeEnd - GetTime()), 1))
                else
                    bu.healv:SetAlpha(.6)
                end

                bu.healv:SetFont(STANDARD_TEXT_FONT, v.crit == 1 and 16 or 12, 'MONOCHROMEOUTLINE')
                bu.healv:SetPoint('CENTER', bu, -1, y)
                bu.healv:SetText('+ '..v.amount..(v.crit == 1 and '!' or ''))
                bu.healv:Show()
            end
        end
	end

    local AddStatus = function(bu, unit)
        bu.name:SetShadowColor(0, 0, 0)
        if  not UnitIsConnected(unit) then
            bu.hp:SetStatusBarColor(.7, .7, .7)
            bu.hp:SetMinMaxValues(0, 1)
            bu.hp:SetValue(1)
            bu.name:SetTextColor(.1, .1, .1)
        elseif UnitIsDead(bu.unit) then
            bu.name:SetTextColor(1, 0, 0)
        elseif UnitIsGhost(bu.unit) then
            bu.name:SetShadowColor(.15, .15, .15)
            bu.name:SetTextColor(.5, .5, .5)
        else
            local _, class = UnitClass(unit)
            local colour   = class and RAID_CLASS_COLORS[class] or {r = .2, g = .2, b = .2}
            bu.name:SetTextColor(colour.r, colour.g, colour.b)
        end
    end

    local AddFlag = function(bu)
        for _, v in pairs(MODUI_CARRIERS) do
            local n = UnitName(bu.unit)
            if  string.find(string.lower(n), v) then 
                bu.flag:Show()
                break
            end
        end
    end

    local ToggleTank = function(unit)
        if  this.tank:IsShown() then
            this.tank:Hide()
        else
            this.tank:Show()
        end
    end

    local OnDragStart = function()
        this:StartMoving()
    end

    local OnDragStop = function() 
        this:StopMovingOrSizing()
    end

    local OnClick = function()
        if  arg1 == 'RightButton' then
            if  cursed[this.unit] then
                DecurseUnit(this.unit)
            else
                ToggleTank(this.unit)
            end
        else
            if  CursorHasItem() then
                DropItemOnUnit(this.unit)
            elseif SpellIsTargeting() then
                SpellTargetUnit(this.unit)
            else
                TargetUnit(this.unit)
            end
        end
    end

    local UpdateUnits = function()
        for i,  v in pairs(bu) do
            if  v:IsShown() then
                local hp, mana, name = v.hp, v.mana, v.name
                local unit           = v.unit
                local power          = UnitPowerType(unit)
                local _, time        = e.proximity:GetUnitRange(unit)
                local seen           = GetTime() - (time or 100)
                local r, g, b        = name:GetTextColor()

                hp:SetMinMaxValues(0, UnitHealthMax(unit))
                hp:SetValue(UnitHealth(unit))

                mana:SetMinMaxValues(0, UnitManaMax(unit))
                mana:SetValue(UnitMana(unit))
                mana:SetStatusBarColor(
                    (power == 1 or  power == 3)     and 1 or 0,
                    power  == 1 and 0 or power == 3 and 1 or 0,
                    power  == 1 and 0 or power == 3 and 0 or 1
                )

                name:SetText(string.sub(UnitName(unit), 1, 6))

                GetBuffs(v)     AddRaidIcon(v)  AddFlag(v) 
                AddHealComm(v)  AddHeal(v)      AddStatus(v, unit)
                AddRange(v, time, seen, r, g, b)

                if  power ~= 0 and UnitMana(unit) < 1 then
                    hp:SetPoint('BOTTOMRIGHT', v)
                    mana:Hide()
                else
                    hp:SetPoint('BOTTOMRIGHT', v, 0, 8)
                    mana:Show()
                end
            end
        end
    end

    local OnUpdate = function()
        e.throttle = e.throttle + arg1
        if  e.throttle > .2 then
            UpdateUnits()
            e.throttle = 0
        end
    end

    local CreateUnits = function()
        for i = 1, 8 do
            local header = CreateFrame('Button', 'modraid_grp'..i, UIParent)
            header:SetWidth(32) 
            header:SetHeight(12)
            header:SetMovable(true) 
            header:SetUserPlaced(true)
            header:RegisterForDrag'LeftButton' 
            header:EnableMouse(true)
            header:Hide()

            header.text = header:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
            header.text:SetPoint('CENTER', header)
            header.text:SetJustifyH'CENTER'
            header.text:SetText'group'

            if  i == 1 then
                if  var.L2R then
                    header:SetPoint('TOPLEFT',  Minimap, 'BOTTOMLEFT', -138, -50)
                else
                    header:SetPoint('TOPRIGHT', Minimap, 'BOTTOMRIGHT', -53, -50)
                end
            elseif i == (xx + 1) then
                header:SetPoint('TOPLEFT',  _G['modraid_grp'..(i - xx)], 'BOTTOMLEFT', 0, -180)
            else
                -- changed: might be an issue w/ logic?
                header:SetPoint(
                    var.L2R and 'LEFT' or 'RIGHT', 
                    _G['modraid_grp'..(i - 1)], 
                    var.L2R and 'RIGHT' or 'LEFT', 
                    var.debuff and (var.L2R and 44 or -44) or (var.L2R and 32 or -32), 
                    0
                )
            end

            header:SetScript('OnDragStart', OnDragStart)
            header:SetScript('OnDragStop',  OnDragStop)
        end

        for i = 1, 40 do
            bu[i] = CreateFrame('Button', 'modraid'..i, UIParent)
            bu[i]:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
            bu[i]:SetWidth(var.x  and var.x or 53)
            bu[i]:SetHeight(var.y and var.y or 24)
    		bu[i]:SetResizable(true)
            bu[i]:SetBackdrop(bg)
            bu[i]:SetBackdropColor(0, 0, 0, 1)
            bu[i]:SetFrameLevel(0)
            bu[i]:Hide()

            bu[i].hp = CreateFrame('StatusBar', nil, bu[i])
            MODUI_SB(bu[i].hp)
            bu[i].hp:SetFrameLevel(0)
            bu[i].hp:SetMinMaxValues(0, 100)
            bu[i].hp:SetValue(100)
            bu[i].hp:SetStatusBarColor(0, 1, 0)
            bu[i].hp:SetPoint('TOPLEFT',     bu[i], 1, -1)
            bu[i].hp:SetPoint('BOTTOMRIGHT', bu[i], -1, 8)

            bu[i].mana = CreateFrame('StatusBar', nil, bu[i])
            MODUI_SB(bu[i].mana)
            bu[i].mana:SetHeight(6)
            bu[i].mana:SetFrameLevel(0)
            bu[i].mana:SetMinMaxValues(0, 100)
            bu[i].mana:SetValue(100)
            bu[i].mana:SetPoint('TOPLEFT',  bu[i].hp, 'BOTTOMLEFT',  0, -1)
            bu[i].mana:SetPoint('TOPRIGHT', bu[i].hp, 'BOTTOMRIGHT', 0, -1)

            bu[i].name = bu[i]:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
            bu[i].name:SetPoint('TOP', bu[i], 0, -3)
            bu[i].name:SetJustifyH'CENTER'

            bu[i].heal = CreateFrame('StatusBar', nil, bu[i].hp)
            bu[i].heal:SetWidth(1) 
            bu[i].heal:SetHeight(16)
            bu[i].heal:SetFrameLevel(0)
            bu[i].heal:SetMinMaxValues(0, 1)
            bu[i].heal:SetValue(1)
            bu[i].heal:SetStatusBarTexture(sb)
            bu[i].heal:SetStatusBarColor(0, 1, 0, .7)

            bu[i].healv = bu[i]:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
            bu[i].healv:SetTextColor(0, .6, 0, .6)
            bu[i].healv:SetPoint('CENTER', bu[i], 0, -4)

            bu[i].raidicon = bu[i]:CreateTexture(nil, 'OVERLAY')
            bu[i].raidicon:SetWidth(17) 
            bu[i].raidicon:SetHeight(17)
            bu[i].raidicon:SetTexture[[Interface\TargetingFrame\UI-RaidTargetingIcons]]
            bu[i].raidicon:SetPoint('CENTER', bu[i])

            bu[i].rez = bu[i]:CreateTexture(nil, 'OVERLAY', nil, 7)
            bu[i].rez:SetWidth(24) 
            bu[i].rez:SetHeight(24)
            bu[i].rez:SetTexture[[Interface\AddOns\md\art\group\Raid-Icon-Rez.tga]]
            bu[i].rez:SetPoint('CENTER', bu[i])
            bu[i].rez:Hide()

            bu[i].flag = bu[i]:CreateTexture(nil, 'OVERLAY', nil, 7)
            bu[i].flag:SetWidth(24) bu[i].flag:SetHeight(24)
            bu[i].flag:SetTexture('Interface\\WorldStateFrame\\'..(UnitFactionGroup'player' == 'Alliance' and 'Horde' or 'Alliance')..'Flag')
            bu[i].flag:SetPoint('CENTER', bu[i])
            bu[i].flag:Hide()

            bu[i].tank = bu[i].hp:CreateTexture(nil, 'OVERLAY', nil, 7)
            bu[i].tank:SetWidth(16)
            bu[i].tank:SetHeight(16)
            bu[i].tank:SetTexture[[Interface\AddOns\md\art\group\Tank.tga]]
            bu[i].tank:SetPoint('CENTER', bu[i], 'BOTTOM', 0, 1)
            bu[i].tank:Hide()

            bu[i].aura = CreateFrame('Button', nil, bu[i])
            bu[i].aura:SetWidth(19)
            bu[i].aura:SetHeight(19)
            bu[i].aura:SetPoint('CENTER', bu[i], 'BOTTOM', 0, 6)
            bu[i].aura:SetFrameLevel(2)
            bu[i].aura:EnableMouse(false)
            bu[i].aura:Hide()

            bu[i].aura.icon = bu[i].aura:CreateTexture(nil, 'BACKGROUND', 0, -7)
            bu[i].aura.icon:SetAllPoints()
            bu[i].aura.icon:SetAlpha(.7)

            if  skin.enable then
                modSkin(bu[i])
                modSkinColor(bu[i], skin.r, skin.g, skin.b)

                modSkin(bu[i].aura, 4)
                modSkinColor(bu[i].aura, skin.r, skin.g, skin.b)
            end

            bu[i].debuffs = {}

            for j = 1, 2 do
                bu[i].debuffs[j] = bu[i]:CreateTexture(nil, 'BACKGROUND')
                bu[i].debuffs[j]:SetWidth(10) 
                bu[i].debuffs[j]:SetHeight(10)
                bu[i].debuffs[j]:Hide()

                bu[i].debuffs[j].border = bu[i]:CreateTexture(nil, 'ARTWORK')
                bu[i].debuffs[j].border:SetWidth(12) 
                bu[i].debuffs[j].border:SetHeight(12)
                bu[i].debuffs[j].border:SetPoint('CENTER', bu[i].debuffs[j])
                bu[i].debuffs[j].border:SetTexture[[Interface\Buttons\UI-Debuff-Overlays]]
                bu[i].debuffs[j].border:SetTexCoord(.296875, .5703125, 0, .515625)
                bu[i].debuffs[j].border:Hide()

                if  j == 1 then
                    bu[i].debuffs[j]:SetPoint('TOPLEFT', bu[i], 'TOPRIGHT', 5, -2)
                else
                    bu[i].debuffs[j]:SetPoint('TOP', bu[i].debuffs[1], 'BOTTOM', 0, -1)
                end
            end

            bu[i]:RegisterEvent'UNIT_AURA'
            bu[i]:SetScript('OnEvent',  GetDebuffs)
            bu[i]:SetScript('OnClick',  OnClick)
            bu[i]:SetScript('OnEnter',  UnitFrame_OnEnter)
            bu[i]:SetScript('OnLeave',  UnitFrame_OnLeave)
        end
    end

    local AddSpawnButton = function(t, y, a)
        local bu = Minimap.raid
        bu:Show()
        if  a + a_offset < a + .6 then
            a        = a + a_offset
            a_offset = a_offset + .005
            bu:SetAlpha(a)
        end
        if  y + y_offset < y + 12 then
            y           = y + y_offset
            y_offset    = y_offset + 2
            bu:SetPoint('TOP', Minimap, 'BOTTOM', 2, -y)
        end
        if  bu:GetAlpha() == 1 and y_offset == 12 then 
            u:SetScript('OnUpdate', nil) 
        end
    end

    local f_OnEnter = function()
        this.text:SetTextColor(1, 1, 0)
        GameTooltip:SetOwner(this, 'ANCHOR_TOPRIGHT', -30, -60)
        GameTooltip:SetText'Click to show/hide Raid Frames'
        GameTooltip:Show()
    end

    local f_OnLeave = function()
        this.text:SetTextColor(0, 1, 0)
        GameTooltip:Hide()
    end

    local f_OnClick = function()
        local t = this.text:GetText()
        if  t == '+' then
            this.text:SetText'–'
            UpdateRoster()
            UpdateUnits()
        elseif t == '–' then
            this.text:SetText'+'
            for i = 1,  8 do 
                _G['modraid_grp'..i]:Hide() 
            end
            for i = 1, 40 do 
                bu[i]:Hide() 
            end
        end
    end

    local CreateSpawnButton = function()
        Minimap.raid = CreateFrame('Button', 'modui_RaidSpawn', Minimap)
        Minimap.raid:SetWidth(20) 
        Minimap.raid:SetHeight(100)
        Minimap.raid:SetPoint('TOP', Minimap, 'BOTTOM')
        Minimap.raid:Hide()

        Minimap.raid.text = Minimap.raid:CreateFontString(nil, 'OVERLAY')
        Minimap.raid.text:SetFont(STANDARD_TEXT_FONT, 24, 'OUTLINE')
        Minimap.raid.text:SetPoint('CENTER', Minimap.raid)
        Minimap.raid.text:SetText'+'
        Minimap.raid.text:SetTextColor(0, 1, 0)

        Minimap.raid:SetScript('OnEnter', f_OnEnter)
        Minimap.raid:SetScript('OnLeave', f_OnLeave)
        Minimap.raid:SetScript('OnClick', f_OnClick)
    end

    local OnEvent = function()
        local f = Minimap.raid
        if  event == 'PLAYER_LOGIN' then
            CreateUnits()
            CreateSpawnButton()
        elseif (
            event == 'PLAYER_ENTERING_WORLD' and UnitInRaid'player')
        or (event == 'CHAT_MSG_SYSTEM' and string.find(arg1, 'You have joined a raid group')) then
            local t, y, a   = GetTime() + 60, -20, .5
            e.reset         = true
            e:UnregisterEvent'PLAYER_ENTERING_WORLD'
            u:SetScript('OnUpdate', function() AddSpawnButton(t, y, a) end)
            f.text:SetText'+'
        elseif  event == 'RAID_ROSTER_UPDATE' then
            UpdateRoster()
            if  GetNumRaidMembers() < 1 or not UnitInRaid'player' then
                print'hide now'
                for i = 1, 8 do _G['modraid_grp'..i]:Hide() end
                f:Hide() 
                e.reset = true
            end
        end
    end

    for _, v in pairs(events) do e:RegisterEvent(v) end

    e:SetScript('OnEvent',  OnEvent)
    e:SetScript('OnUpdate', OnUpdate)


    --
