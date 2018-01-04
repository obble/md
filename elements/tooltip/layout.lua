

    local H = {}

    local tooltips = {
        'GameTooltip',
        'ShoppingTooltip1',
        'ShoppingTooltip2',
        'ItemRefTooltip',
        'ItemRefShoppingTooltip1',
        'ItemRefShoppingTooltip2',
        'WorldMapTooltip',
    }

    H.UnitFrame_OnEnter              = UnitFrame_OnEnter
    H.GameTooltip_SetDefaultAnchor   = GameTooltip_SetDefaultAnchor

    local GetMouseoverUnit = function()
        if  UnitExists'mouseover' then
            --  print'true'
            return true
        else
            --  print'false'
            return false
        end
    end

    local AddBackdrop = function(f)
        f:SetFrameLevel(999)
        f:SetBackdropColor(0, 0, 0, 1)
        if  not f.BD then
            f.BD = CreateFrame('Frame', nil, f)
            f.BD:SetPoint('TOPLEFT', -8.5, 10)
            f.BD:SetPoint('BOTTOMRIGHT', 9, -10)
            f.BD:SetBackdrop(
                {
                    bgFile     = '',
                    edgeFile   = [[Interface\Buttons\WHITE8x8]],
                    edgeSize   = 18,
                }
            )

            f.BD.shadow = f:CreateTexture(nil, 'BACKGROUND')
            f.BD.shadow:SetPoint('TOPLEFT', f.BD, -5, 12)
            f.BD.shadow:SetPoint('BOTTOMRIGHT', f.BD, 5, -11)
            f.BD.shadow:SetTexture[[Interface\Tooltips\UI-Tooltip-Background]]
            f.BD.shadow:SetVertexColor(0, 0, 0, .6)
            f.BD.shadow:SetTexCoord(0, .641, 0, .18)
        end
    end

    local AddStatusBarBG = function(bar)
        bar.bg = bar:CreateTexture(nil, 'BACKGROUND', nil, 7)
        MODUI_SB(bar.bg)
        bar.bg:SetAllPoints()
        bar.bg:SetVertexColor(.25, .25, .25)
    end

    local AddStatusBar = function(bar, tooltip, vertical)
        MODUI_BD(bar)
        MODUI_SB(bar)
        bar:SetHeight(2)
        bar:SetPoint('TOPLEFT',   7, -6)
        bar:SetPoint('TOPRIGHT', -7, -6)
        bar:SetBackdrop(
            {
                bgFile = [[Interface\Buttons\WHITE8x8]],
                insets = {
                    left     =  0,
                    right    =  0,
                    top      = -1,
                    bottom   = -2,
                }
            }
        )
        bar:SetBackdropColor(0, 0, 0)

        if  not bar.bg then
            AddStatusBarBG(bar)
        end
    end

    local AddText = function(t, size)
        t:SetFont(STANDARD_TEXT_FONT, size)
        t:SetShadowOffset(.7, -.7)
        t:SetShadowColor(0, 0, 0, 1)
    end

    local AddAnchor = function()
        if  not _G['modtipParent'] then
            local parent = CreateFrame('Frame', 'modtipParent', UIParent)
            parent:SetWidth(100)
            parent:SetHeight(35)
            parent:SetPoint('BOTTOMRIGHT', MainMenuBar, -10, 140)
            parent:SetMovable(true)
            parent:EnableMouse(true)
            parent:RegisterForDrag'LeftButton'
            parent:SetBackdrop(
                {
                    bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
                    insets = {left = -1, right = -1, top = -1, bottom = -1}
                }
            )
        end
    end

    local OnShow = function()
        this:HonShow()
        AddBackdrop(this)
    end

    local OnHide = function()
        this:HonHide()
        AddBackdrop(this)
    end

    local SetDefaultAnchor = function(tooltip, parent)
        H.GameTooltip_SetDefaultAnchor(tooltip, parent)
        if  GetMouseoverUnit() then
            AddStatusBar(GameTooltipStatusBar, tooltip)
        end
    end

    local OnEvent = function()
        for  _, v in next, tooltips do
            local f = _G[v]
            if f then
                f.HonShow = f:GetScript'OnShow'
                f.HonHide = f:GetScript'OnHide'

                f:SetScript('OnShow', OnShow)
                f:SetScript('OnHide', OnHide)

                AddAnchor()
                AddText(GameTooltipHeaderText,  13)
                AddText(GameTooltipText,        12)
            end
        end
    end

    local OnEnter = function()
        H.UnitFrame_OnEnter()
        AddStatusBar(GameTooltipStatusBar, GameTooltip)   
    end

    UnitFrame_OnEnter = OnEnter

    GameTooltip_SetDefaultAnchor = SetDefaultAnchor

    --
