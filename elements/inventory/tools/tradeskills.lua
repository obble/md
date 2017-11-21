

	local used 	= {}
	local H 	= {}

	local x 	= {
		66, 93, 120, 147
	}

	H.ActionButton_GetPagedID = ActionButton_GetPagedID

	local GetPagedID = function(bu)
		if  bu.modtool then
			return 13 + bu:GetID() - 1
		else
			return H.ActionButton_GetPagedID(bu)
		end
	end

	local OnEvent = function()
		local bag 	= _G['modbag']
		for i = 1, 4 do
			local bu = CreateFrame('CheckButton', 'modtool'..i, bag, 'BonusActionButtonTemplate')
			local nm = _G['modtool'..i..'NormalTexture']

			MODUI_BU(bu, 0)
			MODUI_BUElements(bu)

			bu:SetPoint('TOPLEFT', bag, x[i], -30)
			bu:SetWidth(22)
			bu:SetHeight(22)
			bu:SetFrameLevel(10)
			bu:SetID(i)
			bu:Enable()

			nm:SetVertexColor(0, 0, 0, 0)
			nm.SetVertexColor = function() end

			bu.modtool 		= true
			bu.isBonus 		= true
			bu.buttonType 	= 'MODUI_TOOL'

        	ActionButton_GetPagedID = GetPagedID
		end
	end

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', OnEvent)


	--
