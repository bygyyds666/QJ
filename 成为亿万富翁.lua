local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-成为亿万富翁",
    Icon = "palette",
    Author = "作者：琼玖",
    Folder = "Premium",
    Size = UDim2.fromOffset(550, 320),
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
MainTab:Section({Title = "自动购买", Opened = true})

local noobEnabled = false
local baconEnabled = false
local influencerEnabled = false
local tixManEnabled = false
local tixInvestorEnabled = false
local hackerEnabled = false
local millionaireEnabled = false
local cryptoBroEnabled = false
local djEnabled = false
local frostEnabled = false
local pyroEnabled = false
local rapperEnabled = false
local royalKingEnabled = false
local datkKingEnabled = false
local artistEnabled = false
local billionaireEnabled = false
local presidentEnabled = false

MainTab:Toggle({
    Title = "菜鸟1/s",
    Default = false,
    Callback = function(enabled)
        noobEnabled = enabled
        if enabled then
            task.spawn(function()
                while noobEnabled do
                    local args = {"Noob"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "商务培根3/s",
    Default = false,
    Callback = function(enabled)
        baconEnabled = enabled
        if enabled then
            task.spawn(function()
                while baconEnabled do
                    local args = {"Business Bacon"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "影响者10/s",
    Default = false,
    Callback = function(enabled)
        influencerEnabled = enabled
        if enabled then
            task.spawn(function()
                while influencerEnabled do
                    local args = {"Influencer"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "票卷人50/s",
    Default = false,
    Callback = function(enabled)
        tixManEnabled = enabled
        if enabled then
            task.spawn(function()
                while tixManEnabled do
                    local args = {"Tix Man"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "投资者250/s",
    Default = false,
    Callback = function(enabled)
        tixInvestorEnabled = enabled
        if enabled then
            task.spawn(function()
                while tixInvestorEnabled do
                    local args = {"Tix Investor"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "黑客750/s",
    Default = false,
    Callback = function(enabled)
        hackerEnabled = enabled
        if enabled then
            task.spawn(function()
                while hackerEnabled do
                    local args = {"Hacker"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "百万富翁3.5k/s",
    Default = false,
    Callback = function(enabled)
        millionaireEnabled = enabled
        if enabled then
            task.spawn(function()
                while millionaireEnabled do
                    local args = {"Millionaire"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "加密货币经纪人15k/s",
    Default = false,
    Callback = function(enabled)
        cryptoBroEnabled = enabled
        if enabled then
            task.spawn(function()
                while cryptoBroEnabled do
                    local args = {"Crypto Bro"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "DJ75k/s",
    Default = false,
    Callback = function(enabled)
        djEnabled = enabled
        if enabled then
            task.spawn(function()
                while djEnabled do
                    local args = {"DJ"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "霜先生500k/s",
    Default = false,
    Callback = function(enabled)
        frostEnabled = enabled
        if enabled then
            task.spawn(function()
                while frostEnabled do
                    local args = {"Mr. Frost"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "火焰先生5M/s",
    Default = false,
    Callback = function(enabled)
        pyroEnabled = enabled
        if enabled then
            task.spawn(function()
                while pyroEnabled do
                    local args = {"Mr.Pyro"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "歌手15m/s",
    Default = false,
    Callback = function(enabled)
        rapperEnabled = enabled
        if enabled then
            task.spawn(function()
                while rapperEnabled do
                    local args = {"Rapper"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "皇家国王50m/s",
    Default = false,
    Callback = function(enabled)
        royalKingEnabled = enabled
        if enabled then
            task.spawn(function()
                while royalKingEnabled do
                    local args = {"Royal King"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "黑暗之王",
    Default = false,
    Callback = function(enabled)
        datkKingEnabled = enabled
        if enabled then
            task.spawn(function()
                while datkKingEnabled do
                    local args = {"Datk King"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "艺术家",
    Default = false,
    Callback = function(enabled)
        artistEnabled = enabled
        if enabled then
            task.spawn(function()
                while artistEnabled do
                    local args = {"Artist"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "亿万富翁",
    Default = false,
    Callback = function(enabled)
        billionaireEnabled = enabled
        if enabled then
            task.spawn(function()
                while billionaireEnabled do
                    local args = {"Billionaire"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})

MainTab:Toggle({
    Title = "总裁",
    Default = false,
    Callback = function(enabled)
        presidentEnabled = enabled
        if enabled then
            task.spawn(function()
                while presidentEnabled do
                    local args = {"President"}
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Systems"):WaitForChild("Shop"):WaitForChild("Services"):WaitForChild("ShopNetwork"):WaitForChild("_buyNPC"):InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        end
    end
})