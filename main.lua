local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local gui = Instance.new("ScreenGui")
gui.Name = "c0zgui"
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
title.Text = "c0zgui"
title.Size = UDim2.new(1, 0, 0, 38)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(220, 200, 255)
title.BackgroundColor3 = Color3.fromRGB(90, 0, 160)
title.BorderSizePixel = 0
title.Parent = frame

local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 1, -60)
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

local speedBtn = newButton("Speed")
local flyBtn = newButton("Fly")
local noclipBtn = newButton("NoClip")
local espBtn = newButton("ESP")

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, 0, 0, 20)
sliderLabel.Font = Enum.Font.GothamSemibold
sliderLabel.TextSize = 18
sliderLabel.TextColor3 = Color3.fromRGB(220, 200, 255)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Speed: 16"
sliderLabel.Visible = false
sliderLabel.Position = UDim2.new(0, 10, 1, -35)
sliderLabel.Parent = frame

local slider = Instance.new("Frame")
slider.Size = UDim2.new(1, -20, 0, 14)
slider.Position = UDim2.new(0, 10, 1, -20)
slider.BackgroundColor3 = Color3.fromRGB(70, 30, 120)
slider.Visible = false
slider.Parent = frame

local fill = Instance.new("Frame")
fill.Size = UDim2.new(16/5000, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(190, 120, 255)
fill.BorderSizePixel = 0
fill.Parent = slider

local speed = 16
local speedOn = false
local flyOn = false
local noclipOn = false
local espOn = false
local flyVel = nil
local espHighlights = {}

local function toggleSpeed()
    speedOn = not speedOn
    humanoid.WalkSpeed = speedOn and speed or 16
    speedBtn.Text = speedOn and "Speed: ON" or "Speed"
    slider.Visible = speedOn
    sliderLabel.Visible = speedOn
end

local function toggleFly()
    flyOn = not flyOn
    local root = character:WaitForChild("HumanoidRootPart")
    humanoid.PlatformStand = flyOn
    flyBtn.Text = flyOn and "Fly: ON" or "Fly"
    if flyOn then
        flyVel = Instance.new("BodyVelocity")
        flyVel.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        flyVel.P = 1250
        flyVel.Velocity = Vector3.zero
        flyVel.Name = "FlyForce"
        flyVel.Parent = root
    elseif flyVel then
        flyVel:Destroy()
    end
end

local function toggleNoClip()
    noclipOn = not noclipOn
    noclipBtn.Text = noclipOn and "NoClip: ON" or "NoClip"
end

local function toggleESP()
    espOn = not espOn
    espBtn.Text = espOn and "ESP: ON" or "ESP"
    for _, hl in pairs(espHighlights) do hl:Destroy() end
    espHighlights = {}
    if espOn then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(170, 0, 255)
                highlight.OutlineColor = Color3.fromRGB(100, 0, 150)
                highlight.Adornee = plr.Character
                highlight.Parent = workspace
                espHighlights[plr] = highlight
            end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    if espOn and plr ~= player then
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if espOn and char:FindFirstChild("HumanoidRootPart") then
                local highlight = Instance.new("Highlight")
                highlight.FillColor = Color3.fromRGB(170, 0, 255)
                highlight.OutlineColor = Color3.fromRGB(100, 0, 150)
                highlight.Adornee = char
                highlight.Parent = workspace
                espHighlights[plr] = highlight
            end
        end)
    end
end)

RunService.Stepped:Connect(function()
    if noclipOn then
        for _, p in pairs(character:GetChildren()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
    if flyOn and flyVel then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        local flySpeed = math.clamp(speed, 1, 250)
        flyVel.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
    end
end)

speedBtn.MouseButton1Click:Connect(toggleSpeed)
flyBtn.MouseButton1Click:Connect(toggleFly)
noclipBtn.MouseButton1Click:Connect(toggleNoClip)
espBtn.MouseButton1Click:Connect(toggleESP)

local dragging = false
slider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
end)
slider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
slider.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local pos = math.clamp(input.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
        speed = math.floor((pos / slider.AbsoluteSize.X) * 4999) + 1
        fill.Size = UDim2.new(pos / slider.AbsoluteSize.X, 0, 1, 0)
        sliderLabel.Text = "Speed: " .. speed
        if speedOn then humanoid.WalkSpeed = speed end
    end
end)
