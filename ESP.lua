local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

return function(isEnabled)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                -- Якщо isEnabled = false, видаляємо Highlight та BillboardGui
                if isEnabled == false then  
                    local head = character:FindFirstChild("Head")
                    if head then
                        local billboardGui = head:FindFirstChild("NameTag")
                        if billboardGui then
                            billboardGui:Destroy()
                        end
                    end

                    local highlight = character:FindFirstChild("Highlight")
                    if highlight then
                        highlight:Destroy()
                    end
                end

                -- Якщо isEnabled = true, створюємо Highlight та BillboardGui
                if isEnabled == true then
                    -- Створити Highlight
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(62, 62, 62)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = character

                    -- Додати BillboardGui з ім'ям
                    local head = character:FindFirstChild("Head")
                    if head then
                        -- Видалити попередні BillboardGui (якщо є)
                        for _, child in ipairs(head:GetChildren()) do
                            if child:IsA("BillboardGui") and child.Name == "NameTag" then
                                child:Destroy()
                            end
                        end

                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "NameTag"
                        billboard.Adornee = head
                        billboard.Size = UDim2.new(0, 200, 0, 50)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = head

                        local textLabel = Instance.new("TextLabel")
                        textLabel.Size = UDim2.new(1, 0, 1, 0)
                        textLabel.BackgroundTransparency = 1
                        textLabel.Text = player.Name
                        textLabel.TextColor3 = Color3.new(1, 1, 1)
                        textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                        textLabel.TextStrokeTransparency = 0.5
                        textLabel.TextScaled = true
                        textLabel.Font = Enum.Font.SourceSansBold
                        textLabel.Parent = billboard
                    end
                end
            end
        end
    end
end
