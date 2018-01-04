
    local _, class = UnitClass'Player'
    local colour   = RAID_CLASS_COLORS[class]
    local var      = MODUI_VAR['elements']['quest']
    local H        = {}
    local q        = {}

    H.QuestWatch_Update = QuestWatch_Update

    local AddLink = function(i, title, qi)
        local r, g, b = title:GetTextColor()

        local click   = CreateFrame('Button', 'modq'..i, QuestWatchFrame)
        click:SetAllPoints(title)
        click:SetScript('OnEnter', function() title:SetTextColor(colour.r, colour.g, colour.b) end)
        click:SetScript('OnLeave', function() title:SetTextColor(r, g, b) end)
        click:SetScript('OnClick', function()
            ShowUIPanel(QuestLogFrame)
            QuestLog_SetSelection(qi)
            QuestLog_Update()
        end)
    end

    local Update = function()
        H.QuestWatch_Update()
        local wi = 1
        if  var then
            for i = 1, GetNumQuestWatches() do
                local qi  = GetQuestIndexForWatch(i)
                if  qi then
                    local t     = GetQuestLogTitle(qi)
                    local num   = GetNumQuestLeaderBoards(qi)
                    if  num > 0 then
                         local title = _G['QuestWatchLine'..wi]
                        if  q[t] then
                            print(t)
                            wi = wi + 1
                            --  title is already in our objective tracker and is being duplicated!!
                            title:Hide()
                            for j = 1, num do
                                local line = _G['QuestWatchLine'..wi]
                                line:Hide()
                                wi = wi + 1
                            end
                        else
                            if  title and title:GetText() == t then  -- double-check
                                AddLink(i, title, qi)
                                tinsert(q, t)
                            end
                        end
                    end
                end
            end
        end
    end

    local OnEvent = function()  -- eUI QoL: https://github.com/Ennea/eUI/blob/master/QoLI/QoLI.lua
        local title = GetTitleText()
        if  not title then return end
        for i, v in pairs(QUEST_WATCH_LIST) do
            if  title == GetQuestLogTitle(QUEST_WATCH_LIST[i].index) then
                table.remove(QUEST_WATCH_LIST, i)
                break
            end
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'QUEST_COMPLETE'
    e:SetScript('OnEvent', OnEvent)

    QuestWatch_Update = Update

    --
