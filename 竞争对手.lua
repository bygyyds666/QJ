local repo = 'https://raw.githubusercontent.com/KingScriptAE/No-sirve-nada./refs/heads/main/'
local function safeLoad(url)
	local success, result = pcall(function()
		return loadstring(game:HttpGet(url))()
	end)
	if not success then
		warn("加载失败: " .. url)
		return nil
	end
	return result
end

local Library = safeLoad(repo .. 'Library.lua')
local ThemeManager = safeLoad(repo .. 'addons/ThemeManager.lua')
local SaveManager = safeLoad(repo .. 'addons/SaveManager.lua')

if not Library then
	game:GetService("StarterGui"):SetCore("SendNotification", {
		Title = "错误",
		Text = "UI 库加载失败，请检查网络或脚本资源",
		Duration = 5,
	})
	return
end

local Options = Library.Options
local Toggles = Library.Toggles

local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local cloneref = cloneref or function(instance) return instance end

local PlayStartSound = Instance.new("Sound")
PlayStartSound.Looped = false
PlayStartSound.Volume = 1
PlayStartSound.Parent = SoundService
PlayStartSound:Play()
PlayStartSound.Ended:Connect(function() PlayStartSound:Destroy() end)

local ESPEnabled = false
local ESP_ScreenGui = nil
local ESPFolder = nil
local ESPNameColor = Color3.fromRGB(0, 255, 127)
local ESPBodyColor = Color3.fromRGB(0, 255, 127)
local ESPNameSize = 14
local ESPRainbowEnabled = false
local ESPRainbowSpeed = 5
local CurrentESPHue = 0

local BackstabCheckEnabled = false
local BackstabCooldown = 0
local BACKSTAB_COOLDOWN_TIME = 3
local DeathCheckEnabled = false

local InfiniteJumpEnabled = false
local JumpConnection = nil
local SpeedEnabled = false
local SpeedValue = 1
local SpeedConnection = nil
local GravityLoop = nil
local originalGravity = workspace.Gravity

local NightVisionEnabled = false
local originalBrightness = Lighting.Brightness
local originalAmbient = Lighting.Ambient

local RainbowUIEnabled = false
local RainbowUIScreenGui = nil
local StatusIndicator = nil
local animationConnection = nil

local AimSettings = {
	Enabled = false,
	FOV = 100,
	Smoothness = 10,
	CrosshairDistance = 5,
	FOVColor = Color3.fromRGB(0, 255, 0),
	FriendCheck = true,
	WallCheck = true,
	TargetAll = true,
	FOVRainbowEnabled = true,
	FOVRainbowSpeed = 8,
	FOVEnabled = true
}

local DrawingObjects = {}
local AimConnection = nil
local FOVCircle = nil
local CurrentTarget = nil
local CurrentFOVHue = 0

local RagebotRunning = false
local ragebotConnections = {}
local ragebotThreads = {}

local activeSounds = {}
local customMusic = nil

local targetPlayerList = {}
local selectedTargetIndex = 0

local function GetRainbowColor(hue)
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

local function InitESP()
	ESP_ScreenGui = Instance.new("ScreenGui")
	ESP_ScreenGui.Name = "PlayerESP_System"
	ESP_ScreenGui.ResetOnSpawn = false
	ESP_ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ESP_ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	ESPFolder = Instance.new("Folder")
	ESPFolder.Name = "PlayerESPFolder"
	ESPFolder.Parent = ESP_ScreenGui
end

local function UpdateESPColors()
	if not ESPEnabled or not ESPFolder then return end
	for _, child in ipairs(ESPFolder:GetChildren()) do
		if child:IsA("BillboardGui") then
			local nameLabel = child:FindFirstChild("NameLabel")
			if nameLabel then
				nameLabel.TextColor3 = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPNameColor
				nameLabel.TextSize = ESPNameSize
			end
		elseif child:IsA("Highlight") then
			child.FillColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
			child.OutlineColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
		end
	end
end

local function UpdateESPNameSize()
	if not ESPEnabled or not ESPFolder then return end
	for _, child in ipairs(ESPFolder:GetChildren()) do
		if child:IsA("BillboardGui") then
			local nameLabel = child:FindFirstChild("NameLabel")
			if nameLabel then
				nameLabel.TextSize = ESPNameSize
			end
		end
	end
end

local function CreatePlayerESP(player)
	if player == LocalPlayer or not ESPEnabled then return end
	local character = player.Character
	if not character then return end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	local existingESP = ESPFolder:FindFirstChild(player.Name)
	if existingESP then existingESP:Destroy() end
	local ESPGui = Instance.new("BillboardGui")
	ESPGui.Name = player.Name
	ESPGui.Adornee = humanoidRootPart
	ESPGui.Size = UDim2.new(0, 100, 0, 40)
	ESPGui.StudsOffset = Vector3.new(0, 3, 0)
	ESPGui.AlwaysOnTop = true
	ESPGui.MaxDistance = 500
	ESPGui.Enabled = true
	ESPGui.Parent = ESPFolder
	local NameLabel = Instance.new("TextLabel")
	NameLabel.Size = UDim2.new(1, 0, 0.5, 0)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Font = Enum.Font.GothamBold
	NameLabel.TextSize = ESPNameSize
	NameLabel.TextColor3 = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPNameColor
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
	Highlight.FillColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
	Highlight.FillTransparency = 0.7
	Highlight.OutlineColor = ESPRainbowEnabled and GetRainbowColor(CurrentESPHue) or ESPBodyColor
	Highlight.OutlineTransparency = 0
	Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	Highlight.Enabled = true
	Highlight.Parent = ESPFolder
end

local function CheckBackstabThreat()
	if not BackstabCheckEnabled then return end
	if BackstabCooldown > 0 then return end
	local myCharacter = LocalPlayer.Character
	local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end
	local myPosition = myHRP.Position
	local myCFrame = myHRP.CFrame
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			local humanoid = player.Character:FindFirstChild("Humanoid")
			if hrp and humanoid and humanoid.Health > 0 then
				local enemyPosition = hrp.Position
				local distance = (myPosition - enemyPosition).Magnitude
				if distance < 30 then
					local toEnemy = (enemyPosition - myPosition).Unit
					local myForward = myCFrame.LookVector
					local dotProduct = toEnemy:Dot(myForward)
					if dotProduct < 0.5 then
						Library:Notify("偷袭警告: 小心 " .. player.Name, 5)
						BackstabCooldown = BACKSTAB_COOLDOWN_TIME
						break
					end
				end
			end
		end
	end
end

local function SetupDeathDetection()
	LocalPlayer.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		humanoid.Died:Connect(function()
			if DeathCheckEnabled then
				Library:Notify("死亡提醒: 咋死了 messy帮你诅咒击杀者", 8)
			end
		end)
	end)
	if LocalPlayer.Character then
		local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.Died:Connect(function()
				if DeathCheckEnabled then
					Library:Notify("死亡提醒: 咋死了 messy帮你诅咒击杀者", 8)
				end
			end)
		end
	end
end

local function UpdateESP()
	if not ESPEnabled then return end
	pcall(function()
		local myCharacter = LocalPlayer.Character
		local myHRP = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
		if not myHRP then return end
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local character = player.Character
				if character then
					local hrp = character:FindFirstChild("HumanoidRootPart")
					if hrp then
						local espGui = ESPFolder:FindFirstChild(player.Name)
						if not espGui then
							CreatePlayerESP(player)
							espGui = ESPFolder:FindFirstChild(player.Name)
						end
						local distance = (myHRP.Position - hrp.Position).Magnitude
						local distanceLabel = espGui:FindFirstChild("DistanceLabel")
						if distanceLabel then
							distanceLabel.Text = string.format("%.0f studs", distance)
						end
						if distance > 500 then
							espGui.Enabled = false
							local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
							if highlight then highlight.Enabled = false end
						else
							espGui.Enabled = true
							local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
							if highlight then highlight.Enabled = true end
						end
					else
						local espGui = ESPFolder:FindFirstChild(player.Name)
						if espGui then espGui:Destroy() end
						local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
						if highlight then highlight:Destroy() end
					end
				else
					local esp = ESPFolder:FindFirstChild(player.Name)
					if esp then esp:Destroy() end
					local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
					if highlight then highlight:Destroy() end
				end
			end
		end
	end)
end

local function ToggleESP(state)
	ESPEnabled = state
	if state then
		if not ESP_ScreenGui then InitESP() end
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				CreatePlayerESP(player)
			end
		end
		Library:Notify("玩家透视已开启", 3)
	else
		if ESPFolder then
			for _, esp in ipairs(ESPFolder:GetChildren()) do
				esp:Destroy()
			end
		end
		Library:Notify("玩家透视已关闭", 3)
	end
end

InitESP()

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	if ESPEnabled then
		if ESPFolder then
			for _, esp in ipairs(ESPFolder:GetChildren()) do
				esp:Destroy()
			end
		end
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				CreatePlayerESP(player)
			end
		end
	end
end)

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		if ESPEnabled then
			task.wait(1)
			CreatePlayerESP(player)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	if ESPFolder then
		local espGui = ESPFolder:FindFirstChild(player.Name)
		if espGui then espGui:Destroy() end
		local highlight = ESPFolder:FindFirstChild(player.Name .. "_Highlight")
		if highlight then highlight:Destroy() end
	end
	if CurrentTarget == player then
		CurrentTarget = nil
	end
end)

RunService.Heartbeat:Connect(function(deltaTime)
	UpdateESP()
	if ESPRainbowEnabled then
		CurrentESPHue = CurrentESPHue + deltaTime * ESPRainbowSpeed / 10
		UpdateESPColors()
	end
	if BackstabCooldown > 0 then
		BackstabCooldown = BackstabCooldown - deltaTime
	end
	CheckBackstabThreat()
end)

local function InitializeAimDrawings()
	if not FOVCircle then
		FOVCircle = Drawing.new("Circle")
		FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
		FOVCircle.Thickness = 2
		FOVCircle.Filled = false
		FOVCircle.Radius = AimSettings.FOV
		FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
		table.insert(DrawingObjects, FOVCircle)
	end
end

local function UpdateFOVCircle()
	if FOVCircle then
		FOVCircle.Visible = AimSettings.Enabled and AimSettings.FOVEnabled
		FOVCircle.Radius = AimSettings.FOV
		if AimSettings.FOVRainbowEnabled then
			FOVCircle.Color = GetRainbowColor(CurrentFOVHue)
		else
			FOVCircle.Color = AimSettings.FOVColor
		end
		FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
	end
end

local function CleanupDrawings()
	for _, drawing in ipairs(DrawingObjects) do
		if drawing then
			drawing:Remove()
		end
	end
	DrawingObjects = {}
	FOVCircle = nil
end

local function IsFriend(player)
	if not AimSettings.FriendCheck then
		return false
	end
	local localPlayer = LocalPlayer
	local success, result = pcall(function()
		if localPlayer:IsFriendsWith(player.UserId) then
			return true
		end
		return false
	end)
	return success and result
end

local function WallCheck(targetPosition, targetCharacter)
	if not AimSettings.WallCheck then
		return true
	end
	local camera = workspace.CurrentCamera
	local origin = camera.CFrame.Position
	local direction = (targetPosition - origin).Unit
	local distance = (targetPosition - origin).Magnitude
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	raycastParams.IgnoreWater = true
	raycastParams.CollisionGroup = "Default"
	local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
	return raycastResult == nil
end

local function GetClosestPlayer()
	local camera = workspace.CurrentCamera
	local mousePos = camera.ViewportSize / 2
	local nearestPlayer = nil
	local shortestDistance = AimSettings.FOV

	if not AimSettings.TargetAll and AimSettings.TargetPlayer then
		local target = Players:FindFirstChild(AimSettings.TargetPlayer)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local humanoid = target.Character:FindFirstChild("Humanoid")
			if humanoid and humanoid.Health > 0 then
				local targetPos = target.Character.HumanoidRootPart.Position
				local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
				if onScreen then
					local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
					if distance <= AimSettings.FOV and WallCheck(targetPos, target.Character) then
						if not IsFriend(target) then
							CurrentTarget = target
							return target
						end
					end
				end
			end
		end
		CurrentTarget = nil
		return nil
	end

	if CurrentTarget and CurrentTarget ~= LocalPlayer and CurrentTarget.Character then
		local hrp = CurrentTarget.Character:FindFirstChild("HumanoidRootPart")
		local humanoid = CurrentTarget.Character:FindFirstChild("Humanoid")
		if hrp and humanoid and humanoid.Health > 0 then
			local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
			if onScreen then
				local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
				if distance <= AimSettings.FOV and WallCheck(hrp.Position, CurrentTarget.Character) then
					if not IsFriend(CurrentTarget) then
						return CurrentTarget
					end
				end
			end
		end
	end

	CurrentTarget = nil
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			if not IsFriend(player) then
				local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
				local humanoid = player.Character:FindFirstChild("Humanoid")
				if humanoidRootPart and humanoid and humanoid.Health > 0 then
					if WallCheck(humanoidRootPart.Position, player.Character) then
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
		end
	end
	if nearestPlayer then
		CurrentTarget = nearestPlayer
	end
	return nearestPlayer
end

local function AimBot()
	if not AimSettings.Enabled then
		return
	end
	local camera = workspace.CurrentCamera
	local target = GetClosestPlayer()
	if target and target.Character then
		local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
		local head = target.Character:FindFirstChild("Head")
		if humanoidRootPart and head then
			local targetVelocity = humanoidRootPart.Velocity
			local targetPosition = head.Position
			if AimSettings.CrosshairDistance > 0 then
				local distance = (targetPosition - camera.CFrame.Position).Magnitude
				local timeToTarget = distance / 1000
				targetPosition = targetPosition + (targetVelocity * timeToTarget * AimSettings.CrosshairDistance)
			end
			local currentCFrame = camera.CFrame
			local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
			local smoothedCFrame = currentCFrame:Lerp(targetCFrame, 1 / AimSettings.Smoothness)
			camera.CFrame = smoothedCFrame
		end
	end
end

local function CreateRainbowUI()
	if RainbowUIScreenGui then
		RainbowUIScreenGui:Destroy()
		RainbowUIScreenGui = nil
	end
	local playerGui = LocalPlayer:WaitForChild("PlayerGui")
	RainbowUIScreenGui = Instance.new("ScreenGui")
	RainbowUIScreenGui.Name = "RainbowCircleUI"
	RainbowUIScreenGui.ResetOnSpawn = false
	RainbowUIScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	RainbowUIScreenGui.DisplayOrder = 99999
	RainbowUIScreenGui.IgnoreGuiInset = true
	RainbowUIScreenGui.Enabled = true
	RainbowUIScreenGui.Parent = playerGui
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "RainbowCircle"
	mainFrame.Size = UDim2.new(0, 80, 0, 80)
	mainFrame.Position = UDim2.new(0, 10, 0, 10)
	mainFrame.BackgroundTransparency = 1
	mainFrame.ZIndex = 100000
	mainFrame.Parent = RainbowUIScreenGui
	mainFrame.Active = true
	mainFrame.Selectable = true
	mainFrame.Draggable = false
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = mainFrame
	local rainbowBackground = Instance.new("Frame")
	rainbowBackground.Name = "RainbowBackground"
	rainbowBackground.Size = UDim2.new(1, 0, 1, 0)
	rainbowBackground.Position = UDim2.new(0, 0, 0, 0)
	rainbowBackground.BackgroundTransparency = 0
	rainbowBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	rainbowBackground.ZIndex = 100001
	rainbowBackground.Parent = mainFrame
	rainbowBackground.Active = true
	rainbowBackground.Selectable = true
	local rainbowCorner = Instance.new("UICorner")
	rainbowCorner.CornerRadius = UDim.new(1, 0)
	rainbowCorner.Parent = rainbowBackground
	local rainbowStroke = Instance.new("UIStroke")
	rainbowStroke.Name = "RainbowStroke"
	rainbowStroke.Color = Color3.fromRGB(255, 255, 255)
	rainbowStroke.Thickness = 3
	rainbowStroke.Transparency = 0
	rainbowStroke.Parent = mainFrame
	local innerStroke = Instance.new("UIStroke")
	innerStroke.Name = "InnerStroke"
	innerStroke.Color = Color3.fromRGB(0, 0, 0)
	innerStroke.Thickness = 1
	innerStroke.Transparency = 0.3
	innerStroke.Parent = rainbowBackground
	StatusIndicator = Instance.new("Frame")
	StatusIndicator.Name = "StatusIndicator"
	StatusIndicator.Size = UDim2.new(0, 15, 0, 15)
	StatusIndicator.Position = UDim2.new(1, -18, 1, -18)
	StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	StatusIndicator.BackgroundTransparency = 0
	StatusIndicator.ZIndex = 100002
	StatusIndicator.Parent = mainFrame
	local indicatorCorner = Instance.new("UICorner")
	indicatorCorner.CornerRadius = UDim.new(1, 0)
	indicatorCorner.Parent = StatusIndicator
	local indicatorStroke = Instance.new("UIStroke")
	indicatorStroke.Color = Color3.fromRGB(255, 255, 255)
	indicatorStroke.Thickness = 2
	indicatorStroke.Parent = StatusIndicator
	local statusText = Instance.new("TextLabel")
	statusText.Name = "StatusText"
	statusText.Size = UDim2.new(1, 0, 0, 25)
	statusText.Position = UDim2.new(0, 0, 1, 5)
	statusText.BackgroundTransparency = 1
	statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
	statusText.TextColor3 = Color3.fromRGB(255, 255, 255)
	statusText.TextSize = 14
	statusText.Font = Enum.Font.GothamBold
	statusText.TextStrokeTransparency = 0.3
	statusText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	statusText.TextStrokeTransparency = 0.3
	statusText.ZIndex = 100002
	statusText.Parent = mainFrame
	local clickArea = Instance.new("TextButton")
	clickArea.Name = "ClickArea"
	clickArea.Size = UDim2.new(1, 0, 1, 0)
	clickArea.Position = UDim2.new(0, 0, 0, 0)
	clickArea.BackgroundTransparency = 1
	clickArea.Text = ""
	clickArea.ZIndex = 100003
	clickArea.Parent = mainFrame
	local rainbowColors = {
		Color3.fromRGB(255, 0, 0),
		Color3.fromRGB(255, 95, 0),
		Color3.fromRGB(255, 165, 0),
		Color3.fromRGB(255, 215, 0),
		Color3.fromRGB(255, 255, 0),
		Color3.fromRGB(144, 238, 144),
		Color3.fromRGB(0, 255, 0),
		Color3.fromRGB(0, 200, 200),
		Color3.fromRGB(0, 0, 255),
		Color3.fromRGB(75, 0, 130),
		Color3.fromRGB(138, 43, 226),
		Color3.fromRGB(148, 0, 211),
		Color3.fromRGB(199, 21, 133),
		Color3.fromRGB(255, 20, 147)
	}
	local rainbowColors2 = {
		Color3.fromRGB(255, 0, 0),
		Color3.fromRGB(255, 127, 0),
		Color3.fromRGB(255, 255, 0),
		Color3.fromRGB(0, 255, 0),
		Color3.fromRGB(0, 0, 255),
		Color3.fromRGB(75, 0, 130),
		Color3.fromRGB(148, 0, 211)
	}
	local timeOffset = 0
	local hoverAmplitude = 4
	local hoverSpeed = 4
	local pulseSpeed = 2
	local pulseAmount = 0.1
	local colorIndex = 1
	local colorIndex2 = 3
	local transitionTime = 0.8
	local transitionTime2 = 0.5
	local elapsedTime = 0
	local elapsedTime2 = 0
	local pulseScale = 1
	local isPulsingOut = true
	if animationConnection then
		animationConnection:Disconnect()
	end
	animationConnection = RunService.RenderStepped:Connect(function(deltaTime)
		if not RainbowUIEnabled or not RainbowUIScreenGui or not RainbowUIScreenGui.Parent then
			animationConnection:Disconnect()
			animationConnection = nil
			return
		end
		elapsedTime = elapsedTime + deltaTime
		if elapsedTime >= transitionTime then
			elapsedTime = 0
			colorIndex = colorIndex + 1
			if colorIndex > #rainbowColors then
				colorIndex = 1
			end
		end
		local nextColorIndex = colorIndex + 1
		if nextColorIndex > #rainbowColors then
			nextColorIndex = 1
		end
		local alpha = elapsedTime / transitionTime
		local currentBgColor = rainbowColors[colorIndex]:Lerp(rainbowColors[nextColorIndex], alpha)
		rainbowBackground.BackgroundColor3 = currentBgColor
		elapsedTime2 = elapsedTime2 + deltaTime
		if elapsedTime2 >= transitionTime2 then
			elapsedTime2 = 0
			colorIndex2 = colorIndex2 + 1
			if colorIndex2 > #rainbowColors2 then
				colorIndex2 = 1
			end
		end
		local nextColorIndex2 = colorIndex2 + 1
		if nextColorIndex2 > #rainbowColors2 then
			nextColorIndex2 = 1
		end
		local alpha2 = elapsedTime2 / transitionTime2
		local currentStrokeColor = rainbowColors2[colorIndex2]:Lerp(rainbowColors2[nextColorIndex2], alpha2)
		rainbowStroke.Color = currentStrokeColor
		if isPulsingOut then
			pulseScale = pulseScale + deltaTime * pulseSpeed * pulseAmount
			if pulseScale >= 1 + pulseAmount then
				isPulsingOut = false
			end
		else
			pulseScale = pulseScale - deltaTime * pulseSpeed * pulseAmount
			if pulseScale <= 1 - pulseAmount then
				isPulsingOut = true
			end
		end
		rainbowBackground.Size = UDim2.new(pulseScale, 0, pulseScale, 0)
		rainbowBackground.Position = UDim2.new((1 - pulseScale) / 2, 0, (1 - pulseScale) / 2, 0)
		timeOffset = timeOffset + deltaTime * hoverSpeed
		local hoverOffset = math.sin(timeOffset) * hoverAmplitude
		mainFrame.Position = UDim2.new(0, 10, 0, 10 + hoverOffset)
		innerStroke.Transparency = 0.2 + 0.3 * math.sin(timeOffset * 2)
		if StatusIndicator then
			StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		end
		if statusText then
			statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
			statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
		end
	end)
	local function handleClick()
		AimSettings.Enabled = not AimSettings.Enabled
		if AimSettings.Enabled then
			InitializeAimDrawings()
			UpdateFOVCircle()
			if AimConnection then
				AimConnection:Disconnect()
			end
			AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
				if AimSettings.FOVRainbowEnabled then
					CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
				end
				UpdateFOVCircle()
				AimBot()
			end)
		else
			if AimConnection then
				AimConnection:Disconnect()
				AimConnection = nil
			end
			CleanupDrawings()
			CurrentTarget = nil
		end
		if StatusIndicator then
			StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		end
		if statusText then
			statusText.Text = AimSettings.Enabled and "自瞄开" or "自瞄关"
			statusText.TextColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 100, 100)
		end
		local originalSize = rainbowBackground.Size
		local originalPosition = rainbowBackground.Position
		local tweenInfo1 = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tweenInfo2 = TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
		local clickScaleUp = TweenService:Create(rainbowBackground, tweenInfo1, {
			Size = originalSize * 0.7,
			Position = UDim2.new(0.15, 0, 0.15, 0)
		})
		local clickScaleDown = TweenService:Create(rainbowBackground, tweenInfo2, {
			Size = originalSize,
			Position = originalPosition
		})
		local originalStrokeColor = rainbowStroke.Color
		local flashTween = TweenService:Create(rainbowStroke, tweenInfo1, {
			Color = Color3.fromRGB(255, 255, 255)
		})
		local revertStroke = TweenService:Create(rainbowStroke, tweenInfo2, {
			Color = originalStrokeColor
		})
		clickScaleUp:Play()
		flashTween:Play()
		clickScaleUp.Completed:Connect(function()
			clickScaleDown:Play()
			revertStroke:Play()
		end)
	end
	clickArea.MouseButton1Click:Connect(handleClick)
	mainFrame.MouseButton1Click:Connect(handleClick)
	mainFrame.MouseEnter:Connect(function()
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
			Thickness = 6
		})
		pulseAmount = 0.15
		tween1:Play()
	end)
	mainFrame.MouseLeave:Connect(function()
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween1 = TweenService:Create(rainbowStroke, tweenInfo, {
			Thickness = 3
		})
		pulseAmount = 0.1
		tween1:Play()
	end)
	rainbowBackground.BackgroundTransparency = 1
	rainbowStroke.Transparency = 1
	local fadeIn = TweenService:Create(rainbowBackground, TweenInfo.new(0.5), {
		BackgroundTransparency = 0
	})
	local strokeFadeIn = TweenService:Create(rainbowStroke, TweenInfo.new(0.5), {
		Transparency = 0
	})
	task.wait(0.2)
	fadeIn:Play()
	strokeFadeIn:Play()
	return true
end

local function ToggleRainbowUI(state)
	RainbowUIEnabled = state
	if state then
		local success = CreateRainbowUI()
		if success then
			Library:Notify("自瞄快捷UI已开启", 3)
		end
	else
		if RainbowUIScreenGui then
			RainbowUIScreenGui:Destroy()
			RainbowUIScreenGui = nil
		end
		Library:Notify("自瞄快捷UI已隐藏", 3)
	end
end

local function StartRagebot()
	RagebotRunning = true
	local plr = game:GetService("Players").LocalPlayer
	local rs = game:GetService("ReplicatedStorage")
	local evt = rs.Remotes.Replication.Fighter.UseItem
	local cam = workspace.CurrentCamera
	local rns = game:GetService("RunService")
	local DebrisService = game:GetService("Debris")
	local ws = game:GetService("Workspace")
	local aur, lf, itm, trg = true, nil, nil, nil
	for _, v in pairs(getgc(true)) do
		if type(v) == "table" and rawget(v, "LocalFighter") then
			lf = v.LocalFighter
			break
		end
	end
	local function createTrail(origin, targetPos)
		local trailContainer = Instance.new("Folder")
		trailContainer.Name = "MagicTrail"
		trailContainer.Parent = ws
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
				color = Color3.fromRGB(200, 180, 255)
			elseif t < 0.6 then
				color = Color3.fromRGB(180, 150, 240)
			elseif t < 0.9 then
				color = Color3.fromRGB(160, 130, 230)
			else
				color = Color3.fromRGB(140, 100, 220)
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
		DebrisService:AddItem(trailContainer, 1.5)
		return trailContainer
	end
	local function encf(pos, lat)
		local cf = CFrame.lookAt(pos, lat)
		local rx, ry, rz = cf:ToOrientation()
		return {
			["\x00"] = pos.X,
			["\x01"] = pos.Y,
			["\x02"] = pos.Z,
			["\x03"] = rx,
			["\x04"] = ry,
			["\x05"] = rz,
		}
	end
	local function wallCheck(startPos, endPos, targetPart)
		local direction = (endPos - startPos).Unit
		local distance = (endPos - startPos).Magnitude
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {plr.Character, targetPart.Parent}
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		raycastParams.IgnoreWater = true
		local raycastResult = ws:Raycast(startPos, direction * distance, raycastParams)
		if raycastResult then
			if raycastResult.Instance:IsDescendantOf(targetPart.Parent) then
				return true
			end
			return false
		end
		return true
	end
	local thread1 = task.spawn(function()
		while aur and RagebotRunning do
			local np, nd = nil, 9999
			local ch = plr.Character
			if ch and ch:FindFirstChild("HumanoidRootPart") then
				local cp = ch.HumanoidRootPart.Position
				for _, v in pairs(workspace:GetChildren()) do
					if v ~= ch and v:FindFirstChild("Head") and v:FindFirstChild("Humanoid") then
						local hum = v:FindFirstChild("Humanoid")
						if hum and hum.Health > 0 then
							local d = (v.HumanoidRootPart.Position - cp).Magnitude
							if d < nd then
								nd = d
								np = v
							end
						end
					end
				end
			end
			trg = np
			task.wait(0.05)
		end
	end)
	table.insert(ragebotThreads, thread1)
	local thread2 = task.spawn(function()
		while aur and RagebotRunning do
			if lf and lf.Items then
				for _, v in pairs(lf.Items) do
					if v.IsEquipped and v.Info and v.Info.MaxAmmo then
						itm = v
						break
					end
				end
			end
			task.wait(0.5)
		end
	end)
	table.insert(ragebotThreads, thread2)
	local renderConn = rns.RenderStepped:Connect(function()
		if not RagebotRunning then return end
		if trg then
			local ch = plr.Character
			if ch and ch:FindFirstChild("HumanoidRootPart") then
				local hrp = ch.HumanoidRootPart
				local tp = trg:FindFirstChild("HumanoidRootPart")
				if tp then
					local mps = hrp.Position
					local eps = tp.Position
					local lat = Vector3.new(eps.X, mps.Y, eps.Z)
					hrp.CFrame = CFrame.lookAt(mps, lat)
				end
			end
		end
	end)
	table.insert(ragebotConnections, renderConn)
	local trailPool = {}
	local trailCleanThread = task.spawn(function()
		while RagebotRunning do
			for i = #trailPool, 1, -1 do
				local trail = trailPool[i]
				if trail and trail.Parent == nil then
					table.remove(trailPool, i)
				end
			end
			task.wait(0.5)
		end
	end)
	table.insert(ragebotThreads, trailCleanThread)
	local fireThread = task.spawn(function()
		while aur and RagebotRunning do
			if itm and trg then
				local hd = trg:FindFirstChild("Head")
				local ch = plr.Character
				if hd and ch and ch:FindFirstChild("HumanoidRootPart") then
					local hrp = ch.HumanoidRootPart
					local tp = hd.Position
					local cp = hrp.Position + Vector3.new(0, 1.5, 0)
					local dir = (tp - cp).Unit
					if wallCheck(cp, tp, hd) then
						local maxOffset = 0.2
						local distance = (tp - cp).Magnitude
						local distanceFactor = math.min(distance / 50, 1)
						local actualOffset = maxOffset * distanceFactor
						local offsetX = (math.random() - 0.5) * 2 * actualOffset
						local offsetY = (math.random() - 0.5) * 2 * actualOffset
						local offsetZ = (math.random() - 0.5) * 2 * actualOffset
						local targetPosition = tp + Vector3.new(offsetX, offsetY, offsetZ)
						evt:FireServer(itm:Get("ObjectID"), "\x1A", {
							["\x01"] = {
								["\x00"] = encf(cp, targetPosition),
								["\x01"] = encf(targetPosition, cp),
								["\x02"] = hd,
								["\x03"] = {
									["\x00"] = dir.X,
									["\x01"] = dir.Y,
									["\x02"] = dir.Z,
									["\x03"] = -dir.X,
									["\x04"] = -dir.Y,
									["\x05"] = -dir.Z,
								},
							},
							["\x02"] = true,
							["\x03"] = true,
						}, nil)
						local newTrail = createTrail(cp, targetPosition)
						if newTrail then
							table.insert(trailPool, newTrail)
						end
						local snd = Instance.new("Sound", workspace)
						snd.SoundId = "rbxassetid://8679627751"
						snd.Volume = 1
						snd.PlayOnRemove = true
						DebrisService:AddItem(snd, 1)
					end
				end
			end
			task.wait(0.01)
		end
	end)
	table.insert(ragebotThreads, fireThread)
end

local function StopRagebot()
	RagebotRunning = false
	for _, conn in ipairs(ragebotConnections) do
		conn:Disconnect()
	end
	ragebotConnections = {}
	for _, thread in ipairs(ragebotThreads) do
		task.cancel(thread)
	end
	ragebotThreads = {}
end

local Window = Library:CreateWindow({
	Title = "QJ脚本",
	Footer = "作者：琼玖",
	Icon = 131153193945220,
	NotifySide = "Right",
	ShowCustomCursor = true,
})

Library:Notify("琼玖脚本已加载", 5)

local Tabs = {
	Rage = Window:AddTab("暴力杀戮", "crown"),
	Player = Window:AddTab("本地玩家", "user"),
	Aim = Window:AddTab("暴力功能", "crosshair"),
	Other = Window:AddTab("次要功能", "settings"),
	Music = Window:AddTab("音乐库", "music"),
	Settings = Window:AddTab("设置", "settings"),
}

local RageGroup = Tabs.Rage:AddLeftGroupbox("暴力杀戮")
RageGroup:AddToggle('RagebotToggle', {
	Text = 'Ragebot',
	Default = false,
	Tooltip = '开启暴力自瞄杀戮',
	Callback = function(Value)
		if Value then
			StartRagebot()
			Library:Notify("Ragebot已开启", 3)
		else
			StopRagebot()
			Library:Notify("Ragebot已关闭", 3)
		end
	end
})

local PlayerLeft = Tabs.Player:AddLeftGroupbox("移动增强")
PlayerLeft:AddToggle('InfiniteJumpToggle', {
	Text = '无限跳跃',
	Default = false,
	Tooltip = '按住空格可连续跳跃',
	Callback = function(Value)
		InfiniteJumpEnabled = Value
		if Value then
			if JumpConnection then
				JumpConnection:Disconnect()
			end
			JumpConnection = UserInputService.JumpRequest:Connect(function()
				local char = LocalPlayer.Character
				if char and char:FindFirstChild("Humanoid") then
					char.Humanoid:ChangeState("Jumping")
				end
			end)
			Library:Notify("无限跳跃已开启", 2)
		else
			if JumpConnection then
				JumpConnection:Disconnect()
				JumpConnection = nil
			end
			Library:Notify("无限跳跃已关闭", 2)
		end
	end
})

PlayerLeft:AddSlider('GravitySlider', {
	Text = '重力值',
	Default = 196,
	Min = 0,
	Max = 500,
	Rounding = 0,
	Suffix = "",
	Callback = function(Value)
		workspace.Gravity = Value
		Library:Notify("重力已设置为: " .. Value, 2)
	end
})

PlayerLeft:AddSlider('SpeedValueSlider', {
	Text = '跑步速度倍率',
	Default = 1,
	Min = 1,
	Max = 50,
	Rounding = 0,
	Suffix = "",
	Callback = function(Value)
		SpeedValue = Value
	end
})

PlayerLeft:AddToggle('SpeedToggle', {
	Text = '开启快速跑步',
	Default = false,
	Tooltip = '使用设定的速度倍率',
	Callback = function(Value)
		SpeedEnabled = Value
		if Value then
			if SpeedConnection then
				SpeedConnection:Disconnect()
			end
			SpeedConnection = RunService.Heartbeat:Connect(function()
				local player = LocalPlayer
				local char = player.Character
				if char and char:FindFirstChild("Humanoid") then
					local humanoid = char.Humanoid
					if humanoid.MoveDirection.Magnitude > 0 then
						char:TranslateBy(humanoid.MoveDirection * SpeedValue / 2)
					end
				end
			end)
		else
			if SpeedConnection then
				SpeedConnection:Disconnect()
				SpeedConnection = nil
			end
		end
	end
})

local PlayerRight = Tabs.Player:AddRightGroupbox("其他")
PlayerRight:AddToggle('NightVisionToggle', {
	Text = '夜视模式',
	Default = false,
	Callback = function(Value)
		NightVisionEnabled = Value
		if Value then
			originalBrightness = Lighting.Brightness
			originalAmbient = Lighting.Ambient
			Lighting.Brightness = 2
			Lighting.Ambient = Color3.fromRGB(200, 200, 200)
			Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
			Library:Notify("夜视模式已开启", 2)
		else
			Lighting.Brightness = originalBrightness
			Lighting.Ambient = originalAmbient
			Lighting.OutdoorAmbient = Color3.fromRGB(0.5, 0.5, 0.5)
			Library:Notify("夜视模式已关闭", 2)
		end
	end
})

local AimLeft = Tabs.Aim:AddLeftGroupbox("自瞄控制")
AimLeft:AddToggle('AimEnabled', {
	Text = '启用自瞄',
	Default = false,
	Callback = function(Value)
		AimSettings.Enabled = Value
		if Value then
			InitializeAimDrawings()
			UpdateFOVCircle()
			if AimConnection then
				AimConnection:Disconnect()
			end
			AimConnection = RunService.RenderStepped:Connect(function(deltaTime)
				if AimSettings.FOVRainbowEnabled then
					CurrentFOVHue = CurrentFOVHue + deltaTime * AimSettings.FOVRainbowSpeed / 10
				end
				UpdateFOVCircle()
				AimBot()
			end)
			Library:Notify("自瞄已开启", 2)
		else
			if AimConnection then
				AimConnection:Disconnect()
				AimConnection = nil
			end
			CleanupDrawings()
			CurrentTarget = nil
			Library:Notify("自瞄已关闭", 2)
		end
		if StatusIndicator then
			StatusIndicator.BackgroundColor3 = AimSettings.Enabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
		end
	end
})

AimLeft:AddToggle('RainbowUIToggle', {
	Text = '自瞄快捷UI',
	Default = false,
	Callback = function(Value)
		ToggleRainbowUI(Value)
	end
})

AimLeft:AddToggle('FOVEnabledToggle', {
	Text = 'FOV开关',
	Default = true,
	Callback = function(Value)
		AimSettings.FOVEnabled = Value
		UpdateFOVCircle()
	end
})

AimLeft:AddToggle('FOVRainbowToggle', {
	Text = 'FOV彩虹效果',
	Default = true,
	Callback = function(Value)
		AimSettings.FOVRainbowEnabled = Value
		UpdateFOVCircle()
	end
})

AimLeft:AddSlider('FOVRainbowSpeedSlider', {
	Text = 'FOV彩虹速度',
	Default = 8,
	Min = 1,
	Max = 20,
	Rounding = 0,
	Callback = function(Value)
		AimSettings.FOVRainbowSpeed = Value
	end
})

AimLeft:AddSlider('AimFOVSlider', {
	Text = '自瞄范围(FOV)',
	Default = 100,
	Min = 50,
	Max = 500,
	Rounding = 0,
	Callback = function(Value)
		AimSettings.FOV = Value
		UpdateFOVCircle()
	end
})

AimLeft:AddSlider('SmoothnessSlider', {
	Text = '自瞄平滑度',
	Default = 10,
	Min = 1,
	Max = 50,
	Rounding = 0,
	Callback = function(Value)
		AimSettings.Smoothness = Value
	end
})

AimLeft:AddSlider('CrosshairSlider', {
	Text = '预判距离',
	Default = 5,
	Min = 0,
	Max = 20,
	Rounding = 0,
	Callback = function(Value)
		AimSettings.CrosshairDistance = Value
	end
})

AimLeft:AddToggle('FriendCheckToggle', {
	Text = '好友检测',
	Default = true,
	Callback = function(Value)
		AimSettings.FriendCheck = Value
	end
})

AimLeft:AddToggle('WallCheckToggle', {
	Text = '墙壁检测',
	Default = true,
	Callback = function(Value)
		AimSettings.WallCheck = Value
	end
})

AimLeft:AddToggle('TargetModeToggle', {
	Text = '目标自瞄模式',
	Default = false,
	Callback = function(Value)
		AimSettings.TargetAll = not Value
		CurrentTarget = nil
		if Value then
			Library:Notify("已切换至目标模式，请使用下方按钮选择玩家", 3)
		else
			Library:Notify("已切换至全部玩家模式", 3)
		end
	end
})

targetPlayerList = {}
for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		table.insert(targetPlayerList, player.Name)
	end
end
Players.PlayerAdded:Connect(function(player)
	table.insert(targetPlayerList, player.Name)
end)
Players.PlayerRemoving:Connect(function(player)
	for i, name in ipairs(targetPlayerList) do
		if name == player.Name then
			table.remove(targetPlayerList, i)
			break
		end
	end
	if AimSettings.TargetPlayer == player.Name then
		AimSettings.TargetPlayer = nil
		CurrentTarget = nil
	end
end)

AimLeft:AddButton('下一个目标', function()
	if AimSettings.TargetAll then
		Library:Notify("请先开启目标自瞄模式", 3)
		return
	end
	if #targetPlayerList == 0 then
		Library:Notify("没有可选择的玩家", 3)
		return
	end
	selectedTargetIndex = (selectedTargetIndex % #targetPlayerList) + 1
	AimSettings.TargetPlayer = targetPlayerList[selectedTargetIndex]
	CurrentTarget = nil
	Library:Notify("已选择目标: " .. AimSettings.TargetPlayer, 3)
end)

local AimRight = Tabs.Aim:AddRightGroupbox("快速设置")
AimRight:AddButton('近距离(强锁)', function()
	AimSettings.FOV = 80
	AimSettings.Smoothness = 1
	AimSettings.CrosshairDistance = 0
	UpdateFOVCircle()
	Library:Notify("已应用近距离设置", 2)
end)
AimRight:AddButton('中距离(小强锁)', function()
	AimSettings.FOV = 120
	AimSettings.Smoothness = 4
	AimSettings.CrosshairDistance = 2
	UpdateFOVCircle()
	Library:Notify("已应用中距离设置", 2)
end)
AimRight:AddButton('远距离', function()
	AimSettings.FOV = 130
	AimSettings.Smoothness = 5
	AimSettings.CrosshairDistance = 3
	UpdateFOVCircle()
	Library:Notify("已应用远距离设置", 2)
end)

local OtherLeft = Tabs.Other:AddLeftGroupbox("ESP设置")
OtherLeft:AddToggle('ESPToggle', {
	Text = '玩家透视(ESP)',
	Default = false,
	Callback = function(Value)
		ToggleESP(Value)
	end
})
OtherLeft:AddSlider('ESPNameSizeSlider', {
	Text = '名字大小',
	Default = 14,
	Min = 8,
	Max = 24,
	Rounding = 0,
	Callback = function(Value)
		ESPNameSize = Value
		if ESPEnabled then
			UpdateESPNameSize()
		end
	end
})
OtherLeft:AddToggle('ESPRainbowToggle', {
	Text = '彩虹渐变',
	Default = false,
	Callback = function(Value)
		ESPRainbowEnabled = Value
		if ESPEnabled then
			UpdateESPColors()
		end
	end
})
OtherLeft:AddSlider('ESPRainbowSpeedSlider', {
	Text = '彩虹速度',
	Default = 5,
	Min = 1,
	Max = 10,
	Rounding = 0,
	Callback = function(Value)
		ESPRainbowSpeed = Value
	end
})
OtherLeft:AddToggle('BackstabToggle', {
	Text = '偷袭检测提醒',
	Default = false,
	Callback = function(Value)
		BackstabCheckEnabled = Value
		Library:Notify(Value and "偷袭检测已开启" or "偷袭检测已关闭", 2)
	end
})
OtherLeft:AddToggle('DeathCheckToggle', {
	Text = '死亡提醒',
	Default = false,
	Callback = function(Value)
		DeathCheckEnabled = Value
		if Value then
			SetupDeathDetection()
		end
		Library:Notify(Value and "死亡提醒已开启" or "死亡提醒已关闭", 2)
	end
})
OtherLeft:AddToggle('NightVisionToggle2', {
	Text = '夜视模式',
	Default = false,
	Callback = function(Value)
		NightVisionEnabled = Value
		if Value then
			originalBrightness = Lighting.Brightness
			originalAmbient = Lighting.Ambient
			Lighting.Brightness = 2
			Lighting.Ambient = Color3.fromRGB(200, 200, 200)
			Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
			Library:Notify("夜视模式已开启", 2)
		else
			Lighting.Brightness = originalBrightness
			Lighting.Ambient = originalAmbient
			Lighting.OutdoorAmbient = Color3.fromRGB(0.5, 0.5, 0.5)
			Library:Notify("夜视模式已关闭", 2)
		end
	end
})

local MusicLeft = Tabs.Music:AddLeftGroupbox("播放器")
MusicLeft:AddButton('关闭所有音乐', function()
	for _, sound in pairs(activeSounds) do
		if sound and sound:IsA("Sound") then
			sound:Stop()
			sound:Destroy()
		end
	end
	activeSounds = {}
	if customMusic then
		customMusic:Stop()
		customMusicPlaying = false
	end
	Library:Notify("所有音乐已停止", 2)
end)

MusicLeft:AddLabel('预定义音乐')
MusicLeft:AddButton('柔慢日语歌', function()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://88942576563851"
	sound.Parent = workspace
	sound:Play()
	table.insert(activeSounds, sound)
	sound.Ended:Connect(function()
		for i, s in ipairs(activeSounds) do
			if s == sound then
				table.remove(activeSounds, i)
				break
			end
		end
		sound:Destroy()
	end)
	Library:Notify("正在播放: 柔慢日语歌", 2)
end)
MusicLeft:AddButton('唯一', function()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://138570939058838"
	sound.Parent = workspace
	sound:Play()
	table.insert(activeSounds, sound)
	sound.Ended:Connect(function()
		for i, s in ipairs(activeSounds) do
			if s == sound then
				table.remove(activeSounds, i)
				break
			end
		end
		sound:Destroy()
	end)
	Library:Notify("正在播放: 唯一", 2)
end)
MusicLeft:AddButton('Qian Li', function()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://9042630735"
	sound.Parent = workspace
	sound:Play()
	table.insert(activeSounds, sound)
	sound.Ended:Connect(function()
		for i, s in ipairs(activeSounds) do
			if s == sound then
				table.remove(activeSounds, i)
				break
			end
		end
		sound:Destroy()
	end)
	Library:Notify("正在播放: Qian Li", 2)
end)
MusicLeft:AddButton('DJ', function()
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://112834898401032"
	sound.Parent = workspace
	sound:Play()
	table.insert(activeSounds, sound)
	sound.Ended:Connect(function()
		for i, s in ipairs(activeSounds) do
			if s == sound then
				table.remove(activeSounds, i)
				break
			end
		end
		sound:Destroy()
	end)
	Library:Notify("正在播放: DJ", 2)
end)

local SettingsGroup = Tabs.Settings:AddLeftGroupbox("菜单")
SettingsGroup:AddButton('卸载脚本', function()
	ESPEnabled = false
	if ESPFolder then
		for _, esp in ipairs(ESPFolder:GetChildren()) do
			esp:Destroy()
		end
	end
	StopRagebot()
	if AimConnection then
		AimConnection:Disconnect()
	end
	CleanupDrawings()
	if JumpConnection then
		JumpConnection:Disconnect()
	end
	if SpeedConnection then
		SpeedConnection:Disconnect()
	end
	if animationConnection then
		animationConnection:Disconnect()
	end
	if RainbowUIScreenGui then
		RainbowUIScreenGui:Destroy()
	end
	Library:Unload()
end)

SettingsGroup:AddLabel('菜单快捷键'):AddKeyPicker('MenuKeybind', {
	Default = 'RightShift',
	NoUI = true,
	Text = 'Menu keybind'
})

Library.ToggleKeybind = Options.MenuKeybind

if ThemeManager then
	ThemeManager:SetLibrary(Library)
	ThemeManager:SetFolder("QJScriptTheme")
	ThemeManager:ApplyToTab(Tabs.Settings)
end

if SaveManager then
	SaveManager:SetLibrary(Library)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetFolder("QJScriptConfig")
	SaveManager:BuildConfigSection(Tabs.Settings)
end
