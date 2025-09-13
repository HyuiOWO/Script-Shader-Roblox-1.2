-- ⚡ Roblox Ultimate FPS Boost + Music + No Effects
-- Xóa hiệu ứng, chặn hiệu ứng mới, giảm đồ họa, phát nhạc ID 87086838053275 (loop), ẩn skin + vũ khí

-- Xóa âm thanh cũ
for _, sound in ipairs(workspace:GetDescendants()) do
    if sound:IsA("Sound") then
        sound:Destroy()
    end
end

-- Tạo nhạc mới (loop)
local SoundService = game:GetService("SoundService")
local newMusic = Instance.new("Sound")
newMusic.SoundId = "rbxassetid://87233041213837"
newMusic.Looped = true
newMusic.Volume = 1
newMusic.Parent = SoundService
newMusic:Play()

-- Danh sách class hiệu ứng cần chặn
local blockedEffects = {
    "ParticleEmitter", "Trail", "Beam", "Explosion",
    "Fire", "Smoke", "Sparkles", "Highlight", "PointLight",
    "SurfaceLight", "SpotLight"
}

-- Hàm xóa hiệu ứng
local function clearEffects(obj)
    for _, v in ipairs(obj:GetDescendants()) do
        if table.find(blockedEffects, v.ClassName) then
            v:Destroy()
        end
    end
end

-- Lọc toàn bộ hiện tại
clearEffects(workspace)
clearEffects(game:GetService("Lighting"))

-- Chặn hiệu ứng mới
workspace.DescendantAdded:Connect(function(obj)
    if table.find(blockedEffects, obj.ClassName) then
        obj:Destroy()
    end
end)

game:GetService("Lighting").DescendantAdded:Connect(function(obj)
    if table.find(blockedEffects, obj.ClassName) then
        obj:Destroy()
    end
end)

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
    if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") 
    or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") then
        v:Destroy()
    end
end
lighting.FogEnd = 1e9
lighting.Brightness = 0
lighting.GlobalShadows = false
lighting.OutdoorAmbient = Color3.new(1, 1, 1)

-- Ẩn skin NPC và người chơi (giữ dạng blocky)
local function simplifyCharacter(char)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("Accessory") or part:IsA("Clothing") or part:IsA("ShirtGraphic")
        or part:IsA("Pants") or part:IsA("Shirt") or part:IsA("BodyColors")
        or part:IsA("Decal") or part:IsA("Texture") then
            part:Destroy()
        end
        -- Ẩn tool/vũ khí
        if part:IsA("Tool") or part.Parent:IsA("Tool") then
            for _, mesh in ipairs(part:GetDescendants()) do
                if mesh:IsA("BasePart") then
                    mesh.Transparency = 1
                elseif mesh:IsA("Texture") or mesh:IsA("Decal") then
                    mesh:Destroy()
                end
            end
        end
    end
end

-- Áp dụng cho người chơi hiện tại + người chơi mới vào
for _, plr in ipairs(game.Players:GetPlayers()) do
    if plr.Character then
        simplifyCharacter(plr.Character)
    end
    plr.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart")
        simplifyCharacter(char)
    end)
end

-- Áp dụng cho NPC trong workspace
for _, model in ipairs(workspace:GetDescendants()) do
    if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") then
        simplifyCharacter(model)
    end
end

-- Giảm chất lượng render xuống mức thấp nhất
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Low

-- Thông báo hoàn tất
game.StarterGui:SetCore("SendNotification", {
    Title = "Ultimate FPS Boost";
    Text = "Đã giảm đồ họa, phát nhạc, chặn skin & hiệu ứng!";
    Duration = 5;
})
