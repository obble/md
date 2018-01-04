

    local TEXTURE  = [[Interface\AddOns\md\customise\statusbar\statusbar.tga]]
    local BACKDROP = {bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],}
    local var      = MODUI_VAR['elements']['nameplate']
    local skin     = MODUI_VAR['elements']['bu_skin']
    local _, class = UnitClass'player'
    local p, t     = {}, {}
    local showpet  = false              -- TOGGLE NON_COMBAT PET VISIBILITY


    local pets = {
        'Ancona Chicken',
        'Black Kingsnake', 'Brown Snake', 'Crimson Snake',
        'Bombay', 'casnish Rex', 'Orange Tabby', 'Siamese', 'Silver Tabby',
        'Cockatiel', 'Great Horned Owl', 'Green Wing Macaw', 'Hawk Owl',  'Hyacinth Macaw', 'Senegal',
        'Cockroach',
        'Lifelike Mechanical Toad', 'Lil\' Smokey', 'Mechanical Chicken', 'Mechanical Squirrel', 'Pet Bombling',
        'Prairie Dog',
        'Smolderweb Hatchling',
        'Sprite Darter', 'Tiny Black Whelpling', 'Tiny Crimson Whelpling', 'Tiny Emerald Whelpling',
        'Unconscious Dig Rat',
        'Worg Pup',
    }

    local critters = {
        'Adder',
        'Beetle', 'Fire Beetle', 'Roach',
        'Cat',
        'Chicken',
        'Cow',
        'Deer', 'Fawn', 'Gazelle',
        'Biletoad', 'Frog', 'Giant Marsh Frog', 'Huge Toad', 'Toad',
        'Hare', 'Rabbit',
        'Horse',
        'Lava Crab',
        'Maggot',
        'Moccasin', 'Prairie Dog', 'Squirrel',
        'Mouse', 'Rat', 'Dig Rat',
        'Ram',
        'School of Fish',
        'Scaspion',
        'Sheep',
        'Snake',
        'Swine',
    }

    local isPlate = function(f)
        local  region = f:GetRegions()
        if not region or region:GetObjectType() ~= 'Texture'
        or  region:GetTexture() ~= [[Interface\Tooltips\Nameplate-Border]] then
            return false
        end
        return true
    end

    local isPet = function(n)
        if pets[n] or critters[n] then return true end
        return false
    end

    local isPlayer = function(n)
        if  not t[n] then
            TargetByName(n, true)
            table.insert(t, n)
            t[n] = 'ok'
            if  UnitIsPlayer'target' then
                local _, rankNo     = GetPVPRankInfo(UnitPVPRank'target')
                local _, faction    = UnitFactionGroup'target'
                local _, class      = UnitClass'target'
                local pvp           = UnitIsPVP'target'
                local ffa           = UnitIsPVPFreeForAll'target'
                table.insert(p, n)
                p[n] = {
                    ['class']   = string.upper(class),
                    ['rank']    = rankNo,
                    ['pvp']     = pvp,
                    ['ffa']     = ffa,
                    ['faction'] = faction,
                }
            else
                local pvp = UnitIsPVP'target'
                if  pvp then
                    local _, faction = UnitFactionGroup'target'
                    table.insert(p, n)
                    p[n] = {
                        ['pvp']     = pvp,
                        ['faction'] = faction,
                    }
                end
            end
        end
    end

    local GetTimerLeft = function(tEnd)
        local t = tEnd - GetTime()
        if t > 5 then return decimal_round(t, 0) else return decimal_round(t, 1) end
    end

    local AddPlates = function(plate)    -- STYLE
        local health = plate:GetChildren()
        local border, glow, name, level, _, raidicon = plate:GetRegions()
        local n = name:GetText()

        plate:SetFrameLevel(1)

        name:SetFont(STANDARD_TEXT_FONT, 12)
        name:ClearAllPoints()
        name:SetPoint('BOTTOMRIGHT', plate, 'TOPRIGHT', -4, -16)
        name:SetJustifyH'RIGHT'

        health:SetStatusBarTexture''
        health:SetFrameLevel(1)

        health.new = CreateFrame('StatusBar', nil, health)
        health.new:SetPoint('TOPLEFT', health)
        health.new:SetWidth(116)
        health.new:SetHeight(10)
        health.new:SetStatusBarTexture(TEXTURE)
        health.new:SetFrameLevel(1)

        border:SetVertexColor(.2, .2, .2)
        border:SetDrawLayer'OVERLAY'

        level:ClearAllPoints()
        level:SetPoint('LEFT', health, 'RIGHT', 3, 0)
        level:SetFont(STANDARD_TEXT_FONT, 11)
        level:SetJustifyH'LEFT'

        plate.bg = health.new:CreateTexture(nil, 'BACKGROUND')
        plate.bg:SetAllPoints()
        plate.bg:SetTexture[[Interface\Tooltips\UI-Tooltip-Background]]
        plate.bg:SetVertexColor(0, 0, 0, 1)

        plate.cast = CreateFrame('StatusBar', nil, plate)
        plate.cast:SetStatusBarTexture(TEXTURE)
        plate.cast:SetStatusBarColor(1, .4, 0)
        plate.cast:SetBackdrop(BACKDROP)
        plate.cast:SetBackdropColor(0, 0, 0)
        plate.cast:SetHeight(8)
        plate.cast:SetPoint('LEFT', plate, 4, 0)
        plate.cast:SetPoint('RIGHT', plate, -4, 0)
        plate.cast:SetPoint('TOP', health, 'BOTTOM', 0, -8)

        plate.cast.text = plate.cast:CreateFontString(nil, 'OVERLAY')
        plate.cast.text:SetTextColor(1, .8, 0)
        plate.cast.text:SetFont(STANDARD_TEXT_FONT, 11)
        plate.cast.text:SetShadowOffset(1, -1)
        plate.cast.text:SetShadowColor(0, 0, 0)
        plate.cast.text:SetPoint('TOPLEFT', plate.cast, 'BOTTOMLEFT', 0, -2)

        plate.cast.timer = plate.cast:CreateFontString(nil, 'OVERLAY')
        plate.cast.timer:SetTextColor(1, 1, 1)
        plate.cast.timer:SetFont(STANDARD_TEXT_FONT, 9)
        plate.cast.timer:SetPoint('RIGHT', plate.cast)

        plate.cast.icon = plate.cast:CreateTexture(nil, 'OVERLAY', nil, 7)
        plate.cast.icon:SetWidth(28) plate.cast.icon:SetHeight(28)
        plate.cast.icon:SetPoint('BOTTOMRIGHT', plate.cast, 'BOTTOMLEFT', -10, 1)
        plate.cast.icon:SetTexture[[Interface\Icons\Spell_nature_purge]]
        plate.cast.icon:SetTexCoord(.1, .9, .1, .9)

        local bu = CreateFrame('Frame', nil, plate.cast)
        bu:SetAllPoints(plate.cast.icon)

        plate.heal = plate:CreateFontString(nil, 'OVERLAY')
        plate.heal:SetTextColor(0, .6, 0, .6)
        plate.heal:Hide()

        plate.buffs = {}
        for i = 1, 4 do
            plate.buffs[i] = CreateFrame('Frame', nil, plate)
            plate.buffs[i]:SetWidth(25) plate.buffs[i]:SetHeight(15)
            plate.buffs[i]:SetPoint('BOTTOMLEFT', plate, 'TOPLEFT', (i - 1)*32 + (i - 1)*2 + 5, -8)
            plate.buffs[i]:Hide()

            --  modSkin(plate.buffs[i])
            --  modSkinColor(plate.buffs[i], .9, .9, .9)

            plate.buffs[i].icon = plate.buffs[i]:CreateTexture(nil, 'ARTWORK')
            plate.buffs[i].icon:SetAllPoints()
            plate.buffs[i].icon:SetTexCoord(.1, .9, .25, .75)

            plate.buffs[i].duration = plate.buffs[i]:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
            plate.buffs[i].duration:SetFont(STANDARD_TEXT_FONT, 10)
            plate.buffs[i].duration:SetTextColor(1, 1, 1)
            plate.buffs[i].duration:SetPoint('BOTTOM', plate.buffs[i], 'TOP', 0, 3)
        end

        plate.totem = CreateFrame('Frame', nil, plate)
        plate.totem:SetWidth(26)
        plate.totem:SetHeight(22)
        plate.totem:SetPoint('BOTTOM', plate)

        plate.totem.icon = plate.totem:CreateTexture(nil, 'ARTWORK')
        plate.totem.icon:SetAllPoints()
        plate.totem.icon:SetTexCoord(.1, .9, .15, .85)

        if  class == 'ROGUE' or class == 'DRUID' then
            plate.cp = plate:CreateFontString(nil, 'OVERLAY')
            plate.cp:SetFont(STANDARD_TEXT_FONT, 18, 'OUTLINE')
            plate.cp:SetPoint('LEFT', health)
            plate.cp:Hide()
        end

        plate.rank = plate:CreateTexture(nil, 'OVERLAY')
        plate.rank:SetWidth(14)
        plate.rank:SetHeight(13)
        plate.rank:SetPoint('RIGHT', name, 'LEFT', -3, 1)
        plate.rank:Hide()

        plate.pvp = plate:CreateTexture(nil, 'OVERLAY', nil, 7)
        plate.pvp:SetWidth(30)
        plate.pvp:SetHeight(18)
        plate.pvp:SetPoint('RIGHT', health.new, 'LEFT', 30, 7)
        plate.pvp:SetTexCoord(0, 1, 0, .6)
        plate.pvp:Hide()

        if  not var.pets then
            if isPet(n) then plate:Hide() end
        end

        if  skin.enable then
            modSkin(bu)
            modSkinColor(bu, skin.r, skin.g, skin.b)

            modSkin(plate.cast)
            modSkinColor(plate.cast, skin.r, skin.g, skin.b)

            modSkin(plate.totem)
            modSkinColor(plate.totem, skin.r, skin.g, skin.b)

            for i = 1, 4 do
                modSkin(plate.buffs[i])
                modSkinColor(plate.buffs[i], skin.r, skin.g, skin.b)
            end
        end

        plate.skinned = true
    end

    local AddSize = function(plate)
        local health = plate:GetChildren()
        plate:SetWidth(120)
        health:SetWidth(96)
        health.new:SetWidth(96)
    end

    local AddValue = function(plate)
        local health = plate:GetChildren()
        local min, max = health:GetMinMaxValues()
        health.new:SetMinMaxValues(min, max)
        health.new:SetValue(health:GetValue())
    end

    local AddColour = function(plate)
        local health  = plate:GetChildren()
        local r, g, b = health:GetStatusBarColor()
        health.new:SetStatusBarColor(r, g, b)
    end

    local AddClass = function(plate)    -- CLASS COLOUR
        local health = plate:GetChildren()
        local _, _, name = plate:GetRegions()
        local n = name:GetText()
        local r = health:GetStatusBarColor()

        if not p[n] and not UnitName'target'
        and not string.find(n, '%s') and string.len(n) < 13
        and not t[n] then
            isPlayer(n) ClearTarget()
        end

        if  p[n] and p[n]['class'] and p[n]['faction'] ~= UnitFactionGroup'player' then
            local colour = RAID_CLASS_COLORS[p[n]['class']]
            health:SetStatusBarColor(colour.r, colour.g, colour.b)
            health.new:SetStatusBarColor(colour.r, colour.g, colour.b)
        end
    end

    local AddCP = function(plate)       -- COMBOPOINT
        if plate.cp then
            local health        = plate:GetChildren()
            local _, _, name    = plate:GetRegions()
            local text          = name:GetText()
            local target        = GetUnitName'target'
            local cp 	        = GetComboPoints()
            plate.cp:Hide()
            if  target == text and health:GetAlpha() == 1 and cp > 0 then
                plate.cp:Show()
                plate.cp:SetText(string.rep('°', cp))
                plate.cp:SetTextColor(.5*(cp - 1), 2/(cp - 1), .5/(cp - 1))
            end
        end
    end

    local AddCast = function(plate)
        if plate.cast then
            local health = plate:GetChildren()
            local _, _, name = plate:GetRegions()
            local text = name:GetText()
            local target = GetUnitName'target'
            plate.cast:Hide()
			if  text ~= nil then
				local v = MODUI_GetCast(text)
				if v ~= nil then
					if  GetTime() < v.timeEnd then
						plate.cast:SetMinMaxValues(0, v.timeEnd - v.timeStart)
						if v.inverse then
							plate.cast:SetValue(mod((v.timeEnd - GetTime()), v.timeEnd - v.timeStart))
						else
							plate.cast:SetValue(mod((GetTime() - v.timeStart), v.timeEnd - v.timeStart))
						end
						plate.cast.text:SetText(v.spell)
						plate.cast.timer:SetText(GetTimerLeft(v.timeEnd)..'s')
						plate.cast.icon:SetTexture(v.icon)
						plate.cast:SetAlpha(plate:GetAlpha())
						plate.cast:Show()
					end
				end
			end
        end
    end

    local AddHeal = function(plate)
        local _, _, name = plate:GetRegions()
        local text = name:GetText()
    	plate.heal:Hide()
    	local v = MODUI_GetHeal(text)
    	if  v ~= nil then
    		if GetTime() < v.timeEnd then
    			local y = 14
    			if v.crit == 1 then
    				plate.heal:SetFont(STANDARD_TEXT_FONT, 28, 'OUTLINE')
    			else
    				plate.heal:SetFont(STANDARD_TEXT_FONT, 24, 'OUTLINE')
    				y = y + v.y
    				if y + v.y < y + 20 then v.y = v.y + 1 end
    			end
    			plate.heal:SetPoint('CENTER', plate, 0, y)
    			if (v.timeEnd - GetTime()) < .6 then
    				plate.heal:SetAlpha(mod((v.timeEnd - GetTime()), 1))
    			else
    				plate.heal:SetAlpha(.6)
    			end
    			plate.heal:SetText('+'..v.amount)
    			plate.heal:Show()
    		end
    	end
    end

    local AddBuff = function(plate)
        local _, _, name = plate:GetRegions()
        local n = name:GetText()
        local v = MODUI_GetBuffs(n)
        for i = 1, 4 do
            plate.buffs[i]:Hide()
            plate.buffs[i].icon:SetTexture''
            plate.buffs[i].duration:SetText''
        end
        if v ~= nil then
            for i, e in pairs(v) do
                if i < 5 then
                    plate.buffs[i]:Show()
                    plate.buffs[i].icon:SetTexture(e.icon)
                    plate.buffs[i].duration:SetText(GetTimerLeft(e.timeEnd))
                    if skin.enable then modSkinColor(plate.buffs[i], e.border.r, e.border.g, e.border.b) end
                end
            end
        end
    end

    local AddPvP = function(plate)
        local _, _, name = plate:GetRegions()
        local n = name:GetText()

        for _, v in pairs(
            {
                plate.pvp,
                plate.rank
            }
        ) do
            v:Hide()
        end

        if  p[n] then
            local pvp  = p[n]['pvp']
            local ffa  = p[n]['ffa']
            local rank = p[n]['rank']

            if  pvp or ffa then
                plate.pvp:Show()
                plate.pvp:SetTexture(ffa and [[Interface\TargetingFrame\UI-PVP-FFA]] or 'Interface\\TargetingFrame\\UI-PVP-'..p[n]['faction'])
            end

            if  rank and rank > 0 then
                plate.rank:Show()
                plate.rank:SetTexture(format('%s%02d', 'Interface\\PvPRankBadges\\PvPRank', rank))
            end
        end
    end

    local AddTotem = function(plate)
        local health = plate:GetChildren()
        local border, glow, name, level, _, raidicon = plate:GetRegions()
        local n = gsub(name:GetText(), '(.+) Totem', '%1')
        if  MODUI_TOTEMS[n] then
            local totem  = MODUI_TOTEMS[n]

            health.new:SetStatusBarTexture''

            name:SetAlpha(1)
            name:ClearAllPoints()
            name:SetPoint('BOTTOM', plate.totem, 'TOP', 0, 6)
            name:SetJustifyH'LEFT'

            plate.totem:Show()
            plate.totem.icon:SetTexture('Interface\\Icons\\'..totem.icon)

            plate.bg:SetAlpha(0)

            for _, v in pairs(
                {
                    plate:GetRegions()
                }
            ) do
                v:SetAlpha(0)
            end
        else
            health.new:SetStatusBarTexture(TEXTURE)

            name:ClearAllPoints()
            name:SetPoint('BOTTOMRIGHT', plate, 'TOPRIGHT', -4, -16)
            name:SetJustifyH'RIGHT'

            plate.totem:Hide()

             plate.bg:SetAlpha(1)

            for _,  v in pairs({plate:GetRegions()}) do
                if  v:GetObjectType() == 'Texture' then
                    if  not (v:GetTexture() == [[Interface\TargetingFrame\UI-RaidTargetingIcons]] or string.find(tostring(v:GetTexture()), 'HighLevel')) then
                        v:SetAlpha(1)
                    end
                    if  v:GetTexture() == 'Interface\\TargetingFrame\\UI-TargetingFrame-Skull' then
                        v:SetParent(health.new)
                        v:ClearAllPoints()
                        v:SetPoint('LEFT', health.new, 'RIGHT', 2, 0)
                        v:SetDrawLayer('OVERLAY', 7)
                    end
                end
            end
        end
    end

    local e = CreateFrame'Frame'
    e:SetScript('OnUpdate', function()
        local f = {WorldFrame:GetChildren()}
        if  var.enable then
    	    for _, v in ipairs(f) do
                if  isPlate(v) and v:IsVisible() then
                    local _, _, name = v:GetRegions()

                    if not v.skinned then AddPlates(v) end

                    AddSize(v)  AddValue(v)     AddColour(v)    AddClass(v)
                    AddCP(v)    AddCast(v)      AddHeal(v)      AddBuff(v)
                    AddPvP(v)   AddTotem(v)
                end
            end
        end
    end)

    --
