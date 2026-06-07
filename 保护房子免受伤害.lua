local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "保护房子免受怪物伤害",
    Folder = "作者：琼玖",
    SideBarWidth = 180,
})


local Lighting = game:GetService("Lighting")
local TweenServiceBlur = game:GetService("TweenService")

local blur = Lighting:FindFirstChildOfClass("BlurEffect")
if not blur then
    blur = Instance.new("BlurEffect")
    blur.Size = 0
    blur.Parent = Lighting
end

task.spawn(function()
    local wasOpen = false
    while true do
        task.wait(0.1)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        local isOpen = mainFrame and mainFrame.Visible or false
        
        if isOpen ~= wasOpen then
            wasOpen = isOpen
            TweenServiceBlur:Create(blur, TweenInfo.new(0.3), {
                Size = isOpen and 20 or 0
            }):Play()
        end
    end
end)

function ESP_WeaponBoxes(state)
    if not getgenv().WeaponBoxesESP then
        getgenv().WeaponBoxesESP = { Enabled = false, Boxes = {}, Connection = nil, SearchInterval = nil }
    end
    local ESP = getgenv().WeaponBoxesESP
    
    local function CreateESPForBox(hitbox)
        if ESP.Boxes[hitbox] then return end
        if not hitbox or not hitbox.Parent then return end
        
        local espData = {}
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "WeaponBoxESP_Highlight"
        highlight.Adornee = hitbox
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = hitbox
        espData.Highlight = highlight
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "WeaponBoxESP_Label"
        billboard.Adornee = hitbox
        billboard.Size = UDim2.new(0, 150, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = 500
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Name = "ESPText"
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "武器箱"
        textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        textLabel.TextStrokeTransparency = 0
        textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextSize = 16
        textLabel.Parent = billboard
        billboard.Parent = hitbox
        espData.Billboard = billboard
        
        ESP.Boxes[hitbox] = espData
        
        hitbox.AncestryChanged:Connect(function(_, parent)
            if not parent then
                if ESP.Boxes[hitbox] then
                    if ESP.Boxes[hitbox].Highlight then ESP.Boxes[hitbox].Highlight:Destroy() end
                    if ESP.Boxes[hitbox].Billboard then ESP.Boxes[hitbox].Billboard:Destroy() end
                    ESP.Boxes[hitbox] = nil
                end
            end
        end)
    end
    
    local function ScanForBoxes()
        local workspace = game:GetService("Workspace")
        for _, descendant in ipairs(workspace:GetDescendants()) do
            if descendant:IsA("BasePart") or descendant:IsA("Model") then
                local name = descendant.Name:lower()
                if name == "hitbox" or name:find("hitbox") then
                    CreateESPForBox(descendant)
                end
            end
        end
    end
    
    local function ClearAllESP()
        for hitbox, espData in pairs(ESP.Boxes) do
            if espData.Highlight and espData.Highlight.Parent then espData.Highlight:Destroy() end
            if espData.Billboard and espData.Billboard.Parent then espData.Billboard:Destroy() end
        end
        ESP.Boxes = {}
    end
    
    if state then
        if ESP.Enabled then return end
        ESP.Enabled = true
        ScanForBoxes()
        ESP.SearchInterval = task.spawn(function()
            while ESP.Enabled do
                task.wait(2)
                if ESP.Enabled then ScanForBoxes() end
            end
        end)
        ESP.Connection = game:GetService("Workspace").DescendantAdded:Connect(function(descendant)
            if not ESP.Enabled then return end
            task.wait(0.1)
            if descendant:IsA("BasePart") or descendant:IsA("Model") then
                local name = descendant.Name:lower()
                if name == "hitbox" or name:find("hitbox") then
                    CreateESPForBox(descendant)
                end
            end
        end)
    else
        if not ESP.Enabled then return end
        ESP.Enabled = false
        if ESP.Connection then ESP.Connection:Disconnect() ESP.Connection = nil end
        if ESP.SearchInterval then task.cancel(ESP.SearchInterval) ESP.SearchInterval = nil end
        ClearAllESP()
    end
end

function ESP_Bosses(state)
    if not _G.BossESP then _G.BossESP = { Active = false, Connections = {}, ESPObjects = {} } end
    local ESP = _G.BossESP
    
    local function ClearESP()
        for _, connection in pairs(ESP.Connections) do if connection then connection:Disconnect() end end
        ESP.Connections = {}
        for _, obj in pairs(ESP.ESPObjects) do
            if obj.Billboard then obj.Billboard:Destroy() end
            if obj.Highlight then obj.Highlight:Destroy() end
        end
        ESP.ESPObjects = {}
    end
    
    local function CreateBossESP(boss)
        if ESP.ESPObjects[boss] then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = "BossESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 100, 100)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = boss
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "BossESP_GUI"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 200, 0, 80)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Parent = boss
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "BossName"
        nameLabel.Size = UDim2.new(1, 0, 0, 25)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = boss.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 18
        nameLabel.Parent = billboard
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Name = "Distance"
        distanceLabel.Size = UDim2.new(1, 0, 0, 20)
        distanceLabel.Position = UDim2.new(0, 0, 0, 22)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = "距离: -- 米"
        distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        distanceLabel.TextStrokeTransparency = 0
        distanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        distanceLabel.Font = Enum.Font.Gotham
        distanceLabel.TextSize = 14
        distanceLabel.Parent = billboard
        
        local humanoid = boss:FindFirstChildOfClass("Humanoid") or boss:FindFirstChild("Humanoid")
        if humanoid then
            local hpBackground = Instance.new("Frame")
            hpBackground.Name = "HPBackground"
            hpBackground.Size = UDim2.new(0.8, 0, 0, 12)
            hpBackground.Position = UDim2.new(0.1, 0, 0, 45)
            hpBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            hpBackground.BorderSizePixel = 0
            hpBackground.Parent = billboard
            
            local hpFill = Instance.new("Frame")
            hpFill.Name = "HPFill"
            hpFill.Size = UDim2.new(1, 0, 1, 0)
            hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            hpFill.BorderSizePixel = 0
            hpFill.Parent = hpBackground
            
            local hpText = Instance.new("TextLabel")
            hpText.Name = "HPText"
            hpText.Size = UDim2.new(1, 0, 1, 0)
            hpText.BackgroundTransparency = 1
            hpText.Text = math.floor(humanoid.Health) .. " / " .. math.floor(humanoid.MaxHealth)
            hpText.TextColor3 = Color3.fromRGB(255, 255, 255)
            hpText.TextStrokeTransparency = 0
            hpText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            hpText.Font = Enum.Font.GothamBold
            hpText.TextSize = 10
            hpText.Parent = hpBackground
            
            local hpConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                hpFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                hpFill.BackgroundColor3 = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
                hpText.Text = math.floor(humanoid.Health) .. " / " .. math.floor(humanoid.MaxHealth)
            end)
            table.insert(ESP.Connections, hpConnection)
        end
        
        ESP.ESPObjects[boss] = { Billboard = billboard, Highlight = highlight }
    end
    
    local function UpdateDistances()
        local player = game.Players.LocalPlayer
        if not player or not player.Character then return end
        local character = player.Character
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
        if not humanoidRootPart then return end
        local playerPosition = humanoidRootPart.Position
        
        for boss, espData in pairs(ESP.ESPObjects) do
            if boss and boss.Parent and espData.Billboard then
                local distanceLabel = espData.Billboard:FindFirstChild("Distance")
                if distanceLabel then
                    local distance = (playerPosition - boss.Position).Magnitude
                    distanceLabel.Text = "距离: " .. math.floor(distance) .. " 米"
                end
            end
        end
    end
    
    local function ScanAndCreateESP()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                if string.sub(obj.Name, 1, 5) == "Boss_" then
                    CreateBossESP(obj)
                end
            end
        end
    end
    
    if state then
        if ESP.Active then return end
        ESP.Active = true
        ScanAndCreateESP()
        local distanceConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if ESP.Active then UpdateDistances() end
        end)
        table.insert(ESP.Connections, distanceConnection)
        local descendantConnection = workspace.DescendantAdded:Connect(function(descendant)
            if ESP.Active and (descendant:IsA("BasePart") or descendant:IsA("Model")) then
                if string.sub(descendant.Name, 1, 5) == "Boss_" then
                    wait(0.1)
                    CreateBossESP(descendant)
                end
            end
        end)
        table.insert(ESP.Connections, descendantConnection)
        local removedConnection = workspace.DescendantRemoving:Connect(function(descendant)
            if ESP.ESPObjects[descendant] then
                if ESP.ESPObjects[descendant].Billboard then ESP.ESPObjects[descendant].Billboard:Destroy() end
                if ESP.ESPObjects[descendant].Highlight then ESP.ESPObjects[descendant].Highlight:Destroy() end
                ESP.ESPObjects[descendant] = nil
            end
        end)
        table.insert(ESP.Connections, removedConnection)
    else
        ESP.Active = false
        ClearESP()
    end
end

function AimAssist(state)
    local SETTINGS = { 
        MaxDistance = 200, 
        FOV = 120, 
        Smoothness = 0.08, 
        AimKey = Enum.UserInputType.MouseButton2, 
        TargetPart = "Head", 
        TeamCheck = false 
    }
    local aimConnection = nil
    local currentTarget = nil
    
    local function IsValidTarget(model)
        if not model or model == LocalPlayer.Character then return false end
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        local head = model:FindFirstChild(SETTINGS.TargetPart)
        if not humanoid or not head then return false end
        if humanoid.Health <= 0 then return false end
        return true
    end
    
    local function GetAngle(v1, v2)
        return math.deg(math.acos(math.clamp(v1:Dot(v2) / (v1.Magnitude * v2.Magnitude), -1, 1)))
    end
    
    local function GetScreenDistance(position)
        local screenPos, onScreen = Camera:WorldToViewportPoint(position)
        if not onScreen then return math.huge end
        local centerX = Camera.ViewportSize.X / 2
        local centerY = Camera.ViewportSize.Y / 2
        return math.sqrt((screenPos.X - centerX)^2 + (screenPos.Y - centerY)^2)
    end
    
    local function FindBestTarget()
        local bestTarget = nil
        local bestDistance = math.huge
        local cameraPos = Camera.CFrame.Position
        local cameraLook = Camera.CFrame.LookVector
        
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and IsValidTarget(model) then
                local head = model:FindFirstChild(SETTINGS.TargetPart)
                if head then
                    local headPos = head.Position
                    local distance = (headPos - cameraPos).Magnitude
                    if distance <= SETTINGS.MaxDistance then
                        local direction = (headPos - cameraPos).Unit
                        local angle = GetAngle(cameraLook, direction)
                        if angle <= SETTINGS.FOV / 2 then
                            local screenDist = GetScreenDistance(headPos)
                            if screenDist < bestDistance then
                                bestDistance = screenDist
                                bestTarget = head
                            end
                        end
                    end
                end
            end
        end
        return bestTarget
    end
    
    local function SmoothAim(target)
        if not target or not target.Parent then return end
        local targetPos = target.Position
        local cameraPos = Camera.CFrame.Position
        local newCFrame = CFrame.new(cameraPos, targetPos)
        local smoothedCFrame = Camera.CFrame:Lerp(newCFrame, SETTINGS.Smoothness)
        Camera.CFrame = smoothedCFrame
    end
    
    local function AimLoop()
        local isAimKeyPressed = UserInputService:IsMouseButtonPressed(SETTINGS.AimKey)
        if isAimKeyPressed then
            if not currentTarget or not currentTarget.Parent or not IsValidTarget(currentTarget.Parent) then
                currentTarget = FindBestTarget()
            end
            if currentTarget then SmoothAim(currentTarget) end
        else
            currentTarget = nil
        end
    end
    
    if state then
        if aimConnection then aimConnection:Disconnect() end
        aimConnection = RunService.RenderStepped:Connect(AimLoop)
    else
        if aimConnection then aimConnection:Disconnect() aimConnection = nil end
        currentTarget = nil
    end
end

function ESP_ZombieType(state, typeName, displayTitle, color)
    if not _G[typeName.."ESP"] then _G[typeName.."ESP"] = { Active = false, Connections = {}, ESPObjects = {} } end
    local ESP = _G[typeName.."ESP"]
    
    local function ClearESP()
        for _, connection in pairs(ESP.Connections) do if connection then connection:Disconnect() end end
        ESP.Connections = {}
        for _, obj in pairs(ESP.ESPObjects) do
            if obj.Billboard then obj.Billboard:Destroy() end
            if obj.Highlight then obj.Highlight:Destroy() end
        end
        ESP.ESPObjects = {}
    end
    
    local function CreateESP(zombie)
        if ESP.ESPObjects[zombie] then return end
        
        local highlight = Instance.new("Highlight")
        highlight.Name = typeName.."ESP_Highlight"
        highlight.FillColor = color
        highlight.OutlineColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Parent = zombie
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = typeName.."ESP_GUI"
        billboard.AlwaysOnTop = true
        billboard.Size = UDim2.new(0, 120, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.Parent = zombie
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Name = "ZombieName"
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = displayTitle
        nameLabel.TextColor3 = color
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 14
        nameLabel.Parent = billboard
        
        ESP.ESPObjects[zombie] = { Billboard = billboard, Highlight = highlight }
    end
    
    local function ScanAndCreateESP()
        for _, obj in pairs(workspace:GetDescendants()) do
            if (obj:IsA("BasePart") or obj:IsA("Model")) and obj.Name:lower() == typeName:lower() then
                CreateESP(obj)
            end
        end
    end
    
    if state then
        if ESP.Active then return end
        ESP.Active = true
        ScanAndCreateESP()
        local descendantConnection = workspace.DescendantAdded:Connect(function(descendant)
            if ESP.Active and (descendant:IsA("BasePart") or descendant:IsA("Model")) and descendant.Name:lower() == typeName:lower() then
                wait(0.1)
                CreateESP(descendant)
            end
        end)
        table.insert(ESP.Connections, descendantConnection)
        local removedConnection = workspace.DescendantRemoving:Connect(function(descendant)
            if ESP.ESPObjects[descendant] then
                if ESP.ESPObjects[descendant].Billboard then ESP.ESPObjects[descendant].Billboard:Destroy() end
                if ESP.ESPObjects[descendant].Highlight then ESP.ESPObjects[descendant].Highlight:Destroy() end
                ESP.ESPObjects[descendant] = nil
            end
        end)
        table.insert(ESP.Connections, removedConnection)
    else
        ESP.Active = false
        ClearESP()
    end
end

function ESP_Pumpkin(state) ESP_ZombieType(state, "pumpkin", "南瓜僵尸", Color3.fromRGB(255, 165, 0)) end
function ESP_Secret(state) ESP_ZombieType(state, "secret", "隐藏僵尸", Color3.fromRGB(128, 0, 128)) end
function ESP_Bat(state) ESP_ZombieType(state, "bat", "蝙蝠", Color3.fromRGB(0, 100, 255)) end
function ESP_Zombie(state) ESP_ZombieType(state, "zombie", "普通僵尸", Color3.fromRGB(0, 255, 0)) end

function Noclip(state)
    if not _G.NoclipConnection then _G.NoclipConnection = nil end
    if state then
        if _G.NoclipConnection then return end
        _G.NoclipConnection = game:GetService("RunService").Stepped:Connect(function()
            local player = game.Players.LocalPlayer
            if player and player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if _G.NoclipConnection then
            _G.NoclipConnection:Disconnect()
            _G.NoclipConnection = nil
        end
    end
end

function SetWalkspeed(speed)
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = math.clamp(speed, 0, 100)
        end
    end
end

function SetJumpPower(power)
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = math.clamp(power, 0, 150)
        end
    end
end

function Xray(state)
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(game.Players.LocalPlayer.Character) then
            if state then
                part.LocalTransparencyModifier = 0.7
            else
                part.LocalTransparencyModifier = 0
            end
        end
    end
end

function InfiniteJump(state)
    if not _G.InfiniteJumpConnection then _G.InfiniteJumpConnection = nil end
    if state then
        if _G.InfiniteJumpConnection then return end
        _G.InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
            local player = game.Players.LocalPlayer
            if player and player.Character then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if _G.InfiniteJumpConnection then
            _G.InfiniteJumpConnection:Disconnect()
            _G.InfiniteJumpConnection = nil
        end
    end
end

local CombatTab = Window:Tab({ Title = '功能大全', Icon = 'swords' })
Window:SelectTab(1) 

local VisualsSection = CombatTab:Section({ Title = "透视功能 (ESP)", Icon = "eye" })

VisualsSection:Toggle({
    Title = "透视武器箱",
    Desc = "显示地图上的箱子",
    Callback = function(state)
        ESP_WeaponBoxes(state)
    end
})

VisualsSection:Toggle({
    Title = "透视 Boss",
    Desc = "显示 Boss 位置、血量和距离",
    Callback = function(state)
        ESP_Bosses(state)
    end
})

VisualsSection:Toggle({
    Title = "透视南瓜僵尸",
    Callback = function(state)
        ESP_Pumpkin(state)
    end
})

VisualsSection:Toggle({
    Title = "透视隐藏僵尸",
    Callback = function(state)
        ESP_Secret(state)
    end
})

VisualsSection:Toggle({
    Title = "透视蝙蝠",
    Callback = function(state)
        ESP_Bat(state)
    end
})

VisualsSection:Toggle({
    Title = "透视普通僵尸",
    Callback = function(state)
        ESP_Zombie(state)
    end
})

VisualsSection:Toggle({
    Title = "X光透视",
    Desc = "让周围物体变透明",
    Callback = function(state)
        Xray(state)
    end
})

local FightSection = CombatTab:Section({ Title = "战斗辅助", Icon = "crosshair" })

FightSection:Toggle({
    Title = "自瞄辅助",
    Desc = "锁定敌人头部",
    Callback = function(state)
        AimAssist(state)
    end
})

local MovementSection = CombatTab:Section({ Title = "角色移动", Icon = "footprints" })

MovementSection:Toggle({
    Title = "穿墙",
    Desc = "允许穿过物体",
    Callback = function(state)
        Noclip(state)
    end
})

MovementSection:Toggle({
    Title = "无限跳",
    Desc = "在空中也可以跳跃",
    Callback = function(state)
        InfiniteJump(state)
    end
})

MovementSection:Slider({
    Title = "移动速度",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(value)
        SetWalkspeed(value)
    end
})

MovementSection:Slider({
    Title = "跳跃高度",
    Min = 50,
    Max = 150,
    Default = 50,
    Callback = function(value)
        SetJumpPower(value)
    end
})