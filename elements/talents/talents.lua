

    local _, class  = UnitClass'player'
    local active

    local H         = {}

    local buttons   = {
        ['DRUID']   = {},
        ['HUNTER']  = {},
        ['MAGE']    = {
            ['Winters Chill']    = {
                ['Tab1'] = {        --  arcane
                    1, 2, 5, 6, 7, 12
                },
                ['Tab2'] = {},      --  fire
                ['Tab3'] = {        --  frost
                    2, 3, 4, 7, 8, 10, 11, 12, 14, 16, 17
                },
            },
            ['Arcane Frost']    = {
                ['Tab1'] = {        --  arcane
                    1, 2, 4, 5, 6, 9, 11, 12, 13, 14, 15, 16
                },
                ['Tab2'] = {},      --  fire
                ['Tab3'] = {        --  frost
                    2, 3, 4, 8, 11, 12
                },
            },
            ['PvP Frost']       = { --  http://db.vanillagaming.org/?talent#obhVrobZZVVGuRbtho
                ['Tab1'] = {        --  frost
                    1, 3, 6, 7, 8, 9, 11
                },
                ['Tab2'] = {},      --  fire
                ['Tab3'] = {        --  frost
                    2, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 17
                },
            },
        },
        ['PALADIN'] = {},
        ['PRIEST']  = {},
        ['ROGUE']   = {},
        ['SHAMAN']  = {},
        ['WARLOCK'] = {},
        ['WARRIOR'] = {},
    }

    local OnClick = function(bu, t)
        local n = this:GetText()
        local i = PanelTemplates_GetSelectedTab(TalentFrame)
        local j = buttons[class][n]['Tab'..i]

        --  show relative talent frames
        for k, v in pairs(j) do
            if  bu[v]:IsShown()
            then
                bu[v]:Hide()
                active = nil
            else
                bu[v]:Show()
                active = n
            end
        end
    end

    local TabOnClick = function()
        if not active then return H.TalentFrameTab_OnClick() end
        local j = buttons[class][active]['Tab'..gsub(this:GetName(), 'TalentFrameTab', '')]

        for i = 1, 20 do
            local bu = _G['TalentFrameTalent'..i..'CookieCutter']
            bu:Hide()
        end

        for k, v in pairs(j) do
            local bu = _G['TalentFrameTalent'..v..'CookieCutter']
            bu:Show()
        end

        H.TalentFrameTab_OnClick()
    end

    local AddCookieCutters = function()
        local bu    = {}
        local j     = buttons[class]
        local x     = 1

        for i = 1, 20 do
            local talent = _G['TalentFrameTalent'..i]

            bu[i] = talent:CreateTexture('TalentFrameTalent'..i..'CookieCutter', 'OVERLAY')
            bu[i]:SetPoint('CENTER', talent)
            bu[i]:SetWidth(60) bu[i]:SetHeight(60)
            bu[i]:SetTexture[[Interface\Buttons\UI-AutoCastableOverlay]]
            bu[i]:Hide()
        end

        for t, v in pairs(j) do
            local f = CreateFrame('Button', 'modui_cookiecuttertogglebutton_'..t, TalentFrame, 'UIPanelButtonTemplate')
            f:SetWidth(80) f:SetHeight(20)
            f:SetText(t)
            f:SetFont(STANDARD_TEXT_FONT, 10)
            f:SetPoint('BOTTOMLEFT', TalentFrame, x == 1 and 30 or x == 2 and 127 or 230, 106)
            f:SetScript('OnClick', function()
                OnClick(bu, t)
            end)
            x = x + 1
        end
    end

    local OnEvent = function()
        if  arg1 == 'Blizzard_TalentUI' then
            AddCookieCutters()
            H.TalentFrameTab_OnClick = TalentFrameTab_OnClick
            TalentFrameTab_OnClick   = TabOnClick
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'ADDON_LOADED'
    e:SetScript('OnEvent', OnEvent)


    --
