local Lobby = {}
Lobby.__index = Lobby

function Lobby.Create(Settings)
	local self = setmetatable(Lobby, {})
	
	self.Players = {}
	self.Leader = nil
	self.Type = Settings.Type or 'Public'
	self.Chapter = Settings.Chapter or 'Chapter 1'
	self.Name = Settings.Name or 'Party'
	self.MaxPlayers = Settings.MaxPlayers or 4
	self.ID = Settings.ID
	
	return self
end

function Lobby:SetLeader(Leader: Player)
	self.Leader = Leader
end

function Lobby:Disband()
	game:GetService('ReplicatedStorage'):WaitForChild('LobbyRemote'):FireAllClients('Disband', self)
	
	task.wait()
	
	for i,v in pairs(self) do
		i = nil
		v = nil
	end
	
	return
end

function Lobby:Add(Player: any)
	local AmountOfPlayers = self.MaxPlayers
	local AvailablePlayers = #self.Players
	
	if AmountOfPlayers <= AvailablePlayers then
		return
	end
	
	if self.Type == 'Public' then
		if table.find(self.Players, Player.Name) then
			return error('Player already in party')
		else
			table.insert(self.Players, Player.Name)
			game:GetService('ReplicatedStorage'):WaitForChild('LobbyRemote'):FireClient(Player, 'Join', self.ID, {['Name'] = self.Name, ['Leader'] = self.Leader})
			game:GetService('ReplicatedStorage'):WaitForChild('LobbyRemote'):FireAllClients(Player, 'Update', self.ID)
			
			print('Player has joined party')
		end
	elseif self.Type == 'Friends' then
		if not (Player == self.Leader) then
			if not self.Leader:IsFriendsWith(Player) then
				return warn('Player is not friends with Leader')
			end
		end

		if table.find(self.Players, Player.Name) then
			return error('Player already in party')
		else
			table.insert(self.Players, Player.Name)
			game:GetService('ReplicatedStorage'):WaitForChild('LobbyRemote'):FireClient(Player, 'Join', self.ID, {['Name'] = self.Name, ['Leader'] = self.Leader})
			game:GetService('ReplicatedStorage'):WaitForChild('LobbyRemote'):FireAllClients(Player, 'Update', self.ID, {['Players'] = self.Players, ['MaxPlayers'] = self.MaxPlayers})
			
			print('Joined party')
		end
	end

end

function Lobby:Leave(Player: any)
	if Player == self.Leader then
		return error('Leader cant leave own party')
	end
	
	if table.find(self.Players, Player.Name) then
		for i,v in pairs(self.Players) do
			if v.Name == Player.Name then
				table.remove(self.Players, Player.Name)
			end
		end
		
		game:GetService('ReplicatedStorage'):WaitForChild('LobbyRemote'):FireClient(Player, 'Join', self.ID, {['Name'] = self.Name, ['Leader'] = self.Leader})
		game:GetService('ReplicatedStorage'):WaitForChild('LobbyRemote'):FireAllClients(Player, 'Update', self.ID, {['Players'] = self.Players, ['MaxPlayers'] = self.MaxPlayers})
	else
		return false
	end
end

return Lobby
