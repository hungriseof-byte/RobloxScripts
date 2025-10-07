local Players = game:GetService("Players")
local player = Players.LocalPlayer
local vu = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local TeleportPlaceId = game.PlaceId

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "CustomGUI"
gui.ResetOnSpawn = false

-- Toggle nút ẩn/hiện
local toggleButton = Instance.new("TextButton", gui)
toggleButton.Size = UDim2.new(0, 120, 0, 30)
toggleButton.Position = UDim2.new(0.5, -60, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleButton.BackgroundTransparency = 0.4
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.Text = "Ẩn Giao Diện"
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 8)

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 330, 0, 380)
frame.Position = UDim2.new(0.5, -165, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.4
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

toggleButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	toggleButton.Text = frame.Visible and "Ẩn" or "Hiện"
end)

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚙️ Giao Diện Hỗ Trợ - Hung"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

-- Hàm tạo nút
local function createButton(text, posY, color)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0, 290, 0, 38)
	btn.Position = UDim2.new(0.5, -145, 0, posY)
	btn.BackgroundColor3 = color
	btn.BackgroundTransparency = 0.4
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Text = text
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

-- ✅ Chống AFK
local afkEnabled = false
local afkConnection
local antiAFKButton = createButton("Chống AFK: TẮT", 45, Color3.fromRGB(200, 0, 0))
antiAFKButton.MouseButton1Click:Connect(function()
	afkEnabled = not afkEnabled
	if afkEnabled then
		antiAFKButton.Text = "Chống AFK: BẬT"
		antiAFKButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		afkConnection = player.Idled:Connect(function()
			vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
			task.wait(1)
			vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		end)
	else
		antiAFKButton.Text = "Chống AFK: TẮT"
		antiAFKButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
		if afkConnection then afkConnection:Disconnect() end
	end
end)

-- ✅ Giảm đồ họa
local graphicsReduced = false
local graphicsButton = createButton("Giảm Đồ Họa: TẮT", 90, Color3.fromRGB(200, 0, 0))
graphicsButton.MouseButton1Click:Connect(function()
	graphicsReduced = not graphicsReduced
	if graphicsReduced then
		graphicsButton.Text = "Giảm Đồ Họa: BẬT"
		graphicsButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		Lighting.Ambient = Color3.new(0, 0, 0)
		Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
		Lighting.FogEnd = 1e10
		Lighting.Brightness = 0
		Lighting.GlobalShadows = false
		for _, v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.SmoothPlastic
				v.Reflectance = 0
			elseif v:IsA("Decal") then
				v.Transparency = 1
			end
		end
	else
		graphicsButton.Text = "Giảm Đồ Họa: TẮT"
		graphicsButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
		Lighting.Ambient = Color3.fromRGB(128, 128, 128)
		Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
		Lighting.FogEnd = 1000
		Lighting.Brightness = 2
		Lighting.GlobalShadows = true
	end
end)

-- ✅ Đen màn hình
local screenBlack = false
local blackButton = createButton("🕶️ Đen Màn Hình: TẮT", 135, Color3.fromRGB(80, 80, 80))
local blackFrame = Instance.new("Frame", gui)
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackFrame.Visible = false
blackFrame.ZIndex = 10

blackButton.MouseButton1Click:Connect(function()
	screenBlack = not screenBlack
	blackFrame.Visible = screenBlack
	blackButton.Text = screenBlack and "🕶️ Đen Màn Hình: BẬT" or "🕶️ Đen Màn Hình: TẮT"
end)

-- ✅ Vào lại server khác
local rejoinButton = createButton("🔁 Vào Lại Server Khác", 180, Color3.fromRGB(0, 150, 255))
rejoinButton.MouseButton1Click:Connect(function()
	local HttpService = game:GetService("HttpService")
	local success, response = pcall(function()
		return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. TeleportPlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
	end)
	if success and response and response.data then
		for _, server in ipairs(response.data) do
			if server.playing < server.maxPlayers and server.id ~= game.JobId then
				TeleportService:TeleportToPlaceInstance(TeleportPlaceId, server.id, player)
				break
			end
		end
	end
end)

-- ✅ Tự quay
local isSpinning = false
local spinButton = createButton("🔄 Tự Quay: TẮT", 225, Color3.fromRGB(200, 0, 0))

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local bav = Instance.new("BodyAngularVelocity")
bav.AngularVelocity = Vector3.new(0, 150, 0)
bav.MaxTorque = Vector3.new(0, math.huge, 0)
bav.P = 1000
bav.Name = "Spinner"

spinButton.MouseButton1Click:Connect(function()
	isSpinning = not isSpinning
	if isSpinning then
		spinButton.Text = "🔄 Tự Quay: BẬT"
		spinButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		bav.Parent = hrp
	else
spinButton.Text = "🔄 Tự Quay: TẮT"
		spinButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
		bav.Parent = nil
	end
end)

player.CharacterAdded:Connect(function(char)
	character = char
	hrp = character:WaitForChild("HumanoidRootPart")
	if isSpinning then
		bav.Parent = hrp
	end
end)

-- ✅ Auto Click
local autoClickEnabled = false
local autoClickButton = createButton("🖱️ Auto Click: TẮT", 270, Color3.fromRGB(200, 0, 0))

autoClickButton.MouseButton1Click:Connect(function()
	autoClickEnabled = not autoClickEnabled
	if autoClickEnabled then
		autoClickButton.Text = "🖱️ Auto Click: BẬT"
		autoClickButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	else
		autoClickButton.Text = "🖱️ Auto Click: TẮT"
		autoClickButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
	end
end)

task.spawn(function()
	while true do
		task.wait(0.1)
		if autoClickEnabled then
			pcall(function()
				vu:Button1Down(Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2))
				task.wait(0.05)
				vu:Button1Up(Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2))
			end)
		end
	end
end)

-- ✅ X2 Tốc Độ (an toàn)
local speedBoostEnabled = false
local defaultSpeed = 16
local boostedSpeed = 32
local speedButton = createButton("⚡ X2 Tốc Độ: TẮT", 315, Color3.fromRGB(255, 140, 0))

local humanoid = player.Character:WaitForChild("Humanoid")

speedButton.MouseButton1Click:Connect(function()
	speedBoostEnabled = not speedBoostEnabled
	if speedBoostEnabled then
		speedButton.Text = "⚡ X2 Tốc Độ: BẬT"
		speedButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
		humanoid.WalkSpeed = boostedSpeed
	else
		speedButton.Text = "⚡ X2 Tốc Độ: TẮT"
		speedButton.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
		humanoid.WalkSpeed = defaultSpeed
	end
end)

player.CharacterAdded:Connect(function(char)
	humanoid = char:WaitForChild("Humanoid")
	if speedBoostEnabled then
		humanoid.WalkSpeed = boostedSpeed
	else
		humanoid.WalkSpeed = defaultSpeed
	end
end)

-- ✅ Thời gian chơi
local playTimeLabel = Instance.new("TextLabel", frame)
playTimeLabel.Size = UDim2.new(1, 0, 0, 30)
playTimeLabel.Position = UDim2.new(0, 0, 1, -30)
playTimeLabel.BackgroundTransparency = 1
playTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playTimeLabel.Font = Enum.Font.Gotham
playTimeLabel.TextSize = 16
playTimeLabel.Text = "Thời gian chơi: 00:00"

local playTime = 0
task.spawn(function()
	while true do
		task.wait(1)
		playTime += 1
		local minutes = math.floor(playTime / 60)
		local seconds = playTime % 60
		playTimeLabel.Text = string.format("Thời gian chơi: %02d:%02d", minutes, seconds)
	end
end)
