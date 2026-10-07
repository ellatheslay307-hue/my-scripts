-- Da Hood Script with Kavo UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Da Hood Utility", "DarkTheme")

-- Services & Variables
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Config Values
local speedValue = 32
local jumpValue = 70
local normalSpeed = 16
local normalJump = 50

local speedToggled = false
local jumpToggled = false
local aimlockToggled = false
local silentAimToggled = false
local noFogToggled = false

local aimTarget = nil

-- Save Original Fog Values
local origFogEnd = Lighting.FogEnd
local origFogStart = Lighting.FogStart

-- Get Closest Player Function
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Head")
            if part then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
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

-- Aimlock Loop
RunService.RenderStepped:Connect(function()
    if aimlockToggled then
        if not aimTarget or not aimTarget.Character or not aimTarget.Character:FindFirstChild("Head") then
            aimTarget = getClosestPlayer()
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
        if silentAimToggled then
            local target = getClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                return index == "Hit" and target.Character.Head.CFrame or target.Character.Head
            end
        end
    end
    return oldIndex(self, index)
end)

----------------------------------------------------
-- UI TABS AND CONTROLS
----------------------------------------------------

-- Combat Tab
local CombatTab = Window:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Aimbot Tools")

CombatSection:NewToggle("Silent Aim", "Redirects shots to closest player head", function(state)
    silentAimToggled = state
end)

CombatSection:NewToggle("Cam Aimlock", "Locks camera to closest player head", function(state)
    aimlockToggled = state
    if not state then aimTarget = nil end
end)

-- Movement Tab
local MovementTab = Window:NewTab("Movement")
local MovementSection = MovementTab:NewSection("Player Enhancements")

MovementSection:NewToggle("Speed Boost", "Toggles walk speed", function(state)
    speedToggled = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.WalkSpeed = speedToggled and speedValue or normalSpeed
    end
end)

MovementSection:NewSlider("WalkSpeed Value", "Adjust your speed", 200, 16, function(s)
    speedValue = s
    if speedToggled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
    end
end)

MovementSection:NewToggle("Jump Boost", "Toggles high jump", function(state)
    jumpToggled = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.JumpPower = jumpToggled and jumpValue or normalJump
    end
end)

MovementSection:NewSlider("JumpPower Value", "Adjust your jump height", 300, 50, function(s)
    jumpValue = s
    if jumpToggled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = jumpValue
    end
end)

-- Visuals Tab
local VisualsTab = Window:NewTab("Visuals")
local VisualsSection = VisualsTab:NewSection("Environment")

VisualsSection:NewToggle("Disable Fog", "Removes all map fog", function(state)
    noFogToggled = state
    if noFogToggled then
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
    else
        Lighting.FogEnd = origFogEnd
        Lighting.FogStart = origFogStart
    end
end)

-- UI Toggle Key (RightShift)
local SettingsTab = Window:NewTab("Settings")
local SettingsSection = SettingsTab:NewSection("UI Controls")

SettingsSection:NewKeybind("Toggle UI Key", "Press key to hide/show UI", Enum.KeyCode.RightShift, function()
    Library:ToggleUI()
end)
