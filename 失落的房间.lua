local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-失落的房间",
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
    Title = "QJ脚本-失落的房间",
    Icon = "sword",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    Draggable = true
})

local MainTab = Window:Tab({
    Title = "功能",
    Icon = "megaphone", 
    Locked = false,
})

MainTab:Toggle({
    Title = "透视玩家",
    Desc = "开启后可以透视玩家",
    Value = false,
    Callback = function(value)
    if state then
            local FillColor = Color3.fromRGB(255, 0, 0)
            local DepthMode = "AlwaysOnTop"
            local FillTransparency = 0.5
            local OutlineColor = Color3.fromRGB(255,255,255)
            local OutlineTransparency = 0

            local CoreGui = game:GetService("CoreGui")
            local Players = game:GetService("Players")
            local connections = {}

            local Storage = Instance.new("Folder")
            Storage.Parent = CoreGui
            Storage.Name = "Highlight_Storage"

            local function Highlight(plr)
                if not Storage or not Storage.Parent then return end

                local Highlight = Instance.new("Highlight")
                Highlight.Name = plr.Name
                Highlight.FillColor = FillColor
                Highlight.DepthMode = DepthMode
                Highlight.FillTransparency = FillTransparency
                Highlight.OutlineColor = OutlineColor
                Highlight.OutlineTransparency = 0
                Highlight.Parent = Storage

                local plrchar = plr.Character
                if plrchar then
                    Highlight.Adornee = plrchar
                end

                connections[plr] = plr.CharacterAdded:Connect(function(char)
                    if Highlight and Highlight.Parent then
                        Highlight.Adornee = char
                    end
                end)
            end

            connections.playerAdded = Players.PlayerAdded:Connect(Highlight)

            for i,v in next, Players:GetPlayers() do
                Highlight(v)
            end

            connections.playerRemoving = Players.PlayerRemoving:Connect(function(plr)
                if Storage and Storage.Parent then
                    local plrname = plr.Name
                    if Storage[plrname] then
                        Storage[plrname]:Destroy()
                    end
                end
                if connections[plr] then
                    connections[plr]:Disconnect()
                    connections[plr] = nil
                end
            end)

            Storage:SetAttribute("Connections", connections)
        else
            local CoreGui = game:GetService("CoreGui")
            local Storage = CoreGui:FindFirstChild("Highlight_Storage")
            if Storage then
                local connections = Storage:GetAttribute("Connections")
                if connections then
                    for key, connection in pairs(connections) do
                        if connection and typeof(connection) == "RBXScriptConnection" then
                            connection:Disconnect()
                        end
                    end
                end
                Storage:Destroy()
            end
        end
    end
})

local MonsterESP = {}

MonsterESP.Players = game:GetService("Players")
MonsterESP.Workspace = game:GetService("Workspace")
MonsterESP.RunService = game:GetService("RunService")
MonsterESP.CoreGui = game:GetService("CoreGui")
MonsterESP.Camera = MonsterESP.Workspace.CurrentCamera

MonsterESP.LocalPlayer = MonsterESP.Players.LocalPlayer

MonsterESP.Config = {
    Enabled = false,
    ShowBox = true,
    ShowName = true,
    ShowDistance = true,
    ShowHealth = true,
    ShowTracer = true,
    MaxDistance = 2000,
    TextSize = 14,
    BoxThickness = 1,
    TracerThickness = 1,
}

MonsterESP.MonsterConfig = {
    ecc26      = { DisplayName = "小丑",       Color = Color3.fromRGB(255, 0, 0) },
    ecc25      = { DisplayName = "木偶",       Color = Color3.fromRGB(255, 100, 0) },
    ecc10      = { DisplayName = "肉球",       Color = Color3.fromRGB(150, 0, 0) },
    Turned     = { DisplayName = "感染者",     Color = Color3.fromRGB(200, 0, 200) },
    Spider     = { DisplayName = "蜘蛛",       Color = Color3.fromRGB(50, 50, 50) },
    Sister     = { DisplayName = "修女",       Color = Color3.fromRGB(255, 0, 150) },
    Rot        = { DisplayName = "腐朽",       Color = Color3.fromRGB(0, 150, 0) },
    SaberTooth = { DisplayName = "剑齿虎",     Color = Color3.fromRGB(255, 200, 0) },
    Rig        = { DisplayName = "骨架",       Color = Color3.fromRGB(150, 150, 150) },
    Rat        = { DisplayName = "老鼠",       Color = Color3.fromRGB(100, 50, 0) },
    Raptor     = { DisplayName = "迅猛龙",     Color = Color3.fromRGB(0, 200, 200) },
    PlrTurned  = { DisplayName = "玩家感染者", Color = Color3.fromRGB(255, 0, 255) },
}

MonsterESP.MonsterAliases = {
    ["ecc26"] = {"ecc26", "jester", "ecc_26", "ecc:26"},
    ["ecc25"] = {"ecc25", "pupetina", "ecc_25", "ecc:25"},
    ["ecc10"] = {"ecc10", "meatball", "meat_ball", "ecc_10", "ecc:10"},
    ["Turned"] = {"turned"},
    ["Spider"] = {"spider", "ecc11", "ecc_11", "ecc:11"},
    ["Sister"] = {"sister"},
    ["Rot"] = {"rot", "ecc21", "ecc_21", "ecc:21"},
    ["SaberTooth"] = {"sabertooth", "saber_tooth"},
    ["Rig"] = {"rig"},
    ["Rat"] = {"rat"},
    ["Raptor"] = {"raptor"},
    ["PlrTurned"] = {"plrturned", "plr_turned", "playerturned"},
}

MonsterESP.ESPObjects = {}
MonsterESP.RenderConnection = nil
MonsterESP.ScreenGui = nil

function MonsterESP:GetRootPart(model)
    if not model then return nil end
    return model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("PrimaryPart")
        or model:FindFirstChildWhichIsA("BasePart")
end

function MonsterESP:GetHumanoid(model)
    if not model then return nil end
    return model:FindFirstChildWhichIsA("Humanoid")
end

function MonsterESP:Identify(instance)
    if not instance then return nil end
    local lowerName = string.lower(instance.Name)
    for key, config in pairs(self.MonsterConfig) do
        if lowerName == string.lower(key) then return config end
        local aliases = self.MonsterAliases[key]
        if aliases then
            for _, alias in ipairs(aliases) do
                if lowerName == alias then return config end
            end
        end
        if string.find(lowerName, string.lower(key), 1, true) then return config end
    end
    return nil
end

function MonsterESP:ClearObject(key)
    local obj = self.ESPObjects[key]
    if not obj then return end
    for _, field in ipairs({"box", "nameText", "distText", "healthBar", "healthBarBg", "tracer", "tracerOutline"}) do
        if obj[field] then obj[field]:Remove() obj[field] = nil end
    end
    self.ESPObjects[key] = nil
end

function MonsterESP:ClearAll()
    for key, _ in pairs(self.ESPObjects) do
        self:ClearObject(key)
    end
    self.ESPObjects = {}
end

function MonsterESP:Update()
    if not self.Config.Enabled then
        self:ClearAll()
        return
    end

    local char = self.LocalPlayer.Character
    local localRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end

    local currentMonsters = {}
    for _, instance in ipairs(self.Workspace:GetDescendants()) do
        if instance:IsA("Model") then
            local config = self:Identify(instance)
            if config then
                table.insert(currentMonsters, { Instance = instance, Config = config })
            end
        end
    end

    local activeKeys = {}

    for _, monster in ipairs(currentMonsters) do
        local model = monster.Instance
        local config = monster.Config
        local key = model:GetFullName()
        activeKeys[key] = true

        local rootPart = self:GetRootPart(model)
        if not rootPart then continue end

        local position = rootPart.Position
        local distance = (position - localRoot.Position).Magnitude

        if distance > self.Config.MaxDistance then
            local obj = self.ESPObjects[key]
            if obj then
                for _, field in ipairs({"box", "nameText", "distText", "healthBar", "healthBarBg", "tracer", "tracerOutline"}) do
                    if obj[field] then obj[field].Visible = false end
                end
            end
            continue
        end

        local screenPos, onScreen = self.Camera:WorldToViewportPoint(position)
        local headPos = self.Camera:WorldToViewportPoint(position + Vector3.new(0, 4, 0))
        local footPos = self.Camera:WorldToViewportPoint(position - Vector3.new(0, 4, 0))

        if not onScreen then
            local obj = self.ESPObjects[key]
            if obj then
                for _, field in ipairs({"box", "nameText", "distText", "healthBar", "healthBarBg", "tracer", "tracerOutline"}) do
                    if obj[field] then obj[field].Visible = false end
                end
            end
            self.ESPObjects[key] = obj
            continue
        end

        local obj = self.ESPObjects[key] or {}
        local height = math.abs(headPos.Y - footPos.Y)
        local width = math.max(height * 0.6, 30)
        local boxX = screenPos.X - width / 2
        local boxY = headPos.Y
        local color = config.Color
        local cfg = self.Config

        if cfg.ShowBox then
            if not obj.box then
                obj.box = Drawing.new("Square")
                obj.box.Thickness = cfg.BoxThickness
                obj.box.Filled = false
                obj.box.Transparency = 1
            end
            obj.box.Visible = true
            obj.box.Size = Vector2.new(width, height)
            obj.box.Position = Vector2.new(boxX, boxY)
            obj.box.Color = color
        elseif obj.box then
            obj.box.Visible = false
        end

        if cfg.ShowName then
            if not obj.nameText then
                obj.nameText = Drawing.new("Text")
                obj.nameText.Size = cfg.TextSize
                obj.nameText.Center = true
                obj.nameText.Outline = true
                obj.nameText.OutlineColor = Color3.new(0, 0, 0)
            end
            obj.nameText.Visible = true
            obj.nameText.Text = config.DisplayName
            obj.nameText.Position = Vector2.new(screenPos.X, boxY - 16)
            obj.nameText.Color = color
        elseif obj.nameText then
            obj.nameText.Visible = false
        end

        if cfg.ShowDistance then
            if not obj.distText then
                obj.distText = Drawing.new("Text")
                obj.distText.Size = cfg.TextSize - 2
                obj.distText.Center = true
                obj.distText.Outline = true
                obj.distText.OutlineColor = Color3.new(0, 0, 0)
            end
            obj.distText.Visible = true
            obj.distText.Text = string.format("%.0fm", distance)
            obj.distText.Position = Vector2.new(screenPos.X, boxY + height + 2)
            obj.distText.Color = Color3.fromRGB(255, 255, 255)
        elseif obj.distText then
            obj.distText.Visible = false
        end

        local humanoid = self:GetHumanoid(model)
        if cfg.ShowHealth and humanoid then
            local hp = humanoid.Health
            local maxHp = humanoid.MaxHealth
            local hpPercent = math.clamp(hp / maxHp, 0, 1)

            if not obj.healthBarBg then
                obj.healthBarBg = Drawing.new("Square")
                obj.healthBarBg.Filled = true
                obj.healthBarBg.Transparency = 0.5
                obj.healthBarBg.Color = Color3.new(0, 0, 0)
            end
            if not obj.healthBar then
                obj.healthBar = Drawing.new("Square")
                obj.healthBar.Filled = true
                obj.healthBar.Transparency = 1
            end

            local barWidth = 4
            local barHeight = height
            local barX = boxX - barWidth - 2
            local barY = boxY

            obj.healthBarBg.Visible = true
            obj.healthBarBg.Size = Vector2.new(barWidth, barHeight)
            obj.healthBarBg.Position = Vector2.new(barX, barY)

            obj.healthBar.Visible = true
            obj.healthBar.Size = Vector2.new(barWidth, barHeight * hpPercent)
            obj.healthBar.Position = Vector2.new(barX, barY + barHeight * (1 - hpPercent))
            obj.healthBar.Color = Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0)
        else
            if obj.healthBar then obj.healthBar.Visible = false end
            if obj.healthBarBg then obj.healthBarBg.Visible = false end
        end

        if cfg.ShowTracer then
            if not obj.tracerOutline then
                obj.tracerOutline = Drawing.new("Line")
                obj.tracerOutline.Thickness = cfg.TracerThickness + 2
                obj.tracerOutline.Transparency = 0.5
                obj.tracerOutline.Color = Color3.new(0, 0, 0)
            end
            if not obj.tracer then
                obj.tracer = Drawing.new("Line")
                obj.tracer.Thickness = cfg.TracerThickness
                obj.tracer.Transparency = 1
            end

            local screenCenter = Vector2.new(self.Camera.ViewportSize.X / 2, self.Camera.ViewportSize.Y)
            local targetPos = Vector2.new(screenPos.X, footPos.Y)

            obj.tracerOutline.Visible = true
            obj.tracerOutline.From = screenCenter
            obj.tracerOutline.To = targetPos

            obj.tracer.Visible = true
            obj.tracer.From = screenCenter
            obj.tracer.To = targetPos
            obj.tracer.Color = color
        else
            if obj.tracer then obj.tracer.Visible = false end
            if obj.tracerOutline then obj.tracerOutline.Visible = false end
        end

        self.ESPObjects[key] = obj
    end

    for key, _ in pairs(self.ESPObjects) do
        if not activeKeys[key] then
            self:ClearObject(key)
        end
    end
end

function MonsterESP:Init()
    if self.ScreenGui then return end

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "LostRoomsMonsterESP"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Parent = self.CoreGui

    self.Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and self:Identify(descendant) then
   
        end
    end)
end

MonsterESP:Init()

MonsterESP.RenderConnection = MonsterESP.RunService:BindToRenderStep("LostRoomsMonsterESP", 200, function()
    MonsterESP:Update()
end)

MainTab:Toggle({
    Title = "开启怪物透视",
    Desc = "显示所有怪物的位置、距离和血量",
    Value = false,
    Callback = function(value)
        MonsterESP.Config.Enabled = value
        if value then
            print("[LostRooms] 怪物透视: 开启")
        else
            print("[LostRooms] 怪物透视: 关闭")
            MonsterESP:ClearAll()
        end
    end
})

local ItemESP = {}

ItemESP.Players = game:GetService("Players")
ItemESP.Workspace = game:GetService("Workspace")
ItemESP.RunService = game:GetService("RunService")
ItemESP.CoreGui = game:GetService("CoreGui")
ItemESP.Camera = ItemESP.Workspace.CurrentCamera

ItemESP.LocalPlayer = ItemESP.Players.LocalPlayer

ItemESP.Config = {
    Enabled = false,
    ShowBox = true,
    ShowName = true,
    ShowDistance = true,
    ShowTracer = true,
    MaxDistance = 500,
    TextSize = 13,
    BoxThickness = 1,
    TracerThickness = 1,
}

ItemESP.ItemConfig = {

    Uzi             = { DisplayName = "乌兹",           Color = Color3.fromRGB(255, 60, 60) },
    Shotgun         = { DisplayName = "霰弹枪",         Color = Color3.fromRGB(255, 60, 60) },
    Rifle           = { DisplayName = "步枪",           Color = Color3.fromRGB(255, 60, 60) },
    Revolver        = { DisplayName = "左轮",           Color = Color3.fromRGB(255, 60, 60) },
    Glock17         = { DisplayName = "格洛克17",       Color = Color3.fromRGB(255, 60, 60) },
    Ak47            = { DisplayName = "AK47",           Color = Color3.fromRGB(255, 60, 60) },
    BanHammer       = { DisplayName = "禁锤",           Color = Color3.fromRGB(255, 60, 60) },
    StunStick       = { DisplayName = "电击棍",         Color = Color3.fromRGB(255, 60, 60) },

    UziAmmo         = { DisplayName = "乌兹弹药",       Color = Color3.fromRGB(255, 160, 40) },
    ShotgunAmmo     = { DisplayName = "霰弹",           Color = Color3.fromRGB(255, 160, 40) },
    RifleAmmo       = { DisplayName = "步枪弹药",       Color = Color3.fromRGB(255, 160, 40) },
    RevolverAmmo    = { DisplayName = "左轮弹药",       Color = Color3.fromRGB(255, 160, 40) },
    Glock17Ammo     = { DisplayName = "格洛克弹药",     Color = Color3.fromRGB(255, 160, 40) },
    Ak47Ammo        = { DisplayName = "AK47弹药",       Color = Color3.fromRGB(255, 160, 40) },
    Bullets         = { DisplayName = "子弹",           Color = Color3.fromRGB(255, 160, 40) },

    Vest            = { DisplayName = "防弹背心",       Color = Color3.fromRGB(60, 160, 255) },
    TitaniumVest    = { DisplayName = "钛金背心",       Color = Color3.fromRGB(60, 160, 255) },
    TitaniumLegArmor= { DisplayName = "钛金腿甲",       Color = Color3.fromRGB(60, 160, 255) },
    LegArmor        = { DisplayName = "腿甲",           Color = Color3.fromRGB(60, 160, 255) },
    GasMask         = { DisplayName = "防毒面具",       Color = Color3.fromRGB(60, 160, 255) },
    NightVision     = { DisplayName = "夜视仪",         Color = Color3.fromRGB(60, 160, 255) },
    
    MedKit          = { DisplayName = "医疗包",         Color = Color3.fromRGB(60, 255, 60) },
    Coffee          = { DisplayName = "咖啡",           Color = Color3.fromRGB(60, 255, 60) },
    Carrot          = { DisplayName = "胡萝卜",         Color = Color3.fromRGB(60, 255, 60) },


    WalkieTalkie    = { DisplayName = "对讲机",         Color = Color3.fromRGB(220, 200, 60) },
    Camera          = { DisplayName = "相机",           Color = Color3.fromRGB(220, 200, 60) },
    BearTrap        = { DisplayName = "捕兽夹",         Color = Color3.fromRGB(220, 200, 60) },
    BarbedWire      = { DisplayName = "铁丝网",         Color = Color3.fromRGB(220, 200, 60) },
    Alarm           = { DisplayName = "警报器",         Color = Color3.fromRGB(220, 200, 60) },
    Can             = { DisplayName = "罐头",           Color = Color3.fromRGB(220, 200, 60) },

    WiresGenerator      = { DisplayName = "电线发电机",   Color = Color3.fromRGB(180, 100, 255) },
    WaterGenerator      = { DisplayName = "水发电机",     Color = Color3.fromRGB(180, 100, 255) },
    Water               = { DisplayName = "水",           Color = Color3.fromRGB(180, 100, 255) },
    MetalGenerator      = { DisplayName = "金属发电机",   Color = Color3.fromRGB(180, 100, 255) },
    MetalFloor          = { DisplayName = "金属地板",     Color = Color3.fromRGB(180, 100, 255) },
    GunpowderGenerator  = { DisplayName = "火药发电机",   Color = Color3.fromRGB(180, 100, 255) },
    GlassGenerator      = { DisplayName = "玻璃发电机",   Color = Color3.fromRGB(180, 100, 255) },
    GeneratorCharger    = { DisplayName = "发电机充电器", Color = Color3.fromRGB(180, 100, 255) },
}

ItemESP.ESPObjects = {}
ItemESP.RenderConnection = nil
ItemESP.ScreenGui = nil

function ItemESP:GetRootPart(model)
    if not model then return nil end
    return model:FindFirstChild("HumanoidRootPart")
        or model:FindFirstChild("PrimaryPart")
        or model:FindFirstChildWhichIsA("BasePart")
end

function ItemESP:Identify(instance)
    if not instance then return nil end
    local lowerName = string.lower(instance.Name)
    for key, config in pairs(self.ItemConfig) do
        if lowerName == string.lower(key) then return config end
    end
    return nil
end

function ItemESP:ClearObject(key)
    local obj = self.ESPObjects[key]
    if not obj then return end
    for _, field in ipairs({"box", "nameText", "distText", "tracer", "tracerOutline"}) do
        if obj[field] then obj[field]:Remove() obj[field] = nil end
    end
    self.ESPObjects[key] = nil
end

function ItemESP:ClearAll()
    for key, _ in pairs(self.ESPObjects) do
        self:ClearObject(key)
    end
    self.ESPObjects = {}
end

function ItemESP:Update()
    if not self.Config.Enabled then
        self:ClearAll()
        return
    end

    local char = self.LocalPlayer.Character
    local localRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end

    local currentItems = {}
    for _, instance in ipairs(self.Workspace:GetDescendants()) do
        if instance:IsA("Model") then
            local config = self:Identify(instance)
            if config then
                table.insert(currentItems, { Instance = instance, Config = config })
            end
        end
    end

    local activeKeys = {}

    for _, item in ipairs(currentItems) do
        local model = item.Instance
        local config = item.Config
        local key = model:GetFullName()
        activeKeys[key] = true

        local rootPart = self:GetRootPart(model)
        if not rootPart then continue end

        local position = rootPart.Position
        local distance = (position - localRoot.Position).Magnitude

        if distance > self.Config.MaxDistance then
            local obj = self.ESPObjects[key]
            if obj then
                for _, field in ipairs({"box", "nameText", "distText", "tracer", "tracerOutline"}) do
                    if obj[field] then obj[field].Visible = false end
                end
            end
            continue
        end

        local screenPos, onScreen = self.Camera:WorldToViewportPoint(position)
        if not onScreen then
            local obj = self.ESPObjects[key]
            if obj then
                for _, field in ipairs({"box", "nameText", "distText", "tracer", "tracerOutline"}) do
                    if obj[field] then obj[field].Visible = false end
                end
            end
            self.ESPObjects[key] = obj
            continue
        end

        local obj = self.ESPObjects[key] or {}
        local sizeY = math.max(30, 5000 / distance)
        local sizeX = sizeY * 0.7
        local boxX = screenPos.X - sizeX / 2
        local boxY = screenPos.Y - sizeY / 2
        local color = config.Color
        local cfg = self.Config

   
        if cfg.ShowBox then
            if not obj.box then
                obj.box = Drawing.new("Square")
                obj.box.Thickness = cfg.BoxThickness
                obj.box.Filled = false
                obj.box.Transparency = 1
            end
            obj.box.Visible = true
            obj.box.Size = Vector2.new(sizeX, sizeY)
            obj.box.Position = Vector2.new(boxX, boxY)
            obj.box.Color = color
        elseif obj.box then
            obj.box.Visible = false
        end

        if cfg.ShowName then
            if not obj.nameText then
                obj.nameText = Drawing.new("Text")
                obj.nameText.Size = cfg.TextSize
                obj.nameText.Center = true
                obj.nameText.Outline = true
                obj.nameText.OutlineColor = Color3.new(0, 0, 0)
            end
            obj.nameText.Visible = true
            obj.nameText.Text = config.DisplayName
            obj.nameText.Position = Vector2.new(screenPos.X, boxY - 14)
            obj.nameText.Color = color
        elseif obj.nameText then
            obj.nameText.Visible = false
        end

        if cfg.ShowDistance then
            if not obj.distText then
                obj.distText = Drawing.new("Text")
                obj.distText.Size = cfg.TextSize - 2
                obj.distText.Center = true
                obj.distText.Outline = true
                obj.distText.OutlineColor = Color3.new(0, 0, 0)
            end
            obj.distText.Visible = true
            obj.distText.Text = string.format("%.0fm", distance)
            obj.distText.Position = Vector2.new(screenPos.X, boxY + sizeY + 2)
            obj.distText.Color = Color3.fromRGB(255, 255, 255)
        elseif obj.distText then
            obj.distText.Visible = false
        end

  
        if cfg.ShowTracer then
            if not obj.tracerOutline then
                obj.tracerOutline = Drawing.new("Line")
                obj.tracerOutline.Thickness = cfg.TracerThickness + 2
                obj.tracerOutline.Transparency = 0.5
                obj.tracerOutline.Color = Color3.new(0, 0, 0)
            end
            if not obj.tracer then
                obj.tracer = Drawing.new("Line")
                obj.tracer.Thickness = cfg.TracerThickness
                obj.tracer.Transparency = 1
            end

            local screenCenter = Vector2.new(self.Camera.ViewportSize.X / 2, self.Camera.ViewportSize.Y)
            local targetPos = Vector2.new(screenPos.X, screenPos.Y + sizeY / 2)

            obj.tracerOutline.Visible = true
            obj.tracerOutline.From = screenCenter
            obj.tracerOutline.To = targetPos

            obj.tracer.Visible = true
            obj.tracer.From = screenCenter
            obj.tracer.To = targetPos
            obj.tracer.Color = color
        else
            if obj.tracer then obj.tracer.Visible = false end
            if obj.tracerOutline then obj.tracerOutline.Visible = false end
        end

        self.ESPObjects[key] = obj
    end

    for key, _ in pairs(self.ESPObjects) do
        if not activeKeys[key] then
            self:ClearObject(key)
        end
    end
end

function ItemESP:Init()
    if self.ScreenGui then return end

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "LostRoomsItemESP"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.Parent = self.CoreGui

    self.Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Model") and self:Identify(descendant) then end
    end)
end

ItemESP:Init()

ItemESP.RenderConnection = ItemESP.RunService:BindToRenderStep("LostRoomsItemESP", 201, function()
    ItemESP:Update()
end)

MainTab:Toggle({
    Title = "透视物品",
    Desc = "显示武器、弹药、护甲、道具等所有物品位置",
    Value = false,
    Callback = function(value)
        ItemESP.Config.Enabled = value
        if value then
            print("[LostRooms] 物品透视: 开启")
        else
            print("[LostRooms] 物品透视: 关闭")
            ItemESP:ClearAll()
        end
    end
})

