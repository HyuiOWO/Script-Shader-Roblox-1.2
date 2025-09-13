--===[ SCRIPT GIẢM LAG + NHẠC LOOP + FPS ]===--

-- ⚡ Giảm lag
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Explosion") then
        obj:Destroy()
    elseif obj:IsA("Sound") and obj.Name ~= "GameMusic" then
        obj:Destroy()
    end
end

settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
workspace.GlobalShadows = false
if workspace:FindFirstChildOfClass("Terrain") then
    workspace.Terrain.WaterWaveSize = 0
    workspace.Terrain.WaterWaveSpeed = 0
    workspace.Terrain.WaterReflectance = 0
    workspace.Terrain.WaterTransparency = 1
end

-- ⚡ Phát nhạc loop
local SoundService = game:GetService("SoundService")
for _, s in pairs(SoundService:GetChildren()) do
    if s:IsA("Sound") then
        s:Destroy()
    end
end

local music = Instance.new("Sound")
music.Name = "GameMusic"
music.SoundId = "rbxassetid://87086838053275"
music.Looped = true
music.Volume = 1
music.Parent = SoundService
music:Play()

-- ⚡ Hiển thị FPS
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Parent = ScreenGui
fpsLabel.Size = UDim2.new(0, 120, 0, 20)
fpsLabel.Position = UDim2.new(0.5, -60, 0, 5) -- Giữa trên
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.new(1, 1, 1)
fpsLabel.TextStrokeTransparency = 0
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 18
fpsLabel.Text = "FPS: ..."

-- Đếm FPS bằng Heartbeat (ổn hơn RenderStepped trên KRNL)
local RunService = game:GetService("RunService")
local fps = 0
RunService.Heartbeat:Connect(function()
    fps = fps + 1
end)

while true do
    fpsLabel.Text = "FPS: " .. fps
    fps = 0
    wait(1)
end
