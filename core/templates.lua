

    local path = 'Interface\\AddOns\\md\\art\\templates\\'
    local var  = MODUI_VAR['colour']

    MODUI_ButtonTemplate = function(f, bank)
        f.ButtonTemplate = CreateFrame('Frame', nil, f)
        f.ButtonTemplate:SetAllPoints()
        f.ButtonTemplate:SetFrameLevel(0)
        f.ButtonTemplate:SetFrameStrata'BACKGROUND'

        f.ButtonTemplate.PortraitFrame = CreateFrame('Frame', nil, f.ButtonTemplate)
        f.ButtonTemplate.PortraitFrame:SetWidth(338) 
        f.ButtonTemplate.PortraitFrame:SetHeight(424)

        f.ButtonTemplate.PortraitFrame.BG = f.ButtonTemplate:CreateTexture(nil, 'BACKGROUND')
        f.ButtonTemplate.PortraitFrame.BG:SetTexture(path..'UI-Background-Rock', 1)
        f.ButtonTemplate.PortraitFrame.BG:SetPoint('TOPLEFT', 2, -21)
        f.ButtonTemplate.PortraitFrame.BG:SetPoint('BOTTOMRIGHT', -2, 2)

        f.ButtonTemplate.PortraitFrame.TitleBG =  f.ButtonTemplate:CreateTexture(nil, 'BACKGROUND')
        f.ButtonTemplate.PortraitFrame.TitleBG:SetTexture(path..'_UI-Frame', 1)
        f.ButtonTemplate.PortraitFrame.TitleBG:SetWidth(256) 
        f.ButtonTemplate.PortraitFrame.TitleBG:SetHeight(17)
        f.ButtonTemplate.PortraitFrame.TitleBG:SetPoint('TOPLEFT', 2, -3)
        f.ButtonTemplate.PortraitFrame.TitleBG:SetPoint('TOPRIGHT', -25, -3)
        f.ButtonTemplate.PortraitFrame.TitleBG:SetTexCoord(
            0, 
            1, 
            .28906250, 
            .42187500
        )

        f.ButtonTemplate.PortraitFrame.Portrait =  f.ButtonTemplate:CreateTexture(nil, 'ARTWORK')
        f.ButtonTemplate.PortraitFrame.Portrait:SetWidth(60) 
        f.ButtonTemplate.PortraitFrame.Portrait:SetHeight(60)
        f.ButtonTemplate.PortraitFrame.Portrait:SetPoint('TOPLEFT', -6, 7)
        SetPortraitToTexture(
            f.ButtonTemplate.PortraitFrame.Portrait, 
            [[Interface\ICONS\Inv_misc_bag_21]]
        )

        f.ButtonTemplate.PortraitFrame.PortraitFrame = f.ButtonTemplate:CreateTexture(nil, 'OVERLAY')
        f.ButtonTemplate.PortraitFrame.PortraitFrame:SetTexture(path..'UI-Frame')
        f.ButtonTemplate.PortraitFrame.PortraitFrame:SetWidth(78) 
        f.ButtonTemplate.PortraitFrame.PortraitFrame:SetHeight(78)
        f.ButtonTemplate.PortraitFrame.PortraitFrame:SetPoint('TOPLEFT', -14, 11)
        f.ButtonTemplate.PortraitFrame.PortraitFrame:SetTexCoord(
            .00781250, 
            .61718750, 
            .00781250, 
            .61718750
        )

        f.ButtonTemplate.PortraitFrame.TopRightCorner = f.ButtonTemplate:CreateTexture(nil, 'OVERLAY')
        f.ButtonTemplate.PortraitFrame.TopRightCorner:SetTexture(path..'UI-Frame')
        f.ButtonTemplate.PortraitFrame.TopRightCorner:SetWidth(33) 
        f.ButtonTemplate.PortraitFrame.TopRightCorner:SetHeight(33)
        f.ButtonTemplate.PortraitFrame.TopRightCorner:SetPoint('TOPRIGHT', 0, 1)
        f.ButtonTemplate.PortraitFrame.TopRightCorner:SetTexCoord(
            .63281250, 
            .89062500, 
            .00781250, 
            .26562500
        )

        f.ButtonTemplate.PortraitFrame.TopBorder = f.ButtonTemplate:CreateTexture(nil, 'OVERLAY')
        f.ButtonTemplate.PortraitFrame.TopBorder:SetTexture(path..'_UI-Frame', true)
        f.ButtonTemplate.PortraitFrame.TopBorder:SetWidth(256) 
        f.ButtonTemplate.PortraitFrame.TopBorder:SetHeight(28)
        f.ButtonTemplate.PortraitFrame.TopBorder:SetPoint('TOPLEFT', f.ButtonTemplate.PortraitFrame.PortraitFrame, 'TOPRIGHT', 0, -10)
        f.ButtonTemplate.PortraitFrame.TopBorder:SetPoint('TOPRIGHT', f.ButtonTemplate.PortraitFrame.TopRightCorner, 'TOPLEFT')
        f.ButtonTemplate.PortraitFrame.TopBorder:SetTexCoord(
            0, 
            1, 
            .43750000, 
            .65625000
        )

        f.ButtonTemplate.PortraitFrame.TopTileStreaks = f.ButtonTemplate:CreateTexture(nil, 'BORDER')
        f.ButtonTemplate.PortraitFrame.TopTileStreaks:SetTexture(path..'_UI-Frame', true)
        f.ButtonTemplate.PortraitFrame.TopTileStreaks:SetWidth(256) 
        f.ButtonTemplate.PortraitFrame.TopTileStreaks:SetHeight(37)
        f.ButtonTemplate.PortraitFrame.TopTileStreaks:SetPoint('TOPLEFT', 0, -21)
        f.ButtonTemplate.PortraitFrame.TopTileStreaks:SetPoint('TOPRIGHT', -2, -21)
        f.ButtonTemplate.PortraitFrame.TopTileStreaks:SetAlpha(1)
        f.ButtonTemplate.PortraitFrame.TopTileStreaks:SetTexCoord(
            0, 
            1, 
            .67187500, 
            .96093750
        )

        f.ButtonTemplate.PortraitFrame.BotLeftCorner = f.ButtonTemplate:CreateTexture(nil, 'BORDER')
        f.ButtonTemplate.PortraitFrame.BotLeftCorner:SetTexture(path..'UI-Frame', true)
        f.ButtonTemplate.PortraitFrame.BotLeftCorner:SetWidth(14) 
        f.ButtonTemplate.PortraitFrame.BotLeftCorner:SetHeight(14)
        f.ButtonTemplate.PortraitFrame.BotLeftCorner:SetPoint('BOTTOMLEFT', -6, -5)
        f.ButtonTemplate.PortraitFrame.BotLeftCorner:SetTexCoord(
            .00781250, 
            .11718750, 
            .63281250, 
            .74218750
        )

        f.ButtonTemplate.PortraitFrame.BotRightCorner = f.ButtonTemplate:CreateTexture(nil, 'BORDER')
        f.ButtonTemplate.PortraitFrame.BotRightCorner:SetTexture(path..'UI-Frame', true)
        f.ButtonTemplate.PortraitFrame.BotRightCorner:SetWidth(11) 
        f.ButtonTemplate.PortraitFrame.BotRightCorner:SetHeight(11)
        f.ButtonTemplate.PortraitFrame.BotRightCorner:SetPoint('BOTTOMRIGHT', 0, -5)
        f.ButtonTemplate.PortraitFrame.BotRightCorner:SetTexCoord(
            .13281250, 
            .21875000, 
            .89843750, 
            .98437500
        )   

        f.ButtonTemplate.PortraitFrame.BottomBorder = f.ButtonTemplate:CreateTexture(nil, 'BORDER')
        f.ButtonTemplate.PortraitFrame.BottomBorder:SetTexture(path..'_UI-Frame', true)
        f.ButtonTemplate.PortraitFrame.BottomBorder:SetWidth(256) 
        f.ButtonTemplate.PortraitFrame.BottomBorder:SetHeight(9)
        f.ButtonTemplate.PortraitFrame.BottomBorder:SetPoint('BOTTOMLEFT', f.ButtonTemplate.PortraitFrame.BotLeftCorner, 'BOTTOMRIGHT')
        f.ButtonTemplate.PortraitFrame.BottomBorder:SetPoint('BOTTOMRIGHT', f.ButtonTemplate.PortraitFrame.BotRightCorner, 'BOTTOMLEFT')
        f.ButtonTemplate.PortraitFrame.BottomBorder:SetTexCoord(
            0,
            1,
            .20312500,
            .27343750
        )

        f.ButtonTemplate.PortraitFrame.LeftBorder = f.ButtonTemplate:CreateTexture(nil, 'BORDER')
        f.ButtonTemplate.PortraitFrame.LeftBorder:SetTexture(path..'!UI-Frame', true)
        f.ButtonTemplate.PortraitFrame.LeftBorder:SetWidth(16)
        f.ButtonTemplate.PortraitFrame.LeftBorder:SetHeight(256)
        f.ButtonTemplate.PortraitFrame.LeftBorder:SetPoint('TOPLEFT', f.ButtonTemplate.PortraitFrame.PortraitFrame, 'BOTTOMLEFT', 8, 0)
        f.ButtonTemplate.PortraitFrame.LeftBorder:SetPoint('BOTTOMLEFT', f.ButtonTemplate.PortraitFrame.BotRightCorner, 'TOPLEFT')
        f.ButtonTemplate.PortraitFrame.LeftBorder:SetTexCoord(
            .35937500,
            .60937500,
            0,
            1
        )

        f.ButtonTemplate.PortraitFrame.RightBorder = f.ButtonTemplate:CreateTexture(nil, 'BORDER')
        f.ButtonTemplate.PortraitFrame.RightBorder:SetTexture(path..'!UI-Frame', true)
        f.ButtonTemplate.PortraitFrame.RightBorder:SetWidth(10) 
        f.ButtonTemplate.PortraitFrame.RightBorder:SetHeight(256)
        f.ButtonTemplate.PortraitFrame.RightBorder:SetPoint('TOPRIGHT', f.ButtonTemplate.PortraitFrame.TopRightCorner, 'BOTTOMRIGHT', 1, 0)
        f.ButtonTemplate.PortraitFrame.RightBorder:SetPoint('BOTTOMRIGHT', f.ButtonTemplate.PortraitFrame.BotRightCorner, 'TOPRIGHT')
        f.ButtonTemplate.PortraitFrame.RightBorder:SetTexCoord(
            .17187500,
            .32812500,
            0, 
            1
        )

        f.ButtonTemplate.BtnCornerLeft = f.ButtonTemplate:CreateTexture(nil, 'BACKGROUND')
        f.ButtonTemplate.BtnCornerLeft:SetTexture(path..'UI-Frame')
        f.ButtonTemplate.BtnCornerLeft:SetWidth(12) 
        f.ButtonTemplate.BtnCornerLeft:SetHeight(32)
        f.ButtonTemplate.BtnCornerLeft:SetPoint('BOTTOMLEFT', -2, -1)
        f.ButtonTemplate.BtnCornerLeft:SetTexCoord(
            .89843750,
            .99218750,
            .28125000,
            .53125000
        )

        f.ButtonTemplate.BtnCornerRight = f.ButtonTemplate:CreateTexture(nil, 'BACKGROUND')
        f.ButtonTemplate.BtnCornerRight:SetTexture(path..'UI-Frame')
        f.ButtonTemplate.BtnCornerRight:SetWidth(12) 
        f.ButtonTemplate.BtnCornerRight:SetHeight(32)
        f.ButtonTemplate.BtnCornerRight:SetPoint('BOTTOMRIGHT', 0, -1)
        f.ButtonTemplate.BtnCornerRight:SetTexCoord(
            .13281250,
            .22656250,
            .63281250,
            .88281250
        )

        f.ButtonTemplate.ButtonBottomBorder = f.ButtonTemplate:CreateTexture(nil, 'BACKGROUND')
        f.ButtonTemplate.ButtonBottomBorder:SetTexture(path..'UI-Frame', true)
        f.ButtonTemplate.ButtonBottomBorder:SetWidth(256) 
        f.ButtonTemplate.ButtonBottomBorder:SetHeight(3)
        f.ButtonTemplate.ButtonBottomBorder:SetPoint('BOTTOMLEFT',  f.ButtonTemplate.BtnCornerRight, 'BOTTOMRIGHT', 0, 3)
        f.ButtonTemplate.ButtonBottomBorder:SetPoint('BOTTOMRIGHT', f.ButtonTemplate.BtnCornerRight, 'BOTTOMLEFT')
        f.ButtonTemplate.ButtonBottomBorder:SetTexCoord(
            0, 
            1, 
            .04687500, 
            .07031250
        )

        f.ButtonTemplate.Inset = CreateFrame('Frame', f:GetName()..'ButtonTemplateInset', f.ButtonTemplate)
        f.ButtonTemplate.Inset:SetPoint('TOPLEFT', 4, -60)
        f.ButtonTemplate.Inset:SetPoint('BOTTOMRIGHT', -6, 26)
        f.ButtonTemplate:EnableMouse(false)

        f.ButtonTemplate.Inset.BG = f.ButtonTemplate.Inset:CreateTexture(nil, 'BACKGROUND')
        f.ButtonTemplate.Inset.BG:SetTexture(path..'UI-Background-Marble', true)
        f.ButtonTemplate.Inset.BG:SetPoint('TOPLEFT', f.ButtonTemplate.Inset)
        f.ButtonTemplate.Inset.BG:SetPoint('BOTTOMRIGHT', f.ButtonTemplate.Inset)

        f.ButtonTemplate.Inset.TopLeftCorner = f.ButtonTemplate.Inset:CreateTexture(nil, 'BORDER')
        f.ButtonTemplate.Inset.TopLeftCorner:SetTexture(path..'UI-Frame', true)
        f.ButtonTemplate.Inset.TopLeftCorner:SetWidth(6) 
        f.ButtonTemplate.Inset.TopLeftCorner:SetHeight(6)
        f.ButtonTemplate.Inset.TopLeftCorner:SetPoint('TOPLEFT', f.ButtonTemplate.Inset.BG)
        f.ButtonTemplate.Inset.TopLeftCorner:SetTexCoord(
            .63281250,
            .67968750,
            .54687500,
            .59375000
        )

        f.ButtonTemplate.Inset.TopRightCorner = f.ButtonTemplate.Inset:CreateTexture(nil, 'BORDER')
        f.ButtonTemplate.Inset.TopRightCorner:SetTexture(path..'UI-Frame', true)
        f.ButtonTemplate.Inset.TopRightCorner:SetWidth(6) 
        f.ButtonTemplate.Inset.TopRightCorner:SetHeight(6)
        f.ButtonTemplate.Inset.TopRightCorner:SetPoint('TOPRIGHT', f.ButtonTemplate.Inset.BG)
        f.ButtonTemplate.Inset.TopRightCorner:SetTexCoord(
            .90625000,
            .95312500,
            .21875000,
            .26562500
        )

        f.ButtonTemplate.Inset.BotLeftCorner = f.ButtonTemplate.Inset:CreateTexture(nil, 'BORDER')
        f.ButtonTemplate.Inset.BotLeftCorner:SetTexture(path..'UI-Frame', true)
        f.ButtonTemplate.Inset.BotLeftCorner:SetWidth(6) 
        f.ButtonTemplate.Inset.BotLeftCorner:SetHeight(6)
        f.ButtonTemplate.Inset.BotLeftCorner:SetPoint('BOTTOMLEFT', f.ButtonTemplate.Inset.BG, 0, -1)
        f.ButtonTemplate.Inset.BotLeftCorner:SetTexCoord(
            .69531250,
            .74218750,
            .54687500,
            .59375000
        )

        f.ButtonTemplate.Inset.BotRightCorner = f.ButtonTemplate.Inset:CreateTexture(nil, 'BORDER')
        f.ButtonTemplate.Inset.BotRightCorner:SetTexture(path..'UI-Frame', true)
        f.ButtonTemplate.Inset.BotRightCorner:SetWidth(6) 
        f.ButtonTemplate.Inset.BotRightCorner:SetHeight(6)
        f.ButtonTemplate.Inset.BotRightCorner:SetPoint('BOTTOMRIGHT', f.ButtonTemplate.Inset.BG, 0, -1)
        f.ButtonTemplate.Inset.BotRightCorner:SetTexCoord(
            .75781250,
            .80468750,
            .54687500,
            .59375000
        )

        f.ButtonTemplate.Inset.TopBorder = f.ButtonTemplate.Inset:CreateTexture(nil, 'BACKGROUND')
        f.ButtonTemplate.Inset.TopBorder:SetTexture(path..'_UI-Frame', true)
        f.ButtonTemplate.Inset.TopBorder:SetWidth(256) 
        f.ButtonTemplate.Inset.TopBorder:SetHeight(3)
        f.ButtonTemplate.Inset.TopBorder:SetPoint('TOPLEFT', f.ButtonTemplate.Inset.TopLeftCorner,'TOPRIGHT')
        f.ButtonTemplate.Inset.TopBorder:SetPoint('TOPRIGHT', f.ButtonTemplate.Inset.BorderTopCorner,'TOPLEFT')
        f.ButtonTemplate.Inset.TopBorder:SetTexCoord(
            0,
            1, 
            .08593750, 
            .10937500
        )

        f.ButtonTemplate.Inset.BottomBorder = f.ButtonTemplate.Inset:CreateTexture(nil, 'BACKGROUND')
        f.ButtonTemplate.Inset.BottomBorder:SetTexture(path..'_UI-Frame', true)
        f.ButtonTemplate.Inset.BottomBorder:SetWidth(6) 
        f.ButtonTemplate.Inset.BottomBorder:SetHeight(6)
        f.ButtonTemplate.Inset.BottomBorder:SetPoint('BOTTOMLEFT', f.ButtonTemplate.Inset.BottomLeftCorner,'BOTTOMRIGHT')
        f.ButtonTemplate.Inset.BottomBorder:SetPoint('TOPRIGHT', f.ButtonTemplate.Inset.BottomLeftCorner,'BOTTOMLEFT')
        f.ButtonTemplate.Inset.BottomBorder:SetTexCoord(
            0, 
            1,
            .00781250,
            .03125000
        )

        f.ButtonTemplate.Inset.LeftBorder = f.ButtonTemplate.Inset:CreateTexture(nil, 'BACKGROUND')
        f.ButtonTemplate.Inset.LeftBorder:SetTexture(path..'!UI-Frame', true)
        f.ButtonTemplate.Inset.LeftBorder:SetWidth(3) 
        f.ButtonTemplate.Inset.LeftBorder:SetHeight(256)
        f.ButtonTemplate.Inset.LeftBorder:SetPoint('TOPLEFT', f.ButtonTemplate.Inset.TopLeftCorner,'BOTTOMLEFT')
        f.ButtonTemplate.Inset.LeftBorder:SetPoint('BOTTOMLEFT', f.ButtonTemplate.Inset.BottomLeftCorner,'TOPLEFT')
        f.ButtonTemplate.Inset.LeftBorder:SetTexCoord(
            .09375000,
            .14062500,
            0,
            1
        )

        f.ButtonTemplate.Inset.RightBorder = f.ButtonTemplate.Inset:CreateTexture(nil, 'BACKGROUND')
        f.ButtonTemplate.Inset.RightBorder:SetTexture(path..'!UI-Frame', true)
        f.ButtonTemplate.Inset.RightBorder:SetWidth(3) 
        f.ButtonTemplate.Inset.LeftBorder:SetHeight(256)
        f.ButtonTemplate.Inset.RightBorder:SetPoint('TOPRIGHT', f.ButtonTemplate.Inset.TopRightCorner,'BOTTOMRIGHT')
        f.ButtonTemplate.Inset.RightBorder:SetPoint('BOTTOMRIGHT', f.ButtonTemplate.Inset.BottomRightCorner,'TOPRIGHT')
        f.ButtonTemplate.Inset.RightBorder:SetTexCoord(
            .01562500,
            .06250000,
            0,
            1
        )


        f.ButtonTemplate.Inset.CloseButton = CreateFrame('Button', f:GetName()..'ButtonFrameTemplateCloseButton', f.ButtonTemplate.Inset, 'UIPanelCloseButton')
        f.ButtonTemplate.Inset.CloseButton:SetPoint('TOPRIGHT', f.ButtonTemplate, 4, 5)

        for _, v in pairs(
            {
                f.ButtonTemplate.PortraitFrame.BG,
                f.ButtonTemplate.PortraitFrame.TitleBG,
                f.ButtonTemplate.PortraitFrame.PortraitFrame,
                f.ButtonTemplate.PortraitFrame.TopRightCorner,
                f.ButtonTemplate.PortraitFrame.TopBorder,
                f.ButtonTemplate.PortraitFrame.TopTileStreaks,
                f.ButtonTemplate.PortraitFrame.BotLeftCorner,
                f.ButtonTemplate.PortraitFrame.BotRightCorner,
                f.ButtonTemplate.PortraitFrame.BottomBorder,
                f.ButtonTemplate.PortraitFrame.LeftBorder,
                f.ButtonTemplate.PortraitFrame.RightBorder,
                f.ButtonTemplate.Inset.BG,
                f.ButtonTemplate.Inset.TopLeftCorner,
                f.ButtonTemplate.Inset.TopRightCorner,
                f.ButtonTemplate.Inset.BotLeftCorner,
                f.ButtonTemplate.Inset.BotRightCorner,
                f.ButtonTemplate.Inset.BottomBorder
            }
        ) do
            v:SetVertexColor(
                bank and var.r*1.5 or var.r, 
                bank and var.g*1.5 or var.g, 
                bank and var.b*1.5 or var.b
            )
        end  
    end

    --
