-- Script exécutable Delta pour Roblox
-- Panel vert avec "nom sf"

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local panelOpen = true
local screenGui
local mainPanel
local toggleButton

-- Créer le panel
local function createPanel()
    -- Nettoyer l'ancienne GUI si elle existe
    if playerGui:FindFirstChild("GreenPanelGui") then
        playerGui:FindFirstChild("GreenPanelGui"):Destroy()
    end

    -- ScreenGui principal
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GreenPanelGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    -- Panel principal (VERT)
    mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 500, 0, 350)
    mainPanel.Position = UDim2.new(0.5, -250, 0.5, -175)
    mainPanel.BackgroundColor3 = Color3.fromRGB(0, 180, 0) -- Vert vif
    mainPanel.BorderSizePixel = 2
    mainPanel.BorderColor3 = Color3.fromRGB(0, 120, 0)
    mainPanel.Parent = screenGui

    -- Coins arrondis
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainPanel

    -- Ombre du panel
    local shadow = Instance.new("UIStroke")
    shadow.Color = Color3.fromRGB(0, 0, 0)
    shadow.Thickness = 3
    shadow.Parent = mainPanel

    -- Texte "nom sf" GRAND
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 1, -60)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "nom sf"
    titleLabel.TextSize = 120
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextScaled = true
    titleLabel.Parent = mainPanel

    -- Bouton FERMER (X) - Haut Droit
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 60, 0, 60)
    closeButton.Position = UDim2.new(1, -70, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "✕"
    closeButton.TextSize = 32
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = mainPanel

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = closeButton

    -- Hover effect close button
    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    end)
    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end)

    -- Click pour fermer
    closeButton.MouseButton1Click:Connect(function()
        panelOpen = false
        mainPanel:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.4, true)
        wait(0.4)
        mainPanel.Visible = false
        toggleButton.Visible = true
    end)

    -- Bouton OUVRIR - Bas Gauche
    toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 120, 0, 60)
    toggleButton.Position = UDim2.new(0, 20, 1, -80)
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = "OUVRIR"
    toggleButton.TextSize = 18
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 2
    toggleButton.BorderColor3 = Color3.fromRGB(0, 120, 0)
    toggleButton.Visible = false
    toggleButton.Parent = screenGui

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton

    -- Hover effect toggle button
    toggleButton.MouseEnter:Connect(function()
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 220, 0)
    end)
    toggleButton.MouseLeave:Connect(function()
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
    end)

    -- Click pour ouvrir
    toggleButton.MouseButton1Click:Connect(function()
        panelOpen = true
        mainPanel.Visible = true
        mainPanel:TweenSize(UDim2.new(0, 500, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
        toggleButton.Visible = false
    end)
end

-- Créer le panel au démarrage
createPanel()

-- Raccourci clavier : TOUCHE K pour ouvrir/fermer
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.K then
        if panelOpen then
            panelOpen = false
            mainPanel:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.4, true)
            wait(0.4)
            mainPanel.Visible = false
            toggleButton.Visible = true
        else
            panelOpen = true
            mainPanel.Visible = true
            mainPanel:TweenSize(UDim2.new(0, 500, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
            toggleButton.Visible = false
        end
    end
end)

print("✅ Panel vert créé ! Appuie sur K pour ouvrir/fermer")
