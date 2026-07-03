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

local requesterIsStaff = isStaff(player)
local playersData = {}

for _, p in pairs(Players:GetPlayers()) do
	-- n'ajoute que les joueurs dont le character semble chargé
	if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
		local entry = {
			userId = p.UserId,
			name = p.Name,
			displayName = p.DisplayName,
			role = p:GetAttribute("Role") or (p.Team and p.Team.Name) or "Joueur",
		}

		-- Infos supplémentaires uniquement pour le staff
		if requesterIsStaff then
			local hrp = p.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
			entry.position = hrp and hrp.Position or nil
			entry.health = humanoid and humanoid.Health or nil
		end

		table.insert(playersData, entry)
	end
end

-- Envoie la réponse uniquement au client demandeur
espEvent:FireClient(player, { isStaff = requesterIsStaff, players = playersData })

