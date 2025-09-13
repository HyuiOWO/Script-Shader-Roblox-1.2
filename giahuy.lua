-- LocalScript (StarterPlayerScripts)
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- Xóa phụ kiện, skin, tool, hiệu ứng
local function stripCharacter(char)
	if not char then return end

	for _, acc in ipairs(char:GetChildren()) do
		if acc:IsA("Accessory") or acc:IsA("Clothing") or acc:IsA("ShirtGraphic") then
			acc:Destroy()
		end
	end

	for _, tool in ipairs(char:GetChildren()) do
		if tool:IsA("Tool") then
			tool:Destroy()
		end
	end

	for _, v in ipairs(char:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
			v.Enabled = false
		end
	end
end

-- Nhạc loop
local function playMusic(id)
	-- Xóa nhạc cũ
	for _, s in ipairs(SoundService:GetChildren()) do
		if s:IsA("Sound") then
			s:Destroy()
		end
	end

	local music = Instance.new("Sound")
	music.SoundId = "rbxassetid://"..id
	music.Looped = true
	music.Volume = 1
	music.Parent = SoundService
	music:Play()
end

-- Chạy khi vào game
LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	stripCharacter(char)
end)

if LocalPlayer.Character then
	stripCharacter(LocalPlayer.Character)
end

-- Người chơi khác
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		char:WaitForChild("HumanoidRootPart")
		stripCharacter(char)
	end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
	if plr.Character then
		stripCharacter(plr.Character)
	end
end

-- Bắt đầu phát nhạc
playMusic(87233041213837)
