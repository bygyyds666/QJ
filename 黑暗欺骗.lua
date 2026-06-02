local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()
local Window = WindUI:CreateWindow({
    Title = "QJ脚本-黑暗欺骗",
    Author = "作者：琼玖",
    Folder = "DarkDeception",
    Size = UDim2.fromOffset(260, 450),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = false,
        Callback = function() print("clicked") end,
        Anonymous = false
    },
    SideBarWidth = 120,
    ScrollBarEnabled = true,
    Background = "https://chaton-images.s3.us-east-2.amazonaws.com/o7hkoAxrjanwZ1BaDWuAXj6cJ0VNtkTTtHBjBfG6HpiuD4X1jR6X9V6PJmpGsCMV_1920x1080x683842.jpeg",
    BackgroundImageTransparency = 0.5,
})

Window:EditOpenButton({
    Title = "QJ脚本-黑暗欺骗",
    CornerRadius = UDim.new(0, 10),
    StrokeThickness = 2.5,
    Color = ColorSequence.new(
        Color3.fromHex("#ff4444"),
        Color3.fromHex("#ff7777")
    ),
    Draggable = true,
})

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local placeId = game.PlaceId
print("当前Place ID:", placeId)

local function getCharacter()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function getRootPart()
    local char = getCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local PICKUP_STATE = {
    IsActive = false,
    TargetList = {},
    CurrentIndex = 0,
    TotalCount = 0,
    Status = "准备就绪",
    ProgressText = "0/0",
    Connection = nil,
    TeleportDelay = 0.15
}

local function scanShards()
    local targets = {}
    local shardFolder = Workspace:FindFirstChild("Shards")
    if shardFolder then
        for _, obj in ipairs(shardFolder:GetChildren()) do
            if obj:IsA("BasePart") and obj.Name:find("Shard") then
                local cframe = obj:FindFirstChild("HumanoidRootPart") and obj.HumanoidRootPart.CFrame or obj.CFrame
                table.insert(targets, cframe)
            end
        end
    end
    return targets
end

local function scanColliders()
    local targets = {}
    local collidersFolder = Workspace:FindFirstChild("Colliders")
    if collidersFolder then
        for _, obj in ipairs(collidersFolder:GetChildren()) do
            local cframe = nil
            if obj:IsA("Model") then
                if obj.PrimaryPart then
                    cframe = obj.PrimaryPart.CFrame
                else
                    for _, part in ipairs(obj:GetDescendants()) do
                        if part:IsA("BasePart") then
                            cframe = part.CFrame
                            break
                        end
                    end
                end
            elseif obj:IsA("BasePart") then
                cframe = obj.CFrame
            end
            if cframe then
                table.insert(targets, cframe)
            end
        end
    end
    return targets
end

local function getTargetsByPlaceId()
    if placeId == 102181577519757 then
        return scanShards()
    elseif placeId == 125591428878906 then
        return scanColliders()
    else
        return scanShards()
    end
end

local function stopPickup()
    PICKUP_STATE.IsActive = false
    PICKUP_STATE.CurrentIndex = 0
    if PICKUP_STATE.Connection then
        PICKUP_STATE.Connection:Disconnect()
        PICKUP_STATE.Connection = nil
    end
end

local function startPickup()
    if PICKUP_STATE.IsActive then
        stopPickup()
    end

    PICKUP_STATE.TargetList = getTargetsByPlaceId()
    PICKUP_STATE.TotalCount = #PICKUP_STATE.TargetList
    PICKUP_STATE.CurrentIndex = 0

    if PICKUP_STATE.TotalCount == 0 then
        PICKUP_STATE.Status = "未找到目标"
        PICKUP_STATE.ProgressText = "0/0"
        WindUI:Notify({
            Title = "一键拾取",
            Content = "未找到任何可拾取目标",
            Duration = 3,
            Icon = "alert-triangle"
        })
        return
    end

    PICKUP_STATE.Status = "正在扫描…"
    PICKUP_STATE.ProgressText = "0/" .. PICKUP_STATE.TotalCount
    PICKUP_STATE.IsActive = true

    task.wait(0.1)
    PICKUP_STATE.Status = "传送中"

    if PICKUP_STATE.Connection then
        PICKUP_STATE.Connection:Disconnect()
    end

    PICKUP_STATE.Connection = RunService.Heartbeat:Connect(function()
        if not PICKUP_STATE.IsActive then return end

        if PICKUP_STATE.CurrentIndex >= PICKUP_STATE.TotalCount then
            PICKUP_STATE.Status = "完成!"
            PICKUP_STATE.IsActive = false
            PICKUP_STATE.Connection:Disconnect()
            PICKUP_STATE.Connection = nil
            WindUI:Notify({
                Title = "一键拾取",
                Content = "已完成 " .. PICKUP_STATE.TotalCount .. " 个目标",
                Duration = 3,
                Icon = "check-circle"
            })
            return
        end

        local idx = PICKUP_STATE.CurrentIndex + 1
        local targetCF = PICKUP_STATE.TargetList[idx]
        if targetCF then
            local hrp = getRootPart()
            if hrp then
                hrp.CFrame = targetCF + Vector3.new(0, 2, 0)
            end
            PICKUP_STATE.CurrentIndex = idx
            PICKUP_STATE.ProgressText = idx .. "/" .. PICKUP_STATE.TotalCount
        else
            PICKUP_STATE.CurrentIndex = idx
        end

        task.wait(PICKUP_STATE.TeleportDelay)
    end)
end

local function teleportToAltar()
    local hrp = getRootPart()
    if not hrp then return end
    
    local targetCF = nil
    local targetName = ""
    
    if placeId == 102181577519757 then
        targetCF = CFrame.new(-29.8968544, 21.4973602, -45.0134354)
        targetName = "指定祭坛1"
        WindUI:Notify({
            Title = "祭坛传送",
            Content = "已传送到指定坐标1",
            Duration = 2,
            Icon = "map-pin"
        })
    elseif placeId == 125591428878906 then
        targetCF = CFrame.new(-159.452148, 9.88359642, 398.012268)
        targetName = "指定祭坛2"
        WindUI:Notify({
            Title = "祭坛传送",
            Content = "已传送到指定坐标2",
            Duration = 2,
            Icon = "map-pin"
        })
    else
        local ringAfter = nil
        local hotel = Workspace:FindFirstChild("Hotel")
        if hotel and hotel:FindFirstChild("Maze") then
            local maze = hotel.Maze
            if maze:FindFirstChild("Collisions") then
                local collisions = maze.Collisions
                if collisions:FindFirstChild("PlayerCollisions") then
                    local playerCollisions = collisions.PlayerCollisions
                    if playerCollisions:FindFirstChild("Room") then
                        local room = playerCollisions.Room
                        if room:FindFirstChild("Main") then
                            local main = room.Main
                            ringAfter = main:FindFirstChild("RingAfter")
                        end
                    end
                end
            end
        end

        if ringAfter then
            if ringAfter:IsA("Model") and ringAfter.PrimaryPart then
                targetCF = ringAfter.PrimaryPart.CFrame
            elseif ringAfter:IsA("BasePart") then
                targetCF = ringAfter.CFrame
            end
            targetName = "RingAfter"
        end
    end

    if targetCF then
        hrp.CFrame = targetCF + Vector3.new(0, 2, 0)
        if targetName ~= "" and placeId ~= 102181577519757 and placeId ~= 125591428878906 then
            WindUI:Notify({
                Title = "祭坛传送",
                Content = "已传送到 " .. targetName,
                Duration = 2,
                Icon = "map-pin"
            })
        end
    else
        hrp.CFrame = CFrame.new(0, 10, 0) + Vector3.new(0, 2, 0)
        WindUI:Notify({
            Title = "祭坛传送",
            Content = "使用默认坐标",
            Duration = 2,
            Icon = "map"
        })
    end
end

local ESP_STATE = {
    Enabled = false,
    Connection = nil,
    HighlightObjects = {}
}

local function clearESP()
    for _, obj in ipairs(ESP_STATE.HighlightObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    ESP_STATE.HighlightObjects = {}
end

local function getPrimaryPart(model)
    if model:IsA("Model") then
        if model.PrimaryPart then
            return model.PrimaryPart
        end
        for _, part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                return part
            end
        end
    elseif model:IsA("BasePart") then
        return model
    end
    return nil
end

local function createHighlight(target)
    local adornee = target
    if target:IsA("Model") then
        adornee = getPrimaryPart(target)
    end
    if not adornee then return nil end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "QW_ESP"
    highlight.Adornee = adornee
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = adornee
    return highlight
end

local function updateESP()
    if not ESP_STATE.Enabled then
        if ESP_STATE.Connection then
            ESP_STATE.Connection:Disconnect()
            ESP_STATE.Connection = nil
        end
        clearESP()
        return
    end

    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then
        clearESP()
        return
    end

    local currentEnemies = {}
    for _, child in ipairs(enemiesFolder:GetChildren()) do
        if child:IsA("Model") or child:IsA("BasePart") or child:FindFirstChild("Humanoid") then
            table.insert(currentEnemies, child)
        end
    end

    local espMap = {}
    for _, obj in ipairs(ESP_STATE.HighlightObjects) do
        if obj and obj.Parent and obj.Adornee then
            espMap[obj.Adornee] = obj
        end
    end

    for adornee, highlight in pairs(espMap) do
        local stillExists = false
        for _, enemy in ipairs(currentEnemies) do
            local enemyPart = getPrimaryPart(enemy)
            if enemyPart and enemyPart == adornee then
                stillExists = true
                break
            end
        end
        if not stillExists then
            highlight:Destroy()
            espMap[adornee] = nil
        end
    end

    for _, enemy in ipairs(currentEnemies) do
        local enemyPart = getPrimaryPart(enemy)
        if enemyPart and not espMap[enemyPart] then
            local hl = createHighlight(enemy)
            if hl then
                table.insert(ESP_STATE.HighlightObjects, hl)
                espMap[enemyPart] = hl
            end
        end
    end
end

local function toggleESP(state)
    if ESP_STATE.Enabled == state then return end
    ESP_STATE.Enabled = state
    if ESP_STATE.Enabled then
        if ESP_STATE.Connection then ESP_STATE.Connection:Disconnect() end
        updateESP()
        ESP_STATE.Connection = RunService.Heartbeat:Connect(updateESP)
        WindUI:Notify({ Title = "ESP", Content = "怪物高亮已开启", Duration = 2 })
    else
        if ESP_STATE.Connection then ESP_STATE.Connection:Disconnect(); ESP_STATE.Connection = nil end
        clearESP()
        WindUI:Notify({ Title = "ESP", Content = "怪物高亮已关闭", Duration = 2 })
    end
end

local BaseTab = Window:Tab({ 
    Title = "基础功能", 
    Icon = "home"
})

BaseTab:Section({ Title = "💎 一键拾取" })

local statusPara = BaseTab:Paragraph({
    Title = "当前状态",
    Desc = "状态: " .. PICKUP_STATE.Status .. "\n进度: " .. PICKUP_STATE.ProgressText,
    Image = "circle-play",
    ImageSize = 24,
    Color = "Blue"
})

BaseTab:Button({
    Title = "开始拾取",
    Callback = function()
        startPickup()
    end
})

BaseTab:Button({
    Title = "停止拾取",
    Callback = function()
        stopPickup()
        PICKUP_STATE.Status = "已停止"
        PICKUP_STATE.ProgressText = "0/0"
        if statusPara and statusPara.Parent then
            statusPara:SetDesc("状态: 已停止\n进度: 0/0")
        end
        WindUI:Notify({ Title = "一键拾取", Content = "已手动停止", Duration = 2 })
    end
})

BaseTab:Divider()

BaseTab:Section({ Title = "⚙️ 设置" })

BaseTab:Slider({
    Title = "传送延迟",
    Value = { Min = 0.05, Max = 0.5, Default = PICKUP_STATE.TeleportDelay },
    Step = 0.01,
    Callback = function(value)
        PICKUP_STATE.TeleportDelay = value
    end
})

RunService.Heartbeat:Connect(function()
    if statusPara and statusPara.Parent then
        statusPara:SetDesc("状态: " .. PICKUP_STATE.Status .. "\n进度: " .. PICKUP_STATE.ProgressText)
    end
end)

local ESPTab = Window:Tab({ 
    Title = "ESP", 
    Icon = "eye"
})

ESPTab:Section({ Title = "👁️ ESP 设置" })

ESPTab:Toggle({
    Title = "启用ESP",
    Value = false,
    Callback = function(state)
        toggleESP(state)
    end
})

ESPTab:Paragraph({
    Title = "ESP说明",
    Desc = "• 红色高亮显示怪物\n• 自动更新位置",
    Image = "info",
    ImageSize = 20
})

ESPTab:Button({
    Title = "手动刷新",
    Callback = function()
        if ESP_STATE.Enabled then
            updateESP()
            WindUI:Notify({ Title = "ESP", Content = "已刷新", Duration = 1 })
        else
            WindUI:Notify({ Title = "ESP", Content = "请先启用ESP", Duration = 2 })
        end
    end
})

local TeleportTab = Window:Tab({ 
    Title = "传送", 
    Icon = "map-pin"
})

TeleportTab:Section({ Title = "📍 快速传送" })

TeleportTab:Button({
    Title = "回到祭坛",
    Callback = function()
        teleportToAltar()
    end
})

Window:OnClose(function()
    stopPickup()
end)

WindUI:Notify({
    Title = "琼玖脚本",
    Content = "以为您启用黑暗欺骗",
    Duration = 3
})