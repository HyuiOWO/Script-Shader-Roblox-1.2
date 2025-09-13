--==[ SCRIPT FIX LAG + RGB BOX + FPS + NHẠC MỚI ]==--

-- ⚡ Xóa hiệu ứng (giữ lại BillboardGui để còn thấy tên)
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") 
    or obj:IsA("Smoke") or obj:IsA("Explosion") or obj:IsA("Beam") then
        obj:Destroy()
    elseif obj:IsA("SurfaceGui") then
        obj.Enabled = false
    elseif obj:IsA("Decal") then
        obj.Texture = ""
    end
end

-- ⚡ Giảm đồ họa
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") 
    or obj:IsA("Smoke") or obj:IsA("Explosion") or obj:IsA("Beam") then
        obj:Destroy()
    elseif obj:IsA("Decal") then
        obj.Texture = ""
    elseif obj:IsA("SurfaceGui") then
        obj.Enabled = false
    end
end)

-- ⚡ Xóa skin người chơi (nhưng giữ BillboardGui tên)
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr.Character then
        for _, part in pairs(plr.Character:GetChildren()) do
            if part:IsA("Accessory") or part:IsA("Shirt") or part:IsA("Pants") or part:IsA("ShirtGraphic") then
                part:Destroy()
            elseif (part:IsA("MeshPart") or part:IsA("Part")) and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 1
            end
        end
    end
end

-- ⚡ Xóa toàn bộ âm thanh cũ (mọi nơi)
local function clearSounds(parent)
    for _, s in pairs(parent:GetDescendants()) do
        if s:IsA("Sound") then
            s:Destroy()
        end
    end
end

clearSounds(workspace)
clearSounds(game:GetService("SoundService"))
clearSounds(game:GetService("ReplicatedStorage"))
clearSounds(game.Players.LocalPlayer:WaitForChild("PlayerGui"))

-- ⚡ Phát nhạc loop (mới)
local SoundService = game:GetService("SoundService")
local music = Instance.new("Sound", SoundService)
music.SoundId = "rbxassetid://118507373399694"
music.Looped = true
music.Volume = 5
music:Play()

-- ⚡ Hiển thị FPS
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
local FpsLabel = Instance.new("TextLabel", ScreenGui)

FpsLabel.Size = UDim2.new(0, 100, 0, 20)
FpsLabel.Position = UDim2.new(0.5, -60, 0, 0) -- lên sát mép trên
FpsLabel.BackgroundTransparency = 1
FpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
FpsLabel.TextStrokeTransparency = 0
FpsLabel.TextScaled = true
FpsLabel.Font = Enum.Font.SourceSansBold

local lastUpdate = tick()
local frames = 0
RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - lastUpdate >= 1 then
        FpsLabel.Text = "fps: " .. tostring(frames)
        frames = 0
        lastUpdate = tick()
    end
end)

-- ⚡ Ô vuông RGB quanh player
local function createBox(char)
    if char:FindFirstChild("HumanoidRootPart") and not char:FindFirstChild("RGBBox") then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "RGBBox"
        box.Adornee = char.HumanoidRootPart
        box.Size = Vector3.new(3, 3, 1)
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Transparency = 0.3
        box.Parent = char.HumanoidRootPart
    end
end

for _, plr in pairs(game.Players:GetPlayers()) do
    if plr.Character then createBox(plr.Character) end
    plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart")
        createBox(char)
    end)
end

-- ⚡ Đổi màu RGB liên tục
local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 1) % 360
    local color = Color3.fromHSV(hue/360, 1, 1)
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local box = plr.Character.HumanoidRootPart:FindFirstChild("RGBBox")
            if box then
                box.Color3 = color
            end
        end
    end
end)