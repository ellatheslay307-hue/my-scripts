-- Da Hood Utility Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Script Loaded!";
    Text = "Da Hood Utility active: Press 'X' for Speed, 'C' for Jump.";
    Duration = 5;
})

-- Configuration
local speedBoost = 32
local jumpBoost = 70
local normalSpeed = 16
local normalJump = 50

local speedToggled = false
local jumpToggled = false

-- Keybind Listener
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not humanoid then return end

    -- Toggle Speed with 'X' key
    if input.KeyCode == Enum.KeyCode.X then
        speedToggled = not speedToggled
        humanoid.WalkSpeed = speedToggled and speedBoost or normalSpeed
    end

    -- Toggle Jump Boost with 'C' key
    if input.KeyCode == Enum.KeyCode.C then
        jumpToggled = not jumpToggled
        humanoid.JumpPower = jumpToggled and jumpBoost or normalJump
    end
end)
