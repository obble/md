

    MODUI_CARRIERS  = {}

    local events    = {
        ['PLAYER_ENTERING_WORLD']       = true,
        ['ZONE_CHANGED_NEW_AREA']       = true,
        ['CHAT_MSG_BG_SYSTEM_ALLIANCE'] = false,
        ['CHAT_MSG_BG_SYSTEM_HORDE']    = false,
    }

    local OnEvent = function()
        if  events[event] then
            MODUI_CARRIERS = {}
        else
            local pick 	= 'The (.+) (.+) was picked up by (.+)!'
            local drop 	= 'The (.+) (.+) was dropped by (.+)!'
            local cap   = 'captured the (.+) (.+)!'

            if  string.find(arg1, pick) then
                local flag              = gsub(arg1, pick, '%1')
                local name              = gsub(arg1, pick, '%3')
                MODUI_CARRIERS[flag]    = name
            end

            if  string.find(arg1, drop) then
                local flag = gsub(arg1, drop, '%1')
                MODUI_CARRIERS[flag] = nil
            end

            if  string.find(arg1, cap)  then
                MODUI_CARRIERS = {}
            end
        end
    end

    local  e = CreateFrame'Frame'
    for k, v in pairs(events) do e:RegisterEvent(k) end
    e:SetScript('OnEvent', OnEvent)

   --
