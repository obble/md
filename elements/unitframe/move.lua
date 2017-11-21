

    local H = {}

    H.UnitFrame_OnEnter = UnitFrame_OnEnter

    local OnEvent = function()
        for _, v in pairs(
            {
                PlayerFrame,
                TargetFrame,
                PartyMemberFrame1
            }
        ) do
            v:SetUserPlaced(true) 
            v:SetMovable(true) 
            v:EnableMouse(true)
            v:RegisterForDrag'LeftButton'
            v:SetScript('OnDragStart', function() if IsShiftKeyDown() then this:StartMoving() end end)
            v:SetScript('OnDragStop',  function() this:StopMovingOrSizing() end)
        end
    end

    local OnEnter = function()
        H.UnitFrame_OnEnter()
        local n     = this:GetName()
        local unit  = this.unit
        if  SHOW_NEWBIE_TIPS == '1' and (n == 'TargetFrame' or  n == 'PartyMemberFrame1') then
            GameTooltip:AddLine('Shift + Drag to move '..n..'.', .3, 1, .6)
            GameTooltip:Show()
        end
    end

    local ResetPosition = function(arg)
        for _, v in pairs(
            { 
                PlayerFrame,
                TargetFrame,
                PartyFrame1
            }
        ) do
            v:SetUserPlaced(false)
            v:ClearAllPoints()
        end
        PlayerFrame:SetPoint('TOPLEFT', -19, -4)
        TargetFrame:SetPoint('TOPLEFT', 250, -4)
        PartyMemberFrame1:SetPoint('TOPLEFT', 10, -128)
    end

    UnitFrame_OnEnter = OnEnter

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    SLASH_RESETUF1 = '/reset'
    SlashCmdList['RESETUF'] = ResetPosition

    --
