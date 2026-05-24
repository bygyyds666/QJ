local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local waypoints = {
	Vector3.new(-114.54881286621094, 7.968204498291016, 1049.6021728515625),
	Vector3.new(-3.837383985519409, 7.931760787963867, 1042.989990234375),
	Vector3.new(4.038109302520752, 8.993133544921875, 1226.7816162109375),
	Vector3.new(6.72198486328125, 12.67268180847168, 1500.245849609375),
	Vector3.new(28.514896392822266, 11.729066848754883, 1945.3001708984375),
	Vector3.new(-97.97563934326172, 18.798179626464844, 2323.0380859375),
	Vector3.new(20.86248207092285, 16.952991485595703, 2619.30810546875),
	Vector3.new(-16.623472213745117, 16.27338218688965, 3038.156494140625),
	Vector3.new(-35.602264404296875, 27.634624481201172, 3491.589599609375),
	Vector3.new(-35.319332122802734, 20.555072784423828, 3792.111083984375),
	Vector3.new(-47.46642303466797, 18.08696174621582, 4089.8544921875),
	Vector3.new(-53.01953887939453, 26.75748062133789, 4553.01806640625),
	Vector3.new(-38.17786407470703, 15.570384979248047, 4698.1728515625),
	Vector3.new(-55.184120178222656, 23.583555221557617, 5358.11767578125),
	Vector3.new(-61.88101577758789, 16.22578239440918, 5779.4990234375),
	Vector3.new(-36.109657287597656, 26.709096908569336, 6183.17724609375),
	Vector3.new(-25.909088134765625, 30.26568603515625, 6427.0546875),
	Vector3.new(-26.288393020629883, 33.115570068359375, 6659.748046875),
	Vector3.new(-49.44340515136719, 48.75349807739258, 7283.0224609375),
	Vector3.new(-39.171321868896484, 39.140296936035156, 7455.63623046875),
	Vector3.new(-34.16259765625, 32.640625, 7856.50244140625),
	Vector3.new(-57.62692642211914, 13.71396255493164, 8641.234375),
	Vector3.new(-55.635440826416016, -360.307861328125, 9485.810546875),
}

local isRunning = false
local SLOW_FALL_SPEED = -2

local function startTeleportLoop()
	if isRunning then return end
	isRunning = true

	task.spawn(function()
		while isRunning do
			local char = player.Character
			if not char then break end
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then break end

			for _, pos in ipairs(waypoints) do
				if not isRunning then break end

				char = player.Character
				if not char then break end
				hrp = char:FindFirstChild("HumanoidRootPart")
				if not hrp then break end

				hrp.CFrame = CFrame.new(pos)

				local bodyVel = Instance.new("BodyVelocity")
				bodyVel.Velocity = Vector3.new(0, SLOW_FALL_SPEED, 0)
				bodyVel.MaxForce = Vector3.new(0, 1e6, 0)
				bodyVel.P = 1e5
				bodyVel.Parent = hrp

				task.wait(0.5)

				bodyVel:Destroy()
				task.wait()
			end

			if isRunning then
				task.wait(17)
			end
		end

		isRunning = false
	end)
end

local function stopTeleport()
	isRunning = false
end

local antiAFKEnabled = false
local antiAFKThread = nil

local function startAntiAFK()
	if antiAFKEnabled then return end
	antiAFKEnabled = true

	local Players = game:GetService("Players")
	local UIS = game:GetService("UserInputService")
	local lp = Players.LocalPlayer

	local afkInterval = 30

	local function DoAFK()
		local char = lp.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		local root = char:FindFirstChild("HumanoidRootPart")
		if not root or not hum or hum.Health <= 0 then return end

		workspace.CurrentCamera.CFrame *= CFrame.Angles(math.rad(0.15), math.rad(0.15), 0)
		root:CFrameMove(Vector3.new(0.03, 0, 0))
		task.wait(0.05)
		root:CFrameMove(Vector3.new(-0.03, 0, 0))

		UIS:FireKey(Enum.KeyCode.W, true)
		task.wait(0.03)
		UIS:FireKey(Enum.KeyCode.W, false)
	end

	antiAFKThread = task.spawn(function()
		while antiAFKEnabled do
			task.wait(afkInterval)
			if not antiAFKEnabled then break end
			DoAFK()
		end
	end)
end

local function stopAntiAFK()
	antiAFKEnabled = false
	if antiAFKThread then
		task.cancel(antiAFKThread)
		antiAFKThread = nil
	end
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local PlayerConfig = {
	playernamedied = "",
	dropdown = {},
	LoopTeleport = false,
}

function shuaxinlb(includeSelf)
	PlayerConfig.dropdown = {}
	if includeSelf then
		for _, plr in pairs(game.Players:GetPlayers()) do
			table.insert(PlayerConfig.dropdown, plr.Name)
		end
	else
		local localPlayer = game.Players.LocalPlayer
		for _, plr in pairs(game.Players:GetPlayers()) do
			if plr ~= localPlayer then
				table.insert(PlayerConfig.dropdown, plr.Name)
			end
		end
	end
end

shuaxinlb(true)

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
    Title = "造船寻宝",
    Icon = "sword",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    Draggable = true
})

local Tabs = {
    Main = Window:Section({ Title = "通用", Opened = true }),
}

local TabHandles = {
    Common = Tabs.Main:Tab({ Title = "通用", Icon = "user" }),
    Q = Tabs.Main:Tab({ Title = "自动刷金条", Icon = "cctv" }),
}

-- ===== 通用选项卡内容 =====
TabHandles.Common:Section({ Title = "传送玩家", Icon = "users" })

local playerDropdown = TabHandles.Common:Dropdown({
    Title = "选择玩家名称",
    Multi = false,
    AllowNone = true,
    Values = PlayerConfig.dropdown,
    Callback = function(plr)
        PlayerConfig.playernamedied = plr
    end
})

TabHandles.Common:Button({
    Title = "刷新玩家列表",
    Callback = function()
        shuaxinlb(true)
        playerDropdown:Refresh(PlayerConfig.dropdown)
        WindUI:Notify({ Title = "成功", Content = "玩家列表已刷新", Duration = 3 })
    end
})

TabHandles.Common:Section({ Title = "传送功能", Icon = "navigation" })

TabHandles.Common:Button({
    Title = "传送到玩家旁边",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            WindUI:Notify({ Title = "错误", Content = "本地角色未加载", Duration = 5 })
            return
        end
        local localRootPart = localPlayer.Character.HumanoidRootPart
        local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            localRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            WindUI:Notify({ Title = "成功", Content = "已传送到玩家身边", Duration = 5 })
        else
            WindUI:Notify({ Title = "错误", Content = "无法传送: 玩家已消失", Duration = 5 })
        end
    end
})

TabHandles.Common:Toggle({
    Title = "循环锁定传送",
    Default = false,
    Callback = function(enabled)
        PlayerConfig.LoopTeleport = enabled
        if enabled then
            WindUI:Notify({ Title = "成功", Content = "已开启循环传送", Duration = 5 })
            task.spawn(function()
                while PlayerConfig.LoopTeleport do
                    local localPlayer = game.Players.LocalPlayer
                    if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        task.wait(0.5)
                        continue
                    end
                    local localRootPart = localPlayer.Character.HumanoidRootPart
                    local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        localRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                    end
                    task.wait()
                end
            end)
        else
            WindUI:Notify({ Title = "成功", Content = "已关闭循环传送", Duration = 5 })
        end
    end
})

TabHandles.Common:Button({
    Title = "把玩家传送过来",
    Callback = function()
        local localPlayer = game.Players.LocalPlayer
        if not localPlayer.Character or not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            WindUI:Notify({ Title = "错误", Content = "本地角色未加载", Duration = 5 })
            return
        end
        local localRootPart = localPlayer.Character.HumanoidRootPart
        local targetPlayer = game.Players:FindFirstChild(PlayerConfig.playernamedied)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.CFrame = localRootPart.CFrame * CFrame.new(0, 3, 0)
            WindUI:Notify({ Title = "成功", Content = "已将玩家传送过来", Duration = 5 })
        else
            WindUI:Notify({ Title = "错误", Content = "无法传送: 玩家已消失", Duration = 5 })
        end
    end
})

TabHandles.Common:Section({ Title = "玩家", Icon = "move" })

TabHandles.Common:Slider({
    Title = "设置速度",
    Value = { Min = 16, Max = 400, Default = 16 },
    Callback = function(walkSpeed)
        task.spawn(function()
            while task.wait() do
                local localPlayer = game.Players.LocalPlayer
                local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = walkSpeed
                end
            end
        end)
    end
})

TabHandles.Common:Slider({
    Title = "设置跳跃高度",
    Value = { Min = 50, Max = 400, Default = 50 },
    Callback = function(jumpPower)
        task.spawn(function()
            while task.wait() do
                local localPlayer = game.Players.LocalPlayer
                local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = jumpPower
                end
            end
        end)
    end
})

TabHandles.Common:Toggle({
    Title = "无限跳",
    Default = false,
    Callback = function(enabled)
        getgenv().InfJ = enabled
        WindUI:Notify({ Title = "成功", Content = "无限跳" .. (enabled and "已开启" or "已关闭"), Duration = 3 })
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfJ then
        local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

TabHandles.Common:Section({ Title = "飞行", Icon = "rocket" })

TabHandles.Common:Button({
    Title = "开启/关闭飞行",
    Callback = function()
        local function startFlyScript()
            local main = Instance.new("ScreenGui")
            local Frame = Instance.new("Frame")
            local up = Instance.new("TextButton")
            local down = Instance.new("TextButton")
            local onof = Instance.new("TextButton")
            local TextLabel = Instance.new("TextLabel")
            local plus = Instance.new("TextButton")
            local speed = Instance.new("TextLabel")
            local mine = Instance.new("TextButton")
            local closebutton = Instance.new("TextButton")
            local mini = Instance.new("TextButton")
            local mini2 = Instance.new("TextButton")

            main.Name = "main"
            main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            main.ResetOnSpawn = false

            Frame.Parent = main
            Frame.BackgroundColor3 = Color3.fromRGB(163, 255, 137)
            Frame.BorderColor3 = Color3.fromRGB(103, 221, 213)
            Frame.Position = UDim2.new(0.100320168, 0, 0.379746825, 0)
            Frame.Size = UDim2.new(0, 190, 0, 57)

            up.Name = "up"
            up.Parent = Frame
            up.BackgroundColor3 = Color3.fromRGB(79, 255, 152)
            up.Size = UDim2.new(0, 44, 0, 28)
            up.Font = Enum.Font.SourceSans
            up.Text = "up"
            up.TextColor3 = Color3.fromRGB(0, 0, 0)
            up.TextSize = 14.000

            down.Name = "down"
            down.Parent = Frame
            down.BackgroundColor3 = Color3.fromRGB(215, 255, 121)
            down.Position = UDim2.new(0, 0, 0.491228074, 0)
            down.Size = UDim2.new(0, 44, 0, 28)
            down.Font = Enum.Font.SourceSans
            down.Text = "down"
            down.TextColor3 = Color3.fromRGB(0, 0, 0)
            down.TextSize = 14.000

            onof.Name = "onof"
            onof.Parent = Frame
            onof.BackgroundColor3 = Color3.fromRGB(255, 249, 74)
            onof.Position = UDim2.new(0.702823281, 0, 0.491228074, 0)
            onof.Size = UDim2.new(0, 56, 0, 28)
            onof.Font = Enum.Font.SourceSans
            onof.Text = "fly"
            onof.TextColor3 = Color3.fromRGB(0, 0, 0)
            onof.TextSize = 14.000

            TextLabel.Parent = Frame
            TextLabel.BackgroundColor3 = Color3.fromRGB(242, 60, 255)
            TextLabel.Position = UDim2.new(0.469327301, 0, 0, 0)
            TextLabel.Size = UDim2.new(0, 100, 0, 28)
            TextLabel.Font = Enum.Font.SourceSans
            TextLabel.Text = "Fly GUI V3"
            TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            TextLabel.TextScaled = true
            TextLabel.TextSize = 14.000
            TextLabel.TextWrapped = true

            plus.Name = "plus"
            plus.Parent = Frame
            plus.BackgroundColor3 = Color3.fromRGB(133, 145, 255)
            plus.Position = UDim2.new(0.231578946, 0, 0, 0)
            plus.Size = UDim2.new(0, 45, 0, 28)
            plus.Font = Enum.Font.SourceSans
            plus.Text = "+"
            plus.TextColor3 = Color3.fromRGB(0, 0, 0)
            plus.TextScaled = true
            plus.TextSize = 14.000
            plus.TextWrapped = true

            speed.Name = "speed"
            speed.Parent = Frame
            speed.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
            speed.Position = UDim2.new(0.468421042, 0, 0.491228074, 0)
            speed.Size = UDim2.new(0, 44, 0, 28)
            speed.Font = Enum.Font.SourceSans
            speed.Text = "1"
            speed.TextColor3 = Color3.fromRGB(0, 0, 0)
            speed.TextScaled = true
            speed.TextSize = 14.000
            speed.TextWrapped = true

            mine.Name = "mine"
            mine.Parent = Frame
            mine.BackgroundColor3 = Color3.fromRGB(123, 255, 247)
            mine.Position = UDim2.new(0.231578946, 0, 0.491228074, 0)
            mine.Size = UDim2.new(0, 45, 0, 29)
            mine.Font = Enum.Font.SourceSans
            mine.Text = "-"
            mine.TextColor3 = Color3.fromRGB(0, 0, 0)
            mine.TextScaled = true
            mine.TextSize = 14.000
            mine.TextWrapped = true

            closebutton.Name = "Close"
            closebutton.Parent = main.Frame
            closebutton.BackgroundColor3 = Color3.fromRGB(225, 25, 0)
            closebutton.Font = "SourceSans"
            closebutton.Size = UDim2.new(0, 45, 0, 28)
            closebutton.Text = "X"
            closebutton.TextSize = 30
            closebutton.Position =  UDim2.new(0, 0, -1, 27)

            mini.Name = "minimize"
            mini.Parent = main.Frame
            mini.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
            mini.Font = "SourceSans"
            mini.Size = UDim2.new(0, 45, 0, 28)
            mini.Text = "T"
            mini.TextSize = 30
            mini.Position = UDim2.new(0, 44, -1, 27)

            mini2.Name = "minimize2"
            mini2.Parent = main.Frame
            mini2.BackgroundColor3 = Color3.fromRGB(192, 150, 230)
            mini2.Font = "SourceSans"
            mini2.Size = UDim2.new(0, 45, 0, 28)
            mini2.Text = "T"
            mini2.TextSize = 30
            mini2.Position = UDim2.new(0, 44, -1, 57)
            mini2.Visible = false

            speeds = 1

            local speaker = game:GetService("Players").LocalPlayer

            local chr = game.Players.LocalPlayer.Character
            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

            nowe = false

            game:GetService("StarterGui"):SetCore("SendNotification", { 
                Title = "Fly GUI V3";
                Text = "lnjection succeeded";
                Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
            Duration = 5;

            Frame.Active = true
            Frame.Draggable = true

            onof.MouseButton1Down:connect(function()
                if nowe == true then
                    nowe = false

                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,true)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
                    speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                else 
                    nowe = true

                    for i = 1, speeds do
                        spawn(function()
                            local hb = game:GetService("RunService").Heartbeat	
                            tpwalking = true
                            local chr = game.Players.LocalPlayer.Character
                            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                            while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                                if hum.MoveDirection.Magnitude > 0 then
                                    chr:TranslateBy(hum.MoveDirection)
                                end
                            end
                        end)
                    end
                    game.Players.LocalPlayer.Character.Animate.Disabled = true
                    local Char = game.Players.LocalPlayer.Character
                    local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")

                    for i,v in next, Hum:GetPlayingAnimationTracks() do
                        v:AdjustSpeed(0)
                    end
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics,false)
                    speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
                    speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
                end

                if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
                    local plr = game.Players.LocalPlayer
                    local torso = plr.Character.Torso
                    local flying = true
                    local deb = true
                    local ctrl = {f = 0, b = 0, l = 0, r = 0}
                    local lastctrl = {f = 0, b = 0, l = 0, r = 0}
                    local maxspeed = 50
                    local speed = 0

                    local bg = Instance.new("BodyGyro", torso)
                    bg.P = 9e4
                    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                    bg.cframe = torso.CFrame
                    local bv = Instance.new("BodyVelocity", torso)
                    bv.velocity = Vector3.new(0,0.1,0)
                    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                    if nowe == true then
                        plr.Character.Humanoid.PlatformStand = true
                    end
                    while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                        game:GetService("RunService").RenderStepped:Wait()

                        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                            speed = speed+.5+(speed/maxspeed)
                            if speed > maxspeed then
                                speed = maxspeed
                            end
                        elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                            speed = speed-1
                            if speed < 0 then
                                speed = 0
                            end
                        end
                        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                            bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                        elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                            bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                        else
                            bv.velocity = Vector3.new(0,0,0)
                        end
                        bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
                    end
                    ctrl = {f = 0, b = 0, l = 0, r = 0}
                    lastctrl = {f = 0, b = 0, l = 0, r = 0}
                    speed = 0
                    bg:Destroy()
                    bv:Destroy()
                    plr.Character.Humanoid.PlatformStand = false
                    game.Players.LocalPlayer.Character.Animate.Disabled = false
                    tpwalking = false
                else
                    local plr = game.Players.LocalPlayer
                    local UpperTorso = plr.Character.UpperTorso
                    local flying = true
                    local deb = true
                    local ctrl = {f = 0, b = 0, l = 0, r = 0}
                    local lastctrl = {f = 0, b = 0, l = 0, r = 0}
                    local maxspeed = 50
                    local speed = 0

                    local bg = Instance.new("BodyGyro", UpperTorso)
                    bg.P = 9e4
                    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                    bg.cframe = UpperTorso.CFrame
                    local bv = Instance.new("BodyVelocity", UpperTorso)
                    bv.velocity = Vector3.new(0,0.1,0)
                    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                    if nowe == true then
                        plr.Character.Humanoid.PlatformStand = true
                    end
                    while nowe == true or game:GetService("Players").LocalPlayer.Character.Humanoid.Health == 0 do
                        wait()

                        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                            speed = speed+.5+(speed/maxspeed)
                            if speed > maxspeed then
                                speed = maxspeed
                            end
                        elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                            speed = speed-1
                            if speed < 0 then
                                speed = 0
                            end
                        end
                        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                            bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                        elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                            bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
                        else
                            bv.velocity = Vector3.new(0,0,0)
                        end

                        bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
                    end
                    ctrl = {f = 0, b = 0, l = 0, r = 0}
                    lastctrl = {f = 0, b = 0, l = 0, r = 0}
                    speed = 0
                    bg:Destroy()
                    bv:Destroy()
                    plr.Character.Humanoid.PlatformStand = false
                    game.Players.LocalPlayer.Character.Animate.Disabled = false
                    tpwalking = false
                end
            end)

            local tis

            up.MouseButton1Down:connect(function()
                tis = up.MouseEnter:connect(function()
                    while tis do
                        wait()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,1,0)
                    end
                end)
            end)

            up.MouseLeave:connect(function()
                if tis then
                    tis:Disconnect()
                    tis = nil
                end
            end)

            local dis

            down.MouseButton1Down:connect(function()
                dis = down.MouseEnter:connect(function()
                    while dis do
                        wait()
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0,-1,0)
                    end
                end)
            end)

            down.MouseLeave:connect(function()
                if dis then
                    dis:Disconnect()
                    dis = nil
                end
            end)

            game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
                wait(0.7)
                game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
                game.Players.LocalPlayer.Character.Animate.Disabled = false
            end)

            plus.MouseButton1Down:connect(function()
                speeds = speeds + 1
                speed.Text = speeds
                if nowe == true then
                    tpwalking = false
                    for i = 1, speeds do
                        spawn(function()
                            local hb = game:GetService("RunService").Heartbeat	
                            tpwalking = true
                            local chr = game.Players.LocalPlayer.Character
                            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                            while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                                if hum.MoveDirection.Magnitude > 0 then
                                    chr:TranslateBy(hum.MoveDirection)
                                end
                            end
                        end)
                    end
                end
            end)

            mine.MouseButton1Down:connect(function()
                if speeds == 1 then
                    speed.Text = 'flyno1'
                    wait(1)
                    speed.Text = speeds
                else
                    speeds = speeds - 1
                    speed.Text = speeds
                    if nowe == true then
                        tpwalking = false
                        for i = 1, speeds do
                            spawn(function()
                                local hb = game:GetService("RunService").Heartbeat	
                                tpwalking = true
                                local chr = game.Players.LocalPlayer.Character
                                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                                    if hum.MoveDirection.Magnitude > 0 then
                                        chr:TranslateBy(hum.MoveDirection)
                                    end
                                end
                            end)
                        end
                    end
                end
            end)

            closebutton.MouseButton1Click:Connect(function()
                main:Destroy()
            end)

            mini.MouseButton1Click:Connect(function()
                up.Visible = false
                down.Visible = false
                onof.Visible = false
                plus.Visible = false
                speed.Visible = false
                mine.Visible = false
                mini.Visible = false
                mini2.Visible = true
                main.Frame.BackgroundTransparency = 1
                closebutton.Position =  UDim2.new(0, 0, -1, 57)
            end)

            mini2.MouseButton1Click:Connect(function()
                up.Visible = true
                down.Visible = true
                onof.Visible = true
                plus.Visible = true
                speed.Visible = true
                mine.Visible = true
                mini.Visible = true
                mini2.Visible = false
                main.Frame.BackgroundTransparency = 0 
                closebutton.Position =  UDim2.new(0, 0, -1, 27)
            end)
        end

        -- 防止重复创建多个飞行GUI
        local existing = game.Players.LocalPlayer.PlayerGui:FindFirstChild("main")
        if existing then
            existing:Destroy()
            return
        end
        startFlyScript()
    end
})

-- ===== 传送选项卡内容 =====
TabHandles.Q:Toggle({
    Title = "自动刷金条",
    Default = false,
    Callback = function(state)
        if state then
            startTeleportLoop()
        else
            stopTeleport()
        end
    end
})

TabHandles.Q:Toggle({
    Title = "防挂机",
    Default = false,
    Callback = function(state)
        if state then
            startAntiAFK()
        else
            stopAntiAFK()
        end
    end
})