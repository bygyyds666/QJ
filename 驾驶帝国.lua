local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

function createUI()
    local Window = WindUI:CreateWindow({
        Title = 'QJ脚本-驾驶帝国',
        Icon = "crown",
        IconThemed = true,
        Author = "作者：琼玖",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(375, 278),
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
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
                    Text = "",
                    Style = "Subtle", 
                    Size = UDim2.new(1, -20, 0, 30),
                    Callback = function()
                    end
                }
            }
        }
    })

    local windowOpen = true

    local LocalPlayer = game:GetService("Players").LocalPlayer
    local AutoFarm = false
    local AutoFarmRunning = false
    local _G = {
        Rewards = false,
        antiAFK = false
    }
    local LastNotif = 0
    local TouchTheRoad = false

    local function GetCurrentVehicle()
        return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.SeatPart and LocalPlayer.Character.Humanoid.SeatPart.Parent
    end

    local function TP(cframe)
        local vehicle = GetCurrentVehicle()
        if vehicle then
            vehicle:SetPrimaryPartCFrame(cframe)
        end
    end

    local function VelocityTP(cframe)
        local TeleportSpeed = math.random(600, 600)
        local Car = GetCurrentVehicle()
        if Car then
            local BodyGyro = Instance.new("BodyGyro", Car.PrimaryPart)
            BodyGyro.P = 5000
            BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            BodyGyro.CFrame = Car.PrimaryPart.CFrame
            local BodyVelocity = Instance.new("BodyVelocity", Car.PrimaryPart)
            BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            BodyVelocity.Velocity = CFrame.new(Car.PrimaryPart.Position, cframe.p).LookVector * TeleportSpeed
            wait((Car.PrimaryPart.Position - cframe.p).Magnitude / TeleportSpeed)
            BodyVelocity.Velocity = Vector3.new()
            wait(0.1)
            BodyVelocity:Destroy()
            BodyGyro:Destroy()
        end
    end

    local StartPosition = CFrame.new(Vector3.new(-34567.375, 34.895652770996094, -32846.046875), Vector3.new())
    local EndPosition = CFrame.new(Vector3.new(-31448.3515625, 34.925010681152344, -26616.25), Vector3.new())
    
    local AutoFarmFunc = coroutine.create(function()
        while wait() do
            if not AutoFarm then
                AutoFarmRunning = false
                coroutine.yield()
            end
            AutoFarmRunning = true
            pcall(function()
                if not GetCurrentVehicle() and tick() - (LastNotif or 0) > 5 then
                    LastNotif = tick()
                    WindUI:Notify({
                        Title = "自动刷钱",
                        Content = "请先进入车辆！",
                        Duration = 3,
                        Icon = "4483362458"
                    })
                else
                    TP(StartPosition + (TouchTheRoad and Vector3.new(0,-5,0) or Vector3.new(0, -5, 0)))
                    VelocityTP(EndPosition + (TouchTheRoad and Vector3.new(0,-5,0) or Vector3.new(0, -5, 0)))
                    TP(EndPosition + (TouchTheRoad and Vector3.new(0,-5,0) or Vector3.new(0, -5, 0)))
                    VelocityTP(StartPosition + (TouchTheRoad and Vector3.new(0,-5,0) or Vector3.new(0, -5, 0)))
                end
            end)
        end
    end)

    local function AutoRewards()
        while _G.Rewards do
            wait()
            for i = 1, 7 do
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PlayRewards"):FireServer(i)
            end
        end
    end

    local function AntiAFK()
        while _G.antiAFK do
            wait(20)
            game:GetService("VirtualUser"):Button1Down(Vector2.new(788, 547))
        end
    end

    local AutoTab = Window:Tab({Title = "自动功能", Icon = "zap"})
    
    local AutoFarmSection = AutoTab:Section({Title = "自动刷钱", Icon = "dollar-sign", Opened = true})
    
    AutoFarmSection:Toggle({
        Title = "自动刷钱",
        Value = AutoFarm,
        Callback = function(Value)
            AutoFarm = Value
            if Value and not AutoFarmRunning then
                coroutine.resume(AutoFarmFunc)
                WindUI:Notify({
                    Title = "自动刷钱",
                    Content = "已开启自动刷钱",
                    Duration = 3,
                    Icon = "4483362458"
                })
            elseif not Value then
                WindUI:Notify({
                    Title = "自动刷钱",
                    Content = "已关闭自动刷钱",
                    Duration = 3,
                    Icon = "4483362458"
                })
            end
        end
    })

    AutoFarmSection:Toggle({
        Title = "触地模式",
        Value = TouchTheRoad,
        Callback = function(Value)
            TouchTheRoad = Value
            WindUI:Notify({
                Title = "刷钱设置",
                Content = Value and "已开启接触路面模式" or "已关闭接触路面模式",
                Duration = 3,
                Icon = "4483362458"
            })
        end
    })

    local AutoFeaturesSection = AutoTab:Section({Title = "自动功能", Icon = "settings", Opened = true})
    
    AutoFeaturesSection:Toggle({
        Title = "自动签到",
        Value = _G.Rewards,
        Callback = function(Value)
            _G.Rewards = Value
            if Value then
                coroutine.wrap(AutoRewards)()
                WindUI:Notify({
                    Title = "自动签到",
                    Content = "已开启自动签到",
                    Duration = 3,
                    Icon = "4483362458"
                })
            else
                WindUI:Notify({
                    Title = "自动签到",
                    Content = "已关闭自动签到",
                    Duration = 3,
                    Icon = "4483362458"
                })
            end
        end
    })

    AutoFeaturesSection:Toggle({
        Title = "反挂机",
        Value = _G.antiAFK,
        Callback = function(Value)
            _G.antiAFK = Value
            if Value then
                coroutine.wrap(AntiAFK)()
                WindUI:Notify({
                    Title = "反挂机",
                    Content = "已开启防掉线功能",
                    Duration = 3,
                    Icon = "4483362458"
                })
            else
                WindUI:Notify({
                    Title = "反挂机",
                    Content = "已关闭防掉线功能",
                    Duration = 3,
                    Icon = "4483362458"
                })
            end
        end
    })

    local identifiedexec = ""
    if identifyexecutor then
        identifiedexec = select(1, identifyexecutor())
    end

    WindUI:Notify({
        Title = "QJ脚本",
        Content = "以为您启用驾驶帝国脚本" .. identifiedexec,
        Duration = 5,
        Icon = "4483362458"
    })

    Window:OnClose(function()
        windowOpen = false
    end)

    Window:OnDestroy(function()
        windowOpen = false
    end)
end

createUI()