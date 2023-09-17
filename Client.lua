local LobbyRemote = game:GetService('ReplicatedStorage'):WaitForChild('LobbyRemote')
local PlayerGui = game:GetService('Players').LocalPlayer.PlayerGui
local GrabParty = game:GetService('ReplicatedStorage'):WaitForChild('GrabParty')

LobbyRemote.OnClientEvent:Connect(function(Argument, ID, ExtraInfo)
	if Argument == 'Join' then
		
		local PartyFrame = PlayerGui.Frame.Background["Multi-Player"].Frame.PartyFrame
		PartyFrame.PartyName.Text = ExtraInfo.Name
		PartyFrame.Visible = true
		
		if game.Players.LocalPlayer == ExtraInfo.Leader then
			PartyFrame.Disband.Visible = true
		end
		
		local Template = PartyFrame.Template:Clone()
		Template.Name = game.Players.LocalPlayer.Name
		
		Template.Parent = PartyFrame.PlayerList
		Template.Visible = true
		Template.Player.Text = string.format("%s - Member", game.Players.LocalPlayer.Name)
	elseif Argument == 'Update' then
		local PartyFrame = PlayerGui.Frame.Background['Multi-Player'].Frame.Parties[ID]
		PartyFrame.PartyAmount.Text =  string.format("%d/%d", ExtraInfo.Players, ExtraInfo.MaxPlayers)
	elseif Argument == 'Leave' then
		local PartyFrame = PlayerGui.Frame.Background["Multi-Player"].Frame.PartyFrame
		for _, v in ipairs(PartyFrame.PlayerList:GetChildren()) do
			if v.Name == game.Players.LocalPlayer.Name then
				v:Destroy()
			end
		end
	elseif Argument == 'Disband' then
		local PartyFrame2 = PlayerGui.Frame.Background["Multi-Player"].Frame.PartyFrame
		local PartyFrame = PlayerGui.Frame.Background['Multi-Player'].Frame.Parties[ID]
		PartyFrame:Destroy()
		PartyFrame2.Visible = false
	end
end)
