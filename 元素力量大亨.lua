local setting = {
    autobuild = false,
    autocollect = false,
    autocollectcrate = false,
    autocollectdollar = false,
    autocollectchest = false
}

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-元素力量大亨",
    Icon = "palette",
    Author = "作者：琼玖",
    Folder = "Premium",
    Size = UDim2.fromOffset(550, 320),
    User = {
        Enabled = true,
        Anonymous = true,
        Callback = function() end
    },
    SideBarWidth = 200,
    HideSearchBar = false,
})

local MainTab = Window:Tab({Title = "主要功能", Icon = "settings"})
local MainSection = MainTab:Section({Title = "主要功能", Opened = true})

local function tryRemoteOrBlink(part, actionType, proximityPrompt)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if actionType == "Click" then
        local click = part:FindFirstChildWhichIsA("ClickDetector")
        if click then
            fireclickdetector(click)
            return
        end
    elseif actionType == "Touch" then
        firetouchinterest(part, root, 0)
        firetouchinterest(part, root, 1)
        return
    elseif actionType == "Proximity" and proximityPrompt then
        fireproximityprompt(proximityPrompt)
        return
    end

    local oldPos = root.CFrame
    root.CFrame = part.CFrame
    task.wait(0.05)
    root.CFrame = oldPos
end

MainSection:Toggle({
    Title = "自动建造",
    Default = false,
    Callback = function(state)
        setting.autobuild = state
        if state then
            task.spawn(function()
                while setting.autobuild and task.wait() do
                    for _, v in next, workspace.Tycoons:GetChildren() do
                        if v.Name == game.Players.LocalPlayer.Name then
                            for _, a in next, v.Buttons:GetChildren() do
                                if a.Button.Color == Color3.fromRGB(0, 127, 0) then
                                    tryRemoteOrBlink(a.Button, "Click")
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

MainSection:Toggle({
    Title = "自动收集钱",
    Default = false,
    Callback = function(state)
        setting.autocollect = state
        if state then
            task.spawn(function()
                while setting.autocollect and task.wait(5) do
                    for _, v in next, workspace.Tycoons:GetChildren() do
                        if v.Name == game.Players.LocalPlayer.Name then
                            local collectPart = v.Auxiliary.Collector.Collect
                            if collectPart then
                                tryRemoteOrBlink(collectPart, "Touch")
                            end
                        end
                    end
                end
            end)
        end
    end
})

MainSection:Toggle({
    Title = "自动收集钱箱",
    Default = false,
    Callback = function(state)
        setting.autocollectcrate = state
        if state then
            task.spawn(function()
                while setting.autocollectcrate and task.wait() do
                    for _, v in next, workspace:GetChildren() do
                        if v.Name == "BalloonCrate" then
                            local prompt = v.Crate:FindFirstChild("ProximityPrompt")
                            if prompt then
                                tryRemoteOrBlink(v.Crate, "Proximity", prompt)
                            end
                        end
                    end
                end
            end)
        end
    end
})

MainSection:Toggle({
    Title = "自动收集boss掉的钱",
    Default = false,
    Callback = function(state)
        setting.autocollectdollar = state
        if state then
            task.spawn(function()
                while setting.autocollectdollar and task.wait() do
                    for _, v in next, workspace:GetChildren() do
                        if v.Name == "Dollar" then
                            tryRemoteOrBlink(v, "Touch")
                        end
                    end
                end
            end)
        end
    end
})

MainSection:Toggle({
    Title = "自动收集宝箱",
    Default = false,
    Callback = function(state)
        setting.autocollectchest = state
        if state then
            task.spawn(function()
                while setting.autocollectchest and task.wait() do
                    for _, v in pairs(workspace.Treasure.Chests:GetChildren()) do
                        if v.Name == "Chest" then
                            local prompt = v:FindFirstChild("ProximityPrompt")
                            if prompt then
                                tryRemoteOrBlink(v, "Proximity", prompt)
                            end
                        end
                    end
                end
            end)
        end
    end
})

MainSection:Button({
    Title = "传送一次中心",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local oldpos = root.CFrame
        task.wait(0.5)
        root.CFrame = workspace.Map.Center.CFrame
        task.wait(0.3)
        root.CFrame = oldpos
    end
})

local PlayerTab = Window:Tab({Title = "玩家", Icon = "user"})
local PlayerSection = PlayerTab:Section({Title = "玩家设置", Opened = true})

PlayerSection:Slider({
    Title = "修改玩家移动速度",
    Value = { Min = 16, Max = 400, Default = 16 },
    Callback = function(walkSpeed)
        task.spawn(function()
            while task.wait() do
                local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = walkSpeed
                end
            end
        end)
    end
})

local noclipConnection = nil
PlayerSection:Toggle({
    Title = "穿墙",
    Default = false,
    Callback = function(enabled)
        if enabled then
            if noclipConnection then noclipConnection:Disconnect() end
            noclipConnection = game:GetService("RunService").Stepped:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if not char then return end
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
    end
})