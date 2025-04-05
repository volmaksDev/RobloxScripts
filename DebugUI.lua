return function(debugEnabled)
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

	local Gui = Instance.new("ScreenGui")
	Gui.Name = "DebugUI"
	Gui.ResetOnSpawn = false
	Gui.Parent = PlayerGui
	Gui.Enabled = debugEnabled

	local Frame = Instance.new("Frame")
	Frame.Name = "DebugFrame"
	Frame.Size = UDim2.new(0, 350, 0, 200)
	Frame.Position = UDim2.new(0, 20, 0, 20)
	Frame.BackgroundColor3 = Color3.fromRGB(94,94,94)
	Frame.BackgroundTransparency = 0.6
	Frame.Parent = Gui

	local UIListLayout = Instance.new("UIListLayout", Frame)
	UIListLayout.Padding = UDim.new(0,20)
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local UIPadding = Instance.new("UIPadding", Frame)
	UIPadding.PaddingTop = UDim.new(0,5)

	local UiCorner = Instance.new("UICorner")
	UiCorner.CornerRadius = UDim.new(0,8)
	UiCorner.Parent = Frame

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Size = UDim2.new(0, 200, 0, 50)
	NameLabel.BackgroundColor3 = Color3.fromRGB(77,77,77)
	NameLabel.BackgroundTransparency = 0.5
	NameLabel.Text = "DebugUI"
	NameLabel.TextScaled = true
	NameLabel.TextColor3 = Color3.fromRGB(255,255,255)
	NameLabel.Parent = Frame

	local LabelCorner = UiCorner:Clone()
	LabelCorner.Parent = NameLabel

	local DebugLabel = Instance.new("TextLabel")
	DebugLabel.Name = "DebugLabel"
	DebugLabel.Size = UDim2.new(0, 330, 0, 114)
	DebugLabel.Position = UDim2.new(0, 0, 0.3, 0)
	DebugLabel.BackgroundColor3 = Color3.fromRGB(90,90,90)
	DebugLabel.BackgroundTransparency = 0.5
	DebugLabel.Text = debugEnabled and "Debug Mode: ON" or "Debug Mode: OFF"
	DebugLabel.TextScaled = true
	DebugLabel.TextColor3 = Color3.fromRGB(255,255,255)
	DebugLabel.Parent = Frame

	local UIDragDetector = Instance.new("UIDragDetector")
	UIDragDetector.Parent = Frame
end
