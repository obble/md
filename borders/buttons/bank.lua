

    local OnEvent = function()
        for i = 1, 24 do
            local bu = _G['BankFrameItem'..i]
            if  bu then 
                MODUI_ITEMS(bu)
           end
        end

        for i = 1, 7 do
            local bu = _G['BankFrameBag'..i]
            if  bu then
                MODUI_ITEMS(bu)
            end
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    --
