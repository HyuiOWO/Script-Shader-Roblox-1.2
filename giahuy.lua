--==[ SCRIPT FIX LAG + RGB BOX + TÊN + FPS + NHẠC MỚI ]==--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

-- ⚡ Xóa hiệu ứng (giữ lại BillboardGui tên)
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

-- ⚡ Xóa skin người chơi (giữ BillboardGui tên)
local function clearCharacter(char)
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("Accessory") or part:IsA("Shirt") or part:IsA("Pants") or part:IsA("ShirtGraphic") then
            part:Destroy()
        elseif (part:IsA("MeshPart") or part:IsA("Part")) and part.Name ~= "HumanoidRootPart" then
            part.Transparency = 1
        end
    end
end

for _, plr in pairs(Players:GetPlayers()) do
    if plr.Character then clearCharacter(plr.Character) end
    plr.CharacterAdded:Connect(function(char)
        clearCharacter(char)
    end)
end

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
music.SoundId = "rbxassetid://119880103715646"
music.Looped = true
music.Volume = 3
music:Play()

-- ⚡ Hiển thị FPS
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
local FpsLabel = Instance.new("TextLabel", ScreenGui)
FpsLabel.Size = UDim2.new(0, 80, 0, 20)
FpsLabel.Position = UDim2.new(0.5, -60, 0, 0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.TextStrokeTransparency = 0
FpsLabel.TextScaled = true
FpsLabel.Font = Enum.Font.SourceSansBold

local lastUpdate = tick()
local frames = 0
local hueFPS = 0
RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - lastUpdate >= 1 then
        FpsLabel.Text = "FPS: "..frames
        frames = 0
        lastUpdate = tick()
    end
    hueFPS = (hueFPS + 1) % 360
    FpsLabel.TextColor3 = Color3.fromHSV(hueFPS/360, 1, 1)
end)

-- ⚡ Ô vuông RGB + Tên nhỏ trên ô
local function createBox(char, plr)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp or hrp:FindFirstChild("RGBBox") then return end

    -- Box RGB
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "RGBBox"
    box.Adornee = hrp
    box.Size = Vector3.new(2, 2, 1)
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.5
    box.Parent = hrp

    -- Tên nhỏ trên ô
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerName"
    billboard.Adornee = hrp
    billboard.Size = UDim2.new(0,100,0,20)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true
    billboard.Parent = hrp

    local text = Instance.new("TextLabel", billboard)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Text = plr.Name
    text.TextColor3 = Color3.fromRGB(255,255,255) -- không RGB
    text.TextStrokeTransparency = 0
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
end

-- Tạo box cho tất cả player hiện tại và khi spawn
for _, plr in pairs(Players:GetPlayers()) do
    if plr.Character then createBox(plr.Character, plr) end
    plr.CharacterAdded:Connect(function(char)
        createBox(char, plr)
    end)
end

-- ⚡ Đổi màu RGB liên tục cho box
local hue = 0
RunService.RenderStepped:Connect(function()
    hue = (hue + 1) % 360
    local color = Color3.fromHSV(hue/360,1,1)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local box = plr.Character.HumanoidRootPart:FindFirstChild("RGBBox")
            if box then box.Color3 = color end
        end
    end
end)