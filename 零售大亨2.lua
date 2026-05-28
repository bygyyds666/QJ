local Players = cloneref(game:GetService("Players"))
local LocalPlayer = cloneref(Players.LocalPlayer)
local Character = cloneref(LocalPlayer.Character)
local RootPart = cloneref(Character.HumanoidRootPart)

LocalPlayer.Idled:Connect(
    function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
)

local main = {
    ctsm = "",
    autotrash = false,
    autobox = false,
    autoarrest = false
}

function GetPlot()
    local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlotData"):InvokeServer()
    local plotsum = 1
    if type(Remote) == "table" then
        for key1, value1 in pairs(Remote) do
            local plot = value1
            for key2, value2 in pairs(value1) do
                if key2 == "Owner" then
                    if value2 == LocalPlayer.Name then
                        return "Plot_"..plotsum
                    end
                end
            end
            plotsum += 1
        end
    end
    return nil
end

function GetDock()
    local Remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GetPlotData"):InvokeServer()
    local plotsum = 1
    if type(Remote) == "table" then
        for key1, value1 in pairs(Remote) do
            local plot = value1
            for key2, value2 in pairs(value1) do
                if key2 == "Owner" then
                    if value2 == LocalPlayer.Name then
                        return "LoadingDock_"..plotsum
                    end
                end
            end
            plotsum += 1
        end
    end
    return nil
end

function GetCar()
    return workspace.PlayerVehicles:FindFirstChild("Vehicle_" .. LocalPlayer.Name)
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-零售大亨2",
    Icon = "star",
    IconThemed = true,
    Author = "作者：琼玖",
    Folder = "CloudHub",
    Size = UDim2.fromOffset(300, 270),
    Transparent = true,
    Theme = "Dark",
    User = {
        Enabled = true,
        Callback = function()
            print("clicked")
        end,
        Anonymous = false
    },
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = true
})

Window:SetToggleKey(Enum.KeyCode.F)

Window:EditOpenButton({
    Title = "零售大亨2",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29")),
    Draggable = true
})

local MainSection = Window:Section({
    Title = "功能区",
    Opened = true
})

local Main = MainSection:Tab({ Title = "主要", Icon = "Sword" })

Main:Dropdown({
    Title = "选择清理方式",
    Values = {
        "传送",
        "范围"
    },
    Value = "未选择",
    Callback = function(option)
        main.ctsm = option
    end
})

Main:Toggle({
    Title = "自动清理",
    Default = false,
    Image = "check",
    Callback = function(state)
        main.autotrash = state
        spawn(function()
            while main.autotrash and wait() do
                pcall(function()
                    for _,v in next,workspace.Map.Plots:FindFirstChild(tostring(GetPlot())).Trash:GetChildren() do
                        if main.ctsm == "传送" then
                            RootPart.CFrame = v.PromptPart.CFrame
                            fireproximityprompt(v.PromptPart.ProximityPrompt)
                        elseif main.ctsm == "范围" then
                            fireproximityprompt(v.PromptPart.ProximityPrompt)
                        end
                    end
                end)
            end
        end)
    end
})

Main:Toggle({
    Title = "自动装货",
    Default = false,
    Image = "check",
    Callback = function(state)
        main.autobox = state
        spawn(function()
            while main.autobox and task.wait() do
                pcall(function()
                    local Car = GetCar()
                    local Plot = GetPlot()
                    local Dock = GetDock()
                    
                    if not Car or not Plot or not Dock then 
                        return 
                    end
                    
                    if Character.Humanoid.SeatPart ~= Car.DriveSeat then
                        return
                    end
                    
                    if not workspace.Map.Landmarks["Loading Dock"][Dock].BayStorage:GetChildren()[1] then 
                        return 
                    end
                    
                    Car:PivotTo(workspace.Map.Landmarks["Loading Dock"][Dock].ParkingArea.Floor.CFrame + Vector3.new(20, 0, 10))
                    task.wait(0.4)
                    
                    game:GetService("ReplicatedStorage").Remotes.LoadVehicle:InvokeServer()
                    task.wait(0.6)

                    for _,v in pairs(workspace.Map.Plots[Plot].Walls.Floor_1:GetChildren()) do
                        if v:FindFirstChild("Type") and v.Type.Value == "TruckDoor2" then
                            Car:PivotTo(v.Door_1.Handle.CFrame * CFrame.new(3, 0, 0))
                            task.wait(0.4)
                            game:GetService("ReplicatedStorage").Remotes.UnloadVehicle:InvokeServer()
                            task.wait(0.5)
                        end
                    end
                end)
            end
        end)
    end
})

Main:Toggle({
    Title = "自动抓小偷",
    Default = false,
    Image = "check",
    Callback = function(state)
        main.autoarrest = state
        spawn(function()
            while main.autoarrest and wait() do
                pcall(function()
                    for _,v in next,workspace.NPCModel:GetChildren() do
                        if v:FindFirstChild("ArrestPrompt") then
                            RootPart.Anchored = true
                            RootPart.CFrame = CFrame.new(v:GetPivot().Position)
                            fireproximityprompt(v.ArrestPrompt)
                        else
                            RootPart.Anchored = false
                        end
                    end
                end)
            end
        end)
    end
})

local Teleport = MainSection:Tab({ Title = "传送", Icon = "map-pin" })

Teleport:Button({
    Title = "传送车",
    Callback = function()
        local car = GetCar()
        if not car then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "提示",
                Text = "未找到您的车辆",
                Duration = 3
            })
            return
        end
        RootPart.Anchored = true
        RootPart.CFrame = car.DriveSeat.CFrame
        car.DriveSeat:Sit(Character.Humanoid)
        wait(0.6)
        RootPart.Anchored = false
    end
})

Teleport:Button({
    Title = "传送商店",
    Callback = function()
        for _,v in pairs(workspace.Map.Plots[GetPlot()].Walls.Floor_1:GetChildren()) do
            if v:FindFirstChild("Type") and v.Type.Value == "TruckDoor2" and v:FindFirstChild("Door_1") then
                Character:PivotTo(v.Door_1:FindFirstChild("Handle").CFrame * CFrame.new(3, 0, 0))
            end
        end
    end
})

Teleport:Dropdown({
    Title = "选择传送地点",
    Values = {
        "港口",
        "停机场",
        "车店",
        "灯塔"
    },
    Value = "未选择",
    Callback = function(option)
        if option == "港口" then
            RootPart.CFrame = CFrame.new(1757.7098388671875, -83.50000762939453, -1877.39697265625)
        elseif option == "停机场" then
            RootPart.CFrame = CFrame.new(1781.6561279296875, -83.00000762939453, -1712.373291015625)
        elseif option == "车店" then
             RootPart.CFrame = CFrame.new(1872.4932861328125, 4.999999523162842, -1963.5867919921875)
        elseif option == "灯塔" then
            RootPart.CFrame = CFrame.new(893.9075927734375, 201.49998474121094, -3040.318603515625)
        end
    end
})