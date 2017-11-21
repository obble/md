

    local var   = MODUI_VAR['elements']['hotkeys']
    local H     = {}

    H.ActionButton_UpdateHotkeys = ActionButton_UpdateHotkeys

    local textsubs = {
        ['(s%-)']                               = 's+',
        ['(a%-)']                               = 'a+',
        ['(c%-)']                               = 'c+',
        ['(st%-)']                              = 'c+',
        ['('..KEY_BUTTON3..')']                 = 'm3',
        ['('..gsub(KEY_BUTTON4, '4', '')..')']  = 'm',
        ['('..gsub(KEY_NUMPAD0, '0', '')..')']  = 'nu',
        ['('..KEY_NUMPADDECIMAL..')']           = 'nu.',
        ['('..KEY_NUMPADDIVIDE..')']            = 'nu/',
        ['('..KEY_NUMPADMINUS..')']             = 'nu-',
        ['('..KEY_NUMPADMULTIPLY..')']          = 'nu*',
        ['('..KEY_NUMPADPLUS..')']              = 'nu+',
        ['('..KEY_MOUSEWHEELDOWN..')']          = '▼',
        ['('..KEY_MOUSEWHEELUP..')']            = '▲',
        ['('..KEY_DOWN..')']                    = '▼',
        ['('..KEY_UP..')']                      = '▲',
        ['('..KEY_LEFT..')']                    = '◄',
        ['('..KEY_RIGHT..')']                   = '►',
        ['('..KEY_PAGEDOWN..')']                = 'pg▼',
        ['('..KEY_PAGEUP..')']                  = 'pg▲',
        ['('..KEY_SPACE..')']                   = '_',
        ['('..KEY_INSERT..')']                  = 'ins',
        ['('..KEY_BACKSPACE..')']               = 'bs',
        ['('..KEY_DELETE..')']                  = 'del',
        ['('..KEY_HOME..')']                    = 'hm',
        ['('..KEY_NUMLOCK..')']                 = 'numl',
        ['('..KEY_NUMLOCK_MAC..')']             = 'clr',
        ['('..KEY_ENTER..')']                   = 'ent',
        ['('..KEY_ENTER_MAC..')']               = 'ret',
        ['('..KEY_ESCAPE..')']                  = 'esc',
    }

    local UpdateHotkeys = function(butype)
        H.ActionButton_UpdateHotkeys(butype)
        if  var then
            if not butype then butype = 'ACTIONBUTTON' end
            local hk    = _G[this:GetName()..'HotKey']
            local t     = GetBindingText(GetBindingKey(butype..this:GetID()), 'KEY_', 1)
            if  t == '' then
                hk:Hide()
            else
                for k, v in pairs(textsubs) do t = gsub(t, k, v) end
                hk:SetText(t)
                hk:SetTextHeight(12)
                hk:SetDrawLayer'OVERLAY'
                hk:Show()
            end
        end
    end

    ActionButton_UpdateHotkeys = UpdateHotkeys

    --
