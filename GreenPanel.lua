local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local panelOpen = true
local screenGui
local mainPanel
local toggleButton

-- Fonction pour créer le panel
local function createPanel()
    -- Créer le ScreenGui
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GreenPanelGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    -- Créer le panel principal (vert)
    mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 400, 0, 300)
    mainPanel.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainPanel.BackgroundColor3 = Color3.fromRGB(34, 139, 34) -- Vert foncé
    mainPanel.BorderSizePixel = 0
    mainPanel.Parent = screenGui

    -- Ajouter un coin arrondi au panel (optionnel)
    local cornerRadius = Instance.new("UICorner")
    cornerRadius.CornerRadius = UDim.new(0, 15)
    cornerRadius.Parent = mainPanel

    -- Créer le texte "nom sf" au centre
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "TitleLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "nom sf"
    textLabel.TextSize = 72
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Blanc
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = mainPanel

    -- Bouton de fermeture (X) en haut à droite
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 50, 0, 50)
    closeButton.Position = UDim2.new(1, -50, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "X"
    closeButton.TextSize = 24
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = mainPanel

    -- Coin arrondi pour le bouton
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 10)
    closeCorner.Parent = closeButton

    -- Fonction pour fermer le panel
    closeButton.MouseButton1Click:Connect(function()
        panelOpen = false
        mainPanel:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
        wait(0.3)
        mainPanel.Visible = false
    end)

    -- Créer un bouton pour rouvrir le panel
    toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 100, 0, 50)
    toggleButton.Position = UDim2.new(0, 10, 0, 10)
    toggleButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = "Ouvrir"
    toggleButton.TextSize = 18
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    toggleButton.Visible = false
    toggleButton.Parent = screenGui

    -- Coin arrondi pour le bouton toggle
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleButton

    -- Fonction pour rouvrir le panel
    toggleButton.MouseButton1Click:Connect(function()
        panelOpen = true
        mainPanel.Visible = true
        mainPanel:TweenSize(UDim2.new(0, 400, 0, 300), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        toggleButton.Visible = false
    end)
end

-- Créer le panel au démarrage
createPanel()

-- Raccourci clavier pour ouvrir/fermer (K)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.K then
        if panelOpen then
            panelOpen = false
            mainPanel:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
            wait(0.3)
            mainPanel.Visible = false
            toggleButton.Visible = true
        else
            panelOpen = true
            mainPanel.Visible = true
            mainPanel:TweenSize(UDim2.new(0, 400, 0, 300), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            toggleButton.Visible = false
        end
    end
end)
