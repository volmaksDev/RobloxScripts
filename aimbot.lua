local isAimbotActive = false  -- Змінна для перевірки, чи активований аімбот

return function(isEnabled)
    -- // Friend Ignore added

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local Camera = workspace.CurrentCamera
    local RunService = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local ExistingUI = LocalPlayer.PlayerGui:FindFirstChild("UserInput")

    if ExistingUI then
        ExistingUI:Destroy()
    end

    if isEnabled == true and not isAimbotActive then
        -- Якщо аімбот не активний, активуємо його
        isAimbotActive = true

        -- UI – crosshair circle
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = PlayerGui
        ScreenGui.Name = "UserInput"

        local CircleFrame = Instance.new("Frame")
        CircleFrame.Size = UDim2.new(0, 100, 0, 100)
        CircleFrame.Position = UDim2.new(0.5, -50, 0.5, -50)
        CircleFrame.BackgroundTransparency = 1
        CircleFrame.Parent = ScreenGui

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = CircleFrame

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Thickness = 2
        UIStroke.Color = Color3.fromRGB(255, 0, 0)
        UIStroke.Parent = CircleFrame

        local target = nil
        local isAimbotActive = true

        -- Find valid target (not a friend)
        local function findTarget()
            local origin = Camera.CFrame.Position
            local direction = Camera.CFrame.LookVector * 1000

            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

            local result = workspace:Raycast(origin, direction, raycastParams)

            if result then
                local hitPart = result.Instance
                local model = hitPart:FindFirstAncestorOfClass("Model")

                if model and model ~= LocalPlayer.Character then
                    local humanoid = model:FindFirstChildOfClass("Humanoid")
                    local head = model:FindFirstChild("Head")
                    local player = Players:GetPlayerFromCharacter(model)

                    if humanoid and head and humanoid.Health > 10 and player then
                        if not LocalPlayer:IsFriendsWith(player.UserId) then
                            return {Head = head, Humanoid = humanoid, Name = model.Name}
                        else
                            print("❌ Ignoring friend: " .. player.Name)
                        end
                    end
                end
            end

            return nil
        end

        -- Toggle aim with middle mouse button
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if input.UserInputType == Enum.UserInputType.MouseButton3 and not gameProcessed then
                if isEnabled then
                    if isAimbotActive then
                        target = nil
                    else
                        print("Aimbot: Active")
                    end
                end
            end
        end)

        -- Auto-aim loop
        RunService.RenderStepped:Connect(function()
            if not aimEnabled or not isEnabled then return end

            if target then
                if target.Humanoid and target.Humanoid.Health > 10 then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Head.Position)
                else
                    print("⚠️ Target lost: " .. target.Name)
                    target = nil
                end
            else
                local newTarget = findTarget()
                if newTarget then
                    target = newTarget
                    print("🎯 New target acquired: " .. target.Name)
                end
            end
        end)
    else
        if ExistingUI then
            ExistingUI:Destroy()
        end

        -- Якщо aimbot вимкнений, змінюємо стан на "не активний"
        isAimbotActive = false
    end
end
