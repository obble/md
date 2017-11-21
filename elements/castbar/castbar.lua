
    local TEXTURE   = [[Interface\AddOns\md\customise\statusbar\texture\sb.tga]]
    local var       = MODUI_VAR['elements']['castbar']
    local skin      = MODUI_VAR['elements']['bu_skin']
    local _, class  = UnitClass'player'

    local H = {}
    local overrideIcons     = {
        ['Hearthstone']     = [[Interface\Icons\inv_misc_rune_01]],
        ['Herb Gathering']  = [[Interface\Icons\spell_nature_naturetouchgrow]],
        ['Mining']          = [[Interface\Icons\trade_mining]],
        ['Fishing']         = [[Interface\Icons\trade_fishing]],
        ['Aimed Shot']      = [[Interface\Icons\inv_spear_07]]
    }

    H.UseAction                 = UseAction
    H.CastingBarFrame_OnEvent   = CastingBarFrame_OnEvent
    H.CastingBarFrame_OnUpdate  = CastingBarFrame_OnUpdate

    local PlayerCastingBarFrame = function()
        CastingBarFrame:ClearAllPoints()
        CastingBarFrame:SetPoint('LEFT', PlayerFrame, 75, 0)
        CastingBarFrame:SetPoint('RIGHT', PlayerFrame, -8, 0)
        CastingBarFrame:SetPoint('TOP', PlayerFrame, 'BOTTOM', 0, class == 'SHAMAN'  and -10 or class == 'WARLOCK' and -10 or -2)
        CastingBarFrame.SetPoint        = function() end
        CastingBarFrame.ClearAllPoints  = function() end
        CastingBarFrame:SetWidth(142)
        CastingBarFrame:SetHeight(10)

        CastingBarBorder:Hide()

        CastingBarSpark:SetTexture''
        CastingBarFlash:SetTexture''

        CastingBarText:ClearAllPoints()
        CastingBarText:SetPoint('TOPLEFT', CastingBarFrame, 'BOTTOMLEFT', 2, -5)
        CastingBarText:SetJustifyH'LEFT'

        CastingBarFrame.Icon:SetPoint('RIGHT', CastingBarFrame, 'LEFT', -10, 1)
        CastingBarFrame.Icon:SetWidth(21)
        CastingBarFrame.Icon:SetHeight(21)
        CastingBarFrame.Icon:SetAlpha(1)

        if skin.enable then modSkinShow(CastingBarFrame) end
    end

    local ToggleIcon = function()
        local  t = CastingBarText:GetText()
        if not t or (not CastingBarFrame.hasIcon and not overrideIcons[t]) then
            CastingBarFrame.Icon:Hide()
        else
            CastingBarFrame.Icon:Show()
            if  overrideIcons[t] then
                CastingBarFrame.Icon.Texture:SetTexture(overrideIcons[t])
                CastingBarFrame.Icon.Texture:SetAlpha(.75)
            end
        end
    end

    local HideIcon = function()
        if  CastingBarFrame.hasIcon then
            CastingBarFrame.hasIcon = false
            CastingBarFrame.iconID  = nil
            ToggleIcon()
        end
    end

    local Use = function(slot, target, button)
        H.UseAction(slot, target, button)
        local tooltip   = _G['modCastbarTooltip']
        
        tooltip:SetAction(slot)

        local n         = _G['modCastbarTooltipTextLeft3']:GetText()
        local v         = CastingBarFrame:GetValue()
        local min, max  = CastingBarFrame:GetMinMaxValues()

        if  v == min or v > min or v == max or not CastingBarFrame:IsShown() then
            local icon = GetActionTexture(slot)
            if  icon and n and not string.find(n, SPELL_CAST_TIME_INSTANT) then
                CastingBarFrame.hasIcon = true
                CastingBarFrame.Icon.Texture:SetTexture(icon)
                CastingBarFrame.Icon.Texture:SetAlpha(.75)
                CastingBarFrame:SetScript('OnHide', HideIcon)
            end
            ToggleIcon()
        end
    end

    local OnUpdate = function()
        H.CastingBarFrame_OnUpdate()
        ToggleIcon()
        CastingBarFrame.Icon:ClearAllPoints()
        CastingBarFrame.Icon:SetPoint('RIGHT', CastingBarFrame, 'CENTER', -(CastingBarText:GetStringWidth()/2 + 10), 2.5)
    end

    local OnEvent = function()
        H.CastingBarFrame_OnEvent()
        if  event == 'SPELLCAST_STOP'
        or  event == 'SPELLCAST_CHANNEL_STOP'
        or  event == 'SPELLCAST_FAILED'
        or  event == 'SPELLCAST_INTERRUPTED' then
            HideIcon()
        end
    end

    UseAction                   = Use
    CastingBarFrame_OnEvent     = OnEvent
    CastingBarFrame_OnUpdate    = OnUpdate

    local PLAYER_LOGIN = function()
        CastingBarFrame:SetStatusBarTexture(TEXTURE)

        CastingBarFrame.Icon = CreateFrame('Frame', nil, CastingBarFrame)
        CastingBarFrame.Icon:SetWidth(25)
        CastingBarFrame.Icon:SetHeight(12)
        CastingBarFrame.Icon:SetPoint('RIGHT', CastingBarText, 'LEFT', 30, -1)

        CastingBarFrame.Icon.Texture = CastingBarFrame.Icon:CreateTexture(nil, 'ARTWORK')
        CastingBarFrame.Icon.Texture:SetAllPoints()
        CastingBarFrame.Icon.Texture:SetTexCoord(.1, .9, .275, .725)
        CastingBarFrame.Icon.Texture:SetAlpha(.75)

        if  skin.enable then
            modSkin(CastingBarFrame)
            modSkinColor(CastingBarFrame, skin.r, skin.g, skin.b)
            modSkinHide(CastingBarFrame)

            modSkin(CastingBarFrame.Icon)
            modSkinColor(CastingBarFrame.Icon, skin.r, skin.g, skin.b)
        end

        CastingBarText:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
        CastingBarText:SetShadowOffset(0, 0)
        CastingBarText:ClearAllPoints()
        CastingBarText:SetPoint('TOP', 0, 5)

        local tooltip = CreateFrame('GameTooltip', 'modCastbarTooltip', nil, 'GameTooltipTemplate')
        tooltip:SetOwner(WorldFrame, 'ANCHOR_NONE')

        if  var then
            PlayerCastingBarFrame()
        end
    end

    CastingBarFrame:SetScript('OnShow', ToggleIcon)

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', PLAYER_LOGIN)

    --
