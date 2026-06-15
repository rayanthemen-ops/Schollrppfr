local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local dragging = false
local dragStart = nil
local frameStart = nil

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 500)
frame.Position = UDim2.new(0.5, -225, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 200, 0)
frame.Parent = gui

-- TOP BAR
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 60)
topBar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
topBar.BorderSizePixel = 0
topBar.Parent = frame

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0.05, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "nom sf"
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.TextSize = 32
title.Font = Enum.Font.GothamBlack
title.Parent = topBar

-- GREEN OUTLINE EFFECT
local title2 = Instance.new("TextLabel")
title2.Size = UDim2.new(0.6, 0, 1, 0)
title2.Position = UDim2.new(0.052, 0, 0, 0)
title2.BackgroundTransparency = 1
title2.Text = "nom sf"
title2.TextColor3 = Color3.fromRGB(0, 200, 0)
title2.TextSize = 32
title2.Font = Enum.Font.GothamBlack
title2.Parent = topBar

-- MINIMIZE BUTTON
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 40, 0, 40)
minBtn.Position = UDim2.new(1, -85, 0, 10)
minBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
minBtn.Text = "−"
minBtn.TextSize = 20
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
minBtn.Parent = topBar

-- MAXIMIZE BUTTON
local maxBtn = Instance.new("TextButton")
maxBtn.Size = UDim2.new(0, 40, 0, 40)
maxBtn.Position = UDim2.new(1, -40, 0, 10)
maxBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
maxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
maxBtn.Text = "+"
maxBtn.TextSize = 20
maxBtn.Font = Enum.Font.GothamBold
maxBtn.BorderSizePixel = 0
maxBtn.Parent = topBar

-- NAV BUTTONS
local navFrame = Instance.new("Frame")
navFrame.Size = UDim2.new(1, 0, 0, 50)
navFrame.Position = UDim2.new(0, 0, 0, 60)
navFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
navFrame.BorderSizePixel = 0
navFrame.Parent = frame

local accBtn = Instance.new("TextButton")
accBtn.Size = UDim2.new(0.5, -5, 1, 0)
accBtn.Position = UDim2.new(0, 5, 0, 0)
accBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
accBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
accBtn.Text = "ACCUEIL"
accBtn.TextSize = 14
accBtn.Font = Enum.Font.GothamBold
accBtn.BorderSizePixel = 0
accBtn.Parent = navFrame

local decBtn = Instance.new("TextButton")
decBtn.Size = UDim2.new(0.5, -5, 1, 0)
decBtn.Position = UDim2.new(0.5, 5, 0, 0)
decBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
decBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
decBtn.Text = "DÉCOOL"
decBtn.TextSize = 14
decBtn.Font = Enum.Font.GothamBold
decBtn.BorderSizePixel = 0
decBtn.Parent = navFrame

-- CONTENT
local content = Instance.new("TextLabel")
content.Size = UDim2.new(1, 0, 1, -110)
content.Position = UDim2.new(0, 0, 0, 110)
content.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
content.BorderSizePixel = 0
content.TextColor3 = Color3.fromRGB(200, 200, 200)
content.TextSize = 16
content.Font = Enum.Font.Gotham
content.TextWrapped = true
content.Text = "🏠 BIENVENUE\n\nCliquez sur DÉCOOL pour voir plus!"
content.Parent = frame

-- NAVIGATION
local pageAcc = true
accBtn.MouseButton1Click:Connect(function()
    pageAcc = true
    content.Text = "🏠 BIENVENUE\n\nCliquez sur DÉCOOL pour voir plus!"
    accBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    decBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
end)

decBtn.MouseButton1Click:Connect(function()
    pageAcc = false
    content.Text = "⚙️ OPTIONS\n\n• Déplacez le panel\n• Bouton − pour rétrécir\n• Bouton + pour agrandir\n\nAmusement garantit!"
    accBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    decBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
end)

-- DRAGGING
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

-- SIZE BUTTONS
minBtn.MouseButton1Click:Connect(function()
    frame:TweenSize(UDim2.new(0, 280, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
end)

maxBtn.MouseButton1Click:Connect(function()
    frame:TweenSize(UDim2.new(0, 600, 0, 700), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
end)

print("Panel PRO chargé!")
