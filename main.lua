
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "kopzetGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 470)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(128, 0, 128)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(54, 0, 54))
}
bgGradient.Rotation = 45
bgGradient.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Text = "kopzet"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(200, 150, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Parent = Frame

local container = Instance.new("Frame")
container.Size = UDim2.new(0, 260, 0, 370)
container.Position = UDim2.new(0.5, 0, 0, 50)
container.AnchorPoint = Vector2.new(0.5, 0)
container.BackgroundTransparency = 1
container.Parent = Frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

local function createButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextColor3 = Color3.fromRGB(50, 50, 50)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 20
    btn.Text = text
    btn.AutoButtonColor = true
    btn.LayoutOrder = order
    btn.Parent = container

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 180, 230)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 120, 190))
    }
    grad.Rotation = 90
    grad.Parent = btn

    return btn
end

local btnSpeed = createButton("Speed", 1)
local btnFly = createButton("Fly", 2)
local btnNoClip = createButton("NoClip", 3)
local btnESP = createButton("ESP", 4)

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, 0, 0, 30)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Font = Enum.Font.GothamSemibold
sliderLabel.TextSize = 20
sliderLabel.TextColor3 = Color3.fromRGB(200, 180, 230)
sliderLabel.Text = "Speed: 16"
sliderLabel.Visible = false
sliderLabel.LayoutOrder = 5
sliderLabel.Parent = container

local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(1, 0, 0, 20)
sliderBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
sliderBar.Visible = false
sliderBar.LayoutOrder = 6
sliderBar.Parent = container

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(16/5000, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(200, 180, 230)
sliderFill.Parent = sliderBar

-- === Переменные ===
local speedEnabled, flyEnabled, noClipEnabled, espEnabled = false, false, false, false
local flyForce
local speedValue = 16
local espHighlights = {}

local function toggleSpeed()
    speedEnabled = not speedEnabled
    humanoid.WalkSpeed = speedEnabled and speedValue or 16
    btnSpeed.Text = speedEnabled and "Speed: ON" or "Speed: OFF"
    sliderLabel.Visible = speedEnabled
    sliderBar.Visible = speedEnabled
end

local function toggleFly()
    flyEnabled = not flyEnabled
    local hrp = character:WaitForChild("HumanoidRootPart")

    if flyEnabled then
        humanoid.PlatformStand = true
        btnFly.Text = "Fly: ON"
        flyForce = Instance.new("BodyVelocity")
        flyForce.Velocity = Vector3.zero
        flyForce.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        flyForce.P = 1250
        flyForce.Name = "_FlyStealth"
        flyForce.Parent = hrp
    else
        humanoid.PlatformStand = false
        btnFly.Text = "Fly: OFF"
        if flyForce then
            flyForce:Destroy()
            flyForce = nil
        end
    end
end

local function toggleNoClip()
    noClipEnabled = not noClipEnabled
    btnNoClip.Text = noClipEnabled and "NoClip: ON" or "NoClip: OFF"
end

local function toggleESP()
    espEnabled = not espEnabled
    btnESP.Text = espEnabled and "ESP: ON" or "ESP: OFF"

    for _, hl in pairs(espHighlights) do hl:Destroy() end
    espHighlights = {}

    if espEnabled then
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
    if espEnabled and plr ~= player then
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            if espEnabled and char:FindFirstChild("HumanoidRootPart") then
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
    if noClipEnabled then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    if flyEnabled and flyForce then
        local cam = workspace.CurrentCamera
        local moveVec = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec -= Vector3.new(0,1,0) end

        local flySpeed = math.clamp(speedValue, 1, 250)
        flyForce.Velocity = moveVec.Magnitude > 0 and moveVec.Unit * flySpeed or Vector3.zero
    end
end)

btnSpeed.MouseButton1Click:Connect(toggleSpeed)
btnFly.MouseButton1Click:Connect(toggleFly)
btnNoClip.MouseButton1Click:Connect(toggleNoClip)
btnESP.MouseButton1Click:Connect(toggleESP)

player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    flyForce = nil
    speedEnabled, flyEnabled, noClipEnabled, espEnabled = false, false, false, false
    btnSpeed.Text, btnFly.Text, btnNoClip.Text, btnESP.Text = "Speed", "Fly", "NoClip", "ESP"
    sliderLabel.Visible = false
    sliderBar.Visible = false
end)

-- === Слайдер ===
local draggingSlider = false
sliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true end
end)
sliderBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
end)
sliderBar.InputChanged:Connect(function(input)
    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
        local newSpeed = math.floor((relX / sliderBar.AbsoluteSize.X) * 4999) + 1
        speedValue = newSpeed
        sliderFill.Size = UDim2.new(relX / sliderBar.AbsoluteSize.X, 0, 1, 0)
        sliderLabel.Text = "Speed: " .. speedValue
        if speedEnabled then
            humanoid.WalkSpeed = speedValue
        end
    end
end)
