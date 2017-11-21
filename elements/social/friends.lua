
    local H = {}

    H.FriendsList_Update = FriendsList_Update

    local Update = function()
        H.FriendsList_Update()
        for i = 1, FRIENDS_TO_DISPLAY do
            local index                                         = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame) + i
            local name, level, class, area, connected, status   = GetFriendInfo(index)
            if  connected then
                local text = _G['FriendsFrameFriendButton'..i..'ButtonTextNameLocation']
                local info = _G['FriendsFrameFriendButton'..i..'ButtonTextInfo']
                if  string.find(status, '(.+) —') then
                    status = gsub(status, '(.+) —', '— %1')
                end
                if  class then
                    local colour = RAID_CLASS_COLORS[strupper(class)]
                    if  colour then
                        class = '|c'..colour.colourStr..class..'|r'
                    end
                end
                text:SetText(format(TEXT(FRIENDS_LIST_TEMPLATE), name, area, status))
                info:SetText(format(TEXT(FRIENDS_LEVEL_TEMPLATE), level, class))
            end
        end
    end

    FriendsList_Update = Update

    --
