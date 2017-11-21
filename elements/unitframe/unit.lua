

    local var   = MODUI_VAR['elements']['unit']
    local sbar  = MODUI_VAR['statusbar']

    --local HealComm       = AceLibrary'HealComm-1.0'
    local TEXTURE        = [[Interface\AddOns\md\customise\statusbar\statusbar.tga]]
    local NAME_TEXTURE   = [[Interface\AddOns\md\customise\statusbar\namebg.tga]]
    local BACKDROP       = {
        bgFile = [[Interface\Tooltips\UI-Tooltip-Background]]
    }
    local diffThreshold  = .1

    local H = {}

    local events = {
        'PLAYER_LOGIN',
        'PLAYER_ENTERING_WORLD',
        'PARTY_MEMBERS_CHANGED',
        'PLAYER_TARGET_CHANGED',
        'UNIT_FACTION',
    }

    H.TargetFrame_CheckClassification   = TargetFrame_CheckClassification
    H.PartyMemberFrame_UpdateMember     = PartyMemberFrame_UpdateMember
    H.TargetofTarget_Update             = TargetofTarget_Update
    H.UnitFrameHealthBar_OnValueChanged = UnitFrameHealthBar_OnValueChanged
    H.TextStatusBar_UpdateTextString    = TextStatusBar_UpdateTextString
    H.UIOptionsFrame_UpdateDependencies = UIOptionsFrame_UpdateDependencies

    local AddUnitFrames = function()
        local _, class       = UnitClass'player'
        local colour         = MODUI_CLASS_COLORS[class]

        PlayerFrameBackground.bg = PlayerFrame:CreateTexture(nil, 'ARTWORK')
        PlayerFrameBackground.bg:SetPoint('TOPLEFT', PlayerFrameBackground)
        PlayerFrameBackground.bg:SetPoint('BOTTOMRIGHT', PlayerFrameBackground, 0, 22)
        PlayerFrameBackground.bg:SetVertexColor(colour.r, colour.g, colour.b, 1)
        if sbar.texture then PlayerFrameBackground.bg:SetTexture(NAME_TEXTURE) end
        PlayerFrameBackground.bg:SetTexCoord(1, 0, 0, 1)

        PlayerFrame.status = PlayerFrameTexture:GetParent():CreateFontString(nil, 'OVERLAY')
        PlayerFrame.status:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
        PlayerFrame.status:SetShadowOffset(0, 0)
        PlayerFrame.status:SetTextColor(1, 0, 0)
        PlayerFrame.status:SetPoint('CENTER', PlayerFrameHealthBar, 0, -5)

        PlayerFrameHealthBar:SetBackdrop(BACKDROP)
        PlayerFrameHealthBar:SetBackdropColor(0, 0, 0, .6)
        if sbar.texture then PlayerFrameHealthBar:SetStatusBarTexture(TEXTURE) end

        PlayerFrameManaBar:SetBackdrop(BACKDROP)
        PlayerFrameManaBar:SetBackdropColor(0, 0, 0, .6)
        if sbar.texture then PlayerFrameManaBar:SetStatusBarTexture(TEXTURE)   end

        PlayerPVPIcon:SetHeight(48) 
        PlayerPVPIcon:SetWidth(48)
        PlayerPVPIcon:ClearAllPoints()
        PlayerPVPIcon:SetPoint('CENTER', PlayerFrame, 'LEFT', 60, 16)

        TargetFrame.Elite = TargetFrameTextureFrame:CreateTexture(nil, 'BORDER')
        TargetFrame.Elite:SetTexture[[Interface\AddOns\md\art\unitframe\unitframe\UI-TargetingFrame-Elite]]
        TargetFrame.Elite:SetWidth(128)
        TargetFrame.Elite:SetHeight(128)
        TargetFrame.Elite:SetPoint('TOPRIGHT', TargetFrame)
        TargetFrame.Elite:Hide()

        TargetFrame.Rare = TargetFrameTextureFrame:CreateTexture(nil, 'BORDER')
        TargetFrame.Rare:SetTexture[[Interface\AddOns\md\art\unitframe\unitframe\UI-TargetingFrame-Rare-Elite]]
        TargetFrame.Rare:SetWidth(128)
        TargetFrame.Rare:SetHeight(128)
        TargetFrame.Rare:SetPoint('TOPRIGHT', TargetFrame)
        TargetFrame.Rare:Hide()

        TargetRaidTargetIcon:SetDrawLayer('OVERLAY', 7)

        TargetPVPIcon:SetHeight(48) 
        TargetPVPIcon:SetWidth(48)
        TargetPVPIcon:ClearAllPoints()
        TargetPVPIcon:SetPoint('CENTER', TargetFrame, 'RIGHT', -42, 16)
        TargetPVPIcon:SetDrawLayer('OVERLAY', 7)

        if sbar.texture then TargetFrameNameBackground:SetTexture(NAME_TEXTURE) end
        TargetFrameNameBackground:SetDrawLayer'BORDER'

        TargetFrameHealthBar:SetBackdrop(BACKDROP)
        TargetFrameHealthBar:SetBackdropColor(0, 0, 0, .6)
        if sbar.texture then TargetFrameHealthBar:SetStatusBarTexture(TEXTURE)  end

        TargetFrameManaBar:SetBackdrop(BACKDROP)
        TargetFrameManaBar:SetBackdropColor(0, 0, 0, .6)
        if sbar.texture then TargetFrameManaBar:SetStatusBarTexture(TEXTURE)    end

        PlayerFrameGroupIndicator:SetAlpha(0)

        PlayerHitIndicator:SetText(nil)
        PlayerHitIndicator.SetText = function() end

        PetHitIndicator:SetText(nil)
        PetHitIndicator.SetText = function() end

        TargetLevelText:SetJustifyH'LEFT'
        TargetLevelText:SetPoint('LEFT', TargetFrameTextureFrame, 'CENTER', 56, -16)

        TargetofTargetName:SetHeight(30)
        TargetofTargetName:ClearAllPoints()
        TargetofTargetName:SetPoint('TOPLEFT', TargetofTargetTextureFrame, 'BOTTOMLEFT', 46, 16)

        TargetofTargetPortrait:SetHeight(37)    -- fix the ugly offset on tot portraits
        TargetofTargetPortrait:SetWidth(37)
        TargetofTargetPortrait:SetPoint('TOPLEFT', 5, -5)

        PartyMemberFrame1:ClearAllPoints()
        PartyMemberFrame1:SetPoint('TOPLEFT', 10, -145)

        for i = 6, 12 do
            local f = CreateFrame('Button', 'TargetFrameBuff'..i, TargetFrame, 'TargetBuffButtonTemplate')
            f:SetID(i)
            f:Hide()
            modSkin(f, 1)      -- first 6 are skinned in skin/button/target.lua
            modSkinColor(f, .7, .7, .7)
            if i == 6 then
                f:SetPoint('TOPLEFT', TargetFrameBuff1, 'BOTTOMLEFT', 0, -2)
            else
                f:SetPoint('LEFT', _G['TargetFrameBuff'..(i - 1)], 'RIGHT', 3, 0)
            end
        end

        for _, v in pairs(
            {
                PlayerPVPIcon,
                TargetFrameTextureFramePVPIcon
            }
        ) do 
            v:SetHeight(48) 
            v:SetWidth(48) 
        end

        if  sbar.texture then 
            for _, v in pairs(
                {
                     TargetofTargetHealthBar,
                     TargetofTargetManaBar
                }
            ) do
                v:SetStatusBarTexture(TEXTURE)
            end
        end

        for i = 1, 4 do 
            _G['PartyMemberFrame'..i..'PVPIcon']:SetAlpha(0) 
        end

        for i = 1, 4 do
            for _, v in pairs(
                {
                    _G['PartyMemberFrame'..i..'HealthBar'],
                    _G['PartyMemberFrame'..i..'ManaBar']
                }
            ) do
                v:SetBackdrop(BACKDROP) 
                v:SetBackdropColor(0, 0, 0, .6)
                if sbar.texture then v:SetStatusBarTexture(TEXTURE) end
            end
        end
    end

    local AddHealcomm = function(this)
        if  this.heal then
            local heal          = HealComm:getHeal(UnitName'player')
            local v, max        = UnitHealth'player', UnitHealthMax'player'
            local bu_w, bu_h    = this:GetWidth(), this:GetHeight()
            local hp_w, hp_h    = bu_w*(v/max), bu_h*(v/max)
            if  heal > 0 and v < max and not UnitIsDeadOrGhost'player' then
                local w = bu_w*(heal/max)
                if (hp_w + w) > bu_w then w = bu_w - hp_w end
                this.heal:Show()
                this.heal:SetWidth(w)
                this.heal:SetHeight(bu_h)
                this.heal:ClearAllPoints()
                this.heal:SetPoint('TOPLEFT', this, hp_w, 0)
            else
                this.heal:Hide()
            end
        end
    end

    local AddPartyClasses = function()
        for i = 1, MAX_PARTY_MEMBERS do
            local name = _G['PartyMemberFrame'..i..'Name']
            if  UnitIsPlayer('party'..i) then
                local _, class  = UnitClass('party'..i)
                local colour    = MODUI_CLASS_COLORS[class]
                if  colour then 
                    name:SetTextColor(colour.r, colour.g, colour.b) 
                end
            else
                name:SetTextColor(1, .8, 0)
            end
        end
    end

    local AddTargetClasses = function()
        local _, class  = UnitClass'target'
        local colour    = MODUI_CLASS_COLORS[class]
        if  UnitIsPlayer'target' then
            TargetFrameNameBackground:SetVertexColor(colour.r, colour.g, colour.b, 1)
        end
    end

    local AddTextFormat = function(string, v, min, max, percent)
        if  var['value'].both then
            string:SetText(true_format(v)..'/'..true_format(max)..' — '..percent..'%')
        elseif var['value'].truth and not var['value'].both then
            string:SetText(true_format(v))
        else
            string:SetText(percent..'%')
        end
    end

    local AddExpText = function(string, sb, v, min, max, percent)
        string:SetPoint('CENTER', sb)
        string:SetJustifyH'CENTER'
        if  var['value'].percent then
            if ReputationWatchBar:IsShown() then
                local rname, standing, rmin, rmax, rv = GetWatchedFactionInfo()
                local rperc = math.floor((rv - rmin)/(rmax - rmin)*100)

                MainMenuExpBar.rep:SetText(rname..': '..percent..'% into '.._G['FACTION_STANDING_LABEL'..standing]..'    ')
                    
                string:SetText('—     XP: '..percent..'%')
                string:SetPoint('CENTER', (string:GetWidth()/2) - 8, 25)
            else
                MainMenuExpBar.rep:SetText''
                    
                string:SetText(percent..'%')
            end
        else
            -- to-do: add values for toggling off var['values'].truth
            if  ReputationWatchBar:IsShown() then
                local rname, _, rmin, rmax, rv = GetWatchedFactionInfo()
                MainMenuExpBar.rep:SetText(rname..': '..true_format((rv - rmin))..' / '..true_format((rmax - rmin))..'    ')
                string:SetText('—     XP: '..true_format(v)..' / '..true_format(max))
                string:SetPoint('CENTER', (string:GetWidth()/2) - 8, 25)
            else
                MainMenuExpBar.rep:SetText''
                string:SetText(true_format(v)..' / '..true_format(max))
            end
        end
    end

    local AddTextColour = function(string, class, pp)
        if  var['value'].colour then
            if class == 'ROGUE' or (class == 'DRUID' and pp == 3) then
                string:SetTextColor(250/255, 240/255, 200/255)
            elseif class == 'WARRIOR' or (class == 'DRUID' and pp == 1) then
                string:SetTextColor(250/255, 108/255, 108/255)
            else
                string:SetTextColor(.6, .65, 1)
            end
        else
            string:SetTextColor(1, 1, 1)
        end
    end

    local UpdateTextString = function(sb)
        if not sb then sb = this end
        H.TextStatusBar_UpdateTextString(sb)
        local string = sb.TextString
        if  string then
            local pp        = UnitPowerType'player'
            local v         = math.floor(sb:GetValue())
            local min, max  = sb:GetMinMaxValues()
            local percent   = math.floor(v/max*100)

            if  max > 0 then
                sb:Show()
                if  UnitIsDead'player' then
                    PlayerFrame.status:SetText'Dead'
                    string:SetText''
                    return
                elseif UnitIsGhost'player' then
                    PlayerFrame.status:SetText'Ghost'
                    string:SetText''
                    return
                elseif v == 0 and sb.zeroText then
                    PlayerFrame.status:SetText''
                    string:SetText''
                    return
                elseif sb:GetName() == 'PetFrameManaBar' then
                    string:SetText''
                    return
                else
                    PlayerFrame.status:SetText''
                    if  sb:GetName() == 'MainMenuExpBar' then
                        AddExpText(string, sb, v, min, max, percent)
                    elseif sb:GetName() == 'PlayerFrameManaBar' and (pp == 1 or pp == 2 or pp == 3) then
                        string:SetText(v)
                    else
                        AddTextFormat(string, v, min, max, percent)
                    end
                    string:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
                end
                if  sb:GetName() == 'PlayerFrameManaBar' or sb:GetName() == 'TargetFrameManaBar' then
                    AddTextColour(string, class, pp)
                end
            end
        end
    end

    local OnValueChanged = function(v)
        H.UnitFrameHealthBar_OnValueChanged(v)
        -- AddHealcomm(this)
    end

    local CheckClassification = function()
        local c = UnitClassification'target'

        TargetFrameTexture:SetTexture[[Interface\TargetingFrame\UI-TargetingFrame]]

        for _, v in pairs(
            {
                TargetFrame.Elite,
                TargetFrame.Rare
            }
        ) do
            v:Hide()
        end

        if  c == 'worldboss' or c == 'rareelite' or c == 'elite' then
            TargetFrame.Elite:Show()
        elseif c == 'rare' then
            TargetFrame.Rare:Show()
        end
    end

    local ToTUpdate = function()
        H.TargetofTarget_Update()
        local _, class = UnitClass'targettarget'
        local colour = RAID_CLASS_COLORS[class]
        if  UnitIsPlayer'targettarget' then
            TargetofTargetName:SetTextColor(colour.r, colour.g, colour.b)
        else
            TargetofTargetName:SetTextColor(1, .8, 0)
        end
    end

    local UpdateMember = function()
         H.PartyMemberFrame_UpdateMember()
        AddPartyClasses()
    end

    TextStatusBar_UpdateTextString      = UpdateTextString
    UnitFrameHealthBar_OnValueChanged   = OnValueChanged
    TargetFrame_CheckClassification     = CheckClassification
    TargetFrame_OnShow                  = function() end
    TargetFrame_OnHide                  = CloseDropDownMenus
    TargetofTarget_Update               = ToTUpdate
    PartyMemberFrame_UpdateMember       = UpdateMember

    TargetFrameManaBar:RegisterEvent'PLAYER_DEAD'

    local e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', function()           -- COLOUR UNIT
        if event == 'PLAYER_LOGIN' then
            AddUnitFrames()
        elseif  event == 'PLAYER_ENTERING_WORLD' 
        or      event == 'PARTY_MEMBERS_CHANGED' then
            AddPartyClasses()
        else
            AddTargetClasses()
        end
    end)


    --
