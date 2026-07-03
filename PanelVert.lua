-- PanelVert.lua
-- LocalScript to display a Green ESP panel and draw ESP markers using server RemoteEvent "ESPEvent"
-- Place this file in StarterPlayerScripts (or as PanelVert.lua in the repo if you want it deployed there)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local espEvent = ReplicatedStorage:WaitForChild("ESPEvent")

-- UI / État
local espEnabled = false
local staffOnlyEnabled = false
local lastServerResponse = { isStaff = false, players = {} }
local markers = {} -- userId -> { gui, highlight, conn }

-- Nettoyage
local function clearMarker(userId)
	local v = markers[userId]
	if not v then return end
	if v.gui then v.gui:Destroy() end
	if v.highlight then v.highlight:Destroy() end
	if v.conn then v.conn:Disconnect() end
	markers[userId] = nil
end

local function clearAllMarkers()
	for id,_ in pairs(markers) do clearMarker(id) end
end

-- Green panel UI
local function makeGreenPanel()
	-- Avoid creating twice
	if PlayerGui:FindFirstChild("PanelVert_UI") then return end

	local gui = Instance.new("ScreenGui")
	gui.Name = "PanelVert_UI"
	gui.ResetOnSpawn = false
	gui.Parent = PlayerGui

	local panel = Instance.new("Frame")
	panel.Size = UDim2.new(0, 380, 0, 128)
	panel.Position = UDim2.new(0, 20, 0, 20)
	panel.BackgroundColor3 = Color3.fromRGB(8, 40, 20) -- dark green background
	panel.BorderSizePixel = 0
	panel.Parent = gui
	local panelCorner = Instance.new("UICorner", panel)
	panelCorner.CornerRadius = UDim.new(0, 10)

	local title = Instance.new("TextLabel", panel)
	title.Size = UDim2.new(1, -28, 0, 28)
	title.Position = UDim2.new(0, 14, 0, 8)
	title.BackgroundTransparency = 1
	title.Text = "ESP • Panel Vert"
	title.TextColor3 = Color3.fromRGB(220, 255, 220)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left

	local function makeBtn(text, x)
		local b = Instance.new("TextButton", panel)
		b.Size = UDim2.new(0, 172, 0, 40)
		b.Position = UDim2.new(0, x, 0, 46)
		b.BackgroundColor3 = Color3.fromRGB(18, 80, 40)
		b.TextColor3 = Color3.fromRGB(230, 255, 230)
		b.Font = Enum.Font.GothamBold
		b.TextSize = 14
		b.Text = text
		local bc = Instance.new("UICorner", b)
		bc.CornerRadius = UDim.new(0,8)
		return b
	end

	local playerBtn = makeBtn("Player ESP : OFF", 12)
	playerBtn.MouseButton1Click:Connect(function()
		espEnabled = not espEnabled
		playerBtn.Text = espEnabled and "Player ESP : ON" or "Player ESP : OFF"
		playerBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(30,200,110) or Color3.fromRGB(18,80,40)
		if not espEnabled then
			clearAllMarkers()
		else
			espEvent:FireServer("RequestESP")
		end
	end)

	local staffBtn = makeBtn("Staff Only : OFF", 196)
	staffBtn.MouseButton1Click:Connect(function()
		staffOnlyEnabled = not staffOnlyEnabled
		staffBtn.Text = staffOnlyEnabled and "Staff Only : ON" or "Staff Only : OFF"
		staffBtn.BackgroundColor3 = staffOnlyEnabled and Color3.fromRGB(200,180,40) or Color3.fromRGB(18,80,40)
		espEvent:FireServer("RequestESP")
	end)

	local close = Instance.new("TextButton", panel)
	close.Size = UDim2.new(0, 28, 0, 28)
	close.Position = UDim2.new(1, -38, 0, 8)
	close.Text = "×"
	close.Font = Enum.Font.GothamBold
	close.TextSize = 18
	close.TextColor3 = Color3.fromRGB(20,20,20)
	close.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
	local ccorn = Instance.new("UICorner", close)
	ccorn.CornerRadius = UDim.new(0,6)
	close.MouseButton1Click:Connect(function()
		if PlayerGui:FindFirstChild("PanelVert_UI") then PlayerGui.PanelVert_UI:Destroy() end
		clearAllMarkers()
	end)
end

-- Create a marker visually from server data
local function createMarkerFromData(data)
	local player = Players:GetPlayerByUserId(data.userId)
	if not player or not player.Character then return end
	local hrp = player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- If staffOnlyEnabled but role string doesn't match, skip
	if staffOnlyEnabled then
		local r = tostring(data.role or ""):lower()
		if not (string.find(r, "staff") or string.find(r, "admin") or string.find(r, "mod") or string.find(r, "dev")) then
			return
		end
	end

	-- Highlight
	local hl = Instance.new("Highlight")
	hl.Name = "PanelVert_ESP_Highlight"
	hl.Adornee = player.Character
	hl.FillTransparency = 0.65
	hl.OutlineTransparency = 0.2

	local rr = tostring(data.role or ""):lower()
	local isProbablyStaff = false
	if string.find(rr, "staff") or string.find(rr, "admin") or string.find(rr, "mod") then isProbablyStaff = true end

	if isProbablyStaff then
		hl.FillColor = Color3.fromRGB(255,210,80) -- gold for staff
		hl.OutlineColor = Color3.fromRGB(255,210,80)
	else
		hl.FillColor = Color3.fromRGB(0,170,140) -- green/cyan for players
		hl.OutlineColor = Color3.fromRGB(0,170,140)
	end
	hl.Parent = workspace

	-- Billboard GUI
	local bgui = Instance.new("BillboardGui")
	bgui.Name = "PanelVert_ESP_Tag"
	bgui.Adornee = hrp
	bgui.AlwaysOnTop = true
	bgui.Size = UDim2.new(0, 240, 0, 68)
	bgui.ExtentsOffset = Vector3.new(0, 3, 0)
	bgui.Parent = workspace

	local frame = Instance.new("Frame", bgui)
	frame.Size = UDim2.new(1,0,1,0)
	frame.BackgroundTransparency = 0.45
	frame.BackgroundColor3 = Color3.fromRGB(6, 28, 18)
	frame.BorderSizePixel = 0

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, -12, 0, 24)
	title.Position = UDim2.new(0, 6, 0, 6)
	title.BackgroundTransparency = 1
	title.Text = tostring(data.displayName or data.name)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 15
	title.TextColor3 = Color3.fromRGB(230, 255, 230)
	title.TextXAlignment = Enum.TextXAlignment.Left

	local subtitle = Instance.new("TextLabel", frame)
	subtitle.Size = UDim2.new(1, -12, 0, 18)
	subtitle.Position = UDim2.new(0, 6, 0, 30)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = tostring(data.role or "Joueur")
	subtitle.Font = Enum.Font.Gotham
	subtitle.TextSize = 12
	subtitle.TextColor3 = isProbablyStaff and Color3.fromRGB(255,210,80) or Color3.fromRGB(170,230,200)
	subtitle.TextXAlignment = Enum.TextXAlignment.Left

	local distanceLabel = Instance.new("TextLabel", frame)
	distanceLabel.Size = UDim2.new(0, 80, 0, 18)
	distanceLabel.Position = UDim2.new(1, -86, 0, 30)
	distanceLabel.BackgroundTransparency = 1
	distanceLabel.Text = ""
	distanceLabel.Font = Enum.Font.Gotham
	distanceLabel.TextSize = 12
	distanceLabel.TextColor3 = Color3.fromRGB(200,240,210)
	distanceLabel.TextXAlignment = Enum.TextXAlignment.Right

	-- Update loop
	local conn
	conn = RunService.RenderStepped:Connect(function()
		if not player or not player.Character or not player.Character.Parent then
			conn:Disconnect()
			clearMarker(data.userId)
			return
		end
		local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local targetRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if myRoot and targetRoot then
			local dist = math.floor((myRoot.Position - targetRoot.Position).Magnitude)
			distanceLabel.Text = ("📍 %dm"):format(dist)
		end
		if data.health and lastServerResponse.isStaff then
			subtitle.Text = tostring(data.role or "Joueur") .. "  |  ❤ " .. math.floor(data.health)
		end
	end)

	markers[data.userId] = { gui = bgui, highlight = hl, conn = conn }
end

-- Handler for server response
espEvent.OnClientEvent:Connect(function(response)
	lastServerResponse = response or lastServerResponse
	if not espEnabled then return end
	clearAllMarkers()
	for _, pd in ipairs(lastServerResponse.players or {}) do
		createMarkerFromData(pd)
	end
end)

-- Periodic request to server
-- Initial request
pcall(function() espEvent:FireServer("RequestESP") end)
spawn(function()
	while true do
		task.wait(4)
		pcall(function() espEvent:FireServer("RequestESP") end)
	end
end)

-- Create panel on load
makeGreenPanel()
