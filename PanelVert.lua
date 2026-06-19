local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Variable globale UI sécurisée
local UI = {}

--------------------------------------------------
-- CLEAN UI
--------------------------------------------------
local old = PlayerGui:FindFirstChild("SF_HUB")
if old then old:Destroy() end

--------------------------------------------------
-- ROOT GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "SF_HUB"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = PlayerGui

--------------------------------------------------
-- 🔐 KEY SYSTEM
--------------------------------------------------
local VALID_KEY = "SFAR"
local unlocked = false

local function makeKeyUI()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,320,0,190)
	frame.Position = UDim2.new(0.5,-160,0.5,-95)
	frame.BackgroundColor3 = Color3.fromRGB(18,18,22)
	frame.Parent = gui
	Instance.new("UICorner", frame)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,0,0,40)
	title.BackgroundTransparency = 1
	title.Text = "🔐 ACCESS REQUIRED"
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextColor3 = Color3.fromRGB(235,235,235)
	title.Parent = frame

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.9,0,0,40)
	box.Position = UDim2.new(0.05,0,0.4,0)
	box.PlaceholderText = "Enter key..."
	box.Text = ""
	box.Font = Enum.Font.Gotham
	box.TextSize = 16
	box.TextColor3 = Color3.new(1,1,1)
	box.BackgroundColor3 = Color3.fromRGB(30,30,40)
	box.Parent = frame
	Instance.new("UICorner", box)

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.9,0,0,35)
	btn.Position = UDim2.new(0.05,0,0.7,0)
	btn.Text = "UNLOCK"
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(120,170,255)
	btn.Parent = frame
	Instance.new("UICorner", btn)

	local errorLabel = Instance.new("TextLabel")
	errorLabel.Size = UDim2.new(1,0,0,20)
	errorLabel.Position = UDim2.new(0,0,1,-20)
	errorLabel.BackgroundTransparency = 1
	errorLabel.Text = ""
	errorLabel.TextColor3 = Color3.fromRGB(255,80,80)
	errorLabel.Font = Enum.Font.Gotham
	errorLabel.TextSize = 14
	errorLabel.Parent = frame

	btn.MouseButton1Click:Connect(function()
		if box.Text == VALID_KEY then
			unlocked = true
			frame:Destroy()
			buildUI()
		else
			errorLabel.Text = "Wrong key"
			task.wait(1)
			errorLabel.Text = ""
		end
	end)
end

--------------------------------------------------
-- 🎨 THEME SYSTEM V6
--------------------------------------------------
local Theme = {
	Bg = Color3.fromRGB(18,18,22),
	Panel = Color3.fromRGB(28,28,35),
	Stroke = Color3.fromRGB(90,100,120),
	Text = Color3.fromRGB(235,235,235),
	Accent = Color3.fromRGB(120,170,255),
	Accent2 = Color3.fromRGB(170,120,255),
	Green = Color3.fromRGB(90,200,160)
}

local function applyTheme(color)
	Theme.Accent = color
	if UI.openBtn and UI.stroke then
		UI.openBtn.BackgroundColor3 = color
		UI.stroke.Color = color
	end
end

--------------------------------------------------
-- BLUR
--------------------------------------------------
local blur = Lighting:FindFirstChild("SF_Blur") or Instance.new("BlurEffect")
blur.Name = "SF_Blur"
blur.Size = 0
blur.Parent = Lighting

local function blurToggle(state)
	TweenService:Create(blur, TweenInfo.new(0.2), {
		Size = state and 14 or 0
	}):Play()
end

--------------------------------------------------
-- BUILD UI (après key)
--------------------------------------------------
function buildUI()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,650,0,420)
	frame.Position = UDim2.new(0.5,-325,0.5,-210)
	frame.BackgroundColor3 = Theme.Bg
	frame.Visible = false
	frame.Parent = gui
	Instance.new("UICorner", frame)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Stroke
	stroke.Thickness = 2
	stroke.Parent = frame

	UI.frame = frame
	UI.stroke = stroke

	--------------------------------------------------
	-- OPEN BUTTON
	--------------------------------------------------
	local openBtn = Instance.new("TextButton")
	openBtn.Size = UDim2.new(0,52,0,52)
	openBtn.Position = UDim2.new(0,20,0.5,-26)
	openBtn.Text = "SF"
	openBtn.Font = Enum.Font.GothamBold
	openBtn.TextSize = 20
	openBtn.TextColor3 = Theme.Text
	openBtn.BackgroundColor3 = Theme.Accent
	openBtn.Parent = gui
	Instance.new("UICorner", openBtn)

	UI.openBtn = openBtn

	--------------------------------------------------
	-- TOPBAR (SUPPORT DRAG)
	--------------------------------------------------
	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1,0,0,42)
	topBar.BackgroundColor3 = Theme.Panel
	topBar.Parent = frame
	Instance.new("UICorner", topBar)

	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0,34,0,34)
	close.Position = UDim2.new(1,-38,0,4)
	close.Text = "×"
	close.Font = Enum.Font.GothamBold
	close.TextColor3 = Theme.Text
	close.BackgroundColor3 = Color3.fromRGB(200,80,80)
	close.Parent = topBar
	Instance.new("UICorner", close)

	-- Système de Drag (Glisser-déposer)
	local dragging, dragInput, dragStart, startPos
	local function updateDrag(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	topBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then updateDrag(input) end
	end)

	--------------------------------------------------
	-- SIDEBAR
	--------------------------------------------------
	local side = Instance.new("Frame")
	side.Size = UDim2.new(0,160,1,-42)
	side.Position = UDim2.new(0,0,0,42)
	side.BackgroundColor3 = Theme.Panel
	side.Parent = frame
	Instance.new("UICorner", side)

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,6)
	layout.Parent = side

	--------------------------------------------------
	-- CONTENT
	--------------------------------------------------
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1,-160,1,-42)
	content.Position = UDim2.new(0,160,0,42)
	content.BackgroundTransparency = 1
	content.Parent = frame

	local Pages = {}
	local Buttons = {}
	local Current = nil

	local function createPage(name, text)
		local p = Instance.new("Frame")
		p.Size = UDim2.new(1,0,1,0)
		p.BackgroundTransparency = 1
		p.Visible = false
		p.Parent = content

		local l = Instance.new("TextLabel")
		l.Size = UDim2.new(1,-10,0,40)
		l.Position = UDim2.new(0,5,0,5)
		l.BackgroundTransparency = 1
		l.TextColor3 = Theme.Text
		l.Font = Enum.Font.GothamBold
		l.TextSize = 18
		l.Text = text
		l.Parent = p

		Pages[name] = p
	end

	local function show(name)
		if Current == name then return end
		Current = name

		for _,p in pairs(Pages) do
			p.Visible = false
		end

		local t = Pages[name]
		if t then t.Visible = true end

		for _,b in pairs(Buttons) do
			b.BackgroundColor3 = Color3.fromRGB(40,40,50)
		end

		if Buttons[name] then
			Buttons[name].BackgroundColor3 = Theme.Accent
		end
	end

	--------------------------------------------------
	-- PAGES INITIALIZATION
	--------------------------------------------------
	createPage("Home","🏠 Bienvenue dans SF")
	createPage("Player","👤 Player Options")
	createPage("Themes","🎨 Theme Selector")
	createPage("Settings","⚙️ Settings Panel")
	createPage("About","ℹ️ About SF HUB V6")

	--------------------------------------------------
	-- 🚀 FONCTIONNALITÉ : TP BASS (PLUT GARDEN)
	--------------------------------------------------
	local playerPage = Pages["Player"]

	local tpBtn = Instance.new("TextButton")
	tpBtn.Size = UDim2.new(0,200,0,40)
	tpBtn.Position = UDim2.new(0,15,0,60)
	tpBtn.Text = "🌀 TP Plut Garden (Bass)"
	tpBtn.Font = Enum.Font.GothamBold
	tpBtn.TextSize = 14
	tpBtn.BackgroundColor3 = Color3.fromRGB(45, 50, 65)
	tpBtn.TextColor3 = Theme.Text
	tpBtn.Parent = playerPage
	Instance.new("UICorner", tpBtn)

	-- Logique d'analyse et de TP Triangle/Bass bypass
	tpBtn.MouseButton1Click:Connect(function()
		local char = Player.Character
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		
		if hrp then
			-- 1. Recherche dynamique de la zone du Jardin (Plut Garden) dans la map
			local targetPart = workspace:FindFirstChild("Plut Garden", true) or workspace:FindFirstChild("Garden", true)
			local targetPos
			
			if targetPart and targetPart:IsA("BasePart") then
				targetPos = targetPart.Position + Vector3.new(0, 3, 0) -- Se pose un peu au-dessus
			else
				-- Coordonnées de secours si l'objet n'est pas trouvé par son nom exact
				targetPos = Vector3.new(120, 5, -250) 
			end
			
			-- 2. DÉBUT DU TP BASS BYPASS (Pattern en triangle lointain vers le bas)
			-- Étape A : On descend instantanément très loin en dessous pour casser l'anti-cheat
			hrp.CFrame = CFrame.new(hrp.Position.X, -400, hrp.Position.Z)
			task.wait(0.15)
			
			-- Étape B : On se déplace horizontalement sous la map vers les coordonnées x, z de la base
			hrp.CFrame = CFrame.new(targetPos.X, -400, targetPos.Z)
			task.wait(0.15)
			
			-- Étape C : Réapparition sécurisée au point final (Plut Garden)
			hrp.CFrame = CFrame.new(targetPos)
		else
			tpBtn.Text = "❌ Character non trouvé"
			task.wait(1)
			tpBtn.Text = "🌀 TP Plut Garden (Bass)"
		end
	end)

	--------------------------------------------------
	-- SETTINGS
	--------------------------------------------------
	local settings = Pages["Settings"]

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0,140,0,30)
	toggle.Position = UDim2.new(0,10,0,60)
	toggle.Text = "Toggle: OFF"
	toggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
	toggle.TextColor3 = Theme.Text
	toggle.Parent = settings
	Instance.new("UICorner", toggle)

	local state = false
	toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = state and "Toggle: ON" or "Toggle: OFF"
	end)

	--------------------------------------------------
	-- THEMES
	--------------------------------------------------
	local function addTheme(color, x)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(0,100,0,30)
		b.Position = UDim2.new(0,x,0,60)
		b.BackgroundColor3 = color
		b.Text = ""
		b.Parent = Pages["Themes"]
		Instance.new("UICorner", b)

		b.MouseButton1Click:Connect(function()
			applyTheme(color)
		end)
	end

	addTheme(Theme.Accent, 10)
	addTheme(Theme.Accent2, 120)
	addTheme(Theme.Green, 230)

	--------------------------------------------------
	-- TABS SIDEBAR
	--------------------------------------------------
	local function tab(name, text)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1,-8,0,32)
		b.Text = text
		b.BackgroundColor3 = Color3.fromRGB(40,40,50)
		b.TextColor3 = Theme.Text
		b.Parent = side
		Instance.new("UICorner", b)

		b.MouseButton1Click:Connect(function()
			show(name)
		end)

		Buttons[name] = b
	end

	tab("Home","🏠 Home")
	tab("Player","👤 Player")
	tab("Themes","🎨 Themes")
	tab("Settings","⚙️ Settings")
	tab("About","ℹ️ About")

	show("Home")

	--------------------------------------------------
	-- OPEN / CLOSE LOGIC
	--------------------------------------------------
	local opened = false

	local function open()
		if opened then return end
		opened = true

		frame.Visible = true
		frame.Size = UDim2.new(0,0,0,0)

		TweenService:Create(frame, TweenInfo.new(0.25), {
			Size = UDim2.new(0,650,0,420)
		}):Play()

		blurToggle(true)
	end

	local function closeUI()
		opened = false

		local t = TweenService:Create(frame, TweenInfo.new(0.2), {
			Size = UDim2.new(0,0,0,0)
		})

		t:Play()
		t.Completed:Connect(function()
			frame.Visible = false
		end)

		blurToggle(false)
	end

	openBtn.MouseButton1Click:Connect(function()
		if opened then closeUI() else open() end
	end)

	close.MouseButton1Click:Connect(closeUI)
end

--------------------------------------------------
-- START
--------------------------------------------------
makeKeyUI()
