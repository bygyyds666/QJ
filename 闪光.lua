local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-闪光",
    Icon = "rbxassetid://1279310654146347060",
    IconTransparency = 0.5,
    IconThemed = true,
    Author = "作者:琼玖",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(400, 300),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function() print("clicked") end,
        Anonymous = false
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true,
    Background = "rbxassetid://111122821357551"
})  

Window:EditOpenButton({
    Title = "QJ脚本-闪光",
    Icon = "sword",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    Draggable = true
})

local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local tweenService = game:GetService("TweenService")
local localPlayer = players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

local infiniteJumpEnabled = false
local jumpConnection = nil

local originalGravity = workspace.Gravity
local gravityLoop = nil

local speedEnabled = false
local speedValue = 1
local speedConnection = nil

local espEnabled = false
local espScreenGui = nil
local espFolder = nil
local espNameColor = Color3.fromRGB(0, 255, 127)
local espBodyColor = Color3.fromRGB(0, 255, 127)
local espNameSize = 14
local espRainbowEnabled = false
local espRainbowSpeed = 5
local currentESPHue = 0

local aimbotEnabled = false
local aimbotFOV = 100
local aimbotSmoothness = 10
local aimbotCrosshairDistance = 5
local aimbotFOVColor = Color3.fromRGB(0, 255, 0)
local aimbotFriendCheck = true
local aimbotWallCheck = true
local aimbotTargetPlayer = nil
local aimbotTargetAll = true
local aimbotFOVRainbowEnabled = true
local aimbotFOVRainbowSpeed = 8
local currentFOVHue = 0

local drawingObjects = {}
local aimbotConnection = nil
local fovCircle = nil

local bulletTrackEnabled = false
local bulletOriginalFire = nil
local bulletTrackHooked = false

local function getRainbowColor(hue)
    hue = hue % 1
    local r, g, b
    local i = math.floor(hue * 6)
    local f = hue * 6 - i
    local p = 1
    local q = 1 - f
    local t = f
    if i % 6 == 0 then r, g, b = 1, t, p
    elseif i % 6 == 1 then r, g, b = q, 1, p
    elseif i % 6 == 2 then r, g, b = p, 1, t
    elseif i % 6 == 3 then r, g, b = p, q, 1
    elseif i % 6 == 4 then r, g, b = t, p, 1
    else r, g, b = 1, p, q end
    return Color3.new(r, g, b)
end

local function getNearestHead()
    local nearest = nil
    local minDist = 9999
    local cam = workspace.CurrentCamera
    for _, plr in ipairs(players:GetPlayers()) do
        if plr == localPlayer then continue end
        local char = plr.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not head or not hum or hum.Health <= 0 then continue end
        local pos, onScreen = cam:WorldToViewportPoint(head.Position)
        if not onScreen then continue end
        local dist = (Vector2.new(pos.X, pos.Y) - cam.ViewportSize/2).Magnitude
        if dist < minDist then
            minDist = dist
            nearest = head
        end
    end
    return nearest
end

local function setupBulletTrack()
    if bulletTrackHooked then
        return true
    end
    local success, bulletHandler = pcall(function()
        return require(replicatedStorage.ModuleScripts.GunModules.BulletHandler)
    end)
    if not success or not bulletHandler then
        WindUI:Notify({Title = "错误",Content = "无法找到BulletHandler模块",Duration = 3,Icon = "x"})
        return false
    end
    bulletOriginalFire = bulletHandler.Fire
    bulletHandler.Fire = function(fireData)
        if bulletTrackEnabled then
            local target = getNearestHead()
            if target then
                fireData.Direction = (target.Position - fireData.Origin).Unit
                fireData.Force = fireData.Force * 1000
            end
        end
        return bulletOriginalFire(fireData)
    end
    bulletTrackHooked = true
    return true
end

local function toggleBulletTrack(state)
    bulletTrackEnabled = state
    if state then
        local success = setupBulletTrack()
        if success then
            WindUI:Notify({Title = "子追",Content = "已启用",Duration = 2,Icon = "crosshair"})
        else
            bulletTrackEnabled = false
            WindUI:Notify({Title = "子追",Content = "启用失败",Duration = 2,Icon = "x"})
        end
    else
        WindUI:Notify({Title = "子追",Content = "已关闭",Duration = 2,Icon = "circle"})
    end
end

local function toggleInfiniteJump(state)
    infiniteJumpEnabled = state
    if state then
        if jumpConnection then
            jumpConnection:Disconnect()
        end
        jumpConnection = userInputService.JumpRequest:Connect(function()
            local char = localPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState("Jumping")
            end
        end)
        WindUI:Notify({Title = "无限跳跃",Content = "已开启无限跳跃",Icon = "jump-rope"})
    else
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
        WindUI:Notify({Title = "无限跳跃",Content = "已关闭无限跳跃",Icon = "jump-rope"})
    end
end

local function setGravity(value)
    local numValue = tonumber(value)
    if numValue then
        if gravityLoop then
            gravityLoop:Disconnect()
            gravityLoop = nil
        end
        workspace.Gravity = numValue
        WindUI:Notify({Title = "重力设置",Content = "重力已设置为: " .. tostring(numValue),Icon = "weight"})
    else
        WindUI:Notify({Title = "错误",Content = "请输入数字",Icon = "alert-circle"})
    end
end

local function setSpeed(value)
    local numValue = tonumber(value)
    if numValue then
        speedValue = numValue
        WindUI:Notify({Title = "速度设置",Content = "速度已设置为: " .. tostring(numValue),Icon = "zap"})
    else
        WindUI:Notify({Title = "错误",Content = "请输入有效数字",Icon = "alert-circle"})
    end
end

local function toggleSpeed(state)
    speedEnabled = state
    if state then
        if speedConnection then
            speedConnection:Disconnect()
        end
        speedConnection = runService.Heartbeat:Connect(function()
            local char = localPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                local humanoid = char.Humanoid
                if humanoid.MoveDirection.Magnitude > 0 then
                    char:TranslateBy(humanoid.MoveDirection * speedValue / 2)
                end
            end
        end)
    else
        if speedConnection then
            speedConnection:Disconnect()
            speedConnection = nil
        end
    end
end

local function initESP()
    espScreenGui = Instance.new("ScreenGui")
    espScreenGui.Name = "PlayerESP_System"
    espScreenGui.ResetOnSpawn = false
    espScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    espScreenGui.Parent = localPlayer:WaitForChild("PlayerGui")
    espFolder = Instance.new("Folder")
    espFolder.Name = "PlayerESPFolder"
    espFolder.Parent = espScreenGui
end

local function updateESPColors()
    if not espEnabled or not espFolder then return end
    for _, child in ipairs(espFolder:GetChildren()) do
        if child:IsA("BillboardGui") then
            local nameLabel = child:FindFirstChild("NameLabel")
            if nameLabel then
                nameLabel.TextColor3 = espRainbowEnabled and getRainbowColor(currentESPHue) or espNameColor
                nameLabel.TextSize = espNameSize
            end
        elseif child:IsA("Highlight") then
            child.FillColor = espRainbowEnabled and getRainbowColor(currentESPHue) or espBodyColor
            child.OutlineColor = espRainbowEnabled and getRainbowColor(currentESPHue) or espBodyColor
        end
    end
end

local function updateESPNameSize()
    if not espEnabled or not espFolder then return end
    for _, child in ipairs(espFolder:GetChildren()) do
        if child:IsA("BillboardGui") then
            local nameLabel = child:FindFirstChild("NameLabel")
            if nameLabel then
                nameLabel.TextSize = espNameSize
            end
        end
    end
end

local function createPlayerESP(player)
    if player == localPlayer or not espEnabled then return end
    local character = player.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    local existingESP = espFolder:FindFirstChild(player.Name)
    if existingESP then existingESP:Destroy() end
    local ESPGui = Instance.new("BillboardGui")
    ESPGui.Name = player.Name
    ESPGui.Adornee = humanoidRootPart
    ESPGui.Size = UDim2.new(0, 100, 0, 40)
    ESPGui.StudsOffset = Vector3.new(0, 3, 0)
    ESPGui.AlwaysOnTop = true
    ESPGui.MaxDistance = 500
    ESPGui.Enabled = true
    ESPGui.Parent = espFolder
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = espNameSize
    NameLabel.TextColor3 = espRainbowEnabled and getRainbowColor(currentESPHue) or espNameColor
    NameLabel.TextStrokeTransparency = 0.5
    NameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    NameLabel.Text = player.Name
    NameLabel.Parent = ESPGui
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Size = UDim2.new(1, 0, 0.5, 0)
    DistanceLabel.Position = UDim2.new(0, 0, 0.5, 0)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.Font = Enum.Font.Gotham
    DistanceLabel.TextSize = 12
    DistanceLabel.TextColor3 = Color3.fromRGB(240, 255, 245)
    DistanceLabel.TextStrokeTransparency = 0.5
    DistanceLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    DistanceLabel.Name = "DistanceLabel"
    DistanceLabel.Parent = ESPGui
    local Highlight = Instance.new("Highlight")
    Highlight.Name = player.Name .. "_Highlight"
    Highlight.Adornee = character
    Highlight.FillColor = espRainbowEnabled and getRainbowColor(currentESPHue) or espBodyColor
    Highlight.FillTransparency = 0.7
    Highlight.OutlineColor = espRainbowEnabled and getRainbowColor(currentESPHue) or espBodyColor
    Highlight.OutlineTransparency = 0
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Enabled = true
    Highlight.Parent = espFolder
end

local function updateESP()
    if not espEnabled then return end
    pcall(function()
        local myCharacter = localPlayer.Character
        local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end
        for _, player in ipairs(players:GetPlayers()) do
            if player ~= localPlayer then
                local character = player.Character
                if character then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local espGui = espFolder:FindFirstChild(player.Name)
                        if not espGui then
                            createPlayerESP(player)
                            espGui = espFolder:FindFirstChild(player.Name)
                        end
                        local distance = (myHRP.Position - hrp.Position).Magnitude
                        local distanceLabel = espGui:FindFirstChild("DistanceLabel")
                        if distanceLabel then
                            distanceLabel.Text = string.format("%.0f studs", distance)
                        end
                        if distance > 500 then
                            espGui.Enabled = false
                            local highlight = espFolder:FindFirstChild(player.Name .. "_Highlight")
                            if highlight then highlight.Enabled = false end
                        else
                            espGui.Enabled = true
                            local highlight = espFolder:FindFirstChild(player.Name .. "_Highlight")
                            if highlight then highlight.Enabled = true end
                        end
                    else
                        local espGui = espFolder:FindFirstChild(player.Name)
                        if espGui then espGui:Destroy() end
                        local highlight = espFolder:FindFirstChild(player.Name .. "_Highlight")
                        if highlight then highlight:Destroy() end
                    end
                else
                    local esp = espFolder:FindFirstChild(player.Name)
                    if esp then esp:Destroy() end
                    local highlight = espFolder:FindFirstChild(player.Name .. "_Highlight")
                    if highlight then highlight:Destroy() end
                end
            end
        end
    end)
end

local function toggleESP(state)
    espEnabled = state
    if state then
        if not espScreenGui then initESP() end
        for _, player in ipairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                createPlayerESP(player)
            end
        end
        WindUI:Notify({Title = "透视",Content = "玩家透视已开启",Icon = "eye"})
    else
        if espFolder then
            for _, esp in ipairs(espFolder:GetChildren()) do
                esp:Destroy()
            end
        end
        WindUI:Notify({Title = "透视",Content = "玩家透视已关闭",Icon = "eye"})
    end
end

local function initializeAimDrawings()
    if not fovCircle then
        fovCircle = Drawing.new("Circle")
        fovCircle.Visible = aimbotEnabled
        fovCircle.Thickness = 2
        fovCircle.Filled = false
        fovCircle.Radius = aimbotFOV
        fovCircle.Position = workspace.CurrentCamera.ViewportSize / 2
        table.insert(drawingObjects, fovCircle)
    end
end

local function updateFOVCircle()
    if fovCircle then
        fovCircle.Visible = aimbotEnabled
        fovCircle.Radius = aimbotFOV
        fovCircle.Color = aimbotFOVRainbowEnabled and getRainbowColor(currentFOVHue) or aimbotFOVColor
        fovCircle.Position = workspace.CurrentCamera.ViewportSize / 2
    end
end

local function cleanupDrawings()
    for _, drawing in ipairs(drawingObjects) do
        if drawing then
            drawing:Remove()
        end
    end
    drawingObjects = {}
    fovCircle = nil
end

local function isFriend(player)
    if not aimbotFriendCheck then
        return false
    end
    local success, result = pcall(function()
        if localPlayer:IsFriendsWith(player.UserId) then
            return true
        end
        return false
    end)
    return success and result
end

local function wallCheck(targetPosition, targetCharacter)
    if not aimbotWallCheck then
        return true
    end
    local camera = workspace.CurrentCamera
    local origin = camera.CFrame.Position
    local direction = (targetPosition - origin).Unit
    local distance = (targetPosition - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {localPlayer.Character, targetCharacter}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    raycastParams.CollisionGroup = "Default"
    local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
    if raycastResult then
        local hitPart = raycastResult.Instance
        if hitPart then
            local size = hitPart.Size
            local isLargeWall = size.X > 10 or size.Y > 10 or size.Z > 10
            local nameLower = string.lower(hitPart.Name)
            local isWallName = string.find(nameLower, "wall") or string.find(nameLower, "floor") or string.find(nameLower, "ceiling") or string.find(nameLower, "base")
            if isLargeWall or isWallName then
                return false
            end
        end
    end
    return true
end

local function getClosestPlayer()
    local camera = workspace.CurrentCamera
    local mousePos = camera.ViewportSize / 2
    local nearestPlayer = nil
    local shortestDistance = aimbotFOV
    if aimbotTargetPlayer and not aimbotTargetAll then
        local target = players:FindFirstChild(aimbotTargetPlayer)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if distance <= aimbotFOV then
                    return target
                end
            end
        end
        return nil
    end
    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            if isFriend(player) then
                continue
            end
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoidRootPart and humanoid and humanoid.Health > 0 then
                if not wallCheck(humanoidRootPart.Position, player.Character) then
                    continue
                end
                local screenPos, onScreen = camera:WorldToViewportPoint(humanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        nearestPlayer = player
                    end
                end
            end
        end
    end
    return nearestPlayer
end

local function aimBot()
    if not aimbotEnabled then
        return
    end
    local camera = workspace.CurrentCamera
    local target = getClosestPlayer()
    if target and target.Character then
        local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
        local head = target.Character:FindFirstChild("Head")
        if humanoidRootPart and head then
            local targetVelocity = humanoidRootPart.Velocity
            local targetPosition = head.Position
            if aimbotCrosshairDistance > 0 then
                local distance = (targetPosition - camera.CFrame.Position).Magnitude
                local timeToTarget = distance / 1000
                targetPosition = targetPosition + (targetVelocity * timeToTarget * aimbotCrosshairDistance)
            end
            local currentCFrame = camera.CFrame
            local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
            local smoothedCFrame = currentCFrame:Lerp(targetCFrame, 1 / aimbotSmoothness)
            camera.CFrame = smoothedCFrame
        end
    end
end

local function toggleAimbot(state)
    aimbotEnabled = state
    if state then
        initializeAimDrawings()
        updateFOVCircle()
        if aimbotConnection then
            aimbotConnection:Disconnect()
        end
        aimbotConnection = runService.RenderStepped:Connect(function(deltaTime)
            if aimbotFOVRainbowEnabled then
                currentFOVHue = currentFOVHue + deltaTime * aimbotFOVRainbowSpeed / 10
            end
            updateFOVCircle()
            aimBot()
        end)
        WindUI:Notify({Title = "自瞄",Content = "自瞄功能已开启",Icon = "crosshair"})
    else
        if aimbotConnection then
            aimbotConnection:Disconnect()
            aimbotConnection = nil
        end
        cleanupDrawings()
        WindUI:Notify({Title = "自瞄",Content = "自瞄功能已关闭",Icon = "crosshair"})
    end
end

local FlashMainTab = Window:Tab({Title = "主功能", Icon = "settings", Locked = false})

FlashMainTab:Toggle({
    Title = "无限跳跃",
    Desc = "启用后可以无限跳跃",
    Default = infiniteJumpEnabled,
    Callback = function(value)
        toggleInfiniteJump(value)
    end
})
FlashMainTab:Input({
    Title = "设置重力",
    Desc = "输入重力值 (默认: " .. tostring(originalGravity) .. ")",
    Placeholder = "输入重力值",
    Callback = function(value)
        setGravity(value)
    end
})
FlashMainTab:Input({
    Title = "设置快速跑步速度",
    Desc = "输入速度 (默认: 1)",
    Placeholder = "输入速度",
    Callback = function(value)
        setSpeed(value)
    end
})
FlashMainTab:Toggle({
    Title = "开启快速跑步",
    Desc = "启用快速跑步功能",
    Default = speedEnabled,
    Callback = function(value)
        toggleSpeed(value)
    end
})

local BulletTrackTab = Window:Tab({Title = "子追", Icon = "crosshair", Locked = false})
BulletTrackTab:Toggle({
    Title = "启用子追",
    Desc = "自动瞄准最近敌人头部",
    Default = bulletTrackEnabled,
    Callback = function(value)
        toggleBulletTrack(value)
    end
})

local ESPTab = Window:Tab({Title = "透视功能", Icon = "eye", Locked = false})
ESPTab:Toggle({
    Title = "玩家透视 (ESP)",
    Desc = "显示玩家描边和距离",
    Default = espEnabled,
    Callback = function(value)
        toggleESP(value)
    end
})
ESPTab:Colorpicker({
    Title = "ESP玩家名字颜色",
    Desc = "设置玩家名字显示颜色",
    Default = espNameColor,
    Callback = function(color)
        espNameColor = color
        if espEnabled and not espRainbowEnabled then
            updateESPColors()
        end
    end
})
ESPTab:Colorpicker({
    Title = "ESP身体绘制颜色",
    Desc = "设置玩家身体颜色",
    Default = espBodyColor,
    Callback = function(color)
        espBodyColor = color
        if espEnabled and not espRainbowEnabled then
            updateESPColors()
        end
    end
})
ESPTab:Slider({
    Title = "ESP玩家名字大小",
    Desc = "设置玩家名字的文本大小",
    Value = {Min = 8,Max = 24,Default = espNameSize},
    Callback = function(value)
        espNameSize = value
        if espEnabled then
            updateESPNameSize()
        end
    end
})
ESPTab:Toggle({
    Title = "ESP彩虹渐变",
    Desc = "开启透视彩虹效果",
    Default = espRainbowEnabled,
    Callback = function(value)
        espRainbowEnabled = value
        if espEnabled then
            updateESPColors()
        end
    end
})
ESPTab:Slider({
    Title = "ESP彩虹速度",
    Desc = "调整彩虹的速度",
    Value = {Min = 1,Max = 10,Default = espRainbowSpeed},
    Callback = function(value)
        espRainbowSpeed = value
    end
})

local AimbotTab = Window:Tab({Title = "自瞄功能", Icon = "crosshair", Locked = false})
AimbotTab:Paragraph({
        Title = "你可以滑到这页的最下面打开那个快速设置近距离，或者用子追",
        Desc = "我个人觉得这个好用些（不代表所有人）",
    })
AimbotTab:Toggle({
    Title = "启用自瞄",
    Desc = "开启/关闭自瞄功能",
    Default = aimbotEnabled,
    Callback = function(value)
        toggleAimbot(value)
    end
})
AimbotTab:Toggle({
    Title = "FOV彩虹效果",
    Desc = "开启FOV圆圈彩虹效果",
    Value = aimbotFOVRainbowEnabled,
    Callback = function(value)
        aimbotFOVRainbowEnabled = value
        updateFOVCircle()
    end
})
AimbotTab:Slider({
    Title = "FOV彩虹速度",
    Desc = "调整彩虹流动的速度",
    Value = {Min = 1,Max = 20,Default = aimbotFOVRainbowSpeed},
    Callback = function(value)
        aimbotFOVRainbowSpeed = value
    end
})
AimbotTab:Slider({
    Title = "自瞄范围 (FOV)",
    Desc = "设置自瞄FOV大小",
    Value = {Min = 50,Max = 500,Default = aimbotFOV},
    Callback = function(value)
        aimbotFOV = value
        updateFOVCircle()
    end
})
AimbotTab:Slider({
    Title = "自瞄平滑度",
    Desc = "数值越小越强锁",
    Value = {Min = 1,Max = 50,Default = aimbotSmoothness},
    Callback = function(value)
        aimbotSmoothness = value
    end
})
AimbotTab:Slider({
    Title = "预判距离",
    Desc = "设置预判距离(需要强锁直接调到0-3)",
    Value = {Min = 0,Max = 20,Default = aimbotCrosshairDistance},
    Callback = function(value)
        aimbotCrosshairDistance = value
    end
})
AimbotTab:Colorpicker({
    Title = "FOV圆圈颜色",
    Desc = "彩虹模式关闭时生效",
    Default = aimbotFOVColor,
    Callback = function(color)
        aimbotFOVColor = color
        updateFOVCircle()
    end
})
AimbotTab:Toggle({
    Title = "好友检测",
    Desc = "不秒好友",
    Value = aimbotFriendCheck,
    Callback = function(value)
        aimbotFriendCheck = value
    end
})
AimbotTab:Toggle({
    Title = "墙壁检测",
    Desc = "开启墙壁检测 避免自瞄乱飞",
    Value = aimbotWallCheck,
    Callback = function(value)
        aimbotWallCheck = value
    end
})
local playerList = {}
for _, player in ipairs(players:GetPlayers()) do
    if player ~= localPlayer then
        table.insert(playerList, player.Name)
    end
end
AimbotTab:Toggle({
    Title = "目标自瞄模式",
    Desc = "开启后可以选择目标进行制裁",
    Value = false,
    Callback = function(value)
        aimbotTargetAll = not value
    end
})
local targetDropdown = AimbotTab:Dropdown({
    Title = "选择目标玩家",
    Desc = "选择要自瞄的玩家",
    Values = playerList,
    Value = nil,
    AllowNone = true,
    Callback = function(selected)
        aimbotTargetPlayer = selected
    end
})
players.PlayerAdded:Connect(function(player)
    table.insert(playerList, player.Name)
    if targetDropdown and targetDropdown.Refresh then
        targetDropdown:Refresh(playerList)
    end
end)
players.PlayerRemoving:Connect(function(player)
    for i, name in ipairs(playerList) do
        if name == player.Name then
            table.remove(playerList, i)
            break
        end
    end
    if targetDropdown and targetDropdown.Refresh then
        targetDropdown:Refresh(playerList)
    end
end)
local QuickSettings = AimbotTab:Group({})
QuickSettings:Button({
    Title = "快速设置: 近距离(强锁)",
    Desc = "FOV: 80 平滑: 1 预判0",
    Justify = "Center",
    Callback = function()
        aimbotFOV = 80
        aimbotSmoothness = 1
        aimbotCrosshairDistance = 0
        updateFOVCircle()
        WindUI:Notify({Title = "快速设置",Content = "已使用近距离设置",Icon = "settings"})
    end
})
QuickSettings:Button({
    Title = "快速设置: 中距离(小强锁)",
    Desc = "FOV: 120, 平滑: 4 预判2",
    Justify = "Center",
    Callback = function()
        aimbotFOV = 120
        aimbotSmoothness = 4
        aimbotCrosshairDistance = 2
        updateFOVCircle()
        WindUI:Notify({Title = "快速设置",Content = "已使用中距离设置",Icon = "settings"})
    end
})
QuickSettings:Button({
    Title = "快速设置: 远距离",
    Desc = "FOV: 130 平滑: 5 预判3",
    Justify = "Center",
    Callback = function()
        aimbotFOV = 130
        aimbotSmoothness = 5
        aimbotCrosshairDistance = 3
        updateFOVCircle()
        WindUI:Notify({Title = "快速设置",Content = "已使用远距离设置",Icon = "settings"})
    end
})

localPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if espEnabled then
        if espFolder then
            for _, esp in ipairs(espFolder:GetChildren()) do
                esp:Destroy()
            end
        end
        for _, player in ipairs(players:GetPlayers()) do
            if player ~= localPlayer and player.Character then
                createPlayerESP(player)
            end
        end
    end
end)
players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(1)
            createPlayerESP(player)
        end
    end)
end)
players.PlayerRemoving:Connect(function(player)
    if espFolder then
        local espGui = espFolder:FindFirstChild(player.Name)
        if espGui then espGui:Destroy() end
        local highlight = espFolder:FindFirstChild(player.Name .. "_Highlight")
        if highlight then highlight:Destroy() end
    end
end)

runService.Heartbeat:Connect(function(deltaTime)
    updateESP()
    if espRainbowEnabled then
        currentESPHue = currentESPHue + deltaTime * espRainbowSpeed / 10
        updateESPColors()
    end
end)

WindUI:Notify({Title = "QJ脚本",Content = "以为您加载闪光",Duration = 3,Icon = "check"})
