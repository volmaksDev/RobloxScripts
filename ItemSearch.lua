-- ItemSearch.lua

return function(itemNameToFind)
    local Data = require(game.ReplicatedStorage.Modules.Core.Data)
    local Net = require(game.ReplicatedStorage.Modules.Core.Net)

    local itemForLook = tostring(itemNameToFind)

    local found_count = 0
    local total_hand_slots_used = 0
    local max_hand_slots = 0
    local available_hand_slots = 0

    local max_space = Net.get("get_max_inventory_space")
    if max_space then
        max_hand_slots = max_space.hand
    end

    for _, typeGroup in pairs(Data.items or {}) do
        for _, itemList in pairs(typeGroup) do
            for _, item in ipairs(itemList) do
                if item.location == "hand" and (item.amount or 1) > 0 then
                    total_hand_slots_used += 1
                    if item.name == itemForLook then
                        found_count += item.amount or 1
                    end
                end
            end
        end
    end

    available_hand_slots = max_hand_slots - total_hand_slots_used

    --print("🔎 Предмет:", itemForLook)
    --print("📦 У руках:", found_count)
    --print("💼 Використано слотів:", total_hand_slots_used)
    --print("🟢 Вільно слотів:", available_hand_slots)

    return {
        item = itemForLook,
        amount = found_count,
        slots_used = total_hand_slots_used,
        max_slots = max_hand_slots,
        available_slots = available_hand_slots
    }
end
