

    _G                                      = getfenv(0)

    CHAT_FLAG_AFK                           = 'AFK — '
    CHAT_FLAG_DND                           = 'DND — '
    CHAT_FLAG_GM                            = 'GM — '

    GROUP                                   = 'Gr.'

    MODUI                                   = {}
    MODUI_COLOURELEMENTS_FOR_UI             = {}
    MODUI_COLOURELEMENTS_BORDER_FOR_UI      = {}
    MODUI_PRINT                             = '|cff6ea919modui|cfffed100:|r'

    STANDARD_TEXT_FONT                      = [[Fonts\ARIALN.ttf]]

    gsub                                    = string.gsub

    tlength = function(t)
        local count = 0
        if  t then
            for _ in pairs(t) do count = count + 1 end
        end
        return count
    end

    print = function(m)
        if  (not m) or m == '' then
            DEFAULT_CHAT_FRAME:AddMessage'nil'
        elseif  type(m) == 'table' then
            DEFAULT_CHAT_FRAME:AddMessage'table:'
            for i, v in pairs(m) do
                DEFAULT_CHAT_FRAME:AddMessage('key: '..i)
            end
        else
            DEFAULT_CHAT_FRAME:AddMessage(m)
        end
    end

    SLASH_RELOADUI1 = '/rl'
    SlashCmdList.RELOADUI = ReloadUI

    SLASH_FRAMESTACK1 = '/fs'
    SLASH_FRAMESTACK3 = '/fstack'
    SLASH_FRAMESTACK2 = '/framestack'
    SlashCmdList.FRAMESTACK = function()
        print(GetMouseFocus():GetName())
    end

    --
