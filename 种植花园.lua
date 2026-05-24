local HttpService = cloneref(game:GetService("HttpService"))

local isfunctionhooked = clonefunction(isfunctionhooked)
if isfunctionhooked(game.HttpGet) or isfunctionhooked(getnamecallmethod) or isfunctionhooked(request) then 
    return 
end

local function verifyKey(k)
    local ok, res = pcall(function()
        return request({
            Url = "https://ouo.lat/api/verify.php",
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({key = k, time = os.time()})
        })
    end)
    
    if not ok then return false end
    
    if res.Body ~= "True" then
        return false
    end
    
    local ok2, res2 = pcall(function()
        return game:HttpGet("https://www.wtb.lat/keysystem/check-key?key="..k.."&user="..game.Players.LocalPlayer.Name)
    end)
    
    return ok2 and res2 == "success"
end

local key = ""
pcall(function() key = readfile("DyzhKey.json") end)
if key ~= "" then
    if verifyKey(key) then
        print('验证完成')
    else
        return
    end
end

local a = game:GetService("Players").LocalPlayer
local b = a.Character or a.CharacterAdded:Wait()
local c = game:GetService("ReplicatedStorage")

local sbns = {
    c = false,
    s = false,
    p = false
}

local seeds = {}
local selectseed = ""
for _,v in next, a.PlayerGui.Seed_Shop.Frame.ScrollingFrame:GetChildren() do
    if v.ClassName == "Frame" and not v.Name:find("Padding") then
        table.insert(seeds, v.Name)
    end
end

local gear = {}
local selectgear = ""
for _,v in next, a.PlayerGui.Gear_Shop.Frame.ScrollingFrame:GetChildren() do
    if v.ClassName == "Frame" and not v.Name:find("_") then
        table.insert(gear, v.Name)
    end
end

hookfunction(require(c.Modules.PlayerLuck).GetLuck, function()
    return math.huge
end)

hookfunction(require(c.Modules.PlayerLuck).GetModifiers, function()
    return {
        {
            Name = "Fake_Luck",
            Modifier = math.huge
        }
    }
end)

for _,v in ipairs(require(c.Data.SessionTimeLuckData).Timer) do
    if v.Luck then
        v.Luck = math.huge
    end
end

hookfunction(require(c.Modules.SessionTimeLuckController).GetCurrentLuck, function()
    return math.huge
end)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本",
    Icon = "crown",
    IconThemed = true,
    Author = "作者:琼玖",
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
    ScrollBarEnabled = true,
})

Window:EditOpenButton({
    Title = "种植花园",
    Icon = "image-upscale",
    CornerRadius = UDim.new(0, 10),
    StrokeThickness = 3,
    Color = ColorSequence.new(Color3.fromHex("FF0F7B"), Color3.fromHex("F89B29"))
})

local MainSection = Window:Section({
    Title = "主要菜单",
    Opened = true
})

local Main = MainSection:Tab({Title = "主要功能", Icon = "Sword"})

Main:Toggle({
    Title = "自动收集",
    Image = "swords",
    Value = false,
    Callback = function(state)
        sbns.c = state
        spawn(function()
            while wait() and sbns.c do
                pcall(function()
                    if b and b:FindFirstChild("HumanoidRootPart") then
                        for _, e in pairs(workspace.Farm:GetChildren()) do
                            if e:FindFirstChild("Important") and e.Important:FindFirstChild("Data") and e.Important.Data:FindFirstChild("Owner") then
                                if e.Important.Data.Owner.Value == a.Name then
                                    for _, g in ipairs(e.Important.Plants_Physical:GetDescendants()) do
                                        if g:IsA("ProximityPrompt") then
                                            b.Humanoid:MoveTo(g.Parent.Position)
                                            fireproximityprompt(g)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end)
    end
})

Main:Toggle({
    Title = "自动售卖",
    Image = "swords",
    Value = false,
    Callback = function(state)
        sbns.s = state
        spawn(function()
            while wait() and sbns.s do
                pcall(function()
                    if b and b:FindFirstChild("HumanoidRootPart") then
                        if #a.Backpack:GetChildren() > 20 then
                            local h = b.HumanoidRootPart.CFrame
                            b.HumanoidRootPart.CFrame = workspace.NPCS["Sell Stands"]["Shop Stand"].CFrame * CFrame.new(0, 0, 3)
                            wait(0.5)
                            c.GameEvents.Sell_Item:FireServer()
                            c.GameEvents.Sell_Inventory:FireServer()
                            wait(1)
                            b.HumanoidRootPart.CFrame = h
                        end
                    end
                end)
            end
        end)
    end
})

Main:Toggle({
    Title = "自动种植",
    Image = "swords",
    Value = false,
    Callback = function(state)
        sbns.p = state
        spawn(function()
            while wait() and sbns.p do
                pcall(function()
                    if b and b:FindFirstChild("HumanoidRootPart") then
                        local seedType, tool
                        for _, i in ipairs(b:GetChildren()) do
                            if i:IsA("Tool") and i.Name:find("Seed") then
                                seedType = i.Name:match("^(.-) Seed")
                                tool = i
                                break
                            end
                        end
                        
                        if not tool then
                            for _, i in ipairs(a.Backpack:GetChildren()) do
                                if i:IsA("Tool") and i.Name:find("Seed") then
                                    seedType = i.Name:match("^(.-) Seed")
                                    tool = i
                                    break
                                end
                            end
                        end
                        
                        if tool and seedType then
                            if tool.Parent == a.Backpack then
                                b.Humanoid:EquipTool(tool)
                                repeat wait() until tool.Parent == b
                            end
                            
                            c.GameEvents.Plant_RE:FireServer(
                                Vector3.new(math.floor(b.HumanoidRootPart.Position.X), 0.1, math.floor(b.HumanoidRootPart.Position.Z)),
                                seedType
                            )
                        end
                    end
                end)
            end
        end)
    end
})

Main:Dropdown({
    Title = "选择种子",
    Values = seeds,
    Callback = function(value)
        selectseed = value
    end
})

local SeedInfo = Main:Paragraph({
    Title = "种子信息",
    Desc = "无",
    Color = "White"
})

task.spawn(function()
    while wait() do
        if selectseed ~= "" then
            local seedFrame = a.PlayerGui.Seed_Shop.Frame.ScrollingFrame:FindFirstChild(selectseed)
            if seedFrame then
                SeedInfo:SetDesc("价格: " .. seedFrame.Main_Frame.Cost_Text.Text .. "\n数量: " .. seedFrame.Main_Frame.Stock_Text.Text)
            end
        end
    end
end)

Main:Button({
    Title = "购买种子",
    Callback = function()
        if selectseed ~= "" then
            c.GameEvents.BuySeedStock:FireServer("Tier 1", selectseed)
        end
    end
})

Main:Dropdown({
    Title = "选择工具",
    Values = gear,
    Callback = function(value)
        selectgear = value
    end
})

local GearInfo = Main:Paragraph({
    Title = "工具信息",
    Desc = "无",
    Color = "White"
})

task.spawn(function()
    while wait() do
        if selectgear ~= "" then
            local gearFrame = a.PlayerGui.Gear_Shop.Frame.ScrollingFrame:FindFirstChild(selectgear)
            if gearFrame then
                GearInfo:SetDesc("价格: " .. gearFrame.Main_Frame.Cost_Text.Text .. "\n数量: " .. gearFrame.Main_Frame.Stock_Text.Text)
            end
        end
    end
end)

Main:Button({
    Title = "购买工具",
    Callback = function()
        if selectgear ~= "" then
            c.GameEvents.BuyGearStock:FireServer(selectgear)
        end
    end
})