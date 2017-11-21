
    local var   = MODUI_VAR['elements']['cooldown_text']
    local H     = {}

    H.CooldownFrame_SetTimer = CooldownFrame_SetTimer

    local AddTextUpdate = function(elapsed)
        if  this.text and not this.text:IsShown() then return end
        if  this.nextUpdate and this.nextUpdate > 0 then
            this.nextUpdate  =  this.nextUpdate - elapsed
        else
            local remain = this.duration - (GetTime() - this.start)
            if  floor(remain + .5) > 0 then
                local time, nextUpdate = SecondsToTimeAbbrev(remain)
                this.nextUpdate = nextUpdate
                this.text:SetText(time)
                this.text:SetTextColor(1, .8, 0)
            else
                this.text:SetText''
            end
        end
    end

    local AddText = function(f)
        f.text = f:CreateFontString(nil, 'OVERLAY')
        f.text:SetFont(STANDARD_TEXT_FONT, 16, 'OUTLINE')
        f.text:SetPoint('CENTER', 1, -1)
        f.text:SetJustifyH'CENTER'   
        f:SetScript('OnUpdate', AddTextUpdate)
    end

    local SetTimer = function(this, start, duration, enable) 
        H.CooldownFrame_SetTimer(this, start, duration, enable)
        if  var then -- this occasionally fires before PLAYER_LOGIN
            if  this:GetParent():GetWidth() > 27 and start > 0 and duration > 3 then
                this.start      = start
                this.duration   = duration
                this.nextUpdate = 0
                if  not this.text then
                    AddText(this)
                else
                    this.text:Show()
                end
            else
                if this.text then this.text:Hide() end
            end
        else
            if this.text then this.text:Hide() end
        end
    end

    CooldownFrame_SetTimer = SetTimer

    --
