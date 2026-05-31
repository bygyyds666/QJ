local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local function createUI()
    local Window = WindUI:CreateWindow({
        Title = "QJ脚本-河北唐县",
        Icon = "crown",
        Author = "作者：琼玖",
        Folder = "WindUI",
        Size = UDim2.fromOffset(600, 400),
        Theme = "Dark",
    })

    local Main = Window:Tab({Title = "刷钱", Icon = "dollar-sign"})
    Main:Toggle({
        Title = "卡车刷钱",
        Callback = function()
            game:GetService("ReplicatedStorage").Feature_RemoteEvent.TeamSwitch:FireServer("Trucker")
            game:GetService("ReplicatedStorage").Packages.Shared.Network.RemoteFunctions.ClientRequestCoalTrucks:InvokeServer()
            game:GetService("ReplicatedStorage").Packages.Shared.Network.RemoteFunctions.ClientRequestCoalJob:InvokeServer(workspace.TruckingJob.Coal.routeA, "2018 FAW J6P Facelift")
            local car
            repeat
                for i, v in ipairs(workspace.SpawnedCars:GetChildren()) do
                    if v.Name == game.Players.LocalPlayer.Name .. "'s Car" then
                        car = v
                        break
                    end
                end
                task.wait()
            until car
            repeat
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = car.DriveSeat.CFrame
                car.DriveSeat:Sit(game.Players.LocalPlayer.Character.Humanoid)
                task.wait()
            until game.Players.LocalPlayer.Character.Humanoid.SeatPart == car.DriveSeat
            car:PivotTo(workspace.TruckingJob.Coal.routeA.Pickup.CFrame * CFrame.Angles(0, -math.pi / 2, 0))
            task.wait(0.7)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
            task.wait(0.7)
            car:PivotTo(workspace.TruckingJob.Coal.routeA.Dropoff.CFrame * CFrame.Angles(0, -math.pi / 2, 0))
            task.wait(0.7)
            game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
            task.wait(1)
            car = nil
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3312.3349609375, 10.28740119934082, 3724.0439453125)
            game:GetService("ReplicatedStorage").Feature_RemoteEvent.TeamSwitch:FireServer("Civilian")
        end
    })

    Main:Toggle({
        Title = "出租车刷钱",
        Callback = function()   
            for _, car in pairs(workspace.SpawnedCars:GetChildren()) do
                if car.Name == game.Players.LocalPlayer.Name .. "'s Car" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = car.DriveSeat.CFrame
                    for _, v in pairs(workspace.TaxiSys.PickupPoints:GetChildren()) do
                        if v.Name == "Point" and v:FindFirstChild("Taxi Fare") and v.Locate.Locate.Enabled then
                            repeat
                                task.wait()
                                car:PivotTo(v.CFrame * CFrame.Angles(0, -math.pi / 2, 0))
                            until not v:FindFirstChild("Taxi Fare")
                            for _, t in pairs(workspace.TaxiSys.DropOffPoints:GetChildren()) do
                                if t.Name == "Point" and t:FindFirstChild("TouchInterest") and t.Locate.Locate.Enabled then
                                    car:PivotTo(t.CFrame * CFrame.Angles(0, -math.pi / 2, 0))
                                end
                            end
                        end
                    end
                end
            end
        end
    })

    Main:Toggle({
        Title = "奶茶店刷钱",
        Callback = function()    
            spawn(function()
                game:GetService("ReplicatedStorage").TeamSwitch:FireServer("Teawen Barista")
                while true do 
                    task.wait()
                    pcall(function()
                        workspace.BaristaJob.Scripted.Prompts.Prompt.ProximityPrompt.MaxActivationDistance = math.huge
                        workspace.BaristaJob.Scripted.Prompts.PromptFill.ProximityPrompt.MaxActivationDistance = math.huge
                        fireproximityprompt(workspace.BaristaJob.Scripted.Prompts.Prompt.ProximityPrompt)
                        fireproximityprompt(workspace.BaristaJob.Scripted.Prompts.PromptFill.ProximityPrompt)
                        for i, v in ipairs(workspace:GetChildren()) do
                            if v.Name:find("Customer") then
                                if v:FindFirstChild("ProximityPrompt") then
                                    v.ProximityPrompt.MaxActivationDistance = math.huge
                                    fireproximityprompt(v.ProximityPrompt)
                                end
                            end
                        end
                    end)
                end
            end)
        end
    })

    Main:Toggle({
        Title = "咖啡店刷钱",
        Callback = function()   
            spawn(function()
                game:GetService("ReplicatedStorage").TeamSwitch:FireServer("Mixue Ice Cream")
                while true do 
                    task.wait()
                    pcall(function()
                        workspace.MixueJob.Scripted.Prompts.Prompt.ProximityPrompt.MaxActivationDistance = math.huge
                        workspace.MixueJob.Scripted.Prompts.PromptFill.ProximityPrompt.MaxActivationDistance = math.huge
                        fireproximityprompt(workspace.MixueJob.Scripted.Prompts.Prompt.ProximityPrompt)
                        fireproximityprompt(workspace.MixueJob.Scripted.Prompts.PromptFill.ProximityPrompt)
                        for i, v in ipairs(workspace:GetChildren()) do
                            if v.Name:find("Customer") then
                                if v:FindFirstChild("ProximityPrompt") then
                                    v.ProximityPrompt.MaxActivationDistance = math.huge
                                    fireproximityprompt(v.ProximityPrompt)
                                end
                            end
                        end
                    end)
                end
            end)
        end
    })

    Main:Toggle({
        Title = "送货司机刷钱",
        Callback = function()   
            spawn(function()
                game:GetService("ReplicatedStorage").TeamSwitch:FireServer("Delivery Driver")
                while true do 
                    task.wait(4)
                    pcall(function()
                        game.Workspace.DeliverySys.Misc["Package Pile"].ClickDetector.MaxActivationDistance = math.huge
                        fireclickdetector(game.Workspace.DeliverySys.Misc["Package Pile"].ClickDetector)
                        for _, v in pairs(game.Workspace.DeliverySys.DeliveryPoints:GetChildren()) do
                            if v.Locate.Locate.Enabled then
                                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                            end
                        end
                    end)
                end
            end)
        end
    })

    local TeleportTab = Window:Tab({Title = "传送", Icon = "map-pin"})

    TeleportTab:Button({
        Title = "传送到警察局",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5513.97412109375, 8.656171798706055, 4964.291015625)
        end
    })

    TeleportTab:Button({
        Title = "传送到出生点",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3338.31982421875, 10.048742294311523, 3741.84033203125)
        end
    })

    TeleportTab:Button({
        Title = "传送到医院",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5471.482421875, 14.149418830871582, 4259.75341796875)
        end
    })

    TeleportTab:Button({
        Title = "传送到手机店",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6789.2041015625, 11.197686195373535, 1762.687255859375)
        end
    })

    TeleportTab:Button({
        Title = "传送到火锅店", 
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5912.84765625, 12.217276573181152, 1058.29443359375)
        end
    })

    TeleportTab:Button({
        Title = "传送到高速公路",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8939.2138671875, 19.621065139770508, 10806.4296875)
        end
    })

    TeleportTab:Button({
        Title = "传送到学校",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13874.6630859375, 9.052695274353027, 11078.302734375)
        end
    })

    TeleportTab:Button({
        Title = "传送到驾校",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9027.240234375, 9.016266822814941, 7441.20361328125)
        end
    })

    TeleportTab:Button({
        Title = "传送到羊杂汤",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6027.08447265625, 10.092833518981934, 3383.9697265625)
        end
    })

    TeleportTab:Button({
        Title = "传送到茶丸趣",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5876.77099609375, 10.152806282043457, 3682.9130859375)
        end
    })

    TeleportTab:Button({
        Title = "传送到隆昌包子铺",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5617.0498046875, 9.716679573059082, 4428.56103515625)
        end
    })

    TeleportTab:Button({
        Title = "传送到杭州包子铺",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5209.8603515625, 9.41347599029541, 5437.134765625)
        end
    })

    TeleportTab:Button({
        Title = "传送到露营地",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1713.2999267578125, 9.000035285949707, 10979.6220703125)
        end
    })

    TeleportTab:Button({
        Title = "传送到庆都山底",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-15595.44140625, 7.148616313934326, 21123.388671875)
        end
    })

    TeleportTab:Button({
        Title = "传送到庆都山楼梯底",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-15332.2744140625, 23.315601348876953, 21708.1875)
        end
    })

    TeleportTab:Button({
        Title = "传送到庆都山顶",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-15012.6015625, 324.337646484375, 22416.99609375)
        end
    })

    TeleportTab:Button({
        Title = "传送到签挂烧烤",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-10323.802734375, 9.488192558288574, 7104.04541015625)
        end
    })

    TeleportTab:Button({
        Title = "传送到麦当劳",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5224.9404296875, 9.716679573059082, 870.1453247070312)
        end
    })

    TeleportTab:Button({
        Title = "传送到一泽超市",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2981.219970703125, 21.576412200927734, -408.3921813964844)
        end
    })

    TeleportTab:Button({
        Title = "传送到东北烧烤",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3187.288818359375, 20.524887084960938, -533.3848876953125)
        end
    })

    TeleportTab:Button({
        Title = "传送到洗车人家",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2579.1591796875, 21.46174430847168, -574.2310791015625)
        end
    })

    TeleportTab:Button({
        Title = "传送到小区房1",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1795.0374755859375, 111.88740539550781, -201.18545532226562)
        end
    })

    TeleportTab:Button({
        Title = "传送到小区房1楼底",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1792.570068359375, 22.256141662597656, -155.13458251953125)
        end
    })

    TeleportTab:Button({
        Title = "传送到小区房2",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1234.2042236328125, 330.422607421875, -625.770263671875)
        end
    })

    TeleportTab:Button({
        Title = "传送到小区房2楼底",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1236.7598876953125, 22.07207489013672, -579.0657958984375)
        end
    })

    TeleportTab:Button({
        Title = "前往购买车辆",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-3302.613525390625, 11.646864891052246, 3797.56689453125)
        end
    })
end

createUI()