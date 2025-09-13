-- ⚡ Roblox FPS Boost + No Effects + Hide Skins

-- Xóa âm thanh cũ
for _, s in pairs(workspace:GetDescendants()) do
    if s:IsA("Sound") then s:Destroy() end
end

-- Phát nhạc loop
local SoundService = game:GetService("SoundService")
local music = Instance.new("Sound")
music.SoundId = "rbxassetid://87233041213837"
music.Looped = true
music.Volume = 1
music.Parent = SoundService
music:Play()

-- Các hiệu ứng cần chặn
local effects = {
    "ParticleEmitter","Trail","Beam","Explosion","Fire","Smoke",
    "Sparkles","Highlight","PointLight","SurfaceLight","SpotLight"
}

-- Hàm xoá hiệu ứng
local function removeEffects(obj)
    for _, v in pairs(obj:GetDescendants()) do
        if table.find(effects, v.ClassName) then
            v:Destroy()
        end
    end
end

-- Xóa hiệu ứng hiện tại
removeEffects(workspace)
removeEffects(game.Lighting)

-- Tự động xoá hiệu ứng mới
workspace.DescendantAdded:Connect(function(obj)
    if table.find(effects, obj.ClassName) then obj:Destroy() end
end)
game.Lighting.DescendantAdded:Connect(function(obj)
    if table.find(effects, obj.ClassName) then obj:Destroy() end
end)

-- Ẩn skin + item
local function simplifyChar(char)
    for _, p in pairs(char:GetDescendants()) do
        if p:IsA("Accessory") or p:IsA("Clothing") or p:IsA("Shirt") 
        or p:IsA("Pants") or p:IsA("ShirtGraphic") or p:IsA("BodyColors") then
            p:Destroy()
        end
        if p:IsA("Decal") or p:IsA("Texture") then
            p:Destroy()
        end
        if p:IsA("Tool") or p.Parent:IsA("Tool") then
            if p:IsA("BasePart") then p.Transparency = 1 end
        end
    end
end

-- Người chơi có sẵn
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr.Character then simplifyChar(plr.Character) end
    plr.CharacterAdded:Connect(simplifyChar)
end

-- NPC
for _, m in pairs(workspace:GetDescendants()) do
    if m:IsA("Model") and m:FindFirstChildOfClass("Humanoid") then
        simplifyChar(m)
    end
end

-- Giảm chất lượng render
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

-- Thông báo
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "FPS Boost",
        Text = "Đã bật giảm lag + chặn hiệu ứng + ẩn skin!",
        Duration = 5
    })
end)
