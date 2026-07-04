--======================================================================--
--   ⚙️ SF CONTROL HUB v26 (ÉDITION V5 ADVANCED - STAFF & WHITELIST)    --
--   🔧 VERSION CORRIGÉE - BYPASS TOTAL + FREE CAM + BAN/KICK            --
--======================================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Configuration
local OWNER_ID = LocalPlayer.UserId
local STAFF_MODE_ENABLED = false
local FREE_CAM_ENABLED = false
local FREE_CAM_SPEED = 50
local ALL_REMOTES = {}

-- Nettoyage anti-doublon
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("SF_AdminPanel_Standalone")
if oldGui then oldGui:Destroy() end

-- Conteneur Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SF_AdminPanel_Standalone"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--======================================================================--
-- [1] CADRE PRINCIPAL (PANEL DE CONTROLE)
--======================================================================--
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 600)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 1
UIStroke.Color = Color3.fromRGB(139, 92, 246)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

-- Titre principal
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Title.Text = "🛡️ SF CONTROL HUB v26 [BYPASS EDITION]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = Title

-- Bannière d'état
local ScanBanner = Instance.new("Frame")
ScanBanner.Name = "ScanBanner"
ScanBanner.Size = UDim2.new(0.9, 0, 0, 35)
ScanBanner.Position = UDim2.new(0.05, 0, 0, 55)
ScanBanner.BackgroundColor3 = Color3.fromRGB(16, 185, 129)
ScanBanner.BorderSizePixel = 0
ScanBanner.Parent = MainFrame

local BannerCorner = Instance.new("UICorner")
BannerCorner.CornerRadius = UDim.new(0, 6)
BannerCorner.Parent = ScanBanner

local BannerText = Instance.new("TextLabel")
BannerText.Size = UDim2.new(1, -10, 1, 0)
BannerText.Position = UDim2.new(0, 10, 0, 0)
BannerText.BackgroundTransparency = 1
BannerText.Text = "🔓 Auto-Whitelist Active : " .. LocalPlayer.Name .. " (OWNER)"
BannerText.TextColor3 = Color3.fromRGB(240, 253, 244)
BannerText.Font = Enum.Font.GothamBold
BannerText.TextSize = 11
BannerText.TextXAlignment = Enum.TextXAlignment.Left
BannerText.Parent = ScanBanner

-- Zone de liste des joueurs
local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Size = UDim2.new(0.9, 0, 0, 100)
PlayerListScroll.Position = UDim2.new(0.05, 0, 0, 100)
PlayerListScroll.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
PlayerListScroll.BorderSizePixel = 0
PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerListScroll.ScrollBarThickness = 4
PlayerListScroll.Parent = MainFrame

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Padding = UDim.new(0, 5)
ScrollLayout.Parent = PlayerListScroll

local ScrollPadding = Instance.new("UIPadding")
ScrollPadding.PaddingTop = UDim.new(0, 5)
ScrollPadding.PaddingLeft = UDim.new(0, 5)
ScrollPadding.PaddingRight = UDim.new(0, 5)
ScrollPadding.Parent = PlayerListScroll

-- Champ d'entrée
local DaysInput = Instance.new("TextBox")
DaysInput.Size = UDim2.new(0.9, 0, 0, 35)
DaysInput.Position = UDim2.new(0.05, 0, 0, 210)
DaysInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DaysInput.TextColor3 = Color3.fromRGB(255, 255, 255)
DaysInput.PlaceholderText = "Raison du paramètre / Ban / Kick"
DaysInput.Text = ""
DaysInput.Font = Enum.Font.Gotham
DaysInput.TextSize = 12
DaysInput.Parent = MainFrame

local DaysCorner = Instance.new("UICorner")
DaysCorner.CornerRadius = UDim.new(0, 8)
DaysCorner.Parent = DaysInput

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(0.9, 0, 0, 25)
TargetLabel.Position = UDim2.new(0.05, 0, 0, 250)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Utilisateur ciblé : Aucun"
TargetLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
TargetLabel.Font = Enum.Font.GothamMedium
TargetLabel.TextSize = 11
TargetLabel.Parent = MainFrame

-- Boutons d'action
local BanButton = Instance.new("TextButton")
BanButton.Size = UDim2.new(0.43, 0, 0, 38)
BanButton.Position = UDim2.new(0.05, 0, 0, 280)
BanButton.BackgroundColor3 = Color3.fromRGB(155, 40, 40)
BanButton.Text = "🔨 EXEC BAN"
BanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BanButton.Font = Enum.Font.GothamBold
BanButton.TextSize = 11
BanButton.Parent = MainFrame
Instance.new("UICorner", BanButton).CornerRadius = UDim.new(0, 8)

local KickButton = Instance.new("TextButton")
KickButton.Size = UDim2.new(0.43, 0, 0, 38)
KickButton.Position = UDim2.new(0.52, 0, 0, 280)
KickButton.BackgroundColor3 = Color3.fromRGB(185, 105, 30)
KickButton.Text = "👢 EXEC KICK"
KickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KickButton.Font = Enum.Font.GothamBold
KickButton.TextSize = 11
KickButton.Parent = MainFrame
Instance.new("UICorner", KickButton).CornerRadius = UDim.new(0, 8)

-- Bouton Free Cam
local FreeCamButton = Instance.new("TextButton")
FreeCamButton.Size = UDim2.new(0.9, 0, 0, 38)
FreeCamButton.Position = UDim2.new(0.05, 0, 0, 325)
FreeCamButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
FreeCamButton.Text = "📷 FREE CAM (OFF)"
FreeCamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FreeCamButton.Font = Enum.Font.GothamBold
FreeCamButton.TextSize = 11
FreeCamButton.Parent = MainFrame
Instance.new("UICorner", FreeCamButton).CornerRadius = UDim.new(0, 8)

-- Bouton Services Staff
local StaffPanelButton = Instance.new("TextButton")
StaffPanelButton.Size = UDim2.new(0.9, 0, 0, 40)
StaffPanelButton.Position = UDim2.new(0.05, 0, 0, 370)
StaffPanelButton.BackgroundColor3 = Color3.fromRGB(29, 78, 216)
StaffPanelButton.Text = "🛠️ SERVICES (STAFF) : BYPASS"
StaffPanelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StaffPanelButton.Font = Enum.Font.GothamBold
StaffPanelButton.TextSize = 11
StaffPanelButton.Parent = MainFrame
Instance.new("UICorner", StaffPanelButton).CornerRadius = UDim.new(0, 8)

--======================================================================--
-- [2] PANNEAU STAFF BYPASS
--======================================================================--
local StaffFrame = Instance.new("Frame")
StaffFrame.Name = "StaffFrame"
StaffFrame.Size = UDim2.new(0, 380, 0, 280)
StaffFrame.Position = UDim2.new(0.5, 190, 0.5, 20) 
StaffFrame.BackgroundColor3 = Color3.fromRGB(20, 24, 35)
StaffFrame.BorderSizePixel = 0
StaffFrame.Visible = false
StaffFrame.Parent = ScreenGui

Instance.new("UICorner", StaffFrame).CornerRadius = UDim.new(0, 14)
local StaffStroke = Instance.new("UIStroke")
StaffStroke.Thickness = 1
StaffStroke.Color = Color3.fromRGB(29, 78, 216)
StaffStroke.Parent = StaffFrame

local StaffTitle = Instance.new("TextLabel")
StaffTitle.Size = UDim2.new(1, 0, 0, 40)
StaffTitle.BackgroundColor3 = Color3.fromRGB(26, 32, 46)
StaffTitle.Text = "🛠️ BYPASS REMOTES + STAFF"
StaffTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
StaffTitle.Font = Enum.Font.GothamBold
StaffTitle.TextSize = 11
StaffTitle.Parent = StaffFrame
Instance.new("UICorner", StaffTitle).CornerRadius = UDim.new(0, 14)

local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0.9, 0, 0, 35)
ScanBtn.Position = UDim2.new(0.05, 0, 0, 55)
ScanBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
ScanBtn.Text = "🔍 SCANNER REMOTES"
ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 10
ScanBtn.Parent = StaffFrame
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 8)

local BypassBtn = Instance.new("TextButton")
BypassBtn.Size = UDim2.new(0.9, 0, 0, 35)
BypassBtn.Position = UDim2.new(0.05, 0, 0, 100)
BypassBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
BypassBtn.Text = "🔥 BYPASS TOTAL"
BypassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BypassBtn.Font = Enum.Font.GothamBold
BypassBtn.TextSize = 10
BypassBtn.Parent = StaffFrame
Instance.new("UICorner", BypassBtn).CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 100)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 150)
StatusLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StatusLabel.Text = "⏳ EN ATTENTE\n\nCliquez sur 'BYPASS TOTAL'"
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 10
StatusLabel.TextWrapped = true
StatusLabel.Parent = StaffFrame
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 6)

--======================================================================--
-- 🔍 SCANNER REMOTES
--======================================================================--
local function scanAllRemotes()
    print("[SCAN]: 🔍 Scannage des RemoteEvents...")
    ALL_REMOTES = {}
    
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            table.insert(ALL_REMOTES, obj)
            local nameLower = obj.Name:lower()
            if nameLower:find("ban") or nameLower:find("kick") or nameLower:find("staff") then
                print("[REMOTE TROUVÉ]: " .. obj:GetFullName())
            end
        end
    end
    
    print("[SCAN]: ✅ " .. #ALL_REMOTES .. " Remotes trouvés")
    StatusLabel.Text = "✅ " .. #ALL_REMOTES .. " Remotes trouvés !\n\nCliquez sur 'BYPASS TOTAL' pour activer"
    StatusLabel.TextColor3 = Color3.fromRGB(100, 200, 100)
end

--======================================================================--
-- 🚀 BYPASS REMOTES + STAFF
--======================================================================--
local function executerBypassTotal()
    print("[BYPASS]: 🚀 Activation du bypass total...")
    
    STAFF_MODE_ENABLED = true
    
    -- Modifier les valeurs locales
    pcall(function()
        local valuesToCreate = {
            {name = "Role", type = "StringValue", value = "Staff"},
            {name = "IsStaff", type = "BoolValue", value = true},
            {name = "IsAdmin", type = "BoolValue", value = true},
            {name = "Rank", type = "StringValue", value = "Staff"},
            {name = "CanBan", type = "BoolValue", value = true},
            {name = "CanKick", type = "BoolValue", value = true},
        }
        
        for _, val in ipairs(valuesToCreate) do
            if not LocalPlayer:FindFirstChild(val.name) then
                local newVal = Instance.new(val.type, LocalPlayer)
                newVal.Name = val.name
                if val.type == "StringValue" then newVal.Value = val.value end
                if val.type == "BoolValue" then newVal.Value = val.value end
            else
                local existing = LocalPlayer[val.name]
                if existing:IsA("StringValue") then existing.Value = val.value end
                if existing:IsA("BoolValue") then existing.Value = val.value end
            end
        end
    end)
    
    -- Intercepter les Remotes
    pcall(function()
        for _, remote in ipairs(ALL_REMOTES) do
            if remote:IsA("RemoteEvent") then
                local originalFire = remote.FireServer
                remote.FireServer = function(self, ...)
                    local args = {...}
                    table.insert(args, 1, "Staff")
                    table.insert(args, true)
                    return originalFire(self, unpack(args))
                end
            elseif remote:IsA("RemoteFunction") then
                local originalInvoke = remote.InvokeServer
                remote.InvokeServer = function(self, ...)
                    local args = {...}
                    table.insert(args, 1, "Staff")
                    table.insert(args, true)
                    return originalInvoke(self, unpack(args))
                end
            end
        end
    end)
    
    StatusLabel.Text = "✅ BYPASS ACTIVÉ !\n\n🔨 Ban/Kick maintenant actifs"
    StatusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
    BannerText.Text = "👑 BYPASS STAFF ACTIF - " .. LocalPlayer.Name
    
    print("[BYPASS]: ✅ BYPASS TOTAL ACTIVÉ")
end

ScanBtn.MouseButton1Click:Connect(scanAllRemotes)
BypassBtn.MouseButton1Click:Connect(executerBypassTotal)

--======================================================================--
-- 🔨 BAN/KICK FUNCTIONS
--======================================================================--
local selectedPlayerName = ""

local function banPlayer(targetName)
    if not STAFF_MODE_ENABLED then
        print("[ERREUR]: Activez d'abord le BYPASS")
        return
    end
    
    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer then return end
    
    for _, remote in ipairs(ALL_REMOTES) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(targetPlayer, "Ban Exploit")
                remote:FireServer(targetName, "Ban")
                remote:FireServer({player = targetPlayer, reason = "Ban"})
            end
        end)
    end
    
    print("[BAN]: " .. targetName .. " banned")
end

local function kickPlayer(targetName)
    if not STAFF_MODE_ENABLED then
        print("[ERREUR]: Activez d'abord le BYPASS")
        return
    end
    
    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer then return end
    
    for _, remote in ipairs(ALL_REMOTES) do
        pcall(function()
            if remote:IsA("RemoteEvent") then
                remote:FireServer(targetPlayer, "Kick Exploit")
                remote:FireServer(targetName, "Kick")
                remote:FireServer({player = targetPlayer, reason = "Kick"})
            end
        end)
    end
    
    print("[KICK]: " .. targetName .. " kicked")
end

BanButton.MouseButton1Click:Connect(function()
    banPlayer(selectedPlayerName)
end)

KickButton.MouseButton1Click:Connect(function()
    kickPlayer(selectedPlayerName)
end)

--======================================================================--
-- 📷 FREE CAM SYSTEM
--======================================================================--
local freeCamActive = false
local freeCamConnection = nil
local originalCameraMode = nil

local function enableFreeCam()
    freeCamActive = true
    originalCameraMode = Camera.Focus
    
    local cameraPart = Instance.new("Part")
    cameraPart.CanCollide = false
    cameraPart.CFrame = Camera.CFrame
    cameraPart.Parent = Workspace
    
    Camera.CameraType = Enum.CameraType.Scriptable
    
    local UserInput = game:GetService("UserInputService")
    local Keys = {
        W = false, A = false, S = false, D = false,
        Space = false, Shift = false
    }
    
    UserInput.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.W then Keys.W = true end
        if input.KeyCode == Enum.KeyCode.A then Keys.A = true end
        if input.KeyCode == Enum.KeyCode.S then Keys.S = true end
        if input.KeyCode == Enum.KeyCode.D then Keys.D = true end
        if input.KeyCode == Enum.KeyCode.Space then Keys.Space = true end
        if input.KeyCode == Enum.KeyCode.LeftShift then Keys.Shift = true end
    end)
    
    UserInput.InputEnded:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.W then Keys.W = false end
        if input.KeyCode == Enum.KeyCode.A then Keys.A = false end
        if input.KeyCode == Enum.KeyCode.S then Keys.S = false end
        if input.KeyCode == Enum.KeyCode.D then Keys.D = false end
        if input.KeyCode == Enum.KeyCode.Space then Keys.Space = false end
        if input.KeyCode == Enum.KeyCode.LeftShift then Keys.Shift = false end
    end)
    
    freeCamConnection = game:GetService("RunService").RenderStepped:Connect(function()
        if not freeCamActive then return end
        
        local moveDirection = Vector3.new(0, 0, 0)
        if Keys.W then moveDirection = moveDirection + (Camera.CFrame.LookVector) end
        if Keys.S then moveDirection = moveDirection - (Camera.CFrame.LookVector) end
        if Keys.A then moveDirection = moveDirection - (Camera.CFrame.RightVector) end
        if Keys.D then moveDirection = moveDirection + (Camera.CFrame.RightVector) end
        if Keys.Space then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
        if Keys.Shift then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
        
        local speed = Keys.Shift and FREE_CAM_SPEED * 2 or FREE_CAM_SPEED
        Camera.CFrame = Camera.CFrame + (moveDirection.Unit * speed * 0.016)
    end)
    
    print("[FREE CAM]: ✅ ACTIVÉ - WASD: Mouvement, SPACE: Haut, SHIFT: Bas")
    FreeCamButton.Text = "📷 FREE CAM (ON)"
    FreeCamButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
end

local function disableFreeCam()
    freeCamActive = false
    if freeCamConnection then freeCamConnection:Disconnect() end
    Camera.CameraType = Enum.CameraType.Custom
    Camera.Focus = originalCameraMode or LocalPlayer.Character:FindFirstChild("Head").CFrame
    print("[FREE CAM]: ❌ DÉSACTIVÉ")
    FreeCamButton.Text = "📷 FREE CAM (OFF)"
    FreeCamButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
end

FreeCamButton.MouseButton1Click:Connect(function()
    if freeCamActive then
        disableFreeCam()
    else
        enableFreeCam()
    end
end)

--======================================================================--
-- LISTE DES JOUEURS
--======================================================================--
local function updatePlayerList()
    for _, item in ipairs(PlayerListScroll:GetChildren()) do
        if item:IsA("TextButton") then item:Destroy() end
    end
    
    for _, p in ipairs(Players:GetPlayers()) do
        local PButton = Instance.new("TextButton")
        PButton.Size = UDim2.new(1, 0, 0, 30)
        PButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        PButton.Text = "   " .. p.Name
        PButton.TextColor3 = Color3.fromRGB(230, 230, 230)
        PButton.Font = Enum.Font.Gotham
        PButton.TextSize = 11
        PButton.TextXAlignment = Enum.TextXAlignment.Left
        PButton.Parent = PlayerListScroll
        Instance.new("UICorner", PButton).CornerRadius = UDim.new(0, 6)
        
        PButton.MouseButton1Click:Connect(function()
            selectedPlayerName = p.Name
            TargetLabel.Text = "Utilisateur ciblé : " .. selectedPlayerName
            TargetLabel.TextColor3 = Color3.fromRGB(167, 139, 250)
        end)
    end
    
    PlayerListScroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 10)
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

StaffPanelButton.MouseButton1Click:Connect(function()
    StaffFrame.Visible = not StaffFrame.Visible
end)

print("[SF HUB v26]: ✅ Panel Bypass + Free Cam ACTIVÉ")
print("[SF HUB v26]: 1. Cliquez sur 'SERVICES' puis 'SCANNER REMOTES'")
print("[SF HUB v26]: 2. Cliquez sur 'BYPASS TOTAL'")
print("[SF HUB v26]: 3. Sélectionnez une personne et cliquez BAN/KICK")
print("[SF HUB v26]: 4. Free Cam: Appuyez sur le bouton 📷")
