local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

function createUI()
    local Window = WindUI:CreateWindow({
        Title = 'QJ脚本',
        Icon = "crown",
        IconThemed = true,
        Author = "作者：琼玖",
        Folder = "CloudHub",
        Size = UDim2.fromOffset(375, 278),
        Transparent = true,
        HideSearchBar = false,
        ScrollBarEnabled = true,
        Resizable = true,
        Background = "https://raw.githubusercontent.com/tnine-n9/TnineHubnb/refs/heads/main/1770443104414_edit_300225054024499.png",
        BackgroundImageTransparency = 0.45,
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

    Window:EditOpenButton({
        Title = "汽车经销大亨",
        Icon = "crown",
        CornerRadius = UDim.new(0,16),
        StrokeThickness = 4,
        Color = ColorSequence.new(Color3.fromHex("FF6B6B")),
        Draggable = true,
    })
    Window:Tag({
        Title = "汽车经销商大亨",
        Color = Color3.fromHex("#FFA500") 
    })
    spawn(function()
        while true do
            for hue = 0, 1, 0.01 do  
                local color = Color3.fromHSV(hue, 0.8, 1)  
                Window:EditOpenButton({
                    Color = ColorSequence.new(color)
                })
                wait(0.04)  
            end
        end
    end)

    local windowOpen = true

    Window:OnClose(function()
        windowOpen = false
    end)

    local LockSection = Window:Section({
        Title = "功能以及UI设置",
        Icon = "crown",
        Opened = true,
    })

    local Auto = false
    local season = false
    local oval = false
    local gokart = false
    local circuit = false
    local police = false
    local city = false
    local highway = false
    local mountain = false
    local Sponge = false

    local AutoTab = Window:Tab({Title = "自动功能", Icon = "zap"})
    local RaceTab = Window:Tab({Title = "比赛功能", Icon = "flag"})

    AutoTab:Section({Title = "自动功能", Opened = true})

    AutoTab:Toggle({
        Title = "自动刷钱（需要坐在车子上）",
        Value = false,
        Callback = function(Value)
            Auto = Value
            if Value then
                task.spawn(function()
                    local part = Instance.new("Part")
                    part.Position = Vector3.new(0,60,0)
                    part.Size = Vector3.new(1000,5,1000)
                    part.Anchored = true
                    part.Name = "Keaths Platform"
                    part.CollisionGroupId = 5
                    part.Parent = workspace

                    local part2 = Instance.new("Part")
                    part2.Position = Vector3.new(0,10,0)
                    part2.Size = Vector3.new(1000,5,1000)
                    part2.Anchored = true
                    part2.Name = "Keaths Platform"
                    part2.CollisionGroupId = 5
                    part2.Parent = workspace

                    local part3 = Instance.new("Part")
                    part3.Position = Vector3.new(0,99,0)
                    part3.Size = Vector3.new(1000,5,1000)
                    part3.Anchored = true
                    part3.Name = "Keaths Platform"
                    part3.CollisionGroupId = 5
                    part3.Parent = workspace

                    while Auto and task.wait() do
                        local chr = game.Players.LocalPlayer.Character
                        if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                            local car = chr.Humanoid.SeatPart.Parent.Parent
                            car:PivotTo(CFrame.new(0,0,0))
                            wait(0.81)
                            car:PivotTo(part.CFrame)
                            wait(1)
                            car:PivotTo(part2.CFrame)
                            wait(1)
                            car:PivotTo(part3.CFrame)
                        else
                            wait(1)
                        end
                    end
                    
                    if part then part:Destroy() end
                    if part2 then part2:Destroy() end
                    if part3 then part3:Destroy() end
                end)
            end
        end
    })

    AutoTab:Toggle({
        Title = "自动建造",
        Value = false,
        Callback = function(Value)
            local buyer = Value
            if Value then
                task.spawn(function()
                    while buyer and task.wait() do
                        local function plot()
                            local tycoon = nil
                            for i,v in pairs(workspace.Tycoons:GetDescendants()) do
                                if v.Name == "Owner" and v.ClassName == "StringValue" and v.Value == game.Players.LocalPlayer.Name then
                                    tycoon = v.Parent
                                end
                            end
                            return tycoon
                        end
                        local plotResult = plot()
                        if plotResult then
                            for i,v in pairs(plotResult.Dealership.Purchases:GetChildren()) do 
                                if buyer == true and v.TycoonButton.Button.Transparency == 0 then
                                    game:GetService("ReplicatedStorage").Remotes.Build:FireServer("BuyItem", v.Name)
                                    wait(0.3)
                                end 
                            end
                        end
                    end
                end)
            end
        end
    })

    RaceTab:Section({Title = "自动比赛", Opened = true})

    RaceTab:Toggle({
        Title = "自动完成赛季11比赛",
        Value = false,
        Callback = function(Value)
            season = Value
            if Value then
                task.spawn(function()
                    while season and task.wait() do
                        for i, v in pairs(game:GetService("Workspace").Races.Season.Checkpoints:GetDescendants()) do
                            if not season then break end
                            if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "20" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                end
                            elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "20" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                    car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                                end
                            end
                            task.wait(0.2)
                        end
                    end
                end)
            end
        end
    })

    RaceTab:Toggle({
        Title = "自动完成圆形赛",
        Value = false,
        Callback = function(Value)
            oval = Value
            if Value then
                task.spawn(function()
                    while oval and task.wait() do
                        for i, v in pairs(game:GetService("Workspace").Races.Race.Oval.Checkpoints:GetDescendants()) do
                            if not oval then break end
                            if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "4" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                end
                            elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "4" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                    car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                                end
                            end
                            task.wait(0.2)
                        end
                    end
                end)
            end
        end
    })

    RaceTab:Toggle({
        Title = "自动完成卡丁车赛",
        Value = false,
        Callback = function(Value)
            gokart = Value
            if Value then
                task.spawn(function()
                    while gokart and task.wait() do
                        for i, v in pairs(game:GetService("Workspace").Races.Race.Gokart.Checkpoints:GetDescendants()) do
                            if not gokart then break end
                            if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "9" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                end
                            elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "9" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                    car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                                end
                            end
                            task.wait(0.2)
                        end
                    end
                end)
            end
        end
    })

    RaceTab:Toggle({
        Title = "自动完成转圈赛",
        Value = false,
        Callback = function(Value)
            circuit = Value
            if Value then
                task.spawn(function()
                    while circuit and task.wait() do
                        for i, v in pairs(game:GetService("Workspace").Races.Race.Circuit.Checkpoints:GetDescendants()) do
                            if not circuit then break end
                            if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "13" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                end
                            elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "13" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                    car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                                end
                            end
                            task.wait(0.2)
                        end
                    end
                end)
            end
        end
    })

    RaceTab:Toggle({
        Title = "自动完成漂移赛",
        Value = false,
        Callback = function(Value)
            _G.racetest3 = Value
            if Value then
                task.spawn(function()
                    local partvelo = nil
                    while _G.racetest3 and task.wait() do
                        if game:GetService("Players").LocalPlayer.PlayerGui.Menu.Race.Visible == false then
                            local chr = game.Players.LocalPlayer.Character
                            if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                local car = chr.Humanoid.SeatPart.Parent.Parent
                                car:PivotTo(CFrame.new(-2502.25146484375, 601.9251708984375, 2013.3966064453125))
                                car.Engine.Velocity = Vector3.new(0,0,0)
                                chr.Head.Anchored = true
                                wait(1)
                                chr.Head.Anchored = false
                                wait(1)
                                workspace.Races.RaceHandler.StartLobby:FireServer("Drift")
                                partvelo = nil
                                repeat wait()
                                    if game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(-2502.25146484375, 601.9251708984375, 2013.3966064453125)) > 10 then
                                        car:PivotTo(CFrame.new(-2502.25146484375, 601.9251708984375, 2013.3966064453125))
                                        car.Engine.Velocity = Vector3.new(0,0,0)
                                        wait(0.1)
                                        workspace.Races.RaceHandler.StartLobby:FireServer("Drift")
                                    end
                                until game:GetService("Players").LocalPlayer.PlayerGui.Menu.Race.Visible == true or _G.racetest3 == false
                            end
                        elseif game:GetService("Players").LocalPlayer.PlayerGui.Menu.Race.Visible == true then
                            if partvelo == nil then
                                local distance = math.huge
                                for a,b in pairs(workspace.DriftTrack:GetDescendants()) do
                                    if b.Name == "DriftAsphalt" and b.Parent.Name == "Model" then
                                        local Dist = (Vector3.new(-2567.529296875, 601.9335327148438, 2018.6964111328125) - b.Position).magnitude
                                        if Dist < distance then
                                            distance = Dist
                                            partvelo = b
                                        end
                                    end
                                end
                                if partvelo then
                                    partvelo.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*1000
                                end
                            end
                            if partvelo and game.Players.LocalPlayer:DistanceFromCharacter(partvelo.Position) > 10 then
                                local chr = game.Players.LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(partvelo.CFrame)
                                end
                            end
                        end
                    end
                end)
            else
                local distance = math.huge
                local partvelo = nil
                for a,b in pairs(workspace.DriftTrack:GetDescendants()) do
                    if b.Name == "DriftAsphalt" and b.Parent.Name == "Model" then
                        local Dist = (Vector3.new(-2567.529296875, 601.9335327148438, 2018.6964111328125) - b.Position).magnitude
                        if Dist < distance then
                            distance = Dist
                            partvelo = b
                        end
                    end
                end
                if partvelo then
                    partvelo.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.LookVector*0
                end
            end
        end
    })

    RaceTab:Toggle({
        Title = "自动完成警察抓小偷赛",
        Value = false,
        Callback = function(Value)
            police = Value
            if Value then
                task.spawn(function()
                    while police and task.wait() do
                        for i, v in pairs(game:GetService("Workspace").Races.Police.Checkpoints:GetDescendants()) do
                            if not police then break end
                            if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "18" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                end
                            elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "18" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                    car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                                end
                            end
                            task.wait(0.2)
                        end
                    end
                end)
            end
        end
    })

    RaceTab:Toggle({
        Title = "自动完成城市赛",
        Value = false,
        Callback = function(Value)
            city = Value
            if Value then
                task.spawn(function()
                    while city and task.wait() do
                        for i, v in pairs(game:GetService("Workspace").Races.City.City.Checkpoints:GetDescendants()) do
                            if not city then break end
                            if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "17" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                end
                            elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "17" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                    car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                                end
                            end
                            task.wait(0.2)
                        end
                    end
                end)
            end
        end
    })

    RaceTab:Toggle({
        Title = "自动完成公路赛",
        Value = false,
        Callback = function(Value)
            highway = Value
            if Value then
                task.spawn(function()
                    while highway and task.wait() do
                        for i, v in pairs(game:GetService("Workspace").Races.City.Highway.Checkpoints:GetDescendants()) do
                            if not highway then break end
                            if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "23" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                end
                            elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "23" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                    car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                                end
                            end
                            task.wait(0.2)
                        end
                    end
                end)
            end
        end
    })

    RaceTab:Toggle({
        Title = "自动完成山脉赛",
        Value = false,
        Callback = function(Value)
            mountain = Value
            if Value then
                task.spawn(function()
                    while mountain and task.wait() do
                        for i, v in pairs(game:GetService("Workspace").Races.Mountain.Checkpoints:GetDescendants()) do
                            if not mountain then break end
                            if v.Name == "IsActive" and v.Value == true and v.Parent.Name ~= "26" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                end
                            elseif v.Name == "IsActive" and v.Value == true and v.Parent.Name == "26" then
                                local chr = game:GetService("Players").LocalPlayer.Character
                                if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                                    local car = chr.Humanoid.SeatPart.Parent.Parent
                                    car:PivotTo(CFrame.new(v.Parent.Checkpoint.Position))
                                    task.wait(0.2)
                                    car:PivotTo(CFrame.new(v.Parent.Parent.Parent.GoalPart.Position))
                                end
                            end
                            task.wait(0.2)
                        end
                    end
                end)
            end
        end
    })

    RaceTab:Toggle({
        Title = "自动完成海绵赛",
        Value = false,
        Callback = function(Value)
            Sponge = Value
            if Value then
                task.spawn(function()
                    while Sponge and task.wait() do
                        local chr = game.Players.LocalPlayer.Character
                        if chr and chr.Humanoid and chr.Humanoid.SeatPart and chr.Humanoid.SeatPart.Parent and chr.Humanoid.SeatPart.Parent.Parent then
                            local car = chr.Humanoid.SeatPart.Parent.Parent
                            car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["1"].Checkpoint.CFrame)
                            wait(1)
                            car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["2"].Checkpoint.CFrame)
                            wait(0.1)
                            car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["3"].Checkpoint.CFrame)
                            wait(1)
                            car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["4"].Checkpoint.CFrame)
                            wait(0.1)
                            car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["5"].Checkpoint.CFrame)
                            wait(1)
                            car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["6"].Checkpoint.CFrame)
                            wait(0.1)
                            car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["7"].Checkpoint.CFrame)
                            wait(1)
                            car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["8"].Checkpoint.CFrame)
                            car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["9"].Checkpoint.CFrame)
                            wait(1)
                            car:PivotTo(workspace.Races.SpongeBobRace.Checkpoints["10"].Checkpoint.CFrame)
                            wait(0.2)
                            car:PivotTo(CFrame.new(0,0,0))
                        end
                    end
                end)
            end
        end
    })

    Window:OnClose(function()
        windowOpen = false
    end)

    Window:OnDestroy(function()
        windowOpen = false
    end)
end

createUI()