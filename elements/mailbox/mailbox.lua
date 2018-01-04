
    
    local H = {}

    H.OpenMailFrame.Show = OpenMailFrame.Show

    local OnShow = function()
        if  not IsShiftKeyDown() then return end
        if  OpenMailMoneyButton:IsVisible() then 
            OpenMailMoneyButton:Click()    
        end
        if  OpenMailPackageButton:IsVisible() then 
            OpenMailPackageButton:Click()
        end
    end

    OpenMailFrame:SetScript('OnShow', OnShow)


    --
