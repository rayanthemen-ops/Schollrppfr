-- 🟢 DELTA EXECUTOR - Panel Vert "nom sf" - VERSION CORRIGÉE

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
    print("❌ Erreur : Aucun joueur détecté")
    return
end

local playerGui = player:WaitForChild("PlayerGui")

local panelOpen = true
local screenGui
local mainPanel
local toggleButton

local function createPanel()
    -- Nettoyer si existe
    if playerGui:FindFirstChild("GreenPanelGui") then
        playerGui:FindFirstChild("GreenPanelGui"):Destroy()
    end

    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GreenPanelGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    screenGui.Parent = playerGui

    mainPanel = Instance.new("Frame")
    mainPanel.Name = "MainPanel"
    mainPanel.Size = UDim2.new(0, 500, 0, 350)
    mainPanel.Position = UDim2.new(0.5, -250, 0.5, -175)
    mainPanel.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    mainPanel.BorderSizePixel = 3
    mainPanel.BorderColor3 = Color3.fromRGB(0, 100, 0)
    mainPanel.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainPanel

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "nom sf"
    titleLabel.TextSize = 100
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.TextScaled = true
    titleLabel.Parent = mainPanel

    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 70, 0, 70)
    closeButton.Position = UDim2.new(1, -80, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Text = "X"
    closeButton.TextSize = 40
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.ZIndex = 10
    closeButton.Parent = mainPanel

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 10)
    closeCorner.Parent = closeButton

    closeButton.MouseButton1Click:Connect(function()
        panelOpen = false
        mainPanel:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
        wait(0.3)
        mainPanel.Visible = false
        if toggleButton then toggleButton.Visible = true end
    end)

    toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 130, 0, 50)
    toggleButton.Position = UDim2.new(0, 15, 0, 15)
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Text = "OUVRIR"
    toggleButton.TextSize = 20
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 2
    toggleButton.BorderColor3 = Color3.fromRGB(0, 100, 0)
    toggleButton.Visible = false
    toggleButton.ZIndex = 10
    toggleButton.Parent = screenGui

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleButton

    toggleButton.MouseButton1Click:Connect(function()
        panelOpen = true
        mainPanel.Visible = true
        mainPanel:TweenSize(UDim2.new(0, 500, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        toggleButton.Visible = false
    end)
end

createPanel()
print("✅ Panel vert chargé ! Appuie sur K pour ouvrir/fermer, ou utilise les boutons")

-- Raccourci clavier K
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
            mainPanel:TweenSize(UDim2.new(0, 500, 0, 350), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
            toggleButton.Visible = false
        end
    end
end)
