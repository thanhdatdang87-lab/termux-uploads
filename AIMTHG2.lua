-- TÉO | ESP + HITBOX + AURA LOCK SYSTEM v3.1 - FIXED
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
local originalSize = {}
local ESP_ENABLED = true
local AURA_ENABLED = false
local AUTO_LOCK_ENABLED = false

-- ESP Settings
local SETTINGS = {
    BOX = {
        COLOR = Color3.fromRGB(46, 204, 113),
        THICKNESS = 2,
        FILLED = false
    },
    TRACER = {
        COLOR = Color3.fromRGB(231, 76, 60),
        THICKNESS = 2
    },
    NAME = {
        COLOR = Color3.fromRGB(255, 255, 255),
        SIZE = 14,
        FONT = Drawing.Fonts.UI,
        OUTLINE = true,
        OUTLINE_COLOR = Color3.fromRGB(0, 0, 0)
    },
    HEALTH_BAR = {
        WIDTH = 4,
        HEIGHT = 2,
        BG_COLOR = Color3.fromRGB(50, 50, 50),
        FG_COLOR = Color3.fromRGB(46, 204, 113),
        LOW_COLOR = Color3.fromRGB(231, 76, 60)
    }
}

-- AURA Settings
local AURA_RADIUS = 250
local LOCK_RADIUS = 800
local CAMERA_LERP_SPEED = 0.15
local AURA_COLORS = {
    Color3.fromRGB(255, 0, 0),    -- Red
    Color3.fromRGB(0, 255, 0),    -- Green
    Color3.fromRGB(0, 0, 255),    -- Blue
    Color3.fromRGB(255, 255, 0),  -- Yellow
    Color3.fromRGB(255, 0, 255),  -- Magenta
    Color3.fromRGB(0, 255, 255)   -- Cyan
}
local AURA_CURRENT_COLOR_INDEX = 1
local AURA_CIRCLE = nil
local LOCKED_PLAYER_INDICATOR = nil
local CURRENT_TARGET = nil
local originalCameraType = Camera.CameraType
local TARGET_MODE = "Enemy" -- "Enemy" or "All"

-- ESP Storage
local ESP_TABLE = {}

-- Hitbox Settings
local HITBOX_ENABLED = false
local HITBOX_SIZE = 10
local HITBOX_COLORS = {
    Color3.fromRGB(255, 50, 50),   -- Red
    Color3.fromRGB(50, 255, 50),   -- Green
    Color3.fromRGB(50, 150, 255),  -- Blue
    Color3.fromRGB(255, 255, 50),  -- Yellow
    Color3.fromRGB(255, 50, 255),  -- Magenta
    Color3.fromRGB(50, 255, 255)   -- Cyan
}
local currentHitboxColor = HITBOX_COLORS[1]

-- Tạo GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "teo_master_ui_v3"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

-- Main Frame với gradient
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(300, 380)
main.Position = UDim2.fromScale(0.05, 0.25)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
main.Active = true
main.Draggable = true

-- Corner radius
local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 12)

-- Shadow effect
local shadow = Instance.new("ImageLabel", main)
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://5554236805"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(23, 23, 277, 277)
shadow.ZIndex = -1

-- Animated border
local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(100, 50, 255)

task.spawn(function()
    local colors = {
        Color3.fromRGB(100, 50, 255),  -- Purple
        Color3.fromRGB(50, 150, 255),  -- Blue
        Color3.fromRGB(50, 255, 150),  -- Teal
        Color3.fromRGB(255, 100, 50)   -- Orange
    }
    local currentIndex = 1
    
    while gui.Parent do
        local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        local tween = TweenService:Create(stroke, tweenInfo, {Color = colors[currentIndex]})
        tween:Play()
        
        currentIndex = currentIndex % #colors + 1
        task.wait(0.8)
    end
end)

-- Title with gradient
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "TÉO | MASTER SCRIPT v3.1"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Center

-- Separator line
local separator = Instance.new("Frame", main)
separator.Size = UDim2.new(0.85, 0, 0, 1)
separator.Position = UDim2.new(0.075, 0, 0, 40)
separator.BackgroundColor3 = Color3.fromRGB(100, 50, 255)
separator.BorderSizePixel = 0

-- HITBOX Toggle
local hitboxToggle = Instance.new("TextButton", main)
hitboxToggle.Position = UDim2.fromOffset(20, 55)
hitboxToggle.Size = UDim2.fromOffset(260, 35)
hitboxToggle.Text = "Hitbox: OFF (H)"
hitboxToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
hitboxToggle.TextColor3 = Color3.new(1, 1, 1)
hitboxToggle.Font = Enum.Font.GothamSemibold
hitboxToggle.TextSize = 14

local hitboxCorner = Instance.new("UICorner", hitboxToggle)
hitboxCorner.CornerRadius = UDim.new(0, 8)

local hitboxStroke = Instance.new("UIStroke", hitboxToggle)
hitboxStroke.Color = Color3.fromRGB(60, 60, 80)
hitboxStroke.Thickness = 1

-- Hitbox Size input
local sizeBoxContainer = Instance.new("Frame", main)
sizeBoxContainer.Position = UDim2.fromOffset(20, 100)
sizeBoxContainer.Size = UDim2.fromOffset(260, 35)
sizeBoxContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

local sizeBoxCorner = Instance.new("UICorner", sizeBoxContainer)
sizeBoxCorner.CornerRadius = UDim.new(0, 8)

local sizeBoxStroke = Instance.new("UIStroke", sizeBoxContainer)
sizeBoxStroke.Color = Color3.fromRGB(60, 60, 80)
sizeBoxStroke.Thickness = 1

local sizeIcon = Instance.new("TextLabel", sizeBoxContainer)
sizeIcon.Size = UDim2.new(0, 35, 1, 0)
sizeIcon.Position = UDim2.new(0, 0, 0, 0)
sizeIcon.BackgroundTransparency = 1
sizeIcon.Text = "📏"
sizeIcon.TextColor3 = Color3.fromRGB(150, 150, 200)
sizeIcon.Font = Enum.Font.Gotham
sizeIcon.TextSize = 16

local sizeBox = Instance.new("TextBox", sizeBoxContainer)
sizeBox.Size = UDim2.new(1, -40, 1, 0)
sizeBox.Position = UDim2.new(0, 35, 0, 0)
sizeBox.PlaceholderText = "Hitbox Size (2-40)"
sizeBox.Text = "10"
sizeBox.BackgroundTransparency = 1
sizeBox.TextColor3 = Color3.new(1, 1, 1)
sizeBox.Font = Enum.Font.Gotham
sizeBox.TextSize = 14
sizeBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)

-- ESP Toggle
local espToggle = Instance.new("TextButton", main)
espToggle.Position = UDim2.fromOffset(20, 145)
espToggle.Size = UDim2.new(0.4, 0, 0, 35)
espToggle.Text = "ESP: ON 🟢"
espToggle.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
espToggle.TextColor3 = Color3.new(1, 1, 1)
espToggle.Font = Enum.Font.GothamSemibold
espToggle.TextSize = 14

local espCorner = Instance.new("UICorner", espToggle)
espCorner.CornerRadius = UDim.new(0, 8)

local espStroke = Instance.new("UIStroke", espToggle)
espStroke.Color = Color3.fromRGB(100, 50, 255)
espStroke.Thickness = 1

-- AURA Toggle
local auraToggle = Instance.new("TextButton", main)
auraToggle.Position = UDim2.new(0.5, 10, 0, 145)
auraToggle.Size = UDim2.new(0.4, 0, 0, 35)
auraToggle.Text = "AURA: OFF ⚪"
auraToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
auraToggle.TextColor3 = Color3.new(1, 1, 1)
auraToggle.Font = Enum.Font.GothamSemibold
auraToggle.TextSize = 14

local auraCorner = Instance.new("UICorner", auraToggle)
auraCorner.CornerRadius = UDim.new(0, 8)

local auraStroke = Instance.new("UIStroke", auraToggle)
auraStroke.Color = Color3.fromRGB(60, 60, 80)
auraStroke.Thickness = 1

-- AUTO LOCK Toggle
local lockToggle = Instance.new("TextButton", main)
lockToggle.Position = UDim2.fromOffset(20, 190)
lockToggle.Size = UDim2.fromOffset(260, 35)
lockToggle.Text = "AUTO LOCK: OFF 🔓"
lockToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
lockToggle.TextColor3 = Color3.new(1, 1, 1)
lockToggle.Font = Enum.Font.GothamSemibold
lockToggle.TextSize = 14

local lockCorner = Instance.new("UICorner", lockToggle)
lockCorner.CornerRadius = UDim.new(0, 8)

local lockStroke = Instance.new("UIStroke", lockToggle)
lockStroke.Color = Color3.fromRGB(60, 60, 80)
lockStroke.Thickness = 1

-- Target Mode Toggle (Enemy/All)
local targetModeToggle = Instance.new("TextButton", main)
targetModeToggle.Position = UDim2.fromOffset(20, 235)
targetModeToggle.Size = UDim2.fromOffset(260, 35)
targetModeToggle.Text = "MODE: ENEMY ONLY ⚔️"
targetModeToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
targetModeToggle.TextColor3 = Color3.new(1, 1, 1)
targetModeToggle.Font = Enum.Font.GothamSemibold
targetModeToggle.TextSize = 14

local targetModeCorner = Instance.new("UICorner", targetModeToggle)
targetModeCorner.CornerRadius = UDim.new(0, 8)

local targetModeStroke = Instance.new("UIStroke", targetModeToggle)
targetModeStroke.Color = Color3.fromRGB(60, 60, 80)
targetModeStroke.Thickness = 1

-- Aura Radius Control
local auraRadiusFrame = Instance.new("Frame", main)
auraRadiusFrame.Position = UDim2.fromOffset(20, 280)
auraRadiusFrame.Size = UDim2.fromOffset(125, 35)
auraRadiusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

local auraRadiusCorner = Instance.new("UICorner", auraRadiusFrame)
auraRadiusCorner.CornerRadius = UDim.new(0, 8)

local auraRadiusStroke = Instance.new("UIStroke", auraRadiusFrame)
auraRadiusStroke.Color = Color3.fromRGB(60, 60, 80)
auraRadiusStroke.Thickness = 1

local auraRadiusIcon = Instance.new("TextLabel", auraRadiusFrame)
auraRadiusIcon.Size = UDim2.new(0, 30, 1, 0)
auraRadiusIcon.Position = UDim2.new(0, 5, 0, 0)
auraRadiusIcon.BackgroundTransparency = 1
auraRadiusIcon.Text = "🌀"
auraRadiusIcon.TextColor3 = Color3.fromRGB(150, 150, 200)
auraRadiusIcon.Font = Enum.Font.Gotham
auraRadiusIcon.TextSize = 14

local auraRadiusBox = Instance.new("TextBox", auraRadiusFrame)
auraRadiusBox.Size = UDim2.new(1, -40, 1, 0)
auraRadiusBox.Position = UDim2.new(0, 35, 0, 0)
auraRadiusBox.PlaceholderText = "250"
auraRadiusBox.Text = "250"
auraRadiusBox.BackgroundTransparency = 1
auraRadiusBox.TextColor3 = Color3.new(1, 1, 1)
auraRadiusBox.Font = Enum.Font.Gotham
auraRadiusBox.TextSize = 14
auraRadiusBox.TextXAlignment = Enum.TextXAlignment.Center

-- Lock Radius Control
local lockRadiusFrame = Instance.new("Frame", main)
lockRadiusFrame.Position = UDim2.new(0.5, 10, 0, 280)
lockRadiusFrame.Size = UDim2.fromOffset(125, 35)
lockRadiusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)

local lockRadiusCorner = Instance.new("UICorner", lockRadiusFrame)
lockRadiusCorner.CornerRadius = UDim.new(0, 8)

local lockRadiusStroke = Instance.new("UIStroke", lockRadiusFrame)
lockRadiusStroke.Color = Color3.fromRGB(60, 60, 80)
lockRadiusStroke.Thickness = 1

local lockRadiusIcon = Instance.new("TextLabel", lockRadiusFrame)
lockRadiusIcon.Size = UDim2.new(0, 30, 1, 0)
lockRadiusIcon.Position = UDim2.new(0, 5, 0, 0)
lockRadiusIcon.BackgroundTransparency = 1
lockRadiusIcon.Text = "🎯"
lockRadiusIcon.TextColor3 = Color3.fromRGB(150, 150, 200)
lockRadiusIcon.Font = Enum.Font.Gotham
lockRadiusIcon.TextSize = 14

local lockRadiusBox = Instance.new("TextBox", lockRadiusFrame)
lockRadiusBox.Size = UDim2.new(1, -40, 1, 0)
lockRadiusBox.Position = UDim2.new(0, 35, 0, 0)
lockRadiusBox.PlaceholderText = "800"
lockRadiusBox.Text = "800"
lockRadiusBox.BackgroundTransparency = 1
lockRadiusBox.TextColor3 = Color3.new(1, 1, 1)
lockRadiusBox.Font = Enum.Font.Gotham
lockRadiusBox.TextSize = 14
lockRadiusBox.TextXAlignment = Enum.TextXAlignment.Center

-- Hide UI Button
local hideToggle = Instance.new("TextButton", main)
hideToggle.Position = UDim2.fromOffset(20, 325)
hideToggle.Size = UDim2.fromOffset(260, 35)
hideToggle.Text = "HIDE UI (F9)"
hideToggle.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
hideToggle.TextColor3 = Color3.new(1, 1, 1)
hideToggle.Font = Enum.Font.GothamSemibold
hideToggle.TextSize = 14

local hideCorner = Instance.new("UICorner", hideToggle)
hideCorner.CornerRadius = UDim.new(0, 8)

local hideStroke = Instance.new("UIStroke", hideToggle)
hideStroke.Color = Color3.fromRGB(100, 50, 50)
hideStroke.Thickness = 1

-- ========== BUBBLE BUTTON (Di chuyển được) ==========
local bubbleButton = Instance.new("TextButton", gui)
bubbleButton.Name = "BubbleButton"
bubbleButton.Size = UDim2.new(0, 50, 0, 50)
bubbleButton.Position = UDim2.new(0, 10, 0, 10)
bubbleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bubbleButton.BackgroundTransparency = 0.3
bubbleButton.BorderColor3 = Color3.fromRGB(100, 100, 255)
bubbleButton.BorderSizePixel = 2
bubbleButton.Text = "⚙️"
bubbleButton.TextColor3 = Color3.new(1, 1, 1)
bubbleButton.TextSize = 20
bubbleButton.Font = Enum.Font.GothamBold
bubbleButton.Visible = false
bubbleButton.Active = true
bubbleButton.Draggable = false

-- Make bubble draggable
local bubbleDragging = false
local bubbleDragStart = nil
local bubbleStartPos = nil

bubbleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        bubbleDragging = true
        bubbleDragStart = input.Position
        bubbleStartPos = bubbleButton.Position
    end
end)

bubbleButton.InputChanged:Connect(function(input)
    if bubbleDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - bubbleDragStart
        bubbleButton.Position = UDim2.new(
            bubbleStartPos.X.Scale,
            bubbleStartPos.X.Offset + delta.X,
            bubbleStartPos.Y.Scale,
            bubbleStartPos.Y.Offset + delta.Y
        )
    end
end)

bubbleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        bubbleDragging = false
    end
end)

-- Double click to show menu
local lastClickTime = 0
bubbleButton.MouseButton1Click:Connect(function()
    local currentTime = tick()
    if currentTime - lastClickTime < 0.3 then -- Double click within 300ms
        main.Visible = true
        bubbleButton.Visible = false
    end
    lastClickTime = currentTime
end)

-- ========== HITBOX FUNCTIONS ==========
local function resetHitbox()
    for plr, sz in pairs(originalSize) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            hrp.Size = sz
            hrp.Transparency = 1
            hrp.Material = Enum.Material.Plastic
            hrp.CanCollide = true
        end
    end
    originalSize = {}
end

local function toggleHitbox()
    HITBOX_ENABLED = not HITBOX_ENABLED
    hitboxToggle.Text = HITBOX_ENABLED and "Hitbox: ON (H) 🔴" or "Hitbox: OFF (H) ⚪"
    
    if HITBOX_ENABLED then
        hitboxToggle.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
        hitboxStroke.Color = Color3.fromRGB(100, 50, 255)
    else
        hitboxToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        hitboxStroke.Color = Color3.fromRGB(60, 60, 80)
        resetHitbox()
    end
end

-- Hitbox color cycle
task.spawn(function()
    local colorIndex = 1
    while gui.Parent do
        currentHitboxColor = HITBOX_COLORS[colorIndex]
        colorIndex = colorIndex % #HITBOX_COLORS + 1
        task.wait(3)
    end
end)

-- ========== ESP FUNCTIONS ==========
local function GetHealthColor(healthPercent)
    if healthPercent > 0.5 then
        return SETTINGS.HEALTH_BAR.FG_COLOR
    elseif healthPercent > 0.25 then
        return Color3.fromRGB(255, 165, 0)
    else
        return SETTINGS.HEALTH_BAR.LOW_COLOR
    end
end

local function CreateESP(player)
    if player == LP then return end
    
    local esp = {
        Player = player,
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        HealthBarBG = Drawing.new("Square"),
        HealthBarFG = Drawing.new("Square"),
        HealthText = Drawing.new("Text"),
        HealthNumber = Drawing.new("Text")
    }
    
    esp.Box.Color = SETTINGS.BOX.COLOR
    esp.Box.Thickness = SETTINGS.BOX.THICKNESS
    esp.Box.Filled = SETTINGS.BOX.FILLED
    esp.Box.Visible = false
    
    esp.Tracer.Color = SETTINGS.TRACER.COLOR
    esp.Tracer.Thickness = SETTINGS.TRACER.THICKNESS
    esp.Tracer.Visible = false
    
    esp.Name.Color = SETTINGS.NAME.COLOR
    esp.Name.Size = SETTINGS.NAME.SIZE
    esp.Name.Font = SETTINGS.NAME.FONT
    esp.Name.Center = true
    esp.Name.Outline = SETTINGS.NAME.OUTLINE
    esp.Name.OutlineColor = SETTINGS.NAME.OUTLINE_COLOR
    esp.Name.Visible = false
    
    esp.HealthBarBG.Color = SETTINGS.HEALTH_BAR.BG_COLOR
    esp.HealthBarBG.Filled = true
    esp.HealthBarBG.Thickness = 1
    esp.HealthBarBG.Visible = false
    
    esp.HealthBarFG.Filled = true
    esp.HealthBarFG.Thickness = 1
    esp.HealthBarFG.Visible = false
    
    esp.HealthText.Color = Color3.fromRGB(255, 255, 255)
    esp.HealthText.Size = SETTINGS.HEALTH_BAR.HEIGHT
    esp.HealthText.Font = Drawing.Fonts.UI
    esp.HealthText.Center = true
    esp.HealthText.Outline = true
    esp.HealthText.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.HealthText.Visible = false
    
    esp.HealthNumber.Color = Color3.fromRGB(255, 255, 255)
    esp.HealthNumber.Size = 16
    esp.HealthNumber.Font = Drawing.Fonts.UI
    esp.HealthNumber.Center = true
    esp.HealthNumber.Outline = true
    esp.HealthNumber.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.HealthNumber.Visible = false
    
    ESP_TABLE[player] = esp
    return esp
end

local function UpdateESP()
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for player, esp in pairs(ESP_TABLE) do
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart and humanoid.Health > 0 then
            local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local headPos = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0))
            local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 4, 0))
            
            if onScreen then
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height * 0.6
                local boxPos = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
                
                local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
                local textScale = math.clamp(500 / distance, 0.5, 2)
                
                esp.Box.Size = Vector2.new(width, height)
                esp.Box.Position = boxPos
                esp.Box.Visible = true
                
                esp.Tracer.From = screenCenter
                esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                esp.Tracer.Visible = true
                
                local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                local healthColor = GetHealthColor(humanoid.Health / humanoid.MaxHealth)
                
                local healthBarWidth = SETTINGS.HEALTH_BAR.WIDTH
                local healthBarHeight = height
                local healthBarX = boxPos.X - healthBarWidth - 5
                local healthBarY = boxPos.y
                
                esp.HealthBarBG.Size = Vector2.new(healthBarWidth, healthBarHeight)
                esp.HealthBarBG.Position = Vector2.new(healthBarX, healthBarY)
                esp.HealthBarBG.Visible = true
                
                local currentHealthHeight = healthBarHeight * (humanoid.Health / humanoid.MaxHealth)
                esp.HealthBarFG.Size = Vector2.new(healthBarWidth, currentHealthHeight)
                esp.HealthBarFG.Position = Vector2.new(healthBarX, healthBarY + (healthBarHeight - currentHealthHeight))
                esp.HealthBarFG.Color = healthColor
                esp.HealthBarFG.Visible = true
                
                esp.HealthText.Text = tostring(healthPercent) .. "%"
                esp.HealthText.Size = math.floor(SETTINGS.HEALTH_BAR.HEIGHT * textScale)
                esp.HealthText.Position = Vector2.new(
                    healthBarX + healthBarWidth/2,
                    boxPos.Y - 25
                )
                esp.HealthText.Visible = true
                
                esp.HealthNumber.Text = string.format("%d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                esp.HealthNumber.Size = math.floor(14 * textScale)
                esp.HealthNumber.Position = Vector2.new(
                    rootPos.X,
                    boxPos.Y + height + 10
                )
                esp.HealthNumber.Visible = true
                
                esp.Name.Text = string.format("%s [%dm]", 
                    player.DisplayName or player.Name, 
                    math.floor(distance)
                )
                esp.Name.Size = math.floor(SETTINGS.NAME.SIZE * textScale)
                esp.Name.Position = Vector2.new(rootPos.X, boxPos.Y - 50)
                esp.Name.Visible = true
                
            else
                esp.Box.Visible = false
                esp.Tracer.Visible = false
                esp.Name.Visible = false
                esp.HealthBarBG.Visible = false
                esp.HealthBarFG.Visible = false
                esp.HealthText.Visible = false
                esp.HealthNumber.Visible = false
            end
        else
            esp.Box.Visible = false
            esp.Tracer.Visible = false
            esp.Name.Visible = false
            esp.HealthBarBG.Visible = false
            esp.HealthBarFG.Visible = false
            esp.HealthText.Visible = false
            esp.HealthNumber.Visible = false
        end
    end
end

local function RemoveESP(player)
    local esp = ESP_TABLE[player]
    if esp then
        esp.Box:Remove()
        esp.Tracer:Remove()
        esp.Name:Remove()
        esp.HealthBarBG:Remove()
        esp.HealthBarFG:Remove()
        esp.HealthText:Remove()
        esp.HealthNumber:Remove()
        ESP_TABLE[player] = nil
    end
end

local function toggleESP()
    ESP_ENABLED = not ESP_ENABLED
    espToggle.Text = ESP_ENABLED and "ESP: ON 🟢" or "ESP: OFF 🔴"
    espToggle.BackgroundColor3 = ESP_ENABLED and Color3.fromRGB(40, 30, 60) or Color3.fromRGB(30, 30, 40)
    espStroke.Color = ESP_ENABLED and Color3.fromRGB(100, 50, 255) or Color3.fromRGB(60, 60, 80)
end

-- ========== AURA FUNCTIONS ==========
local function CreateAuraCircle()
    if AURA_CIRCLE then
        AURA_CIRCLE:Remove()
    end
    
    AURA_CIRCLE = Drawing.new("Circle")
    AURA_CIRCLE.Visible = AURA_ENABLED
    AURA_CIRCLE.Radius = AURA_RADIUS
    AURA_CIRCLE.Color = AURA_COLORS[AURA_CURRENT_COLOR_INDEX]
    AURA_CIRCLE.Thickness = 3
    AURA_CIRCLE.Filled = false
    AURA_CIRCLE.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

local function ChangeAuraColor()
    AURA_CURRENT_COLOR_INDEX = (AURA_CURRENT_COLOR_INDEX % #AURA_COLORS) + 1
    if AURA_CIRCLE then
        AURA_CIRCLE.Color = AURA_COLORS[AURA_CURRENT_COLOR_INDEX]
    end
end

local function StartAuraColorCycle()
    while AURA_ENABLED do
        task.wait(3)
        if AURA_ENABLED then
            ChangeAuraColor()
        end
    end
end

local function toggleAura()
    AURA_ENABLED = not AURA_ENABLED
    auraToggle.Text = AURA_ENABLED and "AURA: ON 🌀" or "AURA: OFF ⚪"
    auraToggle.BackgroundColor3 = AURA_ENABLED and Color3.fromRGB(40, 30, 60) or Color3.fromRGB(30, 30, 40)
    auraStroke.Color = AURA_ENABLED and Color3.fromRGB(100, 50, 255) or Color3.fromRGB(60, 60, 80)
    
    if AURA_CIRCLE then
        AURA_CIRCLE.Visible = AURA_ENABLED
    end
    
    if AURA_ENABLED then
        task.spawn(StartAuraColorCycle)
    end
end

-- ========== FIXED: KHÔNG GHIM XUYÊN VẬT THỂ ==========
local function IsTargetVisible(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return false end
    
    local rootPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local cameraPos = Camera.CFrame.Position
    local targetPos = rootPart.Position + Vector3.new(0, 2, 0) -- Ngực
    
    -- Tạo raycast kiểm tra vật cản
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {targetPlayer.Character, LP.Character}
    raycastParams.IgnoreWater = true
    
    local raycastResult = workspace:Raycast(cameraPos, (targetPos - cameraPos).Unit * (targetPos - cameraPos).Magnitude, raycastParams)
    
    -- Nếu không có vật cản hoặc vật cản là transparent
    if not raycastResult then
        return true
    end
    
    -- Kiểm tra nếu vật cản có transparency cao (gần như trong suốt)
    if raycastResult.Instance:IsA("BasePart") then
        return raycastResult.Instance.Transparency > 0.7
    end
    
    return false
end

-- ========== TARGET MODE FUNCTIONS ==========
local function toggleTargetMode()
    if TARGET_MODE == "Enemy" then
        TARGET_MODE = "All"
        targetModeToggle.Text = "MODE: ALL PLAYERS 👥"
        targetModeToggle.BackgroundColor3 = Color3.fromRGB(30, 40, 30)
        targetModeStroke.Color = Color3.fromRGB(50, 150, 50)
    else
        TARGET_MODE = "Enemy"
        targetModeToggle.Text = "MODE: ENEMY ONLY ⚔️"
        targetModeToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        targetModeStroke.Color = Color3.fromRGB(60, 60, 80)
    end
end

local function IsSameTeam(player1, player2)
    if not player1 or not player2 then return false end
    if player1.Neutral and player2.Neutral then return false end
    return player1.Team == player2.Team
end

local function ShouldTargetPlayer(targetPlayer)
    if targetPlayer == LP then return false end
    if not targetPlayer.Character then return false end
    
    local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    if TARGET_MODE == "Enemy" then
        return not IsSameTeam(LP, targetPlayer)
    else -- "All"
        return true
    end
end

-- ========== FIXED AUTO LOCK FUNCTIONS ==========
local function FindBestTargetInLockRadius()
    local bestTarget = nil
    local bestScore = -math.huge
    local cameraPos = Camera.CFrame.Position
    
    for _, player in pairs(Players:GetPlayers()) do
        if ShouldTargetPlayer(player) then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart then
                local distanceToPlayer = (rootPart.Position - cameraPos).Magnitude
                
                if distanceToPlayer <= LOCK_RADIUS then
                    -- FIXED: Kiểm tra target có visible không
                    local isVisible = IsTargetVisible(player)
                    
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local screenPos = Camera:WorldToViewportPoint(rootPart.Position)
                    
                    if screenPos.Z > 0 then
                        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        local distanceToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        
                        -- Thêm điểm thưởng nếu target visible
                        local visibilityBonus = isVisible and 5 or 0
                        
                        local score = (1 / (distanceToCenter + 0.1)) * 3 +
                                     (1 / (distanceToPlayer + 0.1)) * 2 +
                                     ((1 - healthPercent) * 1) +
                                     visibilityBonus
                        
                        if score > bestScore then
                            bestScore = score
                            bestTarget = {
                                Player = player,
                                DistanceToCenter = distanceToCenter,
                                DistanceToPlayer = distanceToPlayer,
                                Health = humanoid.Health,
                                MaxHealth = humanoid.MaxHealth,
                                Score = score,
                                IsVisible = isVisible
                            }
                        end
                    end
                end
            end
        end
    end
    
    return bestTarget
end

local function UpdateAutoLock()
    if AUTO_LOCK_ENABLED and AURA_ENABLED then
        local targetInfo = FindBestTargetInLockRadius()
        
        if targetInfo and targetInfo.Player and targetInfo.Player.Character then
            -- FIXED: Chỉ ghim nếu target visible
            if targetInfo.IsVisible then
                CURRENT_TARGET = targetInfo.Player
                
                if not LOCKED_PLAYER_INDICATOR then
                    LOCKED_PLAYER_INDICATOR = Drawing.new("Circle")
                    LOCKED_PLAYER_INDICATOR.Color = Color3.fromRGB(255, 0, 0)
                    LOCKED_PLAYER_INDICATOR.Radius = 20
                    LOCKED_PLAYER_INDICATOR.Thickness = 4
                    LOCKED_PLAYER_INDICATOR.Filled = false
                    LOCKED_PLAYER_INDICATOR.Visible = true
                end
                
                local rootPart = CURRENT_TARGET.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local screenPos = Camera:WorldToViewportPoint(rootPart.Position)
                    if screenPos.Z > 0 then
                        LOCKED_PLAYER_INDICATOR.Position = Vector2.new(screenPos.X, screenPos.Y)
                        LOCKED_PLAYER_INDICATOR.Visible = true
                        
                        -- Camera rotation to target
                        local cameraPos = Camera.CFrame.Position
                        local targetPos = rootPart.Position + Vector3.new(0, 2, 0)
                        
                        local newCFrame = CFrame.new(cameraPos, targetPos)
                        Camera.CFrame = Camera.CFrame:Lerp(newCFrame, CAMERA_LERP_SPEED)
                        return
                    end
                end
            else
                -- Nếu target không visible, không ghim và ẩn indicator
                CURRENT_TARGET = nil
                if LOCKED_PLAYER_INDICATOR then
                    LOCKED_PLAYER_INDICATOR.Visible = false
                end
            end
        else
            CURRENT_TARGET = nil
            if LOCKED_PLAYER_INDICATOR then
                LOCKED_PLAYER_INDICATOR.Visible = false
            end
        end
    elseif LOCKED_PLAYER_INDICATOR then
        LOCKED_PLAYER_INDICATOR.Visible = false
        CURRENT_TARGET = nil
    end
end

local function toggleAutoLock()
    AUTO_LOCK_ENABLED = not AUTO_LOCK_ENABLED
    lockToggle.Text = AUTO_LOCK_ENABLED and "AUTO LOCK: ON 🔒" or "AUTO LOCK: OFF 🔓"
    lockToggle.BackgroundColor3 = AUTO_LOCK_ENABLED and Color3.fromRGB(40, 30, 60) or Color3.fromRGB(30, 30, 40)
    lockStroke.Color = AUTO_LOCK_ENABLED and Color3.fromRGB(100, 50, 255) or Color3.fromRGB(60, 60, 80)
    
    if AUTO_LOCK_ENABLED then
        originalCameraType = Camera.CameraType
        Camera.CameraType = Enum.CameraType.Scriptable
    else
        Camera.CameraType = originalCameraType
        if LOCKED_PLAYER_INDICATOR then
            LOCKED_PLAYER_INDICATOR.Visible = false
        end
        CURRENT_TARGET = nil
    end
end

-- ========== RADIUS CONTROL FUNCTIONS ==========
auraRadiusBox.FocusLost:Connect(function()
    local num = tonumber(auraRadiusBox.Text)
    if num and num >= 10 and num <= 500 then
        AURA_RADIUS = num
        auraRadiusBox.Text = tostring(AURA_RADIUS)
        if AURA_CIRCLE then
            AURA_CIRCLE.Radius = AURA_RADIUS
        end
    else
        auraRadiusBox.Text = tostring(AURA_RADIUS)
    end
end)

lockRadiusBox.FocusLost:Connect(function()
    local num = tonumber(lockRadiusBox.Text)
    if num and num >= 10 and num <= 2000 then
        LOCK_RADIUS = num
        lockRadiusBox.Text = tostring(LOCK_RADIUS)
    else
        lockRadiusBox.Text = tostring(LOCK_RADIUS)
    end
end)

-- ========== UI TOGGLE FUNCTIONS ==========
local function toggleUI()
    if main.Visible then
        main.Visible = false
        bubbleButton.Visible = true
        hideToggle.Text = "SHOW UI (F9)"
    else
        main.Visible = true
        bubbleButton.Visible = false
        hideToggle.Text = "HIDE UI (F9)"
    end
end

-- Bubble click to show menu
bubbleButton.MouseButton1Click:Connect(function()
    main.Visible = true
    bubbleButton.Visible = false
end)

hideToggle.MouseButton1Click:Connect(toggleUI)

-- ========== EVENT HANDLERS ==========
hitboxToggle.MouseButton1Click:Connect(toggleHitbox)
espToggle.MouseButton1Click:Connect(toggleESP)
auraToggle.MouseButton1Click:Connect(toggleAura)
lockToggle.MouseButton1Click:Connect(toggleAutoLock)
targetModeToggle.MouseButton1Click:Connect(toggleTargetMode)

sizeBox.FocusLost:Connect(function()
    local v = tonumber(sizeBox.Text)
    if v and v >= 2 and v <= 40 then
        HITBOX_SIZE = v
        sizeBox.Text = tostring(HITBOX_SIZE)
    else
        sizeBox.Text = tostring(HITBOX_SIZE)
    end
end)

UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.H then
        toggleHitbox()
    elseif i.KeyCode == Enum.KeyCode.Insert then
        toggleESP()
    elseif i.KeyCode == Enum.KeyCode.F9 then
        toggleUI()
    end
end)

-- ========== INITIALIZATION ==========
-- Initialize ESP
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LP then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LP then
        task.wait(1)
        CreateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
    originalSize[player] = nil
    if player == CURRENT_TARGET then
        CURRENT_TARGET = nil
    end
end)

-- Create Aura Circle
CreateAuraCircle()

-- ========== MAIN LOOPS ==========
-- ESP Update Loop
RunService.RenderStepped:Connect(function()
    if ESP_ENABLED then
        UpdateESP()
    else
        for _, esp in pairs(ESP_TABLE) do
            esp.Box.Visible = false
            esp.Tracer.Visible = false
            esp.Name.Visible = false
            esp.HealthBarBG.Visible = false
            esp.HealthBarFG.Visible = false
            esp.HealthText.Visible = false
            esp.HealthNumber.Visible = false
        end
    end
    
    -- Update Aura Circle Position
    if AURA_CIRCLE then
        AURA_CIRCLE.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    
    -- Update Auto Lock
    UpdateAutoLock()
end)

-- Hitbox Update Loop
RunService.Heartbeat:Connect(function()
    if not HITBOX_ENABLED then return end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if not originalSize[plr] then
                    originalSize[plr] = hrp.Size
                end
                
                hrp.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
                hrp.Transparency = 0.4
                hrp.Color = currentHitboxColor
                hrp.Material = Enum.Material.Neon
                hrp.CanCollide = false
            end
        end
    end
end)

-- Cleanup
gui.Destroying:Connect(function()
    resetHitbox()
    for player in pairs(ESP_TABLE) do
        RemoveESP(player)
    end
    if AURA_CIRCLE then
        AURA_CIRCLE:Remove()
    end
    if LOCKED_PLAYER_INDICATOR then
        LOCKED_PLAYER_INDICATOR:Remove()
    end
end)

-- Initial message
print([[
╔══════════════════════════════════════════╗
║      TÉO MASTER SCRIPT v3.1 FIXED       ║
╠══════════════════════════════════════════╣
║ ✅ FIXED: Không ghim xuyên vật thể      ║
║ ✅ FIXED: Bubble di chuyển được         ║
║ ✅ Hitbox System (đổi màu 3s)           ║
║ ✅ ESP với máu chi tiết                 ║
║ ✅ Text auto scale theo khoảng cách     ║
║ ✅ Aura Circle (đổi màu 3s)             ║
║ ✅ Auto Lock 2 chế độ: Enemy/All        ║
║ ✅ Không target người hết máu           ║
║ ✅ Chỉnh bán kính Aura/Lock             ║
║ ✅ Nút ẩn UI (F9) + Bubble di chuyển    ║
║ ✅ Priority: Gần tâm > Gần > Máu thấp   ║
║ ✅ Controls: H, Insert, F9              ║
╚══════════════════════════════════════════╝]])

print("\n🎮 HƯỚNG DẪN:")
print("   1. HITBOX: Click nút hoặc nhấn H")
print("   2. ESP: Click nút hoặc nhấn INSERT")
print("   3. AURA: Bật để hiện vòng tròn")
print("   4. AUTO LOCK: Bật để tự động ghim")
print("   5. MODE: Chuyển Enemy/All")
print("   6. Chỉnh bán kính Aura/Lock")
print("   7. HIDE UI: Ẩn UI (F9 để bật lại)")
print("   8. Bubble: Di chuyển được, click để mở menu")