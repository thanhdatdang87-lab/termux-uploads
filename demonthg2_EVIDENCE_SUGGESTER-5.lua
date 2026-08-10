
-- Guard: chỉ chạy 1 lần, tránh duplicate menu khi teleport
if _G.__ESP_LOADED then return end
_G.__ESP_LOADED = true
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players['LocalPlayer']
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Character, Humanoid, HumanoidRootPart
local HttpService = game:GetService("HttpService")
local WebhookURL = "https://discord.com/api/webhooks/1517444955956576347/ZTi4R0leuMGt0pHddhCIxhw041KJCQYoTFgUSTwTOh5G4pWV_CLfuWyK0W5BORSS97xG"
local function SendWebhook()
    local ok, err = pcall(function()
        return request({["Url"]=WebhookURL,["Method"]="POST",["Headers"]={["Content-Type"]="application/json"},["Body"]=HttpService:JSONEncode(data)})
    end)
    if not ok then
        warn("Request failed: " .. tostring(err))
    end
end
local GuiName = "Beh"
local GameState

-- 1. Kiểm tra xem đang ở Map nào trước để lấy tên Map
if (game['PlaceId'] == 18199615050) then
    GameState = "Lobby"
elseif (game['PlaceId'] == 18794863104) then
    GameState = "MainGame"
else
    GameState = "Unknown"
end

-- 2. Đã có tên Map rồi thì mới gửi Webhook đi cho chuẩn
local player = game:GetService("Players").LocalPlayer
local messageData = {
    ["content"] = "🔥 **Có người vừa kích hoạt THG2 Hub!**",
    ["embeds"] = {{
        ["title"] = "🎯 Trạng thái hoạt động",
        ["description"] = "Đang có người thực thi script của bồ!",
        ["color"] = 16711680,
        ["fields"] = {
            {
                ["name"] = "👤 Người dùng:",
                ["value"] = player.Name .. " (" .. tostring(player.UserId) .. ")",
                ["inline"] = true
            },
            {
                ["name"] = "🎮 Tình trạng Map:",
                ["value"] = GameState,
                ["inline"] = true
            }
        }
    }}
}
SendWebhook(messageData)

local Ghost
local Unused15
if (GameState == "MainGame") then
    Ghost = Workspace:FindFirstChild("Ghost")
end
local Unused16
local function SafeIndex(ancestor, ancestor_2)
    local ok_2 = pcall(function()
        local value_4 = ancestor[ancestor_2]
    end)
    return ok_2
end
local LoadState = {["IsLoaded"]=false}
function GetPlayer(arg)
    Character = arg
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid['Died']:Connect(function()
        Character, Humanoid, HumanoidRootPart = nil
    end)
    return Humanoid, HumanoidRootPart
end
if LocalPlayer['Character'] then
    GetPlayer(LocalPlayer.Character)
end
LocalPlayer['CharacterAdded']:Connect(GetPlayer)
if Humanoid then
    Humanoid['WalkSpeed'] = 10
    Humanoid['JumpPower'] = 0
end
local OriginalProps = {}
local Unused20 = {}
local function FadeOutDescendants(instance, instance_2)
    local tweenInfo = TweenInfo.new(instance_2, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut)
    for k, v in pairs(instance:GetDescendants()) do
        local imgLabel = {}
        local imgLabel_2 = {}
        OriginalProps[v] = OriginalProps[v] or {}
        if (v:IsA("Frame") or (v:IsA("ScrollingFrame")) or v:IsA("ViewportFrame")) then
            imgLabel["BackgroundTransparency"] = v['BackgroundTransparency']
            imgLabel_2["BackgroundTransparency"] = 1
        elseif (v:IsA("TextLabel") or v:IsA("TextBox") or v:IsA("TextButton")) then
            imgLabel["BackgroundTransparency"] = v['BackgroundTransparency']
            imgLabel["TextTransparency"] = v['TextTransparency']
            imgLabel_2["BackgroundTransparency"] = 1
            imgLabel_2["TextTransparency"] = 1
        elseif (v:IsA("ImageLabel") or v:IsA("ImageButton")) then
            imgLabel["BackgroundTransparency"] = v['BackgroundTransparency']
            imgLabel["ImageTransparency"] = v['ImageTransparency']
            imgLabel_2["BackgroundTransparency"] = 1
            imgLabel_2["ImageTransparency"] = 1
        elseif v:IsA("Texture") then
            imgLabel["Transparency"] = v['Transparency']
            imgLabel_2["Transparency"] = 1
        elseif (v:IsA("BasePart") or v:IsA("UIStroke")) then
            OriginalProps[v]['Transparency'] = v['Transparency']
        elseif (v:IsA("UIGradient") and (v['Parent']['Name'] == "Divider")) then
            OriginalProps[v] = {["Transparency"]=v['Transparency']}
            task.spawn(function()
                local t0 = os.clock()
                while (os.clock() - t0) < instance_2 do
                    local t0_2 = os.clock() - t0
                    local clamped = math.clamp(t0_2 / instance_2, 0, 1)
                    local value_5 = 0.5 - (0.5 * math.cos(clamped * math['pi']))
                    local value_6 = OriginalProps[v]['Transparency']
                    local tbl_11 = {}
                    for k_2, v_2 in ipairs(value_6.Keypoints) do
                        local value = v_2['Value'] + ((1 - v_2['Value']) * value_5)
                        table.insert(tbl_11, NumberSequenceKeypoint.new(v_2.Time, value))
                    end
                    v['Transparency'] = NumberSequence.new(tbl_11)
                    task.wait()
                end
                v['Color'] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
                v['Transparency'] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0)})
            end)
        end
        if next(imgLabel_2) then
            OriginalProps[v] = imgLabel
            TweenService:Create(v, tweenInfo, imgLabel_2):Play()
        end
    end
end
local function CreateButton(a_2, b_2, c_2, d_2)
    local btn = Instance.new("TextButton")
    btn['LayoutOrder'] = c_2
    if (c_2 == nil) then
        btn['LayoutOrder'] = 0
    end
    btn['Parent'] = b_2
    btn['AutomaticSize'] = "Y"
    btn['Size'] = UDim2.new(0, d_2, 0, 28)
    btn['Text'] = ""
    btn['Name'] = "Button"
    btn['BackgroundTransparency'] = 0
    if not Name then
        btn['Name'] = "Button"
    end
    local corner = Instance.new("UICorner")
    corner['Parent'] = btn
    corner['CornerRadius'] = UDim.new(0, 10)
    local gradient = Instance.new("UIGradient")
    gradient['Parent'] = btn
    gradient['Transparency'] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(1, 0)})
    gradient['Color'] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 80, 91)),ColorSequenceKeypoint.new(1, Color3.fromRGB(91, 33, 37))})
    local label = Instance.new("TextLabel", btn)
    label["TextWrapped"] = true
    label["BorderSizePixel"] = 0
    label["TextScaled"] = false
    label["TextSize"] = 12
    label["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    label["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold, Enum['FontStyle'].Normal)
    label["TextColor3"] = Color3.fromRGB(255, 255, 255)
    label["BackgroundTransparency"] = 0
    label["Size"] = UDim2.new(0, d_2, 0, 28)
    label["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    label["Text"] = a_2
    return btn
end
local function FadeInDescendants(keypoint, keypoint_2)
    local tweenInfo_2 = TweenInfo.new(keypoint_2, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut)
    for k_3, v_3 in pairs(keypoint:GetDescendants()) do
        local value_7 = OriginalProps[v_3]
        if value_7 then
            if v_3:IsA("UIGradient") then
                local value_8 = value_7['Transparency'] or v_3['Transparency']
                task.spawn(function()
                    local t0_3 = os.clock()
                    while (os.clock() - t0_3) < keypoint_2 do
                        local t0_4 = os.clock() - t0_3
                        local clamped_2 = math.clamp(t0_4 / keypoint_2, 0, 1)
                        local value_9 = 0.5 - (0.5 * math.cos(clamped_2 * math['pi']))
                        local obj = {}
                        if value_8 then
                            for k_4, v_4 in ipairs(value_8.Keypoints) do
                                local value_2 = 1 - ((1 - v_4['Value']) * value_9)
                                table.insert(obj, NumberSequenceKeypoint.new(v_4.Time, value_2))
                            end
                        end
                        if (#obj == 1) then
                            table.insert(obj, NumberSequenceKeypoint.new(1, obj[1].Value))
                        elseif (#obj == 0) then
                            obj = {NumberSequenceKeypoint.new(0, 1),NumberSequenceKeypoint.new(1, 1)}
                        end
                        v_3['Transparency'] = NumberSequence.new(obj)
                        task.wait()
                    end
                    v_3['Transparency'] = value_8
                end)
            else
                TweenService:Create(v_3, tweenInfo_2, value_7):Play()
            end
        else
            local imgLabel_3 = {}
            if ((v_3:IsA("Frame") and (not v_3['Name'] == "Text")) or v_3:IsA("ViewportFrame")) then
                imgLabel_3["BackgroundTransparency"] = 0
            elseif v_3:IsA("ScrollingFrame") then
                imgLabel_3["BackgroundTransparency"] = 1
            elseif (v_3:IsA("TextLabel") or v_3:IsA("TextBox") or (v_3:IsA("TextButton") and (not v_3['Name'] == "Button"))) then
                imgLabel_3["BackgroundTransparency"] = 1
                imgLabel_3["TextTransparency"] = 0
            elseif (v_3:IsA("ImageLabel") or v_3:IsA("ImageButton")) then
                imgLabel_3["BackgroundTransparency"] = 1
                imgLabel_3["ImageTransparency"] = 0
            elseif v_3:IsA("Texture") then
                imgLabel_3["Transparency"] = 0
            elseif (v_3:IsA("BasePart") or v_3:IsA("UIStroke")) then
                if (value_7 and (value_7['Transparency'] ~= nil)) then
                    TweenService:Create(v_3, tweenInfo_2, {["Transparency"]=value_7['Transparency']}):Play()
                end
            elseif (v_3:IsA("UIGradient") and (v_3['Parent']['Name'] == "Divider")) then
                local seq = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0)})
                task.spawn(function()
                    local t0_5 = os.clock()
                    while (os.clock() - t0_5) < keypoint_2 do
                        local t0_6 = os.clock() - t0_5
                        local clamped_3 = math.clamp(t0_6 / keypoint_2, 0, 1)
                        local value_10 = 0.5 - (0.5 * math.cos(clamped_3 * math['pi']))
                        local tbl_12 = {}
                        for k_5, v_5 in ipairs(seq.Keypoints) do
                            local value_3 = 1 - ((1 - v_5['Value']) * value_10)
                            table.insert(tbl_12, NumberSequenceKeypoint.new(v_5.Time, value_3))
                        end
                        v_3['Transparency'] = NumberSequence.new(tbl_12)
                        task.wait()
                    end
                    v_3['Transparency'] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0)})
                end)
            end
            if next(imgLabel_3) then
                TweenService:Create(v_3, tweenInfo_2, imgLabel_3):Play()
            end
        end
    end
end
local function HideElement(instance_3, instance_4)
    local tweenInfo_3 = TweenInfo.new(instance_3, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
    local imgLabel_4 = {}
    if (instance_4:IsA("Frame") or (instance_4:IsA("ScrollingFrame") and (instance_4['Name'] ~= "UserConsoleInfo")) or instance_4:IsA("TextBox")) then
        imgLabel_4["BackgroundTransparency"] = 1
    end
    if (instance_4:IsA("TextLabel") or instance_4:IsA("TextBox") or instance_4:IsA("TextButton")) then
        imgLabel_4["BackgroundTransparency"] = 1
        imgLabel_4["TextTransparency"] = 1
    end
    if (instance_4:IsA("ImageLabel") or instance_4:IsA("ImageButton")) then
        imgLabel_4["ImageTransparency"] = 1
    end
    if (instance_4:IsA("UIStroke") or instance_4:IsA("BasePart") or instance_4:IsA("Decal") or instance_4:IsA("Texture")) then
        imgLabel_4["Transparency"] = 1
    end
    if next(imgLabel_4) then
        TweenService:Create(instance_4, tweenInfo_3, imgLabel_4):Play()
    elseif instance_4:IsA("UIGradient") then
        TweenService:Create(instance_4, tweenInfo_3, {["Offset"]=Vector2.new(1, 0)}):Play()
    end
end
local function SetTransparency(instance_5, instance_6, instance_7)
    local tweenInfo_4 = TweenInfo.new(instance_5, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
    if not instance_7 then
        instance_7 = 0
    end
    local imgLabel_5 = {}
    if (instance_6:IsA("Frame") or (instance_6:IsA("ScrollingFrame") and (instance_6['Name'] ~= "UserConsoleInfo")) or instance_6:IsA("TextBox")) then
        imgLabel_5["BackgroundTransparency"] = instance_7
    end
    if (instance_6:IsA("TextBox") or instance_6:IsA("TextButton")) then
        imgLabel_5["BackgroundTransparency"] = instance_7
        imgLabel_5["TextTransparency"] = instance_7
    end
    if instance_6:IsA("TextLabel") then
        imgLabel_5["TextTransparency"] = instance_7
    end
    if (instance_6:IsA("ImageLabel") or instance_6:IsA("ImageButton")) then
        imgLabel_5["ImageTransparency"] = instance_7
    end
    if (instance_6:IsA("UIStroke") or instance_6:IsA("BasePart") or instance_6:IsA("Decal") or instance_6:IsA("Texture")) then
        imgLabel_5["Transparency"] = instance_7
    end
    if next(imgLabel_5) then
        TweenService:Create(instance_6, tweenInfo_4, imgLabel_5):Play()
    elseif instance_6:IsA("UIGradient") then
        TweenService:Create(instance_6, tweenInfo_4, {["Offset"]=Vector2.new(1, 0)}):Play()
    end
end
for k_66, v_66 in pairs(PlayerGui:GetChildren()) do
    if (v_66:IsA("ScreenGui") and (v_66['Name'] == GuiName)) then
        for k_67, v_67 in pairs(v_66:GetDescendants()) do
            HideElement(0.5, v_67)
        end
        task.wait(0.5)
        v_66:Destroy()
        task.wait(1)
    end
end
local UI = {}
UI["1"] = Instance.new("ScreenGui", PlayerGui)
UI["1"]['ResetOnSpawn'] = false
UI["1"]["ZIndexBehavior"] = Enum['ZIndexBehavior']['Sibling']
UI["1"]["Name"] = GuiName
UI["1"]['DisplayOrder'] = 500
local CurrentTab = 1
local StartTime = os.clock()
local function FormatTime(input)
    local floored = math.floor(input / 60)
    local floored_2 = math.floor(input % 60)
    return string.format("%02d:%02d", floored, floored_2)
end
local function CreateMainWindow()
    UI["2"] = Instance.new("Frame", UI["1"])
    UI["2"]["Visible"] = false
    UI["2"]["BackgroundTransparency"] = 1
    UI["2"]["BorderSizePixel"] = 0
    UI["2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["2"]["AnchorPoint"] = Vector2.new(0.5, 0.5)
    UI["2"]["Size"] = UDim2.new(0, 700, 0, 400)
    UI["2"]["Position"] = UDim2.new(0.5, 0, 0.5, 0)
    UI["2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["FrameDragDetector"] = Instance.new("UIDragDetector", UI["2"])
    UI["FrameDragDetector"]["BoundingBehavior"] = "EntireObject"
    UI["TabHolder"] = Instance.new("Frame", UI["2"])
    UI["TabHolder"]["Size"] = UDim2.new(0, 100, 0.9)
    UI["TabHolder"]['Position'] = UDim2.new(0, 0, 0.05, 0)
    UI["TabHolder"]["BackgroundTransparency"] = 1
    UI["TabHolder"]["Name"] = "TabHolder"
    UI["TabHolderLayout"] = Instance.new("UIListLayout", UI["TabHolder"])
    UI["TabHolderLayout"]['Padding'] = UDim.new(0, 10)
    UI["TabHolderLayout"]['HorizontalAlignment'] = "Center"
    if UI["2"] then
        UI["2"]['Visible'] = true
        SetTransparency(0.5, UI["2"], 0)
    else
        warn("Guis2 not found. ")
    end
    UI["3"] = Instance.new("UICorner", UI["2"])
    UI["4"] = Instance.new("UIGradient", UI["2"])
    UI["4"]["Rotation"] = 90
    UI["4"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),ColorSequenceKeypoint.new(0.221, Color3.fromRGB(21, 21, 21)),ColorSequenceKeypoint.new(0.588, Color3.fromRGB(52, 52, 52)),ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 32, 36))})
    UI['b'] = Instance.new("TextLabel", UI["2"])
    UI['b']["BorderSizePixel"] = 0
    UI['b']["TextSize"] = 15
    UI['b']["TextTransparency"] = 0.25
    UI['b']["TextStrokeColor3"] = Color3.fromRGB(101, 0, 0)
    UI['b']["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI['b']["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold, Enum['FontStyle'].Normal)
    UI['b']["TextColor3"] = Color3.fromRGB(255, 255, 255)
    UI['b']["TextTransparency"] = 0.2
    UI['b']["BackgroundTransparency"] = 1
    UI['b']["Size"] = UDim2.new(0, 102, 0, 18)
    UI['b']["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI['b']["Text"] = "DEMONOLOGY - THG2 HUB"
    UI['b']["Name"] = "Tổng Hợp Game 2"
    UI['b']["Position"] = UDim2.new(0.215000004, 0, -0.000850000011, 0)
    UI["Top"] = Instance.new("Frame", UI["2"])
    UI["Top"]["Name"] = "Top"
    UI["Top"]["Size"] = UDim2.new(0, 700, 0, 18)
    UI["Top"]["Position"] = UDim2.new(0, 0, 0, 0)
    UI["Top"]["BackgroundTransparency"] = 1
    UI["Minimize"] = Instance.new("ImageButton", UI["Top"])
    UI["Minimize"]["Size"] = UDim2.new(0, 9, 0, 9)
    UI["Minimize"]["Position"] = UDim2.new(0, 0, 0, 350)
    UI["Minimize"]["BackgroundTransparency"] = 1
    UI["Minimize"]["ImageTransparency"] = 0.2
    UI["Minimize"]["Image"] = "rbxassetid://84561431868297"
    UI["Minimize"]["Position"] = UDim2.new(0, 650, 0, 10)
    UI["Minimize"]['Name'] = "Minimize"
    UI["Close"] = Instance.new("ImageButton", UI["Top"])
    UI["Close"]["Size"] = UDim2.new(0, 9, 0, 9)
    UI["Close"]["Position"] = UDim2.new(0, 0, 0, 350)
    UI["Close"]["BackgroundTransparency"] = 1
    UI["Close"]["ImageTransparency"] = 0.2
    UI["Close"]["Image"] = "rbxassetid://120671325651381"
    UI["Close"]["Position"] = UDim2.new(0, 675, 0, 10)
    UI["Close"]['Name'] = "Close"
    UI["4"] = Instance.new("ScrollingFrame", UI["2"])
    UI["4"]["Active"] = true
    UI["4"]["BorderSizePixel"] = 0
    UI["4"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
    UI["4"]["ScrollBarImageTransparency"] = 0.5
    UI["4"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["4"]["AutomaticCanvasSize"] = Enum['AutomaticSize']['Y']
    UI["4"]["Size"] = UDim2.new(0, 584, 0, 382)
    UI["4"]["Position"] = UDim2.new(0.16571, 0, 0.045, 0)
    UI["4"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["4"]["ScrollBarThickness"] = 2
    UI["4"]["BackgroundTransparency"] = 1
    return UI["FrameDragDetector"]
end
CreateMainWindow()
UI["NotificationHolder"] = Instance.new("Frame", UI["1"])
UI["NotificationHolder"]['Size'] = UDim2.new(0, 400, 0.95, 0)
UI["NotificationHolder"]['Position'] = UDim2.new(0.3, 0, 0, 0)
UI["NotificationHolder"]['BackgroundTransparency'] = 1
UI["NotificationHolder"]['Name'] = "NotificationHolder"
local function CreateToggle(a_3, b_3, c_3, d_3, e_2, f_2, g, h, i_2)
    if not d_3 then
        d_3 = 185
    end
    if not e_2 then
        e_2 = 100
    end
    if not g then
        g = 75
    end
    if not h then
        h = 100
    end
    if not i_2 then
        i_2 = false
    end
    local frame = Instance.new("Frame", b_3)
    frame['Size'] = UDim2.new(0, d_3, 0, 28)
    frame['LayoutOrder'] = c_3
    frame['BackgroundTransparency'] = 1
    local corner_2 = Instance.new("UICorner", frame)
    local stroke = Instance.new("UIStroke", frame)
    stroke['Thickness'] = 1.5
    stroke['Color'] = Color3.fromRGB(255, 255, 255)
    stroke['ApplyStrokeMode'] = "Border"
    local label_2 = Instance.new("TextLabel", frame)
    label_2['BackgroundTransparency'] = 1
    label_2['TextColor3'] = Color3.fromRGB(255, 255, 255)
    label_2['Text'] = a_3
    label_2['FontFace'] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold)
    label_2['TextWrapped'] = true
    label_2['TextScaled'] = true
    label_2['ZIndex'] = 6
    label_2['Size'] = UDim2.new(0, e_2, 0, 28)
    label_2['Position'] = UDim2.new(0, 5, 0, 0)
    local frame_2 = Instance.new("Frame", frame)
    frame_2['Size'] = UDim2.new(0, g, 0, 15)
    frame_2['Position'] = UDim2.new(0, h, 0, 6)
    frame_2['BackgroundTransparency'] = 1
    frame_2['ZIndex'] = 6
    local imgLabel_6 = Instance.new("ImageLabel", frame)
    imgLabel_6['Size'] = UDim2.new(0, d_3, 0, 28)
    imgLabel_6['Image'] = "rbxassetid://73660298439922"
    imgLabel_6['ImageTransparency'] = 0.5
    imgLabel_6['Name'] = "Noice"
    local corner_3 = Instance.new("UICorner", imgLabel_6)
    local value_11 = g
    local btn_2 = Instance.new("TextButton", frame_2)
    btn_2['Size'] = UDim2.new(0, value_11 / 2, 0, 15)
    btn_2['Position'] = UDim2.new(0, 0, 0, 0)
    btn_2['BackgroundColor3'] = Color3.fromRGB(81, 32, 37)
    btn_2['BorderSizePixel'] = 0
    btn_2['Text'] = ""
    OriginalProps[imgLabel_6] = {["BackgroundTransparency"]=1,["ImageTransparency"]=0.5}
    local function innerFn(input_9, input_10, input_11)
        local tweenInfo_5 = TweenInfo.new(input_9, Enum['EasingStyle'].Back, Enum['EasingDirection'].Out)
        local tween = TweenService:Create(input_11, tweenInfo_5, input_10)
        tween:Play()
    end
    btn_2['Activated']:Connect(function()
        if (btn_2['Position']['X']['Offset'] == 0) then
            innerFn(0.25, {["Position"]=UDim2.new(0, value_11 / 2, 0, 0),["BackgroundColor3"]=Color3.fromRGB(46, 117, 89)}, btn_2)
        else
            innerFn(0.25, {["Position"]=UDim2.new(0, 0, 0, 0),["BackgroundColor3"]=Color3.fromRGB(81, 32, 37)}, btn_2)
        end
    end)
    local corner_4 = Instance.new("UICorner", btn_2)
    local corner_5 = Instance.new("UICorner", frame_2)
    local stroke_2 = Instance.new("UIStroke", frame_2)
    stroke_2['Thickness'] = 1.5
    stroke_2['Color'] = Color3.fromRGB(255, 255, 255)
    stroke_2['ApplyStrokeMode'] = "Border"
    return btn_2
end
local function CreateLog(a_4, b_4, c_4, d_4, e_3, f_3, g_2)
    if not g_2 then
        g_2 = false
    end
    Log = Instance.new("Frame")
    Log['LayoutOrder'] = c_4 or 0
    Log['Parent'] = b_4
    Log['AutomaticSize'] = Enum['AutomaticSize']['Y']
    Log['Size'] = UDim2.new(0, d_4, 0, 28)
    Log['Name'] = f_3 or "Frame"
    Log['BackgroundTransparency'] = 1
    local corner_6 = Instance.new("UICorner", Log)
    local stroke_3 = Instance.new("UIStroke", Log)
    stroke_3['Thickness'] = 1.5
    stroke_3['Color'] = Color3.fromRGB(255, 255, 255)
    stroke_3['ApplyStrokeMode'] = "Border"
    stroke_3['Transparency'] = 1
    SetTransparency(0.25, stroke_3, 0)
    Noice2 = Instance.new("ImageLabel", Log)
    Noice2['Size'] = UDim2.new(0, d_4, 0, 28)
    Noice2['Image'] = "rbxassetid://73660298439922"
    Noice2['ImageTransparency'] = 1
    Noice2['Name'] = "Noice"
    Noice2['BackgroundTransparency'] = 1
    local corner_7 = Instance.new("UICorner", Noice2)
    SetTransparency(0.25, Noice2, 0.5)
    OriginalProps[Noice2] = {["BackgroundTransparency"]=1,["ImageTransparency"]=0.5}
    TextLabelLog = Instance.new("TextLabel")
    TextLabelLog['TextWrapped'] = true
    TextLabelLog['TextScaled'] = e_3
    TextLabelLog['TextTransparency'] = 1
    TextLabelLog['TextSize'] = 12
    TextLabelLog['BackgroundTransparency'] = 1
    TextLabelLog['Size'] = UDim2.new(1, 0, 0, 28)
    TextLabelLog['FontFace'] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold)
    TextLabelLog['TextColor3'] = Color3.fromRGB(255, 255, 255)
    TextLabelLog['Text'] = a_4
    TextLabelLog['Parent'] = Log
    SetTransparency(0.25, TextLabelLog, 0)
    return TextLabelLog
end
local function CreateSlider(a_5, b_5, c_5, d_5, e_4, f_4, g_3, h_2)
    f_4 = f_4 or 0
    g_3 = g_3 or 100
    
    local frame_3 = Instance.new("Frame")
    frame_3['LayoutOrder'] = c_5 or 0
    frame_3['Parent'] = b_5
    frame_3['AutomaticSize'] = Enum['AutomaticSize']['Y']
    frame_3['Size'] = UDim2.new(0, d_5, 0, 28)
    
    local corner_8 = Instance.new("UICorner")
    corner_8['Parent'] = frame_3
    corner_8['CornerRadius'] = UDim.new(0, 10)
    
    local gradient_2 = Instance.new("UIGradient")
    gradient_2['Parent'] = frame_3
    gradient_2['Color'] = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 75, 91)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(91, 33, 37))
    })
    
    local label_3 = Instance.new("TextLabel", frame_3)
    label_3['TextWrapped'] = true
    label_3['BorderSizePixel'] = 0
    label_3['TextScaled'] = e_4
    label_3['TextSize'] = 12
    label_3['BackgroundColor3'] = Color3.fromRGB(255, 255, 255)
    label_3['FontFace'] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold, Enum['FontStyle'].Normal)
    label_3['TextColor3'] = Color3.fromRGB(255, 255, 255)
    label_3['BackgroundTransparency'] = 1
    label_3['Size'] = UDim2.new(0, d_5, 0, 28)
    
    local stroke_4 = Instance.new("UIStroke", frame_3)
    stroke_4['Color'] = Color3.fromRGB(255, 255, 255)
    stroke_4['Thickness'] = 2
    
    -- Hàm cập nhật thanh Slider và Logic xử lý thuộc tính game
    local function innerFn_2(currentValue)
        currentValue = math.clamp(currentValue, f_4, g_3)
        local percentage = (currentValue - f_4) / (g_3 - f_4)
        percentage = math.clamp(percentage, 0, 0.999)
        
        -- Cập nhật thanh màu LED chạy theo phần trăm
        gradient_2['Transparency'] = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(percentage, 0),
            NumberSequenceKeypoint.new(math.min(percentage + 0.001, 1), 1),
            NumberSequenceKeypoint.new(1, 1)
        })
        
                -- SỬA LỖI: Hiển thị rõ tên kèm theo con số cụ thể (Làm tròn số cho đẹp)
        label_3['Text'] = string.format("%s: %d", tostring(a_5), math.floor(currentValue))
        
        -- Cập nhật trực tiếp trạng thái nhân vật khi kéo (Mượt hơn)
        local LP = game:GetService("Players").LocalPlayer
        local character = LP.Character or LP.CharacterAdded:Wait()
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            if (h_2 == "WalkSpeed") then
                humanoid.WalkSpeed = currentValue
            elseif (h_2 == "JumpPower") then
                humanoid.JumpPower = currentValue
            end
        end
        
        if (h_2 == "Stamina") then
            LP:SetAttribute("Stamina", currentValue)
        end
    end
    
    -- Khởi tạo giá trị ban đầu
    innerFn_2(f_4)
    
    local flag_14 = false
frame_3['InputBegan']:Connect(function(input_2)
    if ((input_2['UserInputType'] == Enum['UserInputType']['MouseButton1']) or (input_2['UserInputType'] == Enum['UserInputType']['Touch'])) then
        flag_14 = true
    end
end)

game:GetService("UserInputService")['InputChanged']:Connect(function(input_3)
    if (flag_14 and ((input_3['UserInputType'] == Enum['UserInputType']['MouseMovement']) or (input_3['UserInputType'] == Enum['UserInputType']['Touch']))) then
        if UI and UI["FrameDragDetector"] then
            UI["FrameDragDetector"]['Enabled'] = false
        end
        
        local absPos = input_3['Position']['X'] - frame_3['AbsolutePosition']['X']
        local clamped_4 = math.clamp(absPos / frame_3['AbsoluteSize']['X'], 0, 1)
        local value_13 = f_4 + ((g_3 - f_4) * clamped_4)
        innerFn_2(value_13)
    end
end)

game:GetService("UserInputService")['InputEnded']:Connect(function(input_4)
    if ((input_4['UserInputType'] == Enum['UserInputType']['MouseButton1']) or (input_4['UserInputType'] == Enum['UserInputType']['Touch'])) then
        if UI and UI["FrameDragDetector"] then
            UI["FrameDragDetector"]['Enabled'] = true
        end
        flag_14 = false
    end
end)

return frame_3
end
    local function CreateLabel(a_6, b_6, c_6, d_6, e_5, f_5)
    local frame_4 = Instance.new("Frame")
    frame_4['LayoutOrder'] = c_6 or 0
    frame_4['Parent'] = b_6
    frame_4['AutomaticSize'] = Enum['AutomaticSize']['Y']
    frame_4['Size'] = UDim2.new(0, d_6, 0, 28)
    local corner_9 = Instance.new("UICorner")
    corner_9['Parent'] = frame_4
    corner_9['CornerRadius'] = UDim.new(0, 10)
    local gradient_3 = Instance.new("UIGradient")
    gradient_3['Parent'] = frame_4
    gradient_3['Color'] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 75, 91)),ColorSequenceKeypoint.new(1, Color3.fromRGB(91, 33, 37))})
    local label_4 = Instance.new("TextLabel", frame_4)
    label_4['TextWrapped'] = true
    label_4['BorderSizePixel'] = 0
    label_4['TextScaled'] = e_5
    label_4['TextSize'] = 12
    SliderStroke['Color'] = Color3.fromRGB(255, 255, 255)
    SliderStroke['Thickness'] = 2
    return label_4
end
local function CreateSectionTitle(a_7, b_7, c_7, d_7, e_6, f_6, g_4, h_3)
    if not d_7 then
        d_7 = 156
    end
    if not e_6 then
        e_6 = 28
    end
    if (f_6 == nil) then
        f_6 = true
    end
    if (g_4 == nil) then
        g_4 = true
    end
    if (h_3 == nil) then
        h_3 = false
    end
    local label_5 = Instance.new("TextLabel", b_7)
    label_5["TextWrapped"] = g_4
    label_5["BorderSizePixel"] = 0
    label_5["TextScaled"] = h_3
    label_5["TextSize"] = 18
    label_5['LayoutOrder'] = c_7
    label_5["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    label_5["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold, Enum['FontStyle'].Normal)
    label_5["TextColor3"] = Color3.fromRGB(255, 255, 255)
    label_5["BackgroundTransparency"] = 1
    label_5["Size"] = UDim2.new(0, d_7, 0, e_6)
    label_5["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    label_5["Text"] = a_7
    if f_6 then
        Divider = Instance.new("Frame", label_5)
        Divider["BorderSizePixel"] = 0
        Divider["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
        if ((d_7 == 156) and (e_6 == 50)) then
            Divider["Size"] = UDim2.new(1, -10, 0, 1)
            Divider["Position"] = UDim2.new(0.036, 0, 0.756, 0)
        elseif ((d_7 == 200) and (e_6 == 50)) then
            Divider["Size"] = UDim2.new(1, -10, 0, 1)
            Divider["Position"] = UDim2.new(0.0365, 0, 0.75624, 0)
        else
            Divider["Size"] = UDim2.new(0, d_7, 0, 1)
            Divider["Position"] = UDim2.new(0.01, 0, 0, 30)
        end
        Divider["BorderColor3"] = Color3.fromRGB(0, 0, 0)
        Divider['Rotation'] = 180
        Divider["Name"] = "Divider"
        Divider["BackgroundTransparency"] = 0.5
        DividerGradient = Instance.new("UIGradient", Divider)
        DividerGradient["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0, 0.0125),NumberSequenceKeypoint.new(0, 0.637),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0.556),NumberSequenceKeypoint.new(1, 0.725),NumberSequenceKeypoint.new(1, 0.0313),NumberSequenceKeypoint.new(1, 0)})
        DividerGradient["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
    end
    return label_5
end
local function CreateDivider(a_8, b_8, c_8, d_8, e_7)
    if not c_8 then
        c_8 = 156
    end
    if not d_8 then
        d_8 = UDim2.new(0, 0, 0, 0)
    end
    if not e_7 then
        e_7 = 0
    end
    Divider = Instance.new("Frame", a_8)
    Divider["BorderSizePixel"] = 0
    Divider["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    Divider["Size"] = UDim2.new(0, c_8, 0, 1)
    Divider["Position"] = d_8
    Divider["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    Divider['Rotation'] = e_7
    Divider["Name"] = "Divider"
    Divider["BackgroundTransparency"] = 0.5
    Divider['LayoutOrder'] = b_8
    DividerGradient = Instance.new("UIGradient", Divider)
    DividerGradient["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0, 0.0125),NumberSequenceKeypoint.new(0, 0.637),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0.556),NumberSequenceKeypoint.new(1, 0.725),NumberSequenceKeypoint.new(1, 0.0313),NumberSequenceKeypoint.new(1, 0)})
    DividerGradient["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
end
local function ApplyStyle(a_9, b_9, c_9, d_9, e_8, f_7, g_5)
    local corner_10 = Instance.new("UICorner")
    corner_10['Parent'] = a_9
    corner_10['CornerRadius'] = UDim.new(0, 10)
    if not e_8 then
        e_8 = "Vertical"
    end
    if not f_7 then
        f_7 = Color3.fromRGB(175, 165, 180)
    end
    if not g_5 then
        g_5 = 0
    end
    local gradient_4 = Instance.new("UIGradient")
    gradient_4['Parent'] = a_9
    if (b_9 == "Red") then
        gradient_4['Transparency'] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(1, 0)})
        gradient_4['Color'] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),ColorSequenceKeypoint.new(0.221, Color3.new(0.0823529, 0.0823529, 0.0823529)),ColorSequenceKeypoint.new(0.588, Color3.new(0.203922, 0.203922, 0.203922)),ColorSequenceKeypoint.new(1, Color3.new(0.352941, 0.12549, 0.141176))})
    elseif (b_9 == "DarkRed") then
        gradient_4['Transparency'] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.85),NumberSequenceKeypoint.new(1, 0.85)})
        gradient_4['Color'] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 75, 91)),ColorSequenceKeypoint.new(1, Color3.fromRGB(91, 33, 37))})
    elseif (b_9 == "DarkRed2") then
        gradient_4['Rotation'] = 90
        gradient_4['Color'] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),ColorSequenceKeypoint.new(0.221, Color3.fromRGB(21, 21, 21)),ColorSequenceKeypoint.new(0.588, Color3.fromRGB(52, 52, 52)),ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 32, 36))})
    end
    if c_9 then
        local stroke_5 = Instance.new("UIStroke", a_9)
        stroke_5['Color'] = f_7
        stroke_5['Thickness'] = 1.5
        stroke_5['Transparency'] = g_5
    end
    if d_9 then
        local layout = Instance.new("UIListLayout", a_9)
        layout['Padding'] = UDim.new(0, 5)
        layout['HorizontalAlignment'] = "Center"
        layout['VerticalAlignment'] = "Top"
        layout['SortOrder'] = "LayoutOrder"
    end
end
local function CreateEsp(ancestor_3, ancestor_4, ancestor_5)
    for k_6, v_6 in pairs(ancestor_4:GetChildren()) do
        if ((v_6['Name'] == "Esp") or (v_6['Name'] == "BillboardGui")) then
            if v_6:FindFirstChild("ImageLabel") then
                task.spawn(function()
                    HideElement(0.25, v_6.ImageLabel)
                    for k_7, v_7 in pairs(v_6['ImageLabel']:GetDescendants()) do
                        HideElement(0.25, v_7)
                    end
                    task.wait(0.25)
                    v_6:Destroy()
                end)
            end
        end
    end
    if not ancestor_3 then
        ancestor_3 = "Label"
    end
    task.wait(0.25)
    local billboard = Instance.new("BillboardGui")
    billboard['Parent'] = ancestor_4
    billboard['AlwaysOnTop'] = true
    billboard['Name'] = "Esp"
    billboard['Size'] = UDim2.new(4, 0, 1, 0)
    billboard['SizeOffset'] = Vector2.new(0, 2.5)
    local frame_5 = Instance.new("Frame", billboard)
    frame_5['BackgroundTransparency'] = 1
    frame_5['Size'] = UDim2.new(1, 0, 1, 0)
    SetTransparency(0.25, frame_5)
    ApplyStyle(frame_5, "DarkRed2")
    local layout_2 = Instance.new("UIListLayout", frame_5)
    layout_2['Padding'] = UDim.new(0, 10)
    layout_2['HorizontalAlignment'] = "Center"
    layout_2['VerticalAlignment'] = "Bottom"
    layout_2['SortOrder'] = "LayoutOrder"
    local label_6 = Instance.new("TextLabel", frame_5)
    label_6['BackgroundTransparency'] = 1
    label_6['Size'] = UDim2.new(0.7, 0, 1, 0)
    label_6['Text'] = ancestor_3
    label_6['TextScaled'] = true
    label_6['TextColor3'] = Color3.fromRGB(255, 255, 255)
    label_6['Position'] = UDim2.new(0.165, 0, 0, 0)
    return frame_5, label_6
end
local function CreateTextBox(a_10, b_10, c_10, d_10)
    if not order then
        order = 0
    end
    if not c_10 then
        c_10 = 185
    end
    if not d_10 then
        d_10 = 28
    end
    local textBox = Instance.new("TextBox", a_10)
    textBox['Size'] = UDim2.new(0, c_10, 0, d_10)
    textBox['LayoutOrder'] = b_10
    textBox['FontFace'] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold, Enum['FontStyle'].Normal)
    textBox['TextColor3'] = Color3.fromRGB(255, 255, 255)
    textBox['TextScaled'] = true
    textBox['PlaceholderText'] = "This textbar is used for applying custom sounds for hunts."
    textBox['Text'] = ""
    ApplyStyle(textBox, "DarkRed")
    local frame_6 = Instance.new("Frame", textBox)
    frame_6['Size'] = UDim2.new(0, c_10, 0, d_10)
    ApplyStyle(frame_6, "DarkRed", true, 0, _, Color3.fromRGB(255, 255, 255), 0.25)
    if textBox:FindFirstChild("UIGradient") then
        textBox['UIGradient']:Destroy()
    end
    local imgLabel_7 = Instance.new("ImageLabel", textBox)
    imgLabel_7['Size'] = UDim2.new(0, c_10, 0, d_10)
    imgLabel_7['Image'] = "rbxassetid://73660298439922"
    imgLabel_7['ImageTransparency'] = 0.5
    imgLabel_7['Name'] = "Noice"
    OriginalProps[imgLabel_7] = {["BackgroundTransparency"]=1,["ImageTransparency"]=0.5}
    local corner_11 = Instance.new("UICorner", imgLabel_7)
    return textBox
end
local function CreateKeybind(input_13, input_14)
    if not input_14 then
        input_14 = 1
    end
    for k_8, v_8 in pairs(UI["NotificationHolder"]:GetChildren()) do
        if (v_8:IsA("Frame") and v_8:FindFirstChild("TextLabel") and (v_8['TextLabel']['Text'] == input_13)) then
            v_8['Destroying']:Wait()
        end
    end
    while UI["NotificationHolder"]:FindFirstChildWhichIsA("Frame") do
        task.wait(0.1)
    end
    local frame_7 = Instance.new("Frame", UI["NotificationHolder"])
    frame_7['Size'] = UDim2.new(0, 320, 0, 80)
    frame_7['BackgroundTransparency'] = 0
    frame_7['Position'] = UDim2.new(0, -370, 0.05, 0)
    for k_9, v_9 in pairs(UI["NotificationHolder"]:GetChildren()) do
        if ((v_9 ~= frame_7) and v_9:IsA("Frame")) then
            frame_7['Position'] = frame_7['Position'] - UDim2.new(0, 0, 0, 110)
        end
    end
    ApplyStyle(frame_7, "Red", false, true)
    CreateSectionTitle("NOTIFICATION", frame_7, 0)
    CreateSectionTitle(input_13, frame_7, 1, 156, nil, false, false, false, true)
    local tweenInfo_6 = TweenInfo.new(0.35, Enum['EasingStyle'].Back, Enum['EasingDirection'].Out)
    local pos = TweenService:Create(frame_7, tweenInfo_6, {["Position"]=UDim2.new(0, 15, 0.05, frame_7['Position']['Y'].Offset)})
    pos:Play()
    pos['Completed']:Wait()
    local tweenInfo_7 = TweenInfo.new(0.15, Enum['EasingStyle'].Back, Enum['EasingDirection'].Out)
    local pos_2 = TweenService:Create(frame_7, tweenInfo_7, {["Position"]=UDim2.new(0, 8, 0.05, frame_7['Position']['Y'].Offset)})
    pos_2:Play()
    pos_2['Completed']:Wait()
    task.wait(input_14)
    local tweenInfo_8 = TweenInfo.new(0.35, Enum['EasingStyle'].Back, Enum['EasingDirection'].In)
    local pos_3 = TweenService:Create(frame_7, tweenInfo_8, {["Position"]=UDim2.new(0, -370, 0.05, frame_7['Position']['Y'].Offset)})
    pos_3:Play()
    pos_3['Completed']:Wait()
    frame_7:Destroy()
    for k_10, v_10 in pairs(UI["NotificationHolder"]:GetChildren()) do
        if (v_10:IsA("Frame") and (v_10['Position']['Y']['Offset'] < frame_7['Position']['Y']['Offset'])) then
            TweenService:Create(v_10, TweenInfo.new(0.25), {["Position"]=UDim2.new(v_10['Position']['X'].Scale, v_10['Position']['X'].Offset, 0.9, v_10['Position']['Y']['Offset'] + 110)}):Play()
        end
    end
end
if (GameState == "Unknown") then
    CreateKeybind("This game is not supported.", 2)
end
local function CreateTab()
    UI["5"] = Instance.new("Frame", UI["4"])
    UI["5"]["BorderSizePixel"] = 0
    UI["5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["5"]["Size"] = UDim2.new(0, 584, 0, 382)
    UI["5"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["5"]["Name"] = "Tab1"
    UI["5"]["BackgroundTransparency"] = 1
    UI["6"] = Instance.new("ScrollingFrame", UI["5"])
    UI["6"]["Active"] = true
    UI["6"]["BorderSizePixel"] = 0
    UI["6"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
    UI["6"]["Name"] = "UserConsoleInfo"
    UI["6"]["ScrollBarImageTransparency"] = 0.5
    UI["6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["6"]["AutomaticCanvasSize"] = Enum['AutomaticSize']['Y']
    UI["6"]["Size"] = UDim2.new(0, 319, 0, 367)
    UI["6"]["Position"] = UDim2.new(0.4024, 0, 0, 0)
    UI["6"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["6"]["ScrollBarThickness"] = 2
    UI["7"] = Instance.new("UIGradient", UI["6"])
    UI["7"]["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.85),NumberSequenceKeypoint.new(1, 0.85)})
    UI["7"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 75, 91)),ColorSequenceKeypoint.new(1, Color3.fromRGB(91, 33, 37))})
    UI["8"] = Instance.new("UICorner", UI["6"])
    UI["9"] = Instance.new("UIListLayout", UI["6"])
    UI["9"]["Padding"] = UDim.new(0, 10)
    UI["9"]["SortOrder"] = Enum['SortOrder']['LayoutOrder']
    UI["9"]["FillDirection"] = Enum['FillDirection']['Horizontal']
    UI['a'] = Instance.new("Frame", UI["6"])
    UI['a']["BorderSizePixel"] = 0
    UI['a']["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI['a']["Size"] = UDim2.new(0, 152, 0, 367)
    UI['a']["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI['a']["BackgroundTransparency"] = 1
    UI["b2"] = CreateSectionTitle("USER INFO:", UI['a'], -236627862, 156, 50)
    UI['c'] = Instance.new("Frame", UI["b2"])
    UI['c']["BorderSizePixel"] = 0
    UI['c']["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI['c']["Size"] = UDim2.new(1, -10, 0, 1)
    UI['c']["Position"] = UDim2.new(0.0365, 0, 0.75624, 0)
    UI['c']["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI['c']["Name"] = "Divider"
    UI['c']["BackgroundTransparency"] = 0.5
    UI['d'] = Instance.new("UIGradient", UI['c'])
    UI['d']["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0, 0.0125),NumberSequenceKeypoint.new(0, 0.637),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0.556),NumberSequenceKeypoint.new(1, 0.725),NumberSequenceKeypoint.new(1, 0.0313),NumberSequenceKeypoint.new(1, 0)})
    UI['d']["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
    UI['e'] = Instance.new("ScrollingFrame", UI['a'])
    UI['e']["Active"] = true
    UI['e']["BorderSizePixel"] = 0
    UI['e']["CanvasSize"] = UDim2.new(0, 0, 0, 0)
    UI['e']["ScrollBarImageTransparency"] = 0.5
    UI['e']["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI['e']["AutomaticCanvasSize"] = Enum['AutomaticSize']['Y']
    UI['e']["Size"] = UDim2.new(0, 152, 0, 317)
    UI['e']["Position"] = UDim2.new(0.03289, 0, 0.13624, 0)
    UI['e']["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI['e']["ScrollBarThickness"] = 2
    UI['e']["BackgroundTransparency"] = 1
    UI['f'] = Instance.new("UIListLayout", UI['e'])
    UI['f']["SortOrder"] = "LayoutOrder"
    UI['f']["Padding"] = UDim.new(0, 10)
    UI["10"] = Instance.new("Frame", UI["6"])
    UI["10"]["BorderSizePixel"] = 0
    UI["10"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["10"]["Size"] = UDim2.new(0, 152, 0, 367)
    UI["10"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["10"]["BackgroundTransparency"] = 1
    UI["11"] = CreateSectionTitle("CONSOLE:", UI["10"], -236627862, 156, 50)
    UI["12"] = Instance.new("Frame", UI["11"])
    UI["12"]["BorderSizePixel"] = 0
    UI["12"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["12"]["Size"] = UDim2.new(1, -10, 0, 1)
    UI["12"]["Position"] = UDim2.new(0.0365, 0, 0.75624, 0)
    UI["12"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["12"]["Name"] = "Divider"
    UI["12"]["BackgroundTransparency"] = 0.5
    UI["13"] = Instance.new("UIGradient", UI["12"])
    UI["13"]["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0, 0.0125),NumberSequenceKeypoint.new(0, 0.637),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0.556),NumberSequenceKeypoint.new(1, 0.725),NumberSequenceKeypoint.new(1, 0.0313),NumberSequenceKeypoint.new(1, 0)})
    UI["13"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
    UI["14"] = Instance.new("ScrollingFrame", UI["10"])
    UI["14"]["Active"] = true
    UI["14"]["BorderSizePixel"] = 0
    UI["14"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
    UI["14"]["ScrollBarImageTransparency"] = 0.5
    UI["14"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["14"]["AutomaticCanvasSize"] = Enum['AutomaticSize']['Y']
    UI["14"]["Size"] = UDim2.new(0, 152, 0, 317)
    UI["14"]["Position"] = UDim2.new(0.03289, 0, 0.13624, 0)
    UI["14"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["14"]["ScrollBarThickness"] = 2
    UI["14"]["BackgroundTransparency"] = 1
    UI["15"] = Instance.new("UIListLayout", UI["14"])
    UI["15"]["SortOrder"] = "LayoutOrder"
    UI["15"]["Padding"] = UDim.new(0, 10)
    UI["16"] = Instance.new("Frame", UI["5"])
    UI["16"]["BorderSizePixel"] = 0
    UI["16"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["16"]["Size"] = UDim2.new(0.62, -10, 0, 1)
    UI["16"]["Position"] = UDim2.new(0.37274, 0, 0.47893, 0)
    UI["16"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["16"]["Name"] = "Divider"
    UI["16"]['Rotation'] = 90
    UI["16"]["BackgroundTransparency"] = 0.5
    UI["17"] = Instance.new("UIGradient", UI["16"])
    UI["17"]["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0, 0.0125),NumberSequenceKeypoint.new(0, 0.637),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0.556),NumberSequenceKeypoint.new(1, 0.725),NumberSequenceKeypoint.new(1, 0.0313),NumberSequenceKeypoint.new(1, 0)})
    UI["17"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
    UI["18"] = Instance.new("Frame", UI["5"])
    UI["18"]["BorderSizePixel"] = 0
    UI["18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["18"]["Size"] = UDim2.new(0, 200, 0, 367)
    UI["18"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["18"]["Name"] = "UpdateLog"
    UI["19"] = Instance.new("UICorner", UI["18"])
    UI["1a"] = Instance.new("UIGradient", UI["18"])
    UI["1a"]["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.85),NumberSequenceKeypoint.new(1, 0.85)})
    UI["1a"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 75, 91)),ColorSequenceKeypoint.new(1, Color3.fromRGB(91, 33, 37))})
    UI["1c"] = CreateSectionTitle("UPDATE LOG:", UI["18"], -236627862, 200, 50)
    UI["1f"] = Instance.new("ScrollingFrame", UI["18"])
    UI["1f"]["Active"] = true
    UI["1f"]["BorderSizePixel"] = 0
    UI["1f"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
    UI["1f"]["ScrollBarImageTransparency"] = 0.5
    UI["1f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["1f"]["AutomaticCanvasSize"] = Enum['AutomaticSize']['Y']
    UI["1f"]["Size"] = UDim2.new(0, 189, 0, 317)
    UI["1f"]["Position"] = UDim2.new(0.036, 0, 0.136, 0)
    UI["1f"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["1f"]["ScrollBarThickness"] = 2
    UI["1f"]["BackgroundTransparency"] = 1
    UI["20"] = Instance.new("UIListLayout", UI["1f"])
    UI["20"]["SortOrder"] = "LayoutOrder"
    UI["20"]["Padding"] = UDim.new(0, 10)
    UI["e2"] = Instance.new("Frame", UI["2"])
    UI["e2"]["BorderSizePixel"] = 0
    UI["e2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["e2"]["Size"] = UDim2.new(0.525, -10, 0, 1)
    UI["e2"]["Position"] = UDim2.new(-0.1, 0, 0.50124, 0)
    UI["e2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["e2"]["Name"] = "Divider"
    UI["e2"]['Rotation'] = 90
    UI["e2"]["BackgroundTransparency"] = 0.5
    UI['f'] = Instance.new("UIGradient", UI["e2"])
    UI['f']["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0, 0.0125),NumberSequenceKeypoint.new(0, 0.637),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0.556),NumberSequenceKeypoint.new(1, 0.725),NumberSequenceKeypoint.new(1, 0.0313),NumberSequenceKeypoint.new(1, 0)})
    UI['f']["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
end
if (GameState == "MainGame") then
    CreateTab()
    UI["PlayerTab"] = Instance.new("Frame", UI["4"])
    UI["PlayerTab"]["BorderSizePixel"] = 0
    UI["PlayerTab"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["PlayerTab"]["Size"] = UDim2.new(0, 584, 0, 382)
    UI["PlayerTab"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["PlayerTab"]["Name"] = "PlayerTab"
    UI["PlayerTab"]["BackgroundTransparency"] = 1
    UI["GhostTab"] = Instance.new("Frame", UI["4"])
    UI["GhostTab"]["BorderSizePixel"] = 0
    UI["GhostTab"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["GhostTab"]["Size"] = UDim2.new(0, 584, 0, 382)
    UI["GhostTab"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["GhostTab"]["Name"] = "GhostTab"
    UI["GhostTab"]["BackgroundTransparency"] = 1
    UI["Button1"] = Instance.new("TextButton", UI["TabHolder"])
    UI["Button1"]["TextWrapped"] = true
    UI["Button1"]["TextStrokeTransparency"] = 0.8
    UI["Button1"]["RichText"] = true
    UI["Button1"]["BorderSizePixel"] = 0
    UI["Button1"]["TextStrokeColor3"] = Color3.fromRGB(101, 0, 0)
    UI["Button1"]["TextSize"] = 18
    UI["Button1"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Button1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Button1"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold, Enum['FontStyle'].Normal)
    UI["Button1"]["ZIndex"] = 100
    UI["Button1"]["BackgroundTransparency"] = 1
    UI["Button1"]["Size"] = UDim2.new(0, 65, 0, 35)
    UI["Button1"]["LayoutOrder"] = 5
    UI["Button1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["Button1"]["Text"] = "MAIN"
    UI["Button1"]["Position"] = UDim2.new(0.17, 0, 0.045, 0)
    UI["Button1"]["Name"] = "Button1"
    UI["Button1Cover"] = Instance.new("Frame", UI["Button1"])
    UI["Button1Cover"]["BackgroundTransparency"] = 1
    UI["Button1Cover"]["BorderSizePixel"] = 0
    UI["Button1Cover"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Button1Cover"]["Size"] = UDim2.new(0, 65, 0, 35)
    UI["Button1Cover"]["Position"] = UDim2.new(-0.00667, 0, -0.00286, 0)
    UI["Button1Cover"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["Button1Cover"]["Name"] = "Button1Cover"
    UI["Button2"] = Instance.new("TextButton", UI["TabHolder"])
    UI["Button2"]["TextWrapped"] = true
    UI["Button2"]["TextStrokeTransparency"] = 0.8
    UI["Button2"]["RichText"] = true
    UI["Button2"]["BorderSizePixel"] = 0
    UI["Button2"]["TextStrokeColor3"] = Color3.fromRGB(101, 0, 0)
    UI["Button2"]["TextSize"] = 18
    UI["Button2"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Button2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Button2"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold, Enum['FontStyle'].Normal)
    UI["Button2"]["ZIndex"] = 100
    UI["Button2"]["BackgroundTransparency"] = 1
    UI["Button2"]["Size"] = UDim2.new(0, 65, 0, 35)
    UI["Button2"]["LayoutOrder"] = 5
    UI["Button2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["Button2"]["Text"] = "PLAYER"
    UI["Button2"]["Position"] = UDim2.new(0.17, 0, 0.15, 0)
    UI["Button2"]["Name"] = "Button2"
    UI["Button2Cover"] = Instance.new("Frame", UI["Button2"])
    UI["Button2Cover"]["BackgroundTransparency"] = 1
    UI["Button2Cover"]["BorderSizePixel"] = 0
    UI["Button2Cover"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Button2Cover"]["Size"] = UDim2.new(0, 65, 0, 35)
    UI["Button2Cover"]["Position"] = UDim2.new(-0.00667, 0, -0.00286, 0)
    UI["Button2Cover"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["Button2Cover"]["Name"] = "Button2Cover"
    UI["Button3"] = Instance.new("TextButton", UI["TabHolder"])
    UI["Button3"]["TextWrapped"] = true
    UI["Button3"]["TextStrokeTransparency"] = 0.8
    UI["Button3"]["RichText"] = true
    UI["Button3"]["BorderSizePixel"] = 0
    UI["Button3"]["TextStrokeColor3"] = Color3.fromRGB(101, 0, 0)
    UI["Button3"]["TextSize"] = 18
    UI["Button3"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Button3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Button3"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold, Enum['FontStyle'].Normal)
    UI["Button3"]["ZIndex"] = 100
    UI["Button3"]["BackgroundTransparency"] = 1
    UI["Button3"]["Size"] = UDim2.new(0, 65, 0, 35)
    UI["Button3"]["LayoutOrder"] = 5
    UI["Button3"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["Button3"]["Text"] = "GHOST"
    UI["Button3"]["Position"] = UDim2.new(0.17, 0, 0.15, 0)
    UI["Button3"]["Name"] = "Button3"
    UI["Button3Cover"] = Instance.new("Frame", UI["Button3"])
    UI["Button3Cover"]["BackgroundTransparency"] = 1
    UI["Button3Cover"]["BorderSizePixel"] = 0
    UI["Button3Cover"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Button3Cover"]["Size"] = UDim2.new(0, 65, 0, 35)
    UI["Button3Cover"]["Position"] = UDim2.new(-0.00667, 0, -0.00286, 0)
    UI["Button3Cover"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["Button3Cover"]["Name"] = "Button3Cover"
    UI["Idk"] = Instance.new("UICorner", UI["Button1Cover"])
    UI['a'] = Instance.new("UIGradient", UI["Button1Cover"])
    UI['a']["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(191, 79, 90)),ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 32, 36))})
    UI["Idk2"] = Instance.new("UICorner", UI["Button2Cover"])
    UI["a2"] = Instance.new("UIGradient", UI["Button2Cover"])
    UI["a2"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(191, 79, 90)),ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 32, 36))})
    UI["Idk3"] = Instance.new("UICorner", UI["Button3Cover"])
    UI["a3"] = Instance.new("UIGradient", UI["Button3Cover"])
    UI["a3"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(191, 79, 90)),ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 32, 36))})
elseif (GameState == "Lobby") then
    CreateTab()
    UI["LobbyMain"] = Instance.new("TextButton", UI["TabHolder"])
    UI["LobbyMain"]["TextWrapped"] = true
    UI["LobbyMain"]["TextStrokeTransparency"] = 0.8
    UI["LobbyMain"]["RichText"] = true
    UI["LobbyMain"]["BorderSizePixel"] = 0
    UI["LobbyMain"]["TextStrokeColor3"] = Color3.fromRGB(101, 0, 0)
    UI["LobbyMain"]["TextSize"] = 18
    UI["LobbyMain"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
    UI["LobbyMain"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["LobbyMain"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold, Enum['FontStyle'].Normal)
    UI["LobbyMain"]["ZIndex"] = 100
    UI["LobbyMain"]["BackgroundTransparency"] = 1
    UI["LobbyMain"]["Size"] = UDim2.new(0, 65, 0, 35)
    UI["LobbyMain"]["LayoutOrder"] = 5
    UI["LobbyMain"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["LobbyMain"]["Text"] = "MAIN"
    UI["LobbyMain"]["Position"] = UDim2.new(0.17, 0, 0.045, 0)
    UI["LobbyMain"]["Name"] = "LobbyMain"
    UI["LobbyMainCover"] = Instance.new("Frame", UI["LobbyMain"])
    UI["LobbyMainCover"]["BackgroundTransparency"] = 1
    UI["LobbyMainCover"]["BorderSizePixel"] = 0
    UI["LobbyMainCover"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["LobbyMainCover"]["Size"] = UDim2.new(0, 65, 0, 35)
    UI["LobbyMainCover"]["Position"] = UDim2.new(-0.00667, 0, -0.00286, 0)
    UI["LobbyMainCover"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["LobbyMainCover"]["Name"] = "LobbyMainCover"
    UI["Idk2"] = Instance.new("UICorner", UI["LobbyMainCover"])
    UI["a2"] = Instance.new("UIGradient", UI["LobbyMainCover"])
    UI["a2"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(191, 79, 90)),ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 32, 36))})
end
local NotificationSound = "rbxassetid://89871052622148"
task.spawn(function()
    local obj_3 = {[1]=UI["5"],[2]=UI["PlayerTab"],[3]=UI["GhostTab"]}
    local function innerFn_3(instance_8, instance_9, instance_10)
        if (CurrentTab == instance_8) then
            return
        end
        local value_14 = obj_3[CurrentTab]
        local value_15 = obj_3[instance_8]
        if value_14 then
            FadeOutDescendants(value_14, 0.1)
            task.wait(0.1)
            value_14['Visible'] = false
        end
        CurrentTab = instance_8
        local value_16 = UI[instance_10]
        if value_16 then
            local tweenInfo_9 = TweenInfo.new(0.1, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut)
            TweenService:Create(value_16, tweenInfo_9, {["BackgroundTransparency"]=0.8}):Play()
        end
        for k_11, v_11 in pairs(UI["1"]['Frame']['TabHolder']:GetChildren()) do
            if (v_11:IsA("TextButton") and (v_11['Name'] ~= instance_9)) then
                for k_12, v_12 in pairs(v_11:GetChildren()) do
                    if (v_12:IsA("Frame") and (v_12['Name'] ~= instance_10)) then
                        local tweenInfo_10 = TweenInfo.new(0.25, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut)
                        TweenService:Create(v_12, tweenInfo_10, {["BackgroundTransparency"]=1}):Play()
                    end
                end
            end
        end
        if value_15 then
            value_15['Visible'] = true
            FadeInDescendants(value_15, 0.1)
        end
    end
    if (GameState == "MainGame") then
        UI["Button1"]['MouseEnter']:Connect(function()
            if (CurrentTab ~= 1) then
                local tweenInfo_12 = TweenInfo.new(0.1, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
                local tween_3 = TweenService:Create(UI['Button1Cover'], tweenInfo_12, {["BackgroundTransparency"]=0.8})
                tween_3:Play()
            end
        end)
        UI["Button1"]['Activated']:Connect(function()
            innerFn_3(1, "Button1", "Button1Cover")
        end)
        UI["Button1"]['MouseLeave']:Connect(function()
            if (CurrentTab ~= 1) then
                local tweenInfo_13 = TweenInfo.new(0.25, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
                local tween_4 = TweenService:Create(UI['Button1Cover'], tweenInfo_13, {["BackgroundTransparency"]=1})
                tween_4:Play()
            end
        end)
        UI["Button2"]['MouseEnter']:Connect(function()
            if (CurrentTab ~= 2) then
                local tweenInfo_14 = TweenInfo.new(0.1, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
                local tween_5 = TweenService:Create(UI['Button2Cover'], tweenInfo_14, {["BackgroundTransparency"]=0.8})
                tween_5:Play()
            end
        end)
        UI["Button2"]['Activated']:Connect(function()
            innerFn_3(2, "Button2", "Button2Cover")
        end)
        UI["Button2"]['MouseLeave']:Connect(function()
            if (CurrentTab ~= 2) then
                local tweenInfo_15 = TweenInfo.new(0.25, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
                local tween_6 = TweenService:Create(UI['Button2Cover'], tweenInfo_15, {["BackgroundTransparency"]=1})
                tween_6:Play()
            end
        end)
        UI["Button3"]['MouseEnter']:Connect(function()
            if (CurrentTab ~= 3) then
                local tweenInfo_16 = TweenInfo.new(0.1, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
                local tween_7 = TweenService:Create(UI['Button3Cover'], tweenInfo_16, {["BackgroundTransparency"]=0.8})
                tween_7:Play()
            end
        end)
        UI["Button3"]['Activated']:Connect(function()
            innerFn_3(3, "Button3", "Button3Cover")
        end)
        UI["Button3"]['MouseLeave']:Connect(function()
            if (CurrentTab ~= 3) then
                local tweenInfo_17 = TweenInfo.new(0.25, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
                local tween_8 = TweenService:Create(UI['Button3Cover'], tweenInfo_17, {["BackgroundTransparency"]=1})
                tween_8:Play()
            end
        end)
    elseif (GameState == "Lobby") then
        UI["LobbyMain"]['MouseEnter']:Connect(function()
            if (CurrentTab ~= 1) then
                local tweenInfo_18 = TweenInfo.new(0.1, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
                local tween_9 = TweenService:Create(UI['LobbyMainCover'], tweenInfo_18, {["BackgroundTransparency"]=0.8})
                tween_9:Play()
            end
        end)
        UI["LobbyMain"]['Activated']:Connect(function()
            innerFn_3(1, "LobbyMain", "LobbyMainCover")
        end)
        UI["LobbyMain"]['MouseLeave']:Connect(function()
            if (CurrentTab ~= 1) then
                local tweenInfo_19 = TweenInfo.new(0.25, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
                local tween_10 = TweenService:Create(UI['LobbyMainCover'], tweenInfo_19, {["BackgroundTransparency"]=1})
                tween_10:Play()
            end
        end)
    end
    if (CurrentTab == 1) then
        if (GameState == "MainGame") then
            UI["5"]["Visible"] = true
            UI["Button1Cover"]["BackgroundTransparency"] = 0.8
            if UI["PlayerTab"] then
                UI["PlayerTab"]['Visible'] = false
            end
            if UI["GhostTab"] then
                UI["GhostTab"]['Visible'] = false
            end
        elseif (GameState == "Lobby") then
            UI["5"]['Visible'] = true
            UI["LobbyMainCover"]['BackgroundTransparency'] = 0.8
            if UI["PlayerTab"] then
                UI["PlayerTab"]['Visible'] = false
            end
        end
    elseif (CurrentTab == 2) then
        if (GameState == "MainGame") then
            if UI["5"] then
                UI["5"]['Visible'] = false
            end
            if UI["GhostTab"] then
                UI["GhostTab"]['Visible'] = false
            end
            UI["PlayerTab"]["Visible"] = true
            UI["Button2Cover"]["BackgroundTransparency"] = 0.8
        end
    elseif (CurrentTab == 3) then
        if (GameState == "MainGame") then
            if UI["5"] then
                UI["5"]['Visible'] = false
            end
            if UI["PlayerTab"] then
                UI["PlayerTab"]['Visible'] = false
            end
            UI["GhostTab"]["Visible"] = true
            UI["Button3Cover"]["BackgroundTransparency"] = 0.8
        end
    end
    UI["Minimize"]['Activated']:Connect(function()
        local tweenInfo_20 = TweenInfo.new(0.1, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
        if (UI["2"]['Size'] == UDim2.new(0, 700, 0, 25)) then
            local size_2 = (Unused20[UI["2"]] and Unused20[UI["2"]]['Size']) or UDim2.new(0, 700, 0, 400)
            TweenService:Create(UI["2"], tweenInfo_20, {["Size"]=size_2}):Play()
            for k_22, v_22 in pairs(UI["2"]:GetDescendants()) do
                local value_17 = Unused20[v_22]
                if value_17 then
                    TweenService:Create(v_22, tweenInfo_20, value_17):Play()
                end
            end
        else
            Unused20[UI["2"]] = {["Size"]=UI["2"]['Size']}
            TweenService:Create(UI["2"], tweenInfo_20, {["Size"]=UDim2.new(0, 700, 0, 25)}):Play()
            for k_23, v_23 in pairs(UI["2"]:GetChildren()) do
                local value_18 = v_23:FindFirstAncestor("PlayerTab") or v_23:FindFirstAncestor("GhostTab")
                if (value_18 and not value_18['Visible']) then
                    continue
                end
                local tbl_2 = {}
                local tbl_3 = {}
                if v_23:IsA("Frame") then
                    tbl_3['BackgroundTransparency'] = v_23['BackgroundTransparency']
                    tbl_3['Size'] = v_23['Size']
                    tbl_2['BackgroundTransparency'] = 1
                    tbl_2['Size'] = UDim2.new(v_23['Size']['X'].Scale, v_23['Size']['X'].Offset, 0, 0)
                end
                if v_23:IsA("ScrollingFrame") then
                    tbl_3['BackgroundTransparency'] = v_23['BackgroundTransparency']
                    tbl_3['Size'] = v_23['Size']
                    tbl_2['BackgroundTransparency'] = 1
                    tbl_2['Size'] = UDim2.new(v_23['Size']['X'].Scale, v_23['Size']['X'].Offset, 0, 0)
                end
                if ((v_23:IsA("TextLabel") or v_23:IsA("TextBox") or v_23:IsA("TextButton")) and (v_23['Name'] ~= "Discord")) then
                    tbl_3['BackgroundTransparency'] = v_23['BackgroundTransparency']
                    tbl_3['TextTransparency'] = v_23['TextTransparency']
                    tbl_3['Size'] = v_23['Size']
                    tbl_2['BackgroundTransparency'] = 1
                    tbl_2['TextTransparency'] = 1
                    tbl_2['Size'] = UDim2.new(v_23['Size']['X'].Scale, v_23['Size']['X'].Offset, 0, 0)
                end
                if v_23:IsA("ViewportFrame") then
                    tbl_3['Visible'] = v_23['Visible']
                    tbl_2['Visible'] = false
                end
                if ((v_23:IsA("ImageLabel") or v_23:IsA("ImageButton")) and (v_23['Name'] ~= "Minimize") and (v_23['Name'] ~= "Close")) then
                    tbl_3['BackgroundTransparency'] = v_23['BackgroundTransparency']
                    tbl_3['ImageTransparency'] = v_23['ImageTransparency']
                    tbl_2['BackgroundTransparency'] = 1
                    tbl_2['ImageTransparency'] = 1
                end
                if v_23:IsA("UIStroke") then
                    tbl_3['Transparency'] = v_23['Transparency']
                    tbl_2['Transparency'] = 1
                end
                if next(tbl_2) then
                    Unused20[v_23] = tbl_3
                    TweenService:Create(v_23, tweenInfo_20, tbl_2):Play()
                elseif v_23:IsA("UIGradient") then
                    Unused20[v_23] = {["Offset"]=v_23['Offset']}
                    TweenService:Create(v_23, tweenInfo_20, {["Offset"]=Vector2.new(1, 0)}):Play()
                end
            end
            for k_24, v_24 in pairs(UI["2"]['TabHolder']:GetDescendants()) do
                local value_19 = v_24:FindFirstAncestor("PlayerTab") or v_24:FindFirstAncestor("GhostTab")
                if (value_19 and not value_19['Visible']) then
                    continue
                end
                local tbl_4 = {}
                local tbl_5 = {}
                if ((v_24:IsA("TextLabel") or v_24:IsA("TextBox") or v_24:IsA("TextButton")) and (v_24['Name'] ~= "Discord")) then
                    tbl_5['BackgroundTransparency'] = v_24['BackgroundTransparency']
                    tbl_5['TextTransparency'] = v_24['TextTransparency']
                    tbl_5['Size'] = v_24['Size']
                    tbl_4['BackgroundTransparency'] = 1
                    tbl_4['TextTransparency'] = 1
                    tbl_4['Size'] = UDim2.new(v_24['Size']['X'].Scale, v_24['Size']['X'].Offset, 0, 0)
                end
                if v_24:IsA("Frame") then
                    tbl_5['BackgroundTransparency'] = v_24['BackgroundTransparency']
                    tbl_5['Size'] = v_24['Size']
                    tbl_4['BackgroundTransparency'] = 1
                    tbl_4['Size'] = UDim2.new(v_24['Size']['X'].Scale, v_24['Size']['X'].Offset, 0, 0)
                end
                if next(tbl_4) then
                    Unused20[v_24] = tbl_5
                    TweenService:Create(v_24, tweenInfo_20, tbl_4):Play()
                end
            end
            Unused20[UI['b']] = Unused20[UI['b']] or {["Position"]=UI['b']['Position']}
            TweenService:Create(UI['b'], tweenInfo_20, {["Position"]=UDim2.new(0, 150, 0, 1)}):Play()
        end
    end)
    UI["Close"]['Activated']:Connect(function()
        for k_25, v_25 in pairs(PlayerGui:GetChildren()) do
            if (v_25:IsA("ScreenGui") and (v_25['Name'] == GuiName)) then
                for k_26, v_26 in pairs(v_25:GetDescendants()) do
                    local tweenInfo_21 = TweenInfo.new(0.5, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
                    local tbl_6 = {}
                    if (v_26:IsA("Frame") or v_26:IsA("ScrollingFrame") or v_26:IsA("TextBox")) then
                        tbl_6["BackgroundTransparency"] = 1
                    end
                    if (v_26:IsA("TextLabel") or v_26:IsA("TextBox") or v_26:IsA("TextButton")) then
                        tbl_6["BackgroundTransparency"] = 1
                        tbl_6["TextTransparency"] = 1
                    end
                    if (v_26:IsA("ImageLabel") or v_26:IsA("ImageButton")) then
                        tbl_6["BackgroundTransparency"] = 1
                        tbl_6["ImageTransparency"] = 1
                    end
                    if v_26:IsA("UIStroke") then
                        tbl_6["Transparency"] = 1
                    end
                    if next(tbl_6) then
                        TweenService:Create(v_26, tweenInfo_21, tbl_6):Play()
                    elseif v_26:IsA("UIGradient") then
                        TweenService:Create(v_26, tweenInfo_21, {["Offset"]=Vector2.new(1, 0)}):Play()
                    end
                end
                task.wait(0.5)
                v_25:Destroy()
                task.wait(1)
            end
        end
    end)
end)
local RuntimeLabel = CreateLog("Runtime: 00:00", UI['e'], nil, 152, false, nil, false, false)
local WinsLabel = CreateLog("Wins: " .. tostring(game:GetService("Players")['LocalPlayer']:GetAttribute("Wins")), UI['e'], 1, 152, false, nil, false, false)
local LevelLabel = CreateLog("Level: " .. tostring(game:GetService("Players")['LocalPlayer']:GetAttribute("Level")), UI['e'], 2, 152, false, nil, false, false)
local MoneyLabel = CreateLog("Money Made: " .. tostring(game:GetService("Players")['LocalPlayer']:GetAttribute("Money")), UI['e'], 3, 152, false, nil, false, false)
task.spawn(function()
    while true do
        local t0_7 = os.clock() - StartTime
        RuntimeLabel['Text'] = "Runtime: " .. FormatTime(t0_7)
        task.wait(1)
    end
end)
CreateLog("-0.11: Released", UI["1f"], nil, 189, false, nil, false, false)
CreateLog("-0.12: Added notifications", UI["1f"], -1, 189, false, nil, false, false)
CreateLog("-0.13: Added custom hunt sounds", UI["1f"], -2, 189, false, nil, false, false)
CreateLog("-0.14: Fixed some things in the favorite ghost room esp function", UI["1f"], -3, 189, false, nil, false, false)
CreateLog("Loaded.", UI["14"], -1, 152)
if (GameState == "MainGame") then
    UI["PlayerTabInfo"] = Instance.new("Frame", UI["PlayerTab"])
    UI["PlayerTabInfo"]['Size'] = UDim2.new(0, 579, 0, 360)
    UI["PlayerTabInfo"]['Position'] = UDim2.new(0, 0, 0, 5)
    UI["GhostTabInfo"] = Instance.new("Frame", UI["GhostTab"])
    UI["GhostTabInfo"]['Size'] = UDim2.new(0, 579, 0, 360)
    UI["GhostTabInfo"]['Position'] = UDim2.new(0, 0, 0, 5)
    ApplyStyle(UI["GhostTabInfo"], "DarkRed")
    UI["GhostTabInfoLayout"] = Instance.new("UIListLayout", UI["GhostTabInfo"])
    UI["GhostTabInfoLayout"]['Padding'] = UDim.new(0, 5)
    UI["GhostTabInfoLayout"]['FillDirection'] = "Horizontal"
    UI["GhostTabInfoLayout"]['SortOrder'] = "LayoutOrder"
    UI["GhostTabInfo1"] = Instance.new("Frame", UI["GhostTabInfo"])
    UI["GhostTabInfo1"]['Size'] = UDim2.new(0, 200, 0, 360)
    UI["GhostTabInfo2"] = Instance.new("Frame", UI["GhostTabInfo"])
    UI["GhostTabInfo2"]['Size'] = UDim2.new(0, 365, 0, 360)
    UI["GhostTabInfo2"]['LayoutOrder'] = 2
    local frame_8 = Instance.new("Frame", UI["GhostTabInfo2"])
    frame_8['Size'] = UDim2.new(0, 175, 0, 360)
    ApplyStyle(frame_8, "DarkRed", false, true)
    CreateSectionTitle("POSSIBLE GHOST TYPES:", frame_8, 0, 175, 28, true, true, true)
    UI["GhostTabDivider2"] = Instance.new("Frame", UI["GhostTabInfo2"])
    UI["GhostTabDivider2"]["BorderSizePixel"] = 0
    UI["GhostTabDivider2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["GhostTabDivider2"]["Size"] = UDim2.new(0, 1, 1, 0)
    UI["GhostTabDivider2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["GhostTabDivider2"]["Name"] = "Divider"
    UI["GhostTabDivider2"]["BackgroundTransparency"] = 0.5
    UI["GhostTabDivider2"]['LayoutOrder'] = 1
    local frame_9 = Instance.new("Frame", UI["GhostTabInfo2"])
    frame_9['LayoutOrder'] = 2
    frame_9['Size'] = UDim2.new(0, 175, 0, 360)
    ApplyStyle(frame_9, "DarkRed", false, true)
    CreateSectionTitle("OTHER:", frame_9, 0, 175, 28, true, true, true)
    local layout_3 = Instance.new("UIListLayout", UI["GhostTabInfo2"])
    layout_3['Padding'] = UDim.new(0, 10)
    layout_3['FillDirection'] = "Horizontal"
    layout_3['SortOrder'] = "LayoutOrder"
    UI["GhostTabDivider"] = Instance.new("Frame", UI["GhostTabInfo"])
    UI["GhostTabDivider"]["BorderSizePixel"] = 0
    UI["GhostTabDivider"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["GhostTabDivider"]["Size"] = UDim2.new(0, 1, 1, 0)
    UI["GhostTabDivider"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["GhostTabDivider"]["Name"] = "Divider"
    UI["GhostTabDivider"]["BackgroundTransparency"] = 0.5
    UI["GhostTabDivider"]['LayoutOrder'] = 1
    UI["GhostTabDividerGradient"] = Instance.new("UIGradient", UI["GhostTabDivider"])
    UI["GhostTabDividerGradient"]["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0, 0.0125),NumberSequenceKeypoint.new(0, 0.637),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0.556),NumberSequenceKeypoint.new(1, 0.725),NumberSequenceKeypoint.new(1, 0.0313),NumberSequenceKeypoint.new(1, 0)})
    UI["GhostTabDividerGradient"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
    ApplyStyle(UI["GhostTabInfo1"], "DarkRed", false, true)
    ApplyStyle(UI["GhostTabInfo2"], "DarkRed", false, false)
    UI["GhostTabInfo1"]['UIListLayout']['SortOrder'] = "LayoutOrder"
    CreateSectionTitle("EVIDENCES:", UI["GhostTabInfo1"], 0, 200, 50)
    UI["GhostTabInfo1"]['TextLabel']['TextSize'] = 16
    UI["PlayerTabDivider1"] = Instance.new("Frame", UI["PlayerTabInfo"])
    UI["PlayerTabDivider1"]["BorderSizePixel"] = 0
    UI["PlayerTabDivider1"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["PlayerTabDivider1"]["Size"] = UDim2.new(0.66, -10, 0, 1)
    UI["PlayerTabDivider1"]["Position"] = UDim2.new(0.32, 0, 0.525, 0)
    UI["PlayerTabDivider1"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["PlayerTabDivider1"]["Name"] = "Divider"
    UI["PlayerTabDivider1"]['Rotation'] = 90
    UI["PlayerTabDivider1"]["BackgroundTransparency"] = 0.5
    UI["PlayerTabDividerGradient1"] = Instance.new("UIGradient", UI["PlayerTabDivider1"])
    UI["PlayerTabDividerGradient1"]["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0, 0.0125),NumberSequenceKeypoint.new(0, 0.637),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0.556),NumberSequenceKeypoint.new(1, 0.725),NumberSequenceKeypoint.new(1, 0.0313),NumberSequenceKeypoint.new(1, 0)})
    UI["PlayerTabDividerGradient1"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
    UI["PlayerTabDivider2"] = Instance.new("Frame", UI["PlayerTabInfo"])
    UI["PlayerTabDivider2"]["BorderSizePixel"] = 0
    UI["PlayerTabDivider2"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["PlayerTabDivider2"]["Size"] = UDim2.new(0.66, -10, 0, 1)
    UI["PlayerTabDivider2"]["Position"] = UDim2.new(0.038, 0, 0.525, 0)
    UI["PlayerTabDivider2"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["PlayerTabDivider2"]["Name"] = "Divider"
    UI["PlayerTabDivider2"]['Rotation'] = 90
    UI["PlayerTabDivider2"]["BackgroundTransparency"] = 0.5
    UI["PlayerTabDividerGradient2"] = Instance.new("UIGradient", UI["PlayerTabDivider2"])
    UI["PlayerTabDividerGradient2"]["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0, 0.0125),NumberSequenceKeypoint.new(0, 0.637),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0.556),NumberSequenceKeypoint.new(1, 0.725),NumberSequenceKeypoint.new(1, 0.0313),NumberSequenceKeypoint.new(1, 0)})
    UI["PlayerTabDividerGradient2"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
    UI["Visuals"] = Instance.new("ScrollingFrame", UI["PlayerTabInfo"])
    UI["Visuals"]['BackgroundTransparency'] = 1
    UI["Visuals"]['Size'] = UDim2.new(0, 185, 0, 350)
    UI["Visuals"]['Position'] = UDim2.new(0, 5, 0, 5)
    UI["Visuals"]['Name'] = "Visuals"
    UI["Visuals"]['AutomaticSize'] = "X"
    UI["Visuals"]["Active"] = true
    UI["Visuals"]["BorderSizePixel"] = 0
    UI["Visuals"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
    UI["Visuals"]["ScrollBarImageTransparency"] = 0.5
    UI["Visuals"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Visuals"]["AutomaticCanvasSize"] = Enum['AutomaticSize']['Y']
    UI["Visuals"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["Visuals"]["ScrollBarThickness"] = 2
    UI["Visuals"]["BackgroundTransparency"] = 1
    UI["PlayerSettings"] = Instance.new("Frame", UI["PlayerTabInfo"])
    UI["PlayerSettings"]['BackgroundTransparency'] = 1
    UI["PlayerSettings"]['Size'] = UDim2.new(0, 185, 0, 350)
    UI["PlayerSettings"]['Position'] = UDim2.new(0, 375, 0, 5)
    UI["PlayerSettings"]['Name'] = "PlayerSettings"
    UI["VisualsLayout"] = Instance.new("UIListLayout", UI["Visuals"])
    UI["VisualsLayout"]['Padding'] = UDim.new(0, 10)
    UI["VisualsLayout"]['HorizontalAlignment'] = "Center"
    UI["VisualsLayout"]['SortOrder'] = "LayoutOrder"
    UI["PlayerSettingsLayout"] = Instance.new("UIListLayout", UI["PlayerSettings"])
    UI["PlayerSettingsLayout"]['Padding'] = UDim.new(0, 10)
    UI["PlayerSettingsLayout"]['HorizontalAlignment'] = "Center"
    UI["PlayerSettingsLayout"]['SortOrder'] = "LayoutOrder"
    UI["PlayerTabInfoCorner"] = Instance.new("UICorner", UI["PlayerTabInfo"])
    UI["PlayerTabInfoGradient"] = Instance.new("UIGradient", UI["PlayerTabInfo"])
    UI["PlayerTabInfoGradient"]["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.85),NumberSequenceKeypoint.new(1, 0.85)})
    UI["PlayerTabInfoGradient"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(192, 75, 91)),ColorSequenceKeypoint.new(1, Color3.fromRGB(91, 33, 37))})
    UI["2ac"] = Instance.new("TextLabel", UI["PlayerTab"])
    UI["2ac"]["BorderSizePixel"] = 0
    UI["2ac"]["TextSize"] = 18
    UI["2ac"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["2ac"]["FontFace"] = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum['FontWeight'].Bold, Enum['FontStyle'].Normal)
    UI["2ac"]["TextColor3"] = Color3.fromRGB(255, 255, 255)
    UI["2ac"]["BackgroundTransparency"] = 1
    UI["2ac"]["RichText"] = true
    UI["2ac"]["Size"] = UDim2.new(0, 156, 0, 50)
    UI["2ac"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["2ac"]["Text"] = "TELEPORTATION"
    UI["2ac"]['Position'] = UDim2.new(0, 212.5, 0, -10)
    UI["2ac"]["LayoutOrder"] = -236627862
    UI["2ac"]["Name"] = "Log"
    UI["Something"] = Instance.new("Frame", UI["2ac"])
    UI["Something"]["BorderSizePixel"] = 0
    UI["Something"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["Something"]["Size"] = UDim2.new(1.05, -10, 0, 1)
    UI["Something"]["Position"] = UDim2.new(0.01, 0, 0, 40)
    UI["Something"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["Something"]['Rotation'] = 180
    UI["Something"]["Name"] = "Divider"
    UI["Something"]["BackgroundTransparency"] = 0.5
    UI["SomethingGradient"] = Instance.new("UIGradient", UI["Something"])
    UI["SomethingGradient"]["Transparency"] = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(0, 0.0125),NumberSequenceKeypoint.new(0, 0.637),NumberSequenceKeypoint.new(0.167, 0.375),NumberSequenceKeypoint.new(0.5, 0.106),NumberSequenceKeypoint.new(0.65, 0.419),NumberSequenceKeypoint.new(1, 0.556),NumberSequenceKeypoint.new(1, 0.725),NumberSequenceKeypoint.new(1, 0.0313),NumberSequenceKeypoint.new(1, 0)})
    UI["SomethingGradient"]["Color"] = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
    UI["SCF"] = Instance.new("ScrollingFrame", UI["PlayerTabInfo"])
    UI["SCF"]["Active"] = true
    UI["SCF"]["BorderSizePixel"] = 0
    UI["SCF"]["CanvasSize"] = UDim2.new(0, 0, 0, 0)
    UI["SCF"]["ScrollBarImageTransparency"] = 0.5
    UI["SCF"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
    UI["SCF"]["AutomaticCanvasSize"] = Enum['AutomaticSize']['Y']
    UI["SCF"]["Size"] = UDim2.new(0, 156, 0, 180)
    UI["SCF"]["Position"] = UDim2.new(0, 213, 0, 200)
    UI["SCF"]["BorderColor3"] = Color3.fromRGB(0, 0, 0)
    UI["SCF"]["ScrollBarThickness"] = 2
    UI["SCF"]["BackgroundTransparency"] = 1
    UI["SCFLayout"] = Instance.new("UIListLayout", UI["SCF"])
    UI["SCFLayout"]['Padding'] = UDim.new(0, 10)
    UI["SCFLayout"]['SortOrder'] = "LayoutOrder"
    UI["SCFLayout"]['HorizontalAlignment'] = "Center"
    UI["MapView"] = Instance.new("ViewportFrame", UI["PlayerTabInfo"])
    UI["MapView"]['Size'] = UDim2.new(0, 150, 0, 150)
    UI["MapView"]['Position'] = UDim2.new(0, 215, 0, 30)
    UI["MapView"]['BackgroundTransparency'] = 1
    UI["MapView"]['Ambient'] = Color3.fromRGB(100, 100, 100)
    UI["MapView"]['LightColor'] = Game:GetService("Lighting")['OutdoorAmbient']
    UI["MapView"]['LightDirection'] = Game:GetService("Lighting"):GetSunDirection()
    UI["MapView"]['BackgroundTransparency'] = 1
    UI["Camera"] = Instance.new("Camera", UI["MapView"])
    UI["MapViewCorner"] = Instance.new("UICorner", UI["MapView"])
    UI["MapViewStroke"] = Instance.new("UIStroke", UI["MapView"])
    UI["MapViewStroke"]['Color'] = Color3.fromRGB(255, 255, 255)
    UI["MapView"]['CurrentCamera'] = UI["Camera"]
    CreateSectionTitle("VISUALS", UI["Visuals"], 0, 185)
    CreateSectionTitle("Adjustables", UI["PlayerSettings"], 4, 185)
    CreateSlider("Walk Speed", UI["PlayerSettings"], 5, 185, false, 10, 100, "WalkSpeed")
    CreateSlider("Jump Power", UI["PlayerSettings"], 6, 185, false, 0, 100, "JumpPower")
    
    -- ===== REMOVE DOOR BUTTON =====
    local RemoveDoorButton = CreateButton("Remove Door", UI["PlayerSettings"], 7, 150)
    RemoveDoorButton['Activated']:Connect(function()
        local doorCount = 0
        
        -- ✅ Loop toàn bộ workspace để tìm doors
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("Part") or obj:IsA("BasePart") then
                -- Check tên có chứa "Door" hoặc "door"
                local objName = obj.Name:lower()
                if string.find(objName, "door") then
                    pcall(function()
                        obj:Destroy()
                        doorCount = doorCount + 1
                    end)
                end
            end
        end
        
        CreateKeybind("Removed " .. doorCount .. " doors!", 3)
    end)
    -- ==============================
    
    -- ===== NOCLIP TOGGLE BUTTON =====
    local NoClipActive = false
    local NoClipButton = CreateButton("NoClip: OFF", UI["PlayerSettings"], 8, 150)
    NoClipButton['Activated']:Connect(function()
        NoClipActive = not NoClipActive
        
        if NoClipActive then
            -- ✅ BẬT NoClip (đi xuyên được)
            NoClipButton['Text'] = "NoClip: ON"
            NoClipButton['BackgroundColor3'] = Color3.fromRGB(0, 255, 0)  -- 🟢 Green
            
            task.spawn(function()
                while NoClipActive do
                    local Chara = LocalPlayer.Character
                    if Chara and Chara:FindFirstChild("HumanoidRootPart") then
                        -- Disable collision cho HumanoidRootPart
                        Chara.HumanoidRootPart.CanCollide = false
                        
                        -- Disable collision cho tất cả parts
                        for _, part in ipairs(Chara:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
            
            CreateKeybind("NoClip enabled - You can phase through walls!", 2)
        else
            -- ✅ TẮT NoClip (bình thường)
            NoClipButton['Text'] = "NoClip: OFF"
            NoClipButton['BackgroundColor3'] = Color3.fromRGB(255, 0, 0)  -- 🔴 Red
            
            local Chara = LocalPlayer.Character
            if Chara then
                -- Enable collision cho HumanoidRootPart
                if Chara:FindFirstChild("HumanoidRootPart") then
                    Chara.HumanoidRootPart.CanCollide = true
                end
                
                -- Enable collision cho tất cả parts
                for _, part in ipairs(Chara:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            
            CreateKeybind("NoClip disabled - Collision enabled", 2)
        end
    end)
    -- ================================
    CreateDivider(UI["PlayerSettings"], 8, 185)
    local flag = false
    local instance_11 = CreateToggle("Infinite Stamina", UI["PlayerSettings"], 9, 185, 85)
    instance_11['Activated']:Connect(function()
        flag = not flag
        if flag then
            task.spawn(function()
                while flag do
                    if (LocalPlayer:GetAttribute("Sprinting") == true) then
                        LocalPlayer:SetAttribute("Sprinting", false)
                    end
                    task.wait(0.01)
                end
            end)
        end
    end)
    CreateSectionTitle("Controls", UI["SCF"])
    CreateLog("Left Mouse Button: Drag", UI["SCF"], 1, 156)
    CreateLog("Mouse Button 1: Zoom in/out", UI["SCF"], 2, 156)
    CreateLog("Right Mouse Button: Teleport", UI["SCF"], 3, 156)
    CreateSectionTitle("Rooms", UI["SCF"], 4)
    local child_19 = Workspace:WaitForChild("Map")
    local child_20 = nil
    local child_21 = Workspace:FindFirstChild("Items")
    local value_20 = nil
    if child_19:FindFirstChild("Map") then
        child_20 = child_19['Map']
    end
    local value_21 = nil
    if child_20 then
        value_21 = child_20:FindFirstChild("Rooms")
    end
    if not value_21 then
        value_21 = child_19:FindFirstChild("Rooms")
    end
    if (Ghost and Ghost:GetAttribute("FavoriteRoom")) then
        for k_68, v_68 in pairs(value_21:GetChildren()) do
            if (v_68['Name'] == Ghost:GetAttribute("FavoriteRoom")) then
                Unused15 = v_68
            end
        end
    end
    local tbl = {}
    CreateDivider(UI["GhostTabInfo1"], 6, 185)
    
    -- ===== TEMPERATURE DETECTION (từ Demo.lua) =====
    local LowestTemp = math.huge
    local LowestTempRoom = nil
    local TemperatureLabel = CreateLog("Temperature: N/A", UI["GhostTabInfo1"], 1, 185, false, nil, false, false)
    
    -- ===== EVIDENCE REQUIREMENTS TRACKER (THAY THẾ HUNT AI) =====
    local EvidenceLabel = CreateLog("Need: Waiting for evidence...", frame_9, 1, 170, false, nil, false, false)
    
    local function UpdateEvidenceSuggester()
        -- Use value_23 (complete ghost list from game)
        local ghostTypes = value_23 or {
            ["Aswang"] = {"Wither", "EMF Level 5", "Inscription"},
            ["Banshee"] = {"Wither", "Fingerprints", "Freezing Temperatures"},
            ["Demon"] = {"EMF Level 5", "Handprints", "Freezing Temperatures"},
            ["Dullahan"] = {"Wither", "Laser Projector", "Freezing Temperatures"},
            ["Dybbuk"] = {"Wither", "Handprints", "Freezing Temperatures"},
            ["Entity"] = {"Spirit Box", "Handprints", "Laser Projector"},
            ["Ghoul"] = {"Spirit Box", "Freezing Temperatures", "Ghost Orb"},
            ["Hantu"] = {"Ghost Orb", "Freezing Temperatures", "Handprints"},
            ["Jinn"] = {"EMF Level 5", "Freezing Temperatures", "Handprints"},
            ["Keres"] = {"Wither", "Handprints", "Spirit Box"},
            ["Leviathan"] = {"Ghost Orb", "Inscription", "Handprints"},
            ["Mare"] = {"Ghost Orb", "Spirit Box", "Freezing Temperatures"},
            ["Nightmare"] = {"EMF Level 5", "Spirit Box", "Ghost Orb"},
            ["Obake"] = {"EMF Level 5", "Fingerprints", "Ghost Orb"},
            ["Oni"] = {"Spirit Box", "Freezing Temperatures", "Laser Projector"},
            ["Phantom"] = {"EMF Level 5", "Handprints", "Ghost Orb"},
            ["Revenant"] = {"Inscription", "EMF Level 5", "Freezing Temperatures"},
            ["Shade"] = {"Fingerprints", "EMF Level 5", "Freezing Temperatures"},
            ["Shadow"] = {"EMF Level 5", "Inscription", "Laser Projector"},
            ["Siren"] = {"Wither", "Spirit Box", "EMF Level 5"},
            ["Skinwalker"] = {"Freezing Temperatures", "Inscription", "Spirit Box"},
            ["Specter"] = {"EMF Level 5", "Freezing Temperatures", "Laser Projector"},
            ["Spirit"] = {"Handprints", "Inscription", "Spirit Box"},
            ["Umbra"] = {"Ghost Orb", "Laser Projector", "Handprints"},
            ["Vex"] = {"Wither", "Ghost Orb", "Freezing Temperatures"},
            ["Wendigo"] = {"Ghost Orb", "Inscription", "Laser Projector"},
            ["Wisp"] = {"Wither", "Laser Projector", "Ghost Orb"},
            ["Wraith"] = {"EMF Level 5", "Laser Projector", "Spirit Box"},
            ["Yurei"] = {"Ghost Orb", "Handprints", "Freezing Temperatures"},
        }
        
        -- Get current evidence
        local currentEvidence = {}
        if tbl["EMF Level 5"] then table.insert(currentEvidence, "EMF Level 5") end
        if tbl["Freezing Temperatures"] then table.insert(currentEvidence, "Freezing Temperatures") end
        if tbl["Ghost Orb"] then table.insert(currentEvidence, "Ghost Orb") end
        if tbl["Handprints"] then table.insert(currentEvidence, "Handprints") end
        if tbl["Spirit Box"] then table.insert(currentEvidence, "Spirit Box") end
        if tbl["Fingerprints"] then table.insert(currentEvidence, "Fingerprints") end
        if tbl["Inscription"] then table.insert(currentEvidence, "Inscription") end
        if tbl["Laser Projector"] then table.insert(currentEvidence, "Laser Projector") end
        if tbl["Wither"] then table.insert(currentEvidence, "Wither") end
        
        local evidenceCount = #currentEvidence
        
        if evidenceCount < 2 then
            -- Chưa đủ 2 evidence
            EvidenceLabel['Text'] = "Need 2 evidence to suggest"
            EvidenceLabel['TextColor3'] = Color3.fromRGB(255, 0, 0)  -- 🔴 Red
        elseif evidenceCount == 2 then
            -- Có đúng 2 evidence - tìm evidence thứ 3 để phân biệt các loại ma
            local thirdEvidenceSet = {}
            
            for ghostName, ghostEvs in pairs(ghostTypes) do
                local matchCount = 0
                local thirdEvidence = nil
                
                for _, ghostEv in ipairs(ghostEvs) do
                    local found = false
                    for _, currentEv in ipairs(currentEvidence) do
                        if currentEv == ghostEv then
                            found = true
                            matchCount = matchCount + 1
                            break
                        end
                    end
                    if not found then
                        thirdEvidence = ghostEv
                    end
                end
                
                -- Ghost này có cả 2 evidence hiện tại
                if matchCount == 2 and thirdEvidence then
                    -- Thêm evidence thứ 3 vào set (tránh trùng)
                    local isInSet = false
                    for _, ev in ipairs(thirdEvidenceSet) do
                        if ev == thirdEvidence then
                            isInSet = true
                            break
                        end
                    end
                    if not isInSet then
                        table.insert(thirdEvidenceSet, thirdEvidence)
                    end
                end
            end
            
            if #thirdEvidenceSet > 0 then
                local suggestionText = table.concat(thirdEvidenceSet, " / ")
                EvidenceLabel['Text'] = "Need: " .. suggestionText
                EvidenceLabel['TextColor3'] = Color3.fromRGB(255, 200, 0)  -- 🟡 Yellow
            else
                EvidenceLabel['Text'] = "Invalid evidence combination"
                EvidenceLabel['TextColor3'] = Color3.fromRGB(255, 0, 0)  -- 🔴 Red
            end
        else
            -- Đủ 3+ evidence
            local evidenceDisplay = table.concat(currentEvidence, " + ")
            EvidenceLabel['Text'] = "Have: " .. evidenceDisplay
            EvidenceLabel['TextColor3'] = Color3.fromRGB(0, 255, 0)  -- 🟢 Green
            
            -- AUTO-MARK CHỈ KHI ĐÚNG 3 EVIDENCE
            if evidenceCount == 3 then
                task.spawn(function()
                    task.wait(0.5)  -- Wait for functions to be ready
                    local ghostTypesNode = PlayerGui:FindFirstChild("Journal") and
                        PlayerGui.Journal.Holder.Pages.Page4.Right.Page:FindFirstChild("GhostTypes")
                    
                    for ghostName, ghostEvs in pairs(ghostTypes) do
                        if #ghostEvs == 3 then
                            local matchCount = 0
                            for _, ghostEv in ipairs(ghostEvs) do
                                for _, currentEv in ipairs(currentEvidence) do
                                    if ghostEv == currentEv then
                                        matchCount = matchCount + 1
                                        break
                                    end
                                end
                            end
                            
                            -- Mark nếu ghost này match với evidence hiện tại
                            if matchCount > 0 then
                                pcall(function()
                                    findAndFire(ghostTypesNode, ghostName, true)
                                end)
                            end
                        end
                    end
                end)
            end
        end
    end
    
    task.spawn(function()
        while true do
            UpdateEvidenceSuggester()
            task.wait(1)
        end
    end)
    -- ========================================================
        local passedLayers = 0
    local function FindLowestTemperature()
        local Temp = math.huge
        local TempRoom = nil
        if not value_21 then return Temp, TempRoom end
        
        for _, room in ipairs(value_21:GetChildren()) do
            if room:GetAttribute("Temperature") ~= nil then
                if room:GetAttribute("Temperature") < Temp then
                    Temp = room:GetAttribute("Temperature")
                    TempRoom = room
                end
            end
        end
        return Temp, TempRoom
    end
    -- ================================================
    local flag_3 = false
    local cached
    for k_69, v_69 in pairs(child_21:GetChildren()) do
        if (v_69:GetAttribute("ItemName") == "EMF Reader") then
            if v_69:GetAttribute("CurrentReading") then
                while v_69:GetAttribute("CurrentReading") do
                    cached = v_69:GetAttribute("CurrentReading")
                    task.wait(0.1)
                end
            end
        end
    end
    local cached_2
    local cached_3
    for k_70, v_70 in pairs(child_21:GetChildren()) do
        if (v_70:GetAttribute("ItemName") == "Flower Pot") then
            cached_2 = v_70
        elseif (v_70:GetAttribute("ItemName") == "Spirit Book") then
            cached_3 = v_70
        end
    end
    child_21['ChildAdded']:Connect(function(arg_2)
        if (arg_2:GetAttribute("ItemName") == "Flower Pot") then
            cached_2 = arg_2
        elseif (arg_2:GetAttribute("ItemName") == "Spirit Book") then
            cached_3 = arg_2
        end
    end)
    CreateLog("None", UI["GhostTabInfo1"], 2, 185, false, "None", true, false)
    task.spawn(function()
        while true do
            if (Workspace:FindFirstChild("Handprints") and Workspace['Handprints']:FindFirstChildWhichIsA("BasePart")) then
                tbl["Handprints"] = true
            end
            for k_27, v_27 in pairs(value_21:GetChildren()) do
                if v_27 then
                    local temp = v_27:GetAttribute("Temperature")
                    if temp then
                        local tempValue = tonumber(temp) or temp  -- Convert string to number if needed
                        if type(tempValue) == "number" and tempValue < 0 then
                            tbl["Freezing Temperatures"] = true
                        end
                    end
                end
            end
            if (Workspace and Workspace:FindFirstChild("GhostOrb")) then
                tbl["Ghost Orb"] = true
            end
            if ((Ghost and Ghost:GetAttribute("LastEMFLevel5Time")) or (cached == 5)) then
                tbl["EMF Level 5"] = true
            end
            if (Ghost and ((Ghost:GetAttribute("LaserVisible") == true) or (Ghost:GetAttribute("InLaser") == true))) then
                tbl["Laser Projector"] = true
            end
            if cached_2 then
                if (cached_2:GetAttribute("PhotoRewardType") == "WitheredFlowers") then
                    tbl["Wither"] = true
                end
            end
            -- Inscription: Check Spirit Book có Decal texture (ma đã viết)
            if cached_3 then
                for _, obj in ipairs(cached_3:GetDescendants()) do
                    if obj:IsA("Decal") then
                        local Model = obj:FindFirstAncestorWhichIsA("Model")
                        if Model and Model:GetAttribute("ItemName") == "Spirit Book" then
                            if obj.Texture ~= "" then  -- ✅ Decal có texture = ma viết
                                tbl["Inscription"] = true
                                break
                            end
                        end
                    end
                end
            end
            
            -- ===== UPDATE TEMPERATURE LABEL =====
            local Temp, TempRoom = FindLowestTemperature()
            if Temp and TempRoom then
                if Temp < LowestTemp then
                    LowestTemp = Temp
                    LowestTempRoom = TempRoom
                    TemperatureLabel['Text'] = string.format("Temperature: %.1f°C (%s)", LowestTemp, LowestTempRoom.Name)
                    if LowestTemp < 0 then
                        TemperatureLabel['TextColor3'] = Color3.fromRGB(0, 255, 0)  -- Green when freezing
                        tbl["Freezing Temperatures"] = true  -- ✅ AUTO-MARK khi < 0
                    else
                        TemperatureLabel['TextColor3'] = Color3.fromRGB(255, 0, 0)  -- Red when warm
                    end
                end
            end
            -- =====================================
            
            if (PlayerGui and PlayerGui:FindFirstChild("Subtitles")) then
                local child_6 = PlayerGui['Subtitles']:FindFirstChild("Holder"):FindFirstChild("TextLabel")
                if child_6 then
                    local subtitleText = child_6['Text']
                    -- 35+ keywords từ các con ma - nếu subtitle chứa bất kỳ keyword nào thì đó là Spirit Box response
                    local spiritBoxKeywords = {
                        -- User's request keywords
                        "ELDER", "BEHIND", "DEATH", "ATTACK", "FAR", "AWAY", "HATE", "FAR AWAY", "HURT", "KILL", "CLOSE", "DON'T TURN AROUND", "YOUNG",
                        -- Original keywords
                        "OLD", "I'M BEHIND YOU", "GET OUT", "RUN", "AFRAID", "ANGRY",
                        "YES", "NO", "HERE", "STAY", "INSIDE", "OUTSIDE",
                        "COMING", "FOUND", "WATCH", "LISTEN", "WAIT", "GO",
                        "UP", "DOWN", "COLD", "HOT", "PAIN", "HELP",
                        "LEAVE", "LOST", "GONE", "SOON", "NEXT", "NOW",
                        "TRAPPED", "BOUND", "CURSED", "EVIL", "DARKNESS", "SCREAM"
                    }
                    for _, keyword in ipairs(spiritBoxKeywords) do
                        if string.find(subtitleText, keyword, 1, true) then
                            tbl["Spirit Box"] = true
                            break
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
    local instance_12 = CreateToggle("Notify new evidences", UI["GhostTabInfo1"], 7, 185, 85, _, 75, 100)
    local tbl_10 = {}
    instance_12['Activated']:Connect(function()
        flag_3 = not flag_3
        while flag_3 do
            if (next(tbl) ~= nil) then
                for k_30, v_30 in pairs(UI["GhostTabInfo1"]:GetChildren()) do
                    if (v_30:IsA("Frame") and (v_30['Name'] == "None")) then
                        SetTransparency(0.25, v_30, 1)
                        SetTransparency(0.25, v_30.UIStroke, 1)
                        SetTransparency(0.25, v_30.TextLabel, 1)
                        SetTransparency(0.25, v_30.Noice, 1)
                        task.wait(0.25)
                        v_30:Destroy()
                    end
                end
            end
            if (tbl["Handprints"] and not tbl_10["Handprints"]) then
                tbl_10["Handprints"] = true
                CreateLog("Handprints", UI["GhostTabInfo1"], 2, 185, false, _, true)
                task.spawn(CreateKeybind, "New Evidence: Handprints", 2)
            end
            if (tbl["Freezing Temperatures"] and not tbl_10["Freezing Temperatures"]) then
                tbl_10["Freezing Temperatures"] = true
                CreateLog("Freezing Temperatures", UI["GhostTabInfo1"], 2, 185, false, _, true)
                task.spawn(CreateKeybind, "New Evidence: Freezing Temperatures", 2)
            end
            if (tbl["Ghost Orb"] and not tbl_10["Ghost Orb"]) then
                tbl_10["Ghost Orb"] = true
                CreateLog("Ghost Orb", UI["GhostTabInfo1"], 2, 185, false, _, true)
                task.spawn(CreateKeybind, "New Evidence: Ghost Orb", 2)
            end
            if (tbl["EMF Level 5"] and not tbl_10["EMF Level 5"]) then
                tbl_10["EMF Level 5"] = true
                CreateLog("EMF Level 5", UI["GhostTabInfo1"], 2, 185, false, _, true)
                task.spawn(CreateKeybind, "New Evidence: EMF Level 5", 2)
            end
            if (tbl["Laser Projector"] and not tbl_10["Laser Projector"]) then
                tbl_10["Laser Projector"] = true
                CreateLog("Laser Projector", UI["GhostTabInfo1"], 2, 185, false, _, true)
                task.spawn(CreateKeybind, "New Evidence: Laser Projector", 2)
            end
            if (tbl["Wither"] and not tbl_10["Wither"]) then
                tbl_10["Wither"] = true
                CreateLog("Wither", UI["GhostTabInfo1"], 2, 185, false, _, true)
                task.spawn(CreateKeybind, "New Evidence: Withered Flowers", 2)
            end
            if (tbl["Inscription"] and not tbl_10["Inscription"]) then
                tbl_10["Inscription"] = true
                CreateLog("Inscription", UI["GhostTabInfo1"], 2, 185, false, _, true)
                task.spawn(CreateKeybind, "New Evidence: Ghost Writing", 2)
            end
            if (tbl["Spirit Box"] and not tbl_10["Spirit Box"]) then
                tbl_10["Spirit Box"] = true
                CreateLog("Spirit Box", UI["GhostTabInfo1"], 2, 185, false, _, true)
                task.spawn(CreateKeybind, "New Evidence: Spirit Box", 2)
            end
            task.wait(0.1)
        end
    end)
    local value_23 = {["Aswang"]={"Wither","EMF Level 5","Inscription"},["Banshee"]={"Ghost Orb","Handprints","Freezing Temperatures"},["Demon"]={"EMF Level 5","Handprints","Freezing Temperatures"},["Dullahan"]={"Wither","Laser Projector","Freezing Temperatures"},["Dybbuk"]={"Wither","Handprints","Freezing Temperatures"},["Entity"]={"Spirit Box","Handprints","Laser Projector"},["Ghoul"]={"Spirit Box","Freezing Temperatures","Ghost Orb"},["Keres"]={"Wither","Handprints","Spirit Box"},["Leviathan"]={"Ghost Orb","Inscription","Handprints"},["Nightmare"]={"EMF Level 5","Spirit Box","Ghost Orb"},["Oni"]={"Spirit Box","Freezing Temperatures","Laser Projector"},["Phantom"]={"EMF Level 5","Handprints","Ghost Orb"},["Revenant"]={"Inscription","EMF Level 5","Freezing Temperatures"},["Shadow"]={"EMF Level 5","Inscription","Laser Projector"},["Siren"]={"Wither","Spirit Box","EMF Level 5"},["Skinwalker"]={"Freezing Temperatures","Inscription","Spirit Box"},["Specter"]={"EMF Level 5","Freezing Temperatures","Laser Projector"},["Spirit"]={"Handprints","Inscription","Spirit Box"},["Umbra"]={"Ghost Orb","Laser Projector","Handprints"},["Vex"]={"Wither","Ghost Orb","Freezing Temperatures"},["Wendigo"]={"Ghost Orb","Inscription","Laser Projector"},["Wisp"]={"Wither","Laser Projector","Ghost Orb"},["Wraith"]={"EMF Level 5","Laser Projector","Spirit Box"}}
    local function innerFn_4(parent_2, parent_3)
        local obj_2 = {}
        for k_13, v_13 in pairs(value_23) do
            local flag_15 = true
            for k_14, v_14 in pairs(parent_3) do
                if v_14 then
                    local flag_16 = false
                    for k_15, v_15 in ipairs(v_13) do
                        if (v_15 == k_14) then
                            flag_16 = true
                            break
                        end
                    end
                    if not flag_16 then
                        flag_15 = false
                        break
                    end
                end
            end
            if flag_15 then
                obj_2[k_13] = true
            end
        end
        for k_16, v_16 in ipairs(parent_2:GetChildren()) do
            if ((v_16['Name'] == "PossibleGhost") and not obj_2[v_16['TextLabel']['Text']]) then
                v_16:Destroy()
            end
        end
        local num = 500
        for i in pairs(obj_2) do
            local flag_17 = false
            for k_17, v_17 in ipairs(parent_2:GetChildren()) do
                if (v_17:FindFirstChild("TextLabel") and (v_17['TextLabel']['Text'] == i)) then
                    flag_17 = true
                    v_17['LayoutOrder'] = num
                    break
                end
            end
            if not flag_17 then
                CreateLog(i, parent_2, num, 175, true, "PossibleGhost", true)
            end
        end
    end
    task.spawn(function()
        while task.wait(0.1) do
            innerFn_4(frame_8, tbl)
        end
    end)
    local child_22 = PlayerGui:WaitForChild("Journal"):FindFirstChild("Holder"):FindFirstChild("Pages"):FindFirstChild("Page4"):FindFirstChild("Left"):FindFirstChild("Page"):FindFirstChild("EvidenceTypes")
    local instance_13 = CreateToggle("Auto mark evidences", UI["GhostTabInfo1"], 8, 185, 85, _, 75, 100)
    local flag_4 = false
    local function findAndFire(parentNode, targetName, isGhost)
        if not parentNode then return false end
        -- Tìm node theo nhiều cách
        local node = nil
        -- 1. Tìm trực tiếp
        node = parentNode:FindFirstChild(targetName)
        -- 2. Case-insensitive
        if not node then
            local lower = string.lower(targetName:gsub(" ",""):gsub("_",""))
            for _, c in ipairs(parentNode:GetChildren()) do
                if string.lower(c.Name:gsub(" ",""):gsub("_","")) == lower then
                    node = c; break
                end
            end
        end
        -- 3. Partial match (4 ký tự đầu)
        if not node then
            local prefix = string.lower(targetName:sub(1,4))
            for _, c in ipairs(parentNode:GetChildren()) do
                if string.find(string.lower(c.Name), prefix, 1, true) then
                    node = c; break
                end
            end
        end
        if not node then
            warn("[ESP] Không tìm thấy node:", targetName)
            return false
        end
        -- Tìm Detection button - thử tất cả cấp
        local detection = node:FindFirstChild("Detection")
            or (node:FindFirstChild("Container") and node.Container:FindFirstChild("Detection"))
            or node:FindFirstChildOfClass("TextButton")
            or node:FindFirstChildWhichIsA("TextButton")
        -- Deep search nếu vẫn không thấy
        if not detection then
            for _, desc in ipairs(node:GetDescendants()) do
                if desc:IsA("TextButton") and (desc.Name == "Detection" or desc.Name == "Button") then
                    detection = desc; break
                end
            end
        end
        if not detection then
            warn("[ESP] Không tìm thấy Detection trong node:", node.Name)
            return false
        end
        -- Fire click - không check Highlight vì có thể logic check sai
        local conns = getconnections(detection.MouseButton1Click)
        if #conns > 0 then
            -- Chỉ fire nếu chưa được check (tìm Highlight hoặc check state)
            local alreadyMarked = false
            local highlight = node:FindFirstChild("Highlight") or detection.Parent:FindFirstChild("Highlight")
            if highlight then
                alreadyMarked = highlight.Visible
            end
            if not alreadyMarked then
                conns[1]:Fire()
            end
            return true
        end
        return false
    end

    -- Tên node thật trong EvidenceTypes (từ debug console):
    -- LaserProjector, Handprints, SpiritBox, EMFLevel5, GhostOrb, FreezingTemperatures, GhostWriting, Wither
    local evidenceNodeMap = {
        ["EMF Level 5"]           = {"EMFLevel5"},
        ["Handprints"]            = {"Handprints"},
        ["Spirit Box"]            = {"SpiritBox"},
        ["Ghost Orb"]             = {"GhostOrb"},
        ["Freezing Temperatures"] = {"FreezingTemperatures"},
        ["Inscription"]         = {"GhostWriting"},
        ["Laser Projector"]       = {"LaserProjector"},
        ["Wither"]                = {"Wither"},
    }

    local function innerFn_5(a_11, b_11)
        if not a_11 then return end
        if not b_11 then
            -- Mark evidence
            local candidates = evidenceNodeMap[a_11]
            if candidates then
                for _, name in ipairs(candidates) do
                    if findAndFire(child_22, name, false) then return end
                end
            end
            -- Fallback với tên gốc
            findAndFire(child_22, a_11, false)
        else
            -- Mark ghost type
            local ghostTypesNode = PlayerGui:FindFirstChild("Journal") and
                PlayerGui.Journal.Holder.Pages.Page4.Right.Page:FindFirstChild("GhostTypes")
            findAndFire(ghostTypesNode, a_11, true)
        end
    end
    local instance_14 = CreateToggle("Auto mark ghost types", UI["GhostTabInfo1"], 8, 185, 85, _, 75, 100)
    AG = false
    instance_14['Activated']:Connect(function()
        AG = not AG
        if AG then
            while AG do
                -- Tính toán ghost possible dựa trên evidence tìm được
                local possibleGhosts = {}
                local evidenceCount = 0
                
                -- Đếm số evidence tìm được
                for evidenceName, found in pairs(tbl) do
                    if found then
                        evidenceCount = evidenceCount + 1
                    end
                end
                
                -- Nếu chưa tìm evidence, skip
                if evidenceCount == 0 then
                    task.wait(0.5)
                    continue
                end
                
                -- Tìm ghost nào còn possible (tất cả evidence tìm được đều nằm trong list của ghost)
                for ghostName, evidenceList in pairs(value_23) do
                    local isPossible = true
                    for evidenceName, found in pairs(tbl) do
                        if found then
                            local inList = false
                            for _, e in ipairs(evidenceList) do
                                if e == evidenceName then
                                    inList = true
                                    break
                                end
                            end
                            if not inList then
                                isPossible = false
                                break
                            end
                        end
                    end
                    if isPossible then
                        table.insert(possibleGhosts, ghostName)
                    end
                end
                
                -- Auto mark ghost dựa trên số ghost còn possible:
                -- - Nếu chỉ còn 1 ghost → auto mark nó (chắc chắn)
                -- - Nếu > 1 ghost → mark tất cả để user dễ nhìn
                if #possibleGhosts == 1 then
                    local ghostName = possibleGhosts[1]
                    innerFn_5(ghostName, true)
                    CreateKeybind("Auto-marked: " .. ghostName, 2)
                elseif #possibleGhosts > 1 then
                    -- Mark tất cả possible ghost (để user dễ nhìn)
                    for _, ghostName in ipairs(possibleGhosts) do
                        pcall(function()
                            innerFn_5(ghostName, true)
                        end)
                    end
                end
                
                task.wait(0.5)
            end
        end
    end)
    local instance_15 = CreateToggle("Auto escape ghost hunts", frame_9, 9, 185, 85, _, 75, 100)
    local flag_5 = false
    instance_15['Activated']:Connect(function()
        flag_5 = not flag_5
        if flag_5 then
            while flag_5 do
                if value_21 then
                    for k_32, v_32 in pairs(value_21:GetChildren()) do
                        if (v_32['Name'] == "Base Camp") then
                            if v_32:FindFirstChild("BoundingBox") then
                                local value_25 = nil
                                if v_32['BoundingBox']:IsA("Part") then
                                    value_25 = v_32['BoundingBox']
                                elseif (v_32['BoundingBox']:IsA("Folder") and v_32['BoundingBox']:FindFirstChild("Part")) then
                                    value_25 = v_32['BoundingBox']['Part']
                                end
                                if (value_25 and (Ghost:GetAttribute("Hunting") == true)) then
                                    HumanoidRootPart['CFrame'] = value_25['CFrame']
                                    while (Ghost:GetAttribute("Hunting") == true) and flag_5 do
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end
    end)
    
    -- Auto mark evidences toggle
    instance_13['Activated']:Connect(function()
        flag_4 = not flag_4
        if flag_4 then
            while flag_4 do
                if tbl["EMF Level 5"] then
                    innerFn_5("EMF Level 5")
                end
                if tbl["Handprints"] then
                    innerFn_5("Handprints")
                end
                if tbl["Spirit Box"] then
                    innerFn_5("Spirit Box")
                end
                if tbl["Ghost Orb"] then
                    innerFn_5("Ghost Orb")
                end
                if tbl["Freezing Temperatures"] then
                    innerFn_5("Freezing Temperatures")
                end
                if tbl["Inscription"] then
                    innerFn_5("Inscription")
                end
                if tbl["Laser Projector"] then
                    innerFn_5("Laser Projector")
                end
                if tbl["Wither"] then
                    innerFn_5("Wither")
                end
                task.wait(0.1)
            end
        end
    end)
    if value_21 then
        value_21:FindFirstChild("Base Camp"):FindFirstChild("Truck")
        if value_21:FindFirstChild("Base Camp")['Truck'] then
            local child_23 = value_21:FindFirstChild("Base Camp")['Truck']['Primary']['CFrame']
            if (child_23 == CFrame.new(28.9760437, 3.68303895, -67.749176, 0, -1, 0, 0, 0, -1, 1, 0, 0)) then
                Unused16 = "Fenway Drive"
            elseif (child_23 == CFrame.new(23.4483738, -30.1618786, -64.6128387, 0, 1, 0, 0, 0, -1, -1, 0, 0)) then
                Unused16 = "Juniper Road"
            elseif (child_23 == CFrame.new(25.9909477, 3.73003864, -111.618744, 1, 0, 0, 0, 0, -1, 0, 1, 0)) then
                Unused16 = "Lincoln Street"
            elseif (child_23 == CFrame.new(152.138535, -6.1329999, -44.4111786, -0.998979926, 0.0451572537, -4.936009645462036E-07, -4.936009645462036E-07, -2.181529998779297E-05, -1, -0.0451572537, -0.998979926, 2.181529998779297E-05)) then
                Unused16 = "Bodega"
            elseif (child_23 == CFrame.new(70.0683899, 13.7799997, 157.604065, 0.981209278, -0.192946643, -1.7136335372924805E-06, 1.7136335372924805E-06, 1.7583370208740234E-05, -0.99999994, 0.192946643, 0.981209219, 1.7583370208740234E-05)) then
                Unused16 = "Lilim Lane"
            elseif (child_23 == CFrame.new(-33.8106422, 19.6800022, -15.1539326, -0.709856749, 0.704345942, -4.857778549194336E-06, -4.857778549194336E-06, -1.1801719665527344E-05, -0.99999994, -0.704345942, -0.709856808, 1.1861324310302734E-05)) then
                Unused16 = "Cafe"
            elseif (child_23 == CFrame.new(64.6408768, 89.4869995, -21.5065556, -0.923553705, 0.383469343, 3.6954879760742188E-06, 3.6954879760742188E-06, 1.8477439880371094E-05, -1, -0.383469343, -0.923553586, -1.8477439880371094E-05)) then
                Unused16 = "Bridgewood"
            elseif (child_23 == CFrame.new(126.896324, 3.70000172, 12.1818724, 0.0348294377, 0.999393463, 3.847479820251465E-05, -3.847479820251465E-05, 3.9696693420410156E-05, -1.00000024, -0.999393463, 0.0348296463, 3.9696693420410156E-05)) then
                Unused16 = "Prison"
            elseif (child_23 == CFrame.new(-5.04826546, 4.31711769, -89.8415756, -1, 0, "-0", 0, 0, -1, 0, -1, "-0")) then
                Unused16 = "School"
            elseif (child_23 == CFrame.new()) then
                Unused16 = "Asylum"
            elseif (child_23 == CFrame.new()) then
                Unused16 = "Oakridge"
            end
        end
    end
    local cached_4
    function Clone()
        if UI["MapView"]:FindFirstChild("Map") then
            UI["MapView"]['Map']:Destroy()
        end
        if UI["MapView"]:FindFirstChild("Items") then
            UI["MapView"]['Items']:Destroy()
        end
        if child_19 then
            local clone = child_19:Clone()
            for k_19, v_19 in ipairs(clone:GetDescendants()) do
                if v_19:IsA("BasePart") then
                    v_19['Anchored'] = true
                    v_19['Transparency'] = v_19['Transparency']
                end
            end
            clone['Parent'] = UI["MapView"]
            local child_24
            if (clone['Rooms']:FindFirstChild("Base Camp"):FindFirstChild("BoundingBox") and clone['Rooms']:FindFirstChild("Base Camp")['BoundingBox']:IsA("Folder")) then
                child_24 = clone['Rooms']:FindFirstChild("Base Camp")['BoundingBox']['Part']['CFrame']['Position'] + Vector3.new(0, 50, 0)
            else
                child_24 = clone['Rooms']:FindFirstChild("Base Camp")['BoundingBox']['Position'] + Vector3.new(0, 50, 0)
            end
            UI["Camera"]['CFrame'] = CFrame.new(child_24, child_24 + Vector3.new(0, -1, 0))
            for k_20, v_20 in pairs(clone:GetDescendants()) do
                if (Unused16 == "Fenway Drive") then
                    if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 11) and (v_20['Position']['Y'] < 16)) then
                        v_20:Destroy()
                    end
                elseif (Unused16 == "Juniper Road") then
                    if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > -22) and (v_20['Position']['Y'] < -16)) then
                        v_20:Destroy()
                    end
                elseif (Unused16 == "Lincoln Street") then
                    if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 12) and (v_20['Position']['Y'] < 17)) then
                        v_20:Destroy()
                    end
                elseif (Unused16 == "Bodega") then
                    if (clone and clone:FindFirstChild("Exteriors"):FindFirstChild("Building")) then
                        clone['Exteriors']['Building']:Destroy()
                    end
                    task.spawn(function()
                        if (cached_4 == 1) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > -0.5) and (v_20['Position']['Y'] < 11)) then
                                v_20:Destroy()
                            end
                            if (v_20:IsA("Folder") and (v_20['Name'] == "Ceilings")) then
                                v_20:Destroy()
                            end
                        elseif (cached_4 == 2) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 10) and (v_20['Position']['Y'] < 10.5)) then
                                v_20:Destroy()
                            end
                        end
                    end)
                elseif (Unused16 == "Lilim Lane") then
                    task.spawn(function()
                        if (cached_4 == 1) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 21) and (v_20['Position']['Y'] < 40)) then
                                v_20:Destroy()
                            end
                            if (v_20:IsA("Folder") and (v_20['Name'] == "Ceilings")) then
                                v_20:Destroy()
                            end
                        elseif (cached_4 == 2) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 33) and (v_20['Position']['Y'] < 40)) then
                                v_20:Destroy()
                            end
                        end
                    end)
                elseif (Unused16 == "Cafe") then
                    task.spawn(function()
                        if (cached_4 == 1) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 29) and (v_20['Position']['Y'] < 52)) then
                                v_20:Destroy()
                            end
                            if (v_20:IsA("Folder") and (v_20['Name'] == "Ceilings")) then
                                v_20:Destroy()
                            end
                        elseif (cached_4 == 2) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 42) and (v_20['Position']['Y'] < 52)) then
                                v_20:Destroy()
                            end
                        end
                    end)
                elseif (Unused16 == "Bridgewood") then
                    task.spawn(function()
                        if (cached_4 == 1) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 100) and (v_20['Position']['Y'] < 120)) then
                                v_20:Destroy()
                            end
                            if (v_20:IsA("Folder") and (v_20['Name'] == "Ceilings")) then
                                v_20:Destroy()
                            end
                        elseif (cached_4 == 2) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 115) and (v_20['Position']['Y'] < 120)) then
                                v_20:Destroy()
                            end
                        end
                    end)
                elseif (Unused16 == "Prison") then
                    task.spawn(function()
                        if (cached_4 == 1) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 13) and (v_20['Position']['Y'] < 42)) then
                                v_20:Destroy()
                            end
                            if ((v_20:IsA("Folder") and (v_20['Name'] == "Ceilings")) or (v_20:IsA("Model") and (v_20['Name'] == "AsphaltCeiling"))) then
                                v_20:Destroy()
                            end
                        elseif (cached_4 == 2) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 26) and (v_20['Position']['Y'] < 42)) then
                                v_20:Destroy()
                            end
                        end
                    end)
                elseif (Unused16 == "School") then
                    task.spawn(function()
                        if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 31) and (v_20['Position']['Y'] < 69)) then
                            v_20:Destroy()
                        end
                        if (cached_4 == 1) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 16.5) and (v_20['Position']['Y'] < 69)) then
                                v_20:Destroy()
                            end
                            if (v_20:IsA("Folder") and (v_20['Name'] == "Ceilings")) then
                                v_20:Destroy()
                            end
                        elseif (cached_4 == 2) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 30) and (v_20['Position']['Y'] < 69)) then
                                v_20:Destroy()
                            end
                        end
                    end)
                elseif (Unused16 == "Asylum") then
                    task.spawn(function()
                        if (cached_4 == 1) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 21) and (v_20['Position']['Y'] < 40)) then
                                v_20:Destroy()
                            end
                            if (v_20:IsA("Folder") and (v_20['Name'] == "Ceilings")) then
                                v_20:Destroy()
                            end
                        elseif (cached_4 == 2) then
                            if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 33) and (v_20['Position']['Y'] < 40)) then
                                v_20:Destroy()
                            end
                        end
                    end)
                elseif (Unused16 == "Oakbridge") then
                    if ((v_20:IsA("BasePart") or v_20:IsA("UnionOperation")) and (v_20['Position']['Y'] > 11) and (v_20['Position']['Y'] < 16)) then
                        v_20:Destroy()
                    end
                end
            end
        end
        print(Unused16)
        print(cached_4)
        if child_21 then
            local clone_2 = child_21:Clone()
            clone_2['Parent'] = UI["MapView"]
        end
        return MFClone, IFClone
    end
    if ((Unused16 == "Bodega") or (Unused16 == "Lilim Lane") or (Unused16 == "Cafe") or (Unused16 == "Bridgewood") or (Unused16 == "Prison") or (Unused16 == "School") or (Unused16 == "Asylum")) then
        CreateSectionTitle("Floors", UI["SCF"], -3)
        local instance_16 = CreateButton("Floor 1", UI["SCF"], -4, 150)
        local instance_17 = CreateButton("Floor 2", UI["SCF"], -4, 150)
        cached_4 = 2
        instance_17['Activated']:Connect(function()
            if (cached_4 == 2) then
                return
            end
            cached_4 = 2
            Clone()
            print(cached_4)
        end)
        instance_16['Activated']:Connect(function()
            if (cached_4 == 1) then
                return
            end
            cached_4 = 1
            Clone()
            print(cached_4)
        end)
    end
    CreateSectionTitle("Additions", UI["SCF"], -5)
    local instance_18 = CreateToggle("Map Fullbright", UI["SCF"], -4, 150, 75, 0, 75, 75)
    local result, result_2 = Clone()
    local function innerFn_6(a_12, b_12, c_11, d_11, e_9)
        if not evidence then
            evidence = true
        end
        if not d_11 then
            d_11 = "Evidence"
        end
        if not e_9 then
            e_9 = false
        end
        local billboard_2
        local frame_10
        local label_8
        local label_9
        if not b_12 then
            if (a_12:FindFirstChild("Esp2") and not e_9) then
                return
            end
            if not e_9 then
                billboard_2 = Instance.new("BillboardGui")
                billboard_2['Parent'] = a_12
                billboard_2['AlwaysOnTop'] = true
                billboard_2['Name'] = "Esp2"
                billboard_2['Size'] = UDim2.new(0, 130, 0, 26)
                billboard_2['SizeOffset'] = Vector2.new(0, 0.8)

                -- Nền box (chỉ hiện khi gần <= 30 studs)
                frame_10 = Instance.new("Frame", billboard_2)
                frame_10['Name'] = "BgFrame"
                frame_10['Size'] = UDim2.new(1, 0, 1, 0)
                frame_10['BackgroundTransparency'] = 1
                ApplyStyle(frame_10, "DarkRed2")

                -- Dot charm (luôn hiện, màu theo loại ESP)
                local dot = Instance.new("Frame", billboard_2)
                dot['Name'] = "Charm"
                dot['Size'] = UDim2.new(0, 9, 0, 9)
                dot['AnchorPoint'] = Vector2.new(0, 0.5)
                dot['Position'] = UDim2.new(0, -13, 0.5, 0)
                dot['BackgroundTransparency'] = 0
                dot['BorderSizePixel'] = 0
                dot['ZIndex'] = 5
                local dotCorner = Instance.new("UICorner", dot)
                dotCorner['CornerRadius'] = UDim.new(1, 0)
                if d_11 == "Item" then
                    dot['BackgroundColor3'] = Color3.fromRGB(255, 255, 255)
                elseif d_11 == "Alive" then
                    dot['BackgroundColor3'] = Color3.fromRGB(50, 220, 80)
                elseif d_11 == "Ghost" then
                    dot['BackgroundColor3'] = Color3.fromRGB(220, 50, 50)
                else
                    dot['BackgroundColor3'] = Color3.fromRGB(200, 200, 200)
                end

                -- Label tên
                label_8 = Instance.new("TextLabel", billboard_2)
                label_8['Name'] = "NameLabel"
                label_8['TextColor3'] = Color3.fromRGB(255, 255, 255)
                label_8['Size'] = UDim2.new(1, 0, 1, 0)
                label_8['BackgroundTransparency'] = 1
                label_8['TextTransparency'] = 1
                label_8['TextScaled'] = false
                label_8['TextSize'] = 13
                label_8['Font'] = Enum.Font.GothamBold
                label_8['Text'] = c_11
                SetTransparency(0.25, frame_10, 0)
                SetTransparency(0.25, label_8, 0)
                task.wait(0.25)

                -- Vòng lặp distance: xa thì ẩn nền, chỉ giữ dot + tên
                task.spawn(function()
                    while billboard_2 and billboard_2.Parent do
                        local root = HumanoidRootPart
                        if root and a_12 and a_12.Parent then
                            local dist = (a_12.Position - root.Position).Magnitude
                            local isClose = dist <= 30
                            if frame_10 and frame_10.Parent then
                                frame_10['BackgroundTransparency'] = isClose and 0 or 1
                                local stroke = frame_10:FindFirstChildOfClass("UIStroke")
                                if stroke then stroke['Transparency'] = isClose and 0 or 1 end
                            end
                        end
                        task.wait(0.15)
                    end
                end)
            end
            if e_9 then
                local child_3 = a_12:FindFirstChild("Esp2")
                local child_4 = child_3 and child_3:FindFirstChild("Evidence")
                local label_7 = child_3 and child_3:FindFirstChildOfClass("TextLabel")
                if (label_7 and child_4) then
                    for n_2 = string.len(child_4.Text), 0, -1 do
                        child_4['MaxVisibleGraphemes'] = n_2
                        task.wait(0.025)
                    end
                    label_7['Text'] = c_11
                    child_4['Text'] = d_11
                    for n_3 = 1, #d_11 do
                        child_4['MaxVisibleGraphemes'] = n_3
                        task.wait(0.025)
                    end
                end
            end
        else
            local child_5 = a_12:FindFirstChild("Esp2")
            if child_5 then
                for k_21, v_21 in pairs(child_5:GetDescendants()) do
                    if (v_21:IsA("Frame") or v_21:IsA("TextLabel")) then
                        SetTransparency(0.25, v_21, 1)
                    end
                end
                task.wait(0.25)
                child_5:Destroy()
            end
        end
        return label_9
    end
    local instance_19 = CreateToggle("Item ESP", UI["Visuals"], 1, 185, 85)
    local flag_6 = false
    instance_19['Activated']:Connect(function()
        flag_6 = not flag_6
        if flag_6 then
            while flag_6 do
                for k_33, v_33 in pairs(child_21:GetChildren()) do
                    if (v_33:IsA("Model") and v_33['PrimaryPart']) then
                        local primaryPart = v_33['PrimaryPart']
                        -- Check xem item có đang được cầm không (gần player < 5 studs)
                        local isBeingHeld = false
                        if HumanoidRootPart then
                            local dist = (primaryPart.Position - HumanoidRootPart.Position).Magnitude
                            if dist < 5 then
                                isBeingHeld = true
                            end
                        end
                        -- Cũng check các player khác
                        if not isBeingHeld then
                            for _, plr in pairs(Players:GetPlayers()) do
                                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                                    local d = (primaryPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                                    if d < 5 then
                                        isBeingHeld = true
                                        break
                                    end
                                end
                            end
                        end
                        if not isBeingHeld then
                            if not v_33:FindFirstChild("Highlight") then
                                Instance.new("Highlight", v_33)
                                v_33['Highlight']['FillTransparency'] = 1
                            end
                            if not primaryPart:FindFirstChild("Esp2") then
                                innerFn_6(primaryPart, false, v_33:GetAttribute("ItemName"), "Item")
                            end
                        else
                            -- Item đang được cầm: xóa ESP
                            if v_33:FindFirstChild("Highlight") then
                                v_33['Highlight']:Destroy()
                            end
                            if primaryPart:FindFirstChild("Esp2") then
                                innerFn_6(primaryPart, true, false, false)
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        else
            for k_34, v_34 in pairs(child_21:GetChildren()) do
                if v_34:IsA("Model") then
                    local primaryPart = v_34['PrimaryPart']
                    if primaryPart and primaryPart:FindFirstChild("Esp2") then
                        innerFn_6(primaryPart, true, false, false)
                    end
                    -- Xóa Highlight
                    if v_34:FindFirstChild("Highlight") then
                        v_34['Highlight']:Destroy()
                    end
                    -- Xóa hết Esp2 trên tất cả descendants phòng trường hợp sót
                    for k_35, v_35 in pairs(v_34:GetDescendants()) do
                        if v_35:IsA("Highlight") then
                            v_35:Destroy()
                        end
                        if v_35:IsA("BillboardGui") and v_35['Name'] == "Esp2" then
                            v_35:Destroy()
                        end
                    end
                end
            end
        end
    end)
    local flag_7 = false
    local instance_20 = CreateToggle("Player ESP", UI["Visuals"], 1, 185, 85)
    instance_20['Activated']:Connect(function()
        flag_7 = not flag_7
        task.wait(0.1)
        if flag_7 then
            local child_7 = Workspace:FindFirstChild("Ragdolls")
            for k_36, v_36 in pairs(Workspace:GetChildren()) do
                if (v_36:FindFirstChild("Humanoid") and (v_36['Name'] ~= "Ghost") and (v_36['Name'] ~= LocalPlayer['Name'])) then
                    if (v_36:FindFirstChild("Head") and not v_36['Head']:FindFirstChild("Esp2")) then
                        innerFn_6(v_36.Head, false, v_36.Name, "Alive")
                    end
                    for k_37, v_37 in pairs(v_36:GetDescendants()) do
                        if v_37:IsA("BasePart") then
                            if not v_37:FindFirstChild("Highlight") then
                                Instance.new("Highlight", v_37)
                                v_37['Transparency'] = 0
                                if v_37:FindFirstChild("Highlight") then
                                    v_37['Highlight']['FillTransparency'] = 1
                                end
                            end
                        end
                    end
                    if (child_7 and child_7:FindFirstChild(v_36.Name)) then
                        print("hah2")
                        if v_36:FindFirstChild("Head") then
                            print("hah3")
                            if v_36['Head']:FindFirstChild("Esp2") then
                                print("hah4")
                                task.wait(0.26)
                                if v_36['Head']['Esp2']:FindFirstChild("Evidence") then
                                    print("heh5")
                                    v_36['Head']['Esp2']['Evidence']['Text'] = "Deceased"
                                end
                            end
                        end
                    end
                end
            end
        else
            local child_8 = Workspace:FindFirstChild("Ragdolls")
            for k_38, v_38 in pairs(Workspace:GetChildren()) do
                if v_38:FindFirstChild("Humanoid") then
                    if (v_38:FindFirstChild("Head") and v_38['Head']:FindFirstChild("Esp2")) then
                        innerFn_6(v_38.Head, true, v_38.Name, "Alive")
                    end
                    for k_39, v_39 in pairs(v_38:GetDescendants()) do
                        if v_38:IsA("BasePart") then
                            v_38['Transparency'] = 1
                            if v_38:FindFirstChild("Highlight") then
                                v_38['Highlight']['FillTransparency'] = 1
                                v_38['Highlight']['OutlineTransparency'] = 1
                                v_38['Highlight']:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end)
    local flag_8 = false
    local instance_21 = CreateToggle("Ghost ESP", UI["Visuals"], 3, 185, 85)
    instance_21['Activated']:Connect(function()
        flag_8 = not flag_8
        if flag_8 then
            while flag_8 do
                if (Ghost and Ghost:FindFirstChild("Head")) then
                    innerFn_6(Ghost.Head, false, "Ghost", Ghost:GetAttribute("VisualModel"))
                    if Ghost:FindFirstChild("VisibleParts") then
                        for k_40, v_40 in pairs(Ghost['VisibleParts']:GetDescendants()) do
                            if v_40:IsA("BasePart") then
                                v_40['Transparency'] = 0
                            end
                            if (v_40:IsA("BasePart") and not v_40:FindFirstChild("Highlight")) then
                                local highlight = Instance.new("Highlight")
                                highlight['FillTransparency'] = 1
                                highlight['OutlineTransparency'] = 1
                                highlight['Parent'] = v_40
                                local tweenInfo_22 = TweenInfo.new(0.25, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
                                local tween_11 = TweenService:Create(highlight, tweenInfo_22, {["OutlineTransparency"]=0})
                                local tween_12 = TweenService:Create(v_40, tweenInfo_22, {["Transparency"]=0})
                                tween_11:Play()
                                tween_12:Play()
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        else
            if (Ghost and Ghost:FindFirstChild("Head") and Ghost['Head']:FindFirstChild("Esp2")) then
                innerFn_6(Ghost.Head, true, "Ghost", Ghost:GetAttribute("VisualModel"))
            end
            if (Ghost and Ghost:FindFirstChild("VisibleParts")) then
                local tbl_7 = {}
                for k_41, v_41 in pairs(Ghost['VisibleParts']:GetDescendants()) do
                    if (v_41:IsA("BasePart") and v_41:FindFirstChild("Highlight")) then
                        local tweenInfo_23 = TweenInfo.new(0.25, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut, 0, false, 0)
                        local tween_13 = TweenService:Create(v_41.Highlight, tweenInfo_23, {["OutlineTransparency"]=1})
                        local tween_14 = TweenService:Create(v_41, tweenInfo_23, {["Transparency"]=1})
                        tween_13:Play()
                        tween_14:Play()
                        table.insert(tbl_7, v_41.Highlight)
                    end
                end
                task.wait(0.25)
                for k_42, v_42 in pairs(tbl_7) do
                    v_42:Destroy()
                end
            end
        end
    end)
    local flag_9 = false
    local instance_22 = CreateToggle("Evidence ESP", UI["Visuals"], 4, 185, 85)
    local flag_10 = false
    instance_22['Activated']:Connect(function()
        flag_10 = not flag_10
        if flag_10 then
            while flag_10 do
                if tbl["Ghost Orb"] then
                    local child_9 = Workspace:FindFirstChild("GhostOrb")
                    if child_9 then
                        child_9['Transparency'] = 0
                        if not child_9:FindFirstChild("Esp2") then
                            innerFn_6(child_9, false, "Ghost Orb", "Evidence")
                        end
                    end
                end
                if tbl["Handprints"] then
                    local child_10 = Workspace:FindFirstChild("Handprints")
                    if child_10 then
                        for k_43, v_43 in ipairs(child_10:GetChildren()) do
                            if not v_43:FindFirstChild("Esp2") then
                                innerFn_6(v_43, false, "Handprint", "Evidence")
                            end
                        end
                    end
                end
                if tbl["Inscription"] then
                    for k_44, v_44 in ipairs(child_21:GetChildren()) do
                        local child_11 = v_44['PrimaryPart']:FindFirstChild("Esp2")
                        local child_12 = child_11 and child_11:FindFirstChild("Evidence")
                        if (v_44:GetAttribute("ItemName") == "Spirit Book") then
                            if not child_11 then
                                innerFn_6(v_44.PrimaryPart, false, "Inscription", "Evidence")
                            elseif (child_12 and (child_12['Text'] ~= "Evidence")) then
                                innerFn_6(v_44.PrimaryPart, false, "Inscription", "Evidence", true)
                            end
                        end
                    end
                end
                if tbl["Wither"] then
                    for k_45, v_45 in pairs(child_21:GetChildren()) do
                        if (v_45:GetAttribute("ItemName") == "Flower Pot") then
                            if (v_45['PrimaryPart'] and not v_45['PrimaryPart']:FindFirstChild("Esp2")) then
                                innerFn_6(v_45.PrimaryPart, false, "Withered Flowers", "Evidence")
                            elseif ((v_45:GetAttribute("ItemName") == "Flower Pot") and v_45['PrimaryPart']:FindFirstChild("Esp2"):FindFirstChild("Evidence") and (not v_45['PrimaryPart']['Esp2']['Evidence']['Text'] == "Evidence")) then
                                innerFn_6(v_45.PrimaryPart, false, "Withered Flowers", "Evidence", true)
                            end
                        end
                    end
                end
                if tbl["Laser Projector"] then
                    for k_46, v_46 in pairs(child_21:GetChildren()) do
                        if (v_46:GetAttribute("ItemName") == "Laser Projector") then
                            if ((Ghost:GetAttribute("LaserVisible") == true) or ((Ghost:GetAttribute("InLaser") == true) and (v_46:GetAttribute("ItemName") == "Laser Projector") and not v_46['PrimaryPart']:FindFirstChild("Esp2"))) then
                                innerFn_6(v_46.PrimaryPart, false, "Laser Projector", "Evidence")
                            elseif ((Ghost:GetAttribute("LaserVisible") == true) or ((Ghost:GetAttribute("InLaser") == true) and (v_46:GetAttribute("ItemName") == "Laser Projector") and v_46['PrimaryPart']:FindFirstChild("Esp2") and (not v_46['PrimaryPart']['Esp2']['Evidence']['Text'] == "Evidence"))) then
                                innerFn_6(v_46.PrimaryPart, false, "Laser Projector", "Evidence", true)
                            end
                        end
                    end
                end
                if tbl["Freezing Temperatures"] then
                    for k_47, v_47 in pairs(child_21:GetDescendants()) do
                        if ((v_47:GetAttribute("ItemName") == "Thermometer") and not v_47['PrimaryPart']:FindFirstChild("Esp2") and (Unused15:GetAttribute("Temperature") < 0)) then
                            innerFn_6(v_47.PrimaryPart, false, "Freezing Temperatures", "Evidence")
                        elseif ((v_47:GetAttribute("ItemName") == "Thermometer") and v_47['PrimaryPart']:FindFirstChild("Esp2") and (Unused15:GetAttribute("Temperature") < 0) and (not v_47['PrimaryPart']['Esp2']['Evidence']['Text'] == "Evidence")) then
                            innerFn_6(v_47.PrimaryPart, false, "Freezing Temperatures", "Evidence", true)
                        end
                    end
                end
                if tbl["EMF Level 5"] then
                    for k_48, v_48 in pairs(child_21:GetDescendants()) do
                        if ((v_48:GetAttribute("ItemName") == "EMF Reader") and not v_48['PrimaryPart']:FindFirstChild("Esp2") and Ghost:GetAttribute("LastEMFLevel5Time")) then
                            innerFn_6(v_48.PrimaryPart, false, "EMF Level 5", "Evidence")
                        elseif ((v_48:GetAttribute("ItemName") == "EMF Reader") and v_48['PrimaryPart']:FindFirstChild("Esp2") and Ghost:GetAttribute("LastEmfLevel5Time") and (not v_48['PrimaryPart']['Esp2']['Evidence']['Text'] == "Evidence")) then
                            innerFn_6(v_48.PrimaryPart, false, "EMF Level 5", "Evidence", true)
                        end
                    end
                end
                task.wait(0.5)
            end
        else
            local child_13 = Workspace:FindFirstChild("GhostOrb")
            if child_13 then
                child_13['Transparency'] = 1
                if child_13:FindFirstChild("Esp2") then
                    innerFn_6(child_13, true)
                end
            end
            local child_14 = Workspace:FindFirstChild("Handprints")
            if child_14 then
                for k_49, v_49 in ipairs(child_14:GetChildren()) do
                    if v_49:FindFirstChild("Esp2") then
                        innerFn_6(v_49, true)
                    end
                end
            end
            for k_50, v_50 in ipairs(child_21:GetChildren()) do
                if (v_50:FindFirstChild("Handle") and v_50['Handle']:FindFirstChild("Esp2")) then
                    innerFn_6(v_50.Handle, true)
                end
            end
        end
    end)
    local flag_11 = false
    local instance_23 = CreateToggle("Ghost's Favorite room esp", UI["Visuals"], 5, 185, 85)
    instance_23['Activated']:Connect(function()
        flag_11 = not flag_11
        if flag_11 then
            while flag_11 do
                local value_26 = Ghost:GetAttribute("FavoriteRoom")
                if value_21 then
                    for k_51, v_51 in pairs(value_21:GetChildren()) do
                        if v_51:IsA("Folder") then
                            if (v_51['Name'] == value_26) then
                                if v_51:FindFirstChild("BoundingBox") then
                                    if v_51['BoundingBox']:IsA("BasePart") then
                                        innerFn_6(v_51.BoundingBox, false, v_51.Name, "Ghost's favorite room.")
                                    elseif v_51['BoundingBox']:FindFirstChild("Part") then
                                        innerFn_6(v_51['BoundingBox'].Part, false, v_51.Name, "Ghost's favorite room.")
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        else
            local value_27 = Ghost:GetAttribute("FavoriteRoom")
            if value_21 then
                for k_52, v_52 in pairs(value_21:GetChildren()) do
                    if v_52:IsA("Folder") then
                        if (v_52['Name'] == value_27) then
                            if v_52:FindFirstChild("BoundingBox") then
                                if v_52['BoundingBox']:IsA("BasePart") then
                                    innerFn_6(v_52.BoundingBox, true, v_52.Name, "Ghost's favorite room.")
                                elseif v_52['BoundingBox']:FindFirstChild("Part") then
                                    innerFn_6(v_52['BoundingBox'].Part, true, v_52.Name, "Ghost's favorite room.")
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    CreateSectionTitle("Custom hunt sound", UI["Visuals"], 6, 185)
    local instance_24 = CreateTextBox(UI["Visuals"], 7, 185, 28)
    task.spawn(function()
        while Ghost and task.wait(0.1) do
            local child_15 = Ghost:FindFirstChild("HumanoidRootPart")
            if not child_15 then
                continue
            end
            local child_16 = child_15:FindFirstChild("Hunt")
            if not child_16 then
                continue
            end
            local value_28 = instance_24['Text']:match("%d+")
            local cached_5
            if value_28 then
                cached_5 = "rbxassetid://" .. value_28
            else
                cached_5 = NotificationSound
            end
            if (child_16['SoundId'] ~= cached_5) then
                child_16['SoundId'] = cached_5
                print("Updated Hunt:", cached_5)
            end
        end
    end)
    CreateSectionTitle("Weather", UI["Visuals"], 8, 189)
    local instance_25 = CreateButton("Rain", UI["Visuals"], 9, 185)
    local instance_26 = CreateButton("Snow", UI["Visuals"], 10, 185)
    local instance_27 = CreateButton("Clear", UI["Visuals"], 11, 185)
    instance_25['Activated']:Connect(function()
        if child_19 then
            for k_53, v_53 in pairs(child_19['Weather']['Rain']:GetDescendants()) do
                if v_53:IsA("ParticleEmitter") then
                    if (v_53['Enabled'] == false) then
                        v_53['Enabled'] = true
                    end
                end
            end
            for k_54, v_54 in pairs(child_19['Weather']['Snow']:GetDescendants()) do
                if v_54:IsA("Texture") then
                    HideElement(1, v_54)
                end
                if ((v_54:IsA("BasePart") and (v_54['Material'] == Enum['Material']['Ground'])) or v_54:IsA("MeshPart")) then
                    HideElement(1, v_54)
                end
                if (v_54:IsA("ParticleEmitter") and (v_54['Enabled'] == true)) then
                    v_54['Enabled'] = false
                end
            end
        end
    end)
    instance_26['Activated']:Connect(function()
        if child_19 then
            for k_55, v_55 in pairs(child_19['Weather']['Snow']:GetDescendants()) do
                if v_55:IsA("Decal") then
                    SetTransparency(1, v_55)
                end
                if ((v_55:IsA("BasePart") and (v_55['Material'] == Enum['Material']['Ground'])) or v_55:IsA("MeshPart")) then
                    SetTransparency(1, v_55)
                end
                if (v_55:IsA("ParticleEmitter") and (v_55['Enabled'] == false)) then
                    v_55['Enabled'] = true
                end
            end
            for k_56, v_56 in pairs(child_19['Weather']['Rain']:GetDescendants()) do
                if v_56:IsA("ParticleEmitter") then
                    if (v_56['Enabled'] == true) then
                        v_56['Enabled'] = false
                    end
                end
            end
        end
    end)
    instance_27['Activated']:Connect(function()
        if child_19 then
            for k_57, v_57 in pairs(child_19['Weather']['Snow']:GetDescendants()) do
                if v_57:IsA("Decal") then
                    HideElement(1, v_57)
                end
                if ((v_57:IsA("BasePart") and (v_57['Material'] == Enum['Material']['Ground'])) or v_57:IsA("MeshPart")) then
                    HideElement(1, v_57)
                end
                if (v_57:IsA("ParticleEmitter") and (v_57['Enabled'] == true)) then
                    v_57['Enabled'] = false
                end
            end
            for k_58, v_58 in pairs(child_19['Weather']['Rain']:GetDescendants()) do
                if v_58:IsA("ParticleEmitter") then
                    if (v_58['Enabled'] == true) then
                        v_58['Enabled'] = false
                    end
                end
            end
        end
    end)
    local instance_28 = CreateToggle("Fullbright", UI["Visuals"], 2, 185, 85)
    local flag_12 = false
    instance_18['Activated']:Connect(function()
        flag_12 = not flag_12
        local tweenInfo_26
        if flag_12 then
            tweenInfo_26 = TweenInfo.new(1.5, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut)
            TweenService:Create(UI['MapView'], tweenInfo_26, {["Ambient"]=Color3.fromRGB(255, 255, 255)}):Play()
        else
            tweenInfo_26 = TweenInfo.new(1, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut)
            TweenService:Create(UI['MapView'], tweenInfo_26, {["Ambient"]=Color3.fromRGB(100, 100, 100)}):Play()
        end
    end)
    local flag_13 = false
    instance_28['Activated']:Connect(function()
        flag_13 = not flag_13
        local value_29 = game:GetService("Lighting")
        if flag_13 then
            local tweenInfo_24 = TweenInfo.new(1.5, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut)
            TweenService:Create(value_29, tweenInfo_24, {["Ambient"]=Color3.fromRGB(255, 255, 255)}):Play()
            task.spawn(function()
                task.wait(1.5)
                while flag_13 do
                    if (value_29['Ambient'] ~= Color3.fromRGB(255, 255, 255)) then
                        TweenService:Create(value_29, tweenInfo_24, {["Ambient"]=Color3.fromRGB(255, 255, 255)}):Play()
                    end
                    task.wait(1.5)
                end
            end)
        else
            local tweenInfo_25 = TweenInfo.new(1, Enum['EasingStyle'].Sine, Enum['EasingDirection'].InOut)
            TweenService:Create(value_29, tweenInfo_25, {["Ambient"]=Color3.fromRGB(0, 0, 0)}):Play()
        end
    end)
    for k_71, v_71 in pairs(value_21:GetChildren()) do
        if v_71['Name'] ~= "Base Camp" then
            local name = CreateButton("Teleport To " .. v_71['Name'], UI["SCF"], 5, 150)
            name['Activated']:Connect(function()
                if (v_71:FindFirstChild("BoundingBox") and v_71['BoundingBox']:IsA("BasePart")) then
                    HumanoidRootPart['Position'] = v_71['BoundingBox']['Position']
                elseif (v_71:FindFirstChild("BoundingBox") and v_71['BoundingBox']:IsA("Folder")) then
                    local children_2 = v_71['BoundingBox']:GetChildren()
                    local value_30 = children_2[math.random(1, #children_2)]
                    HumanoidRootPart['Position'] = value_30['Position']
                end
            end)
        end
    end
    
    CreateSectionTitle("Closets", UI["SCF"], 6)
    if (child_19 and child_19:FindFirstChild("InvisibleGhostWalls")) then
        value_20 = child_19['InvisibleGhostWalls']
    elseif (child_20 and child_20:FindFirstChild("InvisibleGhostWalls")) then
        value_20 = child_20['InvisibleGhostWalls']
    end
    if value_20 then
        local instance_29 = CreateButton("Teleport to the closest closet", UI["SCF"], 7, 150)
        instance_29['Activated']:Connect(function()
            local value_31 = nil
            local value_32 = math['huge']
            if (not child_19:FindFirstChild("Closets") or not child_19:FindFirstChild("Closets"):FindFirstChild("Closet")) then
                for k_59, v_59 in pairs(value_20:GetChildren()) do
                    if (v_59:IsA("BasePart") and (v_59['Name'] == "GhostCloset")) then
                        local pos_4 = (HumanoidRootPart['Position'] - v_59['Position'])['Magnitude']
                        if (pos_4 < value_32) then
                            value_32 = pos_4
                            value_31 = v_59['Position']
                        end
                    end
                end
            else
                local tbl_8 = {}
                for k_60, v_60 in pairs(child_19:FindFirstChild("Closets"):GetChildren()) do
                    if (v_60:IsA("Model") and (v_60['Name'] == "Closet")) then
                        local child_17 = v_60:FindFirstChild("Base"):FindFirstChild("Cube")
                        table.insert(tbl_8, child_17.Position)
                    end
                end
                for k_61, v_61 in pairs(tbl_8) do
                    local pos_5 = (HumanoidRootPart['Position'] - v_61)['Magnitude']
                    if (pos_5 < value_32) then
                        value_32 = pos_5
                        value_31 = v_61
                    end
                end
            end
            if (value_31 and HumanoidRootPart) then
                HumanoidRootPart['CFrame'] = CFrame.new(value_31) * HumanoidRootPart['CFrame']['Rotation']
            end
            if (child_19 and (not child_19:FindFirstChild("Closets") or not child_19:FindFirstChild("Closets"):FindFirstChild("Closet")) and child_20) then
                for k_62, v_62 in pairs(child_20:GetDescendants()) do
                    if string.find(v_62.Name, "Closet") then
                        HumanoidRootPart['Position'] = v_62:GetPivot()['Position']
                    end
                end
            end
        end)
    end
    CreateSectionTitle("Players", UI["SCF"], 9)
    local instance_30 = CreateButton("Teleport to the closest player", UI["SCF"], 10, 150)
    local instance_31 = CreateButton("Teleport to a random player", UI["SCF"], 11, 150)
    
    -- ===== AUTO SPIRIT BOX - FULL FUNCTIONS FROM DEMO.LUA =====
    function CheckInventory(ItemName)
    	local Found = false
    	local InvSlotNum = nil
    	for _, obj in ipairs(LocalPlayer.PlayerGui.Hotbar.Slots:GetChildren()) do
    		if obj:IsA("Frame") and string.find(string.lower(obj.Name), "invslot") then
    			if obj.ItemName.Text == ItemName then
    				Found = true
    				local str = obj.Name
    				local num = tonumber(str:match("%d+"))
    				InvSlotNum = num
    			end
    		end
    	end
    	return Found, InvSlotNum
    end
    
    function FindItem(ItemName)
    	local Found = false
    	local Model = nil
    	local ItemFolder = workspace.Items
    	for _, v in pairs(ItemFolder:GetChildren()) do
    		if v:IsA("Model") and v:GetAttribute("ItemName") then
    			if v:GetAttribute("ItemName") == ItemName then
    				Found = true
    				Model = v
    			end
    		end
    	end
    	return Found, Model
    end
    
    function ActiveItem()
    	local ItemModel = nil
    	local Chara = LocalPlayer.Character
    	if Chara then
    		for _, v in pairs(Chara:GetChildren()) do
    			if v:IsA("Model") or tonumber(v.Name) then
    				ItemModel = v
    				if v:GetAttribute("Enabled") ~= true then
    					local Handle = v:FindFirstChild("Handle")
    					if Handle then
    						game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ToggleItemState"):FireServer(ItemModel)
    						break
    					end
    				end
    			end
    		end
    	end
    	return true, ItemModel
    end
    
    function EquipItem(SlotNum)
    	game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RequestItemEquip"):FireServer("InvSlot" .. tostring(SlotNum))
    	return true
    end
    
    function PickupItem(Model)
    	game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("RequestItemPickup"):FireServer(Model)
    	return true
    end
    
    function FireSpiritBox()
    	local args = {
    		"Are you far away?",
    		"Are you near?",
    		"Where are you?",
    		"What do you want?",
    		"When did you cross over?",
    		"Are you in the room with me?",
    		"Do you want us to leave?",
    		"When did you pass away?",
    		"What is your goal?",
    		"Why are you here?",
    		"How long ago did you die?",
    		"Is there a ghost here?"
    	}
    	game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("AskSpiritBoxFromUI"):FireServer(args[math.random(1, #args)])
    end
    
    local DelaySBTick = tick()
    
    function UseSpiritBox()
    	local ghostModel = workspace:FindFirstChild("Ghost")
    	if not ghostModel then return end
    	local Chara = LocalPlayer.Character
    	
    	if Chara and autoSpiritActive and ghostModel:GetAttribute("Hunting") ~= true then
    		Chara:PivotTo(ghostModel:GetPivot() * CFrame.new(0, 0, 10))
    	else
    		if Chara and autoSpiritActive then
    			TpOutside()
    		end
    	end
    
    	if tick() - DelaySBTick > 0.5 and autoSpiritActive and ghostModel:GetAttribute("Hunting") ~= true then
    		DelaySBTick = tick()
    		local Found, InvSlotNum = CheckInventory("Spirit Box")
    		if not CheckInventory("Spirit Box") then
    			local Found, Model = FindItem("Spirit Box")
    			if Found and Model then
    				PickupItem(Model)
    				task.wait(0.35)
    				ActiveItem()
    				task.wait(0.5)
    				local Found, InvSlotNum = CheckInventory("Spirit Box")
    				if Found then
    					EquipItem(InvSlotNum)
    					task.wait(0.5)
    					FireSpiritBox()
    				end
    			end
    		else
    			EquipItem(InvSlotNum)
    			task.wait(0.35)
    			ActiveItem()
    			task.wait(0.35)
    			FireSpiritBox()
    		end
    	end
    end
    -- ========================================================
    
    -- Auto Spirit Box - spam questions khi đã cầm và bật
    local autoSpiritActive = false
    local instance_auto_spirit = CreateButton("Auto Spirit Box", UI["SCF"], 10.5, 150)
    instance_auto_spirit['Activated']:Connect(function()
        autoSpiritActive = not autoSpiritActive
        if autoSpiritActive then
            CreateKeybind("Auto Spirit Box activated", 2)
            task.spawn(function()
                while autoSpiritActive do
                    UseSpiritBox()  -- ✅ CALL FULL DEMO FUNCTION
                    task.wait(0.3)
                end
                CreateKeybind("Auto Spirit Box deactivated", 2)
            end)
        else
            CreateKeybind("Auto Spirit Box deactivated", 2)
        end
    end)
    CreateSectionTitle("Ghost", UI["SCF"], 12)
    local instance_32 = CreateButton("Teleport to the ghost", UI["SCF"], 13, 150)
    local instance_33 = CreateButton("Teleport to the ghost room", UI["SCF"], 14, 150)
    instance_32['Activated']:Connect(function()
        if (Workspace and Ghost) then
            if Workspace['Ghost']:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart['CFrame'] = Workspace['Ghost']['HumanoidRootPart']['CFrame']
            end
        end
    end)
    instance_33['Activated']:Connect(function()
        if (Workspace and Ghost) then
            local value_33 = Workspace['Ghost']:GetAttribute("FavoriteRoom")
            if value_33 then
                if value_21 then
                    local child_18 = value_21:FindFirstChild(Workspace['Ghost']:GetAttribute("FavoriteRoom"))
                    if child_18 then
                        if (child_18:FindFirstChild("BoundingBox") and child_18['BoundingBox']:IsA("BasePart")) then
                            HumanoidRootPart['CFrame'] = child_18['BoundingBox']['CFrame']
                        elseif (child_18:FindFirstChild("BoundingBox") and child_18['BoundingBox']:IsA("Folder")) then
                            HumanoidRootPart['CFrame'] = child_18['BoundingBox']['Part']['CFrame']
                        end
                    end
                end
            end
        end
    end)
    local base_camp_button = CreateButton("Teleport To Base Camp", UI["SCF"], 15, 150)
    base_camp_button['Activated']:Connect(function()
        local base_camp = value_21:FindFirstChild("Base Camp")
        if base_camp then
            if (base_camp:FindFirstChild("BoundingBox") and base_camp['BoundingBox']:IsA("BasePart")) then
                HumanoidRootPart['Position'] = base_camp['BoundingBox']['Position']
            elseif (base_camp:FindFirstChild("BoundingBox") and base_camp['BoundingBox']:IsA("Folder")) then
                local children_2 = base_camp['BoundingBox']:GetChildren()
                local value_30 = children_2[math.random(1, #children_2)]
                HumanoidRootPart['Position'] = value_30['Position']
            end
        end
    end)
    instance_30['Activated']:Connect(function()
        if (#Players:GetPlayers() <= 1) then
            CreateKeybind("You are playing alone.")
            return
        end
        for k_63, v_63 in pairs(Workspace:GetChildren()) do
            if (v_63:FindFirstChild("Humanoid") and v_63:FindFirstChild("HumanoidRootPart")) then
                if ((v_63['Name'] ~= "Ghost") and (v_63['Name'] ~= LocalPlayer['Name'])) then
                    HumanoidRootPart['CFrame'] = v_63['HumanoidRootPart']['CFrame']
                    break
                end
            end
        end
    end)
    instance_31['Activated']:Connect(function()
        if (#Players:GetPlayers() <= 1) then
            CreateKeybind("You are playing alone.")
            return
        end
        local tbl_9 = {}
        for k_64, v_64 in pairs(workspace:GetChildren()) do
            if (v_64:FindFirstChild("Humanoid") and v_64:FindFirstChild("HumanoidRootPart")) then
                if ((v_64['Name'] ~= "Ghost") and (v_64['Name'] ~= LocalPlayer['Name'])) then
                    table.insert(tbl_9, v_64)
                end
            end
        end
        local value_34 = tbl_9[math.random(1, #tbl_9)]
        HumanoidRootPart['CFrame'] = value_34['HumanoidRootPart']['CFrame']
    end)
    for k_72, v_72 in pairs(UI["2"]:GetDescendants()) do
        if (v_72['Name'] == "Divider") then
            v_72['Size'] = UDim2.new(v_72['Size']['X'].Scale, v_72['Size']['X'].Offset, v_72['Size']['Y'].Scale, 1)
        end
    end
    task.spawn(function()
        local value_35 = game:GetService("RunService")
        local value_36 = game:GetService("UserInputService")
        local flag_2 = false
        local vec2_2 = Vector2.new(0, 0)
        local value_37 = UI["2"]:FindFirstChildOfClass("UIDragDetector")
        child_21['ChildAdded']:Connect(function()
            if child_21 then
                if UI["MapView"]:FindFirstChild("Items") then
                    UI["MapView"]['Items']:Destroy()
                end
                local clone_3 = child_21:Clone()
                clone_3['Parent'] = UI["MapView"]
            end
        end)
        child_21['ChildRemoved']:Connect(function()
            if child_21 then
                if UI["MapView"]:FindFirstChild("Items") then
                    UI["MapView"]['Items']:Destroy()
                end
                local clone_4 = child_21:Clone()
                clone_4['Parent'] = UI["MapView"]
            end
        end)
        local flag_2 = false
        local vec2_2 = Vector2.new(0, 0)
        value_36['InputChanged']:Connect(function(input_5)
            if (input_5['UserInputType'] ~= Enum['UserInputType']['MouseWheel']) then
                return
            end
            local mousePos_2 = value_36:GetMouseLocation()
            local value_38 = LocalPlayer['PlayerGui']:GetGuiObjectsAtPosition(mousePos_2.X, mousePos_2.Y)
            for k_65, v_65 in ipairs(value_38) do
                if (v_65 == UI["MapView"]) then
                    local pos_6 = ((input_5['Position']['Z'] > 0) and -5) or 5
                    UI["Camera"]['CFrame'] = UI["Camera"]['CFrame'] - (UI["Camera"]['CFrame']['LookVector'] * pos_6)
                    break
                end
            end
        end)
        UI["MapView"]['InputBegan']:Connect(function(input_6)
            if (input_6['UserInputType'] == Enum['UserInputType']['MouseButton1']) then
                flag_2 = true
                UI["FrameDragDetector"]['Enabled'] = false
                vec2_2 = value_36:GetMouseLocation()
            end
        end)
        UI["MapView"]['InputEnded']:Connect(function(input_7)
            if (input_7['UserInputType'] == Enum['UserInputType']['MouseButton1']) then
                flag_2 = false
                UI["FrameDragDetector"]['Enabled'] = true
            end
        end)
        UI["MapView"]['InputBegan']:Connect(function(input_8)
            if (input_8['UserInputType'] == Enum['UserInputType']['MouseButton2']) then
                local absPos_2 = UI["MapView"]['AbsolutePosition']
                local absSize_2 = UI["MapView"]['AbsoluteSize']
                local mousePos_3 = value_36:GetMouseLocation()
                local value_39 = mousePos_3['Y'] - 36
                local value_40 = mousePos_3['X'] - absPos_2['X']
                local value_41 = value_39 - absPos_2['Y']
                if ((value_40 >= 0) and (value_40 <= absSize_2['X']) and (value_41 >= 0) and (value_41 <= absSize_2['Y'])) then
                    local value_42 = UI["MapView"]['CurrentCamera']
                    if value_42 then
                        local value_43 = value_42['ViewportSize']
                        local value_44 = (value_40 / absSize_2['X']) * value_43['X']
                        local value_45 = (value_41 / absSize_2['Y']) * value_43['Y']
                        local value_46 = value_42:ViewportPointToRay(value_44, value_45)
                        local hit_2 = workspace:Raycast(value_46.Origin, value_46['Direction'] * 10000)
                        if hit_2 then
                            HumanoidRootPart['CFrame'] = CFrame.new(hit_2.Position) * HumanoidRootPart['CFrame']['Rotation']
                        end
                    end
                end
            end
        end)
        game:GetService("RunService")['RenderStepped']:Connect(function()
            if not flag_2 then
                return
            end
            local mousePos_4 = value_36:GetMouseLocation()
            local value_47 = mousePos_4 - vec2_2
            if (value_47['Magnitude'] > 0) then
                local num_2 = 0.1
                local pos_7 = UI["Camera"]['CFrame']['Position']
                local value_48 = pos_7 + Vector3.new(value_47['Y'] * num_2, 0, -value_47['X'] * num_2)
                UI["Camera"]['CFrame'] = CFrame.new(value_48) * (UI["Camera"]['CFrame'] - pos_7)
                vec2_2 = mousePos_4
            end
        end)
    end)
end
