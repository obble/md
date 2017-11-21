
    local skin = MODUI_VAR['elements']['bu_skin']

    local OnEvent = function()
        if not skin.enable then return end

        for i = 1, 10 do
            local bu = _G['QuestLogItem'..i]
            local ic = _G['QuestLogItem'..i..'IconTexture']
            if  bu then
                local f = CreateFrame('Frame', nil, bu)
                f:SetAllPoints(ic)
                modSkin(f, 1)
                modSkinColor(f, skin.r, skin.g, skin.b)
            end
        end

        for i = 1, 6 do
            local bu = _G['QuestDetailItem'..i]
            local ic = _G['QuestDetailItem'..i..'IconTexture']
            if bu then
                local f = CreateFrame('Frame', nil, bu)
                f:SetAllPoints(ic)
                modSkin(f, 1)
                modSkinColor(f, skin.r, skin.g, skin.b)
            end
        end

        for i = 1, 6 do
            local bu = _G['QuestProgressItem'..i]
            local ic = _G['QuestProgressItem'..i..'IconTexture']
            if bu then
                local f = CreateFrame('Frame', nil, bu)
                f:SetAllPoints(ic)
                modSkin(f, 1)
                modSkinColor(f, skin.r, skin.g, skin.b)
            end
        end

        for i = 1, 6 do
            local bu = _G['QuestRewardItem'..i]
            local ic = _G['QuestRewardItem'..i..'IconTexture']
            if bu then
                local f = CreateFrame('Frame', nil, bu)
                f:SetAllPoints(ic)
                modSkin(f, 1)
                modSkinColor(f, skin.r, skin.g, skin.b)
            end
        end

        local sk = _G['QuestInfoSkillPointFrame']
        local ic = _G['QuestInfoSkillPointFrameIconTexture']
        if  sk then
            sk.f = CreateFrame('Frame', nil, bu)
            sk.f:SetAllPoints(ic)
            modSkin(sk.f, 1)
            modSkinColor(sk.f, skin.r, skin.g, skin.b)
        end

        local sp = _G['QuestInfoRewardSpell']
        local ic = _G['QuestInfoRewardSpellIconTexture']
        if  sp then
            sp.f = CreateFrame('Frame', nil, sp)
            sp.f:SetAllPoints(ic)
            modSkin(sp.f, 1)
            modSkinColor(sp.f, skin.r, skin.g, skin.b)
        end

        local ta = _G['QuestInfoTalentFrame']
        local ic = _G['QuestInfoTalentFrameIconTexture']
        if  ta then
            ta.f = CreateFrame('Frame', nil, ta)
            ta.f:SetAllPoints(ic)
            modSkin(ta.f, 1)
            modSkinColor(ta.f, skin.r, skin.g, skin.b)
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    --
