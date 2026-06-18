local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Panneau simplifié
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 100)
frame.Position = UDim2.new(0.5, -125, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, 0, 1, 0)
btn.Text = "TP FORCÉ & GHOST"

local function forceTP(target)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    -- Récupération précise des coordonnées
    local pos = target:IsA("Model") and (target:FindFirstChild("HumanoidRootPart") and target.HumanoidRootPart.CFrame or target:GetPrimaryPartCFrame()) or target.CFrame
    
    -- Méthode Ghost : on désactive la collision et on déplace la CFrame directement
    char.HumanoidRootPart.Anchored = true
    for i = 1, 10 do -- Déplacement par petits paliers pour tromper l'anti-cheat
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame:Lerp(pos, i/10)
        task.wait(0.05)
    end
    char.HumanoidRootPart.Anchored = false
end

btn.MouseButton1Click:Connect(function()
    -- On cherche le "modrome" détecté précédemment
    local target = Workspace:FindFirstChild("modrome", true) or Workspace:FindFirstChild("Base", true)
    if target then
        forceTP(target)
    else
        warn("Impossible de trouver la base physiquement.")
    end
end)
