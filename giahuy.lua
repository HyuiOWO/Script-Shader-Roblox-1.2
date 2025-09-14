--==[ SCRIPT FIX LAG AN TOÀN + FPS + NHẠC + MÔI TRƯỜNG ]==--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- ⚡ Xóa hiệu ứng nặng (vẫn giữ event game)
local function clearEffects(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire")
    or obj:IsA("Smoke") or obj:IsA("Explosion") or obj:IsA("Beam") then
        obj.Enabled = false
    elseif obj:IsA("SurfaceGui") then
        obj.Enabled = false
    elseif obj:IsA("Decal") then
        obj.Texture = ""
    end
end

for _, obj in pairs(workspace:GetDescendants()) do
    clearEffects(obj)
end

workspace.DescendantAdded:Connect(function(obj)
    clearEffects(obj)
end)

-- ⚡ Xóa toàn bộ âm thanh cũ
local function clearSounds(parent)
    for _, s in pairs(parent:GetDescendants()) do
        if s:IsA("Sound") then
            s:Destroy()
        end
    end
end

clearSounds(workspace)
clearSounds(SoundService)
clearSounds(game:GetService("ReplicatedStorage"))
clearSounds(LocalPlayer:WaitForChild("PlayerGui"))

-- ⚡ Phát nhạc loop mới
local music = Instance.new("Sound", SoundService)
music.SoundId = "rbxassetid://88663628557954"
music.Looped = true
music.Volume = 5
music:Play()

-- ⚡ Hiển thị FPS
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
local FpsLabel = Instance.new("TextLabel", ScreenGui)

FpsLabel.Size = UDim2.new(0, 100, 0, 20)
FpsLabel.Position = UDim2.new(0.5, -50, -0.5, 0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.TextStrokeTransparency = 0
FpsLabel.TextScaled = true
FpsLabel.Font = Enum.Font.SourceSansBold

local lastUpdate = tick()
local frames, hueFPS = 0, 0

RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - lastUpdate >= 1 then
        FpsLabel.Text = "FPS: " .. frames
        frames, lastUpdate = 0, tick()
    end
    hueFPS = (hueFPS + 1) % 360
    FpsLabel.TextColor3 = Color3.fromHSV(hueFPS/360, 1, 1)
end)

-- ⚡ Ẩn skin → đổi xám, giữ nguyên Part để event không hỏng
local function simplifyCharacter(char)
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("Accessory") or part:IsA("Shirt") or part:IsA("Pants") or part:IsA("ShirtGraphic") then
            part:Destroy()
        elseif (part:IsA("MeshPart") or part:IsA("Part")) and part.Name ~= "HumanoidRootPart" then
            part.Material = Enum.Material.SmoothPlastic
            part.Color = Color3.fromRGB(150, 150, 150) -- xám
        end
    end
end

local function loopSimplify()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            simplifyCharacter(plr.Character)
        end
    end
end

-- chạy loop mỗi 1s
task.spawn(function()
    while true do
        loopSimplify()
        task.wait(1)
    end
end)

-- ⚡ Tối ưu Lighting (tắt bóng, ánh sáng dư thừa)
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e6
Lighting.Brightness = 2
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.Outlines = false
pcall(function() Lighting.Atmosphere:Destroy() end)

-- ⚡ Đơn giản hóa biển
workspace.Terrain.WaterWaveSize = 0
workspace.Terrain.WaterWaveSpeed = 0
workspace.Terrain.WaterTransparency = 0
workspace.Terrain.WaterReflectance = 0
workspace.Terrain.WaterColor = Color3.fromRGB(180, 220, 250) -- xanh nhạt

-- ⚡ Đơn giản hóa mặt đất
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Part") or obj:IsA("MeshPart") then
        if obj.Material == Enum.Material.Grass or obj.Material == Enum.Material.Ground or obj.Material == Enum.Material.Sand then
            obj.Material = Enum.Material.SmoothPlastic
            obj.Color = Color3.fromRGB(150, 150, 150) -- xám
        end
    end
end