--===[ GUI Auto Sell Fish ]===--

-- Auto Sell Function
local function autoSell()
    local rs = game:GetService("ReplicatedStorage")
    local remoteFunc = rs.Modules.Utility.Network.Functions.RemoteFunction

    local args = {
        [1] = "SellInventory",
        [3] = tick()
    }
    remoteFunc:InvokeServer(unpack(args))
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- Main Frame (GUI to)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.Text = "Auto Fishing GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

-- Sell Button
local SellButton = Instance.new("TextButton")
SellButton.Size = UDim2.new(0, 200, 0, 50)
SellButton.Position = UDim2.new(0.5, -100, 0.5, -25)
SellButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
SellButton.Text = "Sell Fish"
SellButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SellButton.Parent = MainFrame

SellButton.MouseButton1Click:Connect(function()
    autoSell()
end)

-- Small Toggle Button (ngoài)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Position = UDim2.new(0.05, 0, 0.05, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
ToggleButton.Text = "Toggle GUI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)