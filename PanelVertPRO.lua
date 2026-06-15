local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local dragging = false
local dragStart = nil
local frameStart = nil

-- ═══════════════════════════════════════════════════════════
-- MAIN FRAME (Déplaçable)
-- ═══════════════════════════════════════════════════════════

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 500, 0, 600)
frame.Position = UDim2.new(0.5, -250, 0.5, -300)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = frame

local shadow = Instance.new("UIStroke")
shadow.Color = Color3.fromRGB(0, 200, 0)
shadow.Thickness = 3
shadow.Parent = frame

-- ═══════════════════════════════════════════════════════════
-- TOP BAR (Avec logo et boutons)
-- ═══════════════════════════════════════════════════════════

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 70)
topBar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
topBar.BorderSizePixel = 0
topBar.Parent = frame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 15)
topCorner.Parent = topBar

-- TITRE "nom sf" (Noir et Vert)
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextSize = 35
title.Font = Enum.Font.GothamBlack
title.Parent = topBar

-- Créer l'effet noir et vert avec deux labels
local titleText1 = Instance.new("TextLabel")
titleText1.Size = UDim2.new(1, 0, 1, 0)
titleText1.BackgroundTransparency = 1
titleText1.Text = "nom sf"
titleText1.TextColor3 = Color3.fromRGB(0, 0, 0)
titleText1.TextSize = 35
titleText1.Font = Enum.Font.GothamBlack
titleText1.Position = UDim2.new(0, 2, 0, 2)
titleText1.Parent = title

local titleText2 = Instance.new("TextLabel")
titleText2.Size = UDim2.new(1, 0, 1, 0)
titleText2.BackgroundTransparency = 1
titleText2.Text = "nom sf"
titleText2.TextColor3 = Color3.fromRGB(0, 200, 0)
titleText2.TextSize = 35
titleText2.Font = Enum.Font.GothamBlack
titleText2.Parent = title

-- BOUTON MINIMIZE
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 45, 0, 45)
minimizeBtn.Position = UDim2.new(1, -100, 0, 12.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minimizeBtn.Text = "−"
minimizeBtn.TextSize = 24
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = topBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

-- BOUTON MAXIMIZE
local maximizeBtn = Instance.new("TextButton")
maximizeBtn.Name = "MaximizeBtn"
maximizeBtn.Size = UDim2.new(0, 45, 0, 45)
maximizeBtn.Position = UDim2.new(1, -50, 0, 12.5)
maximizeBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
maximizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
maximizeBtn.Text = "+"
maximizeBtn.TextSize = 24
maximizeBtn.Font = Enum.Font.GothamBold
maximizeBtn.BorderSizePixel = 0
maximizeBtn.Parent = topBar

local maxCorner = Instance.new("UICorner")
maxCorner.CornerRadius = UDim.new(0, 8)
maxCorner.Parent = maximizeBtn

-- ═══════════════════════════════════════════════════════════
-- NAVIGATION BUTTONS
-- ═══════════════════════════════════════════════════════════

local navFrame = Instance.new("Frame")
navFrame.Name = "NavFrame"
navFrame.Size = UDim2.new(1, 0, 0, 60)
navFrame.Position = UDim2.new(0, 0, 0, 70)
navFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
navFrame.BorderSizePixel = 0
navFrame.Parent = frame

local navLayout = Instance.new("UIListLayout")
navLayout.FillDirection = Enum.FillDirection.Horizontal
navLayout.Padding = UDim.new(0, 10)
navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
navLayout.VerticalAlignment = Enum.VerticalAlignment.Center
navLayout.Parent = navFrame

-- BOUTON ACCUEIL
local accueilBtn = Instance.new("TextButton")
accueilBtn.Name = "AccueilBtn"
accueilBtn.Size = UDim2.new(0, 150, 0, 45)
accueilBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
accueilBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
accueilBtn.Text = "ACCUEIL"
accueilBtn.TextSize = 16
accueilBtn.Font = Enum.Font.GothamBold
accueilBtn.BorderSizePixel = 0
accueilBtn.Parent = navFrame

local accCorner = Instance.new("UICorner")
accCorner.CornerRadius = UDim.new(0, 8)
accCorner.Parent = accueilBtn

-- BOUTON DÉCOOL
local decoolBtn = Instance.new("TextButton")
decoolBtn.Name = "DecoolBtn"
decoolBtn.Size = UDim2.new(0, 150, 0, 45)
decoolBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
decoolBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
decoolBtn.Text = "DÉCOOL"
decoolBtn.TextSize = 16
decoolBtn.Font = Enum.Font.GothamBold
decoolBtn.BorderSizePixel = 0
decoolBtn.Parent = navFrame

local decCorner = Instance.new("UICorner")
decCorner.CornerRadius = UDim.new(0, 8)
decCorner.Parent = decoolBtn

-- ═══════════════════════════════════════════════════════════
-- CONTENT FRAME
-- ═══════════════════════════════════════════════════════════

local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -130)
contentFrame.Position = UDim2.new(0, 0, 0, 130)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = frame

-- PAGE ACCUEIL
local accueilPage = Instance.new("Frame")
accueilPage.Name = "AccueilPage"
accueilPage.Size = UDim2.new(1, 0, 1, 0)
accueilPage.BackgroundTransparency = 1
accueilPage.Parent = contentFrame
accueilPage.Visible = true

local accText = Instance.new("TextLabel")
accText.Size = UDim2.new(1, -20, 1, -20)
accText.Position = UDim2.new(0, 10, 0, 10)
accText.BackgroundTransparency = 1
accText.Text = "🏠 BIENVENUE\n\nCeci est ta page d'accueil!\n\nClique sur DÉCOOL pour plus d'options."
accText.TextColor3 = Color3.fromRGB(200, 200, 200)
accText.TextSize = 18
accText.Font = Enum.Font.Gotham
accText.TextWrapped = true
accText.Parent = accueilPage

-- PAGE DÉCOOL
local decoolPage = Instance.new("Frame")
decoolPage.Name = "DecoolPage"
decoolPage.Size = UDim2.new(1, 0, 1, 0)
decoolPage.BackgroundTransparency = 1
decoolPage.Parent = contentFrame
decoolPage.Visible = false

local decText = Instance.new("TextLabel")
decText.Size = UDim2.new(1, -20, 1, -20)
decText.Position = UDim2.new(0, 10, 0, 10)
decText.BackgroundTransparency = 1
decText.Text = "⚙️ OPTIONS DÉCOOL\n\nVoici les options spéciales:\n\n• Déplace le panel avec la souris\n• Utilise − pour rétrécir\n• Utilise + pour agrandir\n\nAmusement garanti! 🎮"
decText.TextColor3 = Color3.fromRGB(200, 200, 200)
decText.TextSize = 18
decText.Font = Enum.Font.Gotham
decText.TextWrapped = true
decText.Parent = decoolPage

-- ═══════════════════════════════════════════════════════════
-- NAVIGATION LOGIC
-- ═══════════════════════════════════════════════════════════

accueilBtn.MouseButton1Click:Connect(function()
    accueilPage.Visible = true
    decoolPage.Visible = false
    accueilBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    decoolBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
end)

decoolBtn.MouseButton1Click:Connect(function()
    accueilPage.Visible = false
    decoolPage.Visible = true
    accueilBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    decoolBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

-- ═══════════════════════════════════════════════════════════
-- DRAGGING LOGIC
-- ═══════════════════════════════════════════════════════════

local UserInputService = game:GetService("UserInputService")
local Mouse = game.Players.LocalPlayer:GetMouse()

topBar.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = Mouse.Position
        frameStart = frame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Mouse.Position - dragStart
        frame.Position = frameStart + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ═══════════════════════════════════════════════════════════
-- SIZE BUTTONS LOGIC
-- ═══════════════════════════════════════════════════════════

minimizeBtn.MouseButton1Click:Connect(function()
    frame:TweenSize(UDim2.new(0, 300, 0, 400), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
end)

maximizeBtn.MouseButton1Click:Connect(function()
    frame:TweenSize(UDim2.new(0, 700, 0, 800), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
end)

print("✅ Panel PRO chargé avec succès!")
