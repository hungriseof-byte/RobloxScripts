-- Gui + auto find server còn thiếu 3 người
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local placeId = game.PlaceId
local currentJobId = game.JobId

-- ==== CONFIG ====
local REQUIRED_FREE_SLOTS = 3
local FETCH_LIMIT = 100
local MAX_PAGES = 5

-- ==== GUI ====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FindServerGui"
ScreenGui.Parent = game.CoreGui

local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(0, 70, 0, 70)
shadow.Position = UDim2.new(0.85, 0, 0.7, 0)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BorderSizePixel = 0
shadow.Parent = ScreenGui

local circle = Instance.new("ImageButton")
circle.Size = UDim2.new(0, 60, 0, 60)
circle.Position = UDim2.new(0.85, 0, 0.7, 0)
circle.AnchorPoint = Vector2.new(0.5, 0.5)
circle.BackgroundTransparency = 1
circle.Image = "rbxassetid://3926305904"
circle.ImageRectOffset = Vector2.new(284, 4)
circle.ImageRectSize = Vector2.new(36, 36)
circle.Parent = ScreenGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 120, 0, 25)
statusLabel.Position = UDim2.new(0.85, 40, 0.7, -10)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Idle"
statusLabel.TextColor3 = Color3.fromRGB(255,255,255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = ScreenGui

-- ==== DRAG ====
local dragging, dragInput, dragStart, startPos
local UIS = game:GetService("UserInputService")

local function update(input)
	local delta = input.Position - dragStart
	circle.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	shadow.Position = circle.Position
	statusLabel.Position = circle.Position + UDim2.new(0, 50, 0, -10)
end

circle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = circle.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

circle.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- ==== FIND SERVER ====
local function fetchServers(cursor)
	local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Desc&limit=" .. FETCH_LIMIT
	if cursor then
		url = url .. "&cursor=" .. cursor
	end
	local success, res = pcall(function()
		return game:HttpGet(url)
	end)
	if not success then return nil end
	local data = HttpService:JSONDecode(res)
	return data
end

local function findServerWithFreeSlots(required)
local cursor = nil
	for _ = 1, MAX_PAGES do
		local data = fetchServers(cursor)
		if not data then break end
		for _, server in ipairs(data.data) do
			local free = server.maxPlayers - server.playing
			if free == required and server.id ~= currentJobId then
				return server.id
			end
		end
		if not data.nextPageCursor then break end
		cursor = data.nextPageCursor
	end
	return nil
end

-- ==== CLICK ====
circle.MouseButton1Click:Connect(function()
	statusLabel.Text = "Finding..."
	local serverId = findServerWithFreeSlots(REQUIRED_FREE_SLOTS)
	if serverId then
		statusLabel.Text = "Joining..."
		TeleportService:TeleportToPlaceInstance(placeId, serverId, player)
	else
		statusLabel.Text = "Not found"
		wait(1.5)
		statusLabel.Text = "Idle"
	end
end)

print("[✅ Script Loaded: Auto Find Server GUI]")
