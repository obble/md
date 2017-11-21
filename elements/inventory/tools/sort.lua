

	local H 	= {}

	local OnClick = function()
		if  UnitIsDead'player' or UnitIsGhost'player' then 
			UIErrorsFrame:AddMessage(ERR_PLAYER_DEAD, 1, 0, 0)
			return
		end
		if  BankFrame:IsShown() then
			for _, v in pairs({'bags', 'bank'}) do Clean_Up(v) end
		else
			Clean_Up('bags')
		end
	end

	local OnEvent = function()
		local bag 	= _G['modbag']

		local bu  = CreateFrame('Button', 'modsort', bag)
		MODUI_BU(bu, 2)
		bu:SetPoint('BOTTOMRIGHT', bag, 'TOPRIGHT', -11, -54)
		bu:SetWidth(26)
		bu:SetHeight(26)
		bu:SetFrameLevel(10)
		bu:EnableMouse(true)
		bu:RegisterForClicks'AnyUp'

		bu:SetNormalTexture[[Interface\AddOns\md\art\inventory\Bags]]
		bu:GetNormalTexture():SetTexCoord(.12109375, .23046875, .7265625, .9296875)

		bu:SetPushedTexture[[Interface\AddOns\md\art\inventory\Bags]]
		bu:GetPushedTexture():SetTexCoord(.00390625, .11328125, .7265625, .9296875)

		bu:SetHighlightTexture[[Interface\Buttons\ButtonHilight-Square]]
		bu:GetHighlightTexture():ClearAllPoints()
		bu:GetHighlightTexture():SetPoint('CENTER', 0, 0)
		bu:GetHighlightTexture():SetWidth(24)
		bu:GetHighlightTexture():SetHeight(23)

		bu:SetScript('OnMouseDown', OnClick)
	end

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', OnEvent)


	--
