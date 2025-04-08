local Connection

return function(isEnabled)
	local RunService = game:GetService("RunService")
	local HighlightEnabled

	if Connection then
		Connection:Disconnect()
	end

	if isEnabled == true then
		HighlightEnabled = true

		local function GetATMs()
			if not HighlightEnabled then return end

			local ATMFolder = workspace.Map.Props:GetChildren()

			for _, ATM in ipairs(ATMFolder) do
				if ATM.Name == "ATM" then

					local Highlight = ATM:FindFirstChild("ATMHighlight")
					if not Highlight then
						Highlight = Instance.new("Highlight")
						Highlight.Name = "ATMHighlight"
						Highlight.Parent = ATM
					end

					local ATMChilds = ATM:GetChildren()
					for _, child in ipairs(ATMChilds) do
						if child:IsA("BasePart") then
							local Screen = child:FindFirstChild("Screen")
							if Screen and Screen:IsA("SurfaceGui") then
								if Screen.Enabled then
									Highlight.FillColor = Color3.fromRGB(255, 0, 0)
								else
									Highlight.FillColor = Color3.fromRGB(0, 255, 0)
								end
							end
						end
					end
				end
			end
		end

		Connection = RunService.Heartbeat:Connect(GetATMs)
   else
      HighlightEnabled = false
   
      -- 🧹 Видаляємо всі Highlight-и з ATM (навіть глибоко вкладені)
      for _, obj in ipairs(workspace.Map.Props:GetDescendants()) do
         if obj:IsA("Model") and obj.Name == "ATM" then
            local highlight = obj:FindFirstChild("ATMHighlight")
            if highlight then
               highlight:Destroy()
            end
         end
      end
   end
end
