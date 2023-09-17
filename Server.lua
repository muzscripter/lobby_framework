local Lobbys = {}
local PlayersLobby = {}
local LobbyModule = require(game:GetService('ReplicatedStorage'):WaitForChild('Lobby'))
local LobbyRemote = game:GetService('ReplicatedStorage'):WaitForChild('LobbyRemote')
local PlayersOccupation = {}


local function GenerateLobbyID()
	return tostring(os.time()) .. math.random(1000, 9999)
end

function CreateLobby(Player, MaxPlayerAmount, PartyType, PartyName, ExtraInfo)
	print(MaxPlayerAmount, PartyType, PartyName)
	
	local LobbyID = GenerateLobbyID()
	
	Lobbys[LobbyID] = LobbyModule.Create({
		MaxPlayers = MaxPlayerAmount,
		Type = PartyType,
		Name = PartyName,
		ID = LobbyID
	})
	
	task.wait()
	
	local Template = game:GetService('ReplicatedStorage').PartyTemplate
	Template.Name = LobbyID
	
	Template.PartyName.Text = PartyName
	Template.PlayerAmount.Text = #Lobbys[LobbyID].Players .. "/" .. MaxPlayerAmount
	Template.Parent = Player.PlayerGui.Frame.Background['Multi-Player'].Frame.Parties
	Template.Visible = true

	Lobbys[LobbyID]:SetLeader(Player)
	Lobbys[LobbyID]:Add(Player)
	
	PlayersOccupation[Player.Name] = LobbyID
	
	return Lobbys[LobbyID]
end

LobbyRemote.OnServerEvent:Connect(function(Player: any, Argument: string, MaxPlayerAmount: number, PartyType, PartyName, ExtraInfo)
	if Argument == 'Create' then
		CreateLobby(Player, MaxPlayerAmount, PartyType, PartyName, ExtraInfo)
		
	elseif Argument == 'Join' then
		Lobbys[ExtraInfo]:Add(Player, ExtraInfo)
		PlayersOccupation[Player.Name] = ExtraInfo
		
	elseif Argument == 'Leave' then
		Lobbys[ExtraInfo]:Leave(Player, ExtraInfo)
		PlayersOccupation[Player.Name] = false
		
	elseif Argument == 'Disband' then
		local ID = PlayersOccupation[Player.Name]

		Lobbys[ID]:Disband()
		for i,v in pairs(Lobbys) do
			print('Index' .. i .. 'Variable' .. v)
		end
	end
	
end)


game:GetService('ReplicatedStorage'):WaitForChild('GrabParty').OnServerInvoke = function(Player, ID)
	local Lobby = Lobbys[ID]
	if Lobby then
		print(Lobby)
	else
		print('Failed to get table')
	end
end
