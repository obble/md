
    local bu        = {}

    local events    = {
        'PLAYER_LOGIN',
        'ZONE_CHANGED_NEW_AREA',
        'CHAT_MSG_BG_SYSTEM_ALLIANCE',
        'CHAT_MSG_BG_SYSTEM_HORDE',
        'CHAT_MSG_BG_SYSTEM_NEUTRAL'
    }

    local nodes     = {
        ['Stables']     = {
            ['Neutral']     = {
                .5025, .6225,   .5, .63
            },
            ['Alliance']    = {
                ['Assaulted']   = {
                    .63,    .7475,  .5,     .63
                },
                ['Captured']    = {
                    .755,   .8725,  .5,     .63
                },
            },
            ['Horde']       = {
                ['Assaulted']   = {
                    .88,    1,      .5,     .63
                },
                ['Captured']    = {
                    0,      .12,    .62,    .75
                },
            },
        },
        ['Mine']   = {
            ['Neutral']     = {
                0,      .1225,  .2525,  .38
            },
            ['Alliance']    = {
                ['Assaulted']   = {
                    .125,   .2475,  .2525,  .38
                },
                ['Captured']    = {
                    .25,    .3725,  .2525,  .38
                },
            },
            ['Horde']       = {
                ['Assaulted']   = {
                    .375,   .4975,  .2525,  .38
                },
                ['Captured']    = {
                    .5,     .6225,  .2525,  .38
                },
            },
        },
        ['Blacksmith']  = {
            ['Neutral']     = {
                .2525,  .375,   .38,    .5
            },
            ['Alliance']    = {
                ['Assaulted']   = {
                    .3775,  .5,     .38,    .5
                },
                ['Captured']    = {
                    .5025,  .625,   .38,    .495
                },
            },
            ['Horde']       = {
                ['Assaulted']   = {
                    .625,   .745,   .38,    .495
                },
                ['Captured']    = {
                    .75,    .875,   .38,    .495
                },
            },
        },
        ['Lumber mill'] = {
            ['Neutral']     = {
                .63,    .7475,  .2525,  .38
            },
            ['Alliance']    = {
                ['Assaulted']   = {
                    .7525,  .8725,  .2525,  .38
                    },
                ['Captured']    = {
                    .875,   1,      .2525,  .38
                },
            },
            ['Horde']       = {
                ['Assaulted']   = {
                    0,      .1215,  .38,    .5
                },
                ['Captured']    = {
                    .128,   .246,   .38,    .5
                },
            },
        },
        ['Farm']        = {
            ['Neutral']     = {
                .88,    1,      .38,    .495
            },
            ['Alliance']    = {
                ['Assaulted']   = {
                    0,      .125,   .5025,  .62
                },
                ['Captured']    = {
                    .13,    .2475,  .5,     .62
                },
            },
            ['Horde']       = {
                ['Assaulted']   = {
                    .2525,  .3725,  .5,     .62
                },
                ['Captured']    = {
                    .38,    .496,   .5,     .63
                },
            },
        },
    }

    local UpdateIcon = function(node, faction, flag)
        for i,  _ in pairs(bu) do
            if  bu[i].v == node then
                    print(node)
                    print(faction)
                    print(flag)
                bu[i].ic:SetTexCoord(
                    nodes[node][faction][flag][1],
                    nodes[node][faction][flag][2],
                    nodes[node][faction][flag][3],
                    nodes[node][faction][flag][4]
                )
                break
            end
        end
    end

    local HideTimer = function(node, faction)
        for i,  _ in pairs(bu) do
            if  bu[i].v == node then
                UpdateIcon(node, faction, 'Captured')
                bu[i]:SetScript('OnUpdate', nil)
                bu[i].text:SetText''
                break
            end
        end
    end

    local OnUpdate = function()
        local time = math.floor(this.max - GetTime())
        if  time > 0 then
            this.text:SetText(AVAB_round(time))
        end
    end

    local AddTimer = function(node)
        for i,  _ in pairs(bu) do
            if  bu[i].v  == node then
                bu[i].max = GetTime() + 61
                bu[i].text:Show()
                bu[i]:SetScript('OnUpdate', OnUpdate)
                break
            end
        end
    end

    local AddNeutralIcon = function()
        local i     = 1
        local j, v  = next(nodes, nil)
        while  j do
            bu[i].v = j
            bu[i].ic:SetTexCoord(
                nodes[j]['Neutral'][1],
                nodes[j]['Neutral'][2],
                nodes[j]['Neutral'][3],
                nodes[j]['Neutral'][4]
            )
            i       = i + 1
            j, v    = next(nodes, j)
        end
    end

    local AddNodes = function()
        for i = 1, 5 do
            local node = CreateFrame('Button', 'modnode_ab'..i, WorldStateAlwaysUpFrame)
            bu[i] = node
            node:SetWidth(16) 
            node:SetHeight(16)
            node:EnableMouse(true) 
            node:RegisterForClicks(true)
            node:Hide()
            
            node.ic = node:CreateTexture(nil, 'OVERLAY')
            node.ic:SetAllPoints()
            node.ic:SetTexture[[Interface\Minimap\POIICONS]]

            node.text = node:CreateFontString(nil, 'OVERLAY', 'GameFontNormalSmall')
            node.text:SetPoint('TOP', node, 'BOTTOM', 1, -2)
            node.text:SetFont(STANDARD_TEXT_FONT, 8)
            node.text:SetJustifyH'CENTER'
            node.text:SetTextColor(1, .8, 0) 

            if i == 1 then
                node:SetPoint('TOP', WorldStateAlwaysUpFrame, 'BOTTOM', -12, -53)
            else
                node:SetPoint('LEFT', _G['modnode_ab'..(i - 1)], 'RIGHT', 16, 0)
            end

            node.i  = i
            bu[i]   = node
        end
    end

    local ParseStrings = function()
        local node, faction
        local won       = 'The (.+) wins'
        local defend    = '(.+) has defended the (.+)'
        local taken     = 'The (.+) has taken the (.+)'
        local claim     = '(.+) claims the (.+)! If left unchallenged, the (.+) will control it in 1 minute!'
        local assault   = '(.+) has assaulted the (.+)'

        if  event == 'CHAT_MSG_BG_SYSTEM_HORDE' then
            faction = 'Horde'
        else
            faction = 'Alliance'
        end

        if  string.find(arg1, won) then
            for i = 1, 5 do 
                bu[i]:Hide()
                bu[i]:SetScript('OnUpdate', nil)
                return
            end
        end

        if  string.find(arg1, defend) then
            node = gsub(arg1, defend, '%2')
            node = gsub(node, '^%l', string.upper)
            HideTimer(node, faction)
            return
        end

        if  string.find(arg1, taken) then
            node = gsub(arg1, taken, '%2')
            node = gsub(node, '^%l', string.upper)
            HideTimer(node, faction)
            return
        end
    
        if  string.find(arg1, claim) then
            node = gsub(arg1, claim, '%2')
            node = gsub(node, '^%l', string.upper)
        elseif string.find(arg1, assault) then
            node = gsub(arg1, assault, '%2')
            node = gsub(node, '^%l', string.upper)
        end

        print(event)
        print(node)
        print(faction)

        UpdateIcon(node, faction, 'Assaulted')

        AddTimer(node)
    end

    local OnEvent = function()
        if  event == 'PLAYER_LOGIN' then
            AddNodes()
            AddNeutralIcon()
            if  GetZoneText() == 'Arathi Basin' then
                for i = 1, 5 do bu[i]:Show() end
            end
        elseif  event == 'ZONE_CHANGED_NEW_AREA' then
            if  GetZoneText() == 'Arathi Basin' then
                for i = 1, 5 do bu[i]:Show() end
                AddNeutralIcon() -- reset
            else
                for i = 1, 5 do bu[i]:Hide() end
            end
        else
            ParseStrings()
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)

    --
