
    local H = {}

    H.ActionButton_UpdateUsable = ActionButton_UpdateUsable
    H.ActionButton_OnUpdate     = ActionButton_OnUpdate

    local UpdateUsable = function()
        local id = ActionButton_GetPagedID(this)
        local usable, nomana = IsUsableAction(id)
        if  usable then
          local icon = _G[this:GetName()..'Icon']
          if  nomana then
              icon:SetVertexColor(.5, .5,  1)
          elseif IsActionInRange(id) == 0 then
              icon:SetVertexColor(.4, .4, .4)
          else
              icon:SetVertexColor(1, 1, 1)
          end
       else
          H.ActionButton_UpdateUsable()
       end
    end

    local OnUpdate = function(elapsed)
        H.ActionButton_OnUpdate(elapsed)
        ActionButton_UpdateUsable()
    end

    ActionButton_UpdateUsable = UpdateUsable
    ActionButton_OnUpdate     = OnUpdate


    --
