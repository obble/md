

    local OnEvent = function()
        for i = 1, 24 do
            local bu = _G['BonusActionButton'..i]
            if  bu then
                MODUI_BU(bu, 0)
                MODUI_BUElements(bu)
                bu:SetCheckedTexture''
            end
        end
        for i = 1, 12 do
            for _, v in pairs(
                    {
                    _G['ActionButton'..i],
                    _G['MultiBarRightButton'..i],
                    _G['MultiBarLeftButton'..i],
                    _G['MultiBarBottomLeftButton'..i],
                    _G['MultiBarBottomRightButton'..i],
                }
            ) do
                MODUI_BU(v, 0)
                MODUI_BUElements(v)
            end

            for _, v in pairs(
                {
                    _G['MultiBarBottomLeftButton1'],
                    _G['MultiBarBottomRightButton12']
                }
            ) do
                v:SetFrameStrata'LOW'
            end

            for _, v in pairs(
                {
                    _G['ActionButton'..i..'NormalTexture'],
                    _G['MultiBarLeftButton'..i..'NormalTexture'],
                    _G['MultiBarRightButton'..i..'NormalTexture'],
                    _G['MultiBarBottomLeftButton'..i..'NormalTexture'],
                    _G['MultiBarBottomRightButton'..i..'NormalTexture'],
                    _G['BonusActionButton'..i..'NormalTexture']
                }
            ) do
                v:SetAlpha(0)
            end

            for _, v in pairs(
                {
                    _G['ActionButton'..i..'Cooldown'],
                    _G['MultiBarLeftButton'..i..'Cooldown'],
                    _G['MultiBarRightButton'..i..'Cooldown'],
                    _G['MultiBarBottomLeftButton'..i..'Cooldown'],
                    _G['MultiBarBottomRightButton'..i..'Cooldown']
                }
            ) do 
                v:SetFrameLevel(4)
            end
        end

        for i = 1, 10 do
            local a = _G['PetActionButton'..i..'AutoCast']
            a:SetScale(1) a:SetFrameLevel(3)

            local a = _G['PetActionButton'..i..'AutoCastable']
            a:SetWidth(50) a:SetHeight(50)

            for _, v in pairs(
                {
                    _G['ShapeshiftButton'..i],
                    _G['PetActionButton'..i]
                }
            ) do
                MODUI_BU(v)
            end
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)
    

    --
