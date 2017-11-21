


    --[[
        api
            modSkin(frame, padding)                         create border
            modSkinHide(frame)                              hide   border
            modSkinShow(frame)                              show   border
            modSkinDraw(frame, drawlayer, subdrawlayer)     set border draw layer
            modSkinColor(frame, r, g, b, a)                 colour border
            modSkinned(frame)                               true if frame has a border, false if not

            texturetable, colour = modSkinInfo(frame)       arg1: table containing eight textures for border
                                                            arg2: table with r,g,b border colour values
    ]]

    local var       = MODUI_VAR['elements']['bu_skin']
    local sections  = {
        'TOPLEFT', 'TOPRIGHT',  'BOTTOMLEFT',   'BOTTOMRIGHT',
        'TOP',      'BOTTOM',   'LEFT',         'RIGHT'
    }

    modSkinned = function(f)
        return f.borderTextures and true or false
    end

    modSkinInfo = function(f)
        return f.borderTextures, f.GetBorderColor
    end

    modSkinPadding = function(f, uL1, uL2, uR1, uR2, bL1, bL2, bR1, bR2)
        -- deprecated
    end

    modSkinColor = function(f, r, g, b, a)
        local   t = f.borderTextures
        if not  t then return end
        for  _, v in pairs(t) do
            v:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
        end
    end

    modSkinDraw = function(f, layer, sublayer)
        local   t = f.borderTextures
        if not  t then return end
        for  _, v in pairs(t) do
            v:SetDrawLayer(layer or 'OVERLAY', sublayer or 0)
        end
    end

    modSkinHide = function(f)
        local   t = f.borderTextures
        if not  t then return end
        for  _, v in pairs(t) do v:Hide() end
    end

    modSkinShow = function(f)
        local   t = f.borderTextures
        if not  t then return end
        for  _, v in pairs(t) do v:Show() end
    end

    local GetBorderColor = function()
        local red, green, blue  = this.TOPLEFT:GetVertexColor()
        local  c                = {r = red, g = green, b = blue}
        return c
    end

    modSkin = function(f, offset)
        if not var.enable or type(f) ~= 'table' or not f.CreateTexture or f.borderTextures then return end

        local t = {}
        offset = offset or 0

        for i = 1, 8 do
            local section = sections[i]
            local x = f:CreateTexture(nil, 'OVERLAY', nil, 1)
            x:SetTexture('Interface\\AddOns\\md\\art\\borders\\border-'..section..'.tga')
            t[sections[i]] = x
        end

        t.TOPLEFT:SetWidth(8)       t.TOPLEFT:SetHeight(8)
        t.TOPLEFT:SetPoint('BOTTOMRIGHT', f, 'TOPLEFT', 4 + offset, -4 - offset)

        t.TOPRIGHT:SetWidth(8)      t.TOPRIGHT:SetHeight(8)
        t.TOPRIGHT:SetPoint('BOTTOMLEFT', f, 'TOPRIGHT', -4 - offset, -4 - offset)

        t.BOTTOMLEFT:SetWidth(8)    t.BOTTOMLEFT:SetHeight(8)
        t.BOTTOMLEFT:SetPoint('TOPRIGHT', f, 'BOTTOMLEFT', 4 + offset, 4 + offset)

        t.BOTTOMRIGHT:SetWidth(8)   t.BOTTOMRIGHT:SetHeight(8)
        t.BOTTOMRIGHT:SetPoint('TOPLEFT', f, 'BOTTOMRIGHT', -4 - offset, 4 + offset)

        t.TOP:SetHeight(8)
        t.TOP:SetPoint('TOPLEFT', t.TOPLEFT, 'TOPRIGHT', 0, 0)
        t.TOP:SetPoint('TOPRIGHT', t.TOPRIGHT, 'TOPLEFT', 0, 0)

        t.BOTTOM:SetHeight(8)
        t.BOTTOM:SetPoint('BOTTOMLEFT', t.BOTTOMLEFT, 'BOTTOMRIGHT', 0, 0)
        t.BOTTOM:SetPoint('BOTTOMRIGHT', t.BOTTOMRIGHT, 'BOTTOMLEFT', 0, 0)

        t.LEFT:SetWidth(8)
        t.LEFT:SetPoint('TOPLEFT', t.TOPLEFT, 'BOTTOMLEFT', 0, 0)
        t.LEFT:SetPoint('BOTTOMLEFT', t.BOTTOMLEFT, 'TOPLEFT', 0, 0)

        t.RIGHT:SetWidth(8)
        t.RIGHT:SetPoint('TOPRIGHT', t.TOPRIGHT, 'BOTTOMRIGHT', 0, 0)
        t.RIGHT:SetPoint('BOTTOMRIGHT', t.BOTTOMRIGHT, 'TOPRIGHT', 0, 0)

        f.borderTextures = t
        f.SetBorderColor = SetBorderColor
        f.GetBorderColor = GetBorderColor
    end

    --
