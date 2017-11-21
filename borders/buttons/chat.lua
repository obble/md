
	local OnEvent = function()
	    local bu = ChatFrameMenuButton
	    MODUI_BU(bu, 6)

	    for i = 1, 7 do
	        local bu = _G['ChatFrame'..i..'BottomButton']
	        MODUI_BU(bu, 6)
	    end
	end

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    --
