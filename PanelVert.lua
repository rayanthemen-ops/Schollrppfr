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

