local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ-破坏者谜团2",
    Author = "作者：琼玖",
    Folder = "QJ-破坏者谜团2"
})

local Lighting = game:GetService("Lighting")
local TweenServiceBlur = game:GetService("TweenService")

local blur = Lighting:FindFirstChildOfClass("BlurEffect")
if not blur then
    blur = Instance.new("BlurEffect")
    blur.Size = 200
    blur.Parent = Lighting
end

task.spawn(function()
    local wasOpen = false
    while true do
        task.wait(0.1)
        local mainFrame = Window.UIElements and Window.UIElements.Main
        local isOpen = mainFrame and mainFrame.Visible or false
        if isOpen ~= wasOpen then
            wasOpen = isOpen
            TweenServiceBlur:Create(blur, TweenInfo.new(0.3), {
                Size = isOpen and 20 or 0
            }):Play()
        end
    end
end)

local Linni = {
    Esp = Window:Tab({ 
        Title = "[ 透视 ]", 
        Icon = "eye" 
    }),
    Mr = Window:Tab({ 
        Title = "[ 警察 ]", 
        Icon = "user" 
    }),
    Killer = Window:Tab({ 
        Title = "[ ez杀人犯 ]", 
        Icon = "user" 
    }),
    Auto = Window:Tab({ 
        Title = "[ 自动 ]", 
        Icon = "baby" 
    }),
}

Window:SelectTab(1)

local playerESP = false
local coinTaffy = false
local TaffyShoot = false
local TaffyshootTChina = 2.8
local TaffyPing = 1
local TaffygunESP = false
local TaffyDete = false
local TaffyGetGun = false
local TaffyMooKnife = false
local TaffyAu = false
local TaffyAuChina = nil
local playerData = {}
local claimedCoins = {}
local antifail = false
local trapESP = Instance.new("Highlight")
trapESP.Name = "TrapESP"
trapESP.FillColor = Color3.fromRGB(255, 112, 10)
trapESP.OutlineColor = Color3.fromRGB(255, 112, 10)
trapESP.FillTransparency = 0.5
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local Linnitask = nil
local LinniTime = false

local function findMurderer()
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Backpack:FindFirstChild("Knife") then
            return i
        end
    end
    for _, i in ipairs(Players:GetPlayers()) do
        if not i.Character then continue end
        if i.Character:FindFirstChild("Knife") then
            return i
        end
    end
    if playerData then
        for player, data in playerData do
            if data.Role == "Murderer" then
                if Players:FindFirstChild(player) then
                    return Players:FindFirstChild(player)
                end
            end
        end
    end
    return nil
end

local function findSheriff()
    for _, i in ipairs(Players:GetPlayers()) do
        if i.Backpack:FindFirstChild("Gun") then
            return i
        end
    end
    for _, i in ipairs(Players:GetPlayers()) do
        if not i.Character then continue end
        if i.Character:FindFirstChild("Gun") then
            return i
        end
    end
    if playerData then
        for player, data in playerData do
            if data.Role == "Sheriff" then
                if Players:FindFirstChild(player) then
                    return Players:FindFirstChild(player)
                end
            end
        end
    end
    return nil
end

local function findSheriffThatsNotMe()
    for _, i in ipairs(Players:GetPlayers()) do
        if i == localPlayer then continue end
        if i.Backpack:FindFirstChild("Gun") then
            return i
        end
    end
    for _, i in ipairs(Players:GetPlayers()) do
        if i == localPlayer then continue end
        if not i.Character then continue end
        if i.Character:FindFirstChild("Gun") then
            return i
        end
    end
    if playerData then
        for player, data in playerData do
            if data.Role == "Sheriff" then
                if Players:FindFirstChild(player) then
                    if Players:FindFirstChild(player) == localPlayer then continue end
                    return Players:FindFirstChild(player)
                end
            end
        end
    end
    return nil
end

function reloadESP()
    for _, v in ipairs(workspace:GetChildren()) do if v.Name == "PlayerESP" then v:Destroy() end end
    local listplayers = Players:GetChildren()
    for _, player in ipairs(listplayers) do
        if player.Character then
            local character = player.Character
            if not character:FindFirstChild("PlayerESP") then
                local a = Instance.new("Highlight", workspace)
                a.Name = "玩家ESP"
                a.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                a.Adornee = character
                a.FillColor = Color3.fromRGB(255, 255, 255)
                a.FillTransparency = 0.5
                task.spawn(function()
                    if player == findMurderer() then
                        a.FillColor = Color3.fromRGB(255,0,0)
                        a.OutlineColor = Color3.fromRGB(255,0,0)
                    elseif player == findSheriff() then
                        a.FillColor = Color3.fromRGB(0, 150, 255)
                        a.OutlineColor = Color3.fromRGB(0, 150, 255)
                    else
                        a.FillColor = Color3.fromRGB(0,255,0)
                        a.OutlineColor = Color3.fromRGB(0, 255, 0)
                    end
                end)
            end
        end
    end
end

local function getMap()
    for _, o in ipairs(workspace:GetChildren()) do
        if o:FindFirstChild("CoinContainer") and o:FindFirstChild("Spawns") then
            return o
        end
    end
    return nil
end

local function getClosestModelToPlayer(player, models)
    local closestModel = nil
    local closestDistance = math.huge 
    local playerPosition = player.Character.HumanoidRootPart.Position
    for _, model in ipairs(models) do
        local modelPosition = model:GetPivot().Position
        local distance = (modelPosition - playerPosition).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestModel = model
        end
    end
    return closestModel
end

local function getPredictedPosition(player, TaffyshootTChina)
    pcall(function()
        player = player.Character
        if not player.Character then return Vector3.new(0,0,0) end
    end)
    local playerHRP = player:FindFirstChild("UpperTorso")
    local playerHum = player:FindFirstChild("Humanoid")
    if not playerHRP or not playerHum then
        return Vector3.new(0,0,0)
    end
    local velocity = playerHRP.AssemblyLinearVelocity
    local playerMoveDirection = playerHum.MoveDirection
    local predictedPosition = playerHRP.Position + ((velocity * Vector3.new(0, 0.5, 0))) * (TaffyshootTChina / 15) + playerMoveDirection * TaffyshootTChina
    predictedPosition = predictedPosition * (((localPlayer:GetNetworkPing() * 1000) * ((TaffyPing - 1) * 0.01)) + 1)
    return predictedPosition
end

local function findNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge 
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then 
            local localRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            local otherRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if localRootPart and otherRootPart then
                local distance = (localRootPart.Position - otherRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end
    return nearestPlayer
end

local function secondsToMinutes(seconds)
    if seconds == -1 then return "" end
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    return string.format("%dm %ds", minutes, remainingSeconds)
end

Linni.Esp:Toggle({
    Title = "显示当前回合剩余时间[你被淘汰后可开启]",
    Desc = "结束了就是-1m 58ms",
    Value = false,
    Callback = function(state)
        LinniTime = state
        if state then
            Linnitask = task.spawn(function()
                while task.wait(0.5) and LinniTime do
                    local success, timeLeft = pcall(function()
                        return game.ReplicatedStorage.Remotes.Extras.GetTimer:InvokeServer()
                    end)
                    if success and timeLeft then
                        local timeText = secondsToMinutes(timeLeft)
                        WindUI:Notify({
                            Title = "回合剩余时间",
                            Content = timeText,
                            Duration = 1
                        })
                    else
                        WindUI:Notify({
                            Title = "无法获取回合时间",
                            Duration = 1
                        })
                        break
                    end
                end
            end)
        else
            if Linnitask then
                task.cancel(Linnitask)
                Linnitask = nil
            end
        end
    end
})

Linni.Esp:Toggle({
    Title = "玩家ESP[普通玩家和杀手和警长]",
    Desc = "每回合需要重新开一遍因为只检测局内,不是全局（绿色是平民，蓝色是警察，红色是杀手）",
    Value = false,
    Callback = function(state)
        playerESP = state
        if state then
            if not findMurderer() or not findSheriff() then
                repeat task.wait(1) until findSheriff() or findMurderer()
            end
            reloadESP()
        else
            for _, v in ipairs(workspace:GetChildren()) do 
                if v.Name == "PlayerESP" then v:Destroy() end 
            end
        end
    end
})

Linni.Esp:Toggle({
    Title = "掉落枪支ESP",
    Desc = "每回合需要重新开一遍因为只检测局内,不是全局[这个不知道]",
    Value = false,
    Callback = function(state)
        TaffygunESP = state
        if state then
            if getMap() and getMap():FindFirstChild("GunDrop") then
                local gunesp = Instance.new("Highlight", workspace)
                gunesp.OutlineTransparency = 1
                gunesp.FillColor = Color3.fromRGB(255, 255, 0)
                gunesp.Name = "GunESP"
                gunesp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                gunesp.Adornee = getMap():FindFirstChild("GunDrop")
                gunesp.Enabled = true
            end
        else
            if workspace:FindFirstChild("GunESP") then
                workspace:FindFirstChild("GunESP"):Destroy()
            end
        end
    end
})

Linni.Esp:Toggle({
    Title = "陷阱检测",
    Desc = "每回合需要重新开一遍因为只检测局内,不是全局,这个不知道",
    Value = false,
    Callback = function(state)
        TaffyDete = state
        if state then
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "Trap" and v.Parent:IsDescendantOf(workspace) then
                    v.Transparency = 0
                    local trapesp = trapESP:Clone()
                    trapesp.Parent = workspace
                    trapesp.Adornee = v
                end
            end
        else
            for _, v in ipairs(workspace:GetChildren()) do
                if v.Name == "TrapESP" then v:Destroy() end
            end
        end
    end
})


Linni.Mr:Toggle({
    Title = "自动射击",
    Desc = "请到基础栏搭配里面的范围使用",
    Value = false,
    Callback = function(state)
        TaffyShoot = state
    end
})

Linni.Mr:Button({
    Title = "射击杀手",
    Callback = function()
        if findSheriff() ~= localPlayer then 
            WindUI:Notify({
                Title = "你不是警长",
                Duration = 1
            })
            return 
        end
        local murderer = findMurderer() or findSheriffThatsNotMe()
        if not murderer then 
            WindUI:Notify({
                Title = "找不到杀手",
                Duration = 1
            })
            return 
        end
        if not localPlayer.Character:FindFirstChild("Gun") then
            local hum = localPlayer.Character:FindFirstChild("Humanoid")
            if localPlayer.Backpack:FindFirstChild("Gun") then
                hum:EquipTool(localPlayer.Backpack:FindFirstChild("Gun"))
            else
                WindUI:Notify({
                    Title = "你没有枪",
                    Duration = 1
                })
                return
            end
        end
        local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
        if not murdererHRP then 
            WindUI:Notify({
                Title = "找不到杀手的身体部位",
                Duration = 1
            })
            return 
        end
        local predictedPosition = getPredictedPosition(murderer, TaffyshootTChina)
        local args = {[1] = 1, [2] = predictedPosition, [3] = "AH2"}
        localPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
        WindUI:Notify({
            Title = "已射击杀手",
            Duration = 1
        })
    end
})

Linni.Mr:Toggle({
    Title = "防失败[秒完成互动]",
    Desc = "平民和警长通用",
    Value = false,
    Callback = function(state)
        antifail = state
    end
})

local LinniSection = Linni.Mr:Section({
    Title = "[ 自动射击调节参数 ] - 打开方法→",
})
LinniSection:Input({
    Title = "射击偏移量",
    Value = "2.8",
    Placeholder = "推荐2.8",
    Callback = function(input)
        if not tonumber(input) then return end
        TaffyshootTChina = tonumber(input)
    end
})
LinniSection:Input({
    Title = "偏移量到ping乘数",
    Value = "1",
    Placeholder = "默认1",
    Callback = function(input)
        if not tonumber(input) then return end
        TaffyPing = tonumber(input)
    end
})

Linni.Killer:Toggle({
    Title = "杀戮光环",
    Value = false,
    Callback = function(state)
        TaffyAu = state
        if state then
            if TaffyAuChina then TaffyAuChina:Disconnect() end
            TaffyAuChina = RunService.Heartbeat:Connect(function()
                if findMurderer() ~= localPlayer then return end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localPlayer then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if (hrp.Position - localPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < 7 then
                            hrp.Anchored = true
                            hrp.CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 2
                            task.wait(0.1)
                            local args = {[1] = "Slash"}
                            if localPlayer.Character:FindFirstChild("Knife") then
                                localPlayer.Character.Knife.Stab:FireServer(unpack(args))
                            elseif localPlayer.Backpack:FindFirstChild("Knife") then
                                localPlayer.Character.Humanoid:EquipTool(localPlayer.Backpack:FindFirstChild("Knife"))
                                task.wait(0.2)
                                localPlayer.Character.Knife.Stab:FireServer(unpack(args))
                            end
                            return
                        end
                    end
                end
            end)
        else
            if TaffyAuChina then 
                TaffyAuChina:Disconnect() 
            end
        end
    end
})

Linni.Killer:Button({
    Title = "杀死最近玩家",
    Callback = function()
        if findMurderer() ~= localPlayer then 
            WindUI:Notify({
                Title = "你不是杀手",
                Duration = 1
            })
            return 
        end
        if not localPlayer.Character:FindFirstChild("Knife") then
            local hum = localPlayer.Character:FindFirstChild("Humanoid")
            if localPlayer.Backpack:FindFirstChild("Knife") then
                localPlayer.Character:FindFirstChild("Humanoid"):EquipTool(localPlayer.Backpack:FindFirstChild("Knife"))
            else
                WindUI:Notify({
                    Title = "你没有刀",
                    Duration = 1
                })
                return
            end
        end
        local nearestPlayer = findNearestPlayer()
        if not nearestPlayer or not nearestPlayer.Character then
            WindUI:Notify({
                Title = "找不到玩家",
                Duration = 1
            })
            return
        end
        local nearestHRP = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not nearestHRP then
            WindUI:Notify({
                Title = "找不到玩家的身体部位",
                Duration = 1
            })
            return
        end
        if not localPlayer.Character:FindFirstChild("HumanoidRootPart") then 
            WindUI:Notify({
                Title = "你的角色无效",
                Duration = 1
            })
            return 
        end
        if not TaffyMooKnife then
            nearestHRP.Anchored = true
            nearestHRP.CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 2
            task.wait(0.1)
            local args = {[1] = "Slash"}
            localPlayer.Character.Knife.Stab:FireServer(unpack(args))
        else
            local lpknife = localPlayer.Character:FindFirstChild("Knife")
            if not lpknife then return end
            local toThrow = nearestHRP.Position
            local args = {
                [1] = lpknife:GetPivot(), 
                [2] = toThrow
            }
            localPlayer.Character.Knife.Throw:FireServer(unpack(args))
        end
        WindUI:Notify({
            Title = "已杀死最近玩家",
            Duration = 1
        })
    end
})

Linni.Killer:Button({
    Title = "杀死所有人",
    Callback = function()
        if findMurderer() ~= localPlayer then 
            WindUI:Notify({
                Title = "你不是杀手",
                Duration = 1
            })
            return 
        end
        if not localPlayer.Character:FindFirstChild("Knife") then
            local hum = localPlayer.Character:FindFirstChild("Humanoid")
            if localPlayer.Backpack:FindFirstChild("Knife") then
                localPlayer.Character:FindFirstChild("Humanoid"):EquipTool(localPlayer.Backpack:FindFirstChild("Knife"))
            else
                WindUI:Notify({
                    Title = "你没有刀",
                    Duration = 1
                })
                return
            end
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localPlayer then
                player.Character:FindFirstChild("HumanoidRootPart").Anchored = true
                player.Character:FindFirstChild("HumanoidRootPart").CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 1 
            end
        end
        local args = {[1] = "Slash"}
        localPlayer.Character.Knife.Stab:FireServer(unpack(args))
        WindUI:Notify({
            Title = "已尝试杀死所有人",
            Duration = 1
        })
    end
})

Linni.Killer:Button({
    Title = "把所有人都扣为人质",
    Callback = function()
        if findMurderer() ~= localPlayer then 
            WindUI:Notify({
                Title = "你不是杀手",
                Duration = 1
            })
            return 
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localPlayer then
                player.Character:FindFirstChild("HumanoidRootPart").Anchored = true
                player.Character:FindFirstChild("HumanoidRootPart").CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 5
            end
        end
        WindUI:Notify({
            Title = "已把所有人扣为人质",
            Duration = 1.5
        })
    end
})

Linni.Killer:Toggle({
    Title = "模拟飞刀击杀",
    Desc = "有稳定性,但是实用性较低",
    Value = false,
    Callback = function(state)
        TaffyMooKnife = state
    end
})

Linni.Auto:Toggle({
    Title = "自动拾取金币",
    Value = false,
    Callback = function(state)
        coinTaffy = state
    end
})

Linni.Auto:Toggle({
    Title = "自动拾取枪支",
    Value = false,
    Callback = function(state)
        TaffyGetGun = state
    end
})

workspace.ChildAdded:Connect(function(ch)
    if ch == getMap() and playerESP then
        WindUI:Notify({
            Title = "地图已加载等待分配角色...",
            Duration = 1.5
        })
        repeat
            task.wait(1)
        until findMurderer()
        WindUI:Notify({
            Title = "玩家ESP已移除,请重新开启",
            Duration = 1
        })
    end
end)

workspace.ChildRemoved:Connect(function(ch)
    if ch == getMap() and playerESP then
        WindUI:Notify({
            Title = "游戏结束移除玩家ESP",
            Duration = 1
        })
        playerData = {}
        for _, v in ipairs(workspace:GetChildren()) do if v.Name == "PlayerESP" then v:Destroy() end end
    end
end)

workspace.DescendantAdded:Connect(function(ch)
    if TaffyDete and ch.Name == "Trap" and ch.Parent:IsDescendantOf(workspace) then
        ch.Transparency = 0
        local trapesp = trapESP:Clone()
        trapesp.Parent = workspace
        trapesp.Adornee = ch
        WindUI:Notify({
            Title = "杀手放置了陷阱",
            Duration = 1
        })
    end
    if TaffygunESP and ch.Name == "GunDrop" then
        if not workspace:FindFirstChild("GunESP") then
            local gunesp = Instance.new("Highlight", workspace)
            gunesp.OutlineTransparency = 1
            gunesp.FillColor = Color3.fromRGB(255, 255, 0)
            gunesp.Name = "GunESP"
            gunesp.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            gunesp.Adornee = ch
            gunesp.Enabled = true
        end
        workspace:FindFirstChild("GunESP").Adornee = ch
        workspace:FindFirstChild("GunESP").Enabled = true
        WindUI:Notify({
            Title = "枪已掉落,寻找黄色透视物品",
            Duration = 1.5
        })
        if TaffyGetGun then
            WindUI:Notify({
                Title = "请等待.",
                Duration = 1
            })
            task.wait(0.01)
            if not getMap():FindFirstChild("GunDrop") then 
                WindUI:Notify({
                    Title = "没有可传送到的掉落枪支",
                    Duration = 1
                })
                return 
            end
            local previousPosition = localPlayer.Character:GetPivot()
            localPlayer.Character:MoveTo(getMap():FindFirstChild("GunDrop").Position)
            localPlayer.Backpack.ChildAdded:Wait()
            localPlayer.Character:PivotTo(previousPosition)
        end
    end
end)

workspace.DescendantRemoving:Connect(function(ch)
    if TaffygunESP and ch.Name == "GunDrop" then
        if workspace:FindFirstChild("GunESP") then
            workspace:FindFirstChild("GunESP"):Destroy()
        end
        WindUI:Notify({
            Title = "有人拿走了掉落的枪",
            Duration = 1
        })
        task.wait(0.6)
        local sheriff = findSheriff()
        if sheriff then
            WindUI:Notify({
                Title = "警长是 " .. sheriff.DisplayName,
                Duration = 1.5
            })
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if findSheriff() == localPlayer and TaffyShoot then
            WindUI:Notify({
                Title = "自动射击已开启",
                Duration = 1
            })
            repeat
                task.wait(0.1)
                local murderer = findMurderer()
                if not murderer then continue end
                local murdererPosition = murderer.Character.HumanoidRootPart.Position
                local characterRootPart = localPlayer.Character.HumanoidRootPart
                local rayDirection = murdererPosition - characterRootPart.Position
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams.FilterDescendantsInstances = {localPlayer.Character}
                local hit = workspace:Raycast(characterRootPart.Position, rayDirection, raycastParams)
                if not hit or hit.Instance.Parent == murderer.Character then 
                    WindUI:Notify({
                        Title = "自动射击中……",
                        Duration = 1
                    })
                    if not localPlayer.Character:FindFirstChild("Gun") then
                        local hum = localPlayer.Character:FindFirstChild("Humanoid")
                        if localPlayer.Backpack:FindFirstChild("Gun") then
                            localPlayer.Character:FindFirstChild("Humanoid"):EquipTool(localPlayer.Backpack:FindFirstChild("Gun"))
                        else
                            WindUI:Notify({
                                Title = "你没有枪",
                                Duration = 1
                            })
                            return
                        end
                    end
                    local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
                    if not murdererHRP then
                        WindUI:Notify({
                            Title = "找不到杀手的身体部位",
                            Duration = 1
                        })
                        return
                    end
                    local predictedPosition = getPredictedPosition(murderer, TaffyshootTChina)
                    local args = {[1] = 1, [2] = predictedPosition, [3] = "AH2"}
                    localPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
                end
            until findSheriff() ~= localPlayer or not TaffyShoot
        end
    end
end)

task.spawn(function()
    while task.wait(0.01) do
        if not coinTaffy then continue end
        if getMap() then
            if getMap():FindFirstChild("CoinContainer") and #getMap():FindFirstChild("CoinContainer"):GetChildren() > 1 then
                local closestCoin = getClosestModelToPlayer(localPlayer, getMap():FindFirstChild("CoinContainer"):GetChildren())
                if closestCoin then
                    if not localPlayer.Character:FindFirstChild("HumanoidRootPart") then continue end
                    local distance = (localPlayer.Character:FindFirstChild("HumanoidRootPart").Position - closestCoin:GetPivot().Position).Magnitude
                    local toclosestcoin = TweenService:Create(localPlayer.Character:FindFirstChild("HumanoidRootPart"), TweenInfo.new(distance*0.05, Enum.EasingStyle.Linear), {
                        CFrame = closestCoin:GetPivot()
                    })
                    toclosestcoin:Play()
                    toclosestcoin.Completed:Wait()
                    task.wait(0.01)
                    closestCoin:Destroy()
                    claimedCoins[closestCoin] = true
                end
            end
        end
    end
end)

task.spawn(function() 
    if game:GetService("RunService"):IsStudio() then return end
    local OldNameCall = nil
    OldNameCall = hookmetamethod(game, "__namecall", function(Self, ...)
        local Args = {...}
        local NamecallMethod = getnamecallmethod()
        if antifail and NamecallMethod == "FireServer" and Args[1] == "SetPlayerMinigameResult" then
            Args[2] = true
        end
        return OldNameCall(Self, unpack(Args))
    end)
end)
