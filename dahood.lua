-- LocalScript
-- Put inside StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--// Settings
local menuVisible = true
local fovRadius = 150
local fovColor = Color3.fromRGB(255, 70, 70)
local silentAimEnabled = false -- UI setting only

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "EllaMain"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(390, 500)
main.Position = UDim2.new(0.5, -195, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = main

--// Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 50)
title.Position = UDim2.fromOffset(15, 10)
title.BackgroundTransparency = 1
title.Text = "ella main"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

--// Helper
local function makeButton(text, y)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 0, 45)
    button.Position = UDim2.fromOffset(15, y)
    button.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.TextSize = 15
    button.Font = Enum.Font.Gotham
    button.AutoButtonColor = true
    button.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = button

    return button
end

--// Silent Aim UI toggle
local silentButton = makeButton("Silent Aim: OFF", 75)

silentButton.MouseButton1Click:Connect(function()
    silentAimEnabled = not silentAimEnabled

    if silentAimEnabled then
        silentButton.Text = "Silent Aim: ON"
        silentButton.BackgroundColor3 = Color3.fromRGB(45, 120, 70)
    else
        silentButton.Text = "Silent Aim: OFF"
        silentButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    end
end)

--// FOV slider
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1, -30, 0, 30)
fovLabel.Position = UDim2.fromOffset(15, 135)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV Radius: 150"
fovLabel.TextColor3 = Color3.new(1, 1, 1)
fovLabel.TextSize = 15
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextXAlignment = Enum.TextXAlignment.Left
fovLabel.Parent = main

local slider = Instance.new("TextButton")
slider.Size = UDim2.new(1, -30, 0, 8)
slider.Position = UDim2.fromOffset(15, 170)
slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
slider.Text = ""
slider.Parent = main

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = slider

slider.MouseButton1Click:Connect(function()
    local mouse = player:GetMouse()
    local relative = math.clamp(
        (mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X,
        0,
        1
    )

    fovRadius = math.floor(25 + relative * 275)
    fovLabel.Text = "FOV Radius: " .. fovRadius
end)

--// FOV circle
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.fromScale(0.5, 0.5)
fovCircle.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Parent = gui

local stroke = Instance.new("UIStroke")
stroke.Color = fovColor
stroke.Thickness = 2
stroke.Transparency = 0.15
stroke.Parent = fovCircle

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = fovCircle

RunService.RenderStepped:Connect(function()
    fovCircle.Size = UDim2.fromOffset(
        fovRadius * 2,
        fovRadius * 2
    )

    fovCircle.Position = UDim2.fromScale(0.5, 0.5)
end)

--// FOV color buttons
local colors = {
    Color3.fromRGB(255, 60, 60),
    Color3.fromRGB(255, 150, 30),
    Color3.fromRGB(255, 230, 50),
    Color3.fromRGB(50, 220, 100),
    Color3.fromRGB(50, 150, 255),
    Color3.fromRGB(150, 70, 255),
    Color3.fromRGB(255, 70, 180),
    Color3.fromRGB(255, 255, 255)
}

for i, color in ipairs(colors) do
    local colorButton = Instance.new("TextButton")
    colorButton.Size = UDim2.fromOffset(28, 28)
    colorButton.Position = UDim2.fromOffset(15 + ((i - 1) * 35), 220)
    colorButton.BackgroundColor3 = color
    colorButton.Text = ""
    colorButton.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = colorButton

    colorButton.MouseButton1Click:Connect(function()
        fovColor = color
        stroke.Color = color
    end)
end

--// Right Ctrl = hide/show UI
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if input.KeyCode == Enum.KeyCode.RightControl then
        menuVisible = not menuVisible
        main.Visible = menuVisible
    end
end)
