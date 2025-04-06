local player = game.Players.LocalPlayer
local speed = 125 
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local char = player.Character or player.CharacterAdded:Wait()
local rootPart = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local moveVector = Vector3.zero

local SpeedConnection
local speedEnabled = false

return function(isEnabled)

	if SpeedConnection then
		SpeedConnection:Disconnect()
		SpeedConnection = nil
	end

	if isEnabled == true then
		speedEnabled = true
		SpeedConnection = RunService.RenderStepped:Connect(function()
			if not rootPart or not humanoid then return end
			if not speedEnabled then return end
			
			local camera = workspace.CurrentCamera
			local direction = (camera.CFrame.RightVector * moveVector.X + camera.CFrame.LookVector * moveVector.Z)
			rootPart.Velocity = direction * speed 
		end)

		UIS.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then return end
			if input.KeyCode == Enum.KeyCode.W then moveVector = moveVector + Vector3.new(0, 0, -1) end
			if input.KeyCode == Enum.KeyCode.S then moveVector = moveVector + Vector3.new(0, 0, 1) end
			if input.KeyCode == Enum.KeyCode.A then moveVector = moveVector + Vector3.new(-1, 0, 0) end
			if input.KeyCode == Enum.KeyCode.D then moveVector = moveVector + Vector3.new(1, 0, 0) end
		end)

		UIS.InputEnded:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.W then moveVector = moveVector - Vector3.new(0, 0, -1) end
			if input.KeyCode == Enum.KeyCode.S then moveVector = moveVector - Vector3.new(0, 0, 1) end
			if input.KeyCode == Enum.KeyCode.A then moveVector = moveVector - Vector3.new(-1, 0, 0) end
			if input.KeyCode == Enum.KeyCode.D then moveVector = moveVector - Vector3.new(1, 0, 0) end
		end)
	else
		speedEnabled = false
	end
end
