local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()

local Window = WindUI:CreateWindow({
    Title = "QJ脚本-出售柠檬",
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
MainTab:Section({Title = "自动升级", Opened = true})

local lemonStandUpgradeEnabled = false

MainTab:Paragraph({
        Title = "此服务器功能那么少的解释",
        Desc = "肝不动了，后面升级还要我那么多钱如果后面借我一个钱多的号我就把其他的自动升级功能弄上去，有愿意给号的售后群联系群主",
    })

MainTab:Toggle({
    Title = "自动升级柠檬架",
    Default = false,
    Callback = function(enabled)
        lemonStandUpgradeEnabled = enabled
        if enabled then
            task.spawn(function()
                while lemonStandUpgradeEnabled do
                    pcall(function()
                        local args = {1}
                        workspace:WaitForChild("Tycoon4"):WaitForChild("Purchases"):WaitForChild("Lemon Stand"):WaitForChild("Lemon Stand"):WaitForChild("Lemon Stand"):WaitForChild("Upgrade"):InvokeServer(unpack(args))
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

local lemonDashUpgradeEnabled = false

MainTab:Toggle({
    Title = "自动升级柠檬冲刺",
    Default = false,
    Callback = function(enabled)
        lemonDashUpgradeEnabled = enabled
        if enabled then
            task.spawn(function()
                while lemonDashUpgradeEnabled do
                    pcall(function()
                        local args = {1}
                        workspace:WaitForChild("Tycoon4"):WaitForChild("Purchases"):WaitForChild("LemonDash"):WaitForChild("LemonDash"):WaitForChild("LemonDash"):WaitForChild("Upgrade"):InvokeServer(unpack(args))
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

local lemonDepotUpgradeEnabled = false

MainTab:Toggle({
    Title = "自动升级柠檬仓库",
    Default = false,
    Callback = function(enabled)
        lemonDepotUpgradeEnabled = enabled
        if enabled then
            task.spawn(function()
                while lemonDepotUpgradeEnabled do
                    pcall(function()
                        local args = {1}
                        workspace:WaitForChild("Tycoon4"):WaitForChild("Purchases"):WaitForChild("Lemon Depot"):WaitForChild("Lemon Depot"):WaitForChild("Lemon Depot"):WaitForChild("Upgrade"):InvokeServer(unpack(args))
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})