local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()
WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ShootEvent = ReplicatedStorage.GunRemotes:WaitForChild("ShootEvent")
local FuncReload = ReplicatedStorage.GunRemotes:WaitForChild("FuncReload")
local meleeEvent = ReplicatedStorage:WaitForChild("meleeEvent")

getgenv().TrailColors = {
    StartColor = Color3.fromRGB(200, 180, 255),
    EndColor = Color3.fromRGB(140, 100, 220),
    MiddleColor1 = Color3.fromRGB(180, 150, 240),
    MiddleColor2 = Color3.fromRGB(160, 130, 230)
}

local RagebotConfig = {
    Enabled = false,
    Prediction = true,
    PredictionAmount = 0.12,
    TeamCheck = true,
    VisibilityCheck = true,
}

local hitNotifications = {}
local notifGui = nil
local notifHolder = nil

local function setupHitUI()
    if notifGui and notifGui.Parent then return end
    notifGui = Instance.new("ScreenGui")
    notifGui.Name = "HitNotify"
    notifGui.Parent = game:GetService("CoreGui")
    notifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    notifHolder = Instance.new("Frame")
    notifHolder.Name = "Holder"
    notifHolder.Parent = notifGui
    notifHolder.BackgroundTransparency = 1
    notifHolder.Size = UDim2.new(0, 160, 1, 0)
    notifHolder.Position = UDim2.new(0.5, -80, 0, 80)
end

local function createHitNotification(playerName, healthAfter, damage)
    setupHitUI()
    local now = tick()

    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 0, 14)
    frame.Position = UDim2.new(0, 0, 0, -20)
    frame.ClipsDescendants = true
    frame.Parent = notifHolder

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 2)
    uiCorner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.Transparency = 0.4
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -6, 1, 0)
    label.Position = UDim2.new(0, 3, 0, 0)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 9
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.new(1,1,1)
    label.Text = string.format("命中:%s｜%d｜%d", playerName, healthAfter, damage)

    table.insert(hitNotifications, {
        frame = frame,
        time = now
    })

    TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0)
    }):Play()

    for i, n in ipairs(hitNotifications) do
        if n.frame and n.frame.Parent then
            local y = 16 * (i-1)
            TweenService:Create(n.frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 0, 0, y)
            }):Play()
        end
    end

    task.delay(1.5, function()
        if not frame or not frame.Parent then return end
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 25, 0, frame.Position.Y.Offset),
            Transparency = 1
        }):Play()
        task.wait(0.3)
        if frame then frame:Destroy() end
        for i, notif in ipairs(hitNotifications) do
            if notif.frame == frame then
                table.remove(hitNotifications, i)
                break
            end
        end
    end)
end

local targetCache = {
    lastUpdate = 0,
    cacheTime = 0.05,
    cachedTarget = nil
}

local function canSeeTarget(targetPart)
    if not RagebotConfig.VisibilityCheck then return true end
    local char = LocalPlayer.Character
    local localHead = char and char:FindFirstChild("Head")
    if not localHead or not targetPart then return false end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {char}
    rayParams.IgnoreWater = true

    local dir = (targetPart.Position - localHead.Position).Unit
    local dist = (targetPart.Position - localHead.Position).Magnitude
    local result = Workspace:Raycast(localHead.Position, dir * dist, rayParams)

    if not result then return true end
    local hit = result.Instance
    if hit:FindFirstAncestorOfClass("Model") and hit:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
        return true
    end
    return false
end

local function getClosestTarget()
    local now = tick()
    if now - targetCache.lastUpdate < targetCache.cacheTime and targetCache.cachedTarget then
        return targetCache.cachedTarget
    end

    local char = LocalPlayer.Character
    local localHead = char and char:FindFirstChild("Head")
    if not localHead then
        targetCache.cachedTarget = nil
        return nil
    end

    local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name or ""
    local closest = nil
    local bestDist = math.huge

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not RagebotConfig.TeamCheck then
            if (myTeam == "Inmates" and plr.Team and plr.Team.Name == "Criminals") or
               (myTeam == "Criminals" and plr.Team and plr.Team.Name == "Inmates") then
                continue
            end
        else
            if plr.Team == LocalPlayer.Team then
                continue
            end
        end

        local tchar = plr.Character
        local hum = tchar and tchar:FindFirstChild("Humanoid")
        local head = tchar and tchar:FindFirstChild("Head")
        if not hum or not head or hum.Health <= 0 then continue end
        if tchar:FindFirstChildOfClass("ForceField") then continue end

        local dist = (head.Position - localHead.Position).Magnitude
        if dist < bestDist and canSeeTarget(head) then
            bestDist = dist
            closest = head
        end
    end

    targetCache.cachedTarget = closest
    targetCache.lastUpdate = now
    return closest
end

local function getAllTargetsInRange(range)
    local targets = {}
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return targets end

    local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name or ""

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not RagebotConfig.TeamCheck then
            if (myTeam == "Inmates" and plr.Team and plr.Team.Name == "Criminals") or
               (myTeam == "Criminals" and plr.Team and plr.Team.Name == "Inmates") then
                continue
            end
        else
            if plr.Team == LocalPlayer.Team then
                continue
            end
        end

        local tchar = plr.Character
        local hum = tchar and tchar:FindFirstChild("Humanoid")
        local head = tchar and tchar:FindFirstChild("Head")
        if not hum or not head or hum.Health <= 0 then continue end

        local dist = (head.Position - hrp.Position).Magnitude
        if dist <= range and canSeeTarget(head) then
            table.insert(targets, head)
        end
    end
    return targets
end

local function createBeautifulTrail(origin, targetPos)
    local trailContainer = Instance.new("Folder")
    trailContainer.Name = "MagicTrail"
    trailContainer.Parent = Workspace

    local midPoint = (origin + targetPos) / 2
    local direction = (targetPos - origin).Unit
    local perpendicular = Vector3.new(-direction.Z, direction.Y, direction.X) * 3
    local controlPoint = midPoint + perpendicular + Vector3.new(0, math.random(-3, 3), 0)

    local function createBezierCurve(p0, p1, p2, t)
        return (1 - t)^2 * p0 + 2 * (1 - t) * t * p1 + t^2 * p2
    end

    local curvePoints = {}
    local numSegments = 20

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
        beamPart.Size = Vector3.new(0.15, 0.15, distance)
        beamPart.Anchored = true
        beamPart.CanCollide = false
        beamPart.Material = Enum.Material.Neon
        beamPart.Transparency = 0.3
        beamPart.CFrame = CFrame.new(startPoint, endPoint) * CFrame.new(0, 0, -distance / 2)
        beamPart.Parent = trailContainer

        local t = i / (#curvePoints - 1)
        local color
        if t < 0.3 then
            color = getgenv().TrailColors.StartColor
        elseif t < 0.6 then
            color = getgenv().TrailColors.MiddleColor1
        elseif t < 0.9 then
            color = getgenv().TrailColors.MiddleColor2
        else
            color = getgenv().TrailColors.EndColor
        end

        beamPart.Color = color

        local pointLight = Instance.new("PointLight")
        pointLight.Brightness = 5
        pointLight.Range = 3
        pointLight.Color = color
        pointLight.Parent = beamPart

        local particles = Instance.new("ParticleEmitter")
        particles.Size = NumberSequence.new(0.1, 0.3)
        particles.Transparency = NumberSequence.new(0.3, 0.8)
        particles.Lifetime = NumberRange.new(0.5, 1)
        particles.Rate = 50
        particles.Speed = NumberRange.new(1, 2)
        particles.VelocitySpread = 180
        particles.Color = ColorSequence.new(color)
        particles.Parent = beamPart
    end

    task.delay(1.5, function()
        if trailContainer and trailContainer.Parent then
            trailContainer:Destroy()
        end
    end)

    return trailContainer
end

local function playHitSound()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://6534948092"
    s.Volume = 0.8
    s.PlayOnRemove = true
    s.Parent = workspace
    s:Destroy()
end

local rageEnabled = false
local meleeEnabled = false
local fullAreaAttack = false
local FlyingEnabled = false
local FlightSpeed = 40
local CurrentAO, CurrentLV, CurrentMoverAttachment
local FlightConnection
local Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}

local function getControlModule()
    local PlayerModule = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")
    return require(PlayerModule:WaitForChild("ControlModule"))
end

local function setupBodyMovers(character)
    local hrp = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    local moverParent = workspace:FindFirstChildOfClass("Terrain") or workspace
    local moverAttachment = Instance.new("Attachment", hrp)
    moverAttachment.Name = "FlightAttachment"
    local alignOrientation = Instance.new('AlignOrientation')
    alignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
    alignOrientation.RigidityEnabled = true
    alignOrientation.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    alignOrientation.CFrame = hrp.CFrame
    alignOrientation.Attachment0 = moverAttachment
    alignOrientation.Parent = moverParent
    local linearVelocity = Instance.new('LinearVelocity')
    linearVelocity.VectorVelocity = Vector3.new(0, 0, 0)
    linearVelocity.MaxForce = 9e9
    linearVelocity.Attachment0 = moverAttachment
    linearVelocity.Parent = moverParent
    return alignOrientation, linearVelocity, humanoid, moverAttachment
end

local function getFlightVector(controlModule)
    local moveVector = controlModule:GetMoveVector()
    local camera = workspace.CurrentCamera
    Control.F = -moveVector.Z
    Control.B = moveVector.Z
    Control.L = -moveVector.X
    Control.R = moveVector.X
    Control.Q = moveVector.Y
    Control.E = -moveVector.Y
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then Control.F = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then Control.B = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then Control.L = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then Control.R = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Control.Q = 1 end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Control.E = 1 end
    local flightVector = (camera.CFrame.LookVector * (Control.F - Control.B) +
    camera.CFrame.RightVector * (Control.R - Control.L) +
    Vector3.new(0, 1, 0) * (Control.Q - Control.E))
    return flightVector.Magnitude > 0 and flightVector.Unit or flightVector
end

local function stopFlying()
    if not FlyingEnabled then return end
    FlyingEnabled = false
    Control = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    if FlightConnection then
        FlightConnection:Disconnect()
        FlightConnection = nil
    end
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = false
    end
    if CurrentAO then CurrentAO:Destroy() CurrentAO = nil end
    if CurrentLV then CurrentLV:Destroy() CurrentLV = nil end
    if CurrentMoverAttachment then CurrentMoverAttachment:Destroy() CurrentMoverAttachment = nil end
end
local function startFlying()
    if FlyingEnabled then return end
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if not character then return end
    FlyingEnabled = true
    if CurrentAO then CurrentAO:Destroy() end
    if CurrentLV then CurrentLV:Destroy() end
    if CurrentMoverAttachment then CurrentMoverAttachment:Destroy() end
    CurrentAO, CurrentLV, humanoid, CurrentMoverAttachment = setupBodyMovers(character)
    local controlModule = getControlModule()
    FlightConnection = RunService.Heartbeat:Connect(function()
        if not FlyingEnabled or not CurrentLV or not CurrentAO then
            if FlightConnection then
                FlightConnection:Disconnect()
                FlightConnection = nil
            end
            return
        end
        local flightVector = getFlightVector(controlModule)
        if flightVector.Magnitude > 0 then
            CurrentLV.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
            CurrentLV.VectorVelocity = flightVector * FlightSpeed
        else
            CurrentLV.VectorVelocity = Vector3.new(0, 0, 0)
        end
        CurrentAO.CFrame = workspace.CurrentCamera.CFrame
        if character.HumanoidRootPart then
            character.Humanoid.PlatformStand = true
        end
    end)
    character.AncestryChanged:Connect(function(_, parent)
        if not parent and FlyingEnabled then
            stopFlying()
        end
    end)
end


task.spawn(function()
    while task.wait(1) do
        if not rageEnabled then continue end
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then
            pcall(function() FuncReload:InvokeServer(tool) end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.01) do
        if not rageEnabled then continue end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local tool = char and char:FindFirstChildOfClass("Tool")
        if not hrp or not tool then continue end

        if fullAreaAttack then
            local targets = getAllTargetsInRange(300)
            for _, targetHead in ipairs(targets) do
                local plr = Players:GetPlayerFromCharacter(targetHead.Parent)
                local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local oldHealth = hum.Health
                    createBeautifulTrail(hrp.Position, targetHead.Position)
                    playHitSound()
                    pcall(function()
                        ShootEvent:FireServer({{hrp.Position, targetHead.Position, targetHead}})
                    end)
                    task.wait()
                    local newHealth = hum.Health
                    local dmg = math.max(0, oldHealth - newHealth)
                    if dmg > 0 then
                        createHitNotification(plr.Name, math.floor(newHealth), dmg)
                    end
                end
            end
        else
            local targetHead = getClosestTarget()
            if not targetHead then continue end
            local plr = Players:GetPlayerFromCharacter(targetHead.Parent)
            local hum = plr.Character and plr.Character:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then continue end

            local oldHealth = hum.Health
            createBeautifulTrail(hrp.Position, targetHead.Position)
            playHitSound()

            pcall(function()
                ShootEvent:FireServer({{hrp.Position, targetHead.Position, targetHead}})
            end)

            task.wait()
            local newHealth = hum.Health
            local dmg = math.max(0, oldHealth - newHealth)
            if dmg > 0 then
                createHitNotification(plr.Name, math.floor(newHealth), dmg)
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        if not meleeEnabled then return end
        local targetHead = (function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return nil end
            local best, bestDist = nil, math.huge
            local myTeam = LocalPlayer.Team and LocalPlayer.Team.Name or ""
            for _, plr in pairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                if not RagebotConfig.TeamCheck then
                    if (myTeam == "Inmates" and plr.Team and plr.Team.Name == "Criminals") or
                       (myTeam == "Criminals" and plr.Team and plr.Team.Name == "Inmates") then
                        continue
                    end
                else
                    if plr.Team == LocalPlayer.Team then
                        continue
                    end
                end
                local tchar = plr.Character
                local hum = tchar and tchar:FindFirstChild("Humanoid")
                local head = tchar and tchar:FindFirstChild("Head")
                if not hum or not head or hum.Health <=0 then continue end
                local d = (head.Position - hrp.Position).Magnitude
                if d < bestDist and d <= 15 then
                    bestDist = d
                    best = head
                end
            end
            return best
        end)()
        if targetHead then
            local tplr = Players:GetPlayerFromCharacter(targetHead.Parent)
            pcall(function()
                meleeEvent:FireServer(tplr, 1, 1)
            end)
        end
    end
end)

local function deleteDoors()
    local doors = workspace:FindFirstChild("Doors")
    if doors then
        for _, d in pairs(doors:GetChildren()) do d:Destroy() end
    end
end

local tpPoints = {
    {Name = "霰弹枪", Pos = Vector3.new(820.15, 101.00, 2229.14)},
    {Name = "MP5", Pos = Vector3.new(813.54, 101.00, 2229.53)},
    {Name = "警卫室", Pos = Vector3.new(503.83, 102.04, 2242.89)},
    {Name = "大门", Pos = Vector3.new(475.22, 98.04, 2219.95)},
    {Name = "罪犯复活点", Pos = Vector3.new(-973.12, 108.32, 2064.72)},
    {Name = "罪犯霰弹枪", Pos = Vector3.new(-939.44, 94.31, 2038.59)},
    {Name = "车", Pos = Vector3.new(-909.77, 95.33, 2165.09)},
    {Name = "AK47(容易封号)", Pos = Vector3.new(-931.51, 94.37, 2039.19)},
}

local VisualModule = {
    ESP = {
        Enabled = false,
        Box = true,
        Name = true,
        Distance = true,
        Health = true,
        Tool = true,
        Team = true,
        TeamColor = false,
        MaxDistance = 2000,
        BoxColor = Color3.new(1, 1, 1),
        NameColor = Color3.new(1, 1, 1),
        DistanceColor = Color3.new(1, 1, 1),
        HealthColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 50, 50),
        FriendColor = Color3.fromRGB(0, 150, 255),
        TextSize = 8
    }
}

local function InitializeVisuals()
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local CoreGui = game:GetService("CoreGui")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera

    local l_1 = Players
    local l_4 = RunService
    local l_7 = CoreGui
    local l_8 = LocalPlayer
    local Camera = Camera

    local function vc()
        local v2 = "Font_" .. tostring(math.random(10000, 99999))
        local v24 = "Folder_" .. tostring(math.random(10000, 99999))
        if isfolder("UI_Fonts") then delfolder("UI_Fonts") end
        makefolder(v24)
        local v3 = v24 .. "/" .. v2 .. ".ttf"
        local v4 = v24 .. "/" .. v2 .. ".json"

        local success, body = pcall(function()
            return game:HttpGet("https://github.com/i77lhm/storage/blob/main/fonts/smallest_pixel-7.ttf?raw=true")
        end)

        if success then
            writefile(v3, body)
        else
            return Font.fromEnum(Enum.Font.Code)
        end

        local v16 = {
            name = v2,
            faces = {{
                name = "Regular",
                weight = 400,
                style = "Normal",
                assetId = getcustomasset(v3)
            }}
        }
        writefile(v4, game:GetService("HttpService"):JSONEncode(v16))
        VisualModule.Font = Font.new(getcustomasset(v4))
    end

    vc()

    local espParts = {}
    local connections = {}
    local espDrawings = {}

    local function createESP(player)
        if player == l_8 then return end
        if espDrawings[player] then return end

        local box = Drawing.new("Square")
        box.Visible = false
        box.Thickness = 1
        box.Filled = false
        box.Color = VisualModule.ESP.BoxColor
        box.Transparency = 1

        local sg = Instance.new("ScreenGui")
        sg.Name = player.Name .. "_ESP"
        sg.IgnoreGuiInset = true
        sg.Parent = l_7

        local infoLabel = Instance.new("TextLabel")
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextColor3 = VisualModule.ESP.NameColor
        infoLabel.FontFace = VisualModule.Font or Font.fromEnum(Enum.Font.Code)
        infoLabel.TextSize = VisualModule.ESP.TextSize
        infoLabel.TextStrokeTransparency = 0
        infoLabel.Parent = sg

        local distLabel = Instance.new("TextLabel")
        distLabel.BackgroundTransparency = 1
        distLabel.TextColor3 = VisualModule.ESP.DistanceColor
        distLabel.FontFace = VisualModule.Font or Font.fromEnum(Enum.Font.Code)
        distLabel.TextSize = VisualModule.ESP.TextSize
        distLabel.TextStrokeTransparency = 0
        distLabel.Parent = sg

        local healthOutline = Instance.new("Frame")
        healthOutline.BackgroundColor3 = Color3.new(0, 0, 0)
        healthOutline.BorderSizePixel = 1
        healthOutline.BorderColor3 = Color3.new(0, 0, 0)
        healthOutline.Visible = false
        healthOutline.Parent = sg

        local healthFill = Instance.new("Frame")
        healthFill.BorderSizePixel = 0
        healthFill.Size = UDim2.new(1, 0, 1, 0)
        healthFill.Parent = healthOutline

        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 0)),
            ColorSequenceKeypoint.new(1, VisualModule.ESP.HealthColor)
        })
        gradient.Rotation = -90
        gradient.Parent = healthFill

        local connection
        connection = l_4.RenderStepped:Connect(function()
            if not VisualModule.ESP.Enabled then
                box.Visible = false
                infoLabel.Visible = false
                distLabel.Visible = false
                healthOutline.Visible = false
                return
            end

            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChild("Humanoid")

            if hrp and hum and hum.Health > 0 then
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                if dist > VisualModule.ESP.MaxDistance then
                    box.Visible = false
                    infoLabel.Visible = false
                    distLabel.Visible = false
                    healthOutline.Visible = false
                    return
                end

                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local sizeX, sizeY = 400/dist, 700/dist
                    local topY = pos.Y - sizeY/2
                    local bottomY = pos.Y + sizeY/2
                    local tool = char:FindFirstChildOfClass("Tool")
                    local toolName = tool and tool.Name or "None"
                    local teamName = player.Team and player.Team.Name or "无队伍"

                    box.Visible = VisualModule.ESP.Box
                    box.Position = Vector2.new(pos.X - sizeX/2, topY)
                    box.Size = Vector2.new(sizeX, sizeY)

                    if VisualModule.ESP.TeamColor then
                        if player.Team == l_8.Team then
                            box.Color = VisualModule.ESP.FriendColor
                            infoLabel.TextColor3 = VisualModule.ESP.FriendColor
                            distLabel.TextColor3 = VisualModule.ESP.FriendColor
                        else
                            box.Color = VisualModule.ESP.EnemyColor
                            infoLabel.TextColor3 = VisualModule.ESP.EnemyColor
                            distLabel.TextColor3 = VisualModule.ESP.EnemyColor
                        end
                    else
                        box.Color = VisualModule.ESP.BoxColor
                        infoLabel.TextColor3 = VisualModule.ESP.NameColor
                        distLabel.TextColor3 = VisualModule.ESP.DistanceColor
                    end

                    infoLabel.Visible = VisualModule.ESP.Name or VisualModule.ESP.Team
                    local displayText = player.Name
                    if VisualModule.ESP.Team then
                        displayText = displayText .. " [" .. teamName .. "]"
                    end
                    if VisualModule.ESP.Tool then
                        displayText = displayText .. " [" .. toolName .. "]"
                    end
                    infoLabel.Text = displayText
                    infoLabel.Position = UDim2.new(0, pos.X, 0, topY - 12)

                    distLabel.Visible = VisualModule.ESP.Distance
                    distLabel.Text = math.floor(dist) .. "ft"
                    distLabel.Position = UDim2.new(0, pos.X, 0, bottomY + 3)

                    healthOutline.Visible = VisualModule.ESP.Health
                    healthOutline.Position = UDim2.new(0, (pos.X - sizeX/2) - 2, 0, topY)
                    healthOutline.Size = UDim2.new(0, 1, 0, sizeY)

                    local hpPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    healthFill.Size = UDim2.new(1, 0, hpPercent, 0)
                    healthFill.Position = UDim2.new(0, 0, 1 - hpPercent, 0)
                    return
                end
            end
            box.Visible = false
            infoLabel.Visible = false
            distLabel.Visible = false
            healthOutline.Visible = false
        end)

        espDrawings[player] = {
            box = box,
            gui = sg,
            infoLabel = infoLabel,
            distLabel = distLabel,
            healthOutline = healthOutline,
            connection = connection
        }

        player.AncestryChanged:Connect(function()
            if not player:IsDescendantOf(l_1) then
                if espDrawings[player] then
                    espDrawings[player].box:Remove()
                    espDrawings[player].gui:Destroy()
                    espDrawings[player].connection:Disconnect()
                    espDrawings[player] = nil
                end
            end
        end)
    end

    local function onPlayerAdded(player)
        if player ~= LocalPlayer then
            local function characterAdded(character)
                task.wait(1)
                createESP(player)
            end

            if player.Character then
                characterAdded(player.Character)
            end

            table.insert(connections, player.CharacterAdded:Connect(characterAdded))
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        onPlayerAdded(player)
    end

    table.insert(connections, Players.PlayerAdded:Connect(onPlayerAdded))

    table.insert(connections, Players.PlayerRemoving:Connect(function(player)
        if espDrawings[player] then
            espDrawings[player].box:Remove()
            espDrawings[player].gui:Destroy()
            espDrawings[player].connection:Disconnect()
            espDrawings[player] = nil
        end
    end))

    local function cleanup()
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end

        for player, drawing in pairs(espDrawings) do
            drawing.box:Remove()
            drawing.gui:Destroy()
            drawing.connection:Disconnect()
        end
    end

    return cleanup
end

local cleanupVisuals = InitializeVisuals()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-监狱人生",
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
    Title = "QJ脚本-监狱人生",
    Icon = "sword",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    Draggable = true
})

local Tab = Window:Tab({ Title = "暴力杀戮", Icon = "crown" })
local Tab1 = Window:Tab({ Title = "ESP", Icon = "crown"})
Tab:Toggle({
    Title = "ragebot",
    Default = false,
    Callback = function(s)
        rageEnabled = s
    end
})

Tab:Toggle({
    Title = "攻击多个目标",
    Default = false,
    Callback = function(v)
        fullAreaAttack = v
    end
})

Tab:Toggle({
    Title = "预测目标玩家",
    Default = RagebotConfig.Prediction,
    Callback = function(v)
        RagebotConfig.Prediction = v
    end
})

Tab:Toggle({
    Title = "团队检查",
    Default = RagebotConfig.TeamCheck,
    Callback = function(v)
        RagebotConfig.TeamCheck = v
        targetCache.cachedTarget = nil
    end
})

Tab:Toggle({
    Title = "可见性检查",
    Default = RagebotConfig.VisibilityCheck,
    Callback = function(v)
        RagebotConfig.VisibilityCheck = v
        targetCache.cachedTarget = nil
    end
})

Tab:Toggle({
    Title = "拳头光环",
    Default = false,
    Callback = function(s)
        meleeEnabled = s
    end
})

Tab:Toggle({
    Title = "启用飞行",
    Default = false,
    Callback = function(v)
        if v then startFlying() else stopFlying() end
    end
})

local pointNames = {}
for _, p in ipairs(tpPoints) do
    table.insert(pointNames, p.Name)
end

Tab:Dropdown({
    Title = "传送",
    Values = pointNames,
    AllowNone = true,
    Callback = function(opt)
        if not opt then return end
        for _, p in ipairs(tpPoints) do
            if p.Name == opt then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = CFrame.new(p.Pos)
                end
                break
            end
        end
    end
})

Tab:Button({ Title = "删除所有门", Callback = deleteDoors })

local ESPSection = Tab1:Section({ Title = "ESP", Icon = "box" })
ESPSection:Toggle({
    Title = "启用ESP",
    Default = false,
    Callback = function(v)
        VisualModule.ESP.Enabled = v
    end
})
ESPSection:Toggle({
    Title = "显示方框",
    Default = VisualModule.ESP.Box,
    Callback = function(v)
        VisualModule.ESP.Box = v
    end
})
ESPSection:Toggle({
    Title = "显示名称",
    Default = VisualModule.ESP.Name,
    Callback = function(v)
        VisualModule.ESP.Name = v
    end
})
ESPSection:Toggle({
    Title = "显示队伍",
    Default = VisualModule.ESP.Team,
    Callback = function(v)
        VisualModule.ESP.Team = v
    end
})
ESPSection:Toggle({
    Title = "显示距离",
    Default = VisualModule.ESP.Distance,
    Callback = function(v)
        VisualModule.ESP.Distance = v
    end
})
ESPSection:Toggle({
    Title = "显示血量",
    Default = VisualModule.ESP.Health,
    Callback = function(v)
        VisualModule.ESP.Health = v
    end
})
ESPSection:Toggle({
    Title = "显示武器",
    Default = VisualModule.ESP.Tool,
    Callback = function(v)
        VisualModule.ESP.Tool = v
    end
})
ESPSection:Toggle({
    Title = "队伍颜色",
    Default = VisualModule.ESP.TeamColor,
    Callback = function(v)
        VisualModule.ESP.TeamColor = v
    end
})