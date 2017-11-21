

	local AddSlots = function(bank)
		for i = 1, 6 do
			local slot 		= _G['BankFrameBag'..i]
			local highlight = _G['BankFrameBag'..i..'HighlightFrame']

			slot:UnregisterEvent'ITEM_PUSH'
			slot:SetHighlightTexture''
			slot:SetParent(bank)
			slot:SetWidth(24)
			slot:SetHeight(24)
			slot:ClearAllPoints()

			highlight:SetAlpha(0)

			if i == 1 then
				slot:SetPoint('TOPLEFT', bank, 66, -29)
			else
				slot:SetPoint('LEFT', _G['BankFrameBag'..(i - 1)], 'RIGHT', 3, 0)
			end
		end
	end

	local OnEvent = function()
		if  event == 'BANKFRAME_OPENED' then
			SetPortraitToTexture(_G['modbank'].portrait, 'npc')
		else
			local bank = CreateFrame('Button', 'modbank', _G['modbag'])
			MODUI_ButtonTemplate(bank, true)
			bank:SetPoint('BOTTOMRIGHT', _G['modbag'], 'BOTTOMLEFT', -20, 0)
			bank:SetFrameLevel(0)
			bank:Hide()

			bank.portrait = bank:CreateTexture(nil, 'BORDER', nil, 7)
			bank.portrait:SetWidth(64)
			bank.portrait:SetHeight(64)
			bank.portrait:SetPoint('TOPLEFT', -8, 8)
			bank.portrait:SetAlpha(1)

			bank.name = bank:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
	    	bank.name:SetFont(STANDARD_TEXT_FONT, 12)
	    	bank.name:SetText'Bank'
	    	bank.name:SetPoint('TOPLEFT', 66, -5)
	    	bank.name:SetTextColor(1, .7, 0)

			bank.bd = CreateFrame('Frame', nil, bank)
			bank.bd:SetPoint('TOPLEFT', 8, -58)
			bank.bd:SetPoint('BOTTOMRIGHT', -10, 27)

			bank.bd.t = bank.bd:CreateTexture(nil, 'ARTWORK')
			bank.bd.t:SetAllPoints()
			bank.bd.t:SetTexture([[Interface/BankFrame/Bank-Background]], true, true)
			bank.bd.t:SetVertexColor(.8, .8, .8)

			bank.close = bank.ButtonTemplate.Inset.CloseButton
			bank.close:SetFrameLevel(4)

			bank.purchase = BankFramePurchaseButton
			bank.purchase:SetWidth(70)
			bank.purchase:SetParent(bank)
			bank.purchase:ClearAllPoints()
			bank.purchase:SetPoint('BOTTOM', bank, 0, 5)

			bank.money = BankFrameDetailMoneyFrame
			bank.money:SetParent(bank)
			bank.money:ClearAllPoints()
			bank.money:SetPoint('BOTTOMRIGHT', bank, 0, 10)

			AddSlots(bank)

			for _, v in pairs(
		      	{
			        BankFrameDetailMoneyFrameCopperButtonText,
			        BankFrameDetailMoneyFrameSilverButtonText,
			        BankFrameDetailMoneyFrameGoldButtonText
		      	}
		    ) do
		      v:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE')
		      v:SetShadowOffset(0, 0)
		    end
		end
	end

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:RegisterEvent'BANKFRAME_OPENED'
	e:SetScript('OnEvent', OnEvent)


	--
