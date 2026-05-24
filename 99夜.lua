local HttpService = game:GetService("HttpService")
local Plr = game:GetService("Players")
local LP = Plr.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local ClientModule
local success, result = pcall(function()
    return require(LP:WaitForChild("PlayerScripts"):WaitForChild("Client"))
end)
if success then
    ClientModule = result
end

local EatRemote = ClientModule and ClientModule.Events and ClientModule.Events.RequestConsumeItem
getgenv().WS = (LP.Character and LP.Character.Humanoid and LP.Character.Humanoid.WalkSpeed) or 16

local AlienX = {
    ["杀戮光环"] = false,
    ["自动砍树"] = false,
    ["自动进食"] = false,
    ["透视孩子"] = false,
    ["透视宝箱"] = false,
}

local BL = {}
local connection = nil

local executor = pcall(identifyexecutor) and identifyexecutor() or "未知"

local function AddESP(part, txt1, txt2, enabled)
    if not part or not part.Parent then return end
    local bg = part:FindFirstChild("BillboardGui")
    if not bg then
        bg = Instance.new("BillboardGui")
        bg.Adornee = part
        bg.Parent = part
        bg.Size = UDim2.new(0, 100, 0, 100)
        bg.StudsOffset = Vector3.new(0, 3, 0)
        bg.AlwaysOnTop = true
        bg.Enabled = enabled

        local TL = Instance.new("TextLabel", bg)
        TL.Name = "TextLabel"
        TL.Text = txt1 .. "\n" .. txt2 .. "m"
        TL.Size = UDim2.new(1, 0, 0, 40)
        TL.Position = UDim2.new(0, 0, 0, 0)
        TL.BackgroundTransparency = 1
        TL.TextColor3 = Color3.new(1, 1, 1)
        TL.TextStrokeTransparency = 0.3
        TL.Font = Enum.Font.GothamBold
        TL.TextSize = 14

        local Img = Instance.new("ImageLabel", bg)
        Img.Position = UDim2.new(0, 20, 0, 40)
        Img.Size = UDim2.new(0, 60, 0, 60)
        Img.Image = part.Name:match("Chest") and "rbxassetid://18660563116" or ""
        Img.BackgroundTransparency = 1
    else
        local textLabel = bg:FindFirstChild("TextLabel")
        if textLabel then
            textLabel.Text = txt1 .. "\n" .. txt2 .. "m"
        end
        bg.Enabled = enabled
    end
end

local function Collect(thing)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == thing then
            local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if part and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                part.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
            end
        end
    end
end

local function tryEatFood(food)
    if not EatRemote then return end
    local tempStorage = ReplicatedStorage:FindFirstChild("TempStorage")
    if not tempStorage then return end
    food.Parent = tempStorage
    local success, result = pcall(function()
        return EatRemote:InvokeServer(food)
    end)
end

local PlayerList = {}
for _, b in pairs(Plr:GetPlayers()) do
    table.insert(PlayerList, b.Name)
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local LocalPlayer = game:GetService("Players").LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local camera = workspace.CurrentCamera
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

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
local uiSize, uiPosition

if deviceType == "手机" then
    uiSize = UDim2.fromOffset(500, 400)
elseif deviceType == "平板" then
    uiSize = UDim2.fromOffset(550, 450)
else
    uiSize = UDim2.fromOffset(600, 500)
end
uiPosition = UDim2.new(0.5, 0, 0.5, 0)

WindUI.TransparencyValue = 0.2
WindUI:SetTheme("Dark")

local Window = WindUI:CreateWindow({
    Title = "QJ脚本",
    Author = "作者：琼玖",
    Folder = "99Night",
    Size = uiSize,
    Position = uiPosition,
    Theme = "Dark",
    Transparent = true,
    User = {
        Enabled = true,
        Anonymous = false,
        Username = LocalPlayer.Name,
        DisplayName = LocalPlayer.DisplayName,
        UserId = LocalPlayer.UserId,
        ThumbnailType = "AvatarBust",
        Callback = function()
            WindUI:Notify({
                Title = "用户信息",
                Content = "玩家:" .. LocalPlayer.Name,
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
        Content = "当前主题: " .. WindUI:GetCurrentTheme(),
        Duration = 2
    })
end, 990)

Window:EditOpenButton({
    Title = "99夜",
    Icon = "rbxassetid://118449824705443",
})

Window:SetToggleKey(Enum.KeyCode.N)

local Tabs = {
    Main = Window:Section({ Title = "主要功能", Opened = true, Icon = "home"}),
    Collect = Window:Section({ Title = "物品收集", Opened = false, Icon = "archive"}),
    ESP = Window:Section({ Title = "透视功能", Opened = false, Icon = "eye"}),
    Teleport = Window:Section({ Title = "传送功能", Opened = false, Icon = "teleporter"}),
    Player = Window:Section({ Title = "玩家设置", Opened = false, Icon = "user"}),
    Announcement = Window:Section({ Title = "公告信息", Opened = false, Icon = "info"}),
}

local TabHandles = {
    MainTab = Tabs.Main:Tab({ Title = "光环功能", Icon = "folder"}),
    CollectTab = Tabs.Collect:Tab({ Title = "收集物品", Icon = "folder"}),
    ESPTab = Tabs.ESP:Tab({ Title = "透视设置", Icon = "folder"}),
    TeleportTab = Tabs.Teleport:Tab({ Title = "传送玩家", Icon = "folder"}),
    PlayerTab = Tabs.Player:Tab({ Title = "玩家属性", Icon = "folder"}),
    AnnouncementTab = Tabs.Announcement:Tab({ Title = "公告", Icon = "folder"}),
}
TabHandles.AnnouncementTab:Paragraph({
    Title = "玩家",
    Desc = "尊敬的用户: " .. LocalPlayer.Name .. " 欢迎使用",
    Image = "user",
    ImageSize = 12
})
TabHandles.AnnouncementTab:Paragraph({
    Title = "设备",
    Desc = "你的使用设备: " .. deviceType,
    Image = "gamepad",
    ImageSize = 12
})
TabHandles.AnnouncementTab:Paragraph({
    Title = "注入器",
    Desc = "你的注入器: " .. executor,
    Image = "syringe",
    ImageSize = 12
})

TabHandles.MainTab:Toggle({
    Title = "杀戮光环",
    Description = "自动攻击附近的敌人",
    Enabled = false,
    Image = "hand-fist",
    ImageSize = 13,
    Callback = function(value)
        AlienX["杀戮光环"] = value
        WindUI:Notify({
            Title = "杀戮光环",
            Content = value and "已开启" or "已关闭",
            Duration = 1
        })
    end
})
TabHandles.MainTab:Toggle({
    Title = "自动砍树",
    Description = "自动砍伐附近的树木",
    Enabled = false,
    Image = "tree",
    ImageSize = 13,
    Callback = function(value)
        AlienX["自动砍树"] = value
        WindUI:Notify({
            Title = "自动砍树",
            Content = value and "已开启" or "已关闭",
            Duration = 1
        })
    end
})
TabHandles.MainTab:Toggle({
    Title = "自动进食",
    Description = "自动吃掉附近的食物",
    Enabled = false,
    Image = "apple-whole",
    ImageSize = 13,
    Callback = function(value)
        AlienX["自动进食"] = value
        WindUI:Notify({
            Title = "自动进食",
            Content = value and "已开启" or "已关闭",
            Duration = 1
        })
    end
})
TabHandles.MainTab:Toggle({
    Title = "瞬间互动",
    Description = "立刻完成互动操作",
    Enabled = false,
    Image = "bolt-lightning",
    ImageSize = 13,
    Callback = function(value)
        if value then
            if not connection then
                connection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                    prompt.HoldDuration = 0
                end)
                WindUI:Notify({ Title = "瞬间互动", Content = "已开启", Duration = 1 })
            end
        else
            if connection then
                connection:Disconnect()
                connection = nil
                WindUI:Notify({ Title = "瞬间互动", Content = "已关闭", Duration = 1 })
            end
        end
    end
})
TabHandles.MainTab:Divider()
TabHandles.MainTab:Button({
    Title = "保存设置",
    Description = "保存当前所有设置",
    Image = "floppy-disk",
    ImageSize = 13,
    Callback = function()
        WindUI:Notify({ Title = "保存设置", Content = "设置已保存", Duration = 2 })
    end
})

local collectItems = {
    {"左轮", "Revolver"}, {"步枪", "Rifle"}, {"左轮子弹", "Revolver Ammo"}, {"步枪子弹", "Rifle Ammo"},
    {"皮革", "Leather Body"}, {"铁甲", "Iron Body"}, {"荆棘铠甲", "Thorn Body"}, {"螺栓", "Bolt"},
    {"金属薄板", "Sheet Metal"}, {"旧收音机", "Old Radio"}, {"损坏的电扇", "Broken Fan"},
    {"损坏的微波炉", "Broken Microwave"}, {"木头", "Log"}, {"椅子", "Chair"}, {"燃料罐", "Fuel Canister"},
    {"油桶", "Oil Barrel"}, {"生物燃料", "Biofuel"}, {"煤", "Coal"}, {"萝卜", "Carrot"}, {"浆果", "Berry"},
    {"生食", "Morsel"}, {"生牛肉", "Steak"}, {"熟食", "Cooked Morsel"}, {"熟牛肉", "Cooked Steak"},
    {"急救包", "MedKit"}, {"绷带", "Bandage"}
}
for _, item in ipairs(collectItems) do
    TabHandles.CollectTab:Button({
        Title = item[1],
        Description = "传送到你的位置",
        Image = "box-archive",
        ImageSize = 13,
        Callback = function()
            Collect(item[2])
            WindUI:Notify({ Title = "收集物品", Content = item[1] .. " 已传送到你的位置", Duration = 1 })
        end
    })
end

TabHandles.ESPTab:Toggle({
    Title = "透视孩子",
    Description = "显示走失孩子的透视",
    Enabled = false,
    Image = "child",
    ImageSize = 13,
    Callback = function(value)
        AlienX["透视孩子"] = value
        WindUI:Notify({ Title = "透视孩子", Content = value and "已开启" or "已关闭", Duration = 1 })
    end
})
TabHandles.ESPTab:Toggle({
    Title = "透视宝箱",
    Description = "显示宝箱的透视",
    Enabled = false,
    Image = "chest",
    ImageSize = 13,
    Callback = function(value)
        AlienX["透视宝箱"] = value
        WindUI:Notify({ Title = "透视宝箱", Content = value and "已开启" or "已关闭", Duration = 1 })
    end
})
TabHandles.ESPTab:Divider()
TabHandles.ESPTab:Button({
    Title = "清除所有ESP",
    Description = "清除所有透视效果",
    Image = "trash",
    ImageSize = 13,
    Callback = function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BillboardGui") then
                obj:Destroy()
            end
        end
        BL = {}
        WindUI:Notify({ Title = "清除ESP", Content = "已清除所有透视效果", Duration = 1 })
    end
})

local teleportDropdown = TabHandles.TeleportTab:Dropdown({
    Title = "选择玩家",
    Description = "选择要传送的玩家",
    Image = "user",
    ImageSize = 13,
    Options = PlayerList,
    Default = "",
    Callback = function(selected)
        local targetPlayer = Plr:FindFirstChild(selected)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LP.Character then
            LP.Character:PivotTo(targetPlayer.Character.HumanoidRootPart.CFrame)
            WindUI:Notify({ Title = "传送", Content = "已传送到 " .. selected, Duration = 2 })
        end
    end
})

local function refreshPlayerList()
    PlayerList = {}
    for _, player in pairs(Plr:GetPlayers()) do
        table.insert(PlayerList, player.Name)
    end
    teleportDropdown:RefreshOptions(PlayerList)
end

Plr.PlayerAdded:Connect(refreshPlayerList)
Plr.PlayerRemoving:Connect(refreshPlayerList)

TabHandles.TeleportTab:Button({
    Title = "刷新玩家列表",
    Description = "刷新当前在线玩家",
    Image = "rotate",
    ImageSize = 13,
    Callback = function()
        refreshPlayerList()
        WindUI:Notify({ Title = "刷新列表", Content = "玩家列表已刷新", Duration = 1 })
    end
})

TabHandles.PlayerTab:Input({
    Title = "移动速度",
    Description = "设置移动速度 (0-200)",
    Image = "running",
    ImageSize = 13,
    Default = tostring(getgenv().WS),
    Numeric = true,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            num = math.clamp(num, 0, 200)
            getgenv().WS = num
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = num
            end
            WindUI:Notify({ Title = "移动速度", Content = "已设置为 " .. num, Duration = 1 })
        else
            WindUI:Notify({ Title = "错误", Content = "请输入有效数字", Duration = 1 })
        end
    end
})

LP.CharacterAdded:Connect(function(char)
    task.wait(0.2)
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = getgenv().WS
    end
end)

TabHandles.PlayerTab:Toggle({
    Title = "玩家发光",
    Description = "让你的玩家发光",
    Enabled = false,
    Image = "lightbulb",
    ImageSize = 13,
    Callback = function(value)
        if value then
            if LP.Character and LP.Character:FindFirstChild("Head") and not LP.Character.Head:FindFirstChild("PlayerLight") then
                local light = Instance.new("PointLight", LP.Character.Head)
                light.Name = "PlayerLight"
                light.Range = 9999999
                light.Brightness = 15
                WindUI:Notify({ Title = "玩家发光", Content = "已开启发光效果", Duration = 1 })
            end
        else
            if LP.Character and LP.Character:FindFirstChild("Head") then
                local light = LP.Character.Head:FindFirstChild("PlayerLight")
                if light then light:Destroy() end
                WindUI:Notify({ Title = "玩家发光", Content = "已关闭发光效果", Duration = 1 })
            end
        end
    end
})

TabHandles.PlayerTab:Divider()

TabHandles.PlayerTab:Button({
    Title = "重置属性",
    Description = "重置所有玩家属性到默认值",
    Image = "rotate-left",
    ImageSize = 13,
    Callback = function()
        getgenv().WS = 16
        if LP.Character and LP.Character.Humanoid then
            LP.Character.Humanoid.WalkSpeed = 16
        end
        if LP.Character and LP.Character:FindFirstChild("Head") then
            local light = LP.Character.Head:FindFirstChild("PlayerLight")
            if light then light:Destroy() end
        end
        WindUI:Notify({ Title = "重置属性", Content = "玩家属性已重置", Duration = 2 })
    end
})

local last1, last2, last3 = 0, 0, 0
RunService.Heartbeat:Connect(function()
    local Now = tick()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end

    local humanoid = LP.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = getgenv().WS
    end

    for i = #BL, 1, -1 do
        if not BL[i] or not BL[i].Parent then
            table.remove(BL, i)
        end
    end

    local itemsContainer = workspace:FindFirstChild("Items")
    if itemsContainer then
        for _, b in pairs(itemsContainer:GetChildren()) do
            if b:GetAttribute(tostring(LP.UserId) .. "Opened") then
                table.insert(BL, b)
                local bg = b:FindFirstChild("BillboardGui")
                if bg then bg:Destroy() end
            end
            if b.Name:match("Chest") and b:IsA("Model") and not table.find(BL, b) then
                local mainPart = b:FindFirstChild("Main") or b.PrimaryPart
                if mainPart then
                    local dist = math.floor((LP.Character.HumanoidRootPart.Position - mainPart.Position).Magnitude)
                    AddESP(b, "宝箱", tostring(dist), AlienX["透视宝箱"])
                end
            end
        end
    end

    local charactersContainer = workspace:FindFirstChild("Characters")
    if charactersContainer then
        for _, b in pairs(charactersContainer:GetChildren()) do
            if b:GetAttribute("Lost") == false then
                table.insert(BL, b)
                local bg = b:FindFirstChild("BillboardGui")
                if bg then bg:Destroy() end
            end
            local lostNames = {"Lost Child", "Lost Child1", "Lost Child2", "Lost Child3", "Dino Kid", "kraken kid", "Squid kid", "Koala Kid", "koala Kid", "koala"}
            if table.find(lostNames, b.Name) and b:FindFirstChild("HumanoidRootPart") and not table.find(BL, b) then
                local dist = math.floor((LP.Character.HumanoidRootPart.Position - b.HumanoidRootPart.Position).Magnitude)
                AddESP(b, "孩子", tostring(dist), AlienX["透视孩子"])
            end
        end
    end

    local toolHandle = LP.Character:FindFirstChild("ToolHandle")
    if toolHandle then
        local tool = toolHandle:FindFirstChild("OriginalItem") and toolHandle.OriginalItem.Value
        if tool then
            if AlienX["杀戮光环"] and Now - last1 >= 0.7 then
                last1 = Now
                local validWeapons = {["Old Axe"]=true, ["Good Axe"]=true, ["Spear"]=true, ["Hatchet"]=true, ["Bone Club"]=true}
                if validWeapons[tool.Name] then
                    if charactersContainer then
                        for _, b in pairs(charactersContainer:GetChildren()) do
                            if b:IsA("Model") and b:FindFirstChild("HumanoidRootPart") and b:FindFirstChild("HitRegisters") then
                                if (LP.Character.HumanoidRootPart.Position - b.HumanoidRootPart.Position).Magnitude <= 100 then
                                    local remote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                                    if remote then
                                        local damageEvent = remote:FindFirstChild("ToolDamageObject")
                                        if damageEvent then
                                            damageEvent:InvokeServer(b, tool, true, LP.Character.HumanoidRootPart.CFrame)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if AlienX["自动砍树"] and Now - last2 >= 0.7 then
                last2 = Now
                local validAxes = {["Old Axe"]=true, ["Stone Axe"]=true, ["Iron Axe"]=true}
                if validAxes[tool.Name] then
                    local function ChopTree(container)
                        if not container then return end
                        for _, b in pairs(container:GetChildren()) do
                            task.wait(0.05)
                            local treeNames = {["Small Tree"]=true, ["TreeBig1"]=true, ["TreeBig2"]=true, ["TreeBig3"]=true}
                            if b:IsA("Model") and treeNames[b.Name] and b:FindFirstChild("HitRegisters") then
                                local trunk = b:FindFirstChild("Trunk") or b:FindFirstChild("HumanoidRootPart") or b.PrimaryPart
                                if trunk and LP.Character and LP.Character.HumanoidRootPart then
                                    if (LP.Character.HumanoidRootPart.Position - trunk.Position).Magnitude <= 100 then
                                        local remote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                                        if remote then
                                            local damageEvent = remote:FindFirstChild("ToolDamageObject")
                                            if damageEvent then
                                                damageEvent:InvokeServer(b, tool, true, LP.Character.HumanoidRootPart.CFrame)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    local map = workspace:FindFirstChild("Map")
                    if map then
                        ChopTree(map:FindFirstChild("Foliage"))
                        ChopTree(map:FindFirstChild("Landmarks"))
                    end
                end
            end
        end
    end

    if AlienX["自动进食"] and Now - last3 >= 10 then
        last3 = Now
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp and itemsContainer then
            local foodTable = {
                Carrot = true, Berry = true, Morsel = false, ["Cooked Morsel"] = true,
                Steak = false, ["Cooked Steak"] = true
            }
            for _, obj in pairs(itemsContainer:GetChildren()) do
                if obj:IsA("Model") and foodTable[obj.Name] then
                    local mainPart = obj:FindFirstChild("Handle") or obj.PrimaryPart
                    if mainPart and (mainPart.Position - hrp.Position).Magnitude < 25 then
                        tryEatFood(obj)
                        break
                    end
                end
            end
        end
    end
end)