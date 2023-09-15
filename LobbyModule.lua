local Lobby = {}
Lobby.__index = Lobby

function Lobby.Create(Settings)
	return setmetatable(Lobby,{
		Players = {},
		Admin = Settings.Creator,
		MaxPlayers = Settings.MaxPlayers
	})
end

function Lobby:Destroy()
	for i,v in pairs(self) do
		i = nil
		v = nil
	end
	
	return
end

function Lobby:Add(Player: any)
	local AmountOfPlayers = #self.MaxPlayers
	local AvailablePlayers = #self.Players
	
	if AmountOfPlayers <= AvailablePlayers then
		return false
	end
	
	if table.find(self.Players, Player.Name) then
		return false
	else
		table.insert(self.Players, Player.Name)
	end
end

function Lobby:Leave(Player: any)
	if table.find(self.Players, Player.Name) then
		for i,v in pairs(self.Players) do
			if v.Name == Player.Name then
				table.remove(self.Players, Player.Name)
			end
		end
	else
		return false
	end
end
return Lobby
