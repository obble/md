
    local var      = MODUI_VAR['elements']['bu_skin']

    local TEXTURE  = [[Interface\AddOns\md\customise\statusbar\statusbar]]
    local BACKDROP = {
        bgFile     = [[Interface\ChatFrame\ChatFrameBackground]],
        tiled      = false,
        insets     = {left = -3, right = -3, top = -3, bottom = -3}
    }
    local SLOT     = {
        bgFile     = '',
        edgeFile   = [[Interface\Buttons\WHITE8x8]],
        edgeSize   = 3,
    }
    local BORDER   = {
        bgFile     = '',
        edgeFile   = [[Interface\Buttons\WHITE8x8]],
        edgeSize   = 1,
    }

    local t = CreateFont'modhotkeys'
    t:SetFont(STANDARD_TEXT_FONT, 10, 'OUTLINE')

    local AddHighlight = function(bu)
        bu.enter = bu:CreateTexture(nil, 'OVERLAY')
        bu.enter:SetAllPoints()
        bu.enter:SetTexture[[Interface\Buttons\CheckButtonHilight]]
        bu.enter:SetTexCoord(.075, .95, .05, .95)
        bu.enter:SetBlendMode'ADD'
        bu.enter:SetAlpha(0)
    end

    local ToggleHighlight = function(bu, show)
        if not bu.enter then AddHighlight(bu) end
        bu.enter:SetAlpha(show and 1 or 0)
    end

    MODUI_BD = function(bu, a)
        local f = bu
        if  f:GetObjectType() == 'Texture' then
            if not bu.BD then
                local parent = bu:GetParent()
                bu.BD = CreateFrame('Frame', nil, parent)
                bu.BD:SetAllPoints(bu)
                bu.BD:SetFrameLevel(parent:GetFrameLevel() - 1)
            end
            f = bu.BD
        end
        f:SetBackdrop(BACKDROP)
        f:SetBackdropColor(0, 0, 0, a or 1)
    end

    MODUI_BU = function(bu, offset, hover)
        if not bu then return end

        -- bu:SetNormalTexture''
        -- bu:SetPushedTexture''
        -- bu:SetHighlightTexture''

        bu.HonEnter = bu:GetScript'OnEnter'
        bu.HonLeave = bu:GetScript'OnLeave'

        bu:SetScript('OnEnter', function() 
            if bu.HonEnter then bu:HonEnter() end
            if hover then ToggleHighlight(bu, true) end 
        end)

        bu:SetScript('OnLeave', function()
            if bu.HonLeave then bu:HonLeave() end
            if hover then ToggleHighlight(bu, false) end 
        end)

        if  var.enable and not modSkinned(bu) then
            modSkin(bu, offset and offset or 1)
            modSkinColor(bu, var.r, var.g, var.b)
        end
    end

    MODUI_BUBorder = function(bu)
        if bu.bo then return end
        bu.bo = CreateFrame('Frame', bu:GetName()..'modborder', bu)
        bu.bo:SetPoint('TOPLEFT', bu, 1, -1)
        bu.bo:SetPoint('BOTTOMRIGHT', bu, -1, 1)
        bu.bo:SetFrameLevel(bu:GetFrameLevel() + 1)
        bu.bo:SetBackdrop(BORDER)
        bu.bo:SetBackdropBorderColor(0, 0, 0, 0)
    end

    MODUI_ITEMS = function(bu)
        local n  = bu:GetName()
        local co  = _G[n..'Count']
        local ic  = _G[n..'IconTexture']
        local cd = _G[n..'Cooldown']

        MODUI_BU(bu)
        MODUI_BUBorder(bu)

        bu:SetNormalTexture''
        bu:SetPushedTexture''
        bu:SetHighlightTexture''

        if  co then
            co:ClearAllPoints()
            co:SetParent(bu.bo)
            co:SetPoint('BOTTOM', bu, 0, -1)
            co:SetShadowOffset(0, 0)
            co:SetJustifyH'CENTER'
            co:SetDrawLayer('OVERLAY', 7)
        end

        if  ic then
            ic:SetTexCoord(.1, .9, .1, .9)
            ic:SetDrawLayer'ARTWORK'
        end
    end

    MODUI_BUElements = function(bu)
        if not bu then return end
        local  bo = _G[bu:GetName()..'Border']
        local  co = _G[bu:GetName()..'Count']
        local  ic = _G[bu:GetName()..'Icon'] or _G[bu:GetName()..'IconTexture']
        local  cd = _G[bu:GetName()..'Cooldown']

        for _, v in pairs({bu.Border, bu.FloatingBG}) do
            if v then v:SetAlpha(0) end
        end

        if  bu.FloatingBG and not bu.mod then
            bu.mod = bu:CreateTexture(nil, 'BACKGROUND')
            bu.mod:SetAllPoints(bu.FloatingBG)
            bu.mod:SetBackdrop(SLOT)
            bu.mod:SetBackdropColor(0, 0, 0)
        end

        if  bo then
            bo:Hide()
        end

        if  co then
            if bu.bo then co:SetParent(bu.bo) end
            co:ClearAllPoints()
            co:SetPoint('BOTTOM', bu, 2, -1)
            co:SetFont(STANDARD_TEXT_FONT, 14, 'OUTLINE')
            co:SetShadowOffset(0, 0)
            co:SetJustifyH'CENTER'
            co:SetDrawLayer('OVERLAY', 7)
        end

        if  cd then
            cd:ClearAllPoints()
            cd:SetAllPoints()
        end

        if  bu.HotKey then
            bu.HotKey:ClearAllPoints()
            bu.HotKey:SetPoint('TOPRIGHT', bu, -1, 2)
            NumberFontNormalSmallGray:SetFontObject'modhotkeys'
        end

        if  ic then
            ic:SetTexCoord(.1, .9, .1, .9)
            ic:SetDrawLayer'ARTWORK'
        end

        if  bu.Name then
            bu.Name:SetWidth(bu:GetWidth() + 15)
            bu.Name:SetFontObject'GameFontHighlight'
        end
    end

    MODUI_SB = function(f)
        if  f:GetObjectType() == 'StatusBar' then
            f:SetStatusBarTexture(TEXTURE)
        else
            f:SetTexture(TEXTURE)
        end
    end


    --
