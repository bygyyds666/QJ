local HttpService = cloneref(game:GetService("HttpService"))

local isfunctionhooked = clonefunction
if not isfunctionhooked(game.HttpGet) or not isfunctionhooked(getnamecallmethod) or not isfunctionhooked(request) then
    return
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local lp = game:GetService("Players").LocalPlayer
local Character = lp.Character
local hrp = Character and Character:FindFirstChild("HumanoidRootPart")

local function getDeviceType()
    local UserInputService = game:GetService("UserInputService")
    if UserInputService.TouchEnabled then
        if UserInputService.KeyboardEnabled then
            return "平板"
        else
            return "手机"
        end
    else
        return "电脑"
    end
end

local deviceType = getDeviceType()
local uiSize

if deviceType == "手机" then
    uiSize = UDim2.fromOffset(500, 400)
elseif deviceType == "平板" then
    uiSize = UDim2.fromOffset(550, 450)
else
    uiSize = UDim2.fromOffset(600, 500)
end
local uiPosition = UDim2.new(0.5, 0, 0.5, 0)

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local displayName = game.Players.LocalPlayer.DisplayName

WindUI:Notify({
    Title = "QJ",
    Content = "自然灾害加载完成",
    Duration = 2
})

local Window = WindUI:CreateWindow({
    Title = "QJ脚本",
    Author = "作者：琼玖",
    Folder = "OrangeCHub",
    Size = uiSize,
    Position = uiPosition,
    Theme = "Dark",
    Transparent = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Username = game.Players.LocalPlayer.Name,
        DisplayName = displayName,
        UserId = game.Players.LocalPlayer.UserId,
        ThumbnailType = "AvatarBust",
        Callback = function()
            WindUI:Notify({
                Title = "用户信息",
                Content = "玩家:" .. game.Players.LocalPlayer.Name,
                Duration = 3
            })
        end
    },
    SideBarWidth = deviceType == "手机" and 150 or 180,
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

Window:EditOpenButton({
    Title = "打开-自然灾害",
    Icon = "",
})

local Tabs = {
    Pl = Window:Section({ Title = "玩家", Opened = false, Icon = "user"}),
    ZN = Window:Section({ Title = "灾难", Opened = false, Icon = "package-open"}),
    Auto = Window:Section({ Title = "自动", Opened = false, Icon = "pocket-knife"})
}

local TabHandles = {
    Announcement = Tabs.Pl:Tab({ Title = "公告", Icon = "folder"}),
    Player = Tabs.Pl:Tab({ Title = "玩家", Icon = "folder"}),
    ZN1 = Tabs.ZN:Tab({ Title = "预测灾难", Icon = "folder"}),
}

TabHandles.Announcement:Paragraph({
    Title = "欢迎尊贵的用户",
    Desc = "感谢您购买此脚本 我们后续会不断更新",
    Image = "info",
    ImageSize = 15
})

TabHandles.Announcement:Paragraph({
    Title = "玩家",
    Desc = "尊敬的用户: " .. game.Players.LocalPlayer.Name .. "欢迎使用",
    Image = "user",
    ImageSize = 12
})

TabHandles.Announcement:Paragraph({
    Title = "设备",
    Desc = "你的使用设备: " .. deviceType,
    Image = "gamepad",
    ImageSize = 12
})

TabHandles.Announcement:Paragraph({
    Title = "设备",
    Desc = "你的注入器: " .. identifyexecutor(),
    Image = "syringe",
    ImageSize = 12
})

TabHandles.Player:Slider({
    Title = "玩家速度",
    Desc = "玩家的速度",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
})

TabHandles.Player:Slider({
    Title = "玩家跳跃高度",
    Desc = "玩家的跳跃高度",
    Step = 1,
    Value = {
        Min = 50,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.JumpHeight = value
        end
    end
})

TabHandles.Player:Button({
    Title = "飞行",
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

            local speeds = 1  -- 修复变量作用域

            local speaker = game:GetService("Players").LocalPlayer

            local chr = game.Players.LocalPlayer.Character
            local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")

            local nowe = false

            game:GetService("StarterGui"):SetCore("SendNotification", { 
                Title = "Fly GUI V3";
                Text = "lnjection succeeded";
                Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})

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
                            local tpwalking = true
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
                    -- tpwalking 是局部变量，外层无法访问，这里忽略
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
                    -- 重置 tpwalking 逻辑
                    -- 但由于 tpwalking 是局部变量，这里通过重新生成协程实现
                    for i = 1, speeds do
                        spawn(function()
                            local hb = game:GetService("RunService").Heartbeat	
                            local tpwalking = true
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
                        for i = 1, speeds do
                            spawn(function()
                                local hb = game:GetService("RunService").Heartbeat	
                                local tpwalking = true
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

TabHandles.Player:Slider({
    Title = "玩家镜头FOV",
    Desc = "玩家的镜头",
    Step = 1,
    Value = {
        Min = 70,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        local camera = workspace.CurrentCamera
        if camera then
            camera.FieldOfView = value
        end
    end
})

TabHandles.Player:Button({
    Title = "删除摔落伤害",
    Desc = "删除",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("FallDamageScript") then
            char.FallDamageScript:Destroy()
        end
        char.ChildAdded:Connect(function(v)
            if v.Name == "FallDamageScript" then
                v:Destroy()
            end
        end)
    end
})

TabHandles.Player:Toggle({
    Title = "锁定玩家血量",
    Desc = "锁血",
    Value = false,
    Callback = function(state)
        local gm = getrawmetatable(game)
        local old = gm.__newindex
        setreadonly(gm, false)

        if state then
            gm.__newindex = function(t, k, v)
                local char = game.Players.LocalPlayer.Character
                if k == "Health" and t:IsA("Humanoid") and char and t.Parent == char then
                    return old(t, k, 100)
                end
                return old(t, k, v)
            end
        else
            gm.__newindex = old
        end

        setreadonly(gm, true)
    end
})

local DISASTER_NAMES = {
    ["Blizzard"] = "暴风雪",
    ["Sandstorm"] = "沙尘暴",
    ["Tornado"] = "龙卷风",
    ["Volcanic Eruption"] = "火山",
    ["Flash Flood"] = "洪水",
    ["Deadly Virus"] = "病毒",
    ["Tsunami"] = "海啸",
    ["Acid Rain"] = "酸雨",
    ["Fire"] = "火焰",
    ["Meteor Shower"] = "流星雨",
    ["Earthquake"] = "地震",
    ["Thunder Storm"] = "暴风雨",
    ["Avalanche"] = "雪崩",
    ["Lightning"] = "闪电"
}

TabHandles.ZN1:Toggle({
    Title = "预测灾难",
    Desc = "灾难",
    Value = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        if state then
            local function checkTag()
                local char = player.Character
                if char then
                    local tag = char:FindFirstChild("SurvivalTag")
                    if tag then
                        local name = DISASTER_NAMES[tag.Value]
                        if name then
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "灾难",
                                Text = name,
                                Duration = 5
                            })
                        end
                    end
                end
            end
            local conn
            conn = player.CharacterAdded:Connect(function(char)
                checkTag()
                char.ChildAdded:Connect(function(child)
                    if child.Name == "SurvivalTag" then
                        local name = DISASTER_NAMES[child.Value]
                        if name then
                            game:GetService("StarterGui"):SetCore("SendNotification", {
                                Title = "灾难",
                                Text = name,
                                Duration = 5
                            })
                        end
                    end
                end)
            end)
            checkTag()
            _G.PredictionConnection = conn
        else
            if _G.PredictionConnection then
                _G.PredictionConnection:Disconnect()
                _G.PredictionConnection = nil
            end
        end
    end
})