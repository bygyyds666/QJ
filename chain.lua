local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()
local Window = WindUI:CreateWindow({
    Title = "QJ脚本-chain",
    Icon = "sword",
    IconThemed = true,
    Author = "作者：琼玖",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(500, 400),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function() end,
        Anonymous = false
    },
    SideBarWidth = 200,
    ScrollBarEnabled = true
})
Window:CreateTopbarButton("theme-switcher", "moon", function()
    WindUI:SetTheme(WindUI:GetCurrentTheme() == "Dark" and "Light" or "Dark")
    WindUI:Notify({
        Title = "提示",
        Content = "当前主题: "..WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

local TimeTag = Window:Tag({
    Title = "--:--",
    Radius = 999,
    Color = Color3.fromRGB(255, 255, 255),
})

task.spawn(function()
	while true do
		local now = os.date("*t")
		local hours = string.format("%02d", now.hour)
		local minutes = string.format("%02d", now.min)
		
		TimeTag:SetTitle(hours .. ":" .. minutes)
		task.wait(0.06)
	end
end)

local Tab = Window:Tab({
    Title = "功能",
    Icon = "house",
    Locked = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local combatStaminaEnabled = false
local staminaEnabled = false

local combatLoop = nil
local staminaLoop = nil

local function setCombatStamina(value)
    local char = workspace:FindFirstChild(LocalPlayer.Name)
    if char and char:FindFirstChild("Stats") then
        local stat = char.Stats:FindFirstChild("CombatStamina")
        if stat then
            stat.Value = value
        end
    end
end

local function setStamina(value)
    local char = workspace:FindFirstChild(LocalPlayer.Name)
    if char and char:FindFirstChild("Stats") then
        local stat = char.Stats:FindFirstChild("Stamina")
        if stat then
            stat.Value = value
        end
    end
end

local RunService = game:GetService("RunService")

local function startCombatLoop()
    if combatLoop then return end
    combatLoop = RunService.Heartbeat:Connect(function()
        if combatStaminaEnabled then
            setCombatStamina(100)
        end
    end)
end

local function startStaminaLoop()
    if staminaLoop then return end
    staminaLoop = RunService.Heartbeat:Connect(function()
        if staminaEnabled then
            setStamina(100)
        end
    end)
end

local function stopCombatLoop()
    if combatLoop then
        combatLoop:Disconnect()
        combatLoop = nil
    end
end

local function stopStaminaLoop()
    if staminaLoop then
        staminaLoop:Disconnect()
        staminaLoop = nil
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if combatStaminaEnabled then
        setCombatStamina(100)
    end
    if staminaEnabled then
        setStamina(100)
    end
end)

Tab:Toggle({
    Title = "无限战斗体力",
    Value = false,
    Callback = function(state)
        combatStaminaEnabled = state
        if state then
            startCombatLoop()
        else
            stopCombatLoop()
        end
    end
})

Tab:Toggle({
    Title = "无限体力",
    Value = false,
    Callback = function(state)
        staminaEnabled = state
        if state then
            startStaminaLoop()
        else
            stopStaminaLoop()
        end
    end
})
local RunService = game:GetService("RunService")

local chainESPEnabled = false
local chainESPConnection = nil
local currentChain = nil

local function createChainESP(chain)
    if not chain:FindFirstChild("Highlight") then
        local h = Instance.new("Highlight")
        h.Name = "Highlight"
        h.Adornee = chain
        h.FillColor = Color3.fromRGB(255, 0, 0)
        h.FillTransparency = 0.8
        h.OutlineColor = Color3.fromRGB(255, 60, 60)
        h.OutlineTransparency = 0
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = chain
    end

    if not chain:FindFirstChild("NameGui") then
        local gui = Instance.new("BillboardGui")
        gui.Name = "NameGui"
        gui.Size = UDim2.new(0, 150, 0, 30)
        gui.StudsOffset = Vector3.new(0, 5, 0)
        gui.Adornee = chain
        gui.AlwaysOnTop = true
        gui.LightInfluence = 0
        gui.Parent = chain

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "TitleLabel"
        titleLabel.Size = UDim2.new(1, 0, 0.5, 0)
        titleLabel.Position = UDim2.new(0, 0, 0, 0)
        titleLabel.Text = "CHAIN"
        titleLabel.TextColor3 = Color3.new(1, 0, 0)
        titleLabel.TextScaled = true
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.TextSize = 10
        titleLabel.BackgroundTransparency = 1
        titleLabel.Parent = gui

        local attrLabel = Instance.new("TextLabel")
        attrLabel.Name = "AttrLabel"
        attrLabel.Size = UDim2.new(1, 0, 0.5, 0)
        attrLabel.Position = UDim2.new(0, 0, 0.5, 0)
        attrLabel.RichText = true
        attrLabel.Text = ""
        attrLabel.TextColor3 = Color3.new(1, 1, 1)
        attrLabel.TextScaled = true
        attrLabel.Font = Enum.Font.Gotham
        attrLabel.TextSize = 8
        attrLabel.BackgroundTransparency = 1
        attrLabel.Parent = gui
    end
end

local function updateChainAttributes(chain)
    local gui = chain:FindFirstChild("NameGui")
    if gui then
        local attrLabel = gui:FindFirstChild("AttrLabel")
        if attrLabel then
            local anger = chain:GetAttribute("Anger") or 0
            local burst = chain:GetAttribute("Burst") or 0
            local choke = chain:GetAttribute("ChokeMeter") or 0
            attrLabel.Text = string.format(
                '[血月度: <font color="rgb(255,255,255)">%.0f%%</font>] [捶地: <font color="rgb(255,255,255)">%.0f%%</font>] [掐脖: <font color="rgb(255,255,255)">%.0f%%</font>]',
                anger, burst, choke
            )
        end
    end
end

local function removeChainESP(chain)
    if chain then
        local highlight = chain:FindFirstChild("Highlight")
        if highlight then highlight:Destroy() end
        local nameGui = chain:FindFirstChild("NameGui")
        if nameGui then nameGui:Destroy() end
    end
end

local function refreshChainESP()
    local chain = workspace:FindFirstChild("Misc")
        and workspace.Misc:FindFirstChild("AI")
        and workspace.Misc.AI:FindFirstChild("CHAIN")
    if chain then
        if currentChain ~= chain then
            if currentChain then removeChainESP(currentChain) end
            currentChain = chain
            createChainESP(chain)
        end
        if not chain:FindFirstChild("Highlight") or not chain:FindFirstChild("NameGui") then
            createChainESP(chain)
        end
        updateChainAttributes(chain)
    else
        if currentChain then
            removeChainESP(currentChain)
            currentChain = nil
        end
    end
end

local function startChainESP()
    if chainESPEnabled then return end
    chainESPEnabled = true
    chainESPConnection = RunService.Heartbeat:Connect(refreshChainESP)
end

local function stopChainESP()
    chainESPEnabled = false
    if chainESPConnection then
        chainESPConnection:Disconnect()
        chainESPConnection = nil
    end
    if currentChain then
        removeChainESP(currentChain)
        currentChain = nil
    end
end

Tab:Toggle({
    Title = "透视chain",
    Value = false,
    Callback = function(state)
        if state then
            startChainESP()
        else
            stopChainESP()
        end
    end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local playerESPEnabled = false
local playerESPConnections = {}
local trackedCharacters = {}

local function addESP(character, player)
    if not character or not player then return end

    if not character:FindFirstChild("Highlight") then
        local h = Instance.new("Highlight")
        h.Name = "Highlight"
        h.Adornee = character
        h.FillColor = Color3.fromRGB(0, 255, 0)
        h.FillTransparency = 0.7
        h.OutlineColor = Color3.fromRGB(0, 200, 0)
        h.OutlineTransparency = 0.1
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Parent = character
    end

    if not character:FindFirstChild("NameGui") then
        local gui = Instance.new("BillboardGui")
        gui.Name = "NameGui"
        gui.Size = UDim2.new(0, 50, 0, 10)
        gui.StudsOffset = Vector3.new(0, 3.5, 0)
        local adornee = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart")
        gui.Adornee = adornee
        gui.AlwaysOnTop = true
        gui.LightInfluence = 0
        gui.Parent = character

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = player.Name
        label.TextColor3 = Color3.new(0, 1, 0)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.BackgroundTransparency = 1
        label.TextSize = 10
        label.Parent = gui
    end
end

local function removeESP(character)
    if not character then return end
    local highlight = character:FindFirstChild("Highlight")
    if highlight then highlight:Destroy() end

    local nameGui = character:FindFirstChild("NameGui")
    if nameGui then nameGui:Destroy() end
end

local function onCharacterAdded(player, character)
    if not playerESPEnabled then return end
    task.delay(0.3, function()
        if playerESPEnabled and character and character.Parent then
            addESP(character, player)
        end
    end)
end

local function trackPlayer(player)
    if player == LocalPlayer then return end
    if trackedCharacters[player] then return end
    trackedCharacters[player] = true

    if player.Character then
        onCharacterAdded(player, player.Character)
    end

    local conn = player.CharacterAdded:Connect(function(character)
        onCharacterAdded(player, character)
    end)
    table.insert(playerESPConnections, conn)

    local removeConn = player.AncestryChanged:Connect(function()
        if not player:IsDescendantOf(game) then
            trackedCharacters[player] = nil
        end
    end)
    table.insert(playerESPConnections, removeConn)
end

local function startPlayerESP()
    if playerESPEnabled then return end
    playerESPEnabled = true

    for _, player in ipairs(Players:GetPlayers()) do
        trackPlayer(player)
    end

    local conn = Players.PlayerAdded:Connect(trackPlayer)
    table.insert(playerESPConnections, conn)
end

local function stopPlayerESP()
    playerESPEnabled = false

    for _, conn in ipairs(playerESPConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(playerESPConnections)
    table.clear(trackedCharacters)

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            removeESP(player.Character)
        end
    end
end

Tab:Toggle({
    Title = "透视玩家",
    Default = false,
    Callback = function(state)
        if state then
            startPlayerESP()
        else
            stopPlayerESP()
        end
    end
})
local Lighting = game:GetService("Lighting")

local originalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ExposureCompensation = Lighting.ExposureCompensation,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
}

local highlightLoop

Tab:Toggle({
    Title = "高亮",
    Default = false,
    Callback = function(state)
        if state then
            highlightLoop = task.spawn(function()
                while task.wait(0.5) do
                    Lighting.Brightness = 2
                    Lighting.ClockTime = 13.5
                    Lighting.Ambient = Color3.new(0.6, 0.6, 0.6)
                    Lighting.OutdoorAmbient = Color3.new(0.6, 0.6, 0.6)
                    Lighting.ExposureCompensation = 0.5
                    Lighting.FogEnd = 100000
                    Lighting.FogStart = 0
                    Lighting.GlobalShadows = false
                end
            end)
        else
            if highlightLoop then
                task.cancel(highlightLoop)
                highlightLoop = nil
            end
            for k, v in pairs(originalLighting) do
                Lighting[k] = v
            end
        end
    end
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

local ScrapFolder = workspace:WaitForChild("Misc"):WaitForChild("Zones"):WaitForChild("LootingItems"):WaitForChild("Scrap")

local running = false
local collectThread
local teleportThread

local targetPositions = {
    Vector3.new(-26.879013061523438, -107.01750183105469, -204.7770538330078),
    Vector3.new(-110.85892486572266, -86.33830261230469, 211.8588409423828),
    Vector3.new(43.30422592163086, -97.9687728881836, 349.1531982421875),
    Vector3.new(164.49859619140625, -103.65132141113281, -35.76066207885742),
    Vector3.new(308.97198486328125, -113.4938735961914, -250.46066284179688),
    Vector3.new(-203.81826782226562, -110.8906478881836, -108.90457916259766),
    Vector3.new(-381.873046875, -115.02182006835938, 42.071022033691406),
}

local function getRootPart()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function firePrompt(prompt)
    if prompt and prompt:IsA("ProximityPrompt") then
        pcall(function()
            fireproximityprompt(prompt)
        end)
    end
end

local function getAllPrompts(root)
    local prompts = {}
    local function recurse(obj)
        for _, child in ipairs(obj:GetChildren()) do
            recurse(child)
            if child:IsA("ProximityPrompt") then
                table.insert(prompts, child)
            end
        end
    end
    recurse(root)
    return prompts
end

local function collectLoop()
    local playerRoot = getRootPart()
    while running do
        local prompts = getAllPrompts(ScrapFolder)
        for _, prompt in ipairs(prompts) do
            if not running then break end
            local part = prompt.Parent
            while part and not part:IsA("BasePart") do
                part = part.Parent
            end
            if part then
                playerRoot.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                task.wait(0.2)
                firePrompt(prompt)
                task.wait(0.6)
            end
        end
        task.wait(0.3)
    end
end

local function teleportLoop()
    local playerRoot = getRootPart()
    while running do
        for _, pos in ipairs(targetPositions) do
            if not running then break end
            playerRoot.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
            task.wait(3)
        end
    end
end

Tab:Toggle({
    Title = "传送捡废铁",
    Value = false,
    Callback = function(state)
        running = state
        if running then
            collectThread = task.spawn(collectLoop)
            teleportThread = task.spawn(teleportLoop)
        else
            if collectThread then task.cancel(collectThread) collectThread = nil end
            if teleportThread then task.cancel(teleportThread) teleportThread = nil end
        end
    end,
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local workspace = game:GetService("Workspace")

local running = false
local collectThread

Tab:Toggle({
    Title = "传送捡魔法书碎片",
    Value = false,
    Callback = function(state)
        running = state
        if running then
            collectThread = task.spawn(function()
                local plr = LocalPlayer
                local chr = plr.Character or plr.CharacterAdded:Wait()
                local hrp = chr:WaitForChild("HumanoidRootPart")
                local artifactsFolder = workspace.Misc.Zones.LootingItems.Artifacts

                while running do
                    for _, model in ipairs(artifactsFolder:GetChildren()) do
                        if not running then break end
                        if model:IsA("Model") then
                            for _, part in ipairs(model:GetChildren()) do
                                if not running then break end
                                if part:IsA("MeshPart") and part.Transparency == 0 then
                                    hrp.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                                    task.wait(0.3)
                                    local prompt = part:FindFirstChildOfClass("ProximityPrompt")
                                    if prompt and prompt.Enabled then
                                        pcall(function()
                                            fireproximityprompt(prompt)
                                        end)
                                    end
                                    task.wait(0.5)
                                end
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            if collectThread then
                task.cancel(collectThread)
                collectThread = nil
            end
        end
    end,
})
local enabled = false

local function setChatVisible(state)
	enabled = state
	local config = game:GetService("TextChatService"):FindFirstChild("ChatWindowConfiguration")
	if config and config:IsA("ChatWindowConfiguration") then
		config.Enabled = state
	end
end

task.spawn(function()
	while task.wait(1) do
		if enabled then
			setChatVisible(true)
		else
			setChatVisible(false)
		end
	end
end)

Tab:Toggle({
	Title = "显示聊天框",
	Value = false,
	Callback = function(state)
		enabled = state
	end,
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local toggleState = false

local function applyCameraMode(state)
	if state then
		LocalPlayer.CameraMaxZoomDistance = 99999
		LocalPlayer.CameraMode = Enum.CameraMode.Classic
	else
		LocalPlayer.CameraMaxZoomDistance = 16
		LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
	end
end

LocalPlayer.CharacterAdded:Connect(function()
	wait(1)
	if not toggleState then
		applyCameraMode(false)
	else
		applyCameraMode(true)
	end
end)

Tab:Toggle({
	Title = "强制第三人称",
	Value = false,
	Callback = function(state)
		toggleState = state
		applyCameraMode(state)
	end
})
Tab:Button({
    Title = "删除雾",
    Desc = nil,
    Locked = false,
    Callback = function()
        local lighting = game:GetService("Lighting")
        if lighting:FindFirstChild("Rainy") then
            lighting.Rainy:Destroy()
        end
    end
})
local Tab = Window:Tab({
    Title = "暴力功能",
    Icon = "hand",
    Locked = false,
})
Tab:Paragraph({
    Title = "注意事项",
    Desc = "不看的人死妈，要先点反作弊，然后开启无限闪避之后再点一下闪避键自动无限闪避就有用了，自动挥刀滥用也是一样的,然后开了无敌就不能用自动挥刀滥用，要是还在群里问为什么没用你妈就死了",
    Image = "file-warning",
    Color = "Red",
    ImageSize = 40, 
    ThumbnailSize = 120
})
Tab:Button({
		Title = "绕过反作弊",
		Desc = "依旧国外大神制作",
		Locked = false,
		Callback = function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua", true))()
		end
	})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local aimLoop
local targetModel
local targetHumanoidRootPart

local function updateTarget()
    local misc = workspace:FindFirstChild("Misc")
    if misc and misc:FindFirstChild("AI") and misc.AI:FindFirstChild("CHAIN") then
        targetModel = misc.AI.CHAIN
        targetHumanoidRootPart = targetModel:FindFirstChild("HumanoidRootPart") or targetModel:FindFirstChildWhichIsA("BasePart")
    else
        targetModel = nil
        targetHumanoidRootPart = nil
    end
end

local function smoothLookAt(currentCFrame, targetPos, speed)
    local direction = (targetPos - currentCFrame.Position).Unit
    local currentLook = currentCFrame.LookVector
    local lerpedLook = currentLook:Lerp(direction, speed)
    return CFrame.new(currentCFrame.Position, currentCFrame.Position + lerpedLook)
end

local descendantAddedConn
local descendantRemovingConn

Tab:Toggle({
    Title = "自瞄chain",
    Default = false,
    Callback = function(state)
        if state then
            updateTarget()

            if not descendantAddedConn then
                descendantAddedConn = workspace.DescendantAdded:Connect(function(obj)
                    if obj.Name == "CHAIN" then
                        task.wait(0.1)
                        updateTarget()
                    end
                end)
            end

            if not descendantRemovingConn then
                descendantRemovingConn = workspace.DescendantRemoving:Connect(function(obj)
                    if obj == targetModel then
                        targetModel = nil
                        targetHumanoidRootPart = nil
                    end
                end)
            end

            local speed = 0.3

            aimLoop = RunService.RenderStepped:Connect(function()
                if targetHumanoidRootPart and camera then
                    local desiredCFrame = smoothLookAt(camera.CFrame, targetHumanoidRootPart.Position, speed)
                    camera.CFrame = desiredCFrame
                else
                    updateTarget()
                end
            end)
        else
            if aimLoop then
                aimLoop:Disconnect()
                aimLoop = nil
            end
            if descendantAddedConn then
                descendantAddedConn:Disconnect()
                descendantAddedConn = nil
            end
            if descendantRemovingConn then
                descendantRemovingConn:Disconnect()
                descendantRemovingConn = nil
            end
        end
    end
})
Tab:Toggle({
    Title = "chain爆炸自动躲v1",
    Value = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local animationIdToCheck = "rbxassetid://14875631059"
        local TELEPORT_DISTANCE = 100
        local DETECT_RANGE = 12
        local RETURN_DISTANCE = 30
        local AIR_ANGLE = math.rad(45)
        local AIR_DURATION = 4

        local targetModel
        local animationAOE
        local originalCFrame
        local teleporting = false

        local function updateTarget()
            local misc = workspace:FindFirstChild("Misc")
            if misc and misc:FindFirstChild("AI") and misc.AI:FindFirstChild("CHAIN") then
                targetModel = misc.AI.CHAIN
                local aiFolder = targetModel:FindFirstChild("AI")
                if aiFolder and aiFolder:FindFirstChild("Animations") and aiFolder.Animations:FindFirstChild("AOE") then
                    animationAOE = aiFolder.Animations.AOE
                else
                    animationAOE = nil
                end
            else
                targetModel = nil
                animationAOE = nil
            end
        end

        local function getRoot()
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            return char:WaitForChild("HumanoidRootPart")
        end

        local function isAnimationPlaying()
            if not targetModel then return false end
            local humanoid = targetModel:FindFirstChildWhichIsA("Humanoid", true)
            if humanoid then
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        local animId = track.Animation.AnimationId
                        if animationAOE and (animId == animationAOE.AnimationId or animId == animationIdToCheck) then
                            return true
                        end
                    end
                end
            end
            return false
        end

        local function teleportAboveTarget()
            if not targetModel or teleporting then return end
            local root = getRoot()
            local distance = (root.Position - targetModel:GetPivot().Position).Magnitude
            if distance > DETECT_RANGE then return end
            teleporting = true
            originalCFrame = root.CFrame

            local targetPos = targetModel:GetPivot().Position + Vector3.new(0, TELEPORT_DISTANCE * math.sin(AIR_ANGLE), 0)
            local lookVector = targetModel:GetPivot().LookVector
            root.CFrame = CFrame.new(targetPos, targetPos + lookVector)

            local startTime = tick()
            while tick() - startTime < AIR_DURATION do
                root.CFrame = CFrame.new(targetPos, targetPos + lookVector)
                task.wait(0.03)
            end

            local returnPos = targetModel:GetPivot().Position + Vector3.new(0, 3, 0) + (lookVector * RETURN_DISTANCE)
            root.CFrame = CFrame.new(returnPos, targetModel:GetPivot().Position)
            teleporting = false
        end

        local lastPlaying = false

        if state then
            updateTarget()

            if not _G.chainDodgeAutoUpdate then
                _G.chainDodgeAutoUpdate = workspace.DescendantAdded:Connect(function(obj)
                    if obj.Name == "CHAIN" or obj.Name == "AOE" then
                        task.wait(0.1)
                        updateTarget()
                    end
                end)
            end

            if not _G.chainDodgeCharAdded then
                _G.chainDodgeCharAdded = LocalPlayer.CharacterAdded:Connect(function()
                    task.wait(1)
                    updateTarget()
                end)
            end

            _G.chainDodgeConn = RunService.Heartbeat:Connect(function()
                if not targetModel then
                    updateTarget()
                end
                local playing = isAnimationPlaying()
                if playing and not lastPlaying then
                    task.spawn(teleportAboveTarget)
                end
                lastPlaying = playing
            end)
        else
            if _G.chainDodgeConn then
                _G.chainDodgeConn:Disconnect()
                _G.chainDodgeConn = nil
            end
            if _G.chainDodgeAutoUpdate then
                _G.chainDodgeAutoUpdate:Disconnect()
                _G.chainDodgeAutoUpdate = nil
            end
            if _G.chainDodgeCharAdded then
                _G.chainDodgeCharAdded:Disconnect()
                _G.chainDodgeCharAdded = nil
            end
        end
    end
})
Tab:Toggle({
    Title = "chain爆炸自动躲v2",
    Value = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer
        local animationIdToCheck = "rbxassetid://14875631059"
        local DETECT_RANGE = 12
        local TELEPORT_DISTANCE = 70

        local targetModel
        local animationAOE
        local teleporting = false

        local function updateTarget()
            local misc = workspace:FindFirstChild("Misc")
            if misc and misc:FindFirstChild("AI") and misc.AI:FindFirstChild("CHAIN") then
                targetModel = misc.AI.CHAIN
                local aiFolder = targetModel:FindFirstChild("AI")
                if aiFolder and aiFolder:FindFirstChild("Animations") and aiFolder.Animations:FindFirstChild("AOE") then
                    animationAOE = aiFolder.Animations.AOE
                else
                    animationAOE = nil
                end
            else
                targetModel = nil
                animationAOE = nil
            end
        end

        local function getRoot()
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            return char:WaitForChild("HumanoidRootPart")
        end

        local function isAnimationPlaying()
            if not targetModel then return false end
            local humanoid = targetModel:FindFirstChildWhichIsA("Humanoid", true)
            if humanoid then
                local animator = humanoid:FindFirstChildOfClass("Animator")
                if animator then
                    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                        local animId = track.Animation.AnimationId
                        if animationAOE and (animId == animationAOE.AnimationId or animId == animationIdToCheck) then
                            return true
                        end
                    end
                end
            end
            return false
        end

        local function teleportFront()
            if not targetModel or teleporting then return end
            local root = getRoot()
            local distance = (root.Position - targetModel:GetPivot().Position).Magnitude
            if distance > DETECT_RANGE then return end
            teleporting = true
            local lookVector = targetModel:GetPivot().LookVector
            local frontPos = targetModel:GetPivot().Position + (lookVector * TELEPORT_DISTANCE)
            root.CFrame = CFrame.new(frontPos, targetModel:GetPivot().Position)
            teleporting = false
        end

        local lastPlaying = false

        if state then
            updateTarget()

            if not _G.chainDodgeAutoUpdateV2 then
                _G.chainDodgeAutoUpdateV2 = workspace.DescendantAdded:Connect(function(obj)
                    if obj.Name == "CHAIN" or obj.Name == "AOE" then
                        task.wait(0.1)
                        updateTarget()
                    end
                end)
            end

            if not _G.chainDodgeCharAddedV2 then
                _G.chainDodgeCharAddedV2 = LocalPlayer.CharacterAdded:Connect(function()
                    task.wait(1)
                    updateTarget()
                end)
            end

            _G.chainDodgeConnV2 = RunService.Heartbeat:Connect(function()
                if not targetModel then
                    updateTarget()
                end
                local playing = isAnimationPlaying()
                if playing and not lastPlaying then
                    task.spawn(teleportFront)
                end
                lastPlaying = playing
            end)
        else
            if _G.chainDodgeConnV2 then
                _G.chainDodgeConnV2:Disconnect()
                _G.chainDodgeConnV2 = nil
            end
            if _G.chainDodgeAutoUpdateV2 then
                _G.chainDodgeAutoUpdateV2:Disconnect()
                _G.chainDodgeAutoUpdateV2 = nil
            end
            if _G.chainDodgeCharAddedV2 then
                _G.chainDodgeCharAddedV2:Disconnect()
                _G.chainDodgeCharAddedV2 = nil
            end
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local CTS
local capturingCTS = false
local LastCTSArgs
local loop

local function refreshCTS()
    local char = LocalPlayer.Character
    if not char then return end
    CTS = char:WaitForChild("CharacterMobility"):WaitForChild("CTS")
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    refreshCTS()
    LastCTSArgs = nil
    if capturingCTS then
        capturingCTS = true
    end
end)

refreshCTS()

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and self == CTS then
        local args = {...}
        if capturingCTS and not LastCTSArgs then
            LastCTSArgs = args
        end
    end
    return old(self, ...)
end
setreadonly(mt, true)

Tab:Toggle({
    Title = "自动无限闪避",
    Value = false,
    Callback = function(state)
        if state then
            capturingCTS = true
            LastCTSArgs = nil
            if loop then
                loop:Disconnect()
                loop = nil
            end
            loop = RunService.Heartbeat:Connect(function(dt)
                if not CTS or not CTS.Parent then
                    refreshCTS()
                end
                if CTS and LastCTSArgs then
                    if tick() % 0.3 < dt then
                        CTS:FireServer(unpack(LastCTSArgs))
                    end
                end
            end)
        else
            capturingCTS = false
            if loop then
                loop:Disconnect()
                loop = nil
            end
        end
    end
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Interact
local capturingInteract = false
local LastInteractArgs
local loop
local swingDelay = 1
local lastFire = 0

local function refreshInteract()
    local char = LocalPlayer.Character
    if not char then return end
    Interact = char:WaitForChild("CharacterHandler"):WaitForChild("Contents"):WaitForChild("Remotes"):WaitForChild("Interact")
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    refreshInteract()
    LastInteractArgs = nil
    if capturingInteract then
        capturingInteract = true
    end
end)

refreshInteract()

local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and self == Interact then
        local args = {...}
        if capturingInteract and not LastInteractArgs then
            LastInteractArgs = args
        end
    end
    return old(self, ...)
end
setreadonly(mt, true)

Tab:Toggle({
    Title = "无敌",
    Desc = "开启功能后需要点一下qte",
    Value = false,
    Callback = function(state)
        if state then
            capturingInteract = true
            LastInteractArgs = nil
            if loop then
                loop:Disconnect()
                loop = nil
            end
            loop = RunService.Heartbeat:Connect(function(dt)
                if not Interact or not Interact.Parent then
                    refreshInteract()
                end
                if Interact and LastInteractArgs and (tick() - lastFire >= 1) then
                    lastFire = tick()
                    Interact:FireServer(unpack(LastInteractArgs))
                end
            end)
        else
            capturingInteract = false
            if loop then
                loop:Disconnect()
                loop = nil
            end
        end
    end
})
Tab:Toggle({
    Title = "自动拼刀",
    Value = false,
    Callback = function(state)
        autoWinXSawClashEnabled = state
        if autoWinXSawClashEnabled then
            xSawClashLoopConnection = game:GetService("RunService").Heartbeat:Connect(function()
                local lp = game.Players.LocalPlayer
                if lp and lp.Character and lp.Character:FindFirstChild("Stats") and lp.Character.Stats:FindFirstChild("ClashStrength") then
                    lp.Character.Stats.ClashStrength.Value = 100
                end
            end)
        else
            if xSawClashLoopConnection then
                xSawClashLoopConnection:Disconnect()
                xSawClashLoopConnection = nil
            end
        end
    end
})
local autoWinXSawClashEnabled = false
local xSawClashLoopConnection = nil
local BlueprintTab = Window:Tab({
    Title = "蓝图解锁",
    Icon = "file-check",
    Locked = false,
})
BlueprintTab:Button({
    Title = "解锁小刀",
    Callback = function()
        local player = game.Players.LocalPlayer
        local blueprints = player:WaitForChild("PlayerStats"):WaitForChild("Blueprints")
        local attributeName = "CombatKnife"
        if blueprints:GetAttribute(attributeName) ~= nil then
            blueprints:SetAttribute(attributeName, true)
            print("Attribute '" .. attributeName .. "' set to true.")
        else
            print("Attribute '" .. attributeName .. "' not found in Blueprints.")
        end
    end,
})

BlueprintTab:Button({
    Title = "解锁喷子",
    Callback = function()
        local player = game.Players.LocalPlayer
        local blueprints = player:WaitForChild("PlayerStats"):WaitForChild("Blueprints")
        local attributeName = "DoubleBarrel"
        if blueprints:GetAttribute(attributeName) ~= nil then
            blueprints:SetAttribute(attributeName, true)
            print("Attribute '" .. attributeName .. "' set to true.")
        else
            print("Attribute '" .. attributeName .. "' not found in Blueprints.")
        end
    end,
})

BlueprintTab:Button({
    Title = "解锁m1911",
    Callback = function()
        local player = game.Players.LocalPlayer
        local blueprints = player:WaitForChild("PlayerStats"):WaitForChild("Blueprints")
        local attributeName = "M1911"
        if blueprints:GetAttribute(attributeName) ~= nil then
            blueprints:SetAttribute(attributeName, true)
            print("Attribute '" .. attributeName .. "' set to true.")
        else
            print("Attribute '" .. attributeName .. "' not found in Blueprints.")
        end
    end,
})

BlueprintTab:Button({
    Title = "解锁马切特",
    Callback = function()
        local player = game.Players.LocalPlayer
        local blueprints = player:WaitForChild("PlayerStats"):WaitForChild("Blueprints")
        local attributeName = "Machete"
        if blueprints:GetAttribute(attributeName) ~= nil then
            blueprints:SetAttribute(attributeName, true)
            print("Attribute '" .. attributeName .. "' set to true.")
        else
            print("Attribute '" .. attributeName .. "' not found in Blueprints.")
        end
    end,
})
BlueprintTab:Button({
    Title = "解锁魔法书",
    Callback = function()
        local player = game.Players.LocalPlayer
        local blueprints = player:WaitForChild("PlayerStats"):WaitForChild("Blueprints")
        local attributeName = "SpellBook"
        if blueprints:GetAttribute(attributeName) ~= nil then
            blueprints:SetAttribute(attributeName, true)
            print("Attribute '" .. attributeName .. "' set to true.")
        else
            print("Attribute '" .. attributeName .. "' not found in Blueprints.")
        end
    end,
})
BlueprintTab:Button({
    Title = "解锁神器任务",
    Callback = function()
        local playerStats = game.Players.LocalPlayer:WaitForChild("PlayerStats")
        local quests = playerStats:WaitForChild("Quests")
        quests:SetAttribute("ArtifactQuest", true)
    end,
})
local Tab = Window:Tab({
    Title = "传送",
    Icon = "zap",
    Locked = false,
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getRootPart()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local target1 = Vector3.new(-26.879013061523438, -107.01750183105469, -204.7770538330078)
local target2 = Vector3.new(-110.85892486572266, -86.33830261230469, 211.8588409423828)
local target3 = Vector3.new(43.30422592163086, -97.9687728881836, 349.1531982421875)
local target4 = Vector3.new(164.49859619140625, -103.65132141113281, -35.76066207885742)
local target5 = Vector3.new(308.97198486328125, -113.4938735961914, -250.46066284179688)
local target6 = Vector3.new(-203.81826782226562, -110.8906478881836, -108.90457916259766)
local target7 = Vector3.new(-381.873046875, -115.02182006835938, 42.071022033691406)

Tab:Button({
    Title = "chain出生地",
    Callback = function()
        local ok, err = pcall(function()
            local root = getRootPart()
            if root then
                root.CFrame = CFrame.new(target1 + Vector3.new(0, 3, 0))
                print("传送到传送点 1")
            end
        end)
        if not ok then
            warn("传送失败:", err)
        end
    end
})

Tab:Button({
    Title = "商店",
    Callback = function()
        local ok, err = pcall(function()
            local root = getRootPart()
            if root then
                root.CFrame = CFrame.new(target2 + Vector3.new(0, 3, 0))
                print("传送到传送点 2")
            end
        end)
        if not ok then
            warn("传送失败:", err)
        end
    end
})

Tab:Button({
    Title = "排行榜",
    Callback = function()
        local ok, err = pcall(function()
            local root = getRootPart()
            if root then
                root.CFrame = CFrame.new(target3 + Vector3.new(0, 3, 0))
                print("传送到传送点 3")
            end
        end)
        if not ok then
            warn("传送失败:", err)
        end
    end
})

Tab:Button({
    Title = "工作间",
    Callback = function()
        local ok, err = pcall(function()
            local root = getRootPart()
            if root then
                root.CFrame = CFrame.new(target4 + Vector3.new(0, 3, 0))
                print("传送到传送点 4")
            end
        end)
        if not ok then
            warn("传送失败:", err)
        end
    end
})

Tab:Button({
    Title = "仓库",
    Callback = function()
        local ok, err = pcall(function()
            local root = getRootPart()
            if root then
                root.CFrame = CFrame.new(target5 + Vector3.new(0, 3, 0))
                print("传送到传送点 5")
            end
        end)
        if not ok then
            warn("传送失败:", err)
        end
    end
})

Tab:Button({
    Title = "发电站",
    Callback = function()
        local ok, err = pcall(function()
            local root = getRootPart()
            if root then
                root.CFrame = CFrame.new(target6 + Vector3.new(0, 3, 0))
                print("传送到传送点 6")
            end
        end)
        if not ok then
            warn("传送失败:", err)
        end
    end
})

Tab:Button({
    Title = "收音机站",
    Callback = function()
        local ok, err = pcall(function()
            local root = getRootPart()
            if root then
                root.CFrame = CFrame.new(target7 + Vector3.new(0, 3, 0))
                print("传送到传送点 7")
            end
        end)
        if not ok then
            warn("传送失败:", err)
        end
    end
})
local Tab = Window:Tab({
    Title = "商店",
    Icon = "store",
    Locked = false,
})
Tab:Button({
    Title = "打开商店界面",
    Description = "显示 PlayerGui.Ingame.Shop",
    Callback = function()
        local success, err = pcall(function()
            local shopGui = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Ingame"):WaitForChild("Shop")
            shopGui.Visible = true
        end)
        if not success then
            warn("未找到商店界面:", err)
        end
    end
})
local Tab = Window:Tab({  
    Title = "设置",  
    Icon = "house",  
    Locked = false,
})
local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

Tab:Dropdown({
    Title = "更改ui颜色",
    Multi = false,
    AllowNone = false,
    Value = nil,
    Values = themeValues,
    Callback = function(theme)
        WindUI:SetTheme(theme)
    end
})