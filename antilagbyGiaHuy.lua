-- ⚡ Roblox Ultimate FPS Boost + Music + FPS Counter (FPS ở trên giữa)
-- Giảm đồ họa tối đa + phát nhạc ID 115925172742147 (loop) + hiển thị FPS

-- Xóa âm thanh cũ
for _, sound in ipairs(workspace:GetDescendants()) do
    if sound:IsA("Sound") then
        sound:Destroy()
    end
end

-- Tạo nhạc mới (loop)
local SoundService = game:GetService("SoundService")
local newMusic = Instance.new("Sound")
newMusic.SoundId = "rbxassetid://87086838053275"
newMusic.Looped = true
newMusic.Volume = 1
newMusic.Parent = SoundService
newMusic:Play()

-- Tắt hiệu ứng hình ảnh (Particles, Trails, Beams, Explosions)
for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Explosion") then
        v:Destroy()
    end
end

-- Giản lược vật liệu phức tạp thành màu trơn
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
    end
end

-- Xóa bề mặt nước động
workspace.Terrain.WaterWaveSize = 0
workspace.Terrain.WaterWaveSpeed = 0
workspace.Terrain.WaterTransparency = 1
workspace.Terrain.WaterReflectance = 0

-- Xóa texture / decal phức tạp
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Texture") or obj:IsA("Decal") then
        obj:Destroy()
    end
end

-- Xóa mặt trời, mây, hiệu ứng ánh sáng
local lighting = game:GetService("Lighting")
for _, v in ipairs(lighting:GetChildren()) do
    if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") then
        v:Destroy()
    end
end
lighting.FogEnd = 1e9
lighting.Brightness = 0
lighting.GlobalShadows = false
lighting.OutdoorAmbient = Color3.new(1, 1, 1)

-- Xóa animation dư thừa (giữ lại di chuyển cơ bản)
for _, plr in ipairs(game.Players:GetPlayers()) do
    if plr.Character then
        for _, anim in ipairs(plr.Character:GetDescendants()) do
            if anim:IsA("Animation") then
                anim:Destroy()
            end
        end
    end
end

-- Giảm chất lượng render xuống mức thấp nhất
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Low

-- Hiển thị FPS trên giữa màn hình
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.IgnoreGuiInset = true

local fpsLabel = Instance.new("TextLabel", gui)
fpsLabel.Size = UDim2.new(0, 100, 0, 20)
fpsLabel.Position = UDim2.new(0.5, -50, 0, 5) -- trên giữa
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.new(1, 1, 1) -- trắng
fpsLabel.TextStrokeTransparency = 0 -- viền đen
fpsLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
fpsLabel.TextSize = 12 -- nhỏ xíu
fpsLabel.Font = Enum.Font.Code
fpsLabel.Text = "FPS: ..."

-- Đếm FPS và cập nhật mỗi giây
local RunService = game:GetService("RunService")
local frames, lastTime = 0, tick()

RunService.RenderStepped:Connect(function()
    frames += 1
    local now = tick()
    if now - lastTime >= 1 then
        fpsLabel.Text = "FPS: " .. tostring(frames)
        frames = 0
        lastTime = now
    end
end)

-- Thông báo hoàn tất
game.StarterGui:SetCore("SendNotification", {
    Title = "Ultimate FPS Boost";
    Text = "Đã giảm đồ họa, tối ưu FPS, phát nhạc và bật FPS counter!";
    Duration = 5;
})
