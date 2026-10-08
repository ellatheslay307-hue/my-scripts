--[[
    ELLA MAIN 🎀 - WORKING STUDIO VERSION

    Put this LocalScript in:
    StarterPlayer > StarterPlayerScripts

    This version provides:
    • Cute draggable pink UI
    • Target Assist
    • Mouse-following FOV
    • Adjustable FOV
    • FOV color buttons
    • Target part selection
    • Current target display
    • Minimize / close
    • Right Ctrl to hide/show

    Target selection is client-side only. If your game has a weapon,
    have the server validate any target before applying damage/effects.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

--==================================================
-- SETTINGS
--==================================================

local menuVisible = true
local minimized = false

local targetAssist = false
local showFOV = true

local fovRadius = 150
local targetPartName = "HumanoidRootPart"
local currentTarget = nil

local fovColor = Color3.fromRGB(255, 105, 180)

--==================================================
-- COLORS
--==================================================

local PINK_LIGHT = Color3.fromRGB(255, 170, 215)
local PINK_PALE = Color3.fromRGB(255, 220, 240)
local BACKGROUND = Color3.fromRGB(35, 18, 30)
local BUTTON = Color3.fromRGB(60, 28, 50)
local BUTTON_HOVER = Color3.fromRGB(90, 40, 70)
local BUTTON_ACTIVE = Color3.fromRGB(120, 45, 90)
local PINK_STROKE = Color3.fromRGB(255, 105, 180)

--==================================================
-- GUI
--==================================================

local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("EllaMain")
if oldGui then
    oldGui:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "EllaMain"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = playerGui

--==================================================
-- FOV CIRCLE
--==================================================

local fovCircle = Instance.new("Frame")
fovCircle.Name = "MouseFOV"
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.ZIndex = 10
fovCircle.Parent = gui

local fovStroke = Instance.new("UIStroke")
fovStroke.Color = fovColor
fovStroke.Thickness = 2
fovStroke.Transparency = 0.1
fovStroke.Parent = fovCircle

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = fovCircle

--==================================================
-- MAIN FRAME
--==================================================

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(410, 560)
main.Position = UDim2.new(0.5, -205, 0.5, -280)
main.BackgroundColor3 = BACKGROUND
main.BorderSizePixel = 0
main.ZIndex = 20
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = PINK_STROKE
mainStroke.Thickness = 2
mainStroke.Transparency = 0.25
mainStroke.Parent = main

--==================================================
-- TITLE BAR
--==================================================

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 62)
titleBar.BackgroundTransparency = 1
titleBar.ZIndex = 21
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.fromOffset(18, 0)
title.BackgroundTransparency = 1
title.Text = "♡ ella main ♡"
title.TextColor3 = PINK_LIGHT
title.TextSize = 23
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 22
title.Parent = titleBar

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(38, 32)
minimize.Position = UDim2.new(1, -88, 0, 15)
minimize.BackgroundColor3 = BUTTON
minimize.Text = "—"
minimize.TextColor3 = PINK_LIGHT
minimize.TextSize = 18
minimize.Font = Enum.Font.GothamBold
minimize.AutoButtonColor = false
minimize.ZIndex = 22
minimize.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 10)
minCorner.Parent = minimize

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(38, 32)
close.Position = UDim2.new(1, -45, 0, 15)
close.BackgroundColor3 = Color3.fromRGB(120, 45, 80)
close.Text = "×"
close.TextColor3 = PINK_PALE
close.TextSize = 20
close.Font = Enum.Font.GothamBold
close.AutoButtonColor = false
close.ZIndex = 22
close.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = close

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPosition

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = false
    end
end)

--==================================================
-- UI HELPERS
--==================================================

local function makeButton(text, y, onClick)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 0, 42)
    button.Position = UDim2.fromOffset(15, y)
    button.BackgroundColor3 = BUTTON
    button.TextColor3 = PINK_PALE
    button.Text = text
    button.TextSize = 14
    button.Font = Enum.Font.GothamMedium
    button.AutoButtonColor = false
    button.ZIndex = 22
    button.Parent = main

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 11)
    corner.Parent = button

    local stroke = Instance.new("UIStroke")
    stroke.Color = PINK_STROKE
    stroke.Transparency = 0.65
    stroke.Thickness = 1
    stroke.Parent = button

    button.MouseEnter:Connect(function()
        if button.BackgroundColor3 ~= BUTTON_ACTIVE then
            button.BackgroundColor3 = BUTTON_HOVER
        end
    end)

    button.MouseLeave:Connect(function()
        if button.BackgroundColor3 ~= BUTTON_ACTIVE then
            button.BackgroundColor3 = BUTTON
        end
    end)

    if onClick then
        button.MouseButton1Click:Connect(onClick)
    end

    return button
end

local function makeLabel(text, y, size)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, size or 25)
    label.Position = UDim2.fromOffset(15, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = PINK_LIGHT
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 22
    label.Parent = main

    return label
end

--==================================================
-- TARGET ASSIST
--==================================================

local targetButton

targetButton = makeButton("♡ Target Assist: OFF", 72, function()
    targetAssist = not targetAssist

    if targetAssist then
        targetButton.Text = "♡ Target Assist: ON"
        targetButton.BackgroundColor3 = BUTTON_ACTIVE
    else
        targetButton.Text = "♡ Target Assist: OFF"
        targetButton.BackgroundColor3 = BUTTON
        currentTarget = nil
    end
end)

--==================================================
-- FOV
--==================================================

local fovLabel = makeLabel("♡ FOV Radius: " .. fovRadius, 124)

local slider = Instance.new("TextButton")
slider.Size = UDim2.new(1, -30, 0, 10)
slider.Position = UDim2.fromOffset(15, 156)
slider.BackgroundColor3 = Color3.fromRGB(80, 40, 65)
slider.Text = ""
slider.AutoButtonColor = false
slider.ZIndex = 22
slider.Parent = main

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = slider

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new((fovRadius - 25) / 275, 0, 1, 0)
sliderFill.BackgroundColor3 = PINK_STROKE
sliderFill.BorderSizePixel = 0
sliderFill.ZIndex = 23
sliderFill.Parent = slider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

local function updateFovFromX(x)
    local relative = math.clamp(
        (x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X,
        0,
        1
    )

    fovRadius = math.floor(25 + relative * 275)
    fovLabel.Text = "♡ FOV Radius: " .. fovRadius
    sliderFill.Size = UDim2.new(relative, 0, 1, 0)
    fovCircle.Size = UDim2.fromOffset(fovRadius * 2, fovRadius * 2)
end

slider.MouseButton1Click:Connect(function()
    updateFovFromX(mouse.X)
end)

local fovButton

fovButton = makeButton("♡ FOV Circle: ON", 178, function()
    showFOV = not showFOV

    if showFOV then
        fovButton.Text = "♡ FOV Circle: ON"
        fovButton.BackgroundColor3 = BUTTON_ACTIVE
    else
        fovButton.Text = "♡ FOV Circle: OFF"
        fovButton.BackgroundColor3 = BUTTON
    end
end)

--==================================================
-- TARGET PART
--==================================================

local partButton

partButton = makeButton("♡ Target Part: HumanoidRootPart", 230, function()
    if targetPartName == "HumanoidRootPart" then
        targetPartName = "Head"
    else
        targetPartName = "HumanoidRootPart"
    end

    partButton.Text = "♡ Target Part: " .. targetPartName
end)

--==================================================
-- TARGET LABEL
--==================================================

local targetLabel = makeLabel("♡ Current Target: None", 282, 35)
targetLabel.TextWrapped = true

local refreshButton

refreshButton = makeButton("♡ Refresh Target", 328, function()
    currentTarget = nil
    targetLabel.Text = "♡ Current Target: None"
end)

--==================================================
-- FOV COLORS
--==================================================

local colorLabel = makeLabel("♡ FOV Color", 380)

local colorNames = {
    {"Pink", Color3.fromRGB(255, 105, 180)},
    {"Purple", Color3.fromRGB(190, 100, 255)},
    {"White", Color3.fromRGB(255, 255, 255)},
    {"Blue", Color3.fromRGB(100, 180, 255)},
}

for i, data in ipairs(colorNames) do
    local name = data[1]
    local color = data[2]

    local button = makeButton("♡ " .. name, 410 + ((i - 1) * 0), function()
        fovColor = color
        fovStroke.Color = color
    end)

    -- Keep the four color choices compact.
    button.Size = UDim2.fromOffset(88, 34)
    button.Position = UDim2.fromOffset(15 + ((i - 1) * 96), 410)
    button.TextSize = 12
end

--==================================================
-- TARGET SELECTION
--==================================================

local function getTargetPart(character)
    if not character then
        return nil
    end

    local part = character:FindFirstChild(targetPartName)

    if part and part:IsA("BasePart") then
        return part
    end

    return character:FindFirstChild("HumanoidRootPart")
end

local function getClosestTarget(mousePosition)
    local closestPlayer = nil
    local closestDistance = fovRadius

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local character = otherPlayer.Character

            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local part = getTargetPart(character)

                if humanoid and humanoid.Health > 0 and part then
                    local screenPosition, onScreen =
                        workspace.CurrentCamera:WorldToViewportPoint(part.Position)

                    if onScreen then
                        local distance = (
                            Vector2.new(screenPosition.X, screenPosition.Y)
                            - mousePosition
                        ).Magnitude

                        if distance <= closestDistance then
                            closestDistance = distance
                            closestPlayer = otherPlayer
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

--==================================================
-- WINDOW CONTROLS
--==================================================

local function setMenuVisible(value)
    menuVisible = value
    main.Visible = value
end

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        main.Size = UDim2.fromOffset(410, 62)
        minimize.Text = "+"
    else
        main.Size = UDim2.fromOffset(410, 560)
        minimize.Text = "—"
    end
end)

close.MouseButton1Click:Connect(function()
    setMenuVisible(false)
end)

--==================================================
-- RIGHT CTRL SHOW/HIDE
--==================================================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    if input.KeyCode == Enum.KeyCode.RightControl then
        setMenuVisible(not menuVisible)
    end
end)

--==================================================
-- UPDATE LOOP
--==================================================

RunService.RenderStepped:Connect(function()
    local cameraNow = workspace.CurrentCamera

    if not cameraNow then
        return
    end

    local mouseLocation = UserInputService:GetMouseLocation()

    fovCircle.Position = UDim2.fromOffset(
        mouseLocation.X,
        mouseLocation.Y
    )

    fovCircle.Size = UDim2.fromOffset(
        fovRadius * 2,
        fovRadius * 2
    )

    fovCircle.Visible = showFOV

    if targetAssist then
        currentTarget = getClosestTarget(mouseLocation)

        if currentTarget then
            targetLabel.Text = "♡ Current Target: " .. currentTarget.Name
        else
            targetLabel.Text = "♡ Current Target: None"
        end
    else
        currentTarget = nil
        targetLabel.Text = "♡ Current Target: None"
    end
end)

--==================================================
-- READY
--==================================================

print("[Ella Main] Loaded successfully.")
