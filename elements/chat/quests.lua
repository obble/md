

    if IsAddOnLoaded'!Questie' or IsAddOnLoaded'Questie' or IsAddOnLoaded'Shagu' then return end

    local H     = {}
    local skin  = MODUI_VAR['elements']['bu_skin']

    H.SetItemRef                    = SetItemRef
    H.QuestLogTitleButton_OnClick   = QuestLogTitleButton_OnClick

    local AddTooltip = function()
        local tip = CreateFrame('GameTooltip', 'QuestTip', UIParent, 'GameTooltipTemplate')
        tip:EnableMouse(true) tip:SetMovable(true) tip:RegisterForDrag'LeftButton'
        tip:SetWidth(128) tip:SetHeight(64)
        tip:SetPoint('CENTER', 0, 0)
        tip:SetPadding(16)
        tip:SetScript('OnLoad', GameTooltip_OnLoad)
        tip:SetScript('OnDragStart', function() tip:StartMoving() end)
        tip:SetScript('OnDragStop',  function() tip:StopMovingOrSizing() ValidateFramePosition(tip) end)

        if  skin.enable then
            modSkin(tip, 4)
            modSkinColor(tip, skin.r, skin.g, skin.b)
        end

        local x = CreateFrame('Button', 'QuestTipCloseButton', tip)
        x:SetWidth(32) x:SetHeight(32)
        x:SetPoint('TOPRIGHT', -1, -1)
        x:SetNormalTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Up]]
        x:SetPushedTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Down]]
        x:SetHighlightTexture[[Interface\Buttons\UI-Panel-MinimizeButton-Highlight]]
        x:SetScript('OnClick', function() HideUIPanel(tip) end)
    end

    local ItemRef = function(link, text, button)
        local q         = string.find(link, 'quest:(%d+):.*')
        local q2        = string.find(link, 'quest2:.*')
        local _, _, lvl = string.find(link, 'quest:%d+:(%d+)')

    	if  (q or q2) and text then
            local tip               = ItemRefTooltip
    		local title, _, qtitle = string.find(text, '.*|h%[?([^%[%]]*)%]?|h.*')
            local have

            ShowUIPanel(tip)
            tip:SetOwner(UIParent, 'ANCHOR_PRESERVE')

            if  title then 
                tip:AddLine(qtitle, 1, .8, 0)
            end

            for i = 1, GetNumQuestLogEntries() do
                local logtitle = GetQuestLogTitle(i)
                if    logtitle == qtitle then     
                    have = true     
                    SelectQuestLogEntry(i)
                    local _, t = GetQuestLogQuestText()

                    tip:AddLine(t, 1, 1, 1, 1)

                    for j = 1, GetNumQuestLeaderBoards() do
                        local desc, _, done = GetQuestLogLeaderBoard(j)
                        local obj           = (done and '|cffa6b6f9' or '|cffcccccc')..desc..'|r'

                        if  j == 1 and GetNumQuestLeaderBoards() > 0 then 
                            tip:AddLine'|cffffffff '
                        end

                        tip:AddLine(obj)
                    end
                end
            end

            if  not have then
                tip:AddLine('You aren\'t doing this one.', 1, .5, .3)
            end

            tip:Show()
        else
            H.SetItemRef(link, text, button)
        end
    end

    local OnClick = function(button)
    	local i            = this:GetID() + FauxScrollFrame_GetOffset(QuestLogListScrollFrame)
        local name, lvl    = GetQuestLogTitle(i)
    	if  IsShiftKeyDown() and ChatFrameEditBox:IsVisible() and (not this.isHeader) then
    		local msg = '|cffffff00|Hquest:0:'..lvl..':0:0 |h['..name ..']|h|r'
    		ChatFrameEditBox:Insert(msg)
            QuestLog_SetSelection(i)
            QuestLog_Update()
            return
    	end
        H.QuestLogTitleButton_OnClick(button)
    end

    SetItemRef                  = ItemRef
    QuestLogTitleButton_OnClick = OnClick

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', AddTooltip)

   --
