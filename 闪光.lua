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

local bulletAimbotEnabled = false
local bulletAimbotRange = 999
local bulletOriginalFireFunction
local bulletHandlerHooked = false

if not getgenv().BulletTrailColors then
    getgenv().BulletTrailColors = {
        StartColor = Color3.fromRGB(0, 170, 255),
        EndColor = Color3.fromRGB(255, 0, 0),
        MiddleColor1 = Color3.fromRGB(255, 0, 255),
        MiddleColor2 = Color3.fromRGB(255, 255, 0)
    }
end

if not getgenv().HitEffectConfig then
    getgenv().HitEffectConfig = {
        Enabled = true,
        Text = "XD",
        TextColor = Color3.fromRGB(255, 0, 0),
        TextSize = 50,
        EffectColor = Color3.fromRGB(255, 0, 0),
        EffectSize = 5,
        Duration = 3,
        ShowExplosion = true,
        ExplosionColor = Color3.fromRGB(255, 100, 0),
        ShowShockwave = true,
        ShockwaveColor = Color3.fromRGB(255, 200, 0)
    }
end

local bulletTrailTransparency = 0.3
local bulletTrailSize = 0.25
local currentBulletTrail = nil
local bulletTrailOverallColor = Color3.fromRGB(255, 255, 255)

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

local function createBezierCurve(p0, p1, p2, t)
    return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2
end

local function cleanupPreviousBulletTrail()
    if currentBulletTrail and currentBulletTrail.Parent then
        currentBulletTrail:Destroy()
        currentBulletTrail = nil
    end
end

local function createHitEffect(hitPosition, hitCharacter)
    if not getgenv().HitEffectConfig.Enabled then
        return
    end
    pcall(function()
        local effectContainer = Instance.new("Folder")
        effectContainer.Name = "HitEffect_" .. tostring(tick())
        effectContainer.Parent = workspace
        if getgenv().HitEffectConfig.Text and getgenv().HitEffectConfig.Text ~= "" then
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "HitText"
            billboardGui.Size = UDim2.new(0, 200, 0, 200)
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
            billboardGui.AlwaysOnTop = true
            billboardGui.Adornee = hitCharacter and hitCharacter:FindFirstChild("HumanoidRootPart") or nil
            billboardGui.Enabled = true
            billboardGui.Parent = effectContainer
            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = getgenv().HitEffectConfig.Text
            textLabel.TextColor3 = getgenv().HitEffectConfig.TextColor
            textLabel.TextSize = getgenv().HitEffectConfig.TextSize
            textLabel.Font = Enum.Font.GothamBold
            textLabel.TextStrokeTransparency = 0.5
            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
            textLabel.Parent = billboardGui
            local tweenInfo = TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
            local scaleTween = tweenService:Create(textLabel, tweenInfo, {TextSize = getgenv().HitEffectConfig.TextSize * 1.5})
            scaleTween:Play()
            task.delay(getgenv().HitEffectConfig.Duration * 0.7, function()
                local fadeTween = tweenService:Create(textLabel, TweenInfo.new(0.5), {TextTransparency = 1,TextStrokeTransparency = 1})
                fadeTween:Play()
            end)
        end
        if getgenv().HitEffectConfig.ShowExplosion then
            local explosion = Instance.new("Part")
            explosion.Name = "ExplosionEffect"
            explosion.Size = Vector3.new(1, 1, 1)
            explosion.Shape = Enum.PartType.Ball
            explosion.Material = Enum.Material.Neon
            explosion.Color = getgenv().HitEffectConfig.ExplosionColor
            explosion.Transparency = 0.3
            explosion.Anchored = true
            explosion.CanCollide = false
            explosion.Position = hitPosition
            explosion.Parent = effectContainer
            local explosionLight = Instance.new("PointLight")
            explosionLight.Brightness = 15
            explosionLight.Range = getgenv().HitEffectConfig.EffectSize * 3
            explosionLight.Color = getgenv().HitEffectConfig.ExplosionColor
            explosionLight.Parent = explosion
            local scaleTween = tweenService:Create(explosion, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = Vector3.new(getgenv().HitEffectConfig.EffectSize,getgenv().HitEffectConfig.EffectSize,getgenv().HitEffectConfig.EffectSize)})
            scaleTween:Play()
            task.delay(0.5, function()
                local fadeTween = tweenService:Create(explosion, TweenInfo.new(0.5), {Transparency = 1})
                fadeTween:Play()
                local lightTween = tweenService:Create(explosionLight, TweenInfo.new(0.5), {Brightness = 0})
                lightTween:Play()
            end)
        end
        if getgenv().HitEffectConfig.ShowShockwave then
            local shockwave = Instance.new("Part")
            shockwave.Name = "ShockwaveEffect"
            shockwave.Size = Vector3.new(1, 0.1, 1)
            shockwave.Shape = Enum.PartType.Cylinder
            shockwave.Material = Enum.Material.Neon
            shockwave.Color = getgenv().HitEffectConfig.ShockwaveColor
            shockwave.Transparency = 0.5
            shockwave.Anchored = true
            shockwave.CanCollide = false
            shockwave.CFrame = CFrame.new(hitPosition) * CFrame.Angles(math.rad(90), 0, 0)
            shockwave.Parent = effectContainer
            local scaleTween = tweenService:Create(shockwave, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = Vector3.new(getgenv().HitEffectConfig.EffectSize * 4,0.1,getgenv().HitEffectConfig.EffectSize * 4),Transparency = 1})
            scaleTween:Play()
        end
        local particleEmitter = Instance.new("ParticleEmitter")
        particleEmitter.Parent = effectContainer
        particleEmitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5),NumberSequenceKeypoint.new(0.5, 1),NumberSequenceKeypoint.new(1, 0)})
        particleEmitter.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0),NumberSequenceKeypoint.new(1, 1)})
        particleEmitter.Color = ColorSequence.new(getgenv().HitEffectConfig.EffectColor)
        particleEmitter.Acceleration = Vector3.new(0, -10, 0)
        particleEmitter.Lifetime = NumberRange.new(1, 2)
        particleEmitter.Rate = 100
        particleEmitter.Speed = NumberRange.new(5, 10)
        particleEmitter.VelocitySpread = 360
        task.delay(getgenv().HitEffectConfig.Duration, function()
            if effectContainer and effectContainer.Parent then
                effectContainer:Destroy()
            end
        end)
        return effectContainer
    end)
end

local function createBulletTrail(origin, targetPos, targetCharacter)
    cleanupPreviousBulletTrail()
    local trailContainer = Instance.new("Folder")
    trailContainer.Name = "BulletTrail_" .. tostring(tick())
    trailContainer.Parent = workspace
    currentBulletTrail = trailContainer
    local midPoint = (origin + targetPos) / 2
    local direction = (targetPos - origin).Unit
    local perpendicular = Vector3.new(-direction.Z, direction.Y, direction.X) * 5
    local controlPoint = midPoint + perpendicular + Vector3.new(0, math.random(-5, 5), 0)
    local curvePoints = {}
    local numSegments = 25
    for i = 0, numSegments do
        local t = i / numSegments
        local point = createBezierCurve(origin, controlPoint, targetPos, t)
        table.insert(curvePoints, point)
    end
    for i = 1, #curvePoints - 1 do
        local startPoint = curvePoints[i]
        local endPoint = curvePoints[i + 1]
        local distance = (endPoint - startPoint).Magnitude
        local beamPart = Instance.new("Part")
        beamPart.Size = Vector3.new(bulletTrailSize, bulletTrailSize, distance)
        beamPart.Anchored = true
        beamPart.CanCollide = false
        beamPart.Material = Enum.Material.Neon
        beamPart.Transparency = bulletTrailTransparency
        beamPart.CFrame = CFrame.new(startPoint, endPoint) * CFrame.new(0, 0, -distance / 2)
        beamPart.Parent = trailContainer
        local t = i / (#curvePoints - 1)
        local color
        if bulletTrailOverallColor ~= Color3.fromRGB(255, 255, 255) then
            color = bulletTrailOverallColor
        else
            if t < 0.3 then
                color = getgenv().BulletTrailColors.StartColor or Color3.fromRGB(0, 170, 255)
            elseif t < 0.6 then
                color = getgenv().BulletTrailColors.MiddleColor1 or Color3.fromRGB(255, 0, 255)
            elseif t < 0.9 then
                color = getgenv().BulletTrailColors.MiddleColor2 or Color3.fromRGB(255, 255, 0)
            else
                color = getgenv().BulletTrailColors.EndColor or Color3.fromRGB(255, 0, 0)
            end
        end
        beamPart.Color = color
        local pointLight = Instance.new("PointLight")
        pointLight.Brightness = 8
        pointLight.Range = 5
        pointLight.Color = color
        pointLight.Parent = beamPart
        local particles = Instance.new("ParticleEmitter")
        particles.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2),NumberSequenceKeypoint.new(0.5, 0.4),NumberSequenceKeypoint.new(1, 0.1)})
        particles.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2),NumberSequenceKeypoint.new(1, 0.8)})
        particles.Lifetime = NumberRange.new(0.8, 1.5)
        particles.Rate = 80
        particles.Speed = NumberRange.new(2, 4)
        particles.VelocitySpread = 180
        particles.Color = ColorSequence.new(color)
        particles.Parent = beamPart
        local glow = Instance.new("SurfaceLight")
        glow.Brightness = 2
        glow.Range = 8
        glow.Color = color
        glow.Parent = beamPart
    end
    local startExplosion = Instance.new("Part")
    startExplosion.Size = Vector3.new(1, 1, 1)
    startExplosion.Anchored = true
    startExplosion.CanCollide = false
    startExplosion.Material = Enum.Material.Neon
    startExplosion.Transparency = 0.5
    startExplosion.Shape = Enum.PartType.Ball
    startExplosion.CFrame = CFrame.new(origin)
    startExplosion.Color = bulletTrailOverallColor ~= Color3.fromRGB(255, 255, 255) and bulletTrailOverallColor or getgenv().BulletTrailColors.StartColor
    startExplosion.Parent = trailContainer
    local startLight = Instance.new("PointLight")
    startLight.Brightness = 10
    startLight.Range = 10
    startLight.Color = startExplosion.Color
    startLight.Parent = startExplosion
    spawn(function()
        task.wait(0.1)
        if targetCharacter and getgenv().HitEffectConfig.Enabled then
            createHitEffect(targetPos, targetCharacter)
        end
        local endExplosion = Instance.new("Part")
        endExplosion.Size = Vector3.new(1.5, 1.5, 1.5)
        endExplosion.Anchored = true
        endExplosion.CanCollide = false
        endExplosion.Material = Enum.Material.Neon
        endExplosion.Transparency = 0.3
        endExplosion.Shape = Enum.PartType.Ball
        endExplosion.CFrame = CFrame.new(targetPos)
        endExplosion.Color = bulletTrailOverallColor ~= Color3.fromRGB(255, 255, 255) and bulletTrailOverallColor or getgenv().BulletTrailColors.EndColor
        endExplosion.Parent = trailContainer
        local endLight = Instance.new("PointLight")
        endLight.Brightness = 15
        endLight.Range = 12
        endLight.Color = endExplosion.Color
        endLight.Parent = endExplosion
    end)
    task.delay(1.5, function()
        if trailContainer and trailContainer.Parent then
            for _, child in ipairs(trailContainer:GetChildren()) do
                if child:IsA("Part") then
                    local tween = tweenService:Create(child, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Transparency = 1})
                    tween:Play()
                end
            end
            task.delay(0.5, function()
                if trailContainer and trailContainer.Parent then
                    trailContainer:Destroy()
                end
            end)
        end
    end)
    return trailContainer
end

local function get_closest_target(range)
    local closest_part, closest_distance, closest_character = nil, range, nil
    local camera = workspace.CurrentCamera
    for _, player in players:GetPlayers() do
        if player == localPlayer then
            continue
        end
        local character = player.Character
        if not character then
            continue
        end
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        if not head or not humanoid or humanoid.Health == 0 then
            continue
        end
        local screen_position, on_screen = camera:WorldToViewportPoint(head.Position)
        if not on_screen then
            continue
        end
        local distance = (Vector2.new(screen_position.X, screen_position.Y) - camera.ViewportSize / 2).Magnitude
        if distance < closest_distance then
            closest_part = head
            closest_distance = distance
            closest_character = character
        end
    end
    return closest_part, closest_character
end

local function setupBulletAimbot()
    if bulletHandlerHooked then
        return true
    end
    local success, bullet_handler = pcall(function()
        return require(game:GetService("ReplicatedStorage").ModuleScripts.GunModules.BulletHandler)
    end)
    if not success or not bullet_handler then
        WindUI:Notify({Title = "错误",Content = "无法找到BulletHandler模块",Duration = 3,Icon = "x"})
        return false
    end
    bulletOriginalFireFunction = bullet_handler.Fire
    bullet_handler.Fire = function(data)
        if bulletAimbotEnabled then
            local closest, character = get_closest_target(bulletAimbotRange)
            if closest then
                data.Force = data.Force * 1000
                data.Direction = (closest.Position - data.Origin).Unit
                spawn(function()
                    createBulletTrail(data.Origin, closest.Position, character)
                end)
            end
        end
        return bulletOriginalFireFunction(data)
    end
    bulletHandlerHooked = true
    return true
end

local function toggleBulletAimbot(state)
    bulletAimbotEnabled = state
    if state then
        local success = setupBulletAimbot()
        if success then
            WindUI:Notify({Title = "美国子弹",Content = "功能已启用 (距离: " .. bulletAimbotRange .. ")",Duration = 2,Icon = "crosshair"})
        else
            bulletAimbotEnabled = false
            WindUI:Notify({Title = "美国子弹",Content = "启用失败",Duration = 2,Icon = "x"})
        end
    else
        cleanupPreviousBulletTrail()
        WindUI:Notify({Title = "美国子弹",Content = "功能已关闭",Duration = 2,Icon = "circle"})
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
    Title = "美国子弹",
    Desc = "开启/关闭美国子弹功能",
    Default = bulletAimbotEnabled,
    Callback = function(value)
        toggleBulletAimbot(value)
    end
})
FlashMainTab:Slider({
    Title = "子弹范围",
    Desc = "设置美国子弹的瞄准范围",
    Value = {Min = 50,Max = 2000,Default = bulletAimbotRange},
    Callback = function(value)
        bulletAimbotRange = value
        if bulletAimbotEnabled then
            WindUI:Notify({Title = "美国子弹",Content = "范围已更新: " .. value,Duration = 2,Icon = "maximize-2"})
        end
    end
})
FlashMainTab:Button({
    Title = "测试子弹",
    Desc = "测试美国子弹功能",
    Callback = function()
        if bulletAimbotEnabled then
            WindUI:Notify({Title = "美国子弹",Content = "功能已启用，范围: " .. bulletAimbotRange,Duration = 3,Icon = "check"})
        else
            WindUI:Notify({Title = "美国子弹",Content = "请先开启美国子弹功能",Duration = 3,Icon = "x"})
        end
    end
})
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

FlashMainTab:Section({Title = "美国子弹弹道设置",TextSize = 16,FontWeight = Enum.FontWeight.SemiBold})
local BulletTrailOverallColorPicker = FlashMainTab:Colorpicker({
    Flag = "BulletTrailOverallColor",
    Title = "整体弹道颜色",
    Desc = "设置弹道整体颜色（启用后会覆盖渐变颜色）",
    Default = bulletTrailOverallColor,
    Transparency = 0,
    Callback = function(color)
        bulletTrailOverallColor = color
        if color == Color3.fromRGB(255, 255, 255) then
            WindUI:Notify({Title = "颜色已更新",Content = "已启用渐变颜色模式",Duration = 2})
        else
            WindUI:Notify({Title = "颜色已更新",Content = "美国子弹弹道整体颜色已设置为: " .. tostring(color),Duration = 2})
        end
    end
})
FlashMainTab:Button({
    Title = "启用渐变颜色模式",
    Desc = "禁用整体颜色，使用下面的渐变颜色设置",
    Justify = "Center",
    Icon = "palette",
    Callback = function()
        bulletTrailOverallColor = Color3.fromRGB(255, 255, 255)
        BulletTrailOverallColorPicker:Set(Color3.fromRGB(255, 255, 255))
        WindUI:Notify({Title = "模式已切换",Content = "已启用渐变颜色模式",Duration = 2})
    end
})
FlashMainTab:Space({ Columns = 1 })
local BulletTrailColorStartPicker = FlashMainTab:Colorpicker({
    Flag = "BulletTrailColorStart",
    Title = "弹道起始颜色",
    Desc = "设置弹道开始部分的颜色（渐变模式生效）",
    Default = getgenv().BulletTrailColors.StartColor,
    Transparency = 0,
    Callback = function(color)
        getgenv().BulletTrailColors.StartColor = color
        WindUI:Notify({Title = "颜色已更新",Content = "美国子弹弹道起始颜色已设置为: " .. tostring(color),Duration = 2})
    end
})
FlashMainTab:Space({ Columns = 1 })
local BulletTrailColorMiddle1Picker = FlashMainTab:Colorpicker({
    Flag = "BulletTrailColorMiddle1",
    Title = "弹道中间颜色1",
    Desc = "设置弹道中间部分的颜色（渐变模式生效）",
    Default = getgenv().BulletTrailColors.MiddleColor1,
    Transparency = 0,
    Callback = function(color)
        getgenv().BulletTrailColors.MiddleColor1 = color
        WindUI:Notify({Title = "颜色已更新",Content = "美国子弹弹道中间颜色1已设置为: " .. tostring(color),Duration = 2})
    end
})
FlashMainTab:Space({ Columns = 1 })
local BulletTrailColorMiddle2Picker = FlashMainTab:Colorpicker({
    Flag = "BulletTrailColorMiddle2",
    Title = "弹道中间颜色2",
    Desc = "设置弹道中间部分的颜色（渐变模式生效）",
    Default = getgenv().BulletTrailColors.MiddleColor2,
    Transparency = 0,
    Callback = function(color)
        getgenv().BulletTrailColors.MiddleColor2 = color
        WindUI:Notify({Title = "颜色已更新",Content = "美国子弹弹道中间颜色2已设置为: " .. tostring(color),Duration = 2})
    end
})
FlashMainTab:Space({ Columns = 1 })
local BulletTrailColorEndPicker = FlashMainTab:Colorpicker({
    Flag = "BulletTrailColorEnd",
    Title = "弹道结束颜色",
    Desc = "设置弹道结束部分的颜色（渐变模式生效）",
    Default = getgenv().BulletTrailColors.EndColor,
    Transparency = 0,
    Callback = function(color)
        getgenv().BulletTrailColors.EndColor = color
        WindUI:Notify({Title = "颜色已更新",Content = "美国子弹弹道结束颜色已设置为: " .. tostring(color),Duration = 2})
    end
})
FlashMainTab:Space()
FlashMainTab:Section({Title = "弹道效果调整",TextSize = 16,FontWeight = Enum.FontWeight.SemiBold})
FlashMainTab:Slider({
    Flag = "BulletTrailSize",
    Title = "弹道尺寸",
    Desc = "调整美国子弹弹道的粗细",
    Icons = {From = "minimize",To = "maximize"},
    Step = 0.05,
    IsTooltip = true,
    Value = {Min = 0.1,Max = 0.5,Default = bulletTrailSize},
    Callback = function(value)
        bulletTrailSize = value
        WindUI:Notify({Title = "尺寸已调整",Content = "美国子弹弹道尺寸设置为: " .. string.format("%.2f", value),Duration = 2})
    end
})
FlashMainTab:Slider({
    Flag = "BulletTrailTransparency",
    Title = "弹道透明度",
    Desc = "调整美国子弹弹道的透明度",
    Icons = {From = "eye",To = "eye-off"},
    Step = 0.1,
    IsTooltip = true,
    Value = {Min = 0,Max = 1,Default = bulletTrailTransparency},
    Callback = function(value)
        bulletTrailTransparency = value
        WindUI:Notify({Title = "透明度已调整",Content = "美国子弹弹道透明度设置为: " .. value,Duration = 2})
    end
})

FlashMainTab:Section({Title = "美国子弹命中特效设置",TextSize = 16,FontWeight = Enum.FontWeight.SemiBold})
FlashMainTab:Toggle({
    Title = "启用命中特效",
    Desc = "开启/关闭子弹命中时的特效",
    Default = getgenv().HitEffectConfig.Enabled,
    Callback = function(value)
        getgenv().HitEffectConfig.Enabled = value
        WindUI:Notify({Title = "命中特效",Content = value and "已启用" or "已禁用",Duration = 2})
    end
})
FlashMainTab:Input({
    Title = "命中文字",
    Desc = "设置命中时显示的文字",
    Placeholder = "输入文字(空格没有文字特效)",
    Default = getgenv().HitEffectConfig.Text,
    Callback = function(value)
        getgenv().HitEffectConfig.Text = value
        WindUI:Notify({Title = "命中文字",Content = "已设置为: " .. value,Duration = 2})
    end
})
local HitEffectTextColorPicker = FlashMainTab:Colorpicker({
    Flag = "HitEffectTextColor",
    Title = "命中文字颜色",
    Desc = "设置命中文字的颜色",
    Default = getgenv().HitEffectConfig.TextColor,
    Transparency = 0,
    Callback = function(color)
        getgenv().HitEffectConfig.TextColor = color
        WindUI:Notify({Title = "颜色已更新",Content = "命中文字颜色已设置",Duration = 2})
    end
})
FlashMainTab:Slider({
    Flag = "HitEffectTextSize",
    Title = "命中文字大小",
    Desc = "调整命中文字的大小",
    Icons = {From = "minimize",To = "maximize"},
    Step = 1,
    IsTooltip = true,
    Value = {Min = 20,Max = 100,Default = getgenv().HitEffectConfig.TextSize},
    Callback = function(value)
        getgenv().HitEffectConfig.TextSize = value
        WindUI:Notify({Title = "文字大小已调整",Content = "命中文字大小设置为: " .. value,Duration = 2})
    end
})
local HitEffectColorPicker = FlashMainTab:Colorpicker({
    Flag = "HitEffectColor",
    Title = "命中特效颜色",
    Desc = "设置命中特效的主要颜色",
    Default = getgenv().HitEffectConfig.EffectColor,
    Transparency = 0,
    Callback = function(color)
        getgenv().HitEffectConfig.EffectColor = color
        WindUI:Notify({Title = "颜色已更新",Content = "命中特效颜色已设置",Duration = 2})
    end
})
FlashMainTab:Slider({
    Flag = "HitEffectSize",
    Title = "命中特效大小",
    Desc = "调整命中特效的整体大小",
    Icons = {From = "minimize",To = "maximize"},
    Step = 0.5,
    IsTooltip = true,
    Value = {Min = 1,Max = 10,Default = getgenv().HitEffectConfig.EffectSize},
    Callback = function(value)
        getgenv().HitEffectConfig.EffectSize = value
        WindUI:Notify({Title = "特效大小已调整",Content = "命中特效大小设置为: " .. value,Duration = 2})
    end
})
FlashMainTab:Slider({
    Flag = "HitEffectDuration",
    Title = "命中特效持续时间",
    Desc = "调整命中特效的显示时间",
    Icons = {From = "fast-forward",To = "clock"},
    Step = 0.5,
    IsTooltip = true,
    Value = {Min = 1,Max = 5,Default = getgenv().HitEffectConfig.Duration},
    Callback = function(value)
        getgenv().HitEffectConfig.Duration = value
        WindUI:Notify({Title = "持续时间已调整",Content = "命中特效持续时间设置为: " .. value .. "秒",Duration = 2})
    end
})
FlashMainTab:Toggle({
    Title = "显示爆炸效果",
    Desc = "开启/关闭命中时的爆炸效果",
    Default = getgenv().HitEffectConfig.ShowExplosion,
    Callback = function(value)
        getgenv().HitEffectConfig.ShowExplosion = value
        WindUI:Notify({Title = "爆炸效果",Content = value and "已启用" or "已禁用",Duration = 2})
    end
})
local ExplosionColorPicker = FlashMainTab:Colorpicker({
    Flag = "ExplosionColor",
    Title = "爆炸效果颜色",
    Desc = "设置爆炸效果的颜色",
    Default = getgenv().HitEffectConfig.ExplosionColor,
    Transparency = 0,
    Callback = function(color)
        getgenv().HitEffectConfig.ExplosionColor = color
        WindUI:Notify({Title = "颜色已更新",Content = "爆炸效果颜色已设置",Duration = 2})
    end
})
FlashMainTab:Toggle({
    Title = "显示冲击波",
    Desc = "开启/关闭命中时的冲击波效果",
    Default = getgenv().HitEffectConfig.ShowShockwave,
    Callback = function(value)
        getgenv().HitEffectConfig.ShowShockwave = value
        WindUI:Notify({Title = "冲击波效果",Content = value and "已启用" or "已禁用",Duration = 2})
    end
})
local ShockwaveColorPicker = FlashMainTab:Colorpicker({
    Flag = "ShockwaveColor",
    Title = "冲击波颜色",
    Desc = "设置冲击波效果的颜色",
    Default = getgenv().HitEffectConfig.ShockwaveColor,
    Transparency = 0,
    Callback = function(color)
        getgenv().HitEffectConfig.ShockwaveColor = color
        WindUI:Notify({Title = "颜色已更新",Content = "冲击波颜色已设置",Duration = 2})
    end
})
FlashMainTab:Space()
FlashMainTab:Section({Title = "命中特效预览",TextSize = 16,FontWeight = Enum.FontWeight.SemiBold})
FlashMainTab:Button({
    Title = "测试命中特效",
    Desc = "在当前位置生成测试命中特效",
    Justify = "Center",
    Icon = "zap",
    Callback = function()
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hitPosition = localPlayer.Character.HumanoidRootPart.Position
            local oldEffect = workspace:FindFirstChild("HitEffect_Test")
            if oldEffect then
                oldEffect:Destroy()
            end
            spawn(function()
                createHitEffect(hitPosition, localPlayer.Character)
            end)
            WindUI:Notify({Title = "测试成功",Content = "命中特效预览已生成",Duration = 3})
        else
            WindUI:Notify({Title = "错误",Content = "无法找到角色位置",Duration = 3,Color = "Red"})
        end
    end
})
FlashMainTab:Space({ Columns = 1 })
FlashMainTab:Button({
    Title = "清理所有特效",
    Desc = "清理屏幕上所有弹道和特效",
    Justify = "Center",
    Icon = "trash-2",
    Color = Color3.fromHex("#ff4830"),
    Callback = function()
        cleanupPreviousBulletTrail()
        local testTrail = workspace:FindFirstChild("BulletTestTrail")
        if testTrail then
            testTrail:Destroy()
        end
        local testEffect = workspace:FindFirstChild("HitEffect_Test")
        if testEffect then
            testEffect:Destroy()
        end
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name:find("BulletTrail") or obj.Name:find("HitEffect") then
                obj:Destroy()
            end
        end
        WindUI:Notify({Title = "清理完成",Content = "所有弹道和特效已清理",Duration = 3})
    end
})
FlashMainTab:Space({ Columns = 1 })
FlashMainTab:Button({
    Title = "重置所有设置",
    Desc = "恢复所有颜色和效果为默认值",
    Justify = "Center",
    Icon = "rotate-ccw",
    Color = Color3.fromHex("#ff4830"),
    Callback = function()
        getgenv().BulletTrailColors = {
            StartColor = Color3.fromRGB(0, 170, 255),
            EndColor = Color3.fromRGB(255, 0, 0),
            MiddleColor1 = Color3.fromRGB(255, 0, 255),
            MiddleColor2 = Color3.fromRGB(255, 255, 0)
        }
        getgenv().HitEffectConfig = {
            Enabled = true,
            Text = "XD",
            TextColor = Color3.fromRGB(255, 0, 0),
            TextSize = 50,
            EffectColor = Color3.fromRGB(255, 0, 0),
            EffectSize = 5,
            Duration = 3,
            ShowExplosion = true,
            ExplosionColor = Color3.fromRGB(255, 100, 0),
            ShowShockwave = true,
            ShockwaveColor = Color3.fromRGB(255, 200, 0)
        }
        bulletTrailOverallColor = Color3.fromRGB(255, 255, 255)
        bulletTrailSize = 0.25
        bulletTrailTransparency = 0.3
        BulletTrailOverallColorPicker:Set(Color3.fromRGB(255, 255, 255))
        BulletTrailColorStartPicker:Set(Color3.fromRGB(0, 170, 255))
        BulletTrailColorMiddle1Picker:Set(Color3.fromRGB(255, 0, 255))
        BulletTrailColorMiddle2Picker:Set(Color3.fromRGB(255, 255, 0))
        BulletTrailColorEndPicker:Set(Color3.fromRGB(255, 0, 0))
        HitEffectTextColorPicker:Set(Color3.fromRGB(255, 0, 0))
        HitEffectColorPicker:Set(Color3.fromRGB(255, 0, 0))
        ExplosionColorPicker:Set(Color3.fromRGB(255, 100, 0))
        ShockwaveColorPicker:Set(Color3.fromRGB(255, 200, 0))
        WindUI:Notify({Title = "重置完成",Content = "所有颜色和效果已恢复为默认值",Duration = 3})
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
        Title = "你可以滑到这页的最下面打开那个快速设置近距离",
        Desc = "我个人觉得这个好用些",
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