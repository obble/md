
    local f = CreateFrame'Frame'
    local OnUpdate = function()
        if  _G['VG_MainFrame'] then
            local m = _G['VG_MainFrame']
            m:SetBackdrop(nil)
            for _,  v in pairs({m:GetChildren()}) do
                if  v:GetBackdrop() then
                    v:SetBackdrop(nil)
                end
            end
            f:SetScript('OnUpdate', nil)
        end
    end

    f:SetScript('OnUpdate', OnUpdate)

    --
