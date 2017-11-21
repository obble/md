

    local var = MODUI_VAR['elements']['bu_skin']
    local H = {}

    H.BuffButton_Update = BuffButton_Update

    local OnEvent = function()
        for i = 0, 23 do
            local bu = _G['BuffButton'..i]
            local du = _G['BuffButton'..i..'Duration']

            MODUI_BU(bu, 0)
            MODUI_BUBorder(bu)
            MODUI_BUElements(bu)

            du:ClearAllPoints() 
            du:SetPoint('CENTER', bu, 'BOTTOM', -1, -9)
            du:SetJustifyH'CENTER'

            if  i < 17 then
                --bu:ClearAllPoints()
                --bu:SetPoint('RIGHT', _G['BuffButton'..i - 1], 'LEFT', -7, 0)
            end
        end

        for i = 1, 2 do
            local bu = _G['TempEnchant'..i]
            local bo = _G['TempEnchant'..i..'Border']
            local du = _G['TempEnchant'..i..'Duration']

            MODUI_BU(bu, 0)
            MODUI_BUBorder(bu)
            MODUI_BUElements(bu)

            bo:SetTexture''

            du:ClearAllPoints() 
            du:SetPoint('CENTER', bu, 'BOTTOM', -1, -9)
            du:SetJustifyH'CENTER'
        end
    end

    local Update = function()
        H.BuffButton_Update()
        local n = this:GetName()
        local d = _G[n..'Border']
        if  this.bo then 
            this.bo:SetBackdropBorderColor(0, 0, 0, 0)
            if  var.enable then
                modSkinColor(this, var.r, var.g, var.b)
            end
        end
        if  d then
            local r, g, b = d:GetVertexColor()
            if  this.bo then
                this.bo:SetBackdropBorderColor(r*1.5, g*1.5, b*1.5, 1)
                if  var.enable then
                    modSkinColor(this, r*1.5, g*1.5, b*1.5, 1)
                end
                d:SetAlpha(0)
            end
        end
    end


    local UpdatePositions = function()
        if  SHOW_BUFF_DURATIONS == '1' then
            BuffButton8:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, -25)
            BuffButton16:SetPoint('TOPRIGHT', TemporaryEnchantFrame, "TOPRIGHT", 0, -120)
        else
            BuffButton8:SetPoint('TOP', TempEnchant1, 'BOTTOM', 0, -5)
            BuffButton16:SetPoint('TOPRIGHT', TemporaryEnchantFrame, 0, -70)
        end
    end

    BuffButton_Update           = Update
    BuffButtons_UpdatePositions = UpdatePositions

    local e = CreateFrame'Frame'
    e:RegisterEvent'PLAYER_LOGIN'
    e:SetScript('OnEvent', OnEvent)

    --
