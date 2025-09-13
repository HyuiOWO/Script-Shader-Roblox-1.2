--===[ SCRIPT GIẢM LAG + PHÁT NHẠC LOOP + HIỂN THỊ FPS ]===--

-- ⚡ Giảm lag: xóa hiệu ứng không cần thiết
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") then
        obj:Destroy()
    elseif obj:IsA("Explosion") or obj:IsA("Sparkles") then
        obj:Destroy()
    elseif obj:IsA("Sound") and obj.Name ~= "GameMusic" then
        obj:Destroy()
    end
end

-- ⚡ Giảm đồ họa: tắt bóng, nước, hiệu ứng thừa
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
workspace.GlobalShadows = false
workspace.FallenPartsDestroyHeight = -5000
if workspace:FindFirstChildOfClass("Terrain") then
    workspace.Terrain.WaterWaveSize = 0
    workspace.Terrain.WaterWaveSpeed = 0
    workspace.Terrain.WaterReflectance = 0
    workspace.Terrain.WaterTransparency = 1
end

-- ⚡ Phát nhạc loop (xóa music cũ, phát nhạc mới)
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

-- ⚡ Hiển thị FPS ở giữa trên màn hình
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FPSGui"
ScreenGui.Parent = game:GetService("CoreGui")

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Parent = ScreenGui
fpsLabel.Size = UDim2.new(0, 100, 0, 20)
fpsLabel.Position = UDim2.new(0.5, -50, 0, 5) -- Giữa trên
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.new(1, 1, 1) -- Trắng
fpsLabel.TextStrokeTransparency = 0 -- Viền đen
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 18
fpsLabel.Text = "FPS: ..."

local fps = 0
game:GetService("RunService").RenderStepped:Connect(function()
    fps = fps + 1
end)

task.spawn(function()
    while true do
        fpsLabel.Text = "FPS: " .. fps
        fps = 0
        task.wait(1) -- cập nhật mỗi giây
    end
end)
