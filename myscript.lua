-- Gui + Auto Find Server (missing 3 players to full)
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
circle.Position = UDim2.new(0.85,
