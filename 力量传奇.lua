local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()
local Window = WindUI:CreateWindow({
Title = "QJ脚本<font color='#00FF00'>v1</font>",
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
Title = "力量传奇",
Icon = "monitor",
CornerRadius = UDim.new(0,16),
StrokeThickness = 4,
Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromHex("FF0000")),
ColorSequenceKeypoint.new(0.16, Color3.fromHex("FF7F00")),
ColorSequenceKeypoint.new(0.33, Color3.fromHex("FFFF00")),
ColorSequenceKeypoint.new(0.5, Color3.fromHex("00FF00")),
ColorSequenceKeypoint.new(0.66, Color3.fromHex("0000FF")),
ColorSequenceKeypoint.new(0.83, Color3.fromHex("4B0082")),
ColorSequenceKeypoint.new(1, Color3.fromHex("9400D3"))
}),
Draggable = true,
})

Window:Tag({
Title = "QJ付费版",
Color = Color3.fromHex("#30ff6a")
})

Window:Tag({
Title = "QJ付费版",
Color = Color3.fromHex("#315dff")
})

local TimeTag = Window:Tag({
Title = "感谢支持",
Color = Color3.fromHex("#000000")
})

local Tabs = {
Main = Window:Section({ Title = "自动", Opened = true }),
gn = Window:Section({ Title = "功能", Opened = true }),
}

local TabHandles = {
Q = Tabs.Main:Tab({ Title = "自动功能", Icon = "layout-grid" }),
W = Tabs.Main:Tab({ Title = "传送功能", Icon = "layout-grid" }),
M = Tabs.Main:Tab({ Title = "自动业报", Icon = "layout-grid" }),
E = Tabs.Main:Tab({ Title = "自动锻炼", Icon = "layout-grid" }),
T = Tabs.Main:Tab({ Title = "自动重生", Icon = "layout-grid" }),
R = Tabs.Main:Tab({ Title = "自动跑步", Icon = "layout-grid" }),
SquatTab = Tabs.Main:Tab({ Title = "自动蹲起", Icon = "layout-grid" }),
Y = Tabs.Main:Tab({ Title = "引体向上", Icon = "layout-grid" }),
U = Tabs.Main:Tab({ Title = "自动举重", Icon = "layout-grid" }),
I = Tabs.Main:Tab({ Title = "自动投石", Icon = "layout-grid" }),
}

local Interstellar = Interstellar or {}
local AutoStates = {
AutoKillReport3 = false,
AutoKill = false,
AutoKillReportLoops3 = {}
}

local ToggleStates = {
rebirthAuto = false,
sizeAuto = false,
teleportMuscleKing = false,
stone0 = false,
stone10 = false,
stone100 = false,
stone5000 = false,
stone150000 = false,
stone400000 = false,
stone750000 = false,
stone1m = false,
stone5m = false,
stone10m = false,
}

TabHandles.Q:Input({
Title = "修改力量",
Value = "",
Callback = function(FXM)
game:GetService("Players").LocalPlayer.leaderstats.Strength.Value = FXM
end
})

TabHandles.Q:Input({
Title = "修改重生",
Value = "",
Callback = function(FXM)
game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value = FXM
end
})

TabHandles.Q:Input({
Title = "修改击杀",
Value = "",
Callback = function(FXM)
game:GetService("Players").LocalPlayer.leaderstats.Kills.Value = FXM
end
})

TabHandles.Q:Input({
Title = "修改获胜",
Value = "",
Callback = function(FXM)
game:GetService("Players").LocalPlayer.leaderstats.Brawls.Value = FXM
end
})

TabHandles.Q:Divider()

TabHandles.Q:Toggle({
Title = "自动重生",
Callback = function(Value)
ToggleStates.rebirthAuto = Value
if Value then
spawn(function()
while ToggleStates.rebirthAuto do
game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
wait()
end
end)
end
end
})

TabHandles.Q:Toggle({
Title = "自动修改体积为2",
Callback = function(Value)
ToggleStates.sizeAuto = Value
if Value then
spawn(function()
while ToggleStates.sizeAuto do
game:GetService("ReplicatedStorage").rEvents.changeSpeedSizeRemote:InvokeServer("changeSize", 2)
wait()
end
end)
end
end
})

TabHandles.Q:Toggle({
Title = "自动传送肌肉之王",
Callback = function(Value)
ToggleStates.teleportMuscleKing = Value
if Value then
spawn(function()
while ToggleStates.teleportMuscleKing do
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8625.9296875, 13.566278457641602, -5730.4736328125)
wait()
end
end)
end
end
})

TabHandles.Q:Divider()

do
local enabled = false
TabHandles.Q:Toggle({
Title = "0石头",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CFrame = CFrame.new(15.53, 0.76, 2117.85)
end
local punch = plr.Backpack:FindFirstChild("Punch")
if punch and punch:IsA("Tool") and humanoid then
humanoid:EquipTool(punch)
end
end
wait(0.1)
end
end)
else
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:UnequipTools()
end
end
end
end
})
end

do
local enabled = false
TabHandles.Q:Toggle({
Title = "10石头",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CFrame = CFrame.new(-151.39, 2.10, 437.53)
end
local punch = plr.Backpack:FindFirstChild("Punch")
if punch and punch:IsA("Tool") and humanoid then
humanoid:EquipTool(punch)
end
end
wait(0.1)
end
end)
else
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:UnequipTools()
end
end
end
end
})
end

do
local enabled = false
TabHandles.Q:Toggle({
Title = "100石头",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CFrame = CFrame.new(164.47, 1.24, -137.76)
end
local punch = plr.Backpack:FindFirstChild("Punch")
if punch and punch:IsA("Tool") and humanoid then
humanoid:EquipTool(punch)
end
end
wait(0.1)
end
end)
else
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:UnequipTools()
end
end
end
end
})
end

do
local enabled = false
TabHandles.Q:Toggle({
Title = "5000石头",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CFrame = CFrame.new(313.02, 2.06, -559.59)
end
local punch = plr.Backpack:FindFirstChild("Punch")
if punch and punch:IsA("Tool") and humanoid then
humanoid:EquipTool(punch)
end
end
wait(0.1)
end
end)
else
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:UnequipTools()
end
end
end
end
})
end

do
local enabled = false
TabHandles.Q:Toggle({
Title = "150000石头",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CFrame = CFrame.new(-2514.23, 1.07, -256.83)
end
local punch = plr.Backpack:FindFirstChild("Punch")
if punch and punch:IsA("Tool") and humanoid then
humanoid:EquipTool(punch)
end
end
wait(0.1)
end
end)
else
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:UnequipTools()
end
end
end
end
})
end

do
local enabled = false
TabHandles.Q:Toggle({
Title = "400000石头",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CFrame = CFrame.new(2186.48, 8.09, 1290.90)
end
local punch = plr.Backpack:FindFirstChild("Punch")
if punch and punch:IsA("Tool") and humanoid then
humanoid:EquipTool(punch)
end
end
wait(0.1)
end
end)
else
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:UnequipTools()
end
end
end
end
})
end

do
local enabled = false
TabHandles.Q:Toggle({
Title = "750000石头",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CFrame = CFrame.new(-7262.31, 9.66, -1218.25)
end
local punch = plr.Backpack:FindFirstChild("Punch")
if punch and punch:IsA("Tool") and humanoid then
humanoid:EquipTool(punch)
end
end
wait(0.1)
end
end)
else
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:UnequipTools()
end
end
end
end
})
end

do
local enabled = false
TabHandles.Q:Toggle({
Title = "100万石头",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CFrame = CFrame.new(4132.50, 991.64, -4035.54)
end
local punch = plr.Backpack:FindFirstChild("Punch")
if punch and punch:IsA("Tool") and humanoid then
humanoid:EquipTool(punch)
end
end
wait(0.1)
end
end)
else
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:UnequipTools()
end
end
end
end
})
end

do
local enabled = false
TabHandles.Q:Toggle({
Title = "500万石头",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CFrame = CFrame.new(-8985.91, 17.23, -5989.86)
end
local punch = plr.Backpack:FindFirstChild("Punch")
if punch and punch:IsA("Tool") and humanoid then
humanoid:EquipTool(punch)
end
end
wait(0.1)
end
end)
else
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:UnequipTools()
end
end
end
end
})
end

do
local enabled = false
TabHandles.Q:Toggle({
Title = "1000万石头",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
if rootPart then
rootPart.CFrame = CFrame.new(-7639.93, 4.30, 3007.76)
end
local punch = plr.Backpack:FindFirstChild("Punch")
if punch and punch:IsA("Tool") and humanoid then
humanoid:EquipTool(punch)
end
end
wait(0.1)
end
end)
else
local plr = game.Players.LocalPlayer
if plr and plr.Character then
local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid:UnequipTools()
end
end
end
end
})
end

TabHandles.T:Input({
Title = "自定义重生次数",
Desc = "只能输入大于现在的重生次数",
Callback = function(value)
Interstellar.birth = tonumber(value) or 0
end
})

TabHandles.T:Toggle({
Title = "重生到指定的重生次数",
Default = false,
Callback = function(state)
Interstellar.autobirth = state
if Interstellar.autobirth then
spawn(function()
local player = game:GetService("Players").LocalPlayer
local targetRebirths = Interstellar.birth
while Interstellar.autobirth do
if player.leaderstats.Rebirths.Value >= targetRebirths then
Interstellar.autobirth = false
Window:Notify({
Title = "重生",
Content = "已自动重生到目标次数",
Duration = 3
})
break
else
game:GetService("ReplicatedStorage").rEvents.rebirthRemote:InvokeServer("rebirthRequest")
wait()
end
end
end)
end
end
})

TabHandles.T:Divider()

TabHandles.T:Paragraph({
Title = "适合直接打石头卡宠的重生次数",
Desc = "重生:80\n重生:280\n重生:580\n重生:980\n重生:1480\n重生:2080\n重生:2780\n重生:3580\n重生:4480\n重生:5480\n重生:6580\n重生:7780\n重生:9080\n重生:10480\n重生:11980\n重生:13580\n重生:15280\n重生:17080\n重生:18980\n重生:94980\n重生:189980",
ThumbnailSize = 190,
})

TabHandles.W:Button({
Title = "自动宝箱（传送+检测）[重复2次]",
Callback = function()
spawn(function()
local repeatTimes = 2
for cycle = 1, repeatTimes do
WindUI:Notify({
Title = "宝箱流程",
Content = "开始第 " .. cycle .. "/" .. repeatTimes .. " 轮宝箱流程",
Duration = 2
})
local teleportPoints = {
CFrame.new(-138.17, 7.33, -276.85),
CFrame.new(4680.29, 1001.05, -3689.63),
CFrame.new(2213.03, 7.33, 918.64),
CFrame.new(-6713.86, 7.33, -1454.19),
CFrame.new(-2572.08, 7.33, -556.94),
CFrame.new(40.71, 7.33, 410.27),
CFrame.new(-7914.54, 4.30, 3028.47)
}
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")
for _, targetCFrame in ipairs(teleportPoints) do
rootPart.CFrame = targetCFrame
task.wait(5)
end
task.wait(1)
WindUI:Notify({
Title = "宝箱流程",
Content = "本轮传送已完成，准备检测宝箱",
Duration = 2
})
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local chestRewards = ReplicatedStorage:FindFirstChild("chestRewards")
local checkRemote = ReplicatedStorage:FindFirstChild("rEvents"):FindFirstChild("checkChestRemote")
if not chestRewards or not checkRemote then
WindUI:Notify({
Title = "宝箱流程",
Content = "宝箱目录或检测事件不存在，跳过本轮",
Duration = 2
})
task.wait(2)
else
local jk = {}
for _, v in pairs(chestRewards:GetDescendants()) do
if v.Name ~= "Light Karma Chest" and v.Name ~= "Evil Karma Chest" then
table.insert(jk, v.Name)
end
end
for _, chestName in ipairs(jk) do
checkRemote:InvokeServer(chestName)
task.wait(2)
end
WindUI:Notify({
Title = "宝箱流程",
Content = "第 " .. cycle .. "/" .. repeatTimes .. " 轮宝箱检测完成",
Duration = 2
})
end
WindUI:Notify({
Title = "宝箱流程",
Content = "等待3秒后进入下一轮",
Duration = 2
})
task.wait(3)
end
WindUI:Notify({
Title = "宝箱流程",
Content = "所有2轮宝箱流程已执行完毕！",
Duration = 3
})
end)
end
})

TabHandles.W:Divider()

TabHandles.W:Button({
Title = "沙滩",
Callback = function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-42.7, 3.7, 404.2)
end
})

TabHandles.W:Button({
Title = "小岛（0-1000力量）",
Callback = function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-37.636775970458984, 3.86960768699646, 1879.180908203125)
end
})

TabHandles.W:Button({
Title = "冰霜健身房（1重生）",
Callback = function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2623.022216796875, 3.716249465942383, -409.0733337402344)
end
})

TabHandles.W:Button({
Title = "神话健身房（5重生）",
Callback = function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2250.778076171875, 3.716248035430908, 1073.2266845703125)
end
})

TabHandles.W:Button({
Title = "永恒健身房（15重生）",
Callback = function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-6758.9638671875, 3.71626353263855, -1284.918701171875)
end
})

TabHandles.W:Button({
Title = "传奇健身房（30重生）",
Callback = function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(4603.28173828125, 987.869140625, -3897.86572265625)
end
})

TabHandles.W:Button({
Title = "力量之王”健身房（5重生）",
Callback = function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8625.9296875, 13.566278457641602, -5730.4736328125)
end
})

TabHandles.W:Button({
Title = "狂野健身房（60重生）",
Callback = function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-8693.0927734375, 8.93972396850586, 2400.66259765625)
end
})

TabHandles.M:Toggle({
Title = "自动刷业报v4",
Default = AutoStates.AutoKillReport3,
Callback = function(state)
AutoStates.AutoKillReport3 = state
if AutoStates.AutoKillReportLoops3 then
for _, c in pairs(AutoStates.AutoKillReportLoops3) do
c:Disconnect()
end
end
AutoStates.AutoKillReportLoops3 = {}
if not state then
if game.Players.LocalPlayer.Character then
local h = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
if h then
h:UnequipTools()
end
end
return
end
local pL = game:GetService("RunService").Heartbeat:Connect(function()
if not AutoStates.AutoKillReport3 then
pL:Disconnect()
return
end
for _, target in pairs(game.Players:GetPlayers()) do
if target ~= game.Players.LocalPlayer and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
pcall(function()
for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
if v:IsA("Tool") and v.Name == "Punch" then
game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
end
end
local p = game.Players.LocalPlayer.Character:FindFirstChild("Punch") or game.Players.LocalPlayer.Backpack:FindFirstChild("Punch")
if p then
p.Parent = game.Players.LocalPlayer.Character
p:Activate()
end
local head = target.Character:FindFirstChild("Head")
local lchar = game.Players.LocalPlayer.Character
local hand = lchar and lchar:FindFirstChild("LeftHand")
if head and hand then
firetouchinterest(head, hand, 0)
wait(0.01)
firetouchinterest(head, hand, 1)
end
end)
end
end
wait(0.1)
end)
table.insert(AutoStates.AutoKillReportLoops3, pL)
end
})

Interstellar.killplayers = {}

local Plr = game:GetService("Players")
local LP = Plr.LocalPlayer
local PlayerList = {}

local function initializePlayerList()
PlayerList = {}
for _, player in ipairs(Plr:GetPlayers()) do
if player ~= LP then
table.insert(PlayerList, player.Name)
end
end
end

local killplayerDropdown

local function refreshPlayerList()
initializePlayerList()
if killplayerDropdown then
killplayerDropdown:Refresh(PlayerList)
WindUI:Notify({
Title = "玩家列表",
Content = "玩家列表已刷新 (" .. #PlayerList .. " 个玩家)",
Duration = 3,
})
end
end

Plr.PlayerAdded:Connect(function(player)
if player ~= LP then
table.insert(PlayerList, player.Name)
if killplayerDropdown then
killplayerDropdown:Refresh(PlayerList)
end
end
end)

Plr.PlayerRemoving:Connect(function(player)
local index = table.find(PlayerList, player.Name)
if index then
table.remove(PlayerList, index)
local killIndex = table.find(Interstellar.killplayers, player.Name)
if killIndex then
table.remove(Interstellar.killplayers, killIndex)
end
if killplayerDropdown then
killplayerDropdown:Refresh(PlayerList)
end
end
end)

initializePlayerList()

killplayerDropdown = TabHandles.M:Dropdown({
Title = "要远程的玩家",
Values = PlayerList,
Value = {},
Multi = true,
AllowNone = true,
Callback = function(values)
Interstellar.killplayers = values or {}
WindUI:Notify({
Title = "远程",
Content = "已设置 " .. #Interstellar.killplayers .. " 个玩家为远程目标",
Duration = 3,
})
end
})

TabHandles.M:Toggle({
Title = "选中名单远程击杀(不选列表默认全部)",
Default = false,
Callback = function(state)
AutoStates.AutoKill = state
if state then
spawn(function()
while AutoStates.AutoKill do
pcall(function()
local targets = {}
if #Interstellar.killplayers > 0 then
targets = Interstellar.killplayers
else
targets = PlayerList
end
for _, playerName in pairs(targets) do
local target = Plr:FindFirstChild(playerName)
if target and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 then
for i, v in pairs(LP.Backpack:GetChildren()) do
if v:IsA("Tool") and v.Name == "Punch" then
LP.Character.Humanoid:EquipTool(v)
end
end
local p = LP.Character:FindFirstChild("Punch") or LP.Backpack:FindFirstChild("Punch")
if p then
p.Parent = LP.Character
p:Activate()
end
local head = target.Character:FindFirstChild("Head")
local lchar = LP.Character
local hand = lchar and lchar:FindFirstChild("LeftHand")
if head and hand then
firetouchinterest(head, hand, 0)
wait(0.01)
firetouchinterest(head, hand, 1)
end
end
end
end)
wait(0.1)
end
end)
end
end
})

TabHandles.M:Button({
Title = "查看选定远程名单",
Callback = function()
local targets = {}
if #Interstellar.killplayers > 0 then
targets = Interstellar.killplayers
else
targets = PlayerList
end
WindUI:Notify({
Title = "远程目标 (" .. #targets .. " 个玩家)",
Content = table.concat(targets, ", "),
Duration = 5,
})
end
})

TabHandles.M:Button({
Title = "刷新玩家列表",
Callback = function()
refreshPlayerList()
WindUI:Notify({
Title = "玩家列表",
Content = "刷新玩家列表成功",
Duration = 3,
})
end
})

local AutoTrainEnabled = false
local TrainThread = nil

TabHandles.E:Toggle({
Title = "自动锻炼",
Callback = function(Value)
AutoTrainEnabled = Value
if TrainThread then
task.cancel(TrainThread)
TrainThread = nil
end
if AutoTrainEnabled then
TrainThread = task.spawn(function()
while AutoTrainEnabled do
local muscleEvent = game.Players.LocalPlayer:FindFirstChild("muscleEvent")
if muscleEvent then
muscleEvent:FireServer("rep")
end
task.wait(0.1)
end
end)
end
end
})

local AutoPunchEnabled = false
local PunchThread = nil

TabHandles.E:Toggle({
Title = "自动挥拳",
Callback = function(Value)
AutoPunchEnabled = Value
if PunchThread then
task.cancel(PunchThread)
PunchThread = nil
end
if AutoPunchEnabled then
PunchThread = task.spawn(function()
while AutoPunchEnabled do
local muscleEvent = game.Players.LocalPlayer:FindFirstChild("muscleEvent")
if muscleEvent then
muscleEvent:FireServer("punch", "rightHand")
end
task.wait(0.1)
end
end)
end
end
})

TabHandles.E:Divider()

do
local enabled = false
TabHandles.E:Toggle({
Title = "自动哑铃",
Callback = function(Value)
enabled = Value
if enabled then
for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
if v.ClassName == "Tool" and v.Name == "Weight" then
v.Parent = game.Players.LocalPlayer.Character
wait()
end
end
spawn(function()
while enabled do
game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
wait()
end
end)
end
end
})
end

do
local enabled = false
TabHandles.E:Toggle({
Title = "自动俯卧撑",
Callback = function(Value)
enabled = Value
if enabled then
for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
if v.ClassName == "Tool" and v.Name == "Pushups" then
v.Parent = game.Players.LocalPlayer.Character
wait()
end
end
spawn(function()
while enabled do
game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
wait()
end
end)
end
end
})
end

do
local enabled = false
TabHandles.E:Toggle({
Title = "自动仰卧起坐",
Callback = function(Value)
enabled = Value
if enabled then
for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
if v.ClassName == "Tool" and v.Name == "Situps" then
v.Parent = game.Players.LocalPlayer.Character
wait()
end
end
spawn(function()
while enabled do
game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
wait()
end
end)
end
end
})
end

do
local enabled = false
TabHandles.E:Toggle({
Title = "自动倒立",
Callback = function(Value)
enabled = Value
if enabled then
for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
if v.ClassName == "Tool" and v.Name == "Handstands" then
v.Parent = game.Players.LocalPlayer.Character
wait()
end
end
spawn(function()
while enabled do
game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
wait()
end
end)
end
end
})
end

do
local enabled = false
TabHandles.E:Toggle({
Title = "自动练全部",
Callback = function(Value)
enabled = Value
if enabled then
for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
if v.ClassName == "Tool" and (v.Name == "Weight" or v.Name == "Handstands" or v.Name == "Pushups" or v.Name == "Situps") then
v.Parent = game.Players.LocalPlayer.Character
wait()
end
end
spawn(function()
while enabled do
game:GetService("Players").LocalPlayer.muscleEvent:FireServer("rep")
wait()
end
end)
end
end
})
end

do
local enabled = false
TabHandles.R:Toggle({
Title = "跑步机海滩10",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(238.671112, 5.40315914, 387.713165, -0.0160072874, -2.90710176e-08, -0.99987185, -3.3434191e-09, 1, -2.90212157e-08, 0.99987185, 2.87843993e-09, -0.0160072874)
local RunService = game:GetService("RunService")
local localPlayer = game.Players.LocalPlayer
RunService:BindToRenderStep("moveBeach10", Enum.RenderPriority.Character.Value + 1, function()
if localPlayer.Character then
local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
if humanoid then
humanoid:Move(Vector3.new(10000, 0, -1), true)
end
end
end)
wait()
end
end)
else
game:GetService("RunService"):UnbindFromRenderStep("moveBeach10")
end
end
})
end

do
local enabled = false
TabHandles.R:Toggle({
Title = "跑步机Frost-健身房-2000",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-3005.37866, 14.3221855, -464.697876, -0.015773816, -1.38508964e-08, 0.999875605, -5.13225586e-08, 1, 1.30429667e-08, -0.999875605, -5.11104332e-08, -0.015773816)
local RunService = game:GetService("RunService")
local localPlayer = game.Players.LocalPlayer
RunService:BindToRenderStep("moveFrost", Enum.RenderPriority.Character.Value + 1, function()
if localPlayer.Character then
local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
if humanoid then
humanoid:Move(Vector3.new(10000, 0, -1), true)
end
end
end)
wait()
end
end)
else
game:GetService("RunService"):UnbindFromRenderStep("moveFrost")
end
end
})
end

do
local enabled = false
TabHandles.R:Toggle({
Title = "跑步机神话-健身房2000",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2571.23706, 15.6896839, 898.650391, 0.999968231, 2.23868635e-09, -0.00797206629, -1.73198844e-09, 1, 6.35660768e-08, 0.00797206629, -6.3550246e-08, 0.999968231)
local RunService = game:GetService("RunService")
local localPlayer = game.Players.LocalPlayer
RunService:BindToRenderStep("moveMyth", Enum.RenderPriority.Character.Value + 1, function()
if localPlayer.Character then
local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
if humanoid then
humanoid:Move(Vector3.new(10000, 0, -1), true)
end
end
end)
wait()
end
end)
else
game:GetService("RunService"):UnbindFromRenderStep("moveMyth")
end
end
})
end

do
local enabled = false
TabHandles.R:Toggle({
Title = "永恒跑步机-健身房",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-7077.79102, 29.6702118, -1457.59961, -0.0322036594, -3.31122768e-10, 0.99948132, -6.44344267e-09, 1, 1.23684493e-10, -0.99948132, -6.43611742e-09, -0.0322036594)
local RunService = game:GetService("RunService")
local localPlayer = game.Players.LocalPlayer
RunService:BindToRenderStep("moveEternal", Enum.RenderPriority.Character.Value + 1, function()
if localPlayer.Character then
local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
if humanoid then
humanoid:Move(Vector3.new(10000, 0, -1), true)
end
end
end)
wait()
end
end)
else
game:GetService("RunService"):UnbindFromRenderStep("moveEternal")
end
end
})
end

do
local enabled = false
TabHandles.R:Toggle({
Title = "跑步机传奇-健身房",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 10
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4370.82812, 999.358704, -3621.42773, -0.960604727, -8.41949266e-09, -0.27791819, -6.12478646e-09, 1, -9.12496567e-09, 0.27791819, -7.06329528e-09, -0.960604727)
local RunService = game:GetService("RunService")
local localPlayer = game.Players.LocalPlayer
RunService:BindToRenderStep("moveLegend", Enum.RenderPriority.Character.Value + 1, function()
if localPlayer.Character then
local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
if humanoid then
humanoid:Move(Vector3.new(10000, 0, -1), true)
end
end
end)
wait()
end
end)
else
game:GetService("RunService"):UnbindFromRenderStep("moveLegend")
end
end
})
end

do
local enabled = false
TabHandles.SquatTab:Toggle({
Title = "沙滩",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.leaderstats.Strength.Value >= 1000 then
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(232.627625, 3.67689133, 96.3039856, -0.963445187, -7.78685845e-08, -0.267905563, -7.92865222e-08, 1, -5.52570167e-09, 0.267905563, 1.5917589e-08, -0.963445187)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.SquatTab:Toggle({
Title = "冰冻健身房",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.leaderstats.Strength.Value >= 4000 then
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-2629.13818, 3.36860609, -609.827454, -0.995664716, -2.67296816e-08, -0.0930150598, -1.90042453e-08, 1, -8.39415222e-08, 0.0930150598, -8.18099295e-08, -0.995664716)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.SquatTab:Toggle({
Title = "传奇健身房",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4443.04443, 987.521484, -4061.12988, 0.83309716, 3.33018835e-09, 0.553126693, -2.87759438e-09, 1, -1.68654424e-09, -0.553126693, -1.86619012e-10, 0.83309716)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.SquatTab:Toggle({
Title = "肌肉健身房",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-8757.37012, 13.2186356, -6051.24365, -0.902269304, 1.63610299e-08, -0.431172907, 1.71076486e-08, 1, 2.14606288e-09, 0.431172907, -5.44002754e-09, -0.902269304)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Squat Rack"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.Y:Toggle({
Title = "海滩",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.leaderstats.Strength.Value >= 1000 then
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-185.157745, 5.81071186, 104.747154, 0.227061391, -8.2363325e-09, 0.97388047, 5.58502826e-08, 1, -4.56432803e-09, -0.97388047, 5.54278827e-08, 0.227061391)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Legends Pullup"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.Y:Toggle({
Title = "神话",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.leaderstats.Strength.Value >= 4000 then
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2315.82104, 5.81071281, 847.153076, 0.993555248, 6.99809632e-08, 0.113349125, -7.05298859e-08, 1, 8.32554692e-10, -0.113349125, -8.82168916e-09, 0.993555248)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Legends Pullup"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.Y:Toggle({
Title = "传奇",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4305.08203, 989.963623, -4118.44873, -0.953815758, -7.58000382e-08, -0.30039227, -8.98859724e-08, 1, 3.30721512e-08, 0.30039227, 5.85457904e-08, -0.953815758)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder["Legends Pullup"].interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.U:Toggle({
Title = "海滩",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.leaderstats.Strength.Value >= 1500 then
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(136.606216, 3.67689133, 97.661499, -0.974106729, -1.89495477e-08, 0.226088539, -1.78365624e-08, 1, 6.96555214e-09, -0.226088539, 2.75254886e-09, -0.974106729)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.U:Toggle({
Title = "传说健身房",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.leaderstats.Strength.Value >= 5000 then
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-2916.11572, 3.67689204, -212.97438, -0.241641939, -6.10995343e-08, 0.970365465, 6.65890596e-08, 1, 7.9547597e-08, -0.970365465, 8.38377616e-08, -0.241641939)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.U:Toggle({
Title = "传奇健身房",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4538.42627, 987.829834, -4008.82007, -0.830109239, 2.21324914e-08, 0.557600796, 8.02302083e-08, 1, 7.97476361e-08, -0.557600796, 1.1093568e-07, -0.830109239)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.U:Toggle({
Title = "肌肉之王",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-8768.4375, 13.5269203, -5681.62256, -0.997508109, -5.4007393e-10, 0.0705519542, 1.52984292e-10, 1, 9.81797044e-09, -0.0705519542, 9.80429782e-09, -0.997508109)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.I:Toggle({
Title = "海滩",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.leaderstats.Strength.Value >= 3000 then
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(-91.6730804, 3.67689133, -292.42868, -0.221022144, -2.21041621e-08, -0.975268781, 1.21414407e-08, 1, -2.54162646e-08, 0.975268781, -1.7458726e-08, -0.221022144)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.I:Toggle({
Title = "神话",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.leaderstats.Strength.Value >= 10000 then
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(2486.01733, 3.67689276, 1237.89331, 0.883595645, -2.06135038e-08, -0.468250751, -3.3286871e-09, 1, -5.03036404e-08, 0.468250751, 4.60067362e-08, 0.883595645)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.I:Toggle({
Title = "传奇",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(4189.96143, 987.829773, -3903.0166, 0.422592968, 0, 0.906319559, 0, 1, 0, -0.906319559, 0, 0.422592968)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end)
end
end
})
end

do
local enabled = false
TabHandles.I:Toggle({
Title = "肌肉之王",
Callback = function(Value)
enabled = Value
if enabled then
spawn(function()
while enabled do
wait(0.1)
if game.Players.LocalPlayer.machineInUse.Value == nil then
game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(8933.69434, 13.5269222, -5700.12598, -0.823058188, 6.96304259e-09, 0.567957044, -1.19721832e-08, 1, -2.96093621e-08, -0.567957044, -3.11699146e-08, -0.823058188)
local vim = game:service("VirtualInputManager")
vim:SendKeyEvent(true, "E", false, game)
else
local A_1 = "rep"
local A_2 = game:GetService("Workspace").machinesFolder.Deadlift.interactSeat
local Event = game:GetService("Players").LocalPlayer.muscleEvent
Event:FireServer(A_1, A_2)
end
end
end)
end
end
})
end