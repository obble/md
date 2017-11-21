

	local bongos 	= IsAddOnLoaded'Bongos_ActionBar'
	local H 	 	= {}
	local time   	= nil
	local var		= MODUI_VAR['elements']['keypress']

	H.ActionButton_OnUpdate      	= ActionButton_OnUpdate
	H.PetActionBarFrame_OnUpdate 	= PetActionBarFrame_OnUpdate
	H.ShapeshiftBar_UpdateState		= ShapeshiftBar_UpdateState
	H.ActionButtonDown				= ActionButtonDown
	H.ActionButtonUp				= ActionButtonUp
	H.MultiActionButtonDown			= MultiActionButtonDown
	H.MultiActionButtonUp			= MultiActionButtonUp

	local AddSelfCast = function()
		if  var.self then
			return IsAltKeyDown()
		else
			return 0
		end
	end

	local AddBorderColour = function(nutime)
		if  this:GetChecked() then
			this.checked = true
			modSkinColor(this, 255/255, 240/255, 0/255)
		end
		if this.keypress and modSkinned(this) then
			local i = (nutime - this.keypress)*5
			modSkinColor(this, .3*i, .3*i, .3*i)
		end
		if this.checked and not this:GetChecked() then
			modSkinColor(this, .7, .7, .7)
			this.checked = nil
		end
		if this.keypress and nutime > (this.keypress + .4) then
			modSkinColor(this, .7, .7, .7)
			this.keypress = nil
		end
	end

	local AddPetBorderColour = function()
		for i = 1, 10 do
			local bu = _G['PetActionButton'..i]
			local _, _, _, _, active = GetPetActionInfo(i)
			if  active then
				modSkinColor(bu, 255/255, 240/255, 0/255)
			else
				modSkinColor(bu, .7, .7, .7)
			end
		end
	end

	local OnUpdate = function(elapsed)
		H.ActionButton_OnUpdate(elapsed)
		AddBorderColour(GetTime())
	end

	local PetOnUpdate = function(elapsed)
		H.PetActionBarFrame_OnUpdate(elapsed)
		AddPetBorderColour()
	end

	local UpdateState = function()
		H.ShapeshiftBar_UpdateState()
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			local _, _, active = GetShapeshiftFormInfo(i)
			local bu = _G['ShapeshiftButton'..i]
			if  active then
				modSkinColor(bu, 255/255, 240/255, 0/255)
			else
				modSkinColor(bu, .7, .7, .7)
			end
		end
	end

	local ButtonDown = function(i)
		if  not var.down then
			H.ActionButtonDown(i)
		else
			local time = GetTime()
			if bongos then
				local bu = _G['BActionButton'..i]
				local id = BActionButton.GetPagedID(i)
				if bu and bu:GetButtonState() == 'NORMAL' then bu:SetButtonState'PUSHED' end
				UseAction(id, 0)
				bu.keypress = time
			else
				if BonusActionBarFrame:IsShown() then
					local bu = _G['BonusActionButton'..i]
					if  bu:GetButtonState() == 'NORMAL' then
						bu:SetButtonState'PUSHED'
						UseAction(ActionButton_GetPagedID(bu), 0, AddSelfCast())
						bu.keypress = time
					end
					return
				end
				local bu = _G['ActionButton'..i]
				if  bu:GetButtonState() == 'NORMAL' then
					bu:SetButtonState'PUSHED'
					UseAction(ActionButton_GetPagedID(bu), 0, AddSelfCast())
					bu.keypress = time
				end
			end
		end
	end

	local ButtonUp = function(i, onSelf)
		if  not var.down then
			H.ActionButtonUp(i, onSelf)
			local time = GetTime()
			if  bongos then
				local bu = _G['BActionButton'..i]
				bu.keypress = time
			else
				if  BonusActionBarFrame:IsShown() then
					local bu = _G['BonusActionButton'..i]
					bu.keypress = time
					return
				end
				local bu = _G['ActionButton'..i]
				bu.keypress = time
			end
		else
			if  bongos then
				local bu = _G['BActionButton'..i]
				if  bu and bu:GetButtonState() == 'PUSHED' then
					bu:SetButtonState'NORMAL'
					if MacroFrame_SaveMacro then MacroFrame_SaveMacro() end
					bu:SetChecked(IsCurrentAction(BActionButton.GetPagedID(i)))
				end
			else
				if  BonusActionBarFrame:IsShown() then
					local bu = _G['BonusActionButton'..i]
					if  bu:GetButtonState() == 'PUSHED' then
						bu:SetButtonState'NORMAL'
						if MacroFrame_SaveMacro then MacroFrame_SaveMacro() end
						if IsCurrentAction(ActionButton_GetPagedID(bu)) then bu:SetChecked(1)
						else bu:SetChecked(0) end
					end
					return
				end

				local bu = _G['ActionButton'..i]
				if bu and bu:GetButtonState() == 'PUSHED' then
					bu:SetButtonState'NORMAL'
					if MacroFrame_SaveMacro then MacroFrame_SaveMacro() end
					if IsCurrentAction(ActionButton_GetPagedID(bu)) then bu:SetChecked(1)
					else bu:SetChecked(0)
					end
				end
			end
		end
	end

	local MultiButtonDown = function(bar, i)
		if  not var.down then
			H.MultiActionButtonDown(bar, i)
		else
			local time = GetTime()
			local bu = _G[bar..'Button'..i]
			if  bu:GetButtonState() == 'NORMAL' then
				bu:SetButtonState'PUSHED'
				UseAction(ActionButton_GetPagedID(bu), 0, AddSelfCast())
				bu.keypress = time
			end
		end
	end

	local MultiButtonUp = function(bar, i, onSelf)
		if  not var.down then
			local time = GetTime()
			local bu = _G[bar..'Button'..i]
			H.MultiActionButtonUp(bar, i, onSelf)
			bu.keypress = time
		else
			local bu = _G[bar..'Button'..i]
			if  bu:GetButtonState() == 'PUSHED' then
				bu:SetButtonState'NORMAL'
				if MacroFrame_SaveMacro then MacroFrame_SaveMacro() end
				if IsCurrentAction(ActionButton_GetPagedID(bu)) then bu:SetChecked(1)
				else bu:SetChecked(0)
				end
			end
		end
	end

	ActionButton_OnUpdate 		= OnUpdate
	PetActionBarFrame_OnUpdate 	= PetOnUpdate
	ShapeshiftBar_UpdateState 	= UpdateState
	ActionButtonDown 			= ButtonDown
	ActionButtonUp 				= ButtonUp
	MultiActionButtonDown		= MultiButtonDown
	MultiActionButtonUp			= MultiButtonUp

	--
