local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local espConnection -- зберігаємо підписку для циклу
local target = nil
local espEnabled = false

return function(isEnabled)
    -- Якщо скрипт вже був активним — відключаємо його
    if espEnabled then
        espEnabled = false

        -- Відключаємо підписку на RenderStepped, якщо вона була активна
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end

        -- Видаляємо всі підсвічування та ніки
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    -- Видаляємо Highlight
                    local highlight = character:FindFirstChild("Highlight")
                    if highlight then
                        highlight:Destroy()
                    end

                    -- Видаляємо BillboardGui
                    local head = character:FindFirstChild("Head")
                    if head then
                        local nameTag = head:FindFirstChild("NameTag")
                        if nameTag then
                            nameTag:Destroy()
                        end
                    end
                end
            end
        end
    end

    if isEnabled then
        -- Активуємо підсвічування
        espEnabled = true

        -- Цикл, який обробляє гравців, додаючи підсвічування та ніки
        espConnection = RunService.RenderStepped:Connect(function()
            -- Перевірка кожного гравця
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local character = player.Character
                    if character then
                        -- Підсвічуємо гравця
                        local highlight = character:FindFirstChild("Highlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.FillColor = Color3.fromRGB(62, 62, 62)
                            highlight.FillTransparency = 0.5
                            highlight.Parent = character
                        end

                        -- Додаємо BillboardGui для показу ніку
                        local head = character:FindFirstChild("Head")
                        if head then
                            local nameTag = head:FindFirstChild("NameTag")
                            if not nameTag then
                                -- Якщо немає, створюємо новий BillboardGui
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
        end)
    end
end
