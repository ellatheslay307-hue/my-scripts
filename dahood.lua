-- Pink Cute Da Hood Utility Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Toggles & Settings
local silentAimEnabled = false
local aimlockEnabled = false
local speedEnabled = false
local jumpEnabled = false
local fogDisabled = false

local speedValue = 50
local jumpValue = 100
local fovRadius = 120

local aimTarget = nil
local origFogEnd = Lighting.FogEnd
local origFogStart = Lighting.FogStart

-- Create FOV Circle Visualizer
local fovCircle = nil
if Drawing then
    fovCircle = Drawing.new("Circle")
    fovCircle.Color = Color3.fromRGB(255, 105, 180) -- Hot Pink
    fovCircle.Thickness = 2
    fovCircle.NumSides = 60
    fovCircle.Radius = fovRadius
    fovCircle.Filled = false
    fovCircle.Visible = false
end

-- Get Closest Player inside FOV
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = fovRadius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mousePos = UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Update FOV Position
RunService.RenderStepped:Connect(function()
    if fovCircle then
        fovCircle.Position = UserInputService:GetMouseLocation()
        fovCircle.Radius = fovRadius
    end

    -- Aimlock Camera Tracking
    if aimlockEnabled then
        if not aimTarget or not aimTarget.Character or not aimTarget.Character:FindFirstChild("Head") then
            aimTarget = getClosestPlayerInFOV()
        end
        if aimTarget and aimTarget.Character and aimTarget.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimTarget.Character.Head.Position)
        end
    end
end)

-- Silent Aim Hook
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldIndex = gmt.__index

gmt.__index = newcclosure(function(self, index)
    if self == Mouse and (index == "Hit" or index == "Target") then
        if silentAimEnabled then
            local target = getClosestPlayerInFOV()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                return index == "Hit" and target.Character.Head.CFrame or target.Character.Head
            end
        end
    end
    return oldIndex(self, index)
end)

----------------------------------------------------
-- CUTE PINK GUI BUILDER
----------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PinkCuteUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 228, 236) -- Soft Pink
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Hot Pink
Title.Text = "🌸 Da Hood Pink Utility 🌸"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.FredokaOne
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = Title

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -65)
Container.Position = UDim2.new(0, 10, 0, 55)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.Parent = Container

-- Helper function to create pink buttons
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(255, 182, 193) -- Light Pink
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(80, 80, 80)
    btn.TextSize = 14
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = Container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(255, 105, 180) or Color3.fromRGB(255, 182, 193)
        btn.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(80, 80, 80)
        callback(active)
    end)
    return btn
end

-- Toggles
createButton("Toggle Silent Aim (Key: V)", function(state)
    silentAimEnabled = state
    if fovCircle then fovCircle.Visible = state end
end)

createButton("Toggle Cam Aimlock (Key: Q)", function(state)
    aimlockEnabled = state
    if not state then aimTarget = nil end
end)

createButton("Toggle Speed Boost (Key: X)", function(state)
    speedEnabled = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.WalkSpeed = speedEnabled and speedValue or 16
    end
end)

createButton("Toggle Jump Boost (Key: C)", function(state)
    jumpEnabled = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.JumpPower = jumpEnabled and jumpValue or 50
    end
end)

createButton("Disable Map Fog", function(state)
    fogDisabled = state
    if fogDisabled then
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    else
        Lighting.FogEnd = origFogEnd
        Lighting.FogStart = origFogStart
    end
end)

----------------------------------------------------
-- KEYBINDS & SHORTCUTS
----------------------------------------------------

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    -- Hide/Show UI with Right Control
    if input.KeyCode == Enum.KeyCode.RightControl then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end

    -- Keybind: V (Silent Aim)
    if input.KeyCode == Enum.KeyCode.V then
        silentAimEnabled = not silentAimEnabled
        if fovCircle then fovCircle.Visible = silentAimEnabled end
    end

    -- Keybind: Q (Aimlock)
    if input.KeyCode == Enum.KeyCode.Q then
        aimlockEnabled = not aimlockEnabled
        if not aimlockEnabled then aimTarget = nil end
    end

    -- Keybind: X (Speed)
    if input.KeyCode == Enum.KeyCode.X then
        speedEnabled = not speedEnabled
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = speedEnabled and speedValue or 16
        end
    end

    -- Keybind: C (Jump)
    if input.KeyCode == Enum.KeyCode.C then
        jumpEnabled = not jumpEnabled
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.JumpPower = jumpEnabled and jumpValue or 50
        end
    end
end)
