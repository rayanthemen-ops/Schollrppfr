-- Services requis
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Nettoyage si le script relance
if playerGui:FindFirstChild("UltraModernPanel") then
	playerGui.UltraModernPanel:Destroy()
end

if Workspace:FindFirstChild("ESPFolder") then
	Workspace:FindFirstChild("ESPFolder"):Destroy()
end

-- 1. Création de l'interface principale (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UltraModernPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Folder ESP
local espFolder = Instance.new("Folder")
espFolder.Name = "ESPFolder"
espFolder.Parent = Workspace

-- Fonction son de clic sécurisée
local function playKeyboardSound()
	pcall(function()
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://6895070853" 
		sound.Volume = 1
		sound.Pitch = math.random(95, 105) / 100
		sound.Parent = screenGui
		sound:Play()
		sound.Ended:Connect(function() sound:Destroy() end)
	end)
end

-- 2. Mini Bouton (Carré haut)
local miniButton = Instance.new("TextButton")
miniButton.Name = "MiniButton"
miniButton.Size = UDim2.new(0, 48, 0, 48)
miniButton.Position = UDim2.new(0.5, -24, 0, 15)
miniButton.BackgroundColor3 = Color3.fromRGB(18, 20, 30)
miniButton.Text = "⚡"
miniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
miniButton.TextSize = 20
miniButton.Font = Enum.Font.GothamBold
miniButton.Visible = false
miniButton.ZIndex = 10
miniButton.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 14)
miniCorner.Parent = miniButton

local miniStroke = Instance.new("UIStroke")
miniStroke.Color = Color3.fromRGB(120, 130, 200)
miniStroke.Thickness = 1.8
miniStroke.Transparency = 0.3
miniStroke.Parent = miniButton

-- 3. Fenêtre principale
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 680, 0, 440)
mainFrame.Position = UDim2.new(0.5, -340, 0.5, -220)
mainFrame.BackgroundColor3 = Color3.fromRGB(14, 16, 24)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 28)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(120, 130, 200)
mainStroke.Thickness = 1.8
mainStroke.Transparency = 0.7
mainStroke.Parent = mainFrame

-- 4. Bouton Croix
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -46, 0, 14)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 34, 48)
closeBtn.BackgroundTransparency = 0.4
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(220, 225, 240)
closeBtn.TextSize = 15
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 5
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(255, 90, 90)
closeStroke.Thickness = 1.2
closeStroke.Transparency = 0.5
closeStroke.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.2), {
		BackgroundColor3 = Color3.fromRGB(220, 50, 70),
		BackgroundTransparency = 0.1,
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
end)

closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.2), {
		BackgroundColor3 = Color3.fromRGB(30, 34, 48),
		BackgroundTransparency = 0.4,
		TextColor3 = Color3.fromRGB(220, 225, 240)
	}):Play()
end)

-- 5. Arrière-Plan Dynamique
local bgContainer = Instance.new("Folder")
bgContainer.Name = "DynamicBackground"
bgContainer.Parent = mainFrame

local bgElements = {}

local function clearBackground()
	for _, el in ipairs(bgElements) do
		if el.Obj then el.Obj:Destroy() end
	end
	bgElements = {}
end

local function generateBackground(mode)
	clearBackground()
	
	local count = (mode == "Stars") and 20 or 12
	for i = 1, count do
		local p = Instance.new("Frame")
		local size = (mode == "Stars") and math.random(15, 35) or math.random(50, 130)
		p.Size = UDim2.new(0, size, 0, size)
		p.Position = UDim2.new(math.random(), 0, math.random(), 0)
		p.BackgroundColor3 = Color3.fromRGB(math.random(70, 150), math.random(100, 220), math.random(200, 255))
		p.BackgroundTransparency = 0.8
		p.BorderSizePixel = 0
		
		local corner = Instance.new("UICorner")
		if mode == "Bubbles" then
			corner.CornerRadius = UDim.new(1, 0)
		elseif mode == "Cubes" then
			corner.CornerRadius = UDim.new(0, 8)
		else
			corner.CornerRadius = UDim.new(0.3, 0)
		end
		corner.Parent = p
		
		p.Parent = bgContainer
		table.insert(bgElements, {
			Obj = p,
			SpeedX = math.random(-15, 15) / 100,
			SpeedY = math.random(-15, 15) / 100,
			RotSpeed = math.random(-30, 30)
		})
	end
end

generateBackground("Bubbles")

RunService.RenderStepped:Connect(function(dt)
	for _, data in ipairs(bgElements) do
		if data.Obj and data.Obj.Parent then
			local pos = data.Obj.Position
			local nx = (pos.X.Scale + data.SpeedX * dt) % 1
			local ny = (pos.Y.Scale + data.SpeedY * dt) % 1
			data.Obj.Position = UDim2.new(nx, pos.X.Offset, ny, pos.Y.Offset)
			data.Obj.Rotation = data.Obj.Rotation + (data.RotSpeed * dt)
		end
	end
end)

-- 6. Barre latérale (Navigation)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 200, 1, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
sidebar.BackgroundTransparency = 0.5
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame

local sideList = Instance.new("UIListLayout")
sideList.SortOrder = Enum.SortOrder.LayoutOrder
sideList.Padding = UDim.new(0, 8)
sideList.Parent = sidebar

local sidePadding = Instance.new("UIPadding")
sidePadding.PaddingTop = UDim.new(0, 25)
sidePadding.PaddingLeft = UDim.new(0, 14)
sidePadding.PaddingRight = UDim.new(0, 14)
sidePadding.Parent = sidebar

local brand = Instance.new("TextLabel")
brand.Size = UDim2.new(1, 0, 0, 40)
brand.BackgroundTransparency = 1
brand.Text = "⚡ PRIME V2"
brand.TextColor3 = Color3.fromRGB(255, 255, 255)
brand.TextSize = 18
brand.Font = Enum.Font.GothamBold
brand.TextXAlignment = Enum.TextXAlignment.Left
brand.LayoutOrder = 0
brand.Parent = sidebar

-- 7. Conteneur des pages
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -200, 1, 0)
contentArea.Position = UDim2.new(0, 200, 0, 0)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local pages = {
	Home = Instance.new("ScrollingFrame"),
	ESP = Instance.new("ScrollingFrame"),
	AutoFarm = Instance.new("ScrollingFrame"),
	Themes = Instance.new("ScrollingFrame"),
	Backgrounds = Instance.new("ScrollingFrame")
}

for name, page in pairs(pages) do
	page.Name = name .. "Page"
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.CanvasSize = UDim2.new(0, 0, 0, 950)
	page.Visible = (name == "Home")
	page.Parent = contentArea
	
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 30)
	pad.PaddingLeft = UDim.new(0, 30)
	pad.PaddingRight = UDim.new(0, 30)
	pad.Parent = page
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 12)
	layout.Parent = page
end

local function createPageTitle(text, parentPage)
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 35)
	title.BackgroundTransparency = 1
	title.Text = text
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 22
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.LayoutOrder = 1
	title.Parent = parentPage
end

createPageTitle("Accueil", pages.Home)
createPageTitle("ESP & Outils", pages.ESP)
createPageTitle("Auto-Farm & Cibles Vitesse", pages.AutoFarm)
createPageTitle("Thèmes de Couleurs", pages.Themes)
createPageTitle("Styles de Fond Arrière", pages.Backgrounds)

local function createNavButton(name, targetPage, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 44)
	btn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
	btn.BackgroundTransparency = 0.6
	btn.Text = "   " .. name
	btn.TextColor3 = Color3.fromRGB(170, 175, 195)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamMedium
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.LayoutOrder = order
	btn.Parent = sidebar
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		playKeyboardSound()
		for _, p in pairs(pages) do p.Visible = false end
		targetPage.Visible = true
	end)
	
	return btn
end

createNavButton("Accueil", pages.Home, 1)
createNavButton("ESP & Outils", pages.ESP, 2)
createNavButton("Auto-Farm & Cibles", pages.AutoFarm, 3)
createNavButton("Thèmes Couleurs", pages.Themes, 4)
createNavButton("Fonds Arrière", pages.Backgrounds, 5)

-- Widget Accueil
local profileCard = Instance.new("Frame")
profileCard.Size = UDim2.new(1, 0, 0, 110)
profileCard.BackgroundColor3 = Color3.fromRGB(20, 24, 36)
profileCard.BorderSizePixel = 0
profileCard.LayoutOrder = 2
profileCard.Parent = pages.Home

local profileCorner = Instance.new("UICorner")
profileCorner.CornerRadius = UDim.new(0, 14)
profileCorner.Parent = profileCard

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 72, 0, 72)
avatarImg.Position = UDim2.new(0, 16, 0.5, -36)
avatarImg.BackgroundColor3 = Color3.fromRGB(35, 40, 55)
avatarImg.BorderSizePixel = 0
avatarImg.Image = "rbxassetid://0"
avatarImg.Parent = profileCard

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImg

task.spawn(function()
	local success, content = pcall(function()
		return Players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
	end)
	if success then
		avatarImg.Image = content
	end
end)

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, -110, 0, 28)
nameLabel.Position = UDim2.new(0, 102, 0, 16)
nameLabel.BackgroundTransparency = 1
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 16
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Text = "Utilisateur : " .. localPlayer.Name
nameLabel.Parent = profileCard

local pseudoLabel = Instance.new("TextLabel")
pseudoLabel.Size = UDim2.new(1, -110, 0, 24)
pseudoLabel.Position = UDim2.new(0, 102, 0, 44)
pseudoLabel.BackgroundTransparency = 1
pseudoLabel.Font = Enum.Font.GothamMedium
pseudoLabel.TextSize = 13
pseudoLabel.TextColor3 = Color3.fromRGB(170, 175, 195)
pseudoLabel.TextXAlignment = Enum.TextXAlignment.Left
pseudoLabel.Text = "Pseudo : @" .. localPlayer.DisplayName
pseudoLabel.Parent = profileCard

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(1, -110, 0, 24)
statsLabel.Position = UDim2.new(0, 102, 0, 70)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.GothamSemibold
statsLabel.TextSize, statsLabel.TextColor3 = 13, Color3.fromRGB(80, 220, 120)
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Text = "FPS : 60 | Ping : 0 ms"
statsLabel.Parent = profileCard

local fpsCounter = 60
local lastTick = tick()
RunService.RenderStepped:Connect(function()
	local currentTick = tick()
	if currentTick - lastTick > 0 then
		fpsCounter = math.floor(1 / (currentTick - lastTick))
	end
	lastTick = currentTick
	
	local pingVal = 0
	pcall(function()
		pingVal = math.floor(localPlayer:GetNetworkPing() * 1000)
	end)
	
	statsLabel.Text = string.format("FPS : %d | Ping : %d ms", fpsCounter, pingVal)
end)

-- Widget Chance d'être Meurtrier (MM2)
local chanceCard = Instance.new("Frame")
chanceCard.Size = UDim2.new(1, 0, 0, 110)
chanceCard.BackgroundColor3 = Color3.fromRGB(20, 24, 36)
chanceCard.BorderSizePixel = 0
chanceCard.LayoutOrder = 3
chanceCard.Parent = pages.Home

local chanceCorner = Instance.new("UICorner")
chanceCorner.CornerRadius = UDim.new(0, 14)
chanceCorner.Parent = chanceCard

local chanceTitle = Instance.new("TextLabel")
chanceTitle.Size = UDim2.new(1, -20, 0, 25)
chanceTitle.Position = UDim2.new(0, 10, 0, 10)
chanceTitle.BackgroundTransparency = 1
chanceTitle.Font = Enum.Font.GothamBold
chanceTitle.TextSize = 14
chanceTitle.TextColor3 = Color3.fromRGB(255, 120, 120)
chanceTitle.TextXAlignment = Enum.TextXAlignment.Left
chanceTitle.Text = "🎯 Affichage Chance d'être Meurtrier :"
chanceTitle.Parent = chanceCard

local chanceValueLabel = Instance.new("TextLabel")
chanceValueLabel.Size = UDim2.new(1, -20, 0, 30)
chanceValueLabel.Position = UDim2.new(0, 10, 0, 35)
chanceValueLabel.BackgroundTransparency = 1
chanceValueLabel.Font = Enum.Font.GothamBold
chanceValueLabel.TextSize = 16
chanceValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
chanceValueLabel.TextXAlignment = Enum.TextXAlignment.Left
chanceValueLabel.Text = "Statut : Désactivé"
chanceValueLabel.Parent = chanceCard

local chanceToggleBtn = Instance.new("TextButton")
chanceToggleBtn.Size = UDim2.new(0, 160, 0, 32)
chanceToggleBtn.Position = UDim2.new(0, 10, 0, 70)
chanceToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
chanceToggleBtn.Text = "Activer"
chanceToggleBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
chanceToggleBtn.TextSize, chanceToggleBtn.Font = 13, Enum.Font.GothamBold
chanceToggleBtn.Parent = chanceCard

local chanceToggleCorner = Instance.new("UICorner")
chanceToggleCorner.CornerRadius = UDim.new(0, 8)
chanceToggleCorner.Parent = chanceToggleBtn

local showMurderChance = false

chanceToggleBtn.MouseButton1Click:Connect(function()
	playKeyboardSound()
	showMurderChance = not showMurderChance
	if showMurderChance then
		chanceToggleBtn.Text = "Refuser (Désactiver)"
		chanceToggleBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
	else
		chanceToggleBtn.Text = "Activer"
		chanceToggleBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
		chanceValueLabel.Text = "Statut : Désactivé"
	end
end)

task.spawn(function()
	while true do
		if showMurderChance then
			pcall(function()
				local playersList = Players:GetPlayers()
				local totalPlayers = #playersList
				if totalPlayers <= 1 then
					chanceValueLabel.Text = "Seul dans le serveur (100%)"
				else
					local chance = (1 / totalPlayers) * 100
					chanceValueLabel.Text = string.format("~%.1f%% de chance ce round (%d joueurs)", chance, totalPlayers)
				end
			end)
		end
		task.wait(3)
	end
end)

-- ESP MM2
local espEnabled = false
local espToggleBtn = Instance.new("TextButton")
espToggleBtn.Size = UDim2.new(1, 0, 0, 50)
espToggleBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
espToggleBtn.Text = "   ESP MM2 + Noms & Distances : OFF"
espToggleBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
espToggleBtn.TextSize = 14
espToggleBtn.Font = Enum.Font.GothamSemibold
espToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
espToggleBtn.LayoutOrder = 2
espToggleBtn.Parent = pages.ESP

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 14)
espCorner.Parent = espToggleBtn

local espData = {}

local function removeESP(plr)
	if espData[plr] then
		if espData[plr].Highlight then espData[plr].Highlight:Destroy() end
		if espData[plr].Billboard then espData[plr].Billboard:Destroy() end
		espData[plr] = nil
	end
end

local function updateESPForPlayer(plr)
	if not espEnabled then
		removeESP(plr)
		return
	end
	
	if plr == localPlayer then return end
	local char = plr.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then 
		removeESP(plr)
		return 
	end
	
	local rootPart = char.HumanoidRootPart
	local head = char:FindFirstChild("Head") or rootPart
	
	local role = "Innocent"
	local backpack = plr:FindFirstChild("Backpack")
	local function checkContainer(container)
		if not container then return end
		for _, item in ipairs(container:GetChildren()) do
			if item:IsA("Tool") then
				local name = item.Name:lower()
				if name == "knife" or name:find("couteau") then
					role = "Murderer"
				elseif name == "gun" or name == "revolver" or name:find("pistolet") then
					role = "Sheriff"
				end
			end
		end
	end
	
	checkContainer(backpack)
	checkContainer(char)
	
	local data = espData[plr]
	if not data then
		data = {}
		local highlight = Instance.new("Highlight")
		highlight.Name = "ESPHighlight_" .. plr.Name
		highlight.Adornee = char
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Parent = espFolder
		data.Highlight = highlight
		
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "ESPBillboard_" .. plr.Name
		billboard.Adornee = head
		billboard.Size = UDim2.new(0, 200, 0, 50)
		billboard.StudsOffset = Vector3.new(0, 2.5, 0)
		billboard.AlwaysOnTop = true
		billboard.Parent = espFolder
		
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "InfoText"
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.TextSize = 13
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextStrokeTransparency = 0
		textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel.Parent = billboard
		
		data.Billboard = billboard
		data.TextLabel = textLabel
		espData[plr] = data
	else
		data.Highlight.Adornee = char
		data.Billboard.Adornee = head
	end
	
	local distance = 0
	if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
		distance = math.floor((localPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude)
	end
	
	local color = Color3.fromRGB(50, 255, 50)
	local roleName = "Innocent"
	
	if role == "Murderer" then
		color = Color3.fromRGB(255, 50, 50)
		roleName = "Murder"
	elseif role == "Sheriff" then
		color = Color3.fromRGB(50, 120, 255)
		roleName = "Sheriff"
	end
	
	data.Highlight.FillColor = color
	data.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	data.Highlight.FillTransparency = (role == "Innocent") and 0.6 or 0.4
	
	data.TextLabel.Text = string.format("[%s] %s (%dm)", roleName, plr.Name, distance)
	data.TextLabel.TextColor3 = color
end

espToggleBtn.MouseButton1Click:Connect(function()
	playKeyboardSound()
	espEnabled = not espEnabled
	if espEnabled then
		espToggleBtn.Text = "   ESP MM2 + Noms & Distances : ON"
		espToggleBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
	else
		espToggleBtn.Text = "   ESP MM2 + Noms & Distances : OFF"
		espToggleBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
		for _, plr in ipairs(Players:GetPlayers()) do
			removeESP(plr)
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if espEnabled then
		for _, plr in ipairs(Players:GetPlayers()) do
			updateESPForPlayer(plr)
		end
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	removeESP(plr)
end)

-- No Clip Global Manuel (Bouton ESP)
local noClipEnabled = false
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(1, 0, 0, 50)
noclipBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
noclipBtn.Text = "   No Clip Manuel : OFF"
noclipBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
noclipBtn.TextSize = 14
noclipBtn.Font = Enum.Font.GothamSemibold
noclipBtn.TextXAlignment = Enum.TextXAlignment.Left
noclipBtn.LayoutOrder = 3
noclipBtn.Parent = pages.ESP

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 14)
noclipCorner.Parent = noclipBtn

noclipBtn.MouseButton1Click:Connect(function()
	playKeyboardSound()
	noClipEnabled = not noClipEnabled
	if noClipEnabled then
		noclipBtn.Text = "   No Clip Manuel : ON"
		noclipBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
	else
		noclipBtn.Text = "   No Clip Manuel : OFF"
		noclipBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
	end
end)

RunService.Stepped:Connect(function()
	if noClipEnabled and localPlayer.Character then
		for _, part in ipairs(localPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Freecam
local freecamEnabled = false
local freecamConn = nil
local freecamPos = Vector3.new(0, 10, 0)

local freecamBtn = Instance.new("TextButton")
freecamBtn.Size = UDim2.new(1, 0, 0, 50)
freecamBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
freecamBtn.Text = "   Freecam (Surveillance) : OFF"
freecamBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
freecamBtn.TextSize = 14
freecamBtn.Font = Enum.Font.GothamSemibold
freecamBtn.TextXAlignment = Enum.TextXAlignment.Left
freecamBtn.LayoutOrder = 4
freecamBtn.Parent = pages.ESP

local freecamCorner = Instance.new("UICorner")
freecamCorner.CornerRadius = UDim.new(0, 14)
freecamCorner.Parent = freecamBtn

local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "FreecamMobileOverlay"
mobileGui.ResetOnSpawn = false
mobileGui.Enabled = false
mobileGui.Parent = playerGui

local upMobileBtn = Instance.new("TextButton")
upMobileBtn.Size = UDim2.new(0, 60, 0, 60)
upMobileBtn.Position = UDim2.new(1, -140, 1, -140)
upMobileBtn.BackgroundColor3 = Color3.fromRGB(20, 24, 36)
upMobileBtn.BackgroundTransparency = 0.3
upMobileBtn.Text = "▲"
upMobileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
upMobileBtn.TextSize = 22
upMobileBtn.Parent = mobileGui

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(1, 0)
upCorner.Parent = upMobileBtn

local downMobileBtn = Instance.new("TextButton")
downMobileBtn.Size = UDim2.new(0, 60, 0, 60)
downMobileBtn.Position = UDim2.new(1, -70, 1, -140)
downMobileBtn.BackgroundColor3 = Color3.fromRGB(20, 24, 36)
downMobileBtn.BackgroundTransparency = 0.3
downMobileBtn.Text = "▼"
downMobileBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
downMobileBtn.TextSize = 22
downMobileBtn.Parent = mobileGui

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(1, 0)
downCorner.Parent = downMobileBtn

local mobileUpHeld = false
local mobileDownHeld = false

upMobileBtn.MouseButton1Down:Connect(function() mobileUpHeld = true end)
upMobileBtn.MouseButton1Up:Connect(function() mobileUpHeld = false end)
downMobileBtn.MouseButton1Down:Connect(function() mobileDownHeld = true end)
downMobileBtn.MouseButton1Up:Connect(function() mobileDownHeld = false end)

local function toggleFreecam(state)
	freecamEnabled = state
	if freecamEnabled then
		freecamBtn.Text = "   Freecam (Surveillance) : ON"
		freecamBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
		mobileGui.Enabled = true
		
		if Camera.CameraSubject then
			freecamPos = Camera.CFrame.Position
		end
		Camera.CameraType = Enum.CameraType.Scriptable
		
		freecamConn = RunService.RenderStepped:Connect(function(dt)
			local moveDir = Vector3.new()
			if UserInputService:IsKeyDown(Enum.KeyCode.Z) then moveDir = moveDir + Vector3.new(0, 0, -1) end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, 0, 1) end
			if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveDir = moveDir + Vector3.new(-1, 0, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(1, 0, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.E) or mobileUpHeld then moveDir = moveDir + Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.R) or mobileDownHeld then moveDir = moveDir + Vector3.new(0, -1, 0) end
			
			freecamPos = freecamPos + (Camera.CFrame:VectorToWorldSpace(moveDir) * (60 * dt * 0.9))
			Camera.CFrame = CFrame.new(freecamPos)
		end)
	else
		freecamBtn.Text = "   Freecam (Surveillance) : OFF"
		freecamBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
		mobileGui.Enabled = false
		if freecamConn then freecamConn:Disconnect() end
		Camera.CameraType = Enum.CameraType.Custom
		if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
			Camera.CameraSubject = localPlayer.Character.Humanoid
		end
	end
end

freecamBtn.MouseButton1Click:Connect(function()
	playKeyboardSound()
	toggleFreecam(not freecamEnabled)
end)

-- --- SYSTÈME AUTO-FARM INTELLIGENT (AVEC NO-CLIP FORCÉ EN DÉPLACEMENT) ---
local autoFarmEnabled = false 

local autofarmBtn = Instance.new("TextButton")
autofarmBtn.Size = UDim2.new(1, 0, 0, 50)
autofarmBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
autofarmBtn.Text = "   Auto-Farm Coins Intelligent : OFF"
autofarmBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
autofarmBtn.TextSize = 14
autofarmBtn.Font = Enum.Font.GothamSemibold
autofarmBtn.TextXAlignment = Enum.TextXAlignment.Left
autofarmBtn.LayoutOrder = 2
autofarmBtn.Parent = pages.AutoFarm

local autofarmCorner = Instance.new("UICorner")
autofarmCorner.CornerRadius = UDim.new(0, 14)
autofarmCorner.Parent = autofarmBtn

autofarmBtn.MouseButton1Click:Connect(function()
	playKeyboardSound()
	autoFarmEnabled = not autoFarmEnabled
	if autoFarmEnabled then
		autofarmBtn.Text = "   Auto-Farm : Actif (Recherche...)"
		autofarmBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
	else
		autofarmBtn.Text = "   Auto-Farm Coins Intelligent : OFF"
		autofarmBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
	end
end)

local function findNearestCoin()
	local nearest = nil
	local shortestDist = math.huge
	local char = localPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
	local rootPos = char.HumanoidRootPart.Position

	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			local nameLower = obj.Name:lower()
			if nameLower == "coin" or nameLower == "coins" or nameLower:find("coin") or nameLower:find("piece") or nameLower:find("pièce") then
				if obj.Position.Y > -5 and obj.Position.Y < 300 then
					local dist = (obj.Position - rootPos).Magnitude
					if dist < shortestDist then
						shortestDist = dist
						nearest = obj
					end
				end
			end
		end
	end
	return nearest
end

task.spawn(function()
	while true do
		if autoFarmEnabled then
			local char = localPlayer.Character
			local humanoid = char and char:FindFirstChildOfClass("Humanoid")
			local rootPart = char and char:FindFirstChild("HumanoidRootPart")
			
			if char and humanoid and rootPart then
				local coin = findNearestCoin()
				
				if coin and coin.Parent then
					-- S'il y a des pièces, on fonce à travers tout (No Clip actif)
					autofarmBtn.Text = "   Auto-Farm : En train de ramasser !"
					autofarmBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
					
					humanoid.PlatformStand = true
					local moveSpeed = 70 
					
					while autoFarmEnabled and coin and coin.Parent do
						-- Force le No Clip sur toutes les parties du personnage pendant qu'il bouge vers la pièce
						for _, part in ipairs(char:GetDescendants()) do
							if part:IsA("BasePart") then
								part.CanCollide = false
							end
						end
						
						local targetPos = Vector3.new(coin.Position.X, rootPart.Position.Y, coin.Position.Z)
						local distance = (rootPart.Position - targetPos).Magnitude
						
						if distance < 1.0 then break end
						
						local dt = RunService.RenderStepped:Wait()
						local currentPos = rootPart.Position
						local nextPos = currentPos:Lerp(targetPos, math.clamp(moveSpeed * dt / distance, 0, 1))
						
						rootPart.CFrame = CFrame.new(nextPos, nextPos + Camera.CFrame.LookVector)
						rootPart.AssemblyLinearVelocity = Vector3.zero
						rootPart.AssemblyAngularVelocity = Vector3.zero
					end
					
					humanoid.PlatformStand = false
				else
					-- S'il n'y a pas de pièces (lobby / fin de round), attente propre
					autofarmBtn.Text = "   Auto-Farm : En attente de pièces..."
					autofarmBtn.TextColor3 = Color3.fromRGB(255, 180, 50)
					humanoid.PlatformStand = false
					task.wait(0.5)
				end
			else
				task.wait(0.5)
			end
		else
			task.wait(0.2)
		end
	end
end)

local function findPlayerByRole(targetRole)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= localPlayer then
			local char = plr.Character
			local function checkContainer(container)
				if not container then return false end
				for _, item in ipairs(container:GetChildren()) do
					if item:IsA("Tool") then
						local name = item.Name:lower()
						if targetRole == "Murderer" and (name == "knife" or name:find("couteau")) then
							return true
						elseif targetRole == "Sheriff" and (name == "gun" or name == "revolver" or name:find("pistolet")) then
							return true
						end
					end
				end
				return false
			end
			
			if checkContainer(plr.Backpack) or (char and checkContainer(char)) then
				return plr
			end
		end
	end
	return nil
end

-- --- FONCTIONS DE CIBLE VITESSE ---
local targetMurderSpeedAvoid = false
local targetSheriffSpeedAvoid = false

local avoidMurderBtn = Instance.new("TextButton")
avoidMurderBtn.Size = UDim2.new(1, 0, 0, 50)
avoidMurderBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
avoidMurderBtn.Text = "   Esquive Rapide Meurtrier (Traversée Map) : OFF"
avoidMurderBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
avoidMurderBtn.TextSize = 14
avoidMurderBtn.Font = Enum.Font.GothamSemibold
avoidMurderBtn.TextXAlignment = Enum.TextXAlignment.Left
avoidMurderBtn.LayoutOrder = 3
avoidMurderBtn.Parent = pages.AutoFarm

local avoidMurderCorner = Instance.new("UICorner")
avoidMurderCorner.CornerRadius = UDim.new(0, 14)
avoidMurderCorner.Parent = avoidMurderBtn

avoidMurderBtn.MouseButton1Click:Connect(function()
	playKeyboardSound()
	targetMurderSpeedAvoid = not targetMurderSpeedAvoid
	if targetMurderSpeedAvoid then
		targetSheriffSpeedAvoid = false
		avoidMurderBtn.Text = "   Esquive Rapide Meurtrier (Traversée Map) : ON"
		avoidMurderBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
	else
		avoidMurderBtn.Text = "   Esquive Rapide Meurtrier (Traversée Map) : OFF"
		avoidMurderBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
	end
end)

local avoidSheriffBtn = Instance.new("TextButton")
avoidSheriffBtn.Size = UDim2.new(1, 0, 0, 50)
avoidSheriffBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
avoidSheriffBtn.Text = "   Esquive Rapide Sheriff (Traversée Map) : OFF"
avoidSheriffBtn.TextColor3 = Color3.fromRGB(50, 120, 255)
avoidSheriffBtn.TextSize = 14
avoidSheriffBtn.Font = Enum.Font.GothamSemibold
avoidSheriffBtn.TextXAlignment = Enum.TextXAlignment.Left
avoidSheriffBtn.LayoutOrder = 4
avoidSheriffBtn.Parent = pages.AutoFarm

local avoidSheriffCorner = Instance.new("UICorner")
avoidSheriffCorner.CornerRadius = UDim.new(0, 14)
avoidSheriffCorner.Parent = avoidSheriffBtn

avoidSheriffBtn.MouseButton1Click:Connect(function()
	playKeyboardSound()
	targetSheriffSpeedAvoid = not targetSheriffSpeedAvoid
	if targetSheriffSpeedAvoid then
		targetMurderSpeedAvoid = false
		avoidSheriffBtn.Text = "   Esquive Rapide Sheriff (Traversée Map) : ON"
		avoidSheriffBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
	else
		avoidSheriffBtn.Text = "   Esquive Rapide Sheriff (Traversée Map) : OFF"
		avoidSheriffBtn.TextColor3 = Color3.fromRGB(50, 120, 255)
	end
end)

RunService.RenderStepped:Connect(function(dt)
	local targetPlr = nil
	if targetMurderSpeedAvoid then
		targetPlr = findPlayerByRole("Murderer")
	elseif targetSheriffSpeedAvoid then
		targetPlr = findPlayerByRole("Sheriff")
	end
	
	if targetPlr and targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart") then
		local tRoot = targetPlr.Character.HumanoidRootPart
		local char = localPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			-- No Clip actif pendant l'esquive rapide
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
			
			local rootPart = char.HumanoidRootPart
			local awayDirection = (rootPart.Position - tRoot.Position).Unit
			if awayDirection.Magnitude == 0 then awayDirection = Vector3.new(1, 0, 0) end
			
			local strafePos = tRoot.Position + (Vector3.new(awayDirection.X, 0, awayDirection.Z).Unit * 35) + Vector3.new(math.sin(tick() * 10) * 15, 0, math.cos(tick() * 10) * 15)
			
			local currentPos = rootPart.Position
			local targetFinal = Vector3.new(strafePos.X, currentPos.Y, strafePos.Z)
			local nextPos = currentPos:Lerp(targetFinal, math.clamp(60 * dt, 0, 1))
			
			rootPart.CFrame = CFrame.new(nextPos, nextPos + Camera.CFrame.LookVector)
			rootPart.AssemblyLinearVelocity = Vector3.zero
		end
	end
end)

-- --- TP MAPS ---
local function createMapTpButton(mapName, targetPosOffset, order)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 50)
	btn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
	btn.Text = "   TP Map : " .. mapName
	btn.TextColor3 = Color3.fromRGB(240, 240, 250)
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamSemibold
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.LayoutOrder = order
	btn.Parent = pages.AutoFarm
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = btn
	
	btn.MouseButton1Click:Connect(function()
		playKeyboardSound()
		local char = localPlayer.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then return end
		
		local rootPart = char.HumanoidRootPart
		
		local foundPart = nil
		for _, obj in ipairs(Workspace:GetDescendants()) do
			if obj:IsA("BasePart") and (obj.Name:lower():find("spawn") or obj.Name:lower():find("lobby") or obj.Name:lower():find("floor") or obj.Name:lower():find("part")) then
				if obj.Position.Y > -10 and obj.Position.Y < 500 then
					foundPart = obj
					break
				end
			end
		end
		
		if foundPart then
			rootPart.CFrame = foundPart.CFrame + targetPosOffset
		else
			rootPart.CFrame = CFrame.new(0, 15, 0) + targetPosOffset
		end
	end)
end

createMapTpButton("Centre de la Map Active", Vector3.new(0, 3, 0), 5)
createMapTpButton("Zone Latérale Sécurisée", Vector3.new(20, 3, 0), 6)

local tpSpawnBtn = Instance.new("TextButton")
tpSpawnBtn.Size = UDim2.new(1, 0, 0, 50)
tpSpawnBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
tpSpawnBtn.Text = "   TP sur le Spawn de la Map"
tpSpawnBtn.TextColor3 = Color3.fromRGB(255, 220, 100)
tpSpawnBtn.TextSize = 14
tpSpawnBtn.Font = Enum.Font.GothamSemibold
tpSpawnBtn.TextXAlignment = Enum.TextXAlignment.Left
tpSpawnBtn.LayoutOrder = 7
tpSpawnBtn.Parent = pages.AutoFarm

local tpSpawnCorner = Instance.new("UICorner")
tpSpawnCorner.CornerRadius = UDim.new(0, 14)
tpSpawnCorner.Parent = tpSpawnBtn

tpSpawnBtn.MouseButton1Click:Connect(function()
	playKeyboardSound()
	local char = localPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	
	local targetCF = CFrame.new(0, 5, 0)
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if (obj:IsA("SpawnLocation") or obj.Name:lower():find("spawn")) and obj:IsA("BasePart") then
			targetCF = obj.CFrame + Vector3.new(0, 3, 0)
			break
		end
	end
	char.HumanoidRootPart.CFrame = targetCF
end)

-- --- ANGLAIS SHERIFF ---
local anglaisSheriffEnabled = false

local anglaisSheriffBtn = Instance.new("TextButton")
anglaisSheriffBtn.Size = UDim2.new(1, 0, 0, 50)
anglaisSheriffBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
anglaisSheriffBtn.Text = "   Anglais Sheriff (Auto Equip Arme Sheriff) : OFF"
anglaisSheriffBtn.TextColor3 = Color3.fromRGB(50, 120, 255)
anglaisSheriffBtn.TextSize = 14
anglaisSheriffBtn.Font = Enum.Font.GothamSemibold
anglaisSheriffBtn.TextXAlignment = Enum.TextXAlignment.Left
anglaisSheriffBtn.LayoutOrder = 8
anglaisSheriffBtn.Parent = pages.AutoFarm

local anglaisSheriffCorner = Instance.new("UICorner")
anglaisSheriffCorner.CornerRadius = UDim.new(0, 14)
anglaisSheriffCorner.Parent = anglaisSheriffBtn

anglaisSheriffBtn.MouseButton1Click:Connect(function()
	playKeyboardSound()
	anglaisSheriffEnabled = not anglaisSheriffEnabled
	if anglaisSheriffEnabled then
		anglaisSheriffBtn.Text = "   Anglais Sheriff (Auto Equip Arme Sheriff) : ON"
		anglaisSheriffBtn.TextColor3 = Color3.fromRGB(80, 255, 80)
	else
		anglaisSheriffBtn.Text = "   Anglais Sheriff (Auto Equip Arme Sheriff) : OFF"
		anglaisSheriffBtn.TextColor3 = Color3.fromRGB(50, 120, 255)
	end
end)

RunService.RenderStepped:Connect(function()
	if not anglaisSheriffEnabled then return end
	
	local char = localPlayer.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local backpack = localPlayer:FindFirstChild("Backpack")
	
	if not char or not humanoid then return end
	
	local hasGunEquipped = false
	for _, item in ipairs(char:GetChildren()) do
		if item:IsA("Tool") then
			local name = item.Name:lower()
			if name == "gun" or name == "revolver" or name:find("pistolet") then
				hasGunEquipped = true
				break
			end
		end
	end
	
	if not hasGunEquipped and backpack then
		for _, item in ipairs(backpack:GetChildren()) do
			if item:IsA("Tool") then
				local name = item.Name:lower()
				if name == "gun" or name == "revolver" or name:find("pistolet") then
					humanoid:EquipTool(item)
					break
				end
			end
		end
	end
	
	if not hasGunEquipped and (not backpack or not backpack:FindFirstChild("Gun")) then
		for _, obj in ipairs(Workspace:GetChildren()) do
			if obj:IsA("Tool") then
				local name = obj.Name:lower()
				if name == "gun" or name == "revolver" or name:find("pistolet") then
					local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
					if handle and char:FindFirstChild("HumanoidRootPart") then
						char.HumanoidRootPart.CFrame = handle.CFrame + Vector3.new(0, 1, 0)
					end
				end
			end
		end
	end
end)

-- Thèmes
local function createThemeOption(themeName, bgColor, order)
	local card = Instance.new("TextButton")
	card.Size = UDim2.new(1, 0, 0, 54)
	card.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
	card.Text = "   " .. themeName
	card.TextColor3 = Color3.fromRGB(240, 240, 250)
	card.TextSize = 15
	card.Font = Enum.Font.GothamSemibold
	card.TextXAlignment = Enum.TextXAlignment.Left
	card.LayoutOrder = order
	card.Parent = pages.Themes
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = card
	
	card.MouseButton1Click:Connect(function()
		playKeyboardSound()
		TweenService:Create(mainFrame, TweenInfo.new(0.4), { BackgroundColor3 = bgColor }):Play()
		TweenService:Create(sidebar, TweenInfo.new(0.4), { BackgroundColor3 = Color3.new(bgColor.R * 0.7, bgColor.G * 0.7, bgColor.B * 0.7) }):Play()
	end)
end

createThemeOption("Cyber Bleu Profond", Color3.fromRGB(12, 16, 28), 2)
createThemeOption("Néon Améthyste", Color3.fromRGB(22, 12, 30), 3)
createThemeOption("Emerald Sombre", Color3.fromRGB(10, 22, 16), 4)
createThemeOption("Obsidian Noir Pur", Color3.fromRGB(10, 10, 12), 5)

-- Styles de Fond
local function createBgStyleOption(styleName, modeKey, order)
	local card = Instance.new("TextButton")
	card.Size = UDim2.new(1, 0, 0, 54)
	card.BackgroundColor3 = Color3.fromRGB(22, 25, 36)
	card.Text = "   Style : " .. styleName
	card.TextColor3 = Color3.fromRGB(240, 240, 250)
	card.TextSize = 15
	card.Font = Enum.Font.GothamSemibold
	card.TextXAlignment = Enum.TextXAlignment.Left
	card.LayoutOrder = order
	card.Parent = pages.Backgrounds
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = card
	
	card.MouseButton1Click:Connect(function()
		playKeyboardSound()
		generateBackground(modeKey)
	end)
end

createBgStyleOption("Bulles Fluides", "Bubbles", 2)
createBgStyleOption("Cubes Géométriques", "Cubes", 3)
createBgStyleOption("Cristaux / Étoiles", "Stars", 4)

-- Fermeture / Réouverture
closeBtn.MouseButton1Click:Connect(function()
	playKeyboardSound()
	
	for i = 1, 40 do
		local bubble = Instance.new("Frame")
		local size = math.random(15, 50)
		bubble.Size = UDim2.new(0, size, 0, size)
		bubble.Position = mainFrame.Position + UDim2.new(math.random(), -340, math.random(), -220)
		bubble.BackgroundColor3 = Color3.fromRGB(math.random(100, 180), math.random(180, 255), 255)
		bubble.BackgroundTransparency = 0.15
		bubble.BorderSizePixel = 0
		bubble.ZIndex = 25
		bubble.Parent = screenGui
		
		local bCorner = Instance.new("UICorner")
		bCorner.CornerRadius = UDim.new(1, 0)
		bCorner.Parent = bubble
		
		local tw = TweenService:Create(bubble, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, 0, 0, 38),
			Size = UDim2.new(0, 2, 0, 2),
			BackgroundTransparency = 1,
			Rotation = 540
		})
		tw:Play()
		tw.Completed:Connect(function() bubble:Destroy() end)
	end
	
	TweenService:Create(mainCorner, TweenInfo.new(0.3), { CornerRadius = UDim.new(1, 0) }):Play()
	
	local shrinkTween = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0, 38)
	})
	shrinkTween:Play()
	
	shrinkTween.Completed:Connect(function()
		mainFrame.Visible = false
		
		miniButton.Size = UDim2.new(0, 0, 0, 0)
		miniButton.Visible = true
		TweenService:Create(miniButton, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 48, 0, 48)
		}):Play()
	end)
end)

miniButton.MouseButton1Click:Connect(function()
	playKeyboardSound()
	
	local miniTween = TweenService:Create(miniButton, TweenInfo.new(0.15), {
		Size = UDim2.new(0, 0, 0, 0)
	})
	miniTween:Play()
	
	miniTween.Completed:Connect(function()
		miniButton.Visible = false
		
		for i = 1, 40 do
			local bubble = Instance.new("Frame")
			local size = math.random(15, 50)
			bubble.Size = UDim2.new(0, 2, 0, 2)
			bubble.Position = UDim2.new(0.5, 0, 0, 38)
			bubble.BackgroundColor3 = Color3.fromRGB(math.random(100, 180), math.random(180, 255), 255)
			bubble.BackgroundTransparency = 0.15
			bubble.BorderSizePixel  = 0
			bubble.ZIndex = 25
			bubble.Parent = screenGui
			
			local bCorner = Instance.new("UICorner")
			bCorner.CornerRadius = UDim.new(1, 0)
			bCorner.Parent = bubble
			
			local targetPosX = 0.5 + (math.random() - 0.5) * 0.7
			local targetPosY = 0.5 + (math.random() - 0.5) * 0.7
			
			local tw = TweenService:Create(bubble, TweenInfo.new(0.4, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
				Position = UDim2.new(targetPosX, 0, targetPosY, 0),
				Size = UDim2.new(0, size, 0, size),
				BackgroundTransparency = 1,
				Rotation = -540
			})
			tw:Play()
			tw.Completed:Connect(function() bubble:Destroy() end)
		end
		
		mainFrame.Size = UDim2.new(0, 0, 0, 0)
		mainFrame.Position = UDim2.new(0.5, 0, 0, 38)
		mainCorner.CornerRadius = UDim.new(1, 0)
		mainFrame.Visible = true
		
		TweenService:Create(mainCorner, TweenInfo.new(0.4), { CornerRadius = UDim.new(0, 28) }):Play()
		TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 680, 0, 440),
			Position = UDim2.new(0.5, -340, 0.5, -220)
		}):Play()
	end)
end)

-- Animation initiale
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainCorner.CornerRadius = UDim.new(1, 0)
TweenService:Create(mainCorner, TweenInfo.new(0.5), { CornerRadius = UDim.new(0, 28) }):Play()
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 680, 0, 440),
	Position = UDim2.new(0.5, -340, 0.5, -220)
}):Play()
