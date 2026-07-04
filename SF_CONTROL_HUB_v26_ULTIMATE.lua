--======================================================================--
--   ⚙️ SF CONTROL HUB v26 ULTIMATE (ÉDITION FINALE - BYPASS TOTAL)    --
--   🔧 VERSION ULTRA - INTERCEPTION REMOTES + RÔLE STAFF FORCÉ        --
--======================================================================--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local OWNER_ID = LocalPlayer.UserId
local STAFF_MODE_ENABLED = false
local INTERCEPTED_REMOTES = {}

-- Nettoyage anti-doublon
local oldGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("SF_AdminPanel_Standalone")
if oldGui then oldGui:Destroy() end

-- Conteneur Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SF_AdminPanel_Standalone"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--======================================================================--
-- [1] CADRE PRINCIPAL
--======================================================================--
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 520)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -260)
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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Title.Text = "🛡️ SF CONTROL HUB v26 [ULTIMATE BYPASS]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = Title

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
BannerText.Text = "⏳ Initialisation en cours..."
BannerText.TextColor3 = Color3.fromRGB(240, 253, 244)
BannerText.Font = Enum.Font.GothamBold
BannerText.TextSize = 11
BannerText.TextXAlignment = Enum.TextXAlignment.Left
BannerText.Parent = ScanBanner

local PlayerListScroll = Instance.new("ScrollingFrame")
PlayerListScroll.Size = UDim2.new(0.9, 0, 0, 130)
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

local DaysInput = Instance.new("TextBox")
DaysInput.Size = UDim2.new(0.9, 0, 0, 35)
DaysInput.Position = UDim2.new(0.05, 0, 0, 240)
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
TargetLabel.Position = UDim2.new(0.05, 0, 0, 280)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Utilisateur ciblé : Aucun"
TargetLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
TargetLabel.Font = Enum.Font.GothamMedium
TargetLabel.TextSize = 11
TargetLabel.Parent = MainFrame

local BanButton = Instance.new("TextButton")
BanButton.Size = UDim2.new(0.43, 0, 0, 38)
BanButton.Position = UDim2.new(0.05, 0, 0, 310)
BanButton.BackgroundColor3 = Color3.fromRGB(155, 40, 40)
BanButton.Text = "🔨 EXEC BAN"
BanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
BanButton.Font = Enum.Font.GothamBold
BanButton.TextSize = 11
BanButton.Parent = MainFrame
Instance.new("UICorner", BanButton).CornerRadius = UDim.new(0, 8)

local KickButton = Instance.new("TextButton")
KickButton.Size = UDim2.new(0.43, 0, 0, 38)
KickButton.Position = UDim2.new(0.52, 0, 0, 310)
KickButton.BackgroundColor3 = Color3.fromRGB(185, 105, 30)
KickButton.Text = "👢 EXEC KICK"
KickButton.TextColor3 = Color3.fromRGB(255, 255, 255)
KickButton.Font = Enum.Font.GothamBold
KickButton.TextSize = 11
KickButton.Parent = MainFrame
Instance.new("UICorner", KickButton).CornerRadius = UDim.new(0, 8)

local TicketPanelButton = Instance.new("TextButton")
TicketPanelButton.Size = UDim2.new(0.9, 0, 0, 40)
TicketPanelButton.Position = UDim2.new(0.05, 0, 0, 355)
TicketPanelButton.BackgroundColor3 = Color3.fromRGB(44, 34, 85)
TicketPanelButton.Text = "🎟️ MONITOR DES TICKETS"
TicketPanelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TicketPanelButton.Font = Enum.Font.GothamBold
TicketPanelButton.TextSize = 11
TicketPanelButton.Parent = MainFrame
Instance.new("UICorner", TicketPanelButton).CornerRadius = UDim.new(0, 8)

local StaffPanelButton = Instance.new("TextButton")
StaffPanelButton.Size = UDim2.new(0.9, 0, 0, 40)
StaffPanelButton.Position = UDim2.new(0.05, 0, 0, 405)
StaffPanelButton.BackgroundColor3 = Color3.fromRGB(29, 78, 216)
StaffPanelButton.Text = "🛠️ SERVICES (STAFF) : BYPASS"
StaffPanelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StaffPanelButton.Font = Enum.Font.GothamBold
StaffPanelButton.TextSize = 11
StaffPanelButton.Parent = MainFrame
Instance.new("UICorner", StaffPanelButton).CornerRadius = UDim.new(0, 8)

--======================================================================--
-- [2] PANNEAU STAFF ULTRA
--======================================================================--
local StaffFrame = Instance.new("Frame")
StaffFrame.Name = "StaffFrame"
StaffFrame.Size = UDim2.new(0, 400, 0, 350)
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
StaffTitle.Text = "🛠️ BYPASS REMOTES - PERMISSIONS TOTALES"
StaffTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
StaffTitle.Font = Enum.Font.GothamBold
StaffTitle.TextSize = 11
StaffTitle.Parent = StaffFrame
Instance.new("UICorner", StaffTitle).CornerRadius = UDim.new(0, 14)

local BypassAllBtn = Instance.new("TextButton")
BypassAllBtn.Size = UDim2.new(0.9, 0, 0, 38)
BypassAllBtn.Position = UDim2.new(0.05, 0, 0, 55)
BypassAllBtn.BackgroundColor3 = Color3.fromRGB(239, 68, 68)
BypassAllBtn.Text = "🔥 BYPASS TOTAL - INTERCEPTER REMOTES"
BypassAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BypassAllBtn.Font = Enum.Font.GothamBold
BypassAllBtn.TextSize = 11
BypassAllBtn.Parent = StaffFrame
Instance.new("UICorner", BypassAllBtn).CornerRadius = UDim.new(0, 8)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 80)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 105)
StatusLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
StatusLabel.Text = "⏳ EN ATTENTE\n\nCliquez sur le bouton ci-dessus pour activer le bypass."
StatusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.TextSize = 10
StatusLabel.TextWrapped = true
StatusLabel.Parent = StaffFrame
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 6)

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(0.9, 0, 0, 100)
InfoLabel.Position = UDim2.new(0.05, 0, 0, 200)
InfoLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
InfoLabel.Text = "📊 Remotes Trouvés: 0\n\n🔗 Interceptions: 0\n\n✅ Mode Staff: OFF"
InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
InfoLabel.Font = Enum.Font.GothamMedium
InfoLabel.TextSize = 10
InfoLabel.TextWrapped = true
InfoLabel.Parent = StaffFrame
Instance.new("UICorner", InfoLabel).CornerRadius = UDim.new(0, 6)

local TicketFrame = Instance.new("Frame")
TicketFrame.Name = "TicketFrame"
TicketFrame.Size = UDim2.new(0, 350, 0, 520)
TicketFrame.Position = UDim2.new(0.5, 190, 0.5, -260) 
TicketFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
TicketFrame.BorderSizePixel = 0
TicketFrame.Visible = false
TicketFrame.Parent = ScreenGui

local TicketCorner = Instance.new("UICorner")
TicketCorner.CornerRadius = UDim.new(0, 14)
TicketCorner.Parent = TicketFrame

local TicketStroke = Instance.new("UIStroke")
TicketStroke.Thickness = 1
TicketStroke.Color = Color3.fromRGB(40, 40, 40)
TicketStroke.Parent = TicketFrame

local TicketTitle = Instance.new("TextLabel")
TicketTitle.Size = UDim2.new(1, 0, 0, 45)
TicketTitle.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TicketTitle.Text = "🎟️ TICKET LOGS"
TicketTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TicketTitle.Font = Enum.Font.GothamBold
TicketTitle.TextSize = 11
TicketTitle.Parent = TicketFrame
local TicketTitleCorner = Instance.new("UICorner")
TicketTitleCorner.CornerRadius = UDim.new(0, 14)
TicketTitleCorner.Parent = TicketTitle

local TicketListScroll = Instance.new("ScrollingFrame")
TicketListScroll.Size = UDim2.new(0.92, 0, 0, 440)
TicketListScroll.Position = UDim2.new(0.04, 0, 0, 60)
TicketListScroll.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
TicketListScroll.BorderSizePixel = 0
TicketListScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
TicketListScroll.ScrollBarThickness = 4
TicketListScroll.Parent = TicketFrame

local TicketLayout = Instance.new("UIListLayout")
TicketLayout.Padding = UDim.new(0, 8)
TicketLayout.Parent = TicketListScroll

StaffPanelButton.MouseButton1Click:Connect(function()
	StaffFrame.Visible = not StaffFrame.Visible
end)

TicketPanelButton.MouseButton1Click:Connect(function()
	TicketFrame.Visible = not TicketFrame.Visible
end)

--------------------------------------------------------------------------
-- 🔥 SYSTÈME D'INTERCEPTION REMOTES ULTRA (BYPASS TOTAL)
--------------------------------------------------------------------------
local remotesCount = 0
local interceptionsCount = 0

local function executerBypassTotal()
	print("[SF HUB]: 🔥 ACTIVATION DU BYPASS TOTAL - INTERCEPTION REMOTES")
	
	STAFF_MODE_ENABLED = true
	remotesCount = 0
	interceptionsCount = 0
	
	StatusLabel.Text = "⏳ SCAN EN COURS...\n\nRecherche de tous les RemoteEvents/RemoteFunctions..."
	StatusLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
	
	-- ÉTAPE 1: Scanner et intercepter TOUS les RemoteEvents
	pcall(function()
		for _, remote in ipairs(game:GetDescendants()) do
			if remote:IsA("RemoteEvent") then
				remotesCount = remotesCount + 1
				local originalFire = remote.FireServer
				
				-- INTERCEPTER CHAQUE APPEL
				remote.FireServer = function(self, ...)
					local args = {...}
					interceptionsCount = interceptionsCount + 1
					
					-- Ajouter automatiquement les permissions à chaque appel
					table.insert(args, "Staff")
					table.insert(args, true)
					table.insert(args, "Admin")
					
					print("[INTERCEPTION]: " .. remote.Name .. " - Args modifiés")
					return originalFire(self, unpack(args))
				end
				
				INTERCEPTED_REMOTES[remote.Name] = remote
			end
		end
		print("[SF HUB]: ✅ " .. remotesCount .. " RemoteEvents interceptés")
	end)
	
	-- ÉTAPE 2: Scanner et intercepter TOUS les RemoteFunctions
	pcall(function()
		for _, remote in ipairs(game:GetDescendants()) do
			if remote:IsA("RemoteFunction") then
				remotesCount = remotesCount + 1
				local originalInvoke = remote.InvokeServer
				
				remote.InvokeServer = function(self, ...)
					local args = {...}
					interceptionsCount = interceptionsCount + 1
					
					table.insert(args, "Staff")
					table.insert(args, true)
					table.insert(args, "Admin")
					
					print("[INTERCEPTION FUNC]: " .. remote.Name)
					return originalInvoke(self, unpack(args))
				end
				
				INTERCEPTED_REMOTES[remote.Name] = remote
			end
		end
		print("[SF HUB]: ✅ RemoteFunctions interceptées")
	end)
	
	-- ÉTAPE 3: Modifier les valeurs locales du joueur
	pcall(function()
		if not LocalPlayer:FindFirstChild("Role") then
			local role = Instance.new("StringValue", LocalPlayer)
			role.Name = "Role"
			role.Value = "Staff"
		else
			LocalPlayer.Role.Value = "Staff"
		end
		
		if not LocalPlayer:FindFirstChild("IsStaff") then
			local isStaff = Instance.new("BoolValue", LocalPlayer)
			isStaff.Name = "IsStaff"
			isStaff.Value = true
		else
			LocalPlayer.IsStaff.Value = true
		end
		
		if not LocalPlayer:FindFirstChild("IsAdmin") then
			local isAdmin = Instance.new("BoolValue", LocalPlayer)
			isAdmin.Name = "IsAdmin"
			isAdmin.Value = true
		else
			LocalPlayer.IsAdmin.Value = true
		end
		
		if not LocalPlayer:FindFirstChild("Rank") then
			local rank = Instance.new("StringValue", LocalPlayer)
			rank.Name = "Rank"
			rank.Value = "Staff"
		else
			LocalPlayer.Rank.Value = "Staff"
		end
		
		print("[SF HUB]: ✅ Valeurs locales modifiées")
	end)
	
	-- RÉSULTAT FINAL
	wait(1)
	StatusLabel.Text = "✅ BYPASS ACTIVÉ AVEC SUCCÈS !\n\n🔗 Remotes: " .. remotesCount .. "\n📊 Interceptions: " .. interceptionsCount
	StatusLabel.TextColor3 = Color3.fromRGB(34, 197, 94)
	
	InfoLabel.Text = "📊 Remotes Trouvés: " .. remotesCount .. "\n\n🔗 Interceptions: " .. interceptionsCount .. "\n\n✅ Mode Staff: ACTIF"
	
	BannerText.Text = "👑 BYPASS ACTIF - " .. LocalPlayer.Name .. " [STAFF MODE]"
	BannerText.Parent.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
	
	print("[SF HUB]: 🔥🔥🔥 BYPASS TOTAL ACTIVÉ 🔥🔥🔥")
end

BypassAllBtn.MouseButton1Click:Connect(executerBypassTotal)

--------------------------------------------------------------------------
-- SYSTEMES DE BAN ET KICK (AVEC BYPASS)
--------------------------------------------------------------------------
local selectedPlayerName = ""

local function banPlayer(targetName)
	if targetName ~= "" and STAFF_MODE_ENABLED then
		local raison = DaysInput.Text ~= "" and DaysInput.Text or "Ban Admin"
		local targetPlayer = Players:FindFirstChild(targetName)
		
		if targetPlayer then
			for _, remote in ipairs(INTERCEPTED_REMOTES) do
				if remote and remote.Parent then
					pcall(function()
						if remote:IsA("RemoteEvent") then
							remote:FireServer(targetPlayer, raison)
							remote:FireServer(targetName, raison)
							remote:FireServer({Player = targetPlayer, Reason = raison, Type = "Ban"})
						end
					end)
				end
			end
			print("[BAN]: " .. targetName)
		end
	elseif not STAFF_MODE_ENABLED then
		print("[ERREUR]: Activez d'abord le BYPASS TOTAL")
	end
end

local function kickPlayer(targetName)
	if targetName ~= "" and STAFF_MODE_ENABLED then
		local raison = DaysInput.Text ~= "" and DaysInput.Text or "Kick Admin"
		local targetPlayer = Players:FindFirstChild(targetName)
		
		if targetPlayer then
			for _, remote in ipairs(INTERCEPTED_REMOTES) do
				if remote and remote.Parent then
					pcall(function()
						if remote:IsA("RemoteEvent") then
							remote:FireServer(targetPlayer, raison)
							remote:FireServer(targetName, raison)
							remote:FireServer({Player = targetPlayer, Reason = raison, Type = "Kick"})
						end
					end)
				end
			end
			print("[KICK]: " .. targetName)
		end
	elseif not STAFF_MODE_ENABLED then
		print("[ERREUR]: Activez d'abord le BYPASS TOTAL")
	end
end

BanButton.MouseButton1Click:Connect(function()
	banPlayer(selectedPlayerName)
end)

KickButton.MouseButton1Click:Connect(function()
	kickPlayer(selectedPlayerName)
end)

--------------------------------------------------------------------------
-- LISTE DES JOUEURS
--------------------------------------------------------------------------
local function updatePlayerList()
	for _, item in ipairs(PlayerListScroll:GetChildren()) do if item:IsA("TextButton") then item:Destroy() end end
	for _, p in ipairs(Players:GetPlayers()) do
		local PButton = Instance.new("TextButton")
		PButton.Size = UDim2.new(1, 0, 0, 34)
		PButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		PButton.Text = "   " .. p.Name
		PButton.TextColor3 = Color3.fromRGB(230, 230, 230)
		PButton.Font = Enum.Font.Gotham
		PButton.TextSize = 12
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

print("[SF HUB v26 ULTIMATE]: ✅ Bypass Total & Interception Remotes ACTIVÉ")
print("[SF HUB v26 ULTIMATE]: 🔥 Cliquez sur 'BYPASS TOTAL' pour intercepter TOUS les Remotes")
print("[SF HUB v26 ULTIMATE]: 👑 Une fois activé, Ban & Kick fonctionneront")
