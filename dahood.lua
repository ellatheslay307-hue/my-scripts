-- Modern Terminal / Console UI Template (ella@main)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Settings & Config
local fovRadius = 120
local showFOV = false
local fovColor = Color3.fromRGB(255, 105, 180) -- Pink default

local speedBoost = 16
local jumpBoost = 50
local normalSpeed = 16
local normalJump = 50

local origFogEnd = Lighting.FogEnd
local origFogStart = Lighting.FogStart
local origFogColor = Lighting.FogColor

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EllaMainUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 700, 0, 500)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 20, 25) -- Dark Pink Tint Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Top Bar (Terminal Style)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 28, 35)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

-- Terminal Window Buttons (Red, Yellow, Green)
local function createDot(color, posX)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.Position = UDim2.new(0, posX, 0.5, -5)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.Parent = TopBar
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
end

createDot(Color3.fromRGB(255, 95, 86), 15)  -- Red
createDot(Color3.fromRGB(255, 189, 46), 32) -- Yellow
createDot(Color3.fromRGB(39, 201, 63), 49)  -- Green

-- Header Title ($ ella@main)
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Position = UDim2.new(0, 70, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "ella@main: ~$ main console"
TitleLabel.TextColor3 = Color3.fromRGB(255, 182, 193) -- Soft Pink
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.Code
TitleLabel.TextSize = 14
TitleLabel.Parent = TopBar

-- Left Sidebar Navigation
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 160, 1, -35)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 16, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 4)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPadding = Instance.new("UIPadding")
SidebarPadding.PaddingTop = UDim.new(0, 15)
SidebarPadding.PaddingLeft = UDim.new(0, 10)
SidebarPadding.PaddingRight = UDim.new(0, 10)
SidebarPadding.Parent = Sidebar

-- Content Display Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -170, 1, -45)
ContentArea.Position = UDim2.new(0, 165, 0, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Tab Frames Table
local tabs = {}

local function createTab(tabName)
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(1, 0, 1, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 3
    tabContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 105, 180)
    tabContainer.Visible = false
    tabContainer.Parent = ContentArea

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = tabContainer

    -- Tab Title inside content area
    local header = Instance.new("TextLabel")
    header.Size = UDim2.new(1, 0
