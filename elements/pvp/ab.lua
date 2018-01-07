

    --  to-do:
    --          flash icon on <15 sec before cap-switch
    --          add win time timer?

    local bu        = {}

    local nodes     = {
        'blacksmith',
        'farm',
        'mine',
        'lumbermill',
        'stables'
    }

    local nodeparent = {
        --  from left to right: stables > mine > blacksmith > lumbermill > farm
        ['mine']        = 'modnode_5',
        ['blacksmith']  = 'modnode_3',
        ['lumbermill']  = 'modnode_1',
        ['farm']        = 'modnode_4',
    }

    local events    = {
        'PLAYER_LOGIN',
        'ZONE_CHANGED_NEW_AREA',
        'CHAT_MSG_BG_SYSTEM_ALLIANCE',
        'CHAT_MSG_BG_SYSTEM_HORDE',
        'CHAT_MSG_BG_SYSTEM_NEUTRAL'
    }

    local AddNodes  = function()
        for i, v in ipairs(nodes) do
            local node = CreateFrame('Button', 'modnode_'..i, WorldStateAlwaysUpFrame)
            node:SetWidth(16) 
            node:SetHeight(16)
            node:EnableMouse(true) 
            node:RegisterForClicks(true)
            node:Hide()

            bu[i]       = node
            bu[i].node  = v
                
            node.ic = node:CreateTexture(nil, 'OVERLAY')
            node.ic:SetAllPoints()
            node.ic:SetTexture[[Interface\Minimap\POIICONS]]

            node.text = node:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
            node.text:SetPoint('TOP', node, 'BOTTOM', 1, -2)
            node.text:SetFont(STANDARD_TEXT_FONT, 8)
            node.text:SetJustifyH'CENTER'
            node.text:SetTextColor(1, .8, 0) 
        end
    end

    local AddTimer = function(node)
        for i,  v in pairs(bu) do
            if  v.node == node then
                v.max = GetTime() + 61
                v.text:Show()
                v:SetScript('OnUpdate', function()
                    local time = math.floor(v.max - GetTime())
                    if  time > 0 then
                        v.text:SetText(AVAB_round(time))
                    end
                end)
                break
            end
        end
    end

    local HideTimer = function(node)
        for i,  v in pairs(bu) do
            if  v.node == node then
                v:SetScript('OnUpdate', nil)
                v.max  = nil
                v.text:SetText''
                break
            end
        end
    end

    local PositionNodes = function()
        for i = 1, 5 do
            if  i == 5 then
                bu[i]:SetPoint('TOP', WorldStateAlwaysUpFrame, 'BOTTOM', -12, -53)
            else
                bu[i]:SetPoint('LEFT', _G[nodeparent[bu[i].node]], 'RIGHT', 16, 0)
            end
        end
    end

    local UpdateNodes = function()
        local num = GetNumMapLandmarks()
        for  i = 1, num do
            if i > 5 then break end
            local name, description, index = GetMapLandmarkInfo(i)
            local c     = {WorldMap_GetPOITextureCoords(index)}
            bu[i].name  = name
            bu[i].d     = description
            bu[i].ic:SetTexCoord(c[1], c[2], c[3], c[4])
            bu[i]:Show()
        end
    end

    local UpdateTimers = function()
        local node
        local won       = 'The (.+) wins'
        local defend    = '(.+) has defended the (.+)'
        local taken     = 'The (.+) has taken the (.+)'
        local claim     = '(.+) claims the (.+)! If left unchallenged, the (.+) will control it in 1 minute!'
        local assault   = '(.+) has assaulted the (.+)'

        if  string.find(arg1, won) then
            -- drop all icons + timers
            for i = 1, 5 do
                bu[i]:SetScript('OnUpdate', nil)
                bu[i]:Hide()
            end
            return
        end

        if  string.find(arg1, defend) then
            node = string.lower(gsub(arg1, defend, '%2'))
            HideTimer(node)
            return
        end

        if  string.find(arg1, taken) then
            node = string.lower(gsub(arg1, taken, '%2'))
            HideTimer(node)
            return
        end
    
        if  string.find(arg1, claim) then
            node = string.lower(gsub(arg1, claim, '%2'))
        elseif string.find(arg1, assault) then
            node = string.lower(gsub(arg1, assault, '%2'))
        end

        AddTimer(node)
    end

    local OnEnter = function()
        GameTooltip:SetOwner(this, 'ANCHOR_TOPRIGHT')
        GameTooltip:ClearLines()
        GameTooltip:SetText(this.name or nil, 1, .8, 0)
        GameTooltip:AddLine(this.d or nil, 1, 1, 1)
        GameTooltip:Show()
    end

    local OnLeave = function()
        GameTooltip:Hide()
    end

    local AddNodeTooltips = function()
        for i = 1, 5 do 
            bu[i]:SetScript('OnEnter', OnEnter)
            bu[i]:SetScript('OnLeave', OnLeave)
        end
    end

    local OnEvent = function()
        local map = 'Blizzard_BattlefieldMinimap'
        if  not IsAddOnLoaded(map) then 
            LoadAddOn(map) 
        end
        local  shown    = BattlefieldMinimap:IsShown()
        if not shown then BattlefieldMinimap:Show() end

        if  event == 'PLAYER_LOGIN' then
            AddNodes()          
            UpdateNodes()
            PositionNodes()
            AddNodeTooltips()
            if  GetZoneText() == 'Arathi Basin' then
            end
        elseif  event == 'ZONE_CHANGED_NEW_AREA' then
            if  GetZoneText() == 'Arathi Basin' then
                UpdateNodes()
            else
                for i = 1, 5 do bu[i]:Hide() end
            end
        else
            UpdateNodes()
            UpdateTimers()
        end

        if  not shown then BattlefieldMinimap:Hide() end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)

    --
