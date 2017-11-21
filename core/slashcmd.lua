

    if  IsAddOnLoaded'SW_Stats' then
        SLASH_MODPS1 = '/dps'
        SlashCmdList.MODPS = function() SW_ToggleBarFrame() end
    end

    if  IsAddOnLoaded'VanillaGuide' then
        SLASH_MODVG1 = '/vn'
        SlashCmdList.MODVG = function()
            local f     = _G['VG_MainFrame']
        	local fs    = _G['VG_SettingsFrame']
            if f:IsVisible() then
                f:Hide()
        		if  fs:IsVisible() then
        			fs.showthis = true
        			fs:Hide()
        		end
            else
                f:Show()
        		if  fs.showthis then
        			fs:Show()
        		end
            end
        end
    end

    SLASH_RELOADUI1 = '/rl'                             -- DEVTOOLS
    SlashCmdList.RELOADUI = ReloadUI

    SLASH_FRAMESTACK1 = '/fs'
    SLASH_FRAMESTACK3 = '/fstack'
    SLASH_FRAMESTACK2 = '/framestack'
    SlashCmdList.FRAMESTACK = function()
        print(GetMouseFocus():GetName())
    end

   --
