
    local OnEvent = function()
        for i = 1, 5  do MODUI_BU(_G['TargetFrameBuff'..i], 1)              end
        for i = 1, 16 do MODUI_BU(_G['TargetFrameDebuff'..i], 1)            end
        for i = 1, 4  do MODUI_BU(_G['TargetofTargetFrameDebuff'..i], -1)   end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    --
