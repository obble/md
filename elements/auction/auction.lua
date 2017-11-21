
    local H = {}

    H.UseContainerItem = UseContainerItem

    local AuctionSearch = function(link)
        if link and not strfind(link, 'item:') then return end
        local _, item, class, sub, index

        for _, v in pairs({BrowseMinLevel, BrowseMaxLevel}) do
            v:SetText''
        end

        UIDropDownMenu_SetText('', BrowseDropDown)
        UIDropDownMenu_SetSelectedName(BrowseDropDown)

        if  link then
            local _, _, t = strfind(link, '%[(.+)%]')
            BrowseName:SetText(t)
            IsUsableCheckButton:SetChecked(false)

            _, _, item = strfind(link, '(item:%d+:%d+:%d+:%d+)')
            _, _, _, _, class, sub = GetItemInfo(item)
        else
            BrowseName:SetText''
            IsUsableCheckButton:SetChecked(true)
            class = 'Recipe'
            sub   = class
        end

        -- distribute
        AuctionFrameBrowse.selectedClass = class
        for i, v in CLASS_FILTERS do
            if  v == class then
                AuctionFrameBrowse.selectedClassIndex = i
                index = i
                break
            end
        end
        --
        if  class ~= sub then
            AuctionFrameBrowse.selectedSubclass = HIGHLIGHT_FONT_COLOR_CODE..sub..FONT_COLOR_CODE_CLOSE
            for  i, v in {GetAuctionItemSubClasses(index)} do
                if  v == sub then
                    AuctionFrameBrowse.selectedSubclassIndex = i
                    break
                end
            end
        else
            AuctionFrameBrowse.selectedSubclass      = nil
            AuctionFrameBrowse.selectedSubclassIndex = nil
        end
        --
        AuctionFrameBrowse.selectedInvtype      = nil
        AuctionFrameBrowse.selectedInvtypeIndex = nil
        AuctionFrameFilters_Update()
        BrowseSearchButton:Click()
        return 1
    end

    local AddReset = function(a)
        BrowseResetButton = CreateFrame('Button', 'BrowseResetButton', AuctionFrame, 'UIPanelButtonTemplate')
        BrowseResetButton:SetWidth(80) BrowseResetButton:SetHeight(20)
        BrowseResetButton:SetText(RESET)
        BrowseResetButton:SetPoint('BOTTOM', BrowseSearchButton, 'TOP', 0, 2)

        BrowseSearchButton:ClearAllPoints()
        BrowseSearchButton:SetPoint('LEFT', IsUsableCheckButton, 'RIGHT', 10, -7)

        BrowseResetButton:SetScript('OnClick', function()
            for _, v in pairs({BrowseName, BrowseMinLevel, BrowseMaxLevel}) do
                v:SetText''
            end

            IsUsableCheckButton:SetChecked(false)

            UIDropDownMenu_SetSelectedValue(BrowseDropDown, -1)

            AuctionFrameBrowse.selectedClass            = nil
            AuctionFrameBrowse.selectedClassIndex       = nil
            AuctionFrameBrowse.selectedSubclass         = nil
            AuctionFrameBrowse.selectedSubclassIndex    = nil
            AuctionFrameBrowse.selectedInvtype          = nil
            AuctionFrameBrowse.selectedInvtypeIndex     = nil

            AuctionFrameFilters_Update()
        end)
    end

    UseContainerItem = function(bag, slot)
        local link = GetContainerItemLink(bag, slot)
        if  IsShiftKeyDown() and IsAddOnLoaded'Blizzard_AuctionUI' and AuctionFrameBrowse:IsVisible() then
            AuctionSearch(link)
        else
            H.UseContainerItem(bag, slot)
        end
    end

    local e = CreateFrame'Frame'
    e:RegisterEvent'ADDON_LOADED'
    e:SetScript('OnEvent', function()
        if  arg1 == 'Blizzard_AuctionUI' then
            AddReset()
            e:UnregisterAllEvents()
        end
    end)

    --
