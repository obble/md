

    local _, class  = UnitClass'Player'
    local colour    = MODUI_CLASS_COLORS[class]
    local skin      = MODUI_VAR['elements']['bu_skin']
    local H      = {}

    H.ChatFrame_OnUpdate = ChatFrame_OnUpdate
    H.FCF_Tab_OnClick    = FCF_Tab_OnClick
    H.FCF_SetTabPosition = FCF_SetTabPosition
    H.FCF_FlashTab       = FCF_FlashTab

    CHAT_FONT_HEIGHTS   = {
        [1]  = 8,  [2]  = 9,  [3]  = 10, [4] = 11, [5]  = 12,
        [6]  = 13, [7]  = 14, [8]  = 15, [9] = 16, [10] = 17,
        [11] = 18, [12] = 19, [13] = 20,
    }

    local OnEnter = function()
        this.hover:SetText'› '
        GameTooltip_AddNewbieTip(CHAT_OPTIONS_LABEL, 1, 1, 1, NEWBIE_TOOLTIP_CHATOPTIONS, 1)
    end

    local OnLeave = function()
        this.hover:SetText''
        GameTooltip:Hide()
    end

    local AddTab = function(f)
        local tab = _G[f:GetName()..'Tab']

        local a, b, c = tab:GetRegions()
        for _, v in pairs(
            {
                a, b, c
            }
        ) do 
            v:Hide()
        end

        local flash = _G[f:GetName()..'TabFlash']
        local a = flash:GetRegions()
        a:SetTexture''

        local text = _G[f:GetName()..'TabText']
        text:SetJustifyH'CENTER'
        text:SetFont(STANDARD_TEXT_FONT, 14, 'OUTLINE')
        text:SetShadowOffset(0, 0)
        text:SetDrawLayer('OVERLAY', 7)

        if  not tab.hover then
            tab.hover = tab:CreateFontString(nil, 'OVERLAY')
            tab.hover:SetFont(STANDARD_TEXT_FONT, 13, 'OUTLINE')
            tab.hover:SetShadowOffset(0, 0)
            tab.hover:SetPoint('RIGHT', text, 'LEFT')
            tab.hover:SetTextColor(0, 1, 0)
        end

        tab.hover:SetText''

        tab:GetHighlightTexture():SetTexture''

        tab:SetScript('OnEnter', OnEnter)
        tab:SetScript('OnLeave', OnLeave)
    end

    local OnMouseWheel = function()
        local  d = arg1
        if not d then return end
        local  f = this:GetParent()

        if  d > 0 then
            if  IsShiftKeyDown() then
                f:ScrollToTop()
            else
                f:ScrollUp()
            end
        elseif d < 0 then
            if IsShiftKeyDown() then f:ScrollToBottom()
      		else f:ScrollDown() end
        end
    end

    local OnUpdate = function(elapsed)
        H.ChatFrame_OnUpdate(elapsed)
        local bu = _G[this:GetName()..'BottomButton']
        local fl = _G[this:GetName()..'BottomButtonFlash']
        if  this:AtBottom() then
            bu:Hide()
        else
            bu:Show()
            bu:SetAlpha(1)

            fl:SetAlpha(0)

            if  skin.enable and fl:IsShown() then
                modSkinColor(bu, 0, 1, 0)
            else
                modSkinColor(bu, skin.r, skin.g, skin.b)
            end
         end
     end

    local SetButtonSide = function(f, side)
        local bu = _G[f:GetName()..'BottomButton']
        bu:ClearAllPoints()
        bu:SetPoint('BOTTOMLEFT', -35, 22)
    end

    local SetTabPosition = function(f, x)
        H.FCF_SetTabPosition(f, x)
        AddTab(f)
    end

    local FCF_Tab_OnClick = function(bu)
        local f = _G['ChatFrame'..this:GetID()]
        H.FCF_Tab_OnClick(bu)
        AddTab(f)
    end

    local OnEvent = function()
        local x     = ({ChatFrameEditBox:GetRegions()})
        local eb    = MODUI_VAR['chat'].editbox

        --  editbox
        ChatFrameEditBox:SetAltArrowKeyMode(nil)
        ChatFrameEditBox:ClearAllPoints()
        ChatFrameEditBox:SetPoint(
            eb and 'BOTTOMLEFT' or 'TOPLEFT',
            ChatFrame1,
            eb and 'TOPLEFT' or 'BOTTOMLEFT',
            -2,
            eb and 18 or -18
        )
        ChatFrameEditBox:SetPoint(
            eb and 'BOTTOMRIGHT' or 'TOPRIGHT',
            ChatFrame1,
            eb and 'TOPRIGHT' or 'BOTTOMRIGHT',
            2,
            eb and 18 or -18
        )

        for _, v in pairs(
            {
                x[6], x[7], x[8]
            }
        ) do
            v:SetAlpha(0)
        end

        --  keep channels between editbox use
        for _, v in pairs(
            {
                ChatTypeInfo.SAY,
                ChatTypeInfo.EMOTE,
                ChatTypeInfo.YELL,
                ChatTypeInfo.PARTY,
                ChatTypeInfo.GUILD,
                ChatTypeInfo.OFFICER,
                ChatTypeInfo.RAID,
                ChatTypeInfo.RAID_WARNING,
                ChatTypeInfo.BATTLEGROUND,
                ChatTypeInfo.WHISPER,
                ChatTypeInfo.CHANNEL
            }
        ) do
            v.sticky = 1
        end

        --  buttons
        for i = 1, 7 do
            local chat      = _G['ChatFrame'..i]
            local up        = _G['ChatFrame'..i..'UpButton']
            local down      = _G['ChatFrame'..i..'DownButton']
            local bottom    = _G['ChatFrame'..i..'BottomButton']

            bottom:ClearAllPoints()
            bottom:SetPoint('BOTTOMLEFT', -35, 22)
            bottom:GetNormalTexture():SetVertexColor(.5, .5, .5)
            bottom:Hide()

            local f = CreateFrame('Frame', nil, chat)
            f:EnableMouse(false)
            f:SetAllPoints()
            f:EnableMouseWheel(true)
            f:SetScript('OnMouseWheel', OnMouseWheel)

            ChatFrameMenuButton:ClearAllPoints() 
            ChatFrameMenuButton:SetPoint('BOTTOMRIGHT', MainMenuBar, 'BOTTOMLEFT', -7, 7)
            ChatFrameMenuButton:SetParent(MainMenuBar)
            ChatFrameMenuButton:SetFrameLevel(4)
            -- ChatFrameMenuButton:GetNormalTexture():SetVertexColor(.5, .5, .5)

            ChatMenu:ClearAllPoints()
            ChatMenu:SetPoint('BOTTOMLEFT', MainMenuBar, 0, 60)

            for _, v in pairs(
                {
                    up,
                    down
                }
            ) do
                v:Hide()
                v.Show = function() end
            end
        end
    end

    ChatFrame_OnUpdate  = OnUpdate
    FCF_SetTabPosition  = SetTabPosition
    FCF_SetButtonSide   = SetButtonSide

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

     --
