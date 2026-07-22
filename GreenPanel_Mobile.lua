-- ==============================================================================
-- SUPREME MULTI-COMMAND CHAT PANEL - SCRIPT COMPLET ET CORRIGÉ
-- ==============================================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- 1. Nettoyage sécurisé des anciennes instances pour éviter les doublons bloquants
pcall(function()
    if CoreGui:FindFirstChild("SupremeUltimatePanel") then
        CoreGui.SupremeUltimatePanel:Destroy()
    end
end)

-- 2. Création de l'interface principale injectée dans le CoreGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SupremeUltimatePanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local injectionSuccess, injectionError = pcall(function()
    ScreenGui.Parent = CoreGui
end)

if not injectionSuccess then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- 3. Configuration de la liste complète de tes commandes personnalisables
local availableCommands = {
    {Name = "Rocket", Cmd = "rocket"},
    {Name = "Balloon", Cmd = "balloon"},
    {Name = "Nightvision", Cmd = "nightvision"},
    {Name = "Jail", Cmd = "jail"},
    {Name = "Ragdoll", Cmd = "ragdoll"},
    {Name = "Inverse", Cmd = "inverse"},
    {Name = "Control", Cmd = "control"},
    {Name = "Tiny", Cmd = "tiny"},
    {Name = "Jumpscare", Cmd = "jumpscare"},
    {Name = "Morph", Cmd = "morph"}
}

-- Table de stockage des commandes sélectionnées en vert
local selectedCommands = {}

-- 4. Fonction universelle d'envoi de commandes (intercepte le chat ou les remotes du jeu)
local function sendAdminCommand(commandName, targetPlayer)
    pcall(function()
        -- Format exact validé par le système de ton jeu (ex: ";ragdoll Pseudo")
        local formattedMessage = ";" .. commandName .. " " .. targetPlayer.Name
        
        -- Tentative 1 : Via l'événement de chat standard Roblox
        local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvents and chatEvents:FindFirstChild("SayMessageRequest") then
            chatEvents.SayMessageRequest:FireServer(formattedMessage, "All")
            return
        end
        
        -- Tentative 2 : Via TextChatService (pour les serveurs récents)
        local textChatService = game:GetService("TextChatService")
        if textChatService and textChatService.TextChannels then
            local generalChannel = textChatService.TextChannels:FindFirstChild("RBXGeneral")
            if generalChannel then
                generalChannel:SendAsync(formattedMessage)
                return
            end
        end
        
        -- Tentative 3 : Recherche automatique de secours dans les RemoteEvents
        for _, remoteObj in ipairs(ReplicatedStorage:GetDescendants()) do
            if remoteObj:IsA("RemoteEvent") then
                local remoteName = remoteObj.Name:lower()
                if remoteName:find("chat") or remoteName:find("command") or remoteName:find("admin") or remoteName:find("message") then
                    remoteObj:FireServer(formattedMessage)
                end
            end
        end
    end)
end

-- 5. Construction de l'interface graphique ultra-design (Style Luxe / Sombre)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 440)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 14)
UICornerMain.Parent = MainFrame

local UIStrokeMain = Instance.new("UIStroke")
UIStrokeMain.Color = Color3.fromRGB(70, 70, 100)
UIStrokeMain.Thickness = 1.5
UIStrokeMain.Parent = MainFrame

-- Barre supérieure (TopBar)
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local UICornerTop = Instance.new("UICorner")
UICornerTop.CornerRadius = UDim.new(0, 14)
UICornerTop.Parent = TopBar

-- Masque pour redresser les coins inférieurs de la TopBar
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 10)
TopBarFix.Position = UDim2.new(0, 0, 1, -10)
TopBarFix.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Titre du Panel
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "💎 SUPREME MULTI-COMMAND PANEL"
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Bouton de fermeture
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0.5, -16)
CloseBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.Parent = TopBar

local UICornerClose = Instance.new("UICorner")
UICornerClose.CornerRadius = UDim.new(0, 8)
UICornerClose.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 6. Conteneur Gauche : Liste des commandes (Multiselect)
local CommandContainer = Instance.new("ScrollingFrame")
CommandContainer.Name = "CommandContainer"
CommandContainer.Size = UDim2.new(0, 320, 1, -70)
CommandContainer.Position = UDim2.new(0, 15, 0, 60)
CommandContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
CommandContainer.BorderSizePixel = 0
CommandContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
CommandContainer.ScrollBarThickness = 4
CommandContainer.Parent = MainFrame

local UICornerCmds = Instance.new("UICorner")
UICornerCmds.CornerRadius = UDim.new(0, 10)
UICornerCmds.Parent = CommandContainer

local UIListLayoutCmds = Instance.new("UIListLayout")
UIListLayoutCmds.Padding = UDim.new(0, 8)
UIListLayoutCmds.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutCmds.Parent = CommandContainer

UIListLayoutCmds:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    CommandContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutCmds.AbsoluteContentSize.Y + 15)
end)

-- 7. Conteneur Droit : Liste des joueurs avec leurs visages HD
local PlayerContainer = Instance.new("ScrollingFrame")
PlayerContainer.Name = "PlayerContainer"
PlayerContainer.Size = UDim2.new(0, 235, 1, -70)
PlayerContainer.Position = UDim2.new(0, 350, 0, 60)
PlayerContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
PlayerContainer.BorderSizePixel = 0
PlayerContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerContainer.ScrollBarThickness = 4
PlayerContainer.Parent = MainFrame

local UICornerPlrs = Instance.new("UICorner")
UICornerPlrs.CornerRadius = UDim.new(0, 10)
UICornerPlrs.Parent = PlayerContainer

local UIListLayoutPlrs = Instance.new("UIListLayout")
UIListLayoutPlrs.Padding = UDim.new(0, 8)
UIListLayoutPlrs.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutPlrs.Parent = PlayerContainer

UIListLayoutPlrs:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerContainer.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutPlrs.AbsoluteContentSize.Y + 15)
end)

-- 8. Fonction d'exécution groupée de toutes les commandes sélectionnées sur la cible
local function executeGroupCommands(targetPlayer)
    if #selectedCommands == 0 then
        warn("Sélectionne au moins une commande en vert avant de cliquer sur un joueur !")
        return
    end
    
    pcall(function()
        for _, cmdString in ipairs(selectedCommands) do
            sendAdminCommand(cmdString, targetPlayer)
            task.wait(0.04) -- Léger délai pour que le serveur traite chaque commande sans rollback
        end
    end)
end

-- 9. Génération dynamique des boutons de commandes (Basculement Vert / Gris)
for _, cmdData in ipairs(availableCommands) do
    local cmdBtn = Instance.new("TextButton")
    cmdBtn.Size = UDim2.new(1, -12, 0, 40)
    cmdBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    cmdBtn.TextColor3 = Color3.fromRGB(190, 190, 205)
    cmdBtn.TextSize = 13
    cmdBtn.Font = Enum.Font.GothamSemibold
    cmdBtn.Text = "   " .. cmdData.Name .. "  (;" .. cmdData.Cmd .. ")"
    cmdBtn.TextXAlignment = Enum.TextXAlignment.Left
    cmdBtn.Parent = CommandContainer
    
    local UICornerBtn = Instance.new("UICorner")
    UICornerBtn.CornerRadius = UDim.new(0, 8)
    UICornerBtn.Parent = cmdBtn
    
    local isSelected = false
    
    cmdBtn.MouseButton1Click:Connect(function()
        isSelected = not isSelected
        if isSelected then
            cmdBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Vert vif actif
            cmdBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            table.insert(selectedCommands, cmdData.Cmd)
        else
            cmdBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42) -- Gris d'origine
            cmdBtn.TextColor3 = Color3.fromRGB(190, 190, 205)
            for i, c in ipairs(selectedCommands) do
                if c == cmdData.Cmd then
                    table.remove(selectedCommands, i)
                    break
                end
            end
        end
    end)
end

-- 10. Fonction de remplissage et actualisation de la liste des joueurs
local function refreshPlayerList()
    -- Nettoyage des anciens boutons joueurs
    for _, child in ipairs(PlayerContainer:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Création des nouveaux boutons pour chaque joueur connecté
    for _, plr in ipairs(Players:GetPlayers()) do
        local playerBtn = Instance.new("TextButton")
        playerBtn.Size = UDim2.new(1, -12, 0, 46)
        playerBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
        playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        playerBtn.TextSize = 13
        playerBtn.Font = Enum.Font.GothamMedium
        playerBtn.Text = "       " .. plr.Name
        playerBtn.TextXAlignment = Enum.TextXAlignment.Left
        playerBtn.Parent = PlayerContainer
        
        local UICornerP = Instance.new("UICorner")
        UICornerP.CornerRadius = UDim.new(0, 8)
        UICornerP.Parent = playerBtn
        
        -- Affichage de l'avatar (visage HD du joueur)
        local thumbImg = Instance.new("ImageLabel")
        thumbImg.Size = UDim2.new(0, 34, 0, 34)
        thumbImg.Position = UDim2.new(0, 6, 0.5, -17)
        thumbImg.BackgroundTransparency = 1
        
        pcall(function()
            thumbImg.Image = Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        end)
        thumbImg.Parent = playerBtn
        
        local UICornerThumb = Instance.new("UICorner")
        UICornerThumb.CornerRadius = UDim.new(0, 6)
        UICornerThumb.Parent = thumbImg
        
        -- Clic sur le joueur -> Déclenche l'envoi groupé de toutes les commandes en vert !
        playerBtn.MouseButton1Click:Connect(function()
            executeGroupCommands(plr)
            
            -- Effet flash orange pour confirmer visuellement l'action
            playerBtn.BackgroundColor3 = Color3.fromRGB(230, 126, 34)
            task.delay(0.2, function()
                if playerBtn and playerBtn.Parent then
                    playerBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                end
            end)
        end)
    end
end

-- Connexions des événements d'entrée/sortie de joueurs
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)

-- Premier lancement du remplissage des listes
refreshPlayerList()

print("Supreme Multi-Command Panel chargé et opérationnel !")
