local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()
WindUI.TransparencyValue = 0.2

local HttpService = cloneref(game:GetService("HttpService"))
local isfunctionhooked = clonefunction(isfunctionhooked)

if isfunctionhooked(game.HttpGet) or isfunctionhooked(getnamecallmethod) or isfunctionhooked(request) then
    return
end

local function verifyKey(k)
    local ok, res = pcall(function()
        return request({
            Url = "https://ouo.lat/api/verify.php",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({key = k, time = os.time()})
        })
    end)
    
    if not ok then return false end
    
    if res.Body ~= "True" then
        return false
    end
    
    local ok2, res2 = pcall(function()
        return game:HttpGet("https://www.wtb.lat/keysystem/check-key?key="..k.."&user="..game.Players.LocalPlayer.Name)
    end)
    
    return ok2 and res2 == "success"
end

local key = ""
pcall(function() key = readfile("DyzhKey.json") end)
if key ~= "" then
    if verifyKey(key) then
        print('验证完成')
    else
        return
    end
end

local Data = {
    ["自动收集钱"] = false,
    ["自动收集餐具"] = false,
    ["自动烹饪"] = false,
    ["自动给食物"] = false,
    ["自动拿订单"] = false,
    ["自动接订单"] = false,
    ["自动选桌子"] = false,
    ["自动拿零钱"] = false,
    ["自动领奖励"] = false,
}

local Players = cloneref(game:GetService("Players"))
local LocalPlayer = cloneref(Players.LocalPlayer)
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local cn = string.find(LocalPlayer.LocaleId, "zh") ~= nil
local T = {
    Title = cn and "主要功能" or "Restaurant Tycoon 3",
    MainSection = cn and "我的大亨" or "My Tycoon",
    FriendSection = cn and "好友大亨" or "Friend Tycoon",
    AutoCollectBill = cn and "自动收集账单" or "Auto Collect Bill",
    AutoCollectDishes = cn and "自动收集餐具" or "Auto Collect Dishes",
    AutoCook = cn and "自动烹饪" or "Auto Cook",
    AutoGiveFood = cn and "自动送餐" or "Auto Give Food",
    AutoDoOrder = cn and "自动处理订单" or "Auto Do Order",
    AutoTakeOrder = cn and "自动接单" or "Auto Take Order",
    AutoSendTable = cn and "自动安排座位" or "Auto Send Table",
    AutoTips = cn and "自动收取小费" or "Auto Tips",
    Author = cn and "作者:琼玖"
}

pcall(function()
    hookfunction(require(ReplicatedStorage:FindFirstChild("Source"):FindFirstChild("Utility"):FindFirstChild("NPC"):FindFirstChild("PathUtility")).GetMovementTime, function(...)
        return 0.1
    end)
end)

function GetFriend()
    for _, v in next, Players:GetPlayers() do
        if LocalPlayer:IsFriendsWith(v.UserId) then
            return v
        end
    end
    return nil
end

local rainbowBorderAnimation
local currentBorderColorScheme = "糖果颜色"
local currentFontColorScheme = "彩虹颜色"
local borderInitialized = false
local animationSpeed = 2
local borderEnabled = false
local fontColorEnabled = false
local uiScale = 1
local blurEnabled = false
local soundEnabled = true

local FONT_STYLES = {
    "SourceSansBold","SourceSansItalic","SourceSansLight","SourceSans",
    "GothamSSm","GothamSSm-Bold","GothamSSm-Medium","GothamSSm-Light",
    "GothamSSm-Black","GothamSSm-Book","GothamSSm-XLight","GothamSSm-Thin",
    "GothamSSm-Ultra","GothamSSm-SemiBold","GothamSSm-ExtraLight","GothamSSm-Heavy",
    "GothamSSm-ExtraBold","GothamSSm-Regular","Gotham","GothamBold",
    "GothamMedium","GothamBlack","GothamLight","Arial","ArialBold",
    "Code","CodeLight","CodeBold","Highway","HighwayBold","HighwayLight",
    "SciFi","SciFiBold","SciFiItalic","Cartoon","CartoonBold","Handwritten"
}

local FONT_DESCRIPTIONS = {
    ["SourceSansBold"] = "标准粗体",["SourceSansItalic"] = "斜体",["SourceSansLight"] = "细体",
    ["SourceSans"] = "标准体",["GothamSSm"] = "哥特标准",["GothamSSm-Bold"] = "哥特粗体",
    ["GothamSSm-Medium"] = "哥特中等",["GothamSSm-Light"] = "哥特细体",["GothamSSm-Black"] = "哥特黑体",
    ["GothamSSm-Book"] = "哥特书本体",["GothamSSm-XLight"] = "哥特超细体",["GothamSSm-Thin"] = "哥特极细体",
    ["GothamSSm-Ultra"] = "哥特超黑体",["GothamSSm-SemiBold"] = "哥特半粗体",["GothamSSm-ExtraLight"] = "哥特特细体",
    ["GothamSSm-Heavy"] = "哥特粗重体",["GothamSSm-ExtraBold"] = "哥特特粗体",["GothamSSm-Regular"] = "哥特常规体",
    ["Gotham"] = "经典哥特体",["GothamBold"] = "经典哥特粗体",["GothamMedium"] = "经典哥特中等",
    ["GothamBlack"] = "经典哥特黑体",["GothamLight"] = "经典哥特细体",["Arial"] = "标准Arial体",
    ["ArialBold"] = "Arial粗体",["Code"] = "代码字体",["CodeLight"] = "代码细体",
    ["CodeBold"] = "代码粗体",["Highway"] = "高速公路体",["HighwayBold"] = "高速公路粗体",
    ["HighwayLight"] = "高速公路细体",["SciFi"] = "科幻字体",["SciFiBold"] = "科幻粗体",
    ["SciFiItalic"] = "科幻斜体",["Cartoon"] = "卡通字体",["CartoonBold"] = "卡通粗体",
    ["Handwritten"] = "手写体"
}

local currentFontStyle = "SourceSansBold"

local COLOR_SCHEMES = {
    ["彩虹颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.16, Color3.fromHex("FFA500")),ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),ColorSequenceKeypoint.new(1, Color3.fromHex("EE82EE"))}),"palette"},
    ["黑红颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))}),"alert-triangle"},
    ["蓝白颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFFFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFFFFF"))}),"droplet"},
    ["紫金颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FFD700")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700"))}),"crown"},
    ["蓝黑颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("0000FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("000000"))}),"moon"},
    ["绿紫颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("00FF00")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("800080")),ColorSequenceKeypoint.new(1, Color3.fromHex("00FF00"))}),"zap"},
    ["粉蓝颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00BFFF")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF69B4"))}),"heart"},
    ["橙青颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("00CED1")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF4500"))}),"sun"},
    ["红金颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFD700")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF0000"))}),"award"},
    ["银蓝颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("4682B4")),ColorSequenceKeypoint.new(1, Color3.fromHex("C0C0C0"))}),"star"},
    ["霓虹颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(0.25, Color3.fromHex("00FFFF")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FFFF00")),ColorSequenceKeypoint.new(0.75, Color3.fromHex("FF00FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("00FFFF"))}),"sparkles"},
    ["森林颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("228B22")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("32CD32")),ColorSequenceKeypoint.new(1, Color3.fromHex("228B22"))}),"tree"},
    ["火焰颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF0000")),ColorSequenceKeypoint.new(1, Color3.fromHex("FF8C00"))}),"flame"},
    ["海洋颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("000080")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("1E90FF")),ColorSequenceKeypoint.new(1, Color3.fromHex("00BFFF"))}),"waves"},
    ["日落颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF4500")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF8C00")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFD700"))}),"sunset"},
    ["银河颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("4B0082")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("8A2BE2")),ColorSequenceKeypoint.new(1, Color3.fromHex("9370DB"))}),"galaxy"},
    ["糖果颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("FF69B4")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("FF1493")),ColorSequenceKeypoint.new(1, Color3.fromHex("FFB6C1"))}),"candy"},
    ["金属颜色"] = {ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromHex("C0C0C0")),ColorSequenceKeypoint.new(0.5, Color3.fromHex("A9A9A9")),ColorSequenceKeypoint.new(1, Color3.fromHex("696969"))}),"shield"}
}

local fontColorAnimations = {}

local function applyFontColorGradient(textElement, colorScheme)
    if not textElement or not textElement:IsA("TextLabel") and not textElement:IsA("TextButton") and not textElement:IsA("TextBox") then
        return
    end
    
    local existingGradient = textElement:FindFirstChild("FontColorGradient")
    if existingGradient then
        existingGradient:Destroy()
    end
    
    if fontColorAnimations[textElement] then
        fontColorAnimations[textElement]:Disconnect()
        fontColorAnimations[textElement] = nil
    end
    
    if not fontColorEnabled then
        textElement.TextColor3 = Color3.new(1, 1, 1)
        return
    end
    
    local schemeData = COLOR_SCHEMES[colorScheme or currentFontColorScheme]
    if not schemeData then return end
    
    local fontGradient = Instance.new("UIGradient")
    fontGradient.Name = "FontColorGradient"
    fontGradient.Color = schemeData[1]
    fontGradient.Rotation = 0
    fontGradient.Parent = textElement
    
    textElement.TextColor3 = Color3.new(1, 1, 1)
    
    local animation
    animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not textElement or textElement.Parent == nil then
            animation:Disconnect()
            fontColorAnimations[textElement] = nil
            return
        end
        
        if not fontGradient or fontGradient.Parent == nil then
            animation:Disconnect()
            fontColorAnimations[textElement] = nil
            return
        end
        
        local time = tick()
        fontGradient.Rotation = (time * animationSpeed * 30) % 360
    end)
    
    fontColorAnimations[textElement] = animation
end

local function applyFontStyleToWindow(fontStyle)
    if not Window or not Window.UIElements then 
        wait(0.5)
        if not Window or not Window.UIElements then
            return false
        end
    end
    
    local successCount = 0
    local totalCount = 0
    
    local function processElement(element)
        for _, child in ipairs(element:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                totalCount = totalCount + 1
                pcall(function()
                    child.Font = Enum.Font[fontStyle]
                    successCount = successCount + 1
                end)
            end
        end
    end
    
    processElement(Window.UIElements.Main)
    
    return successCount, totalCount
end

local function applyFontColorsToWindow(colorScheme)
    if not Window or not Window.UIElements then return end
    
    local function processElement(element)
        for _, child in ipairs(element:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                applyFontColorGradient(child, colorScheme)
            end
        end
    end
    
    processElement(Window.UIElements.Main)
end

local function createRainbowBorder(window, colorScheme, speed)
    if not window or not window.UIElements then
        wait(1)
        if not window or not window.UIElements then
            return nil, nil
        end
    end
    
    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil, nil
    end
    
    local existingStroke = mainFrame:FindFirstChild("RainbowStroke")
    if existingStroke then
        local glowEffect = existingStroke:FindFirstChild("GlowEffect")
        if glowEffect then
            local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
            if schemeData then
                glowEffect.Color = schemeData[1]
            end
        end
        return existingStroke, rainbowBorderAnimation
    end
    
    if not mainFrame:FindFirstChildOfClass("UICorner") then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = mainFrame
    end
    
    local rainbowStroke = Instance.new("UIStroke")
    rainbowStroke.Name = "RainbowStroke"
    rainbowStroke.Thickness = 1.5
    rainbowStroke.Color = Color3.new(1, 1, 1)
    rainbowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    rainbowStroke.LineJoinMode = Enum.LineJoinMode.Round
    rainbowStroke.Enabled = borderEnabled
    rainbowStroke.Parent = mainFrame
    
    local glowEffect = Instance.new("UIGradient")
    glowEffect.Name = "GlowEffect"
    
    local schemeData = COLOR_SCHEMES[colorScheme or currentBorderColorScheme]
    if schemeData then
        glowEffect.Color = schemeData[1]
    else
        glowEffect.Color = COLOR_SCHEMES["彩虹颜色"][1]
    end
    
    glowEffect.Rotation = 0
    glowEffect.Parent = rainbowStroke
    
    return rainbowStroke, nil
end

local function startBorderAnimation(window, speed)
    if not window or not window.UIElements then
        return nil
    end
    
    local mainFrame = window.UIElements.Main
    if not mainFrame then
        return nil
    end
    
    local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
    if not rainbowStroke or not rainbowStroke.Enabled then
        return nil
    end
    
    local glowEffect = rainbowStroke:FindFirstChild("GlowEffect")
    if not glowEffect then
        return nil
    end
    
    if rainbowBorderAnimation then
        rainbowBorderAnimation:Disconnect()
        rainbowBorderAnimation = nil
    end
    
    local animation
    animation = game:GetService("RunService").Heartbeat:Connect(function()
        if not rainbowStroke or rainbowStroke.Parent == nil or not rainbowStroke.Enabled then
            animation:Disconnect()
            return
        end
        
        local time = tick()
        glowEffect.Rotation = (time * speed * 60) % 360
    end)
    
    rainbowBorderAnimation = animation
    return animation
end

local function initializeRainbowBorder(scheme, speed)
    speed = speed or animationSpeed
    
    local rainbowStroke, _ = createRainbowBorder(Window, scheme, speed)
    if rainbowStroke then
        if borderEnabled then
            startBorderAnimation(Window, speed)
        end
        borderInitialized = true
        return true
    end
    return false
end

local function playSound()
    if soundEnabled then
        pcall(function()
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://9047002353"
            sound.Volume = 0.3
            sound.Parent = game:GetService("SoundService")
            sound:Play()
            game:GetService("Debris"):AddItem(sound, 2)
        end)
    end
end

local function applyBlurEffect(enabled)
    if enabled then
        pcall(function()
            local blur = Instance.new("BlurEffect")
            blur.Size = 8
            blur.Name = "UIXH HUBBlur"
            blur.Parent = game:GetService("Lighting")
        end)
    else
        pcall(function()
            local existingBlur = game:GetService("Lighting"):FindFirstChild("UIXH HUBBlur")
            if existingBlur then
                existingBlur:Destroy()
            end
        end)
    end
end

local function applyUIScale(scale)
    if Window and Window.UIElements and Window.UIElements.Main then
        local mainFrame = Window.UIElements.Main
        mainFrame.Size = UDim2.new(0, 600 * scale, 0, 400 * scale)
    end
end

function createUI()
    local Window = WindUI:CreateWindow({
        Title = '餐厅大亨3',
        Icon = "crown",
        IconThemed = true,
        Author = "琼玖",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(375, 278),
        Transparent = true,
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
        BackgroundImageTransparency = 0.45,
        User = {
            Enabled = true,
            Callback = function()
                WindUI:Notify({
                    Title = "点击了自己",
                    Content = "没什么", 
                    Duration = 1,
                    Icon = "4483362748"
                })
            end,
            Anonymous = false
        },
        SideBarWidth = 250,
        Search = {
            Enabled = true,
            Placeholder = "搜索...",
            Callback = function(searchText)
                print("搜索内容:", searchText)
            end
        },
        SidePanel = {
            Enabled = true,
            Content = {
                {
                    Type = "Button", 
                    Text = "",
                    Style = "Subtle", 
                    Size = UDim2.new(1, -20, 0, 30),
                    Callback = function()
                    end
                }
            }
        }
    })

    Window:EditOpenButton({
        Title = "Paid user",
        Icon = "crown",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })

    local windowOpen = true

    Window:OnClose(function()
        windowOpen = false
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
    end)

    local originalOpenFunction = Window.Open
    Window.Open = function(...)
        windowOpen = true
        local result = originalOpenFunction(...)
        
        if borderInitialized and borderEnabled and not rainbowBorderAnimation then
            wait(0.1)
            startBorderAnimation(Window, animationSpeed)
        end
        
        return result
    end

    local Settings = Window:Tab({Title = "UI设置", Icon = "palette"})
    Settings:Paragraph({
        Title = "UI设置",
        Desc = "绝妙二改WindUI",
        Image = "settings",
        ImageSize = 20,
        Color = "White"
    })

    Settings:Toggle({
        Title = "启用边框",
        Value = false,
        Callback = function(value)
            borderEnabled = value
            local mainFrame = Window.UIElements and Window.UIElements.Main
            if mainFrame then
                local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
                if rainbowStroke then
                    rainbowStroke.Enabled = value
                    if value and windowOpen and not rainbowBorderAnimation then
                        startBorderAnimation(Window, animationSpeed)
                    elseif not value and rainbowBorderAnimation then
                        rainbowBorderAnimation:Disconnect()
                        rainbowBorderAnimation = nil
                    end
                    
                    WindUI:Notify({
                        Title = "边框",
                        Content = value and "已启用" or "已禁用",
                        Duration = 2,
                        Icon = value and "eye" or "eye-off"
                    })
                end
            end
        end
    })

    Settings:Toggle({
        Title = "启用字体颜色",
        Value = false,
        Callback = function(value)
            fontColorEnabled = value
            applyFontColorsToWindow(currentFontColorScheme)
            
            WindUI:Notify({
                Title = "字体颜色",
                Content = value and "已启用" or "已禁用",
                Duration = 2,
                Icon = value and "type" or "type"
            })
        end
    })

    Settings:Toggle({
        Title = "启用音效",
        Value = true,
        Callback = function(value)
            soundEnabled = value
            WindUI:Notify({
                Title = "音效",
                Content = value and "已启用" or "已禁用",
                Duration = 2,
                Icon = value and "volume-2" or "volume-x"
            })
        end
    })

    Settings:Toggle({
        Title = "启用背景模糊",
        Value = false,
        Callback = function(value)
            blurEnabled = value
            applyBlurEffect(value)
            WindUI:Notify({
                Title = "背景模糊",
                Content = value and "已启用" or "已禁用",
                Duration = 2,
                Icon = value and "cloud-rain" or "cloud"
            })
        end
    })

    local colorSchemeNames = {}
    for name, _ in pairs(COLOR_SCHEMES) do
        table.insert(colorSchemeNames, name)
    end
    table.sort(colorSchemeNames)

    Settings:Dropdown({
        Title = "边框颜色方案",
        Desc = "选择喜欢的颜色组合",
        Values = colorSchemeNames,
        Value = "糖果颜色",
        Callback = function(value)
            currentBorderColorScheme = value
            local success = initializeRainbowBorder(value, animationSpeed)
            playSound()
        end
    })

    Settings:Dropdown({
        Title = "字体颜色方案",
        Desc = "选择文字颜色组合",
        Values = colorSchemeNames,
        Value = "彩虹颜色",
        Callback = function(value)
            currentFontColorScheme = value
            applyFontColorsToWindow(value)
            playSound()
        end
    })

    local fontOptions = {}
    for _, fontName in ipairs(FONT_STYLES) do
        local description = FONT_DESCRIPTIONS[fontName] or fontName
        table.insert(fontOptions, {text = description, value = fontName})
    end

    table.sort(fontOptions, function(a, b)
        return a.text < b.text
    end)

    local fontValues = {}
    local fontValueToName = {}
    for _, option in ipairs(fontOptions) do
        table.insert(fontValues, option.text)
        fontValueToName[option.text] = option.value
    end

    Settings:Dropdown({
        Title = "字体样式",
        Desc = "选择文字字体样式 (" .. #FONT_STYLES .. " 种可用)",
        Values = fontValues,
        Value = "标准粗体",
        Callback = function(value)
            local fontName = fontValueToName[value]
            if fontName then
                currentFontStyle = fontName
                local successCount, totalCount = applyFontStyleToWindow(fontName)
                playSound()
            end
        end
    })

    Settings:Slider({
        Title = "边框转动速度",
        Desc = "调整边框旋转的快慢",
        Value = { 
            Min = 1,
            Max = 10,
            Default = 5,
        },
        Callback = function(value)
            animationSpeed = value
            if rainbowBorderAnimation then
                rainbowBorderAnimation:Disconnect()
                rainbowBorderAnimation = nil
            end
            if borderEnabled then
                startBorderAnimation(Window, animationSpeed)
            end
            
            applyFontColorsToWindow(currentFontColorScheme)
            playSound()
        end
    })

    Settings:Slider({
        Title = "UI整体缩放",
        Desc = "调整UI大小比例",
        Value = { 
            Min = 0.5,
            Max = 1.5,
            Default = 1,
        },
        Step = 0.1,
        Callback = function(value)
            uiScale = value
            applyUIScale(value)
            playSound()
        end
    })

    Settings:Divider()

    Settings:Slider({
        Title = "UI透明度",
        Desc = "调整整个UI的透明度",
        Value = { 
            Min = 0,
            Max = 1,
            Default = 0.2,
        },
        Step = 0.1,
        Callback = function(value)
            Window:ToggleTransparency(tonumber(value) > 0)
            WindUI.TransparencyValue = tonumber(value)
            playSound()
        end
    })

    Settings:Slider({
        Title = "调整UI宽度",
        Desc = "调整窗口的宽度",
        Value = { 
            Min = 500,
            Max = 800,
            Default = 600,
        },
        Callback = function(value)
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Size = UDim2.fromOffset(value, 400)
            end
            playSound()
        end
    })

    Settings:Slider({
        Title = "调整UI高度",
        Desc = "调整窗口的高度",
        Value = { 
            Min = 300,
            Max = 600,
            Default = 400,
        },
        Callback = function(value)
            if Window.UIElements and Window.UIElements.Main then
                local currentWidth = Window.UIElements.Main.Size.X.Offset
                Window.UIElements.Main.Size = UDim2.fromOffset(currentWidth, value)
            end
            playSound()
        end
    })

    Settings:Slider({
        Title = "边框粗细",
        Desc = "调整边框的粗细",
        Value = { 
            Min = 1,
            Max = 5,
            Default = 1.5,
        },
        Step = 0.5,
        Callback = function(value)
            local mainFrame = Window.UIElements and Window.UIElements.Main
            if mainFrame then
                local rainbowStroke = mainFrame:FindFirstChild("RainbowStroke")
                if rainbowStroke then
                    rainbowStroke.Thickness = value
                end
            end
            playSound()
        end
    })

    Settings:Slider({
        Title = "圆角大小",
        Desc = "调整UI圆角的大小",
        Value = { 
            Min = 0,
            Max = 20,
            Default = 16,
        },
        Callback = function(value)
            local mainFrame = Window.UIElements and Window.UIElements.Main
            if mainFrame then
                local corner = mainFrame:FindFirstChildOfClass("UICorner")
                if not corner then
                    corner = Instance.new("UICorner")
                    corner.Parent = mainFrame
                end
                corner.CornerRadius = UDim.new(0, value)
            end
            playSound()
        end
    })

    Settings:Button({
        Title = "恢复UI到原位",
        Icon = "rotate-ccw",
        Callback = function()
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Position = UDim2.new(0.5, 0, 0.5, 0)
                playSound()
            end
        end
    })

    Settings:Button({
        Title = "重置UI大小",
        Icon = "maximize-2",
        Callback = function()
            if Window.UIElements and Window.UIElements.Main then
                Window.UIElements.Main.Size = UDim2.fromOffset(600, 400)
                playSound()
            end
        end
    })

    Settings:Button({
        Title = "随机字体",
        Icon = "shuffle",
        Callback = function()
            local randomFont = FONT_STYLES[math.random(1, #FONT_STYLES)]
            currentFontStyle = randomFont
            applyFontStyleToWindow(randomFont)
            playSound()
        end
    })

    Settings:Button({
        Title = "随机颜色",
        Icon = "palette",
        Callback = function()
            local randomColor = colorSchemeNames[math.random(1, #colorSchemeNames)]
            currentBorderColorScheme = randomColor
            initializeRainbowBorder(randomColor, animationSpeed)
            playSound()
        end
    })

    Settings:Divider()

    Settings:Button({
        Title = "刷新字体颜色",
        Icon = "refresh-cw",
        Callback = function()
            applyFontColorsToWindow(currentFontColorScheme)
            playSound()
        end
    })

    Settings:Button({
        Title = "刷新字体样式",
        Icon = "refresh-cw",
        Callback = function()
            local successCount, totalCount = applyFontStyleToWindow(currentFontStyle)
            playSound()
        end
    })

    Settings:Button({
        Title = "测试所有字体",
        Icon = "check-circle",
        Callback = function()
            local workingFonts = {}
            local totalFonts = #FONT_STYLES
            
            for i, fontName in ipairs(FONT_STYLES) do
                local success = pcall(function()
                    local test = Enum.Font[fontName]
                end)
                
                if success then
                    table.insert(workingFonts, fontName)
                end
            end
            playSound()
        end
    })

    Settings:Button({
        Title = "导出设置",
        Icon = "download",
        Callback = function()
            local settings = {
                font = currentFontStyle,
                borderColor = currentBorderColorScheme,
                fontSize = currentFontColorScheme,
                speed = animationSpeed,
                scale = uiScale
            }
            setclipboard("设置: " .. game:GetService("HttpService"):JSONEncode(settings))
            playSound()
        end
    })

    local RestaurantTab = Window:Tab({Title = T.Title, Icon = "crown"})
    local MainSection = RestaurantTab:Section({Title = T.MainSection, Opened = true})
    local FriendSection = RestaurantTab:Section({Title = T.FriendSection, Opened = true})

    MainSection:Toggle({
        Title = T.AutoCollectBill,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动收集钱"] = state
            spawn(function()
                while Data["自动收集钱"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v.Player.Value == game.Players.LocalPlayer then
                                for _, a in pairs(v.Items.Surface:GetChildren()) do
                                    if a:FindFirstChild("Bill") then
                                        ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                            ["Tycoon"] = v,
                                            ["Name"] = "CollectBill",
                                            ["FurnitureModel"] = a
                                        })
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    MainSection:Toggle({
        Title = T.AutoCollectDishes,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动收集餐具"] = state
            spawn(function()
                while Data["自动收集餐具"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v.Player.Value == game.Players.LocalPlayer then
                                for _, a in pairs(v.Items.Surface:GetChildren()) do
                                    if a.Name:find("T") and a:FindFirstChild("Trash") then
                                        ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                            ["Tycoon"] = v,
                                            ["Name"] = "CollectDishes",
                                            ["FurnitureModel"] = a
                                        })
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    MainSection:Toggle({
        Title = T.AutoCook,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动烹饪"] = state
            spawn(function()
                while Data["自动烹饪"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v:FindFirstChild("Player") and v.Player.Value == game.Players.LocalPlayer then
                                for _, a in pairs(v.Items.Surface:GetDescendants()) do
                                    if a.Name:find("Oven") then
                                        ReplicatedStorage.Events.Cook.CookInputRequested:FireServer(
                                            "Interact",
                                            a.Parent,
                                            "Oven"
                                        )
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    MainSection:Toggle({
        Title = T.AutoGiveFood,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动给食物"] = state
            spawn(function()
                while Data["自动给食物"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v:FindFirstChild("Player") and v.Player.Value == game.Players.LocalPlayer then
                                if #v.Objects.Food:GetChildren() > 0 then
                                    for _, a in pairs(v.Objects.Food:GetChildren()) do
                                        if not a:GetAttribute("Taken") then
                                            ReplicatedStorage.Events.Restaurant.GrabFood:InvokeServer(a)
                                            for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
                                                if gui:IsA("ImageLabel") and gui.Parent and 
                                                   gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and
                                                   gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0) then
                                                   ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                                        Name = "Serve",
                                                        GroupId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name),
                                                        Tycoon = v,
                                                        FoodModel = a,
                                                        CustomerId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Name)
                                                    })
                                                    task.wait(0.1)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    MainSection:Toggle({
        Title = T.AutoDoOrder,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动拿订单"] = state
            spawn(function()
                while Data["自动拿订单"] do
                    pcall(function()
                        for _,v in next,workspace.Temp:GetChildren() do
                            if v.Name == "Part" and v:FindFirstChildOfClass("ProximityPrompt") then
                                fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    MainSection:Toggle({
        Title = T.AutoTakeOrder,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动接订单"] = state
            spawn(function()
                while Data["自动接订单"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v:FindFirstChild("Player") and v.Player.Value == game.Players.LocalPlayer then
                                for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
                                    if
                                        gui:IsA("ImageLabel") and gui.Parent and gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and
                                            gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0)
                                     then
                                        ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer(
                                            {
                                                Name = "TakeOrder",
                                                GroupId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name),
                                                Tycoon = v,
                                                CustomerId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Name)
                                            }
                                        )
                                        task.wait(0.1)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    MainSection:Toggle({
        Title = T.AutoSendTable,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动选桌子"] = state
            spawn(function()
                while Data["自动选桌子"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v.Player.Value == game.Players.LocalPlayer then
                                for _, a in pairs(v.Items.Surface:GetChildren()) do
                                    if a.Name:find("T") and not a:GetAttribute("InUse") then
                                        for _, gui in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
                                            if gui:IsA("ImageLabel") and gui.Parent and gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0) then
                                                ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                                    ["FurnitureModel"] = a,
                                                    ["Tycoon"] = v,
                                                    ["Name"] = "SendToTable",
                                                    ["GroupId"] = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name)
                                                })
                                                task.wait(0.1)
                                            end
                                        end
                                    end
                                end
                            end
                            task.wait(0.1)
                        end
                    end)
                    task.wait()
                end
            end)
        end
    })

    MainSection:Toggle({
        Title = T.AutoTips,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动拿零钱"] = state
            spawn(function()
                while Data["自动拿零钱"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v:FindFirstChild("Player") and v.Player.Value == game.Players.LocalPlayer then
                                ReplicatedStorage.Events.Restaurant.TipsCollected:FireServer(v)
                            end
                        end
                    end)
                    task.wait()
                end
            end)
        end
    })

    FriendSection:Toggle({
        Title = T.AutoCollectBill,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动收集钱"] = state
            spawn(function()
                while Data["自动收集钱"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v.Player.Value == GetFriend() then
                                for _, a in pairs(v.Items.Surface:GetChildren()) do
                                    if a:FindFirstChild("Bill") then
                                        ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                            ["Tycoon"] = v,
                                            ["Name"] = "CollectBill",
                                            ["FurnitureModel"] = a
                                        })
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    FriendSection:Toggle({
        Title = T.AutoCollectDishes,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动收集餐具"] = state
            spawn(function()
                while Data["自动收集餐具"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v.Player.Value == GetFriend() then
                                for _, a in pairs(v.Items.Surface:GetChildren()) do
                                    if a.Name:find("T") and a:FindFirstChild("Trash") then
                                        ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                            ["Tycoon"] = v,
                                            ["Name"] = "CollectDishes",
                                            ["FurnitureModel"] = a
                                        })
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    FriendSection:Toggle({
        Title = T.AutoCook,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动烹饪"] = state
            spawn(function()
                while Data["自动烹饪"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v:FindFirstChild("Player") and v.Player.Value == GetFriend() then
                                for _, a in pairs(v.Items.Surface:GetDescendants()) do
                                    if a.Name:find("Oven") then
                                        ReplicatedStorage.Events.Cook.CookInputRequested:FireServer(
                                            "Interact",
                                            a.Parent,
                                            "Oven"
                                        )
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    FriendSection:Toggle({
        Title = T.AutoGiveFood,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动给食物"] = state
            spawn(function()
                while Data["自动给食物"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v:FindFirstChild("Player") and v.Player.Value == GetFriend() then
                                if #v.Objects.Food:GetChildren() > 0 then
                                    for _, a in pairs(v.Objects.Food:GetChildren()) do
                                        if not a:GetAttribute("Taken") then
                                            ReplicatedStorage.Events.Restaurant.GrabFood:InvokeServer(a)
                                            for _, gui in pairs(GetFriend().PlayerGui:GetDescendants()) do
                                                if gui:IsA("ImageLabel") and gui.Parent and 
                                                   gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and
                                                   gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0) then
                                                   ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                                        Name = "Serve",
                                                        GroupId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name),
                                                        Tycoon = v,
                                                        FoodModel = a,
                                                        CustomerId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Name)
                                                    })
                                                    task.wait(0.1)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    FriendSection:Toggle({
        Title = T.AutoDoOrder,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动拿订单"] = state
            spawn(function()
                while Data["自动拿订单"] do
                    pcall(function()
                        for _,v in next,workspace.Temp:GetChildren() do
                            if v.Name == "Part" and v:FindFirstChildOfClass("ProximityPrompt") then
                                fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    FriendSection:Toggle({
        Title = T.AutoTakeOrder,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动接订单"] = state
            spawn(function()
                while Data["自动接订单"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v:FindFirstChild("Player") and v.Player.Value == GetFriend() then
                                for _, gui in pairs(GetFriend().PlayerGui:GetDescendants()) do
                                    if
                                        gui:IsA("ImageLabel") and gui.Parent and gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and
                                            gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0)
                                     then
                                        ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer(
                                            {
                                                Name = "TakeOrder",
                                                GroupId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name),
                                                Tycoon = v,
                                                CustomerId = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Name)
                                            }
                                        )
                                        task.wait(0.1)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    })

    FriendSection:Toggle({
        Title = T.AutoSendTable,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动选桌子"] = state
            spawn(function()
                while Data["自动选桌子"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v.Player.Value == GetFriend() then
                                for _, a in pairs(v.Items.Surface:GetChildren()) do
                                    if a.Name:find("T") and not a:GetAttribute("InUse") then
                                        for _, gui in pairs(GetFriend().PlayerGui:GetDescendants()) do
                                            if gui:IsA("ImageLabel") and gui.Parent and gui.Parent.Parent.Parent.Name == "CustomerSpeechUI" and gui.Parent.Parent.Size == UDim2.new(1, 0, 1, 0) then
                                                ReplicatedStorage.Events.Restaurant.TaskCompleted:FireServer({
                                                    ["FurnitureModel"] = a,
                                                    ["Tycoon"] = v,
                                                    ["Name"] = "SendToTable",
                                                    ["GroupId"] = tostring(gui.Parent.Parent.Parent.Adornee.Parent.Parent.Name)
                                                })
                                                task.wait(0.1)
                                            end
                                        end
                                    end
                                end
                            end
                            task.wait(0.1)
                        end
                    end)
                    task.wait()
                end
            end)
        end
    })

    FriendSection:Toggle({
        Title = T.AutoTips,
        Image = "swords",
        Value = false,
        Callback = function(state)
            Data["自动拿零钱"] = state
            spawn(function()
                while Data["自动拿零钱"] do
                    pcall(function()
                        for _, v in pairs(workspace.Tycoons:GetChildren()) do
                            if v:FindFirstChild("Player") and v.Player.Value == GetFriend() then
                                ReplicatedStorage.Events.Restaurant.TipsCollected:FireServer(v)
                            end
                        end
                    end)
                    task.wait()
                end
            end)
        end
    })

    Window:OnClose(function()
        windowOpen = false
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
        applyBlurEffect(false)
    end)

    Window:OnDestroy(function()
        windowOpen = false
        if rainbowBorderAnimation then
            rainbowBorderAnimation:Disconnect()
            rainbowBorderAnimation = nil
        end
        for _, animation in pairs(fontColorAnimations) do
            animation:Disconnect()
        end
        fontColorAnimations = {}
        applyBlurEffect(false)
    end)
end

createUI()