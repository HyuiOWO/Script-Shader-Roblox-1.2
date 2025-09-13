--===[ SCRIPT FIX LAG + Ô VUÔNG RGB HIỂN THỊ NGƯỜI CHƠI ]===--

-- ⚡ Xóa hiệu ứng, âm thanh
for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Explosion") then
        obj:Destroy()
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj:Destroy()
    elseif obj:IsA("Sound") then
        obj:Destroy()
    end
end

-- ⚡ Phát nhạc thay thế (loop)
local SoundService = game:GetService("SoundService")
local bgm = Instance.new("Sound")
bgm.SoundId = "rbxassetid://87233041213837"
bgm.Volume = 1
bgm.Looped = true
bgm.Parent = SoundService
bgm:Play()

-- ⚡ Hiển thị FPS nhỏ nhỏ giữa màn hình
local RunService = game:GetService("RunService")
local fpsGui = Instance.new("ScreenGui", game.CoreGui)
local fpsLabel = Instance.new("TextLabel", fpsGui)
fpsLabel.Size = UDim2.new(0,100,0,20)
fpsLabel.Position = UDim2.new(0.5,-50,0,10)
fpsLabel.BackgroundTransparency = 1
fpsLabel.TextColor3 = Color3.new(1,1,1)
fpsLabel.TextStrokeTransparency = 0.5
fpsLabel.TextScaled = true

local last = tick()
local frames = 0
RunService.RenderStepped:Connect(function()
    frames = frames + 1
    if tick() - last >= 1 then
        fpsLabel.Text = "FPS: "..frames
        frames = 0
        last = tick()
    end
end)

-- ⚡ Ô vuông RGB hiển thị người chơi
local Players = game:GetService("Players")

local function addBox(player)
    if player == Players.LocalPlayer then return end
    player.CharacterAdded:Connect(function(char)
        task.wait(1)
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Box RGB
            local box = Instance.new("BoxHandleAdornment")
            box.Adornee = hrp
            box.AlwaysOnTop = true
            box.Size = Vector3.new(2,5,1)
            box.ZIndex = 0
            box.Transparency = 0.5
            box.Parent = hrp

            -- Tên có scale theo khoảng cách
            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = hrp
            billboard.Size = UDim2.new(0,100,0,20)
            billboard.StudsOffset = Vector3.new(0,3,0)
            billboard.AlwaysOnTop = true
            billboard.MaxDistance = 100 -- xa hơn thì tên bé + mờ
            billboard.Parent = hrp

            local text = Instance.new("TextLabel", billboard)
            text.Size = UDim2.new(1,0,1,0)
            text.BackgroundTransparency = 1
            text.Text = player.Name
            text.TextColor3 = Color3.fromRGB(255,255,255)
            text.TextScaled = true

            -- Đổi màu RGB liên tục
            task.spawn(function()
                local t = 0
                while char.Parent and hrp.Parent and box.Parent do
                    t = t + RunService.RenderStepped:Wait()
                    box.Color3 = Color3.fromHSV((tick()%5)/5,1,1)
                end
            end)
        end
    end)
end

for _,plr in pairs(Players:GetPlayers()) do
    addBox(plr)
end
Players.PlayerAdded:Connect(addBox)
