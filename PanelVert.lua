-- Vérification par group (si configuré)
if STAFF_GROUP_ID > 0 then
	local ok, rank = pcall(function() return player:GetRankInGroup(STAFF_GROUP_ID) end)
	if ok and rank and rank > 0 then return true end
end

-- Vérification par Team (nom qui contient "staff", "admin", "mod")
if player.Team then
	local tName = tostring(player.Team.Name):lower()
	if string.find(tName, "staff") or string.find(tName, "admin") or string.find(tName, "mod") then
		return true
	end
end

return false

local bgui = Instance.new("BillboardGui")
bgui.Size = UDim2.new(0,200,0,60)
bgui.AlwaysOnTop = true
bgui.Adornee = hrp
bgui.Parent = workspace

local label = Instance.new("TextLabel", bgui)
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
label.TextSize = 13
label.TextColor3 = Color3.new(1,1,1)

local conn = RunService.RenderStepped:Connect(function()
    if not player.Character or not localPlayer.Character then
        clearMarker(data.userId)
        return
    end
    local myRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if myRoot and hrp then
        local dist = math.floor((myRoot.Position - hrp.Position).Magnitude)
        local healthText = isRequesterStaff and (data.health and (" | ❤ "..math.floor(data.health)) or "") or ""
        label.Text = string.format("%s\n%s\n[%d m]%s", data.displayName or data.name, data.role or "Joueur", dist, healthText)
    end
end)

markers[data.userId] = { gui = bgui, updateConn = conn }

-- Vérification par group (si configuré)
if STAFF_GROUP_ID > 0 then
	local ok, rank = pcall(function() return player:GetRankInGroup(STAFF_GROUP_ID) end)
	if ok and rank and rank > 0 then return true end
end

-- Vérification par Team (nom qui contient "staff", "admin", "mod")
if player.Team then
	local tName = tostring(player.Team.Name):lower()
	if string.find(tName, "staff") or string.find(tName, "admin") or string.find(tName, "mod") then
		return true
	end
end

return false