function createUI()
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local gradientColors = {
    "rgb(0, 255, 0)",
    "rgb(0, 230, 0)",
    "rgb(0, 210, 0)",
    "rgb(0, 190, 0)",
    "rgb(0, 170, 0)",
    "rgb(0, 150, 0)",
    "rgb(0, 140, 0)",
    "rgb(0, 130, 0)",
    "rgb(0, 120, 0)",
    "rgb(0, 110, 0)"
}

local username = game.Players.LocalPlayer.Name
local coloredUsername = ""
for i = 1, #username do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredUsername = coloredUsername .. '<font color="' .. gradientColors[colorIndex] .. '">' .. username:sub(i, i) .. '</font>'
end

local version = "v1"
local coloredVersion = ""
for i = 1, #version do
    local colorIndex = (i - 1) % #gradientColors + 1
    coloredVersion = coloredVersion .. '<font color="' .. gradientColors[colorIndex] .. '">' .. version:sub(i, i) .. '</font>'
end

local Confirmed = false
    local Window = WindUI:CreateWindow({
        Title = "QJ脚本-战争大亨",
        Icon = "sword",
        IconThemed = true,
        Author = "作者：琼玖",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(300, 200),
        Transparent = true,
        Theme = "Dark",
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
        Background = "https://raw.githubusercontent.com/XxwanhexxX/UN/main/preview_png.png",
        BackgroundImageTransparency = 0.5,
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
                    Text = "培根",
                    Style = "Subtle", 
                    Size = UDim2.new(1, -20, 0, 30),
                    Callback = function()
                    end
                }
            }
        }
    })

    Window:EditOpenButton({
        Title = "战争大亨付费版",
        Icon = "sword",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("00FF00")),
        Draggable = true,
    })

    task.spawn(function()
        while true do
            for hue = 0, 1, 0.01 do  
                local color = Color3.fromHSV(hue, 0.8, 1)  
                Window:EditOpenButton({
                    Color = ColorSequence.new(color)
                })
                task.wait(0.04)  
            end
        end
    end)

    local A = Window:Tab({Title = "玩家", Icon = "rbxassetid://4335480896"})
    local B = Window:Tab({Title = "透视", Icon = "eye"})
    local C = Window:Tab({Title = "传送", Icon = "rbxassetid://3944688398"})
    local D = Window:Tab({Title = "自瞄", Icon = "rbxassetid://4483345998"})
    local F = Window:Tab({Title = "攻击", Icon = "rbxassetid://4384392464"})
    local G = Window:Tab({Title = "修改", Icon = "rbxassetid://94831304996747"})
    local H = Window:Tab({Title = "内置", Icon = "settings"})
    local I = Window:Tab({Title = "自动", Icon = "rbxassetid://4450736564"})
    local infoTab = Window:Tab({Title = "通知", Icon = "layout-grid", Locked = false})

    local playerSection = A:Section({Title = "主功能", Opened = true})

    playerSection:Slider({
        Title = "视野",
        Step = 1,
        Value = {Min = 10, Max = 180, Default = workspace.CurrentCamera.FieldOfView},
        Callback = function(FOV)
            getgenv().TargetFOV = FOV
            workspace.CurrentCamera.FieldOfView = FOV
            
            if not getgenv().FOVLoop then
                getgenv().FOVLoop = game:GetService("RunService").Heartbeat:Connect(function()
                    if workspace.CurrentCamera then
                        workspace.CurrentCamera.FieldOfView = getgenv().TargetFOV
                    end
                end)
                
                game.Players.LocalPlayer.CharacterAdded:Connect(function()
                    task.wait(1)
                    if workspace.CurrentCamera then
                        workspace.CurrentCamera.FieldOfView = getgenv().TargetFOV
                    end
                end)
            end
        end
    })

    playerSection:Toggle({
        Title = "穿墙",
        Value = false,
        Callback = function(state)
            if state then
                getgenv().noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                    local LocalPlayer = game:GetService("Players").LocalPlayer
                    if LocalPlayer.Character then
                        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end)
            else
                if getgenv().noclipConnection then
                    getgenv().noclipConnection:Disconnect()
                    getgenv().noclipConnection = nil
                end
                
                local LocalPlayer = game:GetService("Players").LocalPlayer
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    })

    playerSection:Toggle({
        Title = "快速互动",
        Value = false,
        Callback = function(state)
            if state then
                local ProximityPromptService = game:GetService("ProximityPromptService")
                
                getgenv().fastInteractionConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                    prompt.HoldDuration = 0.01
                end)
                
                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0.01
                    end
                end
            else
                if getgenv().fastInteractionConnection then
                    getgenv().fastInteractionConnection:Disconnect()
                    getgenv().fastInteractionConnection = nil
                end
                
                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0.5
                    end
                end
            end
        end
    })

    playerSection:Divider({
        Text = "移动功能"
    })

    local walkSpeed = 150
    local walkMultiplier = 3
    playerSection:Toggle({
        Title = "移动开关",
        Value = false,
        Callback = function(state)
            getgenv().WalkEnabled = state
            if state then
                local function updateWalkSpeed()
                    local character = game.Players.LocalPlayer.Character
                    if character and character:FindFirstChild("Humanoid") then
                        character.Humanoid.WalkSpeed = walkSpeed * walkMultiplier
                    end
                end
                
                updateWalkSpeed()
                
                getgenv().WalkConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
                    task.wait(1)
                    updateWalkSpeed()
                end)
                
                getgenv().WalkLoop = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().WalkEnabled then
                        updateWalkSpeed()
                    end
                end)
            else
                if getgenv().WalkConnection then
                    getgenv().WalkConnection:Disconnect()
                end
                if getgenv().WalkLoop then
                    getgenv().WalkLoop:Disconnect()
                end
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.WalkSpeed = 16
                end
            end
        end
    })

    playerSection:Slider({
        Title = "移动倍率",
        Step = 0.1,
        Value = {Min = 1, Max = 10, Default = 3},
        Callback = function(multiplier)
            walkMultiplier = multiplier
            if getgenv().WalkEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed * walkMultiplier
            end
        end
    })

    playerSection:Toggle({
        Title = "跳跃高度开关",
        Value = false,
        Callback = function(state)
            getgenv().JumpHeightEnabled = state
            
            if state then
                local function updateJumpPower()
                    local character = game.Players.LocalPlayer.Character
                    if character and character:FindFirstChild("Humanoid") then
                        character.Humanoid.JumpPower = getgenv().JumpHeightValue or 50
                    end
                end
                
                updateJumpPower()
                
                getgenv().JumpConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
                    task.wait(1)
                    updateJumpPower()
                end)
                
                getgenv().JumpLoop = game:GetService("RunService").Heartbeat:Connect(function()
                    if getgenv().JumpHeightEnabled then
                        updateJumpPower()
                    end
                end)
            else
                if getgenv().JumpConnection then
                    getgenv().JumpConnection:Disconnect()
                end
                if getgenv().JumpLoop then
                    getgenv().JumpLoop:Disconnect()
                end
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid.JumpPower = 50
                end
            end
        end
    })

    playerSection:Slider({
        Title = "跳跃高度",
        Step = 1,
        Value = {Min = 50, Max = 500, Default = 100},
        Callback = function(height)
            getgenv().JumpHeightValue = height
            if getgenv().JumpHeightEnabled and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = height
            end
        end
    })

    playerSection:Divider({
        Text = "飞行功能"
    })

    local flySpeed = 150
    local flyMultiplier = 5
    playerSection:Slider({
        Title = "飞行速度",
        Step = 0.1,
        Value = {Min = 1, Max = 20, Default = 5},
        Callback = function(multiplier)
            flyMultiplier = multiplier
        end
    })

    playerSection:Toggle({
        Title = "飞行开关",
        Value = false,
        Callback = function(bak)
            getgenv().fly = bak
            if bak then
                local controlModule = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild('PlayerModule'):WaitForChild("ControlModule"))
                local character = game.Players.LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                local function setupFlight(character)
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    
                    if hrp:FindFirstChild("VelocityHandler") then hrp.VelocityHandler:Destroy() end
                    if hrp:FindFirstChild("GyroHandler") then hrp.GyroHandler:Destroy() end
                    
                    local bv = Instance.new("BodyVelocity")
                    bv.Name = "VelocityHandler"
                    bv.Parent = hrp
                    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                    bv.Velocity = Vector3.new(0, 0, 0)
                    
                    local bg = Instance.new("BodyGyro")
                    bg.Name = "GyroHandler"
                    bg.Parent = hrp
                    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                    bg.P = 1000
                    bg.D = 50
                    
                    return bv, bg
                end
                
                local bv, bg = setupFlight(character)
                
                local camera = game.Workspace.CurrentCamera
                getgenv().FlyLoop = game:GetService("RunService").RenderStepped:Connect(function()
                    local currentCharacter = game.Players.LocalPlayer.Character
                    local hrp = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
                    if currentCharacter and hrp and hrp:FindFirstChild("VelocityHandler") and hrp:FindFirstChild("GyroHandler") and getgenv().fly then
                        currentCharacter.Humanoid.PlatformStand = true
                        hrp.GyroHandler.CFrame = camera.CFrame
                        
                        local direction = controlModule:GetMoveVector()
                        local actualSpeed = flySpeed * flyMultiplier
                        
                        hrp.VelocityHandler.Velocity = Vector3.new()
                        if direction.X ~= 0 then
                            hrp.VelocityHandler.Velocity = hrp.VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * actualSpeed)
                        end
                        if direction.Z ~= 0 then
                            hrp.VelocityHandler.Velocity = hrp.VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * actualSpeed)
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                            hrp.VelocityHandler.Velocity = hrp.VelocityHandler.Velocity + Vector3.new(0, actualSpeed/2, 0)
                        end
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                            hrp.VelocityHandler.Velocity = hrp.VelocityHandler.Velocity - Vector3.new(0, actualSpeed/2, 0)
                        end
                    end
                end)
            else
                if getgenv().FlyLoop then
                    getgenv().FlyLoop:Disconnect()
                end
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    if hrp:FindFirstChild("VelocityHandler") then hrp.VelocityHandler:Destroy() end
                    if hrp:FindFirstChild("GyroHandler") then hrp.GyroHandler:Destroy() end
                    character.Humanoid.PlatformStand = false
                end
            end
        end
    })

    playerSection:Divider({
        Text = "空中行走"
    })

    playerSection:Toggle({
        Title = "空中行走开关",
        Value = false,
        Callback = function(state)
            getgenv().AirWalkEnabled = state
            
            if state then
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    getgenv().BodyPositionInstance = Instance.new("BodyPosition")
                    getgenv().BodyPositionInstance.Position = Vector3.new(hrp.Position.X, getgenv().AirWalkHeight or hrp.Position.Y, hrp.Position.Z)
                    getgenv().BodyPositionInstance.MaxForce = Vector3.new(0, 40000, 0)
                    getgenv().BodyPositionInstance.P = 10000
                    getgenv().BodyPositionInstance.Parent = hrp
                    
                    getgenv().AirWalkConnection = game.Players.LocalPlayer.CharacterAdded:Connect(function(newChar)
                        task.wait(1)
                        if getgenv().AirWalkEnabled and newChar:FindFirstChild("HumanoidRootPart") then
                            getgenv().BodyPositionInstance = Instance.new("BodyPosition")
                            getgenv().BodyPositionInstance.Position = Vector3.new(newChar.HumanoidRootPart.Position.X, getgenv().AirWalkHeight or newChar.HumanoidRootPart.Position.Y, newChar.HumanoidRootPart.Position.Z)
                            getgenv().BodyPositionInstance.MaxForce = Vector3.new(0, 40000, 0)
                            getgenv().BodyPositionInstance.Parent = newChar.HumanoidRootPart
                        end
                    end)
                    
                    getgenv().AirWalkLoop = game:GetService("RunService").Heartbeat:Connect(function()
                        if getgenv().AirWalkEnabled and character and character:FindFirstChild("HumanoidRootPart") and getgenv().BodyPositionInstance then
                            local hrp = character.HumanoidRootPart
                            getgenv().BodyPositionInstance.Position = Vector3.new(hrp.Position.X, getgenv().AirWalkHeight, hrp.Position.Z)
                        end
                    end)
                end
            else
                if getgenv().BodyPositionInstance then
                    getgenv().BodyPositionInstance:Destroy()
                    getgenv().BodyPositionInstance = nil
                end
                if getgenv().AirWalkConnection then
                    getgenv().AirWalkConnection:Disconnect()
                end
                if getgenv().AirWalkLoop then
                    getgenv().AirWalkLoop:Disconnect()
                end
            end
        end
    })

    playerSection:Slider({
        Title = "Y轴高度",
        Step = 1,
        Value = {Min = -100, Max = 500, Default = 50},
        Callback = function(height)
            getgenv().AirWalkHeight = height
            if getgenv().AirWalkEnabled and getgenv().BodyPositionInstance then
                local character = game.Players.LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local hrp = character.HumanoidRootPart
                    getgenv().BodyPositionInstance.Position = Vector3.new(hrp.Position.X, height, hrp.Position.Z)
                end
            end
        end
    })

    local espSection = B:Section({Title = "ESP设置", Opened = true})

    getgenv().ShowBox = false
    getgenv().ShowHealth = false
    getgenv().ShowName = false
    getgenv().ShowDistance = false
    getgenv().ShowTracer = false
    getgenv().TeamCheck = false
    getgenv().ShowSkeleton = false
    getgenv().ShowWeapon = false
    getgenv().ShowRadar = false

    getgenv().TracerColor = Color3.new(1, 1, 1)
    getgenv().SkeletonColor = Color3.new(0.2, 0.8, 1)
    getgenv().BoxColor = Color3.new(1, 1, 1)
    getgenv().HealthBarColor = Color3.new(0, 1, 0)
    getgenv().HealthTextColor = Color3.new(1, 1, 1)
    getgenv().NameColor = Color3.new(1, 1, 1)
    getgenv().DistanceColor = Color3.new(1, 1, 0)
    getgenv().WeaponColor = Color3.new(1, 0.5, 0)

    getgenv().BoxThickness = 1
    getgenv().TracerThickness = 1
    getgenv().SkeletonThickness = 2

    local ESPComponents = {}

    local function createESP(player)
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = getgenv().BoxColor
        box.Thickness = getgenv().BoxThickness
        box.Filled = false

        local healthBar = Drawing.new("Square")
        healthBar.Visible = false
        healthBar.Color = getgenv().HealthBarColor
        healthBar.Thickness = 1
        healthBar.Filled = true

        local healthBarBackground = Drawing.new("Square")
        healthBarBackground.Visible = false
        healthBarBackground.Color = Color3.new(0, 0, 0)
        healthBarBackground.Transparency = 0.5
        healthBarBackground.Thickness = 1
        healthBarBackground.Filled = true

        local healthBarBorder = Drawing.new("Square")
        healthBarBorder.Visible = false
        healthBarBorder.Color = Color3.new(1, 1, 1)
        healthBarBorder.Thickness = 1
        healthBarBorder.Filled = false

        local healthText = Drawing.new("Text")
        healthText.Visible = false
        healthText.Color = getgenv().HealthTextColor
        healthText.Size = 14
        healthText.Font = Drawing.Fonts.Monospace
        healthText.Outline = true
        healthText.OutlineColor = Color3.new(0, 0, 0)

        local nameText = Drawing.new("Text")
        nameText.Visible = false
        nameText.Color = getgenv().NameColor
        nameText.Size = 16
        nameText.Font = Drawing.Fonts.Monospace
        nameText.Outline = true
        nameText.OutlineColor = Color3.new(0, 0, 0)

        local distanceText = Drawing.new("Text")
        distanceText.Visible = false
        distanceText.Color = getgenv().DistanceColor
        distanceText.Size = 14
        distanceText.Font = Drawing.Fonts.Monospace
        distanceText.Outline = true
        distanceText.OutlineColor = Color3.new(0, 0, 0)

        local weaponText = Drawing.new("Text")
        weaponText.Visible = false
        weaponText.Color = getgenv().WeaponColor
        weaponText.Size = 14
        weaponText.Font = Drawing.Fonts.Monospace
        weaponText.Outline = true
        weaponText.OutlineColor = Color3.new(0, 0, 0)

        local tracer = Drawing.new("Line")
        tracer.Visible = false
        tracer.Color = getgenv().TracerColor
        tracer.Thickness = getgenv().TracerThickness

        local skeletonLines = {}
        local skeletonPoints = {}

        local function createSkeleton()
            for i = 1, 15 do
                skeletonLines[i] = Drawing.new("Line")
                skeletonLines[i].Visible = false
                skeletonLines[i].Color = getgenv().SkeletonColor
                skeletonLines[i].Thickness = getgenv().SkeletonThickness
            end

            skeletonPoints["Head"] = Drawing.new("Circle")
            skeletonPoints["Head"].Visible = false
            skeletonPoints["Head"].Color = getgenv().SkeletonColor
            skeletonPoints["Head"].Thickness = 0.1
            skeletonPoints["Head"].Filled = false
            skeletonPoints["Head"].Radius = 4
        end

        createSkeleton()

        ESPComponents[player] = {
            box = box,
            healthBar = healthBar,
            healthBarBackground = healthBarBackground,
            healthBarBorder = healthBarBorder,
            healthText = healthText,
            nameText = nameText,
            distanceText = distanceText,
            weaponText = weaponText,
            tracer = tracer,
            skeletonLines = skeletonLines,
            skeletonPoints = skeletonPoints
        }

        game:GetService("RunService").RenderStepped:Connect(function()
            local espEnabled = getgenv().ShowBox or getgenv().ShowHealth or getgenv().ShowName or 
                              getgenv().ShowDistance or getgenv().ShowTracer or getgenv().ShowSkeleton or 
                              getgenv().ShowWeapon
            
            if not espEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Humanoid") or player == game.Players.LocalPlayer then
                box.Visible = false
                healthBar.Visible = false
                healthBarBackground.Visible = false
                healthBarBorder.Visible = false
                healthText.Visible = false
                nameText.Visible = false
                distanceText.Visible = false
                weaponText.Visible = false
                tracer.Visible = false
                for _, line in pairs(skeletonLines) do
                    line.Visible = false
                end
                for _, point in pairs(skeletonPoints) do
                    point.Visible = false
                end
                return
            end

            if getgenv().TeamCheck and player.Team == game.Players.LocalPlayer.Team then
                box.Visible = false
                healthBar.Visible = false
                healthBarBackground.Visible = false
                healthBarBorder.Visible = false
                healthText.Visible = false
                nameText.Visible = false
                distanceText.Visible = false
                weaponText.Visible = false
                tracer.Visible = false
                for _, line in pairs(skeletonLines) do
                    line.Visible = false
                end
                for _, point in pairs(skeletonPoints) do
                    point.Visible = false
                end
                return
            end

            local character = player.Character
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChild("Humanoid")

            if rootPart and humanoid and humanoid.Health > 0 then
                local rootPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
                local headPos, _ = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0))
                local legPos, _ = workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))

                local weaponName = "无武器"
                for _, tool in ipairs(character:GetChildren()) do
                    if tool:IsA("Tool") then
                        weaponName = tool.Name
                        break
                    end
                end

                if getgenv().ShowBox and onScreen then
                    box.Size = Vector2.new(1000 / rootPos.Z, headPos.Y - legPos.Y)
                    box.Position = Vector2.new(rootPos.X - box.Size.X / 2, rootPos.Y - box.Size.Y / 2)
                    box.Visible = true
                else
                    box.Visible = false
                end

                if getgenv().ShowHealth and onScreen then
                    local healthPercentage = humanoid.Health / humanoid.MaxHealth
                    local barWidth = 50
                    local barHeight = 5
                    local barX = headPos.X - barWidth / 2
                    local barY = headPos.Y - 20

                    healthBarBackground.Size = Vector2.new(barWidth, barHeight)
                    healthBarBackground.Position = Vector2.new(barX, barY)
                    healthBarBackground.Visible = true

                    healthBarBorder.Size = Vector2.new(barWidth, barHeight)
                    healthBarBorder.Position = Vector2.new(barX, barY)
                    healthBarBorder.Visible = true

                    healthBar.Size = Vector2.new(barWidth * healthPercentage, barHeight)
                    healthBar.Position = Vector2.new(barX, barY)
                    healthBar.Visible = true

                    healthText.Position = Vector2.new(barX + barWidth + 5, barY - 5)
                    healthText.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                    healthText.Visible = true
                else
                    healthBar.Visible = false
                    healthBarBackground.Visible = false
                    healthBarBorder.Visible = false
                    healthText.Visible = false
                end

                if getgenv().ShowName and onScreen then
                    nameText.Position = Vector2.new(headPos.X, headPos.Y - 35)
                    nameText.Text = player.Name
                    nameText.Visible = true
                else
                    nameText.Visible = false
                end

                if getgenv().ShowWeapon and onScreen then
                    weaponText.Position = Vector2.new(headPos.X, headPos.Y - 50)
                    weaponText.Text = weaponName
                    weaponText.Visible = true
                else
                    weaponText.Visible = false
                end

                if getgenv().ShowDistance and onScreen then
                    local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    distanceText.Position = Vector2.new(headPos.X, headPos.Y + 10)
                    distanceText.Text = math.floor(distance) .. "m"
                    distanceText.Visible = true
                else
                    distanceText.Visible = false
                end

                if getgenv().ShowTracer then
                    local head = character:FindFirstChild("Head")
                    if head then
                        local headPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                        if onScreen then
                            tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y)
                            tracer.To = Vector2.new(headPos.X, headPos.Y)
                            tracer.Visible = true
                        else
                            tracer.Visible = false
                        end
                    else
                        tracer.Visible = false
                    end
                else
                    tracer.Visible = false
                end

                if getgenv().ShowSkeleton and onScreen then
                    local head = character:FindFirstChild("Head")
                    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                    local leftArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm")
                    local rightArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm")
                    local leftLeg = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftUpperLeg")
                    local rightLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightUpperLeg")
                    
                    if head and torso and leftArm and rightArm and leftLeg and rightLeg then
                        local headPos = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                        local torsoPos = workspace.CurrentCamera:WorldToViewportPoint(torso.Position)
                        local leftArmPos = workspace.CurrentCamera:WorldToViewportPoint(leftArm.Position)
                        local rightArmPos = workspace.CurrentCamera:WorldToViewportPoint(rightArm.Position)
                        local leftLegPos = workspace.CurrentCamera:WorldToViewportPoint(leftLeg.Position)
                        local rightLegPos = workspace.CurrentCamera:WorldToViewportPoint(rightLeg.Position)

                        skeletonPoints["Head"].Position = Vector2.new(headPos.X, headPos.Y)
                        skeletonPoints["Head"].Visible = true

                        skeletonLines[1].From = Vector2.new(headPos.X, headPos.Y)
                        skeletonLines[1].To = Vector2.new(torsoPos.X, torsoPos.Y)
                        skeletonLines[1].Visible = true

                        skeletonLines[2].From = Vector2.new(torsoPos.X, torsoPos.Y)
                        skeletonLines[2].To = Vector2.new(leftArmPos.X, leftArmPos.Y)
                        skeletonLines[2].Visible = true

                        skeletonLines[3].From = Vector2.new(torsoPos.X, torsoPos.Y)
                        skeletonLines[3].To = Vector2.new(rightArmPos.X, rightArmPos.Y)
                        skeletonLines[3].Visible = true

                        skeletonLines[4].From = Vector2.new(torsoPos.X, torsoPos.Y)
                        skeletonLines[4].To = Vector2.new(leftLegPos.X, leftLegPos.Y)
                        skeletonLines[4].Visible = true

                        skeletonLines[5].From = Vector2.new(torsoPos.X, torsoPos.Y)
                        skeletonLines[5].To = Vector2.new(rightLegPos.X, rightLegPos.Y)
                        skeletonLines[5].Visible = true
                    else
                        for _, line in pairs(skeletonLines) do
                            line.Visible = false
                        end
                        for _, point in pairs(skeletonPoints) do
                            point.Visible = false
                        end
                    end
                else
                    for _, line in pairs(skeletonLines) do
                        line.Visible = false
                    end
                    for _, point in pairs(skeletonPoints) do
                        point.Visible = false
                    end
                end
            else
                box.Visible = false
                healthBar.Visible = false
                healthBarBackground.Visible = false
                healthBarBorder.Visible = false
                healthText.Visible = false
                nameText.Visible = false
                distanceText.Visible = false
                weaponText.Visible = false
                tracer.Visible = false
                for _, line in pairs(skeletonLines) do
                    line.Visible = false
                end
                for _, point in pairs(skeletonPoints) do
                    point.Visible = false
                end
            end
        end)
    end

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Camera = workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer

    local radar = Drawing.new("Circle")
    radar.Visible = false
    radar.Color = Color3.new(1, 1, 1)
    radar.Thickness = 2
    radar.Filled = false
    radar.Radius = 100
    radar.Position = Vector2.new(Camera.ViewportSize.X - 120, 120)

    local radarCenter = Drawing.new("Circle")
    radarCenter.Visible = false
    radarCenter.Color = Color3.new(1, 1, 1)
    radarCenter.Thickness = 2
    radarCenter.Filled = true
    radarCenter.Radius = 3
    radarCenter.Position = radar.Position

    local radarDirection = Drawing.new("Line")
    radarDirection.Visible = false
    radarDirection.Color = Color3.new(1, 1, 1)
    radarDirection.Thickness = 2

    local radarGridLines = {}
    for i = 1, 4 do
        radarGridLines[i] = Drawing.new("Line")
        radarGridLines[i].Visible = false
        radarGridLines[i].Color = Color3.new(0.5, 0.5, 0.5)
        radarGridLines[i].Thickness = 1
    end

    local radarRangeText = Drawing.new("Text")
    radarRangeText.Visible = false
    radarRangeText.Color = Color3.new(1, 1, 1)
    radarRangeText.Size = 14
    radarRangeText.Font = Drawing.Fonts.Monospace
    radarRangeText.Outline = true
    radarRangeText.OutlineColor = Color3.new(0, 0, 0)
    radarRangeText.Text = "100m"

    local radarPlayers = {}

    local function updateRadar()
        if not getgenv().ShowRadar then
            radar.Visible = false
            radarCenter.Visible = false
            radarDirection.Visible = false
            radarRangeText.Visible = false
            
            for _, line in pairs(radarGridLines) do
                line.Visible = false
            end
            
            for _, player in pairs(radarPlayers) do
                if player.dot then player.dot.Visible = false end
                if player.direction then player.direction.Visible = false end
                if player.name then player.name.Visible = false end
            end
            return
        end

        radar.Visible = true
        radarCenter.Visible = true
        radarDirection.Visible = true
        radarRangeText.Visible = true
        
        radarRangeText.Position = Vector2.new(radar.Position.X, radar.Position.Y + radar.Radius + 5)
        
        for i = 1, 4 do
            local angle = (i-1) * math.pi / 2
            radarGridLines[i].From = radar.Position
            radarGridLines[i].To = Vector2.new(
                radar.Position.X + math.cos(angle) * radar.Radius,
                radar.Position.Y + math.sin(angle) * radar.Radius
            )
            radarGridLines[i].Visible = true
        end
        
        radarDirection.From = radar.Position
        radarDirection.To = Vector2.new(radar.Position.X, radar.Position.Y - radar.Radius)

        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
                local rootPart = player.Character.HumanoidRootPart
                local relativePosition = rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position
                
                local radarX = radar.Position.X + (relativePosition.X / 10)
                local radarY = radar.Position.Y + (relativePosition.Z / 10)
                
                local distanceFromCenter = math.sqrt((radarX - radar.Position.X)^2 + (radarY - radar.Position.Y)^2)
                
                if distanceFromCenter > radar.Radius then
                    local angle = math.atan2(radarY - radar.Position.Y, radarX - radar.Position.X)
                    radarX = radar.Position.X + math.cos(angle) * radar.Radius
                    radarY = radar.Position.Y + math.sin(angle) * radar.Radius
                end
                
                if not radarPlayers[player] then
                    radarPlayers[player] = {
                        dot = Drawing.new("Circle"),
                        direction = Drawing.new("Line"),
                        name = Drawing.new("Text")
                    }
                    
                    radarPlayers[player].dot.Thickness = 1
                    radarPlayers[player].dot.Filled = true
                    radarPlayers[player].dot.Radius = 4
                    
                    radarPlayers[player].direction.Thickness = 2
                    radarPlayers[player].direction.Visible = true
                    
                    radarPlayers[player].name.Size = 12
                    radarPlayers[player].name.Font = Drawing.Fonts.Monospace
                    radarPlayers[player].name.Outline = true
                    radarPlayers[player].name.OutlineColor = Color3.new(0, 0, 0)
                end
                
                if player.Team == LocalPlayer.Team then
                    radarPlayers[player].dot.Color = Color3.new(0, 1, 0)  
                    radarPlayers[player].direction.Color = Color3.new(0, 0.8, 0)
                    radarPlayers[player].name.Color = Color3.new(0, 1, 0)
                else
                    radarPlayers[player].dot.Color = Color3.new(1, 0, 0) 
                    radarPlayers[player].direction.Color = Color3.new(1, 0, 0)
                    radarPlayers[player].name.Color = Color3.new(1, 0, 0)
                end
                
                radarPlayers[player].dot.Position = Vector2.new(radarX, radarY)
                radarPlayers[player].dot.Visible = true
                
                local lookVector = rootPart.CFrame.LookVector
                local directionLength = 10
                radarPlayers[player].direction.From = Vector2.new(radarX, radarY)
                radarPlayers[player].direction.To = Vector2.new(
                    radarX + lookVector.X * directionLength,
                    radarY + lookVector.Z * directionLength
                )
                
                radarPlayers[player].name.Position = Vector2.new(radarX, radarY - 15)
                radarPlayers[player].name.Text = player.Name
                radarPlayers[player].name.Visible = distanceFromCenter <= radar.Radius
            elseif radarPlayers[player] then
                radarPlayers[player].dot.Visible = false
                radarPlayers[player].direction.Visible = false
                radarPlayers[player].name.Visible = false
            end
        end
        
        for player, components in pairs(radarPlayers) do
            if not Players:FindFirstChild(player.Name) then
                components.dot.Visible = false
                components.direction.Visible = false
                components.name.Visible = false
                radarPlayers[player] = nil
            end
        end
    end

    RunService.RenderStepped:Connect(updateRadar)

    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            createESP(player)
        end
    end

    game:GetService("Players").PlayerAdded:Connect(function(player)
        if player ~= game.Players.LocalPlayer then
            createESP(player)
        end
    end)

    game:GetService("Players").PlayerRemoving:Connect(function(player)
        if ESPComponents[player] then
            for _, component in pairs(ESPComponents[player]) do
                if typeof(component) == "table" then
                    for _, drawing in pairs(component) do
                        drawing:Remove()
                    end
                else
                    component:Remove()
                end
            end
            ESPComponents[player] = nil
        end
    end)

    espSection:Toggle({
        Title = "方框透视", 
        Value = false, 
        Callback = function(Value)
            getgenv().ShowBox = Value
        end
    })

    espSection:Toggle({
        Title = "血量显示", 
        Value = false, 
        Callback = function(Value)
            getgenv().ShowHealth = Value
        end
    })

    espSection:Toggle({
        Title = "名字显示", 
        Value = false, 
        Callback = function(Value)
            getgenv().ShowName = Value
        end
    })

    espSection:Toggle({
        Title = "距离显示", 
        Value = false, 
        Callback = function(Value)
            getgenv().ShowDistance = Value
        end
    })

    espSection:Toggle({
        Title = "武器显示", 
        Value = false, 
        Callback = function(Value)
            getgenv().ShowWeapon = Value
        end
    })

    espSection:Toggle({
        Title = "射线显示", 
        Value = false, 
        Callback = function(Value)
            getgenv().ShowTracer = Value
        end
    })

    espSection:Toggle({
        Title = "骨架显示", 
        Value = false, 
        Callback = function(Value)
            getgenv().ShowSkeleton = Value
        end
    })

    espSection:Toggle({
        Title = "雷达系统", 
        Value = false, 
        Callback = function(Value)
            getgenv().ShowRadar = Value
        end
    })

    espSection:Toggle({
        Title = "队友检查", 
        Value = false, 
        Callback = function(Value)
            getgenv().TeamCheck = Value
        end
    })

    local teleportSection = C:Section({Title = "基地传送", Opened = true})

    local Positions = {
        ["Alpha"] = CFrame.new(-1197, 65, -4790),
        ["Bravo"] = CFrame.new(-220, 65, -4919),
        ["Charlie"] = CFrame.new(797, 65, -4740),
        ["Delta"] = CFrame.new(2044, 65, -3984),
        ["Echo"] = CFrame.new(2742, 65, -3031),
        ["Foxtrot"] = CFrame.new(3045, 65, -1788),
        ["Golf"] = CFrame.new(3376, 65, -562),
        ["Hotel"] = CFrame.new(3290, 65, 587),
        ["Juliet"] = CFrame.new(2955, 65, 1804),
        ["Kilo"] = CFrame.new(2569, 65, 2926),
        ["Lima"] = CFrame.new(989, 65, 3419),
        ["Omega"] = CFrame.new(-319, 65, 3932),
        ["Romeo"] = CFrame.new(-1479, 65, 3722),
        ["Sierra"] = CFrame.new(-2528, 65, 2549),
        ["Tango"] = CFrame.new(-3018, 65, 1503),
        ["Victor"] = CFrame.new(-3587, 65, 634),
        ["Yankee"] = CFrame.new(-3957, 65, -287),
        ["Zulu"] = CFrame.new(-4049, 65, -1334)
    }

    local BaseList = {
        "Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", 
        "Juliet", "Kilo", "Lima", "Omega", "Romeo", "Sierra", "Tango", "Victor", 
        "Yankee", "Zulu"
    }

    local selectedBase = nil

    local function TeleportToBase(baseName)
        local position = Positions[baseName]
        if position then
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = position
                WindUI:Notify({
                    Title = "传送成功",
                    Content = "已传送到 " .. baseName .. " 基地",
                    Duration = 3,
                })
            end
        end
    end

    teleportSection:Dropdown({
        Title = "传送列表", 
        Values = BaseList, 
        Value = "", 
        Callback = function(baseName) 
            selectedBase = baseName
        end
    })

    teleportSection:Button({
        Title = "传送到目标基地",
        Callback = function()
            if selectedBase and selectedBase ~= "" then
                TeleportToBase(selectedBase)
            else
                WindUI:Notify({
                    Title = "提示",
                    Content = "请先选择一个基地",
                    Duration = 3,
                })
            end
        end
    })

    teleportSection:Divider({
        Text = "其他传送"
    })

    teleportSection:Button({
        Title = "返回基地",
        Callback = function()
            local player = game.Players.LocalPlayer
            local tycoon = workspace.Tycoon.Tycoons:FindFirstChild(player.leaderstats.Team.Value)
            if tycoon and tycoon:FindFirstChild("Essentials") and tycoon.Essentials:FindFirstChild("Spawn") then
                player.Character.HumanoidRootPart.CFrame = tycoon.Essentials.Spawn.CFrame
                WindUI:Notify({
                    Title = "传送成功",
                    Content = "已返回基地",
                    Duration = 3,
                })
            end
        end
    })

    teleportSection:Button({
        Title = "随机传送",
        Callback = function()
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local randomPos = Vector3.new(math.random(-500, 500),100,math.random(-500, 500))
                player.Character.HumanoidRootPart.CFrame = CFrame.new(randomPos)
                WindUI:Notify({
                    Title = "传送成功",
                    Content = "已随机传送",
                    Duration = 3,
                })
            end
        end
    })

    teleportSection:Button({
        Title = "捕捉点",
        Callback = function()
            local pl = game.Players.LocalPlayer.Character.HumanoidRootPart
            local location = CFrame.new(-652.087158203125, 121.78434753417969, -1259.2510986328125)
            local Humanoid = game.Players.LocalPlayer.Character.Humanoid
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(0.2)
            pl.CFrame = location
        end
    })

    teleportSection:Button({
        Title = "捕捉点高楼",
        Callback = function()
            local pl = game.Players.LocalPlayer.Character.HumanoidRootPart
            local location = CFrame.new(-216.8485565185547, 447.56982421875, -1514.64599609375)
            local Humanoid = game.Players.LocalPlayer.Character.Humanoid
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(0.2)
            pl.CFrame = location
        end
    })

    local oilTeleportSection = C:Section({Title = "油桶传送", Opened = true})

    oilTeleportSection:Button({
        Title = "传送油桶1",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local targetPart = workspace:FindFirstChild("Game Systems")
                and workspace["Game Systems"]:FindFirstChild("Warehouses")
                and workspace["Game Systems"].Warehouses:FindFirstChild("Dock Warehouse1")
                and workspace["Game Systems"].Warehouses["Dock Warehouse1"]["Oil Capture"]
                and workspace["Game Systems"].Warehouses["Dock Warehouse1"]["Oil Capture"]["Barrel Template"]
                and workspace["Game Systems"].Warehouses["Dock Warehouse1"]["Oil Capture"]["Barrel Template"].PromptPart

            if rootPart and targetPart then
                rootPart.CFrame = targetPart.CFrame
                WindUI:Notify({
                    Title = "传送成功",
                    Content = "已传送到油桶1",
                    Duration = 3,
                })
            else
                WindUI:Notify({
                    Title = "传送失败",
                    Content = "未找到油桶1",
                    Duration = 3,
                })
            end
        end
    })

    oilTeleportSection:Button({
        Title = "传送油桶2",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local targetPart = workspace:FindFirstChild("Game Systems")
                and workspace["Game Systems"]:FindFirstChild("Warehouses")
                and workspace["Game Systems"].Warehouses:FindFirstChild("Oil Rig1")
                and workspace["Game Systems"].Warehouses["Oil Rig1"]["Oil Capture"]
                and workspace["Game Systems"].Warehouses["Oil Rig1"]["Oil Capture"]["Barrel Template"]
                and workspace["Game Systems"].Warehouses["Oil Rig1"]["Oil Capture"]["Barrel Template"].PromptPart

            if rootPart and targetPart then
                rootPart.CFrame = targetPart.CFrame
                WindUI:Notify({
                    Title = "传送成功",
                    Content = "已传送到油桶2",
                    Duration = 3,
                })
            else
                WindUI:Notify({
                    Title = "传送失败",
                    Content = "未找到油桶2",
                    Duration = 3,
                })
            end
        end
    })

    oilTeleportSection:Button({
        Title = "传送油桶3",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local targetPart = workspace:FindFirstChild("Game Systems")
                and workspace["Game Systems"]:FindFirstChild("Warehouses")
                and workspace["Game Systems"].Warehouses:FindFirstChild("Oil Rig2")
                and workspace["Game Systems"].Warehouses["Oil Rig2"]["Oil Capture"]
                and workspace["Game Systems"].Warehouses["Oil Rig2"]["Oil Capture"]["Barrel Template"]
                and workspace["Game Systems"].Warehouses["Oil Rig2"]["Oil Capture"]["Barrel Template"].PromptPart

            if rootPart and targetPart then
                rootPart.CFrame = targetPart.CFrame
                WindUI:Notify({
                    Title = "传送成功",
                    Content = "已传送到油桶3",
                    Duration = 3,
                })
            else
                WindUI:Notify({
                    Title = "传送失败",
                    Content = "未找到油桶3",
                    Duration = 3,
                })
            end
        end
    })

    oilTeleportSection:Button({
        Title = "传送油桶4",
        Callback = function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            local targetPart = workspace:FindFirstChild("Game Systems")
                and workspace["Game Systems"]:FindFirstChild("Warehouses")
                and workspace["Game Systems"].Warehouses:FindFirstChild("Oil Rig3")
                and workspace["Game Systems"].Warehouses["Oil Rig3"]["Oil Capture"]
                and workspace["Game Systems"].Warehouses["Oil Rig3"]["Oil Capture"]["Barrel Template"]
                and workspace["Game Systems"].Warehouses["Oil Rig3"]["Oil Capture"]["Barrel Template"].PromptPart

            if rootPart and targetPart then
                rootPart.CFrame = targetPart.CFrame
                WindUI:Notify({
                    Title = "传送成功",
                    Content = "已传送到油桶4",
                    Duration = 3,
                })
            else
                WindUI:Notify({
                    Title = "传送失败",
                    Content = "未找到油桶4",
                    Duration = 3,
                })
            end
        end
    })

    local aimbotSection = D:Section({Title = "自瞄设置", Opened = true})

    local fov = 50
    local maxDistance = 500
    local autoAimEnabled = false
    local fovVisible = false
    local ignoreCover = false
    local aimTarget = "敌对"
    local aimPosition = "Head"
    local rainbowEnabled = false
    local fovColor = Color3.new(1, 1, 1)

    local whitelistPlayers = {}
    local playerDropdown

    local FOVring = Drawing.new("Circle")
    FOVring.Visible = false
    FOVring.Thickness = 1
    FOVring.Color = fovColor
    FOVring.Filled = false
    FOVring.Radius = fov
    FOVring.Position = workspace.CurrentCamera.ViewportSize / 2

    local function refreshPlayerList()
        local playerList = {}
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                table.insert(playerList, player.Name)
            end
        end
        playerDropdown:Refresh(playerList)
    end

    local function updateDrawings()
        FOVring.Position = workspace.CurrentCamera.ViewportSize / 2
    end

    local function lookAt(target)
        local lookVector = (target - workspace.CurrentCamera.CFrame.Position).unit
        local newCFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + lookVector)
        workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(newCFrame, 0.7)
    end

    local function getClosestPlayerInFOV(trg_part)
        local nearest = nil
        local last = math.huge
        local playerMousePos = workspace.CurrentCamera.ViewportSize / 2
        
        for _, player in ipairs(game.Players:GetPlayers()) do
            if whitelistPlayers[player.Name] then
                continue
            end
            
            if player ~= game.Players.LocalPlayer and (aimTarget == "全部" or player.Team ~= game.Players.LocalPlayer.Team) then
                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local part = character and character:FindFirstChild(trg_part)
                
                if part and humanoid and humanoid.Health > 0 then
                    local ePos, isVisible = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                    local distance = (Vector2.new(ePos.x, ePos.y) - playerMousePos).Magnitude
                    
                    if distance < last and isVisible and distance < fov then
                        if (part.Position - workspace.CurrentCamera.CFrame.Position).Magnitude <= tonumber(maxDistance) then
                            if not ignoreCover or #workspace.CurrentCamera:GetPartsObscuringTarget({part.Position}, {character, game.Players.LocalPlayer.Character}) == 0 then
                                last = distance
                                nearest = player
                            end
                        end
                    end
                end
            end
        end
        
        return nearest
    end

    game:GetService("RunService").RenderStepped:Connect(function()
        updateDrawings()
        
        if autoAimEnabled then
            local closestPlayer = getClosestPlayerInFOV(aimPosition)
            if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild(aimPosition) then
                lookAt(closestPlayer.Character[aimPosition].Position)
            end
        end
        
        if rainbowEnabled then
            local t = tick() * 2
            local r = math.abs(math.sin(t))
            local g = math.abs(math.sin(t + 2 * math.pi / 3))
            local b = math.abs(math.sin(t + 4 * math.pi / 3))
            FOVring.Color = Color3.new(r, g, b)
        end
    end)

    game.Players.PlayerAdded:Connect(function(player)
        task.wait(0.5)
        refreshPlayerList()
    end)

    game.Players.PlayerRemoving:Connect(function(player)
        task.wait(0.5)
        refreshPlayerList()
        if whitelistPlayers[player.Name] then
            whitelistPlayers[player.Name] = nil
        end
    end)

    aimbotSection:Toggle({
        Title = "玩家自瞄",
        Value = false,
        Callback = function(t)
            autoAimEnabled = t
        end
    })

    aimbotSection:Toggle({
        Title = "显示范围",
        Value = false,
        Callback = function(t)
            fovVisible = t
            FOVring.Visible = fovVisible
        end
    })

    aimbotSection:Toggle({
        Title = "掩体不瞄",
        Value = false,
        Callback = function(t)
            ignoreCover = t
        end
    })

    aimbotSection:Slider({
        Title = "自瞄范围",
        Step = 1,
        Value = {Min = 1, Max = 200, Default = 50},
        Callback = function(s)
            fov = tonumber(s)
            FOVring.Radius = fov
        end
    })

    aimbotSection:Slider({
        Title = "自瞄距离",
        Step = 1,
        Value = {Min = 1, Max = 10000, Default = 500},
        Callback = function(s)
            maxDistance = tonumber(s)
        end
    })

    aimbotSection:Slider({
        Title = "自瞄圈粗细",
        Step = 1,
        Value = {Min = 0.5, Max = 10, Default = 1},
        Callback = function(s)
            FOVring.Thickness = tonumber(s)
        end
    })

    aimbotSection:Dropdown({
        Title = "选择自瞄目标", 
        Values = {"敌对", "全部"}, 
        Value = "敌对", 
        Callback = function(value) 
            aimTarget = value 
        end
    })

    aimbotSection:Dropdown({
        Title = "选择自瞄位置", 
        Values = {"头部", "躯干"}, 
        Value = "头部", 
        Callback = function(value)
            if value == "头部" then
                aimPosition = "Head"
            elseif value == "躯干" then
                aimPosition = "Torso"
            end
        end
    })

    aimbotSection:Dropdown({
        Title = "选择圈的颜色", 
        Values = {"白", "红", "黄", "蓝", "绿", "青", "紫", "彩虹"}, 
        Value = "白", 
        Callback = function(value)
            if value == "彩虹" then
                rainbowEnabled = true
            else
                rainbowEnabled = false
                local colors = {
                    ["白"] = Color3.new(1, 1, 1),
                    ["红"] = Color3.new(1, 0, 0),
                    ["黄"] = Color3.new(1, 1, 0),
                    ["蓝"] = Color3.new(0, 0, 1),
                    ["绿"] = Color3.new(0, 1, 0),
                    ["青"] = Color3.new(0, 1, 1),
                    ["紫"] = Color3.new(1, 0, 1)
                }
                fovColor = colors[value]
                FOVring.Color = fovColor
            end
        end
    })

    playerDropdown = aimbotSection:Dropdown({
        Title = "忽略玩家(白名单)", 
        Values = {}, 
        Value = {}, 
        Multi = true, 
        AllowNone = true, 
        Callback = function(selectedPlayers) 
            whitelistPlayers = {}
            for _, playerName in ipairs(selectedPlayers) do
                whitelistPlayers[playerName] = true
            end
        end
    })

    aimbotSection:Button({
        Title = "刷新玩家列表",
        Callback = function()
            refreshPlayerList()
            WindUI:Notify({
                Title = "刷新成功",
                Content = "玩家列表已更新",
                Duration = 2,
            })
        end
    })

    refreshPlayerList()

    local attackSection = F:Section({Title = "攻击功能", Opened = true})

    local C_NPlayers = {}
    local Plr = game:GetService("Players")
    local LP = Plr.LocalPlayer
    local PlayerList = {}

    local function initializePlayerList()
        PlayerList = {}
        for _, player in ipairs(Plr:GetPlayers()) do
            if player ~= LP then
                table.insert(PlayerList, player.Name)
            end
        end
    end

    local function refreshAttackPlayerList()
        initializePlayerList()
        if excludeTargetsDropdown then
            excludeTargetsDropdown:Refresh(PlayerList)
        end
    end

    Plr.PlayerAdded:Connect(function(player)
        if player ~= LP then
            table.insert(PlayerList, player.Name)
            if excludeTargetsDropdown then
                excludeTargetsDropdown:Refresh(PlayerList)
            end
        end
    end)

    Plr.PlayerRemoving:Connect(function(player)
        local index = table.find(PlayerList, player.Name)
        if index then
            table.remove(PlayerList, index)
            local whitelistIndex = table.find(C_NPlayers, player.Name)
            if whitelistIndex then
                table.remove(C_NPlayers, whitelistIndex)
            end
            if excludeTargetsDropdown then
                excludeTargetsDropdown:Refresh(PlayerList)
            end
        end
    end)

    initializePlayerList()

    local excludeTargetsDropdown = attackSection:Dropdown({
        Title = "忽略玩家(白名单)", 
        Values = PlayerList, 
        Value = {}, 
        Multi = true, 
        AllowNone = true, 
        Callback = function(values) 
            C_NPlayers = values or {}
            WindUI:Notify({
                Title = "白名单列表",
                Content = "已设置 " .. #C_NPlayers .. " 个玩家为白名单",
                Duration = 3,
            })
        end
    })

    attackSection:Button({
        Title = "刷新玩家列表",
        Callback = function()
            refreshAttackPlayerList()
        end
    })

    attackSection:Button({
        Title = "获取RPG",
        Callback = function()
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")
            local TweenService = game:GetService("TweenService")
            local LPlayer = Players.LocalPlayer
            
            if LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local HumanoidRootPart = LPlayer.Character.HumanoidRootPart
                local initialPosition = HumanoidRootPart.CFrame
                
                local function hasRPG() 
                    return LPlayer.Backpack:FindFirstChild("RPG") or LPlayer.Character:FindFirstChild("RPG") 
                end
                
                local function findClosestRPGGiver()
                    local closestRPGGiver = nil
                    local closestDistance = math.huge
                    
                    for _, tycoon in pairs(Workspace.Tycoon.Tycoons:GetChildren()) do
                        local rpgGiver = tycoon:FindFirstChild("PurchasedObjects") and tycoon.PurchasedObjects:FindFirstChild("RPG Giver")
                        if rpgGiver and rpgGiver:FindFirstChild("Prompt") and rpgGiver.Prompt:FindFirstChild("Weapon Giver") then
                            local part = rpgGiver:FindFirstChildWhichIsA("BasePart")
                            if part then
                                local distance = (HumanoidRootPart.Position - part.Position).Magnitude
                                if distance < closestDistance then
                                    closestDistance = distance
                                    closestRPGGiver = rpgGiver
                                end
                            end
                        end
                    end
                    return closestRPGGiver
                end
                
                local function teleportTo(targetCFrame)
                    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear)
                    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
                    tween:Play()
                    tween.Completed:Wait()
                end
                
                local function activatePrompt(prompt)
                    if prompt then
                        prompt.MaxActivationDistance = 10
                        fireproximityprompt(prompt)
                    end
                end
                
                local function collectRPG()
                    local closestRPGGiver = findClosestRPGGiver()
                    if not closestRPGGiver then 
                        WindUI:Notify({
                            Title = "ERROR",
                            Content = "未能找到附近的RPG",
                            Duration = 4,
                        })
                        return 
                    end
                    
                    local part = closestRPGGiver:FindFirstChildWhichIsA("BasePart")
                    if part then
                        teleportTo(part.CFrame + Vector3.new(3, 0, 0))
                        task.wait(0.5)
                        
                        local prompt = closestRPGGiver.Prompt:FindFirstChild("Weapon Giver")
                        activatePrompt(prompt)
                        
                        local timeout = 0
                        while not hasRPG() and timeout < 50 do
                            activatePrompt(prompt)
                            task.wait(0.1)
                            timeout = timeout + 1
                        end
                        
                        if hasRPG() then
                            WindUI:Notify({
                                Title = "成功",
                                Content = "已获取RPG",
                                Duration = 3,
                            })
                        else
                            WindUI:Notify({
                                Title = "失败",
                                Content = "获取RPG超时",
                                Duration = 3,
                            })
                        end
                    end
                    teleportTo(initialPosition)
                end
                
                if not hasRPG() then 
                    collectRPG() 
                else 
                    WindUI:Notify({
                        Title = "提示",
                        Content = "已经拥有RPG",
                        Duration = 3,
                    })
                end
            end
        end
    })

    local loopActive = false
    local rpgAttackThread = nil

    attackSection:Toggle({
        Title = "RPG轰炸",
        Value = false,
        Callback = function(t)
            loopActive = t
            
            if t then
                if rpgAttackThread then
                    coroutine.close(rpgAttackThread)
                    rpgAttackThread = nil
                end
                
                rpgAttackThread = coroutine.create(function()
                    local Players = game:GetService("Players")
                    local LocalPlayer = Players.LocalPlayer
                    local ReplicatedStorage = game:GetService("ReplicatedStorage")
                    local RocketSystem = ReplicatedStorage:WaitForChild("RocketSystem")
                    local FireRocket = RocketSystem.Events.FireRocket
                    local RocketHit = RocketSystem.Events.RocketHit
                    local attackPhase = "attack"
                    local phaseStartTime = os.clock()
                    
                    while loopActive do
                        local currentTime = os.clock()
                        local elapsed = currentTime - phaseStartTime
                        
                        if not loopActive then break end
                        
                        if attackPhase == "attack" then
                            if elapsed >= 3 then
                                attackPhase = "pause"
                                phaseStartTime = os.clock()
                            else
                                local character = LocalPlayer.Character
                                if character and character:FindFirstChild("HumanoidRootPart") then
                                    local attackPosition = character.HumanoidRootPart.Position + Vector3.new(0, 1000, 0)
                                    local weapon = character:FindFirstChild("RPG")
                                    
                                    if weapon then
                                        for _, player in ipairs(Players:GetPlayers()) do
                                            if player ~= LocalPlayer and player.Character and not table.find(C_NPlayers, player.Name) then
                                                local target = player.Character:FindFirstChild("HumanoidRootPart")
                                                if target then
                                                    FireRocket:InvokeServer(Vector3.new(), weapon, weapon, attackPosition)
                                                    RocketHit:FireServer(attackPosition, Vector3.new(), weapon, weapon, target, nil, "asdfghvcqawRocket4")
                                                    task.wait(0.3)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        elseif attackPhase == "pause" then
                            if elapsed >= 2 then
                                attackPhase = "attack"
                                phaseStartTime = os.clock()
                            end
                        end
                        
                        task.wait(0.1)
                    end
                end)
                
                coroutine.resume(rpgAttackThread)
            else
                if rpgAttackThread then
                    coroutine.close(rpgAttackThread)
                    rpgAttackThread = nil
                end
            end
        end
    })

    local shieldAttackActive = false
    local shieldAttackThread = nil

    attackSection:Toggle({
        Title = "攻击护盾",
        Value = false,
        Callback = function(t)
            shieldAttackActive = t
            
            if t then
                if shieldAttackThread then
                    coroutine.close(shieldAttackThread)
                    shieldAttackThread = nil
                end
                
                shieldAttackThread = coroutine.create(function()
                    while shieldAttackActive do
                        if not shieldAttackActive then break end
                        
                        local rpg = LP.Character and LP.Character:FindFirstChild("RPG")
                        if not rpg then
                            task.wait(1)
                            continue
                        end
                        
                        local attackPosition = LP.Character.HumanoidRootPart.Position + Vector3.new(0, 1000, 0)
                        local tycoonFolder = workspace:WaitForChild("Tycoon"):WaitForChild("Tycoons")
                        
                        for _, tycoon in ipairs(tycoonFolder:GetChildren()) do
                            if not shieldAttackActive then break end
                            
                            if tycoon:FindFirstChild("Owner") and tycoon.Owner.Value ~= LP then
                                local shield = tycoon:FindFirstChild("PurchasedObjects", true) and
                                              tycoon.PurchasedObjects:FindFirstChild("Base Shield", true) and
                                              tycoon.PurchasedObjects["Base Shield"]:FindFirstChild("Shield", true) and
                                              tycoon.PurchasedObjects["Base Shield"].Shield:FindFirstChild("Shield4", true)
                                
                                if shield then
                                    local fireArgs = { Vector3.new(0, 0, 0), rpg, rpg, attackPosition }
                                    
                                    for _ = 1, 2 do
                                        local hitArgs = {attackPosition, Vector3.new(0, -1, 0), rpg, rpg, shield, nil, string.format("%sRocket%d", string.char(math.random(65, 90)), math.random(1, 1000))}
                                        RocketSystem.Events.RocketHit:FireServer(unpack(hitArgs))
                                        RocketSystem.Events.FireRocket:InvokeServer(unpack(fireArgs))
                                        task.wait(0.3)
                                    end
                                end
                            end
                        end
                        
                        task.wait(0.3)
                    end
                end)
                
                coroutine.resume(shieldAttackThread)
            else
                if shieldAttackThread then
                    coroutine.close(shieldAttackThread)
                    shieldAttackThread = nil
                end
            end
        end
    })

    local modifySection = G:Section({Title = "武器修改", Opened = true})

    modifySection:Paragraph({
        Title = "关于",
        Desc = "功能在下\n \n使用教程\n 先把你要改的枪拿手里打开无限子弹 然后给你要改的强进行换弹然后切枪三次就行了\n 死了的话或者换枪的话依旧这样",
    })

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local gunEnabled = false
    local gunConnection = nil
    local deathConnection = nil
    local originalGunData = {}

    local function modifyGuns()
        for i, v in next, getgc(false) do
            if typeof(v) == "function" then
                local info = getinfo(v)
                if tostring(info.name) == "fireGun" then
                    local gunTable = getupvalue(v, 1)
                    
                    if not originalGunData[gunTable] then
                        originalGunData[gunTable] = {}
                        for key, value in pairs(gunTable) do
                            if typeof(value) ~= "function" then
                                originalGunData[gunTable][key] = value
                            end
                        end
                        
                        for key, value in pairs(gunTable) do
                            if typeof(value) == "table" then
                                originalGunData[gunTable][key] = {}
                                for subKey, subValue in pairs(value) do
                                    originalGunData[gunTable][key][subKey] = subValue
                                end
                            end
                        end
                    end
                    
                    rawset(gunTable, "Ammo", math.huge)
                    rawset(gunTable, "Distance", math.huge)
                    rawset(gunTable, "BSpeed", 9999)
                    rawset(gunTable, "BDrop", 0)
                    rawset(gunTable, "FireRate", 2000)
                    rawset(gunTable, "MaxSpread", 0)
                    rawset(gunTable, "MinSpread", 0)
                    rawset(gunTable.FireModes, "Auto", true)
                    rawset(gunTable.FireModes, "Semi", true)
                    rawset(gunTable.FireModes, "ChangeFiremode", true)
                    rawset(gunTable, "MinRecoilPower", 0)
                    rawset(gunTable, "MaxRecoilPower", 0)
                    rawset(gunTable, "RecoilPowerStepAmount", 0)
                    rawset(gunTable, "RecoilPunch", 0)
                    rawset(gunTable, "DPunchBase", 0)
                    rawset(gunTable, "AimRecover", 1)
                    rawset(gunTable, "HPunchBase", 0)
                    rawset(gunTable, "VPunchBase", 0)
                    rawset(gunTable, "PunchRecover", 1)
                    rawset(gunTable, "SwayBase", 0)
                    rawset(gunTable, "AimRecoilReduction", math.huge)
                    
                    for key, value in next, gunTable do
                        if typeof(value) == "table" then
                            for subKey, subValue in next, value do
                                if typeof(subValue) == "number" then
                                    rawset(value, subKey, 0)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local function resetGuns()
        for gunTable, data in pairs(originalGunData) do
            for key, value in pairs(data) do
                if typeof(value) == "table" then
                    if gunTable[key] then
                        for subKey, subValue in pairs(value) do
                            rawset(gunTable[key], subKey, subValue)
                        end
                    end
                else
                    rawset(gunTable, key, value)
                end
            end
        end
        originalGunData = {}
    end

    local function onCharacterDeath()
        resetGuns()
        
        if gunEnabled then
            LocalPlayer.CharacterAdded:Wait()
            task.wait(1)
            modifyGuns()
        end
    end

    local function setupDeathListener()
        if deathConnection then
            deathConnection:Disconnect()
            deathConnection = nil
        end
        
        deathConnection = LocalPlayer.CharacterAdded:Connect(function(char)
            local humanoid = char:WaitForChild("Humanoid")
            humanoid.Died:Connect(onCharacterDeath)
        end)
        
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Died:Connect(onCharacterDeath)
            end
        end
    end

    modifySection:Toggle({
        Title = "子弹无限+射速",
        Value = false,
        Callback = function(value)
            gunEnabled = value
            
            if value then
                if LocalPlayer.Character then
                    modifyGuns()
                end
                
                setupDeathListener()
                
                if gunConnection then
                    gunConnection:Disconnect()
                end
                
                gunConnection = LocalPlayer.CharacterAdded:Connect(function()
                    if gunEnabled then
                        task.wait(1)
                        modifyGuns()
                        setupDeathListener()
                    end
                end)
            else
                resetGuns()
                
                if gunConnection then
                    gunConnection:Disconnect()
                    gunConnection = nil
                end
                
                if deathConnection then
                    deathConnection:Disconnect()
                    deathConnection = nil
                end
            end
        end
    })

    modifySection:Toggle({
        Title = "getgc改（不推荐）",
        Value = false,
        Callback = function(value)
            for _,v in next,getgc(false) do
                if typeof(v)=="function"then
                    local info=debug.getinfo(v)
                    if tostring(info.name)=="fireGun"then
                        local tab=debug.getupvalue(v,1)
                        if value then
                            rawset(tab,"Ammo",math.huge)
                            rawset(tab,"Distance",math.huge)
                            rawset(tab,"BSpeed",99999)
                            rawset(tab,"BDrop",0)
                            rawset(tab,"FireRate",2000)
                            rawset(tab,"MaxSpread",0)
                            rawset(tab,"MinSpread",0)
                            rawset(tab.FireModes,"Auto",true)
                            rawset(tab.FireModes,"Semi",true)
                            rawset(tab.FireModes,"ChangeFiremode",true)
                            rawset(tab,"MinRecoilPower",0)
                            rawset(tab,"MaxRecoilPower",0)
                            rawset(tab,"RecoilPowerStepAmount",0)
                            rawset(tab,"RecoilPunch",0)
                            rawset(tab,"DPunchBase",0)
                            rawset(tab,"AimRecover",1)
                            rawset(tab,"HPunchBase",0)
                            rawset(tab,"VPunchBase",0)
                            rawset(tab,"PunchRecover",1)
                            rawset(tab,"SwayBase",0)
                            rawset(tab,"AimRecoilReduction",math.huge)
                            for i,v in next,tab do
                                if typeof(v)=="table"then
                                    for i,v in next,v do
                                        if typeof(v)=="number"then
                                            v=0
                                        end
                                    end
                                end
                            end
                        else
                            rawset(tab,"Ammo",30)
                            rawset(tab,"Distance",100)
                            rawset(tab,"BSpeed",500)
                            rawset(tab,"BDrop",0.5)
                            rawset(tab,"FireRate",60)
                            rawset(tab,"MaxSpread",0.1)
                            rawset(tab,"MinSpread",0.05)
                            rawset(tab.FireModes,"Auto",false)
                            rawset(tab.FireModes,"Semi",true)
                            rawset(tab.FireModes,"ChangeFiremode",true)
                            rawset(tab,"MinRecoilPower",0.5)
                            rawset(tab,"MaxRecoilPower",1.5)
                            rawset(tab,"RecoilPowerStepAmount",0.1)
                            rawset(tab,"RecoilPunch",0.5)
                            rawset(tab,"DPunchBase",0.3)
                            rawset(tab,"AimRecover",0.5)
                            rawset(tab,"HPunchBase",0.2)
                            rawset(tab,"VPunchBase",0.2)
                            rawset(tab,"PunchRecover",0.5)
                            rawset(tab,"SwayBase",0.1)
                            rawset(tab,"AimRecoilReduction",0.3)
                        end
                    end
                end
            end
        end
    })

    local builtinSection = H:Section({Title = "内置功能", Opened = true})

    builtinSection:Divider({
        Text = "其他"
    })

    local blockFDMG = false
    local oldNamecall = nil
    local isHookActive = false

    local function initHook()
        if isHookActive then return end
        
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if blockFDMG and getnamecallmethod() == "FireServer" and tostring(self) == "FDMG" then
                return nil
            end
            return oldNamecall(self, ...)
        end)
        
        isHookActive = true
    end

    local function removeHook()
        if not isHookActive or not oldNamecall then return end
        
        hookmetamethod(game, "__namecall", oldNamecall)
        oldNamecall = nil
        isHookActive = false
    end

    builtinSection:Toggle({
        Title = "摔落无伤害",
        Value = false,
        Callback = function(value)
            blockFDMG = value
            
            if value then
                if not isHookActive then
                    initHook()
                end
            else
                if isHookActive then
                    removeHook()
                end
            end
        end
    })

    builtinSection:Button({
        Title = "删除所有门",
        Callback = function()
           for k,v in pairs(workspace.Tycoon.Tycoons:GetChildren()) do
                for x,y in pairs(v.PurchasedObjects:GetChildren()) do
                    if(y.Name:find("Door") or y.Name:find("Gate")) then y:destroy(); end;
                end;
            end;
        end
    })

    builtinSection:Divider()

    builtinSection:Toggle({
        Title = "死后原地重生",
        Value = false,
        Callback = function(state)
            getgenv().respawnAtDeathPosition = state
            
            local deathPosition = nil
            local deathOrientation = nil
            
            local function setupDeathTracking()
                local player = game.Players.LocalPlayer
                
                player.CharacterAdded:Connect(function(character)
                    local humanoid = character:WaitForChild("Humanoid")
                    
                    humanoid.Died:Connect(function()
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            deathPosition = rootPart.Position
                            deathOrientation = rootPart.CFrame - rootPart.Position
                        end
                    end)
                end)
                
                if player.Character then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Died:Connect(function()
                            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                deathPosition = rootPart.Position
                                deathOrientation = rootPart.CFrame - rootPart.Position
                            end
                        end)
                    end
                end
            end
            
            setupDeathTracking()
            
            game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
                if getgenv().respawnAtDeathPosition and deathPosition then
                    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
                    local humanoid = character:WaitForChild("Humanoid", 5)
                    
                    if humanoidRootPart and humanoid then
                        task.wait(0.5)
                        humanoidRootPart.CFrame = CFrame.new(deathPosition) * deathOrientation
                        deathPosition = nil
                        deathOrientation = nil
                    end
                end
            end)
        end
    })

    builtinSection:Divider()

    builtinSection:Toggle({
        Title = "删除死亡镜头",
        Value = false,
        Callback = function(kan)
            getgenv().KillCamSkipEnabled = kan
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local KillCamSkipEvent = ReplicatedStorage.Remotes:WaitForChild("KillCamSkipEvent")
            
            local function startKillCamSkip()
                while getgenv().KillCamSkipEnabled do
                    pcall(function()
                        KillCamSkipEvent:FireServer()
                    end)
                    task.wait(0.4)
                end
            end
            
            task.spawn(function()
                while true do
                    if getgenv().KillCamSkipEnabled then
                        startKillCamSkip()
                    end
                    task.wait(0.1)
                end
            end)
        end
    })

    builtinSection:Toggle({
        Title = "机枪防损坏",
        Value = false,
        Callback = function(state)
            getgenv().BlockCRAMHits = state
            
            local Players = game:GetService("Players")
            local LPlayer = Players.LocalPlayer
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local remote = ReplicatedStorage:WaitForChild("BulletFireSystem"):WaitForChild("RegisterTurretHit")
            
            local function isOwnVehicle(hitPart)
                if not hitPart then return false end
                
                local vehicleWorkspace = workspace:FindFirstChild("Game Systems"):FindFirstChild("Helicopter Workspace")
                if vehicleWorkspace and hitPart:IsDescendantOf(vehicleWorkspace) then
                    return true
                end
                return false
            end
            
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                if getgenv().BlockCRAMHits and method == "FireServer" and self == remote then
                    local turretPart = args[1] 
                    local hitData = args[4] 
                    local hitPart = hitData and hitData["hitPart"]
                    if turretPart and tostring(turretPart):find("CRAM") and isOwnVehicle(hitPart) then
                        return nil
                    end
                end
                return oldNamecall(self, ...)
            end)
        end
    })

    builtinSection:Button({
        Title = "防暴盾牌",
        Callback = function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            ReplicatedStorage.BulletFireSystem.GunReload:destroy()
            local gunReload = Instance.new("Part")
            gunReload.Name = "GunReload"
            gunReload.Parent = ReplicatedStorage.BulletFireSystem
            while true do
                task.wait(0)
                for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                    if v.ClassName == "Tool" then v.ACS_Modulo.Variaveis.Ammo.Value = 9999 end
                end
            end
        end
    })

    builtinSection:Button({
        Title = "删除视觉盔甲和头盔",
        Callback = function()
            local character = game.Players.LocalPlayer.Character
            for _, child in pairs(character:GetChildren()) do
                if child.ClassName == "Accessory" then
                    child:Destroy()
                elseif child:IsA("BasePart") then
                    if child.Name:find("Armor") then
                        if child:FindFirstChild("Mesh") then
                            child.Mesh:Destroy()
                        end
                    elseif child.Name:find("Helmet") then
                        child:Destroy()
                    end
                end
            end
        end
    })

    builtinSection:Toggle({
        Title = "获取所有玩家背包",
        Value = false,
        Callback = function(state)
            if state then
                task.spawn(function()
                    while state do
                        for i,v in pairs(game.Players:GetChildren()) do
                            task.wait()
                            for i,b in pairs(v.Backpack:GetChildren()) do
                                b.Parent = game.Players.LocalPlayer.Backpack
                                task.wait()
                            end
                        end
                    end
                end)
            end
        end
    })

    builtinSection:Button({
        Title = "重置角色",
        Callback = function()
            local player = game.Players.LocalPlayer
            if player.Character then 
                player.Character:BreakJoints() 
            end
        end
    })

    local autoSection = I:Section({Title = "自动功能", Opened = true})

    autoSection:Toggle({
        Title = "自动重生",
        Value = false,
        Callback = function(state)
            getgenv().autoRebirth = state
            task.spawn(function()
                while getgenv().autoRebirth and task.wait() do
                    pcall(function()
                        game:GetService("ReplicatedStorage").RebirthEVT:FireServer()
                    end)
                    task.wait(0.5)
                end
            end)
        end
    })

    autoSection:Button({
        Title = "自动空投",
        Callback = function()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and workspace:FindFirstChild("Game Systems") then
                for _,v in next,workspace["Game Systems"]:GetChildren() do
                    if v.Name:find("Airdrop_") and v:FindFirstChild("MainPart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.MainPart.CFrame
                        if v.MainPart:FindFirstChild("AirDropPrompt") then
                            fireproximityprompt(v.MainPart.AirDropPrompt)
                        end
                    end
                end
            end
        end
    })

    autoSection:Toggle({
        Title = "自动救人",
        Value = false,
        Callback = function(state)
            getgenv().autoRevive = state
            if state then
                local RunService = game:GetService("RunService")
                local CollectionService = game:GetService("CollectionService")

                local REVIVE_PROMPT_TAG = "RevivePromptTag"

                for _, prompt in ipairs(workspace:GetDescendants()) do
                    if prompt.Name == "RevivePrompt" then
                        CollectionService:AddTag(prompt, REVIVE_PROMPT_TAG)
                    end
                end

                workspace.DescendantAdded:Connect(function(descendant)
                    if descendant.Name == "RevivePrompt" then
                        CollectionService:AddTag(descendant, REVIVE_PROMPT_TAG)
                    end
                end)

                local function triggerPrompt(prompt)
                    if prompt.Parent then
                        fireproximityprompt(prompt)
                    end
                end

                while getgenv().autoRevive do
                    local tagged = CollectionService:GetTagged(REVIVE_PROMPT_TAG)
                    for _, prompt in ipairs(tagged) do
                        coroutine.wrap(triggerPrompt)(prompt)
                    end
                    task.wait()
                end
            end
        end
    })

    autoSection:Toggle({
        Title = "自动修电箱",
        Value = false,
        Callback = function(state)
            getgenv().autoFixGenerator = state
            if state then
                local player = game.Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()

                while getgenv().autoFixGenerator do
                    pcall(function()
                        for _, room in pairs(workspace.Rooms:GetChildren()) do
                            local interactables = room:FindFirstChild("Interactables")
                            
                            if interactables then
                                for _, generator in pairs(interactables:GetChildren()) do
                                    if generator.Name == "Generator" and generator:FindFirstChild("Fixed") and generator:FindFirstChild("RemoteFunction") and generator:FindFirstChild("RemoteEvent") then
                                        local proximityPrompt = generator.ProxyPart:FindFirstChild("ProximityPrompt")
                                        
                                        generator.RemoteFunction:InvokeServer()

                                        local distance = (character.PrimaryPart.Position - generator.ProxyPart.Position).Magnitude

                                        if distance <= proximityPrompt.MaxActivationDistance and generator.Fixed.Value < 100 then
                                            local args = {
                                                [1] = true
                                            }
                                            generator.RemoteEvent:FireServer(unpack(args))
                                        end
                                    elseif generator.Name == "EncounterGenerator" and generator:FindFirstChild("Fixed") and generator:FindFirstChild("RemoteFunction") and generator:FindFirstChild("RemoteEvent") then
                                        local proximityPrompt = generator.ProxyPart:FindFirstChild("ProximityPrompt")
                                        
                                        generator.RemoteFunction:InvokeServer()

                                        local distance = (character.PrimaryPart.Position - generator.ProxyPart.Position).Magnitude

                                        if distance <= proximityPrompt.MaxActivationDistance and generator.Fixed.Value < 100 then
                                            local args = {
                                                [1] = true
                                            }
                                            generator.RemoteEvent:FireServer(unpack(args))
                                        end
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0)
                end
            end
        end
    })

    infoTab:Select()

WindUI:Notify({
                        Title = "QJ",
                        Content = "为你启用脚本",
                        Duration = 3,
                        Icon = "alert-circle"
                    })
end
createUI()
