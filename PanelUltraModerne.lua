local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local dragging = false
local dragStart = nil
local frameStart = nil

-- MAIN FRAME (Ultra moderne)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 600)
frame.Position = UDim2.new(0.5, -250, 0.5, -300)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

-- Coins arrondis
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = frame

-- Ombre/Glow
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(0, 200, 100)
stroke.Thickness = 2
stroke.Parent = frame

-- TOP BAR DÉGRADÉ (Draggable)
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 70)
topBar.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
topBar.BorderSizePixel = 0
topBar.Parent = frame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 20)
topCorner.Parent = topBar

-- TITRE "nom sf" (NOIR + VERT avec ombre)
local titleBg = Instance.new("TextLabel")
titleBg.Size = UDim2.new(0.7, 0, 1, 0)
titleBg.Position = UDim2.new(0.05, 0, 0, 0)
titleBg.BackgroundTransparency = 1
titleBg.Parent = topBar

-- Texte noir (ombre)
local titleBlack = Instance.new("TextLabel")
titleBlack.Size = UDim2.new(1, 0, 1, 0)
titleBlack.BackgroundTransparency = 1
titleBlack.Text = "nom sf"
titleBlack.TextColor3 = Color3.fromRGB(0, 0, 0)
titleBlack.TextSize = 36
titleBlack.Font = Enum.Font.GothamBlack
titleBlack.Position = UDim2.new(0, 2, 0, 2)
titleBlack.Parent = titleBg

-- Texte vert
local titleGreen = Instance.new("TextLabel")
titleGreen.Size = UDim2.new(1, 0, 1, 0)
titleGreen.BackgroundTransparency = 1
titleGreen.Text = "nom sf"
titleGreen.TextColor3 = Color3.fromRGB(255, 255, 255)
titleGreen.TextSize = 36
titleGreen.Font = Enum.Font.GothamBlack
titleGreen.Parent = titleBg

-- BOUTON FERMER (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 50, 0, 50)
closeBtn.Position = UDim2.new(1, -60, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 71, 87)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Text = "✕"
closeBtn.TextSize = 26
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 100
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeBtn

-- Hover effect
closeBtn.MouseEnter:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 70)
end)

closeBtn.MouseLeave:Connect(function()
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 71, 87)
end)

-- NAV BUTTONS FRAME
local navFrame = Instance.new("Frame")
navFrame.Size = UDim2.new(1, 0, 0, 60)
navFrame.Position = UDim2.new(0, 0, 0, 70)
navFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
navFrame.BorderSizePixel = 0
navFrame.Parent = frame

local navLayout = Instance.new("UIListLayout")
navLayout.FillDirection = Enum.FillDirection.Horizontal
navLayout.Padding = UDim.new(0, 10)
navLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
navLayout.VerticalAlignment = Enum.VerticalAlignment.Center
navLayout.Parent = navFrame

-- BOUTON ACCUEIL
local accBtn = Instance.new("TextButton")
accBtn.Name = "AccBtn"
accBtn.Size = UDim2.new(0, 160, 0, 45)
accBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
accBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
accBtn.Text = "🏠 ACCUEIL"
accBtn.TextSize = 16
accBtn.Font = Enum.Font.GothamBold
accBtn.BorderSizePixel = 0
accBtn.Parent = navFrame

local accCorner = Instance.new("UICorner")
accCorner.CornerRadius = UDim.new(0, 8)
accCorner.Parent = accBtn

-- BOUTON DÉCOOL
local decBtn = Instance.new("TextButton")
decBtn.Name = "DecBtn"
decBtn.Size = UDim2.new(0, 160, 0, 45)
decBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
decBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
decBtn.Text = "⚙️ DÉCOOL"
decBtn.TextSize = 16
decBtn.Font = Enum.Font.GothamBold
decBtn.BorderSizePixel = 0
decBtn.Parent = navFrame

local decCorner = Instance.new("UICorner")
decCorner.CornerRadius = UDim.new(0, 8)
decCorner.Parent = decBtn

-- CONTENT FRAME
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -130)
contentFrame.Position = UDim2.new(0, 0, 0, 130)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = frame

-- PAGE ACCUEIL
local accPage = Instance.new("TextLabel")
accPage.Size = UDim2.new(1, 0, 1, 0)
accPage.BackgroundTransparency = 1
accPage.TextColor3 = Color3.fromRGB(200, 200, 200)
accPage.TextSize = 18
accPage.Font = Enum.Font.Gotham
accPage.TextWrapped = true
accPage.Text = "🏠 BIENVENUE SUR NOM SF\n\nBienvenue dans l'interface!\n\nClique sur DÉCOOL pour accéder aux options spéciales."
accPage.Parent = contentFrame
accPage.Visible = true

-- PAGE DÉCOOL
local decPage = Instance.new("TextLabel")
decPage.Size = UDim2.new(1, 0, 1, 0)
decPage.BackgroundTransparency = 1
decPage.TextColor3 = Color3.fromRGB(200, 200, 200)
decPage.TextSize = 18
decPage.Font = Enum.Font.Gotham
decPage.TextWrapped = true
decPage.Text = "⚙️ OPTIONS DÉCOOL\n\n✨ Fonctionnalités:\n\n• 🖱️ Déplace le panel\n• ✕ Ferme le panel\n• − Réduit le panel\n• + Agrandit le panel\n\n💚 Ultra moderne et fluide!"
decPage.Parent = contentFrame
decPage.Visible = false

-- NAVIGATION LOGIC
accBtn.MouseButton1Click:Connect(function()
    accPage.Visible = true
    decPage.Visible = false
    accBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    decBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
end)

decBtn.MouseButton1Click:Connect(function()
    accPage.Visible = false
    decPage.Visible = true
    accBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
    decBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 150)
end)

-- CLOSE BUTTON
closeBtn.MouseButton1Click:Connect(function()
    frame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.4, true)
    wait(0.4)
    frame.Visible = false
    print("❌ Panel fermé")
end)

-- DRAGGING (TopBar)
local Mouse = game.Players.LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")

topBar.InputBegan:Connect(function(input, gp)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = Mouse.Position
        frameStart = frame.Position
    end
end)

UIS.InputChanged:Connect(function(input, gp)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = Mouse.Position - dragStart
        frame.Position = frameStart + UDim2.new(0, delta.X, 0, delta.Y)
    end
end)

UIS.InputEnded:Connect(function(input, gp)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("✅✅✅ PANEL ULTRA MODERNE CHARGÉ! ✅✅✅")
