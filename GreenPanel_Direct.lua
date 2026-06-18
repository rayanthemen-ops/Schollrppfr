local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))

-- UI Principale (Adaptée Mobile)
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local scanBtn = Instance.new("TextButton", mainFrame)
scanBtn.Size = UDim2.new(0.8, 0, 0, 50)
scanBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
scanBtn.Text = "🔍 SCANNER CODES"
scanBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 255)

-- Système de Scan Intelligent
local function findCodes()
    local foundCodes = {}
    
    -- On scanne les endroits probables
    local searchLocations = {ReplicatedStorage, game:GetService("Workspace")}
    
    for _, location in pairs(searchLocations) do
        for _, obj in pairs(location:GetDescendants()) do
            -- Recherche par nom de dossier ou contenu
            if string.find(string.lower(obj.Name), "code") then
                if obj:IsA("StringValue") or obj:IsA("NumberValue") then
                    table.insert(foundCodes, obj.Name .. " : " .. obj.Value)
                elseif obj:IsA("ModuleScript") then
                    table.insert(foundCodes, "Module trouvé (vérifier manuellement) : " .. obj.Name)
                end
            end
        end
    end
    return foundCodes
end

-- Panneau des résultats
local function showResults(codes)
    local panel = Instance.new("Frame", gui)
    panel.Size = UDim2.new(0.9, 0, 0.6, 0)
    panel.Position = UDim2.new(0.05, 0, 0.2, 0)
    panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    local list = Instance.new("ScrollingFrame", panel)
    list.Size = UDim2.new(1, 0, 1, 0)
    
    for i, code in pairs(codes) do
        local label = Instance.new("TextLabel", list)
        label.Size = UDim2.new(1, 0, 0, 40)
        label.Position = UDim2.new(0, 0, 0, (i-1)*45)
        label.Text = code
        label.TextColor3 = Color3.new(1,1,1)
    end
end

scanBtn.MouseButton1Click:Connect(function()
    local codes = findCodes()
    showResults(codes)
end)
