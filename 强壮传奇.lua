local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-强壮传奇",
    Icon = "palette",
    Author = "作者：琼玖",
    Folder = "Premium",
    Size = UDim2.fromOffset(550, 400),
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function()
        end
    },
    SideBarWidth = 200,
    HideSearchBar = false,
})

local MainTab = Window:Tab({Title = "主要功能", Icon = "settings"})
MainTab:Section({Title = "自动功能", Opened = true})

local autoEatEnabled = false
MainTab:Toggle({
    Title = "自动吃",
    Default = false,
    Callback = function(enabled)
        autoEatEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoEatEnabled do
                    local args = {"Food"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UseTool"):FireServer(unpack(args))
                    task.wait(0.1)
                end
            end)
        end
    end
})

local autoSellEnabled = false
MainTab:Toggle({
    Title = "自动卖",
    Default = false,
    Callback = function(enabled)
        autoSellEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoSellEnabled do
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("YieldSell"):InvokeServer()
                    task.wait(0.5)
                end
            end)
        end
    end
})

local autoPunchEnabled = false
MainTab:Toggle({
    Title = "自动打",
    Default = false,
    Callback = function(enabled)
        autoPunchEnabled = enabled
        if enabled then
            task.spawn(function()
                while autoPunchEnabled do
                    local args = {"Punch"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UseTool"):FireServer(unpack(args))
                    task.wait(0.1)
                end
            end)
        end
    end
})

local TeleportTab = Window:Tab({Title = "传送", Icon = "map-pin"})
TeleportTab:Section({Title = "选择传送点", Opened = true})

local teleportPoints = {
    ["蔬菜草地"]   = {697.9, 1663.6, 2048.0},
    ["面包沙漠"]   = {718.7, 3246.2, 2079.9},
    ["冰淇淋冻原"] = {710.9, 5909.4, 2051.8},
    ["披萨荒地"]   = {721.2, 9127.2, 2051.7},
    ["甜甜圈银河"] = {717.1, 12797.0, 2047.9},
    ["水果糖果岛"] = {713.3, 16552.9, 2061.3},
    ["巧克力王国"] = {699.6, 21875.2, 2048.2},
    ["蘑菇绿洲"]   = {722.1, 30255.9, 2046.6},
}

local locationNames = {
    "蔬菜草地",
    "面包沙漠",
    "冰淇淋冻原",
    "披萨荒地",
    "甜甜圈银河",
    "水果糖果岛",
    "巧克力王国",
    "蘑菇绿洲",
}

TeleportTab:Dropdown({
    Title = "传送点",
    Values = locationNames,
    Default = "蔬菜草地",
    Callback = function(selected)
        local coords = teleportPoints[selected]
        if coords then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2], coords[3])
            end
        end
    end
})

TeleportTab:Button({
    Title = "解锁全部岛屿",
    Callback = function()
        task.spawn(function()
            local char = game.Players.LocalPlayer.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then
                return
            end
            for _, name in ipairs(locationNames) do
                local coords = teleportPoints[name]
                char.HumanoidRootPart.CFrame = CFrame.new(coords[1], coords[2], coords[3])
                task.wait(0.5)
            end
        end)
    end
})