-- ====================================================================
-- HUB V20 : ANTI-ROLLBACK (MÉTHODE PALIERS)
-- ====================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local function CreateUI()
    if PlayerGui:FindFirstChild("SchoolRP_V20") then PlayerGui["SchoolRP_V20"]:Destroy() end

    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "SchoolRP_V20"
    ScreenGui.DisplayOrder = 999999

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 300, 0, 150)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    MainFrame.Active = true
    MainFrame.Draggable = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local TpBtn = Instance.new("TextButton", MainFrame)
    TpBtn.Size = UDim2.new(0.8, 0, 0, 50)
    TpBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
    TpBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100) -- Vert pour succès
    TpBtn.Text = "TP SÉCURISÉ (V20)"
    TpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", TpBtn).CornerRadius = UDim.new(0, 6)

    TpBtn.MouseButton1Click:Connect(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local target = nil
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Position.Y < -50 and obj.Size.X > 40 then
                target = obj.Position
                break
            end
        end

        if target then
            -- ÉTAPE 1 : TP à mi-chemin (pour tromper la détection)
            local midPoint = Vector3.new(hrp.Position.X, -25, hrp.Position.Z)
            hrp.Anchored = true
            hrp.CFrame = CFrame.new(midPoint)
            task.wait(0.4) 
            
            -- ÉTAPE 2 : TP à la cible finale
            hrp.CFrame = CFrame.new(target + Vector3.new(0, 5, 0))
            task.wait(0.4)
            
            hrp.Anchored = false
            TpBtn.Text = "ARRIVÉ !"
            task.wait(2)
            TpBtn.Text = "TP SÉCURISÉ (V20)"
        end
    end)
end

CreateUI()
