local Lobbys = {}
local PlayersLobby = {}
local LobbyModule = require(game:GetService('ReplicatedStorage'):WaitForChild('Lobby'))
local LobbyRemote = game:GetService('ReplicatedStorage'):WaitForChild('LobbyRemote')

LobbyRemote.OnServerEvent:Connect(function(Player: any, Argument: string, Max: number, ExtraInfo)
	if Argument == 'Create' then
		Lobbys[Player.Name] = LobbyModule.Create({
			Players = {},
			Admin = Player,
			MaxPlayers = Max
		})
	elseif Argument == 'Join' then
		Lobbys[ExtraInfo]:Add(Player)
	elseif Argument == 'Leave' then
		Lobbys[ExtraInfo]:Leave(Player)
	end
end)
