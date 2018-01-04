

    MODUI_CARRIERS  = {}

    local events    = {
        ['PLAYER_ENTERING_WORLD']       = true,
        ['ZONE_CHANGED_NEW_AREA']       = true,
        ['CHAT_MSG_BG_SYSTEM_ALLIANCE'] = false,
        ['CHAT_MSG_BG_SYSTEM_HORDE']    = false,
    }

    local banner    = {
        ['Interface\\Icons\\INV_BannerPVP_01'] = {'Horde'},
        ['Interface\Icons\INV_BannerPVP_02']   = {'Alliance'},
    }

    local CheckRaidBuffs = function()
        if  UnitInRaid'player' then
            for i = 1, GetNumRaidMembers() do
                local unit = 'raid'..i
                if UnitExists(unit) then
                    for j = 1, 40 do
                        local name = UnitBuff(unit, j)
                        if  name and banner[name] then
                            MODUI_CARRIERS[banner[name]] = string.lower(UnitName(unit))
                            break
                        elseif  not name then
                            break
                        end
                    end
                end
            end
        end
    end

    local OnEvent = function()
        if  events[event] then
            MODUI_CARRIERS = {}
            CheckRaidBuffs()
        else
            local pick 	= 'The (.+) (.+) was picked up by (.+)!'
            local drop 	= 'The (.+) (.+) was dropped by (.+)!'
            local cap   = 'captured the (.+) (.+)!'

            if  string.find(arg1, pick) then
                local flag              = gsub(arg1, pick, '%1')
                local name              = gsub(arg1, pick, '%3')
                MODUI_CARRIERS[flag]    = string.lower(name) --  better for matches
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
