--==[ SCRIPT FIX LAG FULL TỐI ƯU + LOOP XÓA SKIN ]==--

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain

-- ⚡ Xóa hiệu ứng (giữ BillboardGui để còn thấy tên)
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

-- ⚡ Hàm xoá skin / chuyển thành xám
local function grayCharacter(char)
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("Accessory") or part:IsA("Shirt") or part:IsA("Pants") or part:IsA("ShirtGraphic") then
            part:Destroy()
        elseif (part:IsA("MeshPart") or part:IsA("Part")) and part.Name ~= "HumanoidRootPart" then
            part.Material = Enum.Material.SmoothPlastic
            part.Color = Color3.fromRGB(128, 128, 128) -- xám
        end
    end
end

-- Xử lý khi player spawn
for _, plr in pairs(Players:GetPlayers()) do
    if plr.Character then grayCharacter(plr.Character) end
    plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart")
        grayCharacter(char)
    end)
end

-- Loop xoá skin liên tục (mỗi 1s)
task.spawn(function()
    while true do
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                grayCharacter(plr.Character)
            end
        end
        task.wait(1)
    end
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

-- ⚡ Phát nhạc mới
local music = Instance.new("Sound", SoundService)
music.SoundId = "rbxassetid://87233041213837"
music.Looped = true
music.Volume = 1
music:Play()

-- ⚡ Hiển thị FPS nhỏ trên cùng
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
local FpsLabel = Instance.new("TextLabel", ScreenGui)

FpsLabel.Size = UDim2.new(0, 80, 0, 15)
FpsLabel.Position = UDim2.new(0.5, -40, -0.1, 0)
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
        FpsLabel.Text = "FPS: " .. tostring(frames)
        frames = 0
        lastUpdate = tick()
    end
end)

-- ⚡ Tối ưu map: xóa trời, đất xám, biển xanh nhạt không animation
if workspace:FindFirstChildOfClass("Sky") then
    workspace:FindFirstChildOfClass("Sky"):Destroy()
end

Terrain.WaterColor = Color3.fromRGB(173, 216, 230) -- xanh nhạt
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 0

for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and (obj.Name:lower():find("ground") or obj.Name:lower():find("grass")) then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Color = Color3.fromRGB(128, 128, 128) -- xám
    end
end

-- ⚡ Tắt ánh sáng và bóng tối
Lighting.FogEnd = 1e9
Lighting.Brightness = 0
Lighting.GlobalShadows = false
Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)

-- ⚡ Tắt đèn trong game (PointLight, SpotLight, SurfaceLight)
for _, light in pairs(workspace:GetDescendants()) do
    if light:IsA("PointLight") or light:IsA("SpotLight") or light:IsA("SurfaceLight") then
        light.Enabled = false
    end
end
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
        obj.Enabled = false
    end
end)