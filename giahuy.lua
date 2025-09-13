--==[ SCRIPT FIX LAG FULL + Ô VUÔNG RGB HIỂN THỊ NGƯỜI CHƠI ]==--

-- ⚡ Xóa hiệu ứng
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") 
    or obj:IsA("Smoke") or obj:IsA("Explosion") or obj:IsA("Beam") then
        obj:Destroy()
    elseif obj:IsA("SurfaceGui") or obj:IsA("BillboardGui") then
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
    end
end)

-- ⚡ Xóa skin người chơi + NPC
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr.Character then
        for _, part in pairs(plr.Character:GetChildren()) do
            if part:IsA("Accessory") or part:IsA("Shirt") or part:IsA("Pants") or part:IsA("ShirtGraphic") then
                part:Destroy()
            elseif part:IsA("MeshPart") or part:IsA("Part") then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                end
            end
        end
    end
end

for _, npc in pairs(workspace:GetDescendants()) do
    if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
        for _, part in pairs(npc:GetChildren()) do
            if part:IsA("Accessory") or part:IsA("Shirt") or part:IsA("Pants") then
                part:Destroy()
            elseif part:IsA("MeshPart") or part:IsA("Part") then
                if part.Name ~= "HumanoidRootPart" then
                    part.Transparency = 1
                end
            end
        end
    end
end

-- ⚡ Xóa toàn bộ âm thanh
for _, s in pairs(workspace:GetDescendants()) do
    if s:IsA("Sound") then
        s:Destroy()
    end
end

-- ⚡ Phát nhạc loop
local SoundService = game:GetService("SoundService")
local music = Instance.new("Sound", SoundService)
music.SoundId = "rbxassetid://87233041213837"
music.Looped = true
music.Volume = 1
music:Play()

-- ⚡ Hiển thị FPS (sát trên màn hình, cập nhật mỗi giây)
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
local FpsLabel = Instance.new("TextLabel", ScreenGui)

FpsLabel.Size = UDim2.new(0, 100, 0, 20)
FpsLabel.Position = UDim2.new(0.5, -50, 0, 0) -- sát trên màn hình
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

-- ⚡ Ô vuông RGB hiển thị player
local Players = game:GetService("Players")

local function addBox(plr)
    if plr == player then return end
    plr.CharacterAdded:Connect(function(char)
        task.wait(1)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local box = Instance.new("BoxHandleAdornment")
            box.Adornee = hrp
            box.AlwaysOnTop = true
            box.Size = Vector3.new(2, 5, 1) -- vừa người
            box.Transparency = 0.5
            box.ZIndex = 0
            box.Parent = hrp

            -- RGB đổi màu
            task.spawn(function()
                while char.Parent and hrp.Parent and box.Parent do
                    RunService.RenderStepped:Wait()
                    box.Color3 = Color3.fromHSV((tick() % 5) / 5, 1, 1)
                end
            end)
        end
    end)
end

for _, plr in pairs(Players:GetPlayers()) do
    addBox(plr)
end
Players.PlayerAdded:Connect(addBox)