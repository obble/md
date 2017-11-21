

    local H = {}

    H.Minimap_Update = Minimap_Update

    local OnMouseWheel = function()
        if not arg1 then return end
        if  arg1 > 0   and  Minimap:GetZoom() < 5 then
            Minimap:SetZoom(Minimap:GetZoom() + 1)
        elseif arg1 < 0 and Minimap:GetZoom() > 0 then
            Minimap:SetZoom(Minimap:GetZoom() - 1)
        end
    end

    local Update = function()
        H.Minimap_Update()
		if  MinimapZoneText:GetStringWidth() > 128 then
			local t = gsub(GetMinimapZoneText(), '(%u)%S* %l*%s*', '%1. ')
			MinimapZoneText:SetText(t)
			if  MinimapZoneText:GetStringWidth() > 115 then
				t =   gsub(GetMinimapZoneText(), '(%a)([%w_\']*)', '%1.')
				MinimapZoneText:SetText(t)
			end
		end
	end

    local PLAYER_LOGIN = function()
        local f = CreateFrame('Frame', nil, Minimap)
        f:EnableMouse(false)
        f:SetPoint('TOPLEFT', Minimap)
        f:SetPoint('BOTTOMRIGHT', Minimap)
        f:EnableMouseWheel(true)
        f:SetScript('OnMouseWheel', OnMouseWheel)

        MiniMapTrackingFrame:SetFrameStrata'MEDIUM'
        MiniMapTrackingFrame:ClearAllPoints()
        MiniMapTrackingFrame:SetPoint('TOP', -64, 4)

        GameTimeFrame:SetScale(.76)
        GameTimeFrame:ClearAllPoints() 
        GameTimeFrame:SetPoint('BOTTOM', 84, 24)

        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint('TOPRIGHT', 7, -20)

        MinimapZoneText:ClearAllPoints()
        MinimapZoneText:SetPoint('TOP', Minimap, 0, 17)

        Update()

        for _, v in pairs(
            {
                MinimapBorderTop,
                MinimapToggleButton,
                MinimapZoomIn,
        	    MinimapZoomOut
            }
        ) do
            v:Hide()
        end
    end

    Minimap_Update = Update

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', PLAYER_LOGIN)

    --
