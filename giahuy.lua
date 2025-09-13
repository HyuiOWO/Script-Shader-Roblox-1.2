--==[ SCRIPT FIX LAG + BOX RGB + FPS RGB ]==--

-- ⚡ Xóa hiệu ứng (giữ BillboardGui tên của Roblox)
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
for _, plr in pairs(game.Players:GetPlayers()) do
    if plr.Character then
        for _, part in pairs(plr.Character:GetChildren()) do
            if part:IsA("Accessory") or part:IsA("Shirt") or part:IsA("Pants") or part:IsA("ShirtGraphic") then
                part:Destroy()
            elseif (part:IsA("MeshPart") or part:IsA("Part")) and part.Name ~= "HumanoidRootPart" then
                part.Transparency = 1
            end
        end
    end
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
clearSounds(game:GetService("SoundService"))
clearSounds(game:GetService("ReplicatedStorage"))
clearSounds