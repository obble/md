

    MOD_GetSlots = function()
        local i = 0
        for bag = 0, NUM_BAG_SLOTS do
            for slot = 1, GetContainerNumSlots(bag) do
                local  link = GetContainerItemLink(bag, slot)
                if not link then i = i + 1 end
            end
        end
        return i
    end

    MOD_GetMaxSlots = function()
        local i = 0
        for bag = 0, NUM_BAG_SLOTS do
            for  slot = 1, GetContainerNumSlots(bag) do
                i = i + 1
            end
        end
        return i
    end

    MOD_GetBankSlots = function()
        local  i = 0
        for j = 1, 28 do
            local  id   = BankButtonIDToInvSlotID(j)
            local  link = GetInventoryItemLink('player', id)
            if not link then i = i + 1 end
        end
        for bag = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
            for slot = 1, GetContainerNumSlots(bag) do
                local  link = GetContainerItemLink(bag, slot)
                if not link then i = i + 1 end
            end
        end
        return i
    end

    MOD_GetBankMaxSlots = function()
        local  i = 28   --  account for standard bank slots
        for bag = NUM_BAG_SLOTS + 1, NUM_BAG_SLOTS + NUM_BANKBAGSLOTS do
            for  slot = 1, GetContainerNumSlots(bag) do
                i = i + 1
            end
        end
        return i
    end

   --
