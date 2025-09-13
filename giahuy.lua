-- LocalScript (StarterPlayerScripts)
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- ✅ Tạo màn hình loading
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.IgnoreGuiInset = true

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0.6, 0, 0.1, 0)
frame.Position = UDim2.new(0.2, 0, 0.45, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 0

local bar = Instance.new("Frame", frame)
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
bar.BorderSizePixel = 0

local label = Instance.new("TextLabel", screenGui)
label.Size = UDim2.new(1, 0, 0.1, 0)
label.Position = UDim2.new(0, 0, 0.55, 0)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1, 1, 1)
label.TextScaled = true
label.Text = "Đang tải..."

-- ✅ Hàm xử lý stripCharacter (ẩn skin, tool, hiệu ứng)
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

-- ✅ Nhạc loop
local function playMusic(id)
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

-- ✅ Thanh loading chạy
task.spawn(function()
	local success, err = pcall(function()
		for i = 1, 100 do
			bar.Size = UDim2.new(i/100, 0, 1, 0)
			task.wait(0.03)
		end
	end)

	if success then
		label.Text = "Hoàn tất!"
		task.wait(0.5)
	else
		label.Text = "Lỗi: " .. tostring(err)
		task.wait(2)
	end

	screenGui:Destroy()
end)

-- ✅ Chạy khi vào game
LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	pcall(function() stripCharacter(char) end)
end)

if LocalPlayer.Character then
	pcall(function() stripCharacter(LocalPlayer.Character) end)
end

-- Người chơi khác
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		char:WaitForChild("HumanoidRootPart")
		pcall(function() stripCharacter(char) end)
	end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
	if plr.Character then
		pcall(function() stripCharacter(plr.Character) end)
	end
end

-- ✅ Bắt đầu phát nhạc
playMusic(87086838053275)
