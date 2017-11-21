
    local e = CreateFrame'Frame'
    local j = 1

    local OnEvent = function()
        if  arg1 == 'Blizzard_TradeSkillUI' then
            local bu = _G['TradeSkillSkillIcon']
            if  bu then
                MODUI_BU(bu)
            end

            local t = _G['TradeSkillDetailHeaderLeft']
            t:Hide()

            for i = 1, MAX_TRADE_SKILL_REAGENTS do
                local r  = _G['TradeSkillReagent'..i]
                local ri = _G['TradeSkillReagent'..i..'IconTexture']
                local rc = _G['TradeSkillReagent'..i..'Count']

                if  r then
                    if  not ri.f then -- new frame for us to reparent to
                        ri.f = CreateFrame('Frame', nil, r)
                        ri.f:SetFrameLevel(r:GetFrameLevel() + 1)
                        ri.f:SetPoint('TOPLEFT', ri)
                        ri.f:SetPoint('BOTTOMRIGHT', ri)
                        ri.f:EnableMouse(false)
                        MODUI_BU(ri.f)
                    end

                    ri:SetParent(ri.f)
                    ri:SetPoint('TOPLEFT', r, 1, -1)
                    ri:SetPoint('BOTTOMRIGHT', r, -107, 1)
                    ri:SetDrawLayer'ARTWORK'

                    rc:SetParent(ri.f)
                    rc:SetDrawLayer'OVERLAY'
                end
            end
            j = j  + 1
            if  j == 3 then e:UnregisterAllEvents() end
        elseif arg1 == 'Blizzard_CraftUI' then
            local bu = _G['CraftIcon']
            if  bu then
                MODUI_BU(bu)
            end

            local t = _G['CraftDetailHeaderLeft']
            t:Hide()

            for i = 1, MAX_CRAFT_REAGENTS do
                local r  = _G['CraftReagent'..i]
                local ri = _G['CraftReagent'..i..'IconTexture']
                local rc = _G['CraftReagent'..i..'Count']

                if  r then
                    if not ri.f then
                        ri.f = CreateFrame('Frame', nil, r)
                        ri.f:SetFrameLevel(r:GetFrameLevel() + 1)
                        ri.f:SetPoint('TOPLEFT', ri)
                        ri.f:SetPoint('BOTTOMRIGHT', ri)
                        ri.f:EnableMouse(false)
                        MODUI_BU(bu, 11)
                    end

                    ri:SetParent(ri.f)
                    ri:SetPoint('TOPLEFT', r, 1, -1)
                    ri:SetPoint('BOTTOMRIGHT', r, -107, 1)
                    ri:SetDrawLayer'ARTWORK'

                    rc:SetParent(ri.f)
                    rc:SetDrawLayer'OVERLAY'
                end
            end
            j = j  + 1
            if  j == 3 then e:UnregisterAllEvents() end
        end
    end

    e:RegisterEvent'ADDON_LOADED'
    e:SetScript('OnEvent', OnEvent)

    --
