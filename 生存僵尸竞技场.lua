local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

local function refreshCharacter()
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    RootPart = Character:WaitForChild("HumanoidRootPart")
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.1)
    refreshCharacter()
end)

local function safeCall(fn, ...)
    local ok, a, b, c = pcall(fn, ...)
    if ok then
        return a, b, c
    end
    warn("[SZA] " .. tostring(a))
    return nil
end

local function getRequest()
    return http_request or request or (syn and syn.request) or (fluxus and fluxus.request)
end

local makeFolder = makefolder or function() end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()
local SZAModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/tylerdurden223/papi/main/SurviveZombieArenaModule"))()

if type(SZAModule) ~= "table" then
    error("加载失败")
end

local function notify(title, content, icon, duration)
    WindUI:Notify({
        Title = title or "SZA",
        Content = content or "",
        Icon = icon or "info",
        Duration = duration or 3
    })
end

local featureFlags = {}
local valueStore = {}
local elementStore = {}
local running = true
local connections = {}

local function trackConnection(conn)
    connections[#connections + 1] = conn
    return conn
end

local function makeFlag(name, defaultValue)
    local flag = {
        Value = defaultValue,
        _windElem = nil
    }

    function flag:Set(v)
        self.Value = v
        if self._windElem then
            safeCall(function()
                self._windElem:Set(v)
            end)
        end
    end

    function flag:SetValue(v)
        self:Set(v)
    end

    featureFlags[name] = flag
    return flag
end

local function makeValue(name, defaultValue)
    local obj = { Value = defaultValue }
    valueStore[name] = obj
    return obj
end

makeFlag("AutoKill", false)             -- 自动射击
makeFlag("InstaKill", false)            -- 瞬间击杀
makeFlag("ZombieESP", false)            -- 僵尸透视
makeFlag("AutoBuyGear", false)          -- 自动购买装备
makeFlag("InvisEnabled", false)         -- 隐身/无敌
makeFlag("AutoWeaponUpgrade", false)    -- 自动武器升级
makeFlag("AutoHealthUpgrade", false)    -- 自动生命升级
makeFlag("AutoSkipWave", false)         -- 自动跳过波次
makeFlag("AutoDoubleCredits", false)    -- 自动双倍金币
makeFlag("AntiAFK", false)              -- 防挂机
makeFlag("Noclip", false)              -- 穿墙
makeFlag("EnableFly", false)            -- 飞行
makeFlag("InfiniteJump", false)         -- 无限跳跃
makeFlag("Fullbright", false)           -- 全图明亮
makeFlag("AutoCollectShards", false)    -- 自动收集碎片

makeValue("AutoKillDelay", 0.1)
makeValue("InstaKillDamage", 999999999)
makeValue("InstaKillDelay", 0.1)
makeValue("ESPColor", "Red")
makeValue("GearBuySelect", { "Landmine" })
makeValue("GearBuyDelay", 0.5)
makeValue("InvisTransparency", 0)
makeValue("WeaponUpgradeDelay", 0.5)
makeValue("HealthUpgradeDelay", 0.5)
makeValue("WalkSpeed", 16)
makeValue("FlyHeight", 0)
makeValue("JumpPower", 7.2)
makeValue("TargetPriority", "Closest")
makeValue("AutoKillRadius", 60)
makeValue("ZombieTypeFilter", {})
makeValue("ESPMaxDistance", 200)
makeValue("KillTierTarget", "Brute")

safeCall(function()
    SZAModule.init(featureFlags, valueStore)
end)

local savedLighting = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    FogEnd = Lighting.FogEnd,
    ClockTime = Lighting.ClockTime
}

local queueRemotes = ReplicatedStorage:FindFirstChild("QueueRemotes")
local waveRemotes = ReplicatedStorage:FindFirstChild("WaveRemotes")
local zombieRemotes = ReplicatedStorage:FindFirstChild("ZombieRemotes")

local skipVoteRemote = waveRemotes and waveRemotes:FindFirstChild("SkipVote")
local doubleCreditsRemote = waveRemotes and waveRemotes:FindFirstChild("DoubleCreditsVote")
local zombieDamageRemote = zombieRemotes and zombieRemotes:FindFirstChild("ZombieDamage")
local leaveQueueRemote = queueRemotes and queueRemotes:FindFirstChild("LeaveQueue")
local createPartyRemote = queueRemotes and queueRemotes:FindFirstChild("CreateParty")
local showPartySizeRemote = queueRemotes and queueRemotes:FindFirstChild("ShowPartySizeUI")
local queueUpdateRemote = queueRemotes and queueRemotes:FindFirstChild("QueueUpdate")

local queueState = {
    difficulty = "普通",
    map = "RooftopSiege",
    partySize = 1,
    autoOn = false,
    hookConn = nil,
    updateConn = nil
}

local playerHighlights = {}
local healthLabelsEnabled = false
local fpsSamples = {}
local invisToggleKey = Enum.KeyCode.Z
local backgroundLoops = {
    stats = true,
    queue = true,
    shards = true,
    credits = true,
    highlights = true
}

local authConfig = {
    Enabled = false,
    Strict = false,
    BaseUrl = "https://neoxsoftworks.eu",
    KeyFile = "neoxkey.txt"
}

local requestFn = getRequest()

local function getGameName()
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    if ok and info and info.Name and info.Name ~= "" then
        return info.Name
    end
    if game.Name and game.Name ~= "" then
        return game.Name
    end
    return "未知游戏"
end

local function getHwid()
    local analytics = game:GetService("RbxAnalyticsService")
    local ok, hwid = pcall(function()
        return analytics:GetClientId()
    end)
    if ok then
        return hwid
    end
    return nil
end

local function loadSavedKey()
    if readfile and isfile and isfile(authConfig.KeyFile) then
        return readfile(authConfig.KeyFile)
    end
    return nil
end

local function saveKey(key)
    if writefile then
        safeCall(function()
            writefile(authConfig.KeyFile, key)
        end)
    end
end

local function getNonce()
    if not requestFn then
        return nil, "HTTP 请求函数不可用"
    end
    local response = safeCall(function()
        return requestFn({
            Url = authConfig.BaseUrl .. "/api/get-nonce",
            Method = "GET",
            Headers = {
                ["Content-Type"] = "application/json"
            }
        })
    end)
    if not response or not response.Body then
        return nil, "获取 nonce 失败"
    end
    local decoded = safeCall(function()
        return HttpService:JSONDecode(response.Body)
    end)
    if not decoded or not decoded.nonce then
        return nil, "无效的 nonce 响应"
    end
    return decoded.nonce, nil
end

local function validateKey(key)
    if key == nil or key:match("^%s*$") then
        return false, "密钥为空"
    end
    if not requestFn then
        return false, "HTTP 请求函数不可用"
    end

    local hwid = getHwid()
    if not hwid then
        return false, "获取 HWID 失败"
    end

    local nonce, nonceError = getNonce()
    if not nonce then
        return false, nonceError
    end

    local payload = HttpService:JSONEncode({
        key = key,
        hwid = hwid,
        nonce = nonce,
        game_name = getGameName()
    })

    local response = safeCall(function()
        return requestFn({
            Url = authConfig.BaseUrl .. "/api/validate-key",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = payload
        })
    end)

    if not response or not response.Body then
        return false, "授权服务器无响应"
    end

    local decoded = safeCall(function()
        return HttpService:JSONDecode(response.Body)
    end)
    if type(decoded) ~= "table" or decoded.valid == nil then
        return false, "无效的授权响应"
    end

    if not decoded.valid then
        return false, decoded.reason or "密钥无效或已过期"
    end

    return true, nil
end

local function runAuth()
    if not authConfig.Enabled then
        return true
    end

    local saved = loadSavedKey()
    if saved and saved ~= "" then
        local ok, reason = validateKey(saved)
        if ok then
            return true
        end
        notify("授权", "保存的密钥无效: " .. tostring(reason), "triangle-alert", 3)
    end

    local envKey = (getgenv and getgenv().NEOX_KEY) or _G.NEOX_KEY
    if envKey and envKey ~= "" then
        local ok, reason = validateKey(envKey)
        if ok then
            saveKey(envKey)
            return true
        end
        notify("授权", "NEOX_KEY 无效: " .. tostring(reason), "triangle-alert", 4)
    else
        notify("授权", "缺少密钥。请设置 getgenv().NEOX_KEY", "triangle-alert", 6)
    end

    return false
end

local function cleanupHighlights()
    for _, hl in pairs(playerHighlights) do
        if hl and hl.Parent then
            hl:Destroy()
        end
    end
    table.clear(playerHighlights)
end

local function applyPlayerHighlights()
    cleanupHighlights()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hl = Instance.new("Highlight")
            hl.FillColor = Color3.fromRGB(0, 200, 255)
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.FillTransparency = 0.5
            hl.Parent = plr.Character
            playerHighlights[plr] = hl
        end
    end
end

local function getHumanoid()
    local character = LocalPlayer.Character
    if not character then
        return nil
    end
    return character:FindFirstChildOfClass("Humanoid")
end

local function applyJumpPower(value)
    local hum = getHumanoid()
    if hum then
        hum.JumpHeight = value
    end
end

local function applyFullbright(state)
    featureFlags.Fullbright.Value = state
    if state then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
        Lighting.FogEnd = 100000
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("ColorCorrectionEffect") then
                effect.Enabled = false
            end
        end
    else
        Lighting.Brightness = savedLighting.Brightness
        Lighting.Ambient = savedLighting.Ambient
        Lighting.OutdoorAmbient = savedLighting.OutdoorAmbient
        Lighting.FogEnd = savedLighting.FogEnd
        Lighting.ClockTime = savedLighting.ClockTime
        for _, effect in ipairs(Lighting:GetChildren()) do
            if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") or effect:IsA("ColorCorrectionEffect") then
                effect.Enabled = true
            end
        end
    end
end

local function restoreCharacterDefaults()
    local character = LocalPlayer.Character
    if character then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bodyVelocity = hrp:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end

        for _, obj in ipairs(character:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.CanCollide = true
                if obj.Name ~= "HumanoidRootPart" then
                    obj.Transparency = 0
                end
            end
        end

        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpHeight = 7.2
        end
    end

    local invisChair = workspace:FindFirstChild("invischair")
    if invisChair then
        invisChair:Destroy()
    end

    safeCall(function()
        workspace.CurrentCamera.FieldOfView = 70
    end)
end

local function updateHealthLabels()
    local zombiesFolder = workspace:FindFirstChild("Zombies_Local")
    if not zombiesFolder then
        return
    end

    for _, zombie in ipairs(zombiesFolder:GetChildren()) do
        local hrp = zombie:FindFirstChild("HumanoidRootPart")
        local humanoid = zombie:FindFirstChildOfClass("Humanoid")
        if hrp and humanoid then
            local healthBar = hrp:FindFirstChild("HealthBar")
            local label = healthBar and healthBar:FindFirstChild("Label")
            if label and label:IsA("TextLabel") then
                if healthLabelsEnabled then
                    local hp = math.floor((humanoid.Health / math.max(humanoid.MaxHealth, 1)) * 100)
                    local shortName = zombie.Name:match("_(.+)$") or zombie.Name
                    label.Text = shortName .. " | " .. hp .. "%"
                else
                    label.Text = "僵尸"
                end
            end
        end
    end
end

local function fireSkipVote()
    local remote = skipVoteRemote
    if not remote then
        local wave = ReplicatedStorage:FindFirstChild("WaveRemotes")
        remote = wave and wave:FindFirstChild("SkipVote")
    end
    if remote then
        safeCall(function()
            remote:FireServer(true)
        end)
    end
end

local function fireDoubleCreditsVote()
    local remote = doubleCreditsRemote
    if not remote then
        local wave = ReplicatedStorage:FindFirstChild("WaveRemotes")
        remote = wave and wave:FindFirstChild("DoubleCreditsVote")
    end
    if remote then
        safeCall(function()
            remote:FireServer(true)
        end)
    end
end

local function killTier(tierName)
    local zombiesFolder = workspace:FindFirstChild("Zombies_Local")
    if not zombiesFolder or not zombieDamageRemote then
        return
    end

    for _, zombie in ipairs(zombiesFolder:GetChildren()) do
        safeCall(function()
            local thisTier = zombie:GetAttribute("Tier")
            local matchByName = zombie.Name:find(tierName) ~= nil
            if thisTier == tierName or matchByName then
                local id = tonumber(zombie.Name:match("%d+")) or 0
                zombieDamageRemote:FireServer(id, 999999999)
            end
        end)
    end
end

local function collectShardsTick()
    if not featureFlags.AutoCollectShards.Value then
        return
    end

    refreshCharacter()
    if not RootPart then
        return
    end

    local targetColor = Color3.fromRGB(170, 0, 255)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if not featureFlags.AutoCollectShards.Value then
            break
        end
        if obj:IsA("BasePart") and not obj.Anchored then
            local diff = math.abs(obj.Color.R - targetColor.R) + math.abs(obj.Color.G - targetColor.G) + math.abs(obj.Color.B - targetColor.B)
            if diff < 0.1 and (RootPart.Position - obj.Position).Magnitude < 80 then
                RootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
                task.wait(0.05)
            end
        end
    end
end

local function getWaveText()
    local wave = workspace:GetAttribute("CurrentWave")
    if wave then
        return tostring(wave)
    end
    return "--"
end

local function getCreditsText()
    local stats = LocalPlayer:FindFirstChild("leaderstats")
    if not stats then
        return "--"
    end

    local value = stats:FindFirstChild("Credits") or stats:FindFirstChild("Minerals") or stats:FindFirstChild("Cash")
    if value then
        return tostring(value.Value)
    end
    return "--"
end

local function getHealthText()
    local hum = getHumanoid()
    if not hum then
        return "-- / --"
    end
    return string.format("%d / %d", math.floor(hum.Health), math.floor(hum.MaxHealth))
end

local function getFPS()
    if #fpsSamples == 0 then
        return 0
    end
    local sum = 0
    for _, sample in ipairs(fpsSamples) do
        sum = sum + sample
    end
    return math.floor(sum / #fpsSamples)
end

local function moveToNearestQueuePad()
    local queuesFolder = workspace:FindFirstChild("Queues")
    if not queuesFolder then
        return false
    end

    refreshCharacter()
    if not RootPart then
        return false
    end

    local nearestPart = nil
    local nearestDistance = math.huge
    for _, queueObj in ipairs(queuesFolder:GetChildren()) do
        local base = queueObj:FindFirstChild("BillboardPart") or queueObj:FindFirstChildWhichIsA("BasePart")
        if base then
            local d = (RootPart.Position - base.Position).Magnitude
            if d < nearestDistance then
                nearestDistance = d
                nearestPart = base
            end
        end
    end

    if nearestPart then
        RootPart.CFrame = CFrame.new(nearestPart.Position + Vector3.new(0, 3, 0))
        return true
    end
    return false
end

local function createParty()
    local remote = createPartyRemote or (queueRemotes and queueRemotes:FindFirstChild("CreateParty"))
    if not remote then
        return
    end
    safeCall(function()
        remote:FireServer(queueState.partySize, queueState.difficulty, queueState.map)
    end)
end

local function leaveQueue()
    local remote = leaveQueueRemote or (queueRemotes and queueRemotes:FindFirstChild("LeaveQueue"))
    if remote then
        safeCall(function()
            remote:FireServer()
        end)
    end
end

local function stopQueueHooks()
    if queueState.hookConn then
        queueState.hookConn:Disconnect()
        queueState.hookConn = nil
    end
    if queueState.updateConn then
        queueState.updateConn:Disconnect()
        queueState.updateConn = nil
    end
end

local function startQueueHooks()
    stopQueueHooks()

    local showRemote = showPartySizeRemote or (queueRemotes and queueRemotes:FindFirstChild("ShowPartySizeUI"))
    local updateRemote = queueUpdateRemote or (queueRemotes and queueRemotes:FindFirstChild("QueueUpdate"))

    if showRemote and showRemote.OnClientEvent then
        queueState.hookConn = showRemote.OnClientEvent:Connect(function(signal)
            if not queueState.autoOn then
                return
            end
            if signal then
                task.wait(0.1)
                createParty()
            end
        end)
        trackConnection(queueState.hookConn)
    end

    if updateRemote and updateRemote.OnClientEvent then
        queueState.updateConn = updateRemote.OnClientEvent:Connect(function(payload)
            if not queueState.autoOn then
                return
            end
            local action = type(payload) == "table" and payload.Action or nil
            if action == "Left" or action == "TeleportFailed" then
                task.wait(3)
                moveToNearestQueuePad()
            end
        end)
        trackConnection(queueState.updateConn)
    end

    moveToNearestQueuePad()
end

local authPassed = runAuth()
if not authPassed and authConfig.Strict then
    return
end

WindUI:AddTheme({
    Name = "NEOX",
    Background = Color3.fromHex("#0f0f1a"),
    Dialog = Color3.fromHex("#161624"),
    Accent = Color3.fromHex("#7c3aed"),
    Outline = Color3.fromHex("#7c3aed"),
    Button = Color3.fromHex("#3b2f6e"),
    Text = Color3.fromHex("#f0eeff"),
    Placeholder = Color3.fromHex("#9d8ec7"),
    Icon = Color3.fromHex("#c4b5fd"),
    Slider = Color3.fromHex("#7c3aed")
})

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-生存僵尸竞技场",
    Author = "作者：琼玖",
    Folder = "NEOX_HUB_SZA",
    Size = UDim2.fromOffset(600, 450),
    Theme = "NEOX",
    ToggleKey = Enum.KeyCode.Q,
    ScrollBarEnabled = true,
    KeySystem = false
})

WindUI:SetNotificationLower(true)

Window:OnDestroy(function()
    running = false
    backgroundLoops.stats = false
    backgroundLoops.queue = false
    backgroundLoops.shards = false
    backgroundLoops.credits = false
    backgroundLoops.highlights = false

    cleanupHighlights()

    for _, conn in ipairs(connections) do
        if conn and conn.Disconnect then
            conn:Disconnect()
        end
    end

    safeCall(function() SZAModule.stopAutoKill() end)
    safeCall(function() SZAModule.stopInstaKill() end)
    safeCall(function() SZAModule.stopAutoBuy() end)
    safeCall(function() SZAModule.stopWeaponUpgrade() end)
    safeCall(function() SZAModule.stopHealthUpgrade() end)
    safeCall(function() SZAModule.stopSkip() end)
    safeCall(function() SZAModule.stopNoclip() end)
    safeCall(function() SZAModule.stopFly() end)
    safeCall(function() SZAModule.disableInvisibility() end)
    safeCall(function() SZAModule.clearESP() end)
    applyFullbright(false)
    restoreCharacterDefaults()
    stopQueueHooks()
    leaveQueue()
end)

local CombatTab = Window:Tab({ Title = "战斗", Icon = "crosshair" })
local ESPTab = Window:Tab({ Title = "透视", Icon = "eye" })
local GearsTab = Window:Tab({ Title = "装备", Icon = "box" })
local ImmortalTab = Window:Tab({ Title = "不死", Icon = "shield" })
local UpgradesTab = Window:Tab({ Title = "升级", Icon = "zap" })
local WaveTab = Window:Tab({ Title = "波次", Icon = "waves" })
local MiscTab = Window:Tab({ Title = "杂项", Icon = "settings" })
local QueueTab = Window:Tab({ Title = "队列", Icon = "users" })
local InfoTab = Window:Tab({ Title = "信息", Icon = "info" })
local ConfigTab = Window:Tab({ Title = "配置", Icon = "save" })

CombatTab:Section({ Title = "击杀" })
featureFlags.AutoKill._windElem = CombatTab:Toggle({
    Title = "自动射击",
    Flag = "AutoKill",
    Value = featureFlags.AutoKill.Value,
    Callback = function(state)
        featureFlags.AutoKill.Value = state
        if state then
            if featureFlags.InstaKill.Value then
                featureFlags.InstaKill:Set(false)
            end
            safeCall(SZAModule.startAutoKill)
        else
            safeCall(SZAModule.stopAutoKill)
        end
    end
})

elementStore.AutoKillDelay = CombatTab:Slider({
    Title = "自动射击延迟（秒）",
    Step = 0.01,
    Value = { Min = 0, Max = 2, Default = valueStore.AutoKillDelay.Value },
    Callback = function(v)
        valueStore.AutoKillDelay.Value = v
    end
})

featureFlags.InstaKill._windElem = CombatTab:Toggle({
    Title = "瞬间击杀",
    Flag = "InstaKill",
    Value = featureFlags.InstaKill.Value,
    Callback = function(state)
        featureFlags.InstaKill.Value = state
        if state then
            if featureFlags.AutoKill.Value then
                featureFlags.AutoKill:Set(false)
            end
            safeCall(SZAModule.startInstaKill)
        else
            safeCall(SZAModule.stopInstaKill)
        end
    end
})

elementStore.InstaDamage = CombatTab:Slider({
    Title = "伤害值",
    Step = 1000,
    Value = { Min = 1000, Max = 999999999, Default = valueStore.InstaKillDamage.Value },
    Callback = function(v)
        valueStore.InstaKillDamage.Value = v
    end
})

elementStore.InstaDelay = CombatTab:Slider({
    Title = "击杀延迟（秒）",
    Step = 0.01,
    Value = { Min = 0, Max = 2, Default = valueStore.InstaKillDelay.Value },
    Callback = function(v)
        valueStore.InstaKillDelay.Value = v
    end
})

CombatTab:Button({
    Title = "击杀全部",
    Callback = function()
        safeCall(SZAModule.killAll)
    end
})

CombatTab:Section({ Title = "瞄准" })
elementStore.TargetPriority = CombatTab:Dropdown({
    Title = "目标优先级",
    Values = { "最近", "最高血量", "最低血量" },
    Value = valueStore.TargetPriority.Value,
    Multi = false,
    Callback = function(v)
        valueStore.TargetPriority.Value = v
    end
})

elementStore.KillRadius = CombatTab:Slider({
    Title = "自动击杀半径（格）",
    Step = 5,
    Value = { Min = 10, Max = 200, Default = valueStore.AutoKillRadius.Value },
    Callback = function(v)
        valueStore.AutoKillRadius.Value = v
    end
})

local zombieTiers = { "Walker", "Runner", "Decayed", "Brute", "Ashwalker", "Shade", "Volatile", "Howler", "Electro" }
elementStore.ZombieFilter = CombatTab:Dropdown({
    Title = "僵尸类型过滤",
    Values = zombieTiers,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(v)
        valueStore.ZombieTypeFilter.Value = v
    end
})

elementStore.KillTier = CombatTab:Dropdown({
    Title = "击杀指定等级",
    Values = zombieTiers,
    Value = valueStore.KillTierTarget.Value,
    Multi = false,
    Callback = function(v)
        valueStore.KillTierTarget.Value = v
    end
})

CombatTab:Button({
    Title = "击杀选中等级全部僵尸",
    Callback = function()
        killTier(valueStore.KillTierTarget.Value or "Brute")
    end
})

ESPTab:Section({ Title = "僵尸透视" })
featureFlags.ZombieESP._windElem = ESPTab:Toggle({
    Title = "僵尸高亮",
    Flag = "ZombieESP",
    Value = featureFlags.ZombieESP.Value,
    Callback = function(state)
        featureFlags.ZombieESP.Value = state
        if not state then
            safeCall(SZAModule.clearESP)
        end
    end
})

elementStore.ESPColor = ESPTab:Dropdown({
    Title = "透视颜色",
    Values = { "红色", "橙色", "黄色", "紫色" },
    Value = valueStore.ESPColor.Value,
    Multi = false,
    Callback = function(v)
        valueStore.ESPColor.Value = v
        safeCall(function()
            local colors = SZAModule.ESP_COLORS or {}
            SZAModule.applyESPColor(colors[v] or colors.Red)
        end)
    end
})

ESPTab:Toggle({
    Title = "标签显示生命百分比",
    Value = false,
    Callback = function(state)
        healthLabelsEnabled = state
        if not state then
            updateHealthLabels()
        end
    end
})

elementStore.ESPMaxDistance = ESPTab:Slider({
    Title = "最大距离（格）",
    Step = 10,
    Value = { Min = 20, Max = 500, Default = valueStore.ESPMaxDistance.Value },
    Callback = function(v)
        valueStore.ESPMaxDistance.Value = v
    end
})

ESPTab:Section({ Title = "玩家透视" })
ESPTab:Toggle({
    Title = "玩家高亮",
    Value = false,
    Callback = function(state)
        if state then
            applyPlayerHighlights()
        else
            cleanupHighlights()
        end
        valueStore.PlayerHighlightsEnabled = { Value = state }
    end
})

GearsTab:Section({ Title = "装备" })
elementStore.GearSelect = GearsTab:Dropdown({
    Title = "选择装备",
    Values = SZAModule.GEARS or { "Landmine" },
    Value = valueStore.GearBuySelect.Value,
    Multi = true,
    Callback = function(v)
        valueStore.GearBuySelect.Value = v
    end
})

featureFlags.AutoBuyGear._windElem = GearsTab:Toggle({
    Title = "自动购买",
    Flag = "AutoBuyGear",
    Value = featureFlags.AutoBuyGear.Value,
    Callback = function(state)
        featureFlags.AutoBuyGear.Value = state
        if state then
            safeCall(SZAModule.startAutoBuy)
        else
            safeCall(SZAModule.stopAutoBuy)
        end
    end
})

elementStore.GearDelay = GearsTab:Slider({
    Title = "购买延迟（秒）",
    Step = 0.1,
    Value = { Min = 0.1, Max = 5, Default = valueStore.GearBuyDelay.Value },
    Callback = function(v)
        valueStore.GearBuyDelay.Value = v
    end
})

ImmortalTab:Section({ Title = "不死" })
featureFlags.InvisEnabled._windElem = ImmortalTab:Toggle({
    Title = "无敌模式",
    Flag = "InvisEnabled",
    Value = featureFlags.InvisEnabled.Value,
    Callback = function(state)
        featureFlags.InvisEnabled.Value = state
        if state then
            safeCall(function()
                SZAModule.setInvisTransparency(valueStore.InvisTransparency.Value / 100)
                SZAModule.enableInvisibility()
            end)
        else
            safeCall(SZAModule.disableInvisibility)
        end
    end
})

elementStore.InvisTransparency = ImmortalTab:Slider({
    Title = "透明度",
    Step = 1,
    Value = { Min = 0, Max = 100, Default = valueStore.InvisTransparency.Value },
    Callback = function(v)
        valueStore.InvisTransparency.Value = v
        safeCall(function()
            SZAModule.setInvisTransparency(v / 100)
        end)
    end
})

ImmortalTab:Keybind({
    Title = "切换快捷键",
    Value = "Z",
    Callback = function(v)
        safeCall(function()
            invisToggleKey = Enum.KeyCode[v]
        end)
    end
})

UpgradesTab:Section({ Title = "武器" })
featureFlags.AutoWeaponUpgrade._windElem = UpgradesTab:Toggle({
    Title = "自动武器升级",
    Flag = "AutoWeaponUpgrade",
    Value = featureFlags.AutoWeaponUpgrade.Value,
    Callback = function(state)
        featureFlags.AutoWeaponUpgrade.Value = state
        if state then
            safeCall(SZAModule.startWeaponUpgrade)
        else
            safeCall(SZAModule.stopWeaponUpgrade)
        end
    end
})

elementStore.WeaponDelay = UpgradesTab:Slider({
    Title = "延迟（秒）",
    Step = 0.1,
    Value = { Min = 0.1, Max = 5, Default = valueStore.WeaponUpgradeDelay.Value },
    Callback = function(v)
        valueStore.WeaponUpgradeDelay.Value = v
    end
})

UpgradesTab:Section({ Title = "生命" })
featureFlags.AutoHealthUpgrade._windElem = UpgradesTab:Toggle({
    Title = "自动生命升级",
    Flag = "AutoHealthUpgrade",
    Value = featureFlags.AutoHealthUpgrade.Value,
    Callback = function(state)
        featureFlags.AutoHealthUpgrade.Value = state
        if state then
            safeCall(SZAModule.startHealthUpgrade)
        else
            safeCall(SZAModule.stopHealthUpgrade)
        end
    end
})

elementStore.HealthDelay = UpgradesTab:Slider({
    Title = "延迟（秒）",
    Step = 0.1,
    Value = { Min = 0.1, Max = 5, Default = valueStore.HealthUpgradeDelay.Value },
    Callback = function(v)
        valueStore.HealthUpgradeDelay.Value = v
    end
})

WaveTab:Section({ Title = "跳过" })
featureFlags.AutoSkipWave._windElem = WaveTab:Toggle({
    Title = "自动投票跳过",
    Flag = "AutoSkipWave",
    Value = featureFlags.AutoSkipWave.Value,
    Callback = function(state)
        featureFlags.AutoSkipWave.Value = state
        if state then
            safeCall(SZAModule.startSkip)
        else
            safeCall(SZAModule.stopSkip)
        end
    end
})

WaveTab:Button({
    Title = "立即跳过所有波次",
    Callback = function()
        safeCall(SZAModule.instantSkip)
        if not featureFlags.EnableFly.Value then
            featureFlags.EnableFly:Set(true)
        end
    end
})

WaveTab:Button({
    Title = "投票跳过（直接远程）",
    Callback = fireSkipVote
})

WaveTab:Section({ Title = "金币" })
featureFlags.AutoDoubleCredits._windElem = WaveTab:Toggle({
    Title = "自动双倍金币",
    Flag = "AutoDoubleCredits",
    Value = featureFlags.AutoDoubleCredits.Value,
    Callback = function(state)
        featureFlags.AutoDoubleCredits.Value = state
    end
})

WaveTab:Button({
    Title = "投票双倍金币",
    Callback = fireDoubleCreditsVote
})

WaveTab:Section({ Title = "碎片" })
featureFlags.AutoCollectShards._windElem = WaveTab:Toggle({
    Title = "自动收集银河碎片",
    Flag = "AutoCollectShards",
    Value = featureFlags.AutoCollectShards.Value,
    Callback = function(state)
        featureFlags.AutoCollectShards.Value = state
    end
})

MiscTab:Section({ Title = "移动" })
featureFlags.AntiAFK._windElem = MiscTab:Toggle({
    Title = "防挂机",
    Flag = "AntiAFK",
    Value = featureFlags.AntiAFK.Value,
    Callback = function(state)
        featureFlags.AntiAFK.Value = state
        if state then
            safeCall(SZAModule.enableAntiAFK)
        end
    end
})

featureFlags.Noclip._windElem = MiscTab:Toggle({
    Title = "穿墙",
    Flag = "Noclip",
    Value = featureFlags.Noclip.Value,
    Callback = function(state)
        featureFlags.Noclip.Value = state
        if state then
            safeCall(SZAModule.startNoclip)
        else
            safeCall(SZAModule.stopNoclip)
        end
    end
})

elementStore.WalkSpeed = MiscTab:Slider({
    Title = "走路速度",
    Step = 1,
    Value = { Min = 16, Max = 150, Default = valueStore.WalkSpeed.Value },
    Callback = function(v)
        valueStore.WalkSpeed.Value = v
        safeCall(function()
            SZAModule.setWalkSpeed(v)
        end)
    end
})

featureFlags.EnableFly._windElem = MiscTab:Toggle({
    Title = "飞行",
    Flag = "EnableFly",
    Value = featureFlags.EnableFly.Value,
    Callback = function(state)
        featureFlags.EnableFly.Value = state
        if state then
            safeCall(SZAModule.startFly)
        else
            safeCall(SZAModule.stopFly)
        end
    end
})

elementStore.FlyHeight = MiscTab:Slider({
    Title = "飞行高度",
    Step = 1,
    Value = { Min = 0, Max = 150, Default = valueStore.FlyHeight.Value },
    Callback = function(v)
        valueStore.FlyHeight.Value = v
    end
})

elementStore.JumpPower = MiscTab:Slider({
    Title = "跳跃力度",
    Step = 1,
    Value = { Min = 7, Max = 150, Default = 7.2 },
    Callback = function(v)
        valueStore.JumpPower.Value = v
        applyJumpPower(v)
    end
})

featureFlags.InfiniteJump._windElem = MiscTab:Toggle({
    Title = "无限跳跃",
    Flag = "InfiniteJump",
    Value = featureFlags.InfiniteJump.Value,
    Callback = function(state)
        featureFlags.InfiniteJump.Value = state
    end
})

MiscTab:Section({ Title = "视觉" })
elementStore.FOV = MiscTab:Slider({
    Title = "视野 (FOV)",
    Step = 1,
    Value = { Min = 40, Max = 120, Default = 70 },
    Callback = function(v)
        safeCall(function()
            workspace.CurrentCamera.FieldOfView = v
        end)
    end
})

featureFlags.Fullbright._windElem = MiscTab:Toggle({
    Title = "全图明亮",
    Flag = "Fullbright",
    Value = featureFlags.Fullbright.Value,
    Callback = applyFullbright
})

elementStore.ClockTime = MiscTab:Slider({
    Title = "时间",
    Step = 0.5,
    Value = { Min = 0, Max = 24, Default = 14 },
    Callback = function(v)
        safeCall(function()
            Lighting.ClockTime = v
        end)
    end
})

MiscTab:Section({ Title = "其他" })
MiscTab:Button({
    Title = "卸载脚本",
    Callback = function()
        Window:Destroy()
    end
})

QueueTab:Section({ Title = "设置" })
QueueTab:Dropdown({
    Title = "难度",
    Values = { "普通", "困难", "噩梦" },
    Value = queueState.difficulty,
    Multi = false,
    Callback = function(v)
        queueState.difficulty = v or "普通"
    end
})

QueueTab:Dropdown({
    Title = "地图",
    Values = { "RooftopSiege", "Atlantis" },
    Value = queueState.map,
    Multi = false,
    Callback = function(v)
        queueState.map = v or "RooftopSiege"
    end
})

QueueTab:Slider({
    Title = "队伍人数",
    Step = 1,
    Value = { Min = 1, Max = 4, Default = queueState.partySize },
    Callback = function(v)
        queueState.partySize = v
    end
})

QueueTab:Section({ Title = "自动" })
QueueTab:Toggle({
    Title = "全自动排队",
    Value = false,
    Callback = function(state)
        queueState.autoOn = state
        if not state then
            stopQueueHooks()
            leaveQueue()
        else
            startQueueHooks()
            task.wait(0.8)
            createParty()
        end
    end
})

QueueTab:Section({ Title = "手动" })
QueueTab:Button({
    Title = "立刻排队",
    Callback = function()
        moveToNearestQueuePad()
        task.wait(0.8)
        createParty()
    end
})

QueueTab:Button({
    Title = "离开队列",
    Callback = leaveQueue
})

InfoTab:Section({ Title = "状态" })
local statZombies = InfoTab:Paragraph({ Title = "僵尸数: 0" })
local statCreditsEst = InfoTab:Paragraph({ Title = "预估金币: 0" })
local statSession = InfoTab:Paragraph({ Title = "本局: 0" })
local statWave = InfoTab:Paragraph({ Title = "波次: --" })
local statHealth = InfoTab:Paragraph({ Title = "生命: -- / --" })
local statFps = InfoTab:Paragraph({ Title = "帧数: --" })
local statCredits = InfoTab:Paragraph({ Title = "金币: --" })

local configFolder = "Foxname_sza"
if not isfolder(configFolder) then
    makeFolder(configFolder)
end
local autoConfigFile = configFolder .. "/Auto.txt"

local function configPath(name)
    return string.format("%s/%s.json", configFolder, name)
end

local function readAutoConfig()
    if isfile(autoConfigFile) then
        local data = safeCall(function()
            return HttpService:JSONDecode(readfile(autoConfigFile))
        end)
        if type(data) == "table" then
            return data
        end
    end
    return { NameFileSelected = "默认", Auto = false }
end

local function writeAutoConfig(selectedName, autoEnabled)
    if not writefile then
        return
    end
    safeCall(function()
        writefile(autoConfigFile, HttpService:JSONEncode({
            NameFileSelected = selectedName or "默认",
            Auto = autoEnabled == true
        }))
    end)
end

local function listConfigs()
    local out = {}
    for _, f in ipairs(listfiles(configFolder)) do
        local name = f:match("([^/\\]+)%.json$")
        if name then
            out[#out + 1] = name
        end
    end
    if #out == 0 then
        out = { "默认" }
    end
    return out
end

local function hasConfigName(list, name)
    for _, v in ipairs(list) do
        if v == name then
            return true
        end
    end
    return false
end

local windConfigManager = Window.ConfigManager

local function listWindConfigs()
    if not windConfigManager then
        return {}
    end
    local list = safeCall(function()
        return windConfigManager:AllConfigs()
    end)
    if type(list) == "table" then
        return list
    end
    return {}
end

local function listAllConfigNames()
    local merged = {}
    local seen = {}

    for _, name in ipairs(listConfigs()) do
        if not seen[name] then
            seen[name] = true
            merged[#merged + 1] = name
        end
    end

    for _, name in ipairs(listWindConfigs()) do
        if type(name) == "string" and name ~= "" and not seen[name] then
            seen[name] = true
            merged[#merged + 1] = name
        end
    end

    if #merged == 0 then
        merged = { "默认" }
    end
    table.sort(merged)
    return merged
end

local function collectConfigData()
    local f = {}
    local v = {}
    for k, flag in pairs(featureFlags) do
        f[k] = flag.Value
    end
    for k, val in pairs(valueStore) do
        v[k] = val.Value
    end
    return {
        flags = f,
        values = v,
        queue = queueState
    }
end

local function applyConfigData(data)
    if type(data) ~= "table" then
        return
    end

    if type(data.flags) == "table" then
        for k, v in pairs(data.flags) do
            local flag = featureFlags[k]
            if flag then
                flag:Set(v)
            end
        end
    end

    if type(data.values) == "table" then
        for k, v in pairs(data.values) do
            if valueStore[k] then
                valueStore[k].Value = v
            end
        end
    end

    safeCall(function() elementStore.AutoKillDelay:Set(valueStore.AutoKillDelay.Value) end)
    safeCall(function() elementStore.InstaDamage:Set(valueStore.InstaKillDamage.Value) end)
    safeCall(function() elementStore.InstaDelay:Set(valueStore.InstaKillDelay.Value) end)
    safeCall(function() elementStore.KillRadius:Set(valueStore.AutoKillRadius.Value) end)
    safeCall(function() elementStore.ESPMaxDistance:Set(valueStore.ESPMaxDistance.Value) end)
    safeCall(function() elementStore.GearDelay:Set(valueStore.GearBuyDelay.Value) end)
    safeCall(function() elementStore.InvisTransparency:Set(valueStore.InvisTransparency.Value) end)
    safeCall(function() elementStore.WeaponDelay:Set(valueStore.WeaponUpgradeDelay.Value) end)
    safeCall(function() elementStore.HealthDelay:Set(valueStore.HealthUpgradeDelay.Value) end)
    safeCall(function() elementStore.WalkSpeed:Set(valueStore.WalkSpeed.Value) end)
    safeCall(function() elementStore.FlyHeight:Set(valueStore.FlyHeight.Value) end)
    safeCall(function() elementStore.JumpPower:Set(valueStore.JumpPower.Value) end)
    safeCall(function() elementStore.TargetPriority:Select(valueStore.TargetPriority.Value) end)
    safeCall(function() elementStore.ESPColor:Select(valueStore.ESPColor.Value) end)
    safeCall(function() elementStore.GearSelect:Select(valueStore.GearBuySelect.Value) end)
    safeCall(function() elementStore.KillTier:Select(valueStore.KillTierTarget.Value) end)
    safeCall(function() elementStore.ZombieFilter:Select(valueStore.ZombieTypeFilter.Value or {}) end)

    safeCall(function() SZAModule.setWalkSpeed(valueStore.WalkSpeed.Value) end)
    safeCall(function() SZAModule.setInvisTransparency((valueStore.InvisTransparency.Value or 0) / 100) end)
    applyJumpPower(valueStore.JumpPower.Value)

    if type(data.queue) == "table" then
        queueState.difficulty = data.queue.difficulty or queueState.difficulty
        queueState.map = data.queue.map or queueState.map
        queueState.partySize = tonumber(data.queue.partySize) or queueState.partySize
    end
end

ConfigTab:Section({ Title = "配置" })
local autoMeta = readAutoConfig()
local currentConfigName = autoMeta.NameFileSelected or "默认"
local configDropdown
local autoLoadConfigEnabled = autoMeta.Auto == true
local initialConfigList = listAllConfigNames()
if not hasConfigName(initialConfigList, currentConfigName) then
    currentConfigName = initialConfigList[1] or "默认"
end

ConfigTab:Input({
    Title = "配置名称",
    Placeholder = "输入配置名称",
    Callback = function(v)
        if v and v ~= "" then
            currentConfigName = v
        end
    end
})

configDropdown = ConfigTab:Dropdown({
    Title = "选择配置",
    Values = initialConfigList,
    Value = currentConfigName,
    Multi = false,
    Callback = function(v)
        if v and v ~= "" then
            currentConfigName = v
            writeAutoConfig(currentConfigName, autoLoadConfigEnabled)
        end
    end
})

ConfigTab:Button({
    Title = "保存配置",
    Callback = function()
        local data = collectConfigData()
        safeCall(function()
            if windConfigManager then
                local cfg = windConfigManager:CreateConfig(currentConfigName)
                cfg:Save()
            end
        end)
        safeCall(function()
            writefile(configPath(currentConfigName), HttpService:JSONEncode(data))
        end)
        safeCall(function()
            configDropdown:Refresh(listAllConfigNames())
        end)
        writeAutoConfig(currentConfigName, autoLoadConfigEnabled)
        notify("配置", "已保存: " .. currentConfigName, "check", 2)
    end
})

ConfigTab:Button({
    Title = "加载配置",
    Callback = function()
        local path = configPath(currentConfigName)
        if not isfile(path) then
            safeCall(function()
                if windConfigManager then
                    local cfg = windConfigManager:CreateConfig(currentConfigName)
                    cfg:Load()
                end
            end)
        else
            local data = safeCall(function()
                return HttpService:JSONDecode(readfile(path))
            end)
            if data then
                applyConfigData(data)
            end
            safeCall(function()
                if windConfigManager then
                    local cfg = windConfigManager:CreateConfig(currentConfigName)
                    cfg:Load()
                end
            end)
        end
        writeAutoConfig(currentConfigName, autoLoadConfigEnabled)
        notify("配置", "已加载: " .. currentConfigName, "check", 2)
    end
})

ConfigTab:Button({
    Title = "删除配置",
    Callback = function()
        local path = configPath(currentConfigName)
        if isfile(path) then
            if delfile then
                delfile(path)
            elseif deletefile then
                deletefile(path)
            end
        end
        safeCall(function()
            if windConfigManager then
                local cfg = windConfigManager:CreateConfig(currentConfigName)
                cfg:Delete()
            end
        end)
        safeCall(function()
            configDropdown:Refresh(listAllConfigNames())
        end)
        writeAutoConfig(currentConfigName, autoLoadConfigEnabled)
        notify("配置", "已删除: " .. currentConfigName, "trash-2", 2)
    end
})

ConfigTab:Button({
    Title = "刷新列表",
    Callback = function()
        safeCall(function()
            configDropdown:Refresh(listAllConfigNames())
        end)
        notify("配置", "配置列表已刷新", "refresh-cw", 2)
    end
})

ConfigTab:Toggle({
    Title = "自动加载选中的配置",
    Value = autoLoadConfigEnabled,
    Callback = function(state)
        autoLoadConfigEnabled = state
        writeAutoConfig(currentConfigName, autoLoadConfigEnabled)
        notify("配置", state and ("自动加载: " .. currentConfigName) or "自动加载已禁用", "check", 2)
    end
})

ConfigTab:Button({
    Title = "立即加载选中配置",
    Callback = function()
        local path = configPath(currentConfigName)
        if isfile(path) then
            local data = safeCall(function()
                return HttpService:JSONDecode(readfile(path))
            end)
            if data then
                applyConfigData(data)
            end
        end
        safeCall(function()
            if windConfigManager then
                local cfg = windConfigManager:CreateConfig(currentConfigName)
                cfg:Load()
            end
        end)
        notify("配置", "已加载: " .. currentConfigName, "check", 2)
    end
})

task.spawn(function()
    task.wait(0.5)
    if autoLoadConfigEnabled and currentConfigName and currentConfigName ~= "" then
        local path = configPath(currentConfigName)
        if isfile(path) then
            local data = safeCall(function()
                return HttpService:JSONDecode(readfile(path))
            end)
            if data then
                applyConfigData(data)
            end
        end
        safeCall(function()
            if windConfigManager then
                local cfg = windConfigManager:CreateConfig(currentConfigName)
                cfg:Load()
            end
        end)
        notify("配置", "自动加载: " .. currentConfigName, "check", 2)
    end
end)

trackConnection(RunService.Heartbeat:Connect(function(dt)
    fpsSamples[#fpsSamples + 1] = 1 / math.max(dt, 0.0001)
    if #fpsSamples > 30 then
        table.remove(fpsSamples, 1)
    end
end))

trackConnection(LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    local hum = newCharacter:WaitForChild("Humanoid", 5)
    if not hum then
        return
    end
    task.wait(0.1)
    if valueStore.JumpPower.Value ~= 7.2 then
        hum.JumpHeight = valueStore.JumpPower.Value
    end
    if valueStore.WalkSpeed.Value ~= 16 then
        hum.WalkSpeed = valueStore.WalkSpeed.Value
    end
end))

trackConnection(UserInputService.JumpRequest:Connect(function()
    if featureFlags.InfiniteJump.Value then
        local hum = getHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end))

trackConnection(UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end
    if input.KeyCode == invisToggleKey then
        featureFlags.InvisEnabled:Set(not featureFlags.InvisEnabled.Value)
    end
end))

task.spawn(function()
    while running and backgroundLoops.stats do
        task.wait(0.5)
        safeCall(function()
            statZombies:SetTitle("僵尸数: " .. tostring(SZAModule.getZombieCount()))
            statCreditsEst:SetTitle("预估金币: " .. tostring(SZAModule.getEstCredits()))
            statSession:SetTitle("本局: " .. tostring(SZAModule.getSessionTotal()))
            statWave:SetTitle("波次: " .. getWaveText())
            statHealth:SetTitle("生命: " .. getHealthText())
            statFps:SetTitle("帧数: " .. tostring(getFPS()))
            statCredits:SetTitle("金币: " .. getCreditsText())
            SZAModule.updateESP()
            updateHealthLabels()
        end)
    end
end)

task.spawn(function()
    while running and backgroundLoops.shards do
        task.wait(1)
        collectShardsTick()
    end
end)

task.spawn(function()
    while running and backgroundLoops.highlights do
        task.wait(2)
        if valueStore.PlayerHighlightsEnabled and valueStore.PlayerHighlightsEnabled.Value then
            applyPlayerHighlights()
        end
    end
end)

notify("QJ脚本", "以为您启用生存僵尸竞技场脚本", 4)