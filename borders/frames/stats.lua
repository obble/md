
    
    local skin = MODUI_VAR['elements']['bu_skin']

    local  OnEvent = function()
        if not skin.enable then return end

        local stat      = CreateFrame('Frame', nil, CharacterAttributesFrame)
        stat:SetAllPoints(PlayerStatBackgroundTop)

        local melee     = CreateFrame('Frame', nil, CharacterAttributesFrame)
        melee:SetAllPoints(MeleeAttackBackgroundTop)

        local ranged    = CreateFrame('Frame', nil, CharacterAttributesFrame)
        ranged:SetAllPoints(RangedAttackBackgroundTop)

        for _, v in pairs (
            {
                stat, melee, ranged
            }
        ) do
            modSkin(v, 2.5)
            modSkinColor(v, skin.r, skin.g, skin.b)
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    --
