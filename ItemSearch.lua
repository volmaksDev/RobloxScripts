return function(item)
    local Data = require(game.ReplicatedStorage.Modules.Core.Data)
    local Net = require(game.ReplicatedStorage.Modules.Core.Net)

    local itemForLook = tostring(item)

    local total_hand_items = 0
    local max_hand_slots = 0
    local available_hand_slots = 0 
    local found_count = 0

    local max_space = Net.get("get_max_inventory_space")
    if max_space then
        max_hand_slots = max_space.hand
    end

    for _, typeGroup in pairs(Data.items or {}) do
        for _, itemList in pairs(typeGroup) do
            for _, item in ipairs(itemList) do
                if item.location == "hand" then
                    total_hand_items += 1
                    if item.name == itemForLook then
                        found_count += item.amount or 1
                    end
                end
            end
        end
    end

    available_hand_slots = max_hand_slots - total_hand_items

    print("Предмет:", itemForLook)
    print("Кількість в руках:", found_count)
    print("Всього предметів в руках:", total_hand_items)
    print("Доступні слоти:", available_hand_slots)
end
