

    local skin = MODUI_VAR['elements']['bu_skin']
    local H = {}

    local Update  = function()
        H.TalentFrame_Update()
        if not skin.enable then return end
        for i = 1, 20 do
            local bu    = _G['TalentFrameTalent'..i]
            local slot  = _G['TalentFrameTalent'..i..'Slot']
            local r, g, b = slot:GetVertexColor()
            if  decimal_round(r, 1) ~= .5 then
                modSkinColor(bu, r, g, b)
            else
                modSkinColor(bu, .7, .7, .7)
            end 
        end
    end

    local AddButtons = function()
        if not skin.enable then return end
        for i = 1, 20 do
            local bu        = _G['TalentFrameTalent'..i]
            local slot      = _G['TalentFrameTalent'..i..'Slot']
            local border    = _G['TalentFrameTalent'..i..'RankBorder']
            MODUI_BU(bu)          
            slot:SetAlpha(0)
            border:SetPoint('TOP', bu, 'BOTTOM', 0, 8)
        end
        TalentFrame_Update = Update
    end

    local OnEvent = function()
        if arg1 == 'Blizzard_TalentUI' then
            H.TalentFrame_Update = TalentFrame_Update
            AddButtons()
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'ADDON_LOADED'
    e:SetScript('OnEvent', OnEvent)

    --
