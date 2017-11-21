

    local events = {
        'TRADE_SHOW',
        'TRADE_UPDATE'
    }

    local OnEvent = function()
        for i = 1, 7 do
            for _, v in pairs(
                {
                    _G['TradePlayerItem'..i..'ItemButton'],
                    _G['TradeRecipientItem'..i..'ItemButton']
                }
            ) do
                if  not modSkinned(v) then
                    MODUI_BU(v, 1)
                    MODUI_BUElements(v)
                end  
            end  
        end
    end

    local  e = CreateFrame'Frame'
    for _, v in pairs(events) do e:RegisterEvent(v) end
    e:SetScript('OnEvent', OnEvent)

    --
