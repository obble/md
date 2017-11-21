

    local var   = MODUI_VAR['elements']['unit']
    local skin  = MODUI_VAR['elements']['bu_skin']

    local H = {}

    H.TargetDebuffButton_Update  = TargetDebuffButton_Update
    H.RefreshBuffs               = RefreshBuffs

    local anchor = function(num)
        if num and  num > 5 then return '6' end
        return '1'
    end

    --[[local AddDebuff = function(bu, border, texture, stacks, dtype, i)
        local icon   = _G['TargetFrameDebuff'..i..'Icon']
        local count  = _G['TargetFrameDebuff'..i..'Count']
        local colour = DebuffTypeColor[dtype] or DebuffTypeColor['none']

        icon:SetTexture(texture)

        border:Hide()

        if  stacks > 1 then
            count:SetText(stacks)
            count:Show()
        else
            count:Hide()
        end

        if skin.enable then
            modSkinColor(bu, colour.r*1.5, colour.g*1.5, colour.b*1.5)
        end
    end

    local AddBuffSize = function(x)
        for i = 1, 5 do
            local bu = _G['TargetFrameBuff'..i]
            if  bu then
                bu:SetWidth(x)
                bu:SetHeight(x)
            end
        end
    end

    local AddDebuffSize = function(x)
        for i = 1, 6 do
            local bu = _G['TargetFrameDebuff'..i]
            local border = _G['TargetFrameDebuff'..i..'Border']
            bu:SetWidth(x)
            bu:SetHeight(x)
            if  border then
                border:SetWidth(x + 2)
                border:SetHeight(x + 2)
            end
        end
    end

    local AddAuraPosition = function(wrap)
        if  UnitIsFriend('player', 'target') then
            if  var.aura then
                TargetFrameBuff1:ClearAllPoints()
                TargetFrameBuff1:SetPoint('TOPLEFT', TargetFrame, 'BOTTOMLEFT', 7, 32)
                TargetFrameDebuff1:ClearAllPoints()
                TargetFrameDebuff1:SetPoint('TOPLEFT', _G['TargetFrameBuff1'], 'BOTTOMLEFT', 0, -4)
            else
                TargetFrameBuff1:ClearAllPoints()
                TargetFrameBuff1:SetPoint('BOTTOMLEFT', TargetFrame, 'TOPLEFT', 7, -20)
                TargetFrameDebuff1:ClearAllPoints()
                TargetFrameDebuff1:SetPoint('BOTTOMLEFT', _G['TargetFrameBuff1'], 'TOPLEFT', 0, 5)
            end
        else
            if  var.aura then
                TargetFrameDebuff1:ClearAllPoints()
                TargetFrameDebuff1:SetPoint('TOPLEFT', TargetFrame, 'BOTTOMLEFT', 7, 32)
                TargetFrameBuff1:ClearAllPoints()
                TargetFrameBuff1:SetPoint('TOPLEFT', _G['TargetFrameDebuff1'], 'BOTTOMLEFT', 0, -4)
            else
                TargetFrameDebuff1:ClearAllPoints()
                TargetFrameDebuff1:SetPoint('BOTTOMLEFT', TargetFrame, 'TOPLEFT', 7, -20)
                if  numDebuff < 5 or not TargetofTargetFrame:IsShown() then
                    TargetFrameBuff1:ClearAllPoints()
                    TargetFrameBuff1:SetPoint('BOTTOMLEFT', _G['TargetFrameDebuff1'], 'TOPLEFT', 2, 5)
                elseif numDebuff > 4 and numDebuff < 10 then
                    TargetFrameBuff1:ClearAllPoints()
                    TargetFrameBuff1:SetPoint('BOTTOMLEFT', _G['TargetFrameDebuff6'], 'TOPLEFT', 2, 5)
                elseif numDebuff > 10 then
                    TargetFrameBuff1:ClearAllPoints()
                    TargetFrameBuff1:SetPoint('BOTTOMLEFT', _G['TargetFrameDebuff11'], 'TOPLEFT', 2, 5)
                end
            end
        end

        local row   = _G['TargetFrameDebuff'..(wrap - 1)]
        local row1  = _G['TargetFrameDebuff'..(wrap)]
        local row2  = _G['TargetFrameDebuff'..(wrap + 1)]
        local row3  = _G['TargetFrameDebuff'..(wrap + 2)]
        
        row1:ClearAllPoints()
        row1:SetPoint('LEFT', row, 'RIGHT', 3, 0)

        if  var.aura then
            row2:ClearAllPoints()
            row2:SetPoint('TOPLEFT', TargetFrameDebuff1, 'BOTTOMLEFT', 0, -2)
        else
            row2:ClearAllPoints()
            row2:SetPoint('BOTTOMLEFT', TargetFrameDebuff1, 'TOPLEFT', 2, 5)
        end

        row3:ClearAllPoints()
        row3:SetPoint('LEFT', row2, 'RIGHT', 3, 0)

        -- Set anchor for the last row if debuff wrap is 5
        if  wrap == 5 then
            TargetFrameDebuff11:ClearAllPoints()
            TargetFrameDebuff11:SetPoint('TOPLEFT', TargetFrameDebuff6, 'BOTTOMLEFT', 0, -2)
        else
            TargetFrameDebuff11:ClearAllPoints()
            TargetFrameDebuff11:SetPoint('LEFT', TargetFrameDebuff10, 'RIGHT', 3, 0)
        end
    end

    local TargetUpdate = function()
        local numBuff, numDebuff    = 0, 0
        local wrap                  = TargetofTargetFrame:IsShown() and 5 or 6
        local x

        for i = 1, MAX_TARGET_BUFFS do
            local buff  = UnitBuff('target', i)
            local bu    = _G['TargetFrameBuff'..i]
            if  buff then
                _G['TargetFrameBuff'..i..'Icon']:SetTexture(buff)
                numBuff = numBuff + 1
                bu.id   = i
                bu:Show()
            else
                bu:Hide()
            end
        end

        for i = 1, MAX_TARGET_DEBUFFS do
            local texture, stacks, dtype = UnitDebuff('target', i)
            local bu     = _G['TargetFrameDebuff'..i]
            local border = _G['TargetFrameDebuff'..i..'Border']
            if  texture then
                AddDebuff(bu, border, texture, stacks, dtype, i)
                numDebuff = numDebuff + 1
                bu:Show()
            else
                bu:Hide()
            end
            bu.id = i
        end

        if ((TargetofTargetFrame:IsShown() and (numBuff == 5)) or (numDebuff >= wrap)) then
            x = 17
        else
            x = 21
        end

        AddBuffSize(x)
        AddDebuffSize(x)
        AddAuraPosition(wrap)
    end]]

    local AddAllTargetBuffs = function()
        local numBuff, numDebuff = 0, 0

        for i = 1, 16 do
            local bu    = _G['TargetFrameBuff'..i]
            local icon  = UnitBuff('target', i)
            if  bu and icon then
                _G['TargetFrameBuff'..i..'Icon']:SetTexture(icon)
                bu.id   = i
                numBuff = i
                bu:Show()
            else
                if bu then bu:Hide() end
            end
        end

        for i = 1, 16 do
            local icon, stack, dtype = UnitDebuff('target', i)
            local bu = _G['TargetFrameDebuff'..i]
            if  bu and icon then
                local count     = _G['TargetFrameDebuff'..i..'Count']
                local border    = _G['TargetFrameDebuff'..i..'Border']
                local colour    = DebuffTypeColor[dtype] or DebuffTypeColor['none']

                MODUI_BUBorder(bu)

                if  stack > 1 then
                    count:SetText(stack)
                    count:Show()
                else
                    count:Hide()
                end

                border:Hide()

                _G['TargetFrameDebuff'..i..'Icon']:SetTexture(icon)

                bu.bo:SetBackdropBorderColor(colour.r, colour.g, colour.b)
                if  skin.enable then
                    modSkinColor(bu, colour.r*1.5, colour.g*1.5, colour.b*1.5)
                end

                bu.id       = i
                numDebuff   = i
                bu:Show()
            else
                if  bu then 
                    bu:Hide() 
                end
            end
        end

        for i = 6, 12 do
            local bu    = _G['TargetFrameBuff'..i]
            bu:SetWidth(_G['TargetFrameBuff1']:GetWidth()) 
            bu:SetHeight(_G['TargetFrameBuff1']:GetHeight())
            bu:Hide()
        end

        if  UnitIsFriend('player', 'target') then
            if  not var.auras then
                TargetFrameBuff1:ClearAllPoints()
                TargetFrameBuff1:SetPoint('TOPLEFT', TargetFrame, 'BOTTOMLEFT', 7, 32)
                TargetFrameBuff6:ClearAllPoints()
                TargetFrameBuff6:SetPoint('TOPLEFT', _G['TargetFrameBuff1'], 'BOTTOMLEFT', 0, -4)
                TargetFrameDebuff1:ClearAllPoints()
                TargetFrameDebuff1:SetPoint('TOPLEFT', _G['TargetFrameBuff'..anchor(b)], 'BOTTOMLEFT', 0, -4)
            else
                TargetFrameBuff1:ClearAllPoints()
                TargetFrameBuff1:SetPoint('BOTTOMLEFT', TargetFrame, 'TOPLEFT', 7, -20)
                TargetFrameBuff6:ClearAllPoints()
                TargetFrameBuff6:SetPoint('BOTTOMLEFT', _G['TargetFrameBuff1'], 'TOPLEFT', 0, 5)
                TargetFrameDebuff1:ClearAllPoints()
                TargetFrameDebuff1:SetPoint('BOTTOMLEFT', _G['TargetFrameBuff'..anchor(b)], 'TOPLEFT', 0, 5)
            end
        else
            if  not var.auras then
                TargetFrameDebuff1:ClearAllPoints()
                TargetFrameDebuff1:SetPoint('TOPLEFT', TargetFrame, 'BOTTOMLEFT', 7, 32)
                TargetFrameBuff1:ClearAllPoints()
                TargetFrameBuff1:SetPoint('TOPLEFT', _G['TargetFrameDebuff'..anchor(d)], 'BOTTOMLEFT', 0, -4)
            else
                TargetFrameDebuff1:ClearAllPoints()
                TargetFrameDebuff1:SetPoint('BOTTOMLEFT', TargetFrame, 'TOPLEFT', 7, -20)
                TargetFrameBuff1:ClearAllPoints()
                TargetFrameBuff1:SetPoint('BOTTOMLEFT', _G['TargetFrameDebuff'..anchor(d)], 'TOPLEFT', 2, 5)
            end
        end
    end

    local OnUpdate = function()
        for i = 1, 4 do
            local f     = 'TargetofTargetFrameDebuff'..i
            local d     = _G[f..'Border']
            local icon  = _G[f..'Icon']
            if  d then
                local r, g, b = d:GetVertexColor()
                if  skin.enable then
                    modSkinColor(_G[f], r*1.5, g*1.5, b*1.5)
                end
                d:SetAlpha(0)
                icon:SetTexCoord(.1, .9, .1, .9)
            end
        end
    end

    local OnEnter = function()
        UnitFrame_OnEnter()
        TargetDebuffButton_Update()
    end

    local OnLeave = function()
        UnitFrame_OnLeave()
        TargetDebuffButton_Update()
        for i = 6, 12 do 
            _G['TargetFrameBuff'..i]:Hide() 
        end
    end

    local OnEvent = function()
        for i = 2, 4 do
            local bu    = _G['TargetofTargetFrameDebuff'..i]
            local bu1   = _G['TargetofTargetFrameDebuff1']
            bu:ClearAllPoints()
            if      i == 2 then
                bu:SetPoint('LEFT',     _G['TargetofTargetFrameDebuff1'], 'RIGHT', 4, 0)
            elseif  i == 3 then
                bu:SetPoint('TOPLEFT',  _G['TargetofTargetFrameDebuff1'], 'BOTTOMLEFT', 0, -4)
            else
                bu:SetPoint('LEFT',     _G['TargetofTargetFrameDebuff3'], 'RIGHT', 4, 0)
            end
        end
    end

    TargetDebuffButton_Update = AddAllTargetBuffs

    TargetFrame:SetScript('OnEnter', OnEnter)
    TargetFrame:SetScript('OnLeave', OnLeave)

    local e = CreateFrame('Frame', 'modToT', TargetofTargetTextureFrame)
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent',  OnEvent)
    e:SetScript('OnUpdate', OnUpdate)

    --
