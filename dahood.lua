/* STREAMING_CHUNK:Loading Rayfield UI Library and services... */
-- Rayfield UI Library Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

/* STREAMING_CHUNK:Initializing state variables... */
-- Default Settings & States
local config = {
silentAim = false,
aimlock = false,
speedEnabled = false,
speedValue = 32,
jumpEnabled = false,
jumpValue = 70,
disableFog = false,
normalSpeed = 16,
normalJump = 50
}

local aimTarget = nil
local savedFogStart = Lighting.FogStart
local savedFogEnd = Lighting.FogEnd

/* STREAMING_CHUNK:Defining helper function to locate closest target... */
-- Helper Function: Get Closest Player to Cursor
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

/* STREAMING_CHUNK:Creating main Rayfield window and UI tabs... */
-- Create Main Window
local Window = Rayfield:CreateWindow({
Name = "Da Hood Utility Hub",
LoadingTitle = "Loading Da Hood Script...",
LoadingSubtitle = "by ellatheslay307-hue",
ConfigurationSaving = {
Enabled = true,
FolderName = "DaHoodHubConfig",
FileName = "Config"
},
KeySystem = false
})

-- UI Tabs
local CombatTab = Window:CreateTab("Combat", 4483362458)
local MovementTab = Window:CreateTab("Movement", 4483362458)
local WorldTab = Window:CreateTab("World & Visuals", 4483362458)

/* STREAMING_CHUNK:Configuring Combat Tab (Silent Aim & Aimlock)... */
-- Combat Section
CombatTab:CreateSection("Targeting")

CombatTab:CreateToggle({
Name = "Silent Aim",
CurrentValue = false,
Flag = "SilentAimToggle",
Callback = function(Value)
config.silentAim = Value
end,
})

CombatTab:CreateToggle({
Name = "Aimlock (Camlock)",
CurrentValue = false,
Flag = "AimlockToggle",
Callback = function(Value)
config.aimlock = Value
if Value then
aimTarget = getClosestPlayer()
else
aimTarget = nil
end
end,
})

CombatTab:CreateKeybind({
Name = "Toggle Aimlock Key",
CurrentKeybind = "Q",
HoldToInteract = false,
Flag = "AimlockKeybind",
Callback = function(Keybind)
config.aimlock = not config.aimlock
if config.aimlock then
aimTarget = getClosestPlayer()
else
aimTarget = nil
end
end,
})

/* STREAMING_CHUNK:Configuring Movement Tab (Speed & Jump Controls)... */
-- Movement Section
MovementTab:CreateSection("Character Enhancements")

MovementTab:CreateToggle({
Name = "Speed Boost",
CurrentValue = false,
Flag = "SpeedToggle",
Callback = function(Value)
config.speedEnabled = Value
local char = LocalPlayer.Character
if char and char:FindFirstChildOfClass("Humanoid") then
char.Humanoid.WalkSpeed = Value and config.speedValue or config.normalSpeed
end
end,
})

MovementTab:CreateSlider({
Name = "WalkSpeed Value",
Range = {16, 150},
Increment = 1,
Suffix = " Speed",
CurrentValue = 32,
Flag = "SpeedSlider",
Callback = function(Value)
config.speedValue = Value
local char = LocalPlayer.Character
if config.speedEnabled and char and char:FindFirstChildOfClass("Humanoid") then
char.Humanoid.WalkSpeed = Value
end
end,
})

MovementTab:CreateToggle({
Name = "Jump Boost",
CurrentValue = false,
Flag = "JumpToggle",
Callback = function(Value)
config.jumpEnabled = Value
local char = LocalPlayer.Character
if char and char:FindFirstChildOfClass("Humanoid") then
char.Humanoid.JumpPower = Value and config.jumpValue or config.normalJump
end
end,
})

MovementTab:CreateSlider({
Name = "Jump Power Value",
Range = {50, 200},
Increment = 5,
Suffix = " Power",
CurrentValue = 70,
Flag = "JumpSlider",
Callback = function(Value)
config.jumpValue = Value
local char = LocalPlayer.Character
if config.jumpEnabled and char and char:FindFirstChildOfClass("Humanoid") then
char.Humanoid.JumpPower = Value
end
end,
})

/* STREAMING_CHUNK:Configuring Visuals Tab (Fog Disabler)... */
-- Visuals Section
WorldTab:CreateSection("Environment")

WorldTab:CreateToggle({
Name = "Disable Fog",
CurrentValue = false,
Flag = "FogToggle",
Callback = function(Value)
config.disableFog = Value
if Value then
Lighting.FogEnd = 9e9
Lighting.FogStart = 9e9
else
Lighting.FogStart = savedFogStart
Lighting.FogEnd = savedFogEnd
end
end,
})

/* STREAMING_CHUNK:Setting up update loops and metamethod hooks... */
-- Aimlock Loop
RunService.RenderStepped:Connect(function()
if config.aimlock and aimTarget and aimTarget.Character and aimTarget.Character:FindFirstChild("Head") then
Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimTarget.Character.Head.Position)
end
end)

-- Character Spawn / Movement Keep-Alive Listener
LocalPlayer.CharacterAdded:Connect(function(char)
local humanoid = char:WaitForChild("Humanoid")
humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
if config.speedEnabled then
humanoid.WalkSpeed = config.speedValue
end
end)
humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
if config.jumpEnabled then
humanoid.JumpPower = config.jumpValue
end
end)
end)

-- Silent Aim Hook (Redirects mouse hits)
local gmt = getrawmetatable(game)
setreadonly(gmt, false)
local oldIndex = gmt.__index

gmt.__index = newcclosure(function(self, index)
if self == Mouse and (index == "Hit" or index == "Target") then
if config.silentAim then
local target = getClosestPlayer()
if target and target.Character and target.Character:FindFirstChild("Head") then
return index == "Hit" and target.Character.Head.CFrame or target.Character.Head
end
end
end
return oldIndex(self, index)
end)

Rayfield:Notify({
Title = "Script Ready",
Content = "Da Hood UI Hub successfully loaded!",
Duration = 5,
Image = 4483362458,
})
