
	local H 	= {}

	H.MerchantFrame_OnShow = MerchantFrame_OnShow
	H.MerchantFrame_OnHide = MerchantFrame_OnHide

	local OnEnter = function()
		GameTooltip:SetOwner(this, 'ANCHOR_CURSOR')
 		GameTooltip:SetText'Clear Your bags of the stuff you don\'t need. All grey items will be sold.'
		GameTooltip:Show()
	end

	local OnLeave = function() 
		GameTooltip:Hide() 
	end

	local OnUpdate = function()
        this.last = this.last + arg1
        if this.last > .05 then
            local i = table.getn(this.junk)
            if  i > 0 then
                UseContainerItem(this.junk[i][1], this.junk[i][2])
                print('|cff4c8d00-|r'..GetContainerItemLink(this.junk[i][1], this.junk[i][2]))
                table.remove(this.junk, i)
            else
                this:SetScript('OnUpdate', nil)
                print'|cff4c8d00All trash items have been sold.|r'
            end
        end
    end

	local OnClick = function()
		this.junk = {}
        for bag = 0, 4 do
            for slot = 0, GetContainerNumSlots(bag) do
                local link = GetContainerItemLink(bag, slot)
                if  link then
                    local _, _, istring = string.find(link, '|H(.+)|h')
                    local _, _, q = GetItemInfo(istring)
                    if q == 0 then table.insert(this.junk, {bag, slot}) end
                end
            end
        end
        print'|cff4c8d00Selling poor quality or trash items.|r'
        this:SetScript('OnUpdate', OnUpdate)
	end

	local OnEvent = function()
		local bag 	= _G['modbag']
		
		local bu = CreateFrame('Button', 'modbag_sellgreys', bag, 'ActionButtonTemplate')
		MODUI_BU(bu)
		bu:SetWidth(25)
		bu:SetHeight(25)
		bu:SetPoint('TOPRIGHT', MerchantFrame, -50, -44)
		bu:SetFrameStrata'HIGH'
		bu:SetNormalTexture''
		bu:Hide()

		bu.t = bu:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		bu.t:SetFont(STANDARD_TEXT_FONT, 12)
		bu.t:SetPoint('RIGHT', bu, 'LEFT', -4, 1)
		bu.t:SetTextColor(1, .7, 0)
		bu.t:SetText'Sell All Trash Items'

		bu.i = bu:CreateTexture(nil, 'ARTWORK')
		bu.i:SetAllPoints()
		bu.i:SetTexture[[Interface\ICONS\inv_ore_tin_01]]
		bu.i:SetTexCoord(.1, .9, .1, .9)


		bu:SetScript('OnEnter', OnEnter)
		bu:SetScript('OnLeave', OnLeave)
		bu:SetScript('OnClick', OnClick)

		bu.last = 0
	end

	local OnShow = function()
		H.MerchantFrame_OnShow()
		_G['modbag_sellgreys']:Show()
	end

	local OnHide = function()
		H.MerchantFrame_OnHide()
		_G['modbag_sellgreys']:Hide()
		CloseAllBags()
	end

	MerchantFrame_OnShow = OnShow
	MerchantFrame_OnHide = OnHide

	local e = CreateFrame'Frame'
	e:RegisterEvent'PLAYER_LOGIN'
	e:SetScript('OnEvent', OnEvent)

	--
