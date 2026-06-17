local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--------------------------------------------------
-- CLEAN UI & LIGHTING
--------------------------------------------------
local oldGui = PlayerGui:FindFirstChild("SF_HUB")
if oldGui then oldGui:Destroy() end

local oldBlur = Lighting:FindFirstChild("SF_Blur")
if oldBlur then oldBlur:Destroy() end

--------------------------------------------------
-- ROOT GUI
--------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "SF_HUB"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.Parent = PlayerGui

--------------------------------------------------
-- 🎨 PALETTE DE COULEURS & CONFIG STATE
--------------------------------------------------
local Theme = {
	Bg = Color3.fromRGB(11, 12, 16),
	Panel = Color3.fromRGB(18, 19, 26),
	Stroke = Color3.fromRGB(35, 38, 50),
	Text = Color3.fromRGB(240, 243, 250),
	Accent = Color3.fromRGB(0, 180, 255),
	Green = Color3.fromRGB(0, 220, 140)
}

local UI = {}
local toggleState = false
local CONFIG_FILE = "sf_config.json"

local function saveConfig()
	if writefile then
		local data = {
			ThemeColor = {Theme.Accent.R, Theme.Accent.G, Theme.Accent.B},
			Toggle = toggleState
		}
		writefile(CONFIG_FILE, HttpService:JSONEncode(data))
	end
end

local function loadConfig()
	if isfile and readfile and isfile(CONFIG_FILE) then
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(readfile(CONFIG_FILE))
		end)
		if success and decoded then
			if decoded.ThemeColor then
				Theme.Accent = Color3.new(decoded.ThemeColor[1], decoded.ThemeColor[2], decoded.ThemeColor[3])
			end
			if decoded.Toggle ~= nil then
				toggleState = decoded.Toggle
			end
		end
	end
end

loadConfig()

local function applyTheme(color)
	Theme.Accent = color
	if UI.openBtn and UI.stroke then
		UI.openBtn.BackgroundColor3 = color
		TweenService:Create(UI.stroke, TweenInfo.new(0.3), {Color = color}):Play()
	end
	saveConfig()
end

--------------------------------------------------
-- BLUR SYSTEM
--------------------------------------------------
local blur = Instance.new("BlurEffect")
blur.Name = "SF_Blur"
blur.Size = 0
blur.Parent = Lighting

local function blurToggle(state)
	TweenService:Create(blur, TweenInfo.new(0.2), {
		Size = state and 14 or 0
	}):Play()
end

--------------------------------------------------
-- SYSTEME DE DRAG
--------------------------------------------------
local function makeDraggable(dragFrame, moveFrame)
	local dragging, dragInput, dragStart, startPos

	dragFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = moveFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			TweenService:Create(moveFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			}):Play()
		end
	end)
end

--------------------------------------------------
-- BUILD MAIN UI
--------------------------------------------------
local function buildUI()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,500,0,320)
	frame.Position = UDim2.new(0.5,-250,0.5,-160)
	frame.BackgroundColor3 = Theme.Bg
	frame.Visible = false
	frame.Parent = gui
	
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 8)
	frameCorner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Accent
	stroke.Thickness = 1.5
	stroke.Parent = frame

	UI.frame = frame
	UI.stroke = stroke

	local openBtn = Instance.new("TextButton")
	openBtn.Size = UDim2.new(0,52,0,52)
	openBtn.Position = UDim2.new(0,20,0.5,-26)
	openBtn.Text = "SF"
	openBtn.Font = Enum.Font.GothamBold
	openBtn.TextSize = 20
	openBtn.TextColor3 = Theme.Bg
	openBtn.BackgroundColor3 = Theme.Accent
	openBtn.Parent = gui
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = openBtn

	UI.openBtn = openBtn

	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1,0,0,42)
	topBar.BackgroundColor3 = Theme.Panel
	topBar.Parent = frame
	
	local topCorner = Instance.new("UICorner")
	topCorner.CornerRadius = UDim.new(0, 8)
	topCorner.Parent = topBar
	
	makeDraggable(topBar, frame)

	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0,34,0,34)
	close.Position = UDim2.new(1,-38,0,4)
	close.Text = "×"
	close.Font = Enum.Font.GothamBold
	close.TextColor3 = Theme.Text
	close.BackgroundColor3 = Color3.fromRGB(240, 70, 80)
	close.Parent = topBar
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 6)
	closeCorner.Parent = close

	local side = Instance.new("Frame")
	side.Size = UDim2.new(0,130,1,-42)
	side.Position = UDim2.new(0,0,0,42)
	side.BackgroundColor3 = Theme.Panel
	side.Parent = frame
	
	local sideCorner = Instance.new("UICorner")
	sideCorner.CornerRadius = UDim.new(0, 8)
	sideCorner.Parent = side

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0,5)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Parent = side
	
	local sPadding = Instance.new("UIPadding")
	sPadding.PaddingTop = UDim.new(0, 5)
	sPadding.Parent = side

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1,-130,1,-42)
	content.Position = UDim2.new(0,130,0,42)
	content.BackgroundTransparency = 1
	content.Parent = frame

	local Pages = {}
	local Buttons = {}
	local Current = nil

	local function createPage(name)
		local p = Instance.new("Frame")
		p.Size = UDim2.new(1,0,1,0)
		p.BackgroundTransparency = 1
		p.Visible = false
		p.Parent = content
		Pages[name] = p
		return p
	end

	local function show(name)
		if Current == name then return end
		Current = name

		for _,p in pairs(Pages) do p.Visible = false end
		if Pages[name] then Pages[name].Visible = true end

		for _,b in pairs(Buttons) do b.BackgroundColor3 = Color3.fromRGB(26, 29, 38) end
		if Buttons[name] then Buttons[name].BackgroundColor3 = Theme.Accent end
	end

	local homePage = createPage("Home")
	local playerPage = createPage("Player")
	local evasionPage = createPage("Evasion")
	local visualsPage = createPage("Visuals")
	local themesPage = createPage("Themes")
	local settingsPage = createPage("Settings")
	local aboutPage = createPage("About")

	local function addSimpleText(page, text)
		local l = Instance.new("TextLabel")
		l.Size = UDim2.new(1,-20,1,-20)
		l.Position = UDim2.new(0,10,0,10)
		l.BackgroundTransparency = 1
		l.TextWrapped = true
		l.TextColor3 = Theme.Text
		l.Font = Enum.Font.Gotham
		l.TextSize = 15
		l.Text = text
		l.Parent = page
	end

	addSimpleText(homePage, "🌌 Bienvenue dans SF HUB V6\n\nVos préférences sont sauvegardées.")
	addSimpleText(aboutPage, "ℹ️ SF HUB V6\nSauvegarde Cloud/Locale active.")

	local function getHum(target)
		local char = target or Player.Character
		return char and char:FindFirstChildOfClass("Humanoid")
	end

	local function getRoot(target)
		local char = target or Player.Character
		return char and char:FindFirstChild("HumanoidRootPart")
	end

	local function createPlayerOption(name, default, callback)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(0.95, 0, 0, 28)
		row.BackgroundTransparency = 1
		row.Parent = playerPage

		local lab = Instance.new("TextLabel")
		lab.Size = UDim2.new(0.6, 0, 1, 0)
		lab.Text = name
		lab.TextColor3 = Theme.Text
		lab.Font = Enum.Font.GothamMedium
		lab.TextSize = 13
		lab.TextXAlignment = Enum.TextXAlignment.Left
		lab.BackgroundTransparency = 1
		lab.Parent = row

		local input = Instance.new("TextBox")
		input.Size = UDim2.new(0.35, 0, 0.9, 0)
		input.Position = UDim2.new(0.65, 0, 0.05, 0)
		input.BackgroundColor3 = Color3.fromRGB(26, 29, 38)
		input.Text = tostring(default)
		input.TextColor3 = Theme.Text
		input.Font = Enum.Font.Gotham
		input.TextSize = 12
		input.Parent = row
		local inputCorner = Instance.new("UICorner")
		inputCorner.Parent = input

		input.FocusLost:Connect(function()
			local num = tonumber(input.Text)
			if num then callback(num) end
		end)
	end

	local function createPlayerToggle(name, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.95, 0, 0, 28)
		btn.Text = name .. " : OFF"
		btn.BackgroundColor3 = Color3.fromRGB(26, 29, 38)
		btn.TextColor3 = Theme.Text
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 12
		btn.Parent = playerPage
		local corner = Instance.new("UICorner")
		corner.Parent = btn

		local state = false
		btn.MouseButton1Click:Connect(function()
			state = not state
			btn.Text = name .. (state and " : ON" or " : OFF")
			btn.BackgroundColor3 = state and Theme.Green or Color3.fromRGB(26, 29, 38)
			callback(state)
		end)
	end

	createPlayerOption("⚡ Vitesse", 16, function(val) local h = getHum() if h then h.WalkSpeed = val end end)
	createPlayerOption("🦘 Saut", 50, function(val) local h = getHum() if h then h.UseJumpPower = true; h.JumpPower = val end end)

	local evLayout = Instance.new("UIListLayout")
	evLayout.Padding = UDim.new(0, 12)
	evLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	evLayout.Parent = evasionPage
	local evPadding = Instance.new("UIPadding")
	evPadding.PaddingTop = UDim.new(0, 15)
	evPadding.Parent = evasionPage

	local statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(0.9, 0, 0, 30)
	statusLabel.Text = "Statut : En attente..."
	statusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Parent = evasionPage

	local autoEscapeBtn = Instance.new("TextButton")
	autoEscapeBtn.Size = UDim2.new(0.9, 0, 0, 45)
	autoEscapeBtn.Text = "⚡ RECHERCHE & DÉCOLLE AUTO"
	autoEscapeBtn.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
	autoEscapeBtn.Parent = evasionPage
	Instance.new("UICorner", autoEscapeBtn)

	autoEscapeBtn.MouseButton1Click:Connect(function()
		local char = Player.Character
		local root = getRoot(char)
		local hum = getHum(char)
		if not root or not hum then return end
		statusLabel.Text = "🔍 Analyse..."
		hum.Sit = false
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		
		local foundTarget = false
		local targetCFrame = nil
		local keywords = {"toilet", "wc", "escape", "sorti", "evas", "decolle"}
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") or obj:IsA("Model") then
				local nameLower = string.lower(obj.Name)
				for _, keyword in pairs(keywords) do
					if string.find(nameLower, keyword) then
						foundTarget = true
						targetCFrame = obj:IsA("BasePart") and obj.CFrame or (obj:GetPrimaryPartCFrame() or obj:FindFirstChildWhichIsA("BasePart").CFrame)
						break
					end
				end
			end
			if foundTarget then break end
		end

		if foundTarget and targetCFrame then
			root.Velocity = Vector3.new(0, 0, 0)
			root.CFrame = targetCFrame * CFrame.new(0, 4, 0)
		else
			root.Velocity = Vector3.new(0, 0, 0)
			root.CFrame = root.CFrame * CFrame.new(0, 65, 0)
		end
		statusLabel.Text = "✅ Libéré !"
		task.wait(2)
		statusLabel.Text = "Statut : En attente..."
	end)

	local function createTab(name, text)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1,-12,0,34)
		b.Text = text
		b.BackgroundColor3 = Color3.fromRGB(26, 29, 38)
		b.Parent = side
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		b.MouseButton1Click:Connect(function() show(name) end)
		Buttons[name] = b
	end

	createTab("Home","🏠 Home")
	createTab("Player","👤 Player")
	createTab("Evasion", "🚪 Évasion")
	createTab("Visuals", "👁️ Visuals")
	createTab("Themes","🎨 Themes")
	createTab("Settings","⚙️ Settings")
	createTab("About","ℹ️ About")

	show("Home")

	local opened = true
	local function closeUI()
		if not opened then return end
		opened = false
		local t = TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0,0,0,0)})
		t:Play()
		t.Completed:Connect(function() if not opened then frame.Visible = false end end)
		blurToggle(false)
	end

	openBtn.MouseButton1Click:Connect(function() 
		if opened then closeUI() else 
			opened = true
			frame.Visible = true
			TweenService:Create(frame, TweenInfo.new(0.25), {Size = UDim2.new(0,500,0,320)}):Play()
			blurToggle(true)
		end 
	end)
	close.MouseButton1Click:Connect(closeUI)
end

local function makeKeyUI()
	local VALID_KEY = "SFAR"
	local KEY_FILE = "sf_key.txt"
	if isfile and readfile and isfile(KEY_FILE) then
		if readfile(KEY_FILE) == VALID_KEY then buildUI(); return end
	end
	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0,320,0,190); frame.Position = UDim2.new(0.5,-160,0.5,-95)
	frame.BackgroundColor3 = Theme.Bg
	Instance.new("UICorner", frame)
	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(0.9,0,0,40); box.Position = UDim2.new(0.05,0,0.4,0); box.PlaceholderText = "Entrez la clé..."
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9,0,0,35); btn.Position = UDim2.new(0.05,0,0.7,0); btn.Text = "DEVERROUILLER"
	btn.MouseButton1Click:Connect(function()
		if box.Text == VALID_KEY then
			if writefile then writefile(KEY_FILE, VALID_KEY) end
			frame:Destroy()
			buildUI()
		end
	end)
end

makeKeyUI()