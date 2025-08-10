local Players = game:GetService("Players")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "c0zgui free"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 250)
frame.Position = UDim2.new(0, 30, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(50, 0, 80)
frame.BorderColor3 = Color3.fromRGB(160, 90, 255)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Text = "c0zgui free"
title.Size = UDim2.new(1, 0, 0, 38)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(220, 200, 255)
title.BackgroundColor3 = Color3.fromRGB(90, 0, 160)
title.BorderSizePixel = 0
title.Parent = frame

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 1, -80)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1
container.Parent = frame

local layout = Instance.new("UIGridLayout")
layout.CellSize = UDim2.new(0.5, -5, 0, 36)
layout.CellPadding = UDim2.new(0, 10, 0, 10)
layout.FillDirection = Enum.FillDirection.Horizontal
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

local function newButton(text)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(160, 90, 255)
    btn.TextColor3 = Color3.fromRGB(20, 10, 30)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 20
    btn.Text = text
    btn.AutoButtonColor = true
    btn.Parent = container
    return btn
end

-- Фиктивные кнопки
local speedBtn = newButton("Speed")
local flyBtn = newButton("Fly")
local noclipBtn = newButton("NoClip")
local espBtn = newButton("ESP")

-- Сообщение про обновление
local updateLabel = Instance.new("TextLabel")
updateLabel.Size = UDim2.new(1, 0, 0, 20)
updateLabel.Position = UDim2.new(0, 0, 1, -25)
updateLabel.Font = Enum.Font.GothamBold
updateLabel.TextSize = 16
updateLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
updateLabel.BackgroundTransparency = 1
updateLabel.Text = "A Dumper update is required"
updateLabel.Parent = frame

-- Заглушки функций
speedBtn.MouseButton1Click:Connect(function()
    speedBtn.Text = "Speed"
end)

flyBtn.MouseButton1Click:Connect(function()
    flyBtn.Text = "Fly"
end)

noclipBtn.MouseButton1Click:Connect(function()
    noclipBtn.Text = "NoClip"
end)

espBtn.MouseButton1Click:Connect(function()
    espBtn.Text = "ESP"
end)
