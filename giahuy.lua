--==[ SCRIPT FIX LAG FULL (ẩn thay vì xoá) ]==--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- ⚡ Xóa hiệu ứng nặng (particle/sound/music)
local function clearEffects()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") 
        or obj:IsA("Smoke") or obj:IsA("Explosion") or obj:IsA("Beam") then
            obj:Destroy()
        elseif obj:IsA("Sound") then
            obj:Destroy()
        end
    end
    for _, s in pairs(SoundService:GetDescendants()) do
        if s:IsA("Sound") then s:Destroy() end
    end
end
clearEffects()

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") 
    or obj:IsA("Smoke") or obj:IsA("Explosion") or obj:IsA("Beam") 
    or obj:IsA("Sound") then
        obj:Destroy()
    end
end)

-- ⚡ Phát nhạc mới
local music = Instance.new("Sound", SoundService)
music.SoundId = "rbxassetid://88663628557954"
music.Looped = true
music.Volume = 2
music:Play()

-- ⚡ Làm skin + phụ kiện thành màu xám
local function grayCharacter(char)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("MeshPart") or part:IsA("Part") then
            if part.Name ~= "HumanoidRootPart" then
                part.Color = Color3.fromRGB(128, 128, 128) -- xám
                part.Material = Enum.Material.SmoothPlastic
            end
        elseif part:IsA("Accessory") then
            for _, p in pairs(part:GetDescendants()) do
                if p:IsA("Part") or p:IsA("MeshPart") then
                    p.Color = Color3.fromRGB(128, 128, 128)
                    p.Material = Enum.Material.SmoothPlastic
                end
            end
        elseif part:IsA("Shirt") or part:IsA("Pants") or part:IsA("ShirtGraphic") then
            part:Destroy() -- bỏ áo quần, chỉ rối thêm
        end
    end
end

for _, plr in pairs(Players:GetPlayers()) do
    if plr.Character then grayCharacter(plr.Character) end
    plr.CharacterAdded:Connect(function(char)
        grayCharacter(char)
    end)
end

-- ⚡ Lặp lại mỗi 1s để chắc ăn
task.spawn(function()
    while task.wait(1) do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then grayCharacter(plr.Character) end
        end
    end
end)

-- ⚡ FPS counter (RGB)
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
local FpsLabel = Instance.new("TextLabel", ScreenGui)
FpsLabel.Size = UDim2.new(0, 80, 0, 20)
FpsLabel.Position = UDim2.new(0.5, -60, -0.2, 0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.TextStrokeTransparency = 0
FpsLabel.TextScaled = true
FpsLabel.Font = Enum.Font.SourceSansBold

local lastUpdate, frames, hueFPS = tick(), 0, 0
RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - lastUpdate >= 1 then
        FpsLabel.Text = "FPS: "..frames
        frames, lastUpdate = 0, tick()
    end
    hueFPS = (hueFPS + 1) % 360
    FpsLabel.TextColor3 = Color3.fromHSV(hueFPS/360, 1, 1)
end)

-- ⚡ Tối ưu môi trường (biển, đất, trời, ánh sáng)
-- Biển xanh nhạt tĩnh
if workspace:FindFirstChildOfClass("Terrain") then
    local t = workspace.Terrain
    t.WaterColor = Color3.fromRGB(173, 216, 230) -- xanh nhạt
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterTransparency = 0
end

-- Đất thành xám
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("Part") or obj:IsA("MeshPart") then
        if obj.Material == Enum.Material.Grass or obj.Material == Enum.Material.Ground or obj.Material == Enum.Material.Sand then
            obj.Color = Color3.fromRGB(128, 128, 128)
            obj.Material = Enum.Material.SmoothPlastic
        end
    end
end

-- Xóa bầu trời
for _, obj in pairs(Lighting:GetChildren()) do
    if obj:IsA("Sky") then obj:Destroy() end
end

-- Tắt ánh sáng / bóng tối
Lighting.GlobalShadows = false
Lighting.Brightness = 0