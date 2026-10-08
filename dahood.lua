--[[
    ELLA MAIN 🎀
    LocalScript
    Put inside StarterPlayer > StarterPlayerScripts

    Features:
    • Cute pink UI
    • Draggable UI
    • FOV follows mouse
    • Target Assist
    • FOV size
    • FOV colors
    • Target part
    • Current target
    • Minimize button
    • Right Ctrl hide/show

    For your own Roblox game.
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--==================================================
-- SETTINGS
--==================================================

local menuVisible = true
local minimized = false

local targetAssist = false
local showFOV = true

local fovRadius = 150
local fovColor = Color3.fromRGB(255, 105, 180)

local targetPartName = "HumanoidRootPart"
local currentTarget = nil

--==================================================
-- CUTE PINK COLORS
--==================================================

local PINK_DARK = Color3.fromRGB(190, 65, 130)
local PINK = Color3.fromRGB(255, 105, 180)
local PINK_LIGHT = Color3.fromRGB(255, 170, 215)
local PINK_PALE = Color3.fromRGB(255, 220, 240)

local BACKGROUND = Color3.fromRGB(35, 18, 30)
local BUTTON = Color3.fromRGB(60, 28, 50)
local BUTTON_HOVER = Color3.fromRGB(90, 40, 70)

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "EllaMain"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(410, 560)
main.Position = UDim2.new(0.5, -205, 0.5, -280)

main.BackgroundColor3 = BACKGROUND
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = PINK
mainStroke.Thickness = 2
mainStroke.Transparency = 0.25
mainStroke.Parent = main

--==================================================
-- TITLE BAR
--==================================================

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 62)
titleBar.BackgroundTransparency = 1
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

title.Parent = titleBar

--==================================================
-- MINIMIZE
--==================================================

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(38, 32)
minimize.Position = UDim2.new(1, -88, 0, 15)

minimize.BackgroundColor3 = BUTTON
minimize.Text = "—"
minimize.TextColor3 = PINK_LIGHT
minimize.TextSize = 18
minimize.Font = Enum.Font.GothamBold

minimize.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 10)
minCorner.Parent = minimize

--==================================================
-- CLOSE
--==================================================

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(38, 32)
close.Position = UDim2.new(1, -45, 0, 15)

close.BackgroundColor3 = Color3.fromRGB(120, 45, 80)
close.Text = "×"
close.TextColor3 = PINK_PALE
close.TextSize = 20
close.Font = Enum.Font.GothamBold

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
-- BUTTON HELPER
--==================================================

local function makeButton(text, y)

	local button = Instance.new("TextButton")

	button.Size = UDim2.new(1, -30, 0, 42)
	button.Position = UDim2.fromOffset(15, y)

	button.BackgroundColor3 = BUTTON
	button.TextColor3 = PINK_PALE

	button.Text = text
	button.TextSize = 14
	button.Font = Enum.Font.GothamMedium

	button.AutoButtonColor = false
	button.Parent = main

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 11)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = PINK
	stroke.Transparency = 0.65
	stroke.Thickness = 1
	stroke.Parent = button

	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = BUTTON_HOVER
	end)

	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = BUTTON
	end)

	return button
end

--==================================================
-- TARGET ASSIST
--==================================================

local targetButton = makeButton(
	"♡ Target Assist: OFF",
	72
)

targetButton.MouseButton1Click:Connect(function()

	targetAssist = not targetAssist

	if targetAssist then

		targetButton.Text = "♡ Target Assist: ON"
		targetButton.BackgroundColor3 =
			Color3.fromRGB(120, 45, 90)

	else

		targetButton.Text = "♡ Target Assist: OFF"
		targetButton.BackgroundColor3 = BUTTON

		currentTarget = nil

	end
end)

--==================================================
-- FOV LABEL
--==================================================

local fovLabel = Instance.new("TextLabel")

fovLabel.Size = UDim2.new(1, -30, 0, 25)
fovLabel.Position = UDim2.fromOffset(15, 125)

fovLabel.BackgroundTransparency = 1
fovLabel.Text = "♡ FOV Radius: 150"

fovLabel.TextColor3 = PINK_LIGHT
fovLabel.TextSize = 14
fovLabel.Font = Enum.Font.GothamMedium
fovLabel.TextXAlignment = Enum.TextXAlignment.Left

fovLabel.Parent = main

--==================================================
-- FOV SLIDER
--==================================================

local slider = Instance.new("TextButton")

slider.Size = UDim2.new(1, -30, 0, 10)
slider.Position = UDim2.fromOffset(15, 157)

slider.BackgroundColor3 = Color3.fromRGB(80, 40, 65)
slider.Text = ""

slider.Parent = main

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1, 0)
sliderCorner.Parent = slider

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.45, 0, 1, 0)
sliderFill.BackgroundColor3 = PINK
sliderFill.BorderSizePixel = 0
sliderFill.Parent = slider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = sliderFill

slider.MouseButton1Click:Connect(function()

	local mouse = player:GetMouse()

	local relative = math.clamp(
		(mouse.X - slider.AbsolutePosition.X)
			/ slider.AbsoluteSize.X,
		0,
		1
	)

	fovRadius = math.floor(25 + relative * 275)

	fovLabel.Text =
		"♡ FOV Radius: " .. fovRadius

	sliderFill.Size =
		UDim2.new(relative, 0, 1, 0)
end)

--==================================================
-- SHOW FOV
--==================================================

local fovButton = makeButton(
	"♡ FOV Circle: ON",
	185
)

fovButton.MouseButton1Click:Connect(function()

	showFOV = not showFOV

	if showFOV then

		fovButton.Text = "♡ FOV Circle: ON"
		fovButton.BackgroundColor3 =
			Color3.fromRGB(120, 45, 90)

	else

		fovButton.Text = "♡ FOV Circle: OFF"
		fovButton.BackgroundColor3 = BUTTON

	end
end)

--==================================================
-- TARGET PART
--==================================================

local partButton = makeButton(
	"♡ Target Part: HumanoidRootPart",
	237
)

partButton.MouseButton1Click:Connect(function()

	if targetPartName == "HumanoidRootPart" then

		targetPartName = "Head"

		partButton.Text =
			"♡ Target Part: Head"

	else

		targetPartName = "HumanoidRootPart"

		partButton.Text =
			"♡ Target Part: HumanoidRootPart"

	end
end)

--==================================================
-- CURRENT TARGET
--==================================================

local targetLabel = Instance.new("TextLabel")

targetLabel.Size = UDim2.new(1, -30, 0, 30)
targetLabel.Position = UDim2.fromOffset(15, 290)

targetLabel.BackgroundTransparency = 1
targetLabel.Text = "♡ Target: None"

targetLabel.TextColor3 = PINK_LIGHT
targetLabel.TextSize = 14
targetLabel.Font = Enum.Font.GothamMedium
targetLabel.TextXAlignment = Enum.TextXAlignment.Left

targetLabel.Parent = main

--==================================================
-- REFRESH
--==================================================

local refreshButton = makeButton(
	"♡ Refresh Target",
	325
)

refreshButton.MouseButton1Click:Connect(function()

	currentTarget = nil

end)

--==================================================
-- COLOR TITLE
--==================================================

local colorTitle = Instance.new("TextLabel")

colorTitle.Size = UDim2.new(1, -30, 0, 25)
colorTitle.Position = UDim2.fromOffset(15, 380)

colorTitle.BackgroundTransparency = 1
colorTitle.Text = "♡ FOV Color"

colorTitle.TextColor3 = PINK_LIGHT
colorTitle.TextSize = 14
colorTitle.Font = Enum.Font.GothamMedium
colorTitle.TextXAlignment = Enum.TextXAlignment.Left

colorTitle.Parent = main

--==================================================
-- COLORS
--==================================================

local colors = {
	Color3.fromRGB(255, 105, 180),
	Color3.fromRGB(255, 150, 200),
	Color3.fromRGB(255, 80, 150),
	Color3.fromRGB(210, 100, 255),
	Color3.fromRGB(160, 100, 255),
	Color3.fromRGB(255, 190, 220),
	Color3.fromRGB(255, 255, 255),
	Color3.fromRGB(255, 70, 70)
}

for i, color in ipairs(colors) do

	local colorButton = Instance.new("TextButton")

	colorButton.Size = UDim2.fromOffset(30, 30)

	colorButton.Position =
		UDim2.fromOffset(
			15 + ((i - 1) * 37),
			415
		)

	colorButton.BackgroundColor3 = color
	colorButton.Text = ""

	colorButton.Parent = main

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 9)
	corner.Parent = colorButton

	colorButton.MouseButton1Click:Connect(function()

		fovColor = color
		stroke.Color = color

	end)
end

--==================================================
-- FOV CIRCLE
--==================================================

local fovCircle = Instance.new("Frame")

fovCircle.Name = "MouseFOV"

fovCircle.AnchorPoint =
	Vector2.new(0.5, 0.5)

fovCircle.Size =
	UDim2.fromOffset(
		fovRadius * 2,
		fovRadius * 2
	)

fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0

fovCircle.Parent = gui

local stroke = Instance.new("UIStroke")

stroke.Color = fovColor
stroke.Thickness = 2
stroke.Transparency = 0.1

stroke.Parent = fovCircle

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = fovCircle

--==================================================
-- TARGET SEARCH
--==================================================

local function getClosestTarget(mousePosition)

	local closestPlayer = nil
	local closestDistance = fovRadius

	for _, targetPlayer in ipairs(Players:GetPlayers()) do

		if targetPlayer ~= player then

			local character = targetPlayer.Character

			if character then

				local humanoid =
					character:FindFirstChildOfClass(
						"Humanoid"
					)

				local targetPart =
					character:FindFirstChild(
						targetPartName
					)

				if humanoid
					and targetPart
					and humanoid.Health > 0 then

					local screenPosition, onScreen =
						camera:WorldToViewportPoint(
							targetPart.Position
						)

					if onScreen then

						local screenPoint =
							Vector2.new(
								screenPosition.X,
								screenPosition.Y
							)

						local distance =
							(screenPoint - mousePosition).Magnitude

						if distance <= closestDistance then

							closestDistance = distance
							closestPlayer = targetPlayer

						end
					end
				end
			end
		end
	end

	return closestPlayer
end

--==================================================
-- MAIN UPDATE
--==================================================

RunService.RenderStepped:Connect(function()

	-- Get mouse position
	local mousePosition =
		UserInputService:GetMouseLocation()

	-- FOV follows mouse
	fovCircle.Position =
		UDim2.fromOffset(
			mousePosition.X,
			mousePosition.Y
		)

	-- Update FOV size
	fovCircle.Size =
		UDim2.fromOffset(
			fovRadius * 2,
			fovRadius * 2
		)

	-- Show / hide
	fovCircle.Visible = showFOV

	-- Target selection around mouse
	if targetAssist then

		currentTarget =
			getClosestTarget(mousePosition)

	else

		currentTarget = nil

	end

	-- Target display
	if currentTarget then

		targetLabel.Text =
			"♡ Target: " ..
			currentTarget.Name

		targetLabel.TextColor3 =
			Color3.fromRGB(255, 140, 200)

	else

		targetLabel.Text =
			"♡ Target: None"

		targetLabel.TextColor3 =
			PINK_LIGHT

	end
end)

--==================================================
-- MINIMIZE
--==================================================

minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	for _, child in ipairs(main:GetChildren()) do

		if child ~= titleBar
			and child ~= mainCorner
			and child ~= mainStroke then

			child.Visible = not minimized

		end
	end

	if minimized then

		main.Size =
			UDim2.fromOffset(410, 62)

		minimize.Text = "+"

	else

		main.Size =
			UDim2.fromOffset(410, 560)

		minimize.Text = "—"

	end
end)

--==================================================
-- CLOSE
--==================================================

close.MouseButton1Click:Connect(function()

	main.Visible = false
	menuVisible = false

end)

--==================================================
-- RIGHT CTRL
--==================================================

UserInputService.InputBegan:Connect(function(input, processed)

	if processed then
		return
	end

	if input.KeyCode ==
		Enum.KeyCode.RightControl then

		menuVisible = not menuVisible
		main.Visible = menuVisible

	end
end)

--==================================================
-- TARGET GETTER
--==================================================

local function getCurrentTarget()

	if currentTarget
		and currentTarget.Character then

		return currentTarget
	end

	return nil
end

-- Your own game's weapon system can use:
--
-- local target = getCurrentTarget()
--
-- if target then
--     local character = target.Character
--     local part = character:FindFirstChild(targetPartName)
-- end
