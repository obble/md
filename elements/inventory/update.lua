

	local var       	= MODUI_VAR['elements']['bu_skin']
	local size 			= 28
	local spacing 		= 3
	local bu, con, bag, col, row
	local buttons 		= {}
	local keybuttons	= {}
	local bankbuttons 	= {}
	local H 			= {}


	--   todo:
	-- bank: fix
	-- bank/bag/keyring: fix open/close logic and x/y relative to thus
	-- keyring: either recreate or reallocate resources to embed this in the bag.
	--		 stop it getting chewed up so fiercely

	H.ContainerFrame_OnShow = ContainerFrame_OnShow
	H.ContainerFrame_OnHide = ContainerFrame_OnHide
	H.ContainerFrame_Update = ContainerFrame_Update

	local GetSlots = function()
		local  num = 1
		for i = 1, NUM_BAG_FRAMES do
			local name 	= 'ContainerFrame'..i + 1
			local f 	= _G[name]
			local _, a 	= f:GetRegions()
			local n 	= a:GetName()
			if  f:IsShown() then
				if not (string.find(n, 'Bank') or string.find(n, 'Keyring'))  then
					num = num + 1
				end
			end
		end
		return num
	end

	local GetItemType = function(bu, id)
		local link 				= GetContainerItemLink(id, bu:GetID())
		local _, _, _, quality 	= GetContainerItemInfo(id, bu:GetID())
	
	    bu.bo:SetBackdropBorderColor(0, 0, 0, 0)

	    if  link then
	    	local _, _, t = string.find(link, '(item:%d+:%d+:%d+:%d+)')
            local n, _, q, _, _, subtype	= GetItemInfo(t)
	    	if  string.find(n, 'Mark of Honor') then
               	bu.bo:SetBackdropBorderColor(.98, .95, 0, 1)
               	if  var.enable then
                	modSkinColor(bu, .98, .95, 0)
                end
            elseif subtype == 'Quest' then
                bu.bo:SetBackdropBorderColor(1, .33, 0, 1)
                if  var.enable then
                	modSkinColor(bu, 1, .33, 0)
                end
            elseif q and q > 1 then
               	local r, g, b = GetItemQualityColor(q)
               	bu.bo:SetBackdropBorderColor(r, g, b, 1)
               	if  var.enable then
                	modSkinColor(bu, r, g, b)
                end
			end
		end
	end

	local GetSlotType = function(bu, id)
		if  var.enable then
			local link 		= GetInventoryItemLink('player', ContainerIDToInventoryID(id))
			local _, _, t 	= string.find(link or '', 'item:(%d+)')

			modSkinColor(bu, var.r, var.g, var.b)

			if  id == KEYRING_CONTAINER then
	        	modSkinColor(bu, 1, .5, 0)
	        elseif t then
	        	local _, _, _, _, _, subtype = GetItemInfo(t)
	 			if  subtype == 'SOULBAG' or subtype == 'QUIVER' then
	 				modSkinColor(bu, .2, 1, .4)
	 			end
	    	end
	    end
	end

	local HideStandardBags = function(n)
		local  bag = _G[n]
		if not bag.stripped then
			local a, b, c, d, e, f = bag:GetRegions()

			bag:EnableMouse(false)

			_G[n..'PortraitButton']:EnableMouse(false)
			_G[n..'CloseButton']:Hide()

			for _, v in pairs(
				{
					a, b, c, d, e, f
				}
			) do 
				v:SetAlpha(0) 
			end

			bag.stripped = true
		end
	end

	local HideStandardBank = function()
		BankFrame:EnableMouse(false)
		BankFrame:DisableDrawLayer'BACKGROUND'
		BankFrame:DisableDrawLayer'BORDER'
		BankFrame:DisableDrawLayer'ARTWORK'
		BankFrame:DisableDrawLayer'OVERLAY'

		for _, v in pairs({BankFramePurchaseInfo:GetRegions()}) do
			v:Hide()
		end

		for _, v in pairs(
			{
				BankCloseButton,
				BankFrameMoneyFrame,
				BankPortraitTexture,
				BankFramePurchaseInfo,
			}
		) do
			v:Hide()
		end
	end

	local AddButtonBG = function(bu)
		bu.bg = bu:CreateTexture(nil, 'BACKGROUND', nil, 7)
		bu.bg:SetTexture[[Interface\PaperDoll\UI-Backpack-EmptySlot]]
		bu.bg:SetTexCoord(.1, .9, .1, .9)
		bu.bg:SetAlpha(.5)
		bu.bg:SetAllPoints()
	end

	local MoveButtons = function(table, f)
		local length  = tlength(table)
		local columns = math.ceil(sqrt(length) + 1)
		local col, row = 0, 0
		for i = 1, length do
			bu = table[i]
			bu:SetWidth(size)
			bu:SetHeight(size)
			bu:SetFrameLevel(2)
			bu:ClearAllPoints()
			bu:SetPoint(
				'TOPLEFT', 
				f, 
				col*(size + spacing) + 7,
				-1*row*(size + spacing) - 66
			)

			-- bg art
			if not bu.bg then
				AddButtonBG(bu)
			end

			if columns < 6 then
				KeyRingButton:Hide()
			else
				KeyRingButton:Show()
			end

			if  col > (columns - 3) then
				col = 0
				row = row + 1
			else
				col = col + 1
			end
		end

		for i = 1, 4 do
			local t = _G['modtool'..i]
			if  columns < 6 then
				t:Disable()
				t:SetAlpha(0)
			elseif columns < 8 then
				if  i < 3 then
					t:Enable()
					t:SetAlpha(1)
				else
					t:Disable()
					t:SetAlpha(0)
				end
			else
				t:Enable()
				t:SetAlpha(1)
			end
		end

		if  f:GetName() == 'modbank' then
			for i = 1, 6 do
				local slot = _G['BankFrameBag'..i]
				slot:ClearAllPoints()

				if  i == 1 then
					slot:SetPoint('TOPLEFT', f, 66, -29)
				else
					slot:SetPoint('LEFT', _G['BankFrameBag'..(i - 1)], 'RIGHT', 3, 0)
				end

				if columns < 8 then
					slot:SetWidth(16)
					slot:SetHeight(14)
					if i == 1 then
						slot:ClearAllPoints()
						slot:SetPoint('TOPLEFT', f, 66, -26)
					elseif i == 4 then
						slot:ClearAllPoints()
						slot:SetPoint('TOPLEFT', _G['BankFrameBag1'], 'BOTTOMLEFT', 0, -3)
					end
				end
			end
		end

		f:SetHeight((row + (col == 0 and 0 or 1))*(size + spacing) + 96)
		f:SetWidth(columns*size + spacing*(columns - 1) - 16)
		f:Show()

		col, row = 0, 0
	end

	local HideArt = function()
		local mbank = _G['modbank']
		if  BankFrame:IsShown() then 
			HideStandardBank() 
		end

		for _, v in pairs(
			{
				BankFrameMoneyFrameInset,
				BankFrameMoneyFrameBorder
			}
		) do
			v:Hide()
		end
	end

	local ReAnchor = function()
		local mbag = _G['modbag']
		buttons = {}

		if  this:GetID() == KEYRING_CONTAINER then
			local n 	= this:GetName()
			local frame = _G[n]
			local id  	= frame:GetID()
			local size 	= GetKeyRingSize()
	
			HideStandardBags(n)

			for i = 1, size do
				local bu = _G[n..'Item'..i]
				GetSlotType(bu, id)
				GetItemType(bu, id)
				table.insert(buttons, bu)
				bu.isKey = true
			end
		end

		for f = 1, GetSlots() do
			local n 	= 'ContainerFrame'..f
			local frame = _G[n]
			local id  	= frame:GetID()

			HideStandardBags(n)

			for i = GetContainerNumSlots(id), 1, -1 do
				local bu = _G[n..'Item'..i]
				local cd = _G[n..'Item'..i..'Cooldown']
				GetSlotType(bu, id)
				GetItemType(bu, id)
				table.insert(buttons, bu)
				-- cd:SetFrameLevel(bu:GetFrameLevel() + 1)
			end
		end

		MoveButtons(buttons, mbag)
		H.ContainerFrame_OnShow()
	end

	local cachedBankWidth, cachedBankHeight
	local ReAnchorBank = function(noMoving)
		local mbank = _G['modbank']
		bankbuttons = {}
		local bagNameCount = 0
		for i = 1, 24 do
			local bu = _G['BankFrameItem'..i]
			table.insert(bankbuttons, bu)
			GetItemType(bu, -1)
		end
		for f = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
			bagNameCount = bagNameCount + 1
			local j 	= GetSlots() + bagNameCount
			local con 	= 'ContainerFrame'..j
			local id  	= _G[con]:GetID()
			if  id ~= KEYRING_CONTAINER then
				 HideStandardBags(con)
				_G[con]:SetScale(1) -- a fix
				for i = GetContainerNumSlots(f), 1, -1  do
					bu = _G[con..'Item'..i]
					GetItemType(bu, id)
					table.insert(bankbuttons, bu)
					bu:Show()
				end
			end
		end

		if not noMoving then
			MoveButtons(bankbuttons, mbank)
			cachedBankWidth  = mbank:GetWidth()
			cachedBankHeight = mbank:GetHeight()
		else
			mbank:SetWidth(cachedBankWidth)
			mbank:SetHeight(cachedBankHeight)
		end

		mbank:Show()
	end

	local HideBank = function()
		local mbank = _G['modbank']
		for i = 1, 24 do
			_G['BankFrameItem'..i]:Hide()
		end
		for i = 5, 11 do CloseBag(i) end
		ReAnchor()
	end

	local CloseBags = function()					-- toggle functions
		local mbag, mbank = _G['modbag'], _G['modbank']
		HideArt()
		for i = 0, 11 do CloseBag(i) end
		local key = IsBagOpen(KEYRING_CONTAINER)
		if  key then
			_G['ContainerFrame'..key]:Hide()
		end
		for _, v in pairs({mbag, mbank}) do v:Hide() end
	end

	local CloseBags2 = function()
		local mbag, mbank = _G['modbag'], _G['modbank']
		H.ContainerFrame_OnHide()
		CloseBankFrame()
		for _, v in pairs({mbag, mbank}) do v:Hide() end
	end

	local OpenBags = function()
		local mbag = _G['modbag']
		HideArt()
		for i = 0, 4 do OpenBag(i) end
		mbag:Show()
		mbag.close:SetScript('OnClick', CloseBags)
	end

	local ToggleBags = function()
		if  IsBagOpen(0) then
			CloseBankFrame()
			CloseBags()
		else OpenBags() end
	end

	local ToggleKeys = function()
		if  not IsBagOpen(KEYRING_CONTAINER) then
			ContainerFrame_GenerateFrame(ContainerFrame_GetOpenFrame(), GetKeyRingSize(), KEYRING_CONTAINER)
			SetButtonPulse(KeyRingButton, 0, 1)
		else
			CloseBag(KEYRING_CONTAINER)
			CloseAllBags()
			OpenBags()
		end
	end

	BankFrame:SetScript('OnShow', function()
		local mbag, mbank = _G['modbag'], _G['modbank']
		for i = 0, 11 do OpenBag(i) end
		for _, v in pairs({mbag, mbank}) do v:Show() end
		SetPortraitTexture(mbank.ButtonTemplate.PortraitFrame.Portrait, 'npc')
		mbag.close:SetScript('OnClick',  ToggleBags)
		mbank.close:SetScript('OnClick', CloseBags)
		PlaySound'igMainMenuOpen'
		ReAnchorBank()
		HideArt()
	end)

	BankFrame.HonHide = BankFrame:GetScript'OnHide'
	BankFrame:SetScript('OnHide', function()
		BankFrame:HonHide()
		HideArt()
		CloseBags()
	end)

	BagSlotButton_OnClick = function()
		local id = this:GetID()
		local hadItem = PutItemInBag(id)
		ToggleBags()
		if not hadItem then return end
	end

	BankFrameItemButtonBag_OnClick = function(bu)
		local  id = this:GetInventorySlot()
		local  hadItem = PutItemInBag(id)
		if not hadItem then return end
	end

	local ContainerUpdate = function(this)
		H.ContainerFrame_Update(this)
		ReAnchor()
		if  BankFrame:IsShown() then
			ReAnchorBank()
		end
	end

	UpdateContainerFrameAnchors = nil

	ContainerFrame_OnShow 		= ReAnchor
	ContainerFrame_OnHide 		= CloseBags2
	ContainerFrame_Update		= ContainerUpdate

	ToggleBackpack 				= ToggleBags
	ToggleBag      				= ToggleBags
	OpenAllBags    				= ToggleBags
	OpenBackpack   				= ToggleBags
	CloseAllBags   				= CloseBags

	ToggleKeyRing				= ToggleKeys

	--
