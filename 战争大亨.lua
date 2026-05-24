local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本",
    Icon = "rbxassetid://1279310654146347060",
    IconTransparency = 0.5,
    IconThemed = true,
    Author = "作者:琼玖",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(400, 300),
    Transparent = true,
    Theme = "Light",
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
    Title = "战争大亨",
    Icon = "sword",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    Draggable = true
})

-- ================ ？？？ ================
local Tabs = {
    Main = Window:Section({ Title = "通用", Opened = true }),
    gn = Window:Section({ Title = "功能", Opened = true }),    
}

local TabHandles = {
    Q = Tabs.Main:Tab({ Title = "传送", Icon = "cctv" }),
    W = Tabs.Main:Tab({ Title = "透视", Icon = "fullscreen" }),
    E = Tabs.gn:Tab({ Title = "功能", Icon = "list-collapse" }),
    R = Tabs.gn:Tab({ Title = "自瞄或子追", Icon = "circle-dashed" }),
    T = Tabs.gn:Tab({ Title = "RPG", Icon = "database" }),
    Y = Tabs.gn:Tab({ Title = "车子功能", Icon = "bus" }),
}
-- ================      ================

-- ================ 传送基地 ================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local PlayerList = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LP then
        PlayerList[#PlayerList + 1] = player.Name
    end
end

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

Dropdown = TabHandles.Q:Dropdown({
    Title = "传送基地", 
    Values = {"Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Golf", "Hotel", "Juliet", "Kilo", "Lima", "Omega", "Romeo", "Sierra", "Tango", "Victor", "Yankee", "Zulu"}, 
    Value = "Alpha", 
    Callback = function(d) 
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character:FindFirstChild("HumanoidRootPart").CFrame = Positions[d]
        end
    end
})

local function GetAvailableBases()
    local bases = {}
    if not ExcludedBases then
        ExcludedBases = {}
    end
    if not workspace:FindFirstChild("Tycoon") or not workspace.Tycoon:FindFirstChild("Tycoons") then
        warn("Tycoon or Tycoons folder not found")
        return bases
    end
    
    local tycoons = workspace.Tycoon.Tycoons:GetChildren()
    for _, tycoon in ipairs(tycoons) do
        if not table.find(ExcludedBases, tycoon.Name) then
            table.insert(bases, tycoon.Name)
        end
    end
    
    return bases
end
-- ================ 基地白名单 ================
-- =  =
Dropdown = TabHandles.Q:Dropdown({
    Title = "基地白名单{排除列表}", 
    Values = GetAvailableBases(), 
    Multi = true, 
    Default = {}, 
    Callback = function(Values) 
        ExcludedBases = Values 
    end
})

-- ================ 刷新基地列表 ================
-- =  =
Button = TabHandles.Q:Button({
    Title = "刷新基地列表",
    Desc = "",
    Locked = false,
    Callback = function()
    BasesDropdown:Refresh(GetAvailableBases())
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})
-- ================ 自动偷别人箱子 ================
Button = TabHandles.Q:Button({
    Title = "自动偷箱子",
    Desc = "",
    Icon = "database",
    Locked = false,
    Callback = function(value)
        getgenv().auto = value
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})
-- ================ 自动升级自己的房子 ================
-- = 而不是别人 =
Button = TabHandles.Q:Button({
    Title = "自动升级",
    Desc = "",
    Icon = "bell",
    Locked = false,
    Callback = function(value)
        getgenv().autoTeleport = value
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

-- ================ 透视0 ================
-- =  =
getgenv().ESPEnabled = false
getgenv().ShowBox = false
getgenv().ShowHealth = false
getgenv().ShowName = false
getgenv().ShowDistance = false
getgenv().ShowTracer = false
getgenv().TeamCheck = false
getgenv().ShowSkeleton = false
getgenv().ShowRadar = false
getgenv().ShowPlayerCount = false
getgenv().ShowWeapon = false
getgenv().ShowFOV = false
getgenv().OutOfViewArrows = false
getgenv().Chams = false

getgenv().TracerColor = Color3.new(1, 0, 0)
getgenv().SkeletonColor = Color3.new(0.2, 0.8, 1)
getgenv().BoxColor = Color3.new(1, 1, 1)
getgenv().HealthBarColor = Color3.new(0, 1, 0)
getgenv().HealthTextColor = Color3.new(1, 1, 1)
getgenv().NameColor = Color3.new(1, 1, 1)
getgenv().DistanceColor = Color3.new(1, 1, 0)
getgenv().WeaponColor = Color3.new(1, 0.5, 0)
getgenv().ArrowColor = Color3.new(1, 0, 0)
getgenv().FOVColor = Color3.new(1, 1, 1)
getgenv().ChamsColor = Color3.new(1, 0, 0)

getgenv().BoxThickness = 1
getgenv().TracerThickness = 1
getgenv().SkeletonThickness = 2
getgenv().FOVRadius = 100
getgenv().ArrowSize = 15

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function getGradientColor(time)
    local r = math.sin(time * 2) * 0.5 + 0.5
    local g = math.sin(time * 3) * 0.5 + 0.5
    local b = math.sin(time * 4) * 0.5 + 0.5
    return Color3.new(r, g, b)
end

local playerCountText = Drawing.new("Text")
playerCountText.Visible = false
playerCountText.Color = Color3.new(1, 1, 1)
playerCountText.Size = 20
playerCountText.Font = Drawing.Fonts.Monospace
playerCountText.Outline = true
playerCountText.OutlineColor = Color3.new(0, 0, 0)
playerCountText.Position = Vector2.new(Camera.ViewportSize.X / 2, 10)

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Color = getgenv().FOVColor
fovCircle.Thickness = 1
fovCircle.Filled = false
fovCircle.Radius = getgenv().FOVRadius
fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local function updatePlayerCount()
    local playerCount = #Players:GetPlayers()
    playerCountText.Text = "在线玩家: " .. playerCount
    playerCountText.Visible = getgenv().ESPEnabled and getgenv().ShowPlayerCount

    local time = tick()
    playerCountText.Color = getGradientColor(time)
end

local function updateFOV()
    fovCircle.Visible = getgenv().ShowFOV
    fovCircle.Color = getgenv().FOVColor
    fovCircle.Radius = getgenv().FOVRadius
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

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

    local arrow = Drawing.new("Triangle")
    arrow.Visible = false
    arrow.Color = getgenv().ArrowColor
    arrow.Filled = true
    arrow.Thickness = 1

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
        skeletonPoints["Head"].Color = Color3.new(1, 0.5, 0)
        skeletonPoints["Head"].Thickness = 2
        skeletonPoints["Head"].Filled = true
        skeletonPoints["Head"].Radius = 4
    end

    createSkeleton()

    local lastHealth = 100
    local healthChangeTime = 0
    local smoothHealth = 100

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
        arrow = arrow,
        skeletonLines = skeletonLines,
        skeletonPoints = skeletonPoints
    }

    RunService.RenderStepped:Connect(function()
        if not getgenv().ESPEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character:FindFirstChild("Humanoid") or player == LocalPlayer then
            box.Visible = false
            healthBar.Visible = false
            healthBarBackground.Visible = false
            healthBarBorder.Visible = false
            healthText.Visible = false
            nameText.Visible = false
            distanceText.Visible = false
            weaponText.Visible = false
            tracer.Visible = false
            arrow.Visible = false
            for _, line in pairs(skeletonLines) do
                line.Visible = false
            end
            for _, point in pairs(skeletonPoints) do
                point.Visible = false
            end
            return
        end

        if getgenv().TeamCheck and player.Team == LocalPlayer.Team then
            box.Visible = false
            healthBar.Visible = false
            healthBarBackground.Visible = false
            healthBarBorder.Visible = false
            healthText.Visible = false
            nameText.Visible = false
            distanceText.Visible = false
            weaponText.Visible = false
            tracer.Visible = false
            arrow.Visible = false
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
            local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            local headPos, _ = Camera:WorldToViewportPoint(rootPart.Position + Vector3.new(0, 3, 0))
            local legPos, _ = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))

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
                box.Color = getgenv().BoxColor
                box.Thickness = getgenv().BoxThickness
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

                smoothHealth = smoothHealth + (humanoid.Health - smoothHealth) * 0.1
                local smoothHealthPercentage = smoothHealth / humanoid.MaxHealth

                healthBar.Size = Vector2.new(barWidth * smoothHealthPercentage, barHeight)
                healthBar.Position = Vector2.new(barX, barY)

                if smoothHealthPercentage >= 0.8 then
                    healthBar.Color = Color3.new(0, 1, 0)
                elseif smoothHealthPercentage >= 0.5 then
                    healthBar.Color = Color3.new(1, 1, 0)
                elseif smoothHealthPercentage >= 0.2 then
                    healthBar.Color = Color3.new(1, 0.5, 0)
                else
                    healthBar.Color = Color3.new(1, 0, 0)
                end

                healthBar.Visible = true

                if humanoid.Health ~= lastHealth then
                    healthChangeTime = tick()
                    lastHealth = humanoid.Health
                end

                if tick() - healthChangeTime < 0.5 then
                    healthBar.Color = Color3.new(1, 0, 0)
                end

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

                if getgenv().ShowDistance then
                    local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    distanceText.Position = Vector2.new(headPos.X, headPos.Y + 10)
                    distanceText.Text = math.floor(distance) .. "m"
                    distanceText.Visible = true
                else
                    distanceText.Visible = false
                end

                if getgenv().ShowWeapon then
                    weaponText.Position = Vector2.new(headPos.X, headPos.Y - 50)
                    weaponText.Text = weaponName
                    weaponText.Visible = true
                else
                    weaponText.Visible = false
                end
            else
                nameText.Visible = false
                distanceText.Visible = false
                weaponText.Visible = false
            end

            if getgenv().ShowTracer then
                local head = character:FindFirstChild("Head")
                if head then
                    local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        tracer.To = Vector2.new(headPos.X, headPos.Y)
                        tracer.Visible = true
                        tracer.Color = getgenv().TracerColor
                        tracer.Thickness = getgenv().TracerThickness
                        
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                        if distance < 20 then
                            tracer.Color = Color3.new(0, 1, 0)
                        elseif distance < 50 then
                            tracer.Color = Color3.new(1, 1, 0) 
                        else
                            tracer.Color = getgenv().TracerColor 
                        end
                    else
                        tracer.Visible = false
                    end
                else
                    tracer.Visible = false
                end
            else
                tracer.Visible = false
            end

            if getgenv().OutOfViewArrows and not onScreen then
                local direction = (rootPart.Position - Camera.CFrame.Position).Unit
                local dotProduct = Camera.CFrame.RightVector:Dot(direction)
                local crossProduct = Camera.CFrame.RightVector:Cross(direction)
                
                local screenPosition = Vector2.new(
                    Camera.ViewportSize.X / 2 + dotProduct * Camera.ViewportSize.X / 3,
                    Camera.ViewportSize.Y / 2 - crossProduct.Y * Camera.ViewportSize.Y / 3
                )
                
                screenPosition = Vector2.new(
                    math.clamp(screenPosition.X, getgenv().ArrowSize, Camera.ViewportSize.X - getgenv().ArrowSize),
                    math.clamp(screenPosition.Y, getgenv().ArrowSize, Camera.ViewportSize.Y - getgenv().ArrowSize)
                )
                
                local angle = math.atan2(screenPosition.Y - Camera.ViewportSize.Y / 2, screenPosition.X - Camera.ViewportSize.X / 2)
                
                arrow.PointA = screenPosition
                arrow.PointB = Vector2.new(
                    screenPosition.X - getgenv().ArrowSize * math.cos(angle - 0.5),
                    screenPosition.Y - getgenv().ArrowSize * math.sin(angle - 0.5)
                )
                arrow.PointC = Vector2.new(
                    screenPosition.X - getgenv().ArrowSize * math.cos(angle + 0.5),
                    screenPosition.Y - getgenv().ArrowSize * math.sin(angle + 0.5)
                )
                
                arrow.Color = getgenv().ArrowColor
                arrow.Visible = true
            else
                arrow.Visible = false
            end

            if getgenv().ShowSkeleton and onScreen then
                local head = character:FindFirstChild("Head")
                local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                local leftArm = character:FindFirstChild("Left Arm") or character:FindFirstChild("LeftUpperArm")
                local rightArm = character:FindFirstChild("Right Arm") or character:FindFirstChild("RightUpperArm")
                local leftLeg = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftUpperLeg")
                local rightLeg = character:FindFirstChild("Right Leg") or character:FindFirstChild("RightUpperLeg")
                
                if head and torso and leftArm and rightArm and leftLeg and rightLeg then
                    local headPos = Camera:WorldToViewportPoint(head.Position)
                    local torsoPos = Camera:WorldToViewportPoint(torso.Position)
                    local leftArmPos = Camera:WorldToViewportPoint(leftArm.Position)
                    local rightArmPos = Camera:WorldToViewportPoint(rightArm.Position)
                    local leftLegPos = Camera:WorldToViewportPoint(leftLeg.Position)
                    local rightLegPos = Camera:WorldToViewportPoint(rightLeg.Position)

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

                    if character:FindFirstChild("LeftLowerArm") then
                        local leftLowerArmPos = Camera:WorldToViewportPoint(character.LeftLowerArm.Position)
                        skeletonLines[6].From = Vector2.new(leftArmPos.X, leftArmPos.Y)
                        skeletonLines[6].To = Vector2.new(leftLowerArmPos.X, leftLowerArmPos.Y)
                        skeletonLines[6].Visible = true
                    end

                    if character:FindFirstChild("RightLowerArm") then
                        local rightLowerArmPos = Camera:WorldToViewportPoint(character.RightLowerArm.Position)
                        skeletonLines[7].From = Vector2.new(rightArmPos.X, rightArmPos.Y)
                        skeletonLines[7].To = Vector2.new(rightLowerArmPos.X, rightLowerArmPos.Y)
                        skeletonLines[7].Visible = true
                    end

                    if character:FindFirstChild("LeftLowerLeg") then
                        local leftLowerLegPos = Camera:WorldToViewportPoint(character.LeftLowerLeg.Position)
                        skeletonLines[8].From = Vector2.new(leftLegPos.X, leftLegPos.Y)
                        skeletonLines[8].To = Vector2.new(leftLowerLegPos.X, leftLowerLegPos.Y)
                        skeletonLines[8].Visible = true
                    end

                    if character:FindFirstChild("RightLowerLeg") then
                        local rightLowerLegPos = Camera:WorldToViewportPoint(character.RightLowerLeg.Position)
                        skeletonLines[9].From = Vector2.new(rightLegPos.X, rightLegPos.Y)
                        skeletonLines[9].To = Vector2.new(rightLowerLegPos.X, rightLowerLegPos.Y)
                        skeletonLines[9].Visible = true
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
            arrow.Visible = false
            for _, line in pairs(skeletonLines) do
                line.Visible = false
            end
            for _, point in pairs(skeletonPoints) do
                point.Visible = false
            end
        end
    end)
end

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
RunService.RenderStepped:Connect(updatePlayerCount)
RunService.RenderStepped:Connect(updateFOV)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
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

-- ================ 透视1 ================
Toggle = TabHandles.W:Toggle({
    Title = "透视开启", 
    Value = false, 
    Callback = function(Value)
        getgenv().ESPEnabled = Value
    end
})

Toggle = TabHandles.W:Toggle({
    Title = "模型透视", 
    Value = false, 
    Callback = function(Value)
        getgenv().ShowSkeleton = Value
    end
})

Toggle = TabHandles.W:Toggle({
    Title = "方框透视", 
    Value = false, 
    Callback = function(Value)
        getgenv().ShowBox = Value
    end
})

Toggle = TabHandles.W:Toggle({
    Title = "射线透视", 
    Value = false, 
    Callback = function(Value)
        getgenv().ShowTracer = Value
    end
})

Toggle = TabHandles.W:Toggle({
    Title = "名字透视", 
    Value = false, 
    Callback = function(Value)
        getgenv().ShowName = Value
    end
})
-- ================ ？？？？ ================

Button = TabHandles.E:Button({
    Title = "坠落无伤害",
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

Button = TabHandles.E:Button({
    Title = "删除所有门",
    Callback = function()
       for k,v in pairs(Workspace.Tycoon.Tycoons:GetChildren()) do
            for x,y in pairs(v.PurchasedObjects:GetChildren()) do
                if(y.Name:find("Door") or y.Name:find("Gate")) then y:destroy(); end;
            end;
        end;
    end})

Toggle = TabHandles.E:Toggle({
    Title = "无cd状态",
    Callback = function()
        local ContextActions = game:GetService("Workspace")[game.Players.LocalPlayer.Name].ContextActions
        local ContextMain = require(ContextActions.ContextMain)
        
        ContextMain:New({
            RobPlayerLength = 0.1,
            FixWallLength = 0.1,
            CrackSafeLength = 0.1,
            RobSafeLength = 0.1,
            RobRegisterLength = 0.1,
            PickCellLength = 0.1,
            SkinAnimalLength = 0.1
        }, 200, {
            "Get out of my shop! Outlaws are not welcome here!",
            "Hey, scoundrel! Get out before I call the sheriff!",
            "You're an outlaw! We don't serve your type here!"
        }, {
            "This here's a bandit camp! Get out!",
            "Get lost, cowboy!",
            "Are you an outlaw? Didn't think so! Scram!"
        })
    end
})

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
                print("死亡位置已记录: " .. tostring(deathPosition))
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
                    print("死亡位置已记录: " .. tostring(deathPosition))
                end
            end)
        end
    end
end

setupDeathTracking()

Button = TabHandles.E:Button({
    Title = "原地重生",
    Description = "在死亡位置重生角色",
    Callback = function()
        if not deathPosition then
            return
        end
        
        local player = game.Players.LocalPlayer
        local character = player.Character
        
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then

                return
            end
        end
        
        local connection
        connection = player.CharacterAdded:Connect(function(newCharacter)
            local newRootPart = newCharacter:WaitForChild("HumanoidRootPart", 5)
            local newHumanoid = newCharacter:WaitForChild("Humanoid", 5)
            
            if newRootPart and newHumanoid then
                wait(0.5)
                
                newRootPart.CFrame = CFrame.new(deathPosition) * deathOrientation
                
                
                deathPosition = nil
                deathOrientation = nil
            end
            
            if connection then
                connection:Disconnect()
            end
        end)
        
        if not character then
            local currentTeam = player.Team
            player.Team = nil
            wait(0.1)
            player.Team = currentTeam
        else
            player:LoadCharacter()
        end
        
        delay(10, function()
            if connection then
                connection:Disconnect()
                WindUI:Notify({
                    Title = "超时",
                    Content = "重生过程超时",
                    Duration = 3,
                })
            end
        end)
    end
})
-- ================      ================









-- ================      ================
local fov = 0
local maxDistance = 50
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Cam = workspace.CurrentCamera

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 0.5
FOVring.Color = Color3.new(1, 1, 1)
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

local autoAimEnabled = false
local fovVisible = false
local ignoreCover = false
local aimTarget = "敌对"
local aimPosition = "Head"
local fovColor = Color3.new(1, 1, 1)
local rainbowEnabled = false

local function updateDrawings()
    FOVring.Position = Cam.ViewportSize / 2
end

local function onKeyDown(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        RunService:UnbindFromRenderStep("FOVUpdate")
        FOVring:Remove()
    end
end

UserInputService.InputBegan:Connect(onKeyDown)

local function lookAt(target)
    local lookVector = (target - Cam.CFrame.Position).unit
    local newCFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
    Cam.CFrame = newCFrame
end

local function getClosestPlayerInFOV(trg_part)
    local nearest = nil
    local last = math.huge
    local playerMousePos = Cam.ViewportSize / 2
    
    for _, player in ipairs(Plr:GetPlayers()) do
        if player ~= LP and (aimTarget == "全部" or player.TeamColor ~= LP.TeamColor) then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local part = character and character:FindFirstChild(trg_part)
            
            if part and humanoid and humanoid.Health > 0 then
                local ePos, isVisible = Cam:WorldToViewportPoint(part.Position)
                local distance = (Vector2.new(ePos.x, ePos.y) - playerMousePos).Magnitude
                
                if distance < last and isVisible and distance < fov then
                    if (part.Position - Cam.CFrame.Position).Magnitude <= tonumber(maxDistance) then
                        if not ignoreCover or #Cam:GetPartsObscuringTarget({part.Position}, {character, LP.Character}) == 0 then
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
-- ================  ================
-- = 玩家自瞄 =-- = 显示范围 =-- = 掩体不瞄 =-- =  =-- =  =-- =  =


local fov = 0
local maxDistance = 50
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Cam = workspace.CurrentCamera

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 0.5
FOVring.Color = Color3.new(1, 1, 1)
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

Toggle = TabHandles.R:Toggle({
    Title = "子弹无限",
    Desc = "",
    Locked = false,
    Callback = function(v)
    local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local gk = true 
local uj = nil
local deathConnection = nil

local originalGunData = {}

local function apn()
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
                rawset(gunTable, "BSpeed", 99999)
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
    
    if gk then
        LocalPlayer.CharacterAdded:Wait()
        task.wait(1)  
        apn()
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

gk = true

if LocalPlayer.Character then
    apn()
end

setupDeathListener()

uj = LocalPlayer.CharacterAdded:Connect(function()
    if gk then
        task.wait(1) 
        apn()
        setupDeathListener()  
    end
end)
end
})  
-- ================  ================
-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =











-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =
-- ================  ================

local bulletTrackingEnabled = true  
local oldHook = nil
              
Toggle = TabHandles.R:Toggle({
    Title = "子追",
    Desc = "",
    Locked = false,
    Callback = function(t)
    bulletTrackingEnabled = t

local function setupBulletTracking()
    local Workspace = game:GetService("Workspace")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = Workspace.CurrentCamera
    
    local function getClosestHead()
        if not LocalPlayer.Character then return nil end
        if not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end
        
        local closestHead = nil
        local closestDistance = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local character = player.Character
                local root = character:FindFirstChild("HumanoidRootPart")
                local head = character:FindFirstChild("Head")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local forcefield = character:FindFirstChild("ForceField")
                
                if root and head and humanoid and not forcefield and humanoid.Health > 0 then
                    local distance = (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                    if distance < closestDistance then
                        closestHead = head
                        closestDistance = distance
                    end
                end
            end
        end
        
        return closestHead
    end
    
    if not oldHook then
        oldHook = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if bulletTrackingEnabled and method == "Raycast" and not checkcaller() then
                local origin = args[1] or Camera.CFrame.Position
                local closestHead = getClosestHead()
                
                if closestHead then
                    return {
                        Instance = closestHead,
                        Position = closestHead.Position,
                        Normal = (origin - closestHead.Position).Unit,
                        Material = Enum.Material.Plastic,
                        Distance = (closestHead.Position - origin).Magnitude
                    }
                end
            end

            return oldHook(self, ...)
        end)
    end
end

bulletTrackingEnabled = true
setupBulletTracking() 
end
})

Toggle = TabHandles.R:Toggle({
    Title = "显示范围",
    Desc = "",
    Locked = false,
    Callback = function(t)
    fovVisible = t
    FOVring.bulletTrackingEnabled = fovVisible
            
 end
}) 

Slider = TabHandles.R:Slider({
    Title = "自瞄范围",
    Desc = "speedwalk",
    Value = { Min = 1, Max = 200, },
    Callback = function(s)
    fov = tonumber(s)
    FOVring.bulletTrackingEnabled = fov
    end
})

Slider = TabHandles.R:Slider({
    Title = "自瞄距离",
    Desc = "speedwalk",
    Value = { Min = 0, Max = 1200, },
    Callback = function(s)
    bulletTrackingEnabled = tonumber(s)
    end
})            
-- ================  ================
-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =








-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =
-- ================  ================


Toggle = TabHandles.R:Toggle({
    Title = "玩家自瞄",
    Desc = "",
    Locked = false,
    Callback = function(t)
    autoAimEnabled = t

 end
})
-- ================  ================
-- =  =
Toggle = TabHandles.R:Toggle({
    Title = "显示范围",
    Desc = "",
    Locked = false,
    Callback = function(t)
    fovVisible = t
    FOVring.Visible = fovVisible
            
 end
}) 
-- =  =
-- ================  ================
Toggle = TabHandles.R:Toggle({
    Title = "掩体不瞄",
    Desc = "",
    Locked = false,
    Callback = function(t)
    ignoreCover = t
           
 end
})           
-- ================  ================
Slider = TabHandles.R:Slider({
    Title = "自瞄范围",
    Desc = "speedwalk",
    Value = { Min = 1, Max = 200, },
    Callback = function(s)
    fov = tonumber(s)
    FOVring.Radius = fov
    end
})
-- ================  ================
Slider = TabHandles.R:Slider({
    Title = "自瞄距离",
    Desc = "speedwalk",
    Value = { Min = 0, Max = 1200, },
    Callback = function(s)
    maxDistance = tonumber(s)
    end
})
-- ================  ================
Slider = TabHandles.R:Slider({
    Title = "自瞄圈粗细",
    Desc = "speedwalk",
    Value = { Min = 1, Max = 10, },
    Callback = function(s)
    FOVring.Thickness = tonumber(s)
    end
})
-- ================  ================
Dropdown = TabHandles.R:Dropdown({
    Title = "选择自瞄目标", 
    Values = {"敌对", "全部"}, 
    Value = "敌对", 
    Callback = function(value) 
        aimTarget = value 
    end
})
-- ================  ================
Dropdown = TabHandles.R:Dropdown({
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
-- ================  ================
Dropdown = TabHandles.R:Dropdown({
    Title = "选择圈的颜色", 
    Values = {"红", "黄", "蓝", "绿", "青", "紫", "彩虹"}, 
    Value = "红", 
    Callback = function(value)
        if value == "彩虹" then
            rainbowEnabled = true
        else
            rainbowEnabled = false
            local colors = {
                ["红"] = Color3.new(1, 0, 0),
                ["黄"] = Color3.new(1, 1, 0),
                ["蓝"] = Color3.new(0, 0, 1),
                ["绿"] = Color3.new(0, 1, 0),
                ["青"] = Color3.new(0, 1, 1),
                ["紫"] = Color3.new(1, 0, 1)
            }
            FOVring.Color = colors[value]
        end
    end
})
-- ================  ================
Dropdown = TabHandles.R:Dropdown({
    Title = "不攻击的玩家(多选)", 
    Values = PlayerList, 
    Value = {}, 
    Multi = true, 
    AllowNone = true, 
    Callback = function(values) 
        C_NPlayers = values or {} 
    end
})
-- ================  ================
Button = TabHandles.R:Button({
    Title = "刷新玩家列表",
    Desc = "",
    Locked = false,
    Callback = function()
    PlayerList = {}
    for _, player in ipairs(Plr:GetPlayers()) do
        if player ~= LP then
            table.insert(PlayerList, player.Name)
        end
    end
    excludeTargetsDropdown:Refresh(PlayerList)
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})

-- ================  ================
-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =










-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =
-- ================  ================


Button = TabHandles.T:Button({
    Title = "获取RPG",
    Desc = "",
    Locked = false,
    Callback = function()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer
    local TycoonsFolder = workspace.Tycoon.Tycoons
    local savedPosition
    
    local function findNearestTeleportPosition()
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local playerPosition = humanoidRootPart.Position
        local closestDistance = math.huge
        local closestCFrame = nil
        
        for _, tycoonModel in ipairs(TycoonsFolder:GetChildren()) do
            if tycoonModel:IsA("Model") then
                local purchasedObjects = tycoonModel:FindFirstChild("PurchasedObjects")
                if purchasedObjects then
                    local rpgGiver = purchasedObjects:FindFirstChild("RPG Giver")
                    if rpgGiver then
                        local prompt = rpgGiver:FindFirstChild("Prompt")
                        if prompt and prompt:IsA("BasePart") then
                            local distance = (playerPosition - prompt.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestCFrame = prompt.CFrame
                            end
                        end
                    end
                end
            end
        end
        
        return closestCFrame
    end
    
    local function teleportPlayer()
        local character = localPlayer.Character
        if not character then
            return
        end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            savedPosition = humanoidRootPart.CFrame
        end
        
        local targetCFrame = findNearestTeleportPosition()
        if targetCFrame then
            humanoidRootPart.CFrame = targetCFrame
            
            spawn(function()
                while wait(0.5) do
                    if not character.Parent then
                        break
                    end
                    
                    local backpack = localPlayer:FindFirstChild("Backpack")
                    if backpack and backpack:FindFirstChild("RPG") then
                        humanoidRootPart.CFrame = savedPosition
                        break
                    end
                end
            end)
        else
            WindUI:Notify({
                Title = "ERROR",
                Content = "未能找到附近的RPG",
                Duration = 4,
            })
        end
    end
    
    teleportPlayer()
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})
-- ================  ================
-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =








-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =
-- ================  ================

local loopActive = false
local rpgAttackThread = nil

Button = TabHandles.T:Button({
    Title = "RPG轰炸",
    Desc = "",
    Locked = false,
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
            
WindUI:Notify({
    Title = "通知",
    Content = "加载成功",
    Duration = 1, -- 3 seconds
    Icon = "layout-grid",
})                        
            
 end
})
-- ================  ================
-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =






-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =
-- ================  ================


-- ================  ================
-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =















-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =
-- ================  ================

Button = TabHandles.T:Button({
    Title = "原地重生",
    Description = "在死亡位置重生角色",
    Callback = function()
        if not deathPosition then
            return
        end
        
        local player = game.Players.LocalPlayer
        local character = player.Character
        
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then

                return
            end
        end
        
        local connection
        connection = player.CharacterAdded:Connect(function(newCharacter)
            local newRootPart = newCharacter:WaitForChild("HumanoidRootPart", 5)
            local newHumanoid = newCharacter:WaitForChild("Humanoid", 5)
            
            if newRootPart and newHumanoid then
                wait(0.5)
                
                newRootPart.CFrame = CFrame.new(deathPosition) * deathOrientation
                
                
                deathPosition = nil
                deathOrientation = nil
            end
            
            if connection then
                connection:Disconnect()
            end
        end)
        
        if not character then
            local currentTeam = player.Team
            player.Team = nil
            wait(0.1)
            player.Team = currentTeam
        else
            player:LoadCharacter()
        end
        
        delay(10, function()
            if connection then
                connection:Disconnect()
                WindUI:Notify({
                    Title = "超时",
                    Content = "重生过程超时",
                    Duration = 3,
                })
            end
        end)
        
WindUI:Notify({
    Title = "通知",
    Content = "加载成功无伤落地",
    Duration = 3, -- 3 seconds
    Icon = "layout-grid",
})        
        
    end
})
-- ================  ================
-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =










-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =-- =  =
-- ================  ================