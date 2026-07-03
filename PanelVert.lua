-- Vérification par group (si configuré)
if STAFF_GROUP_ID > 0 then
	local ok, rank = pcall(function() return player:GetRankInGroup(STAFF_GROUP_ID) end)
	if ok and rank and rank > 0 then return true end
end

-- Vérification par Team (nom qui contient "staff", "admin", "mod")
if player.Team then
	local tName = tostring(player.Team.Name):lower()
	if string.find(tName, "staff") or string.find(tName, "admin") or string.find(tName, "mod") then
		return true
	end
end

return false

local requesterIsStaff = isStaff(player)
local playersData = {}

for _, p in pairs(Players:GetPlayers()) do
	-- n'ajoute que les joueurs dont le character semble chargé
	if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
		local entry = {
			userId = p.UserId,
			name = p.Name,
			displayName = p.DisplayName,
			role = p:GetAttribute("Role") or (p.Team and p.Team.Name) or "Joueur",
		}

		-- Infos supplémentaires uniquement pour le staff
		if requesterIsStaff then
			local hrp = p.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
			entry.position = hrp and hrp.Position or nil
			entry.health = humanoid and humanoid.Health or nil
		end

		table.insert(playersData, entry)
	end
end

-- Envoie la réponse uniquement au client demandeur
espEvent:FireClient(player, { isStaff = requesterIsStaff, players = playersData })

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 360, 0, 120)
panel.Position = UDim2.new(0, 20, 0, 20)
panel.BackgroundColor3 = Color3.fromRGB(10,10,10)
panel.BorderSizePixel = 0
panel.Parent = gui

local corner = Instance.new("UICorner", panel)
corner.CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel", panel)
title.Size = UDim2.new(1, -24, 0, 28)
title.Position = UDim2.new(0, 12, 0, 8)
title.BackgroundTransparency = 1
title.Text = "ESP • Panel"
title.TextColor3 = Color3.fromRGB(240,240,240)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left

local function makeBtn(text, y)
	local b = Instance.new("TextButton", panel)
	b.Size = UDim2.new(0, 160, 0, 36)
	b.Position = UDim2.new(0, 12 + (y-1)*176, 0, 44)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.TextColor3 = Color3.fromRGB(220,220,220)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.Text = text
	local bc = Instance.new("UICorner", b)
	bc.CornerRadius = UDim.new(0,6)
	return b
end

local playerBtn = makeBtn("Player ESP : OFF", 1)
playerBtn.Position = UDim2.new(0, 12, 0, 44)
playerBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	playerBtn.Text = espEnabled and "Player ESP : ON" or "Player ESP : OFF"
	playerBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(0,160,80) or Color3.fromRGB(30,30,30)
	if not espEnabled then
		clearAllMarkers()
	else
		-- trigger a refresh request
		espEvent:FireServer("RequestESP")
	end
end)

local staffBtn = makeBtn("Staff Only : OFF", 2)
staffBtn.Position = UDim2.new(0, 188, 0, 44)
staffBtn.MouseButton1Click:Connect(function()
	staffOnlyEnabled = not staffOnlyEnabled
	staffBtn.Text = staffOnlyEnabled and "Staff Only : ON" or "Staff Only : OFF"
	staffBtn.BackgroundColor3 = staffOnlyEnabled and Color3.fromRGB(240,170,0) or Color3.fromRGB(30,30,30)
	espEvent:FireServer("RequestESP")
end)

-- Close button
local close = Instance.new("TextButton", panel)
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -36, 0, 8)
close.Text = "×"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.TextColor3 = Color3.fromRGB(240,240,240)
close.BackgroundColor3 = Color3.fromRGB(180,40,40)
local cc = Instance.new("UICorner", close)
cc.CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function()
	gui:Destroy()
	clearAllMarkers()
end)

-- If staffOnlyEnabled but role string does not suggest staff, skip
if staffOnlyEnabled then
	local r = tostring(data.role or ""):lower()
	if not (string.find(r, "staff") or string.find(r, "admin") or string.find(r, "mod") or string.find(r, "dev")) then
		return
	end
end

-- Create Highlight
local hl = Instance.new("Highlight")
hl.Name = "SF_ESP_Highlight"
hl.Adornee = player.Character
hl.FillTransparency = 0.65
hl.OutlineTransparency = 0.2
hl.Parent = workspace

-- Colors: staff = gold, other = cyan / based on role color
local isProbablyStaff = false
local rr = tostring(data.role or ""):lower()
if string.find(rr, "staff") or string.find(rr, "admin") or string.find(rr, "mod") then isProbablyStaff = true end

if isProbablyStaff then
	hl.FillColor = Color3.fromRGB(255,200,50)
	hl.OutlineColor = Color3.fromRGB(255,200,50)
else
	hl.FillColor = Color3.fromRGB(0,160,255)
	hl.OutlineColor = Color3.fromRGB(0,160,255)
end

-- Create BillboardGui
local bgui = Instance.new("BillboardGui")
bgui.Name = "SF_ESP_Tag"
bgui.Adornee = hrp
bgui.AlwaysOnTop = true
bgui.Size = UDim2.new(0, 220, 0, 64)
bgui.ExtentsOffset = Vector3.new(0, 3, 0)
bgui.Parent = workspace

local frame = Instance.new("Frame", bgui)
frame.Size = UDim2.new(1,0,1,0)
frame.BackgroundTransparency = 0.45
frame.BackgroundColor3 = Color3.fromRGB(8,8,8)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -8, 0, 22)
title.Position = UDim2.new(0, 4, 0, 4)
title.BackgroundTransparency = 1
title.Text = tostring(data.displayName or data.name)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(240,240,240)
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, -8, 0, 18)
subtitle.Position = UDim2.new(0, 4, 0, 26)
subtitle.BackgroundTransparency = 1
subtitle.Text = tostring(data.role or "Joueur")
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.TextColor3 = isProbablyStaff and Color3.fromRGB(255,200,50) or Color3.fromRGB(160,220,255)
subtitle.TextXAlignment = Enum.TextXAlignment.Left

local distanceLabel = Instance.new("TextLabel", frame)
distanceLabel.Size = UDim2.new(0, 70, 0, 18)
distanceLabel.Position = UDim2.new(1, -74, 0, 22)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = ""
distanceLabel.Font = Enum.Font.Gotham
distanceLabel.TextSize = 12
distanceLabel.TextColor3 = Color3.fromRGB(220,220,220)
distanceLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Update connection
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
	-- If server sent health and requester is staff, append health
	if data.health and lastServerResponse.isStaff then
		subtitle.Text = tostring(data.role or "Joueur") .. "  |  ❤ " .. math.floor(data.health)
	end
end)

markers[data.userId] = { gui = bgui, highlight = hl, conn = conn }