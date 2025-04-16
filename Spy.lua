local connection
local hasShownOwnedHomes = false
local previousAttributes = {}
local targetNickname = nil
local spyGui

return function(isEnabled)
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local originalCameraSubject = Camera.CameraSubject
    local originalCameraType = Camera.CameraType

    -- Remove UI if already exists
    if spyGui then
        spyGui:Destroy()
        spyGui = nil
    end

    -- Stop spy if running
    if connection then
        connection:Disconnect()
        connection = nil
    end

    if isEnabled then
        -- UI для повідомлення хто під спостереженням
        spyGui = Instance.new("ScreenGui", PlayerGui)
        spyGui.Name = "PlayerSpyLabel"

        local label = Instance.new("TextLabel", spyGui)
        label.Text = "Зараз spy за: Невідомо"
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Position = UDim2.new(0, 0, 1, -40)
        label.TextColor3 = Color3.new(1, 1, 1)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.Name = "SpyLabel"

        -- Input: Manual partial name via console
        warn("💡 Type this to set a target: setSpyTarget(\"partialName\")")

        -- Global setter for nickname
        getgenv().setSpyTarget = function(partialName)
            for _, player in ipairs(Players:GetPlayers()) do
                if string.find(player.Name:lower(), partialName:lower()) then
                    targetNickname = player.Name
                    if spyGui and spyGui:FindFirstChild("SpyLabel") then
                        spyGui.SpyLabel.Text = "Зараз spy за: " .. targetNickname
                    end
                    warn("🎯 Target set to: " .. targetNickname)
                    return
                end
            end
            warn("❌ Player not found with name: " .. partialName)
        end

        local function notify(_, msg)
            print("[Spy] " .. msg)
        end

        local function checkAttributes(player)
            local tracked = {
                "owned_homes", "IsInCombat", "IsInSafeZone", "Job",
                "LastHackedAtmTimestamp", "ArePaidRandomItemsRestricted",
                "InCharacterCreator", "LastDeathStamp", "LastDownedStamp",
                "LastSafeZoneLeave"
            }

            for _, attr in ipairs(tracked) do
                local value = player:GetAttribute(attr)

                if value ~= nil then
                    if attr == "owned_homes" and value == 1 and not hasShownOwnedHomes then
                        hasShownOwnedHomes = true
                        notify("info", "The player owns a home.")
                    end

                    if previousAttributes[attr] == nil then
                        previousAttributes[attr] = value
                    elseif previousAttributes[attr] ~= value then
                        previousAttributes[attr] = value
                        local msg
                        if attr == "LastDeathStamp" then
                            msg = "The player has died."
                        elseif attr == "LastDownedStamp" then
                            msg = "The player has been downed."
                        elseif attr == "LastSafeZoneLeave" then
                            msg = "In Safe Zone: " .. tostring(player:GetAttribute("IsInSafeZone"))
                        elseif attr == "LastHackedAtmTimestamp" then
                            msg = "The player hacked an ATM."
                        else
                            msg = "Attribute changed: " .. attr .. " = " .. tostring(value)
                        end
                        notify("update", msg)
                    end
                end
            end
        end

        connection = RunService.RenderStepped:Connect(function()
            if not targetNickname then return end
            local player = Players:FindFirstChild(targetNickname)
            if player then
                checkAttributes(player)
            end
        end)

        -- Камера: дозволити toggle через глобальний флаг
        getgenv().spyCamera = function(enable)
            local player = Players:FindFirstChild(targetNickname)
            if enable and player and player.Character and player.Character:FindFirstChild("Head") then
                Camera.CameraSubject = player.Character.Head
                Camera.CameraType = Enum.CameraType.Attach
                warn("📷 Camera locked to: " .. player.Name)
            else
                Camera.CameraSubject = originalCameraSubject
                Camera.CameraType = originalCameraType
                warn("📷 Camera returned to normal.")
            end
        end
    end
end
