local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bygyyds666/QJ/refs/heads/main/ui.lua"))()
local Window = WindUI:CreateWindow({
        Title = "QJ脚本",
        Icon = "rbxassetid://81944629903864",
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
    Title = "极速传奇",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = openButtonColor,
    Draggable = true,
})

local Tabs = {
    Main = Window:Section({ Title = "通用", Opened = true }),
}

local TabHandles = {
    Q = Tabs.Main:Tab({ Title = "自动刷功能", Icon = "layout-grid" }),
    W = Tabs.Main:Tab({ Title = "传送功能", Icon = "layout-grid" }),
    E = Tabs.Main:Tab({ Title = "自动功能", Icon = "layout-grid" }),
}

Toggle = TabHandles.Q:Toggle({
    Title = "卡宠（有些重生不可用）",
    Desc = "",
    Locked = false,
    Callback = function(Value)
		autoXP = Value
		while autoXP do
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Yellow Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
			wait(0.1)
		end
	end    
})

Toggle = TabHandles.Q:Toggle({
    Title = "自动刷经验 150",
    Desc = "",
    Locked = false,
    Callback = function(Value)
		autoXP = Value
		while autoXP do
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")			
			wait()
		end	
    end
})

local cssdkq = false
local cssd = TabHandles.Q:Toggle({
    Title = "自动刷速度",
    Desc = "城市内使用",
    Value = cssdkq,
    Callback = function(state) 
        cssdkq = state
        if state then
            while cssdkq do
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local bxsdkq = false
local bxsd = TabHandles.Q:Toggle({
    Title = "自动刷速度",
    Desc = "白雪城市内使用",
    Value = bxsdkq,
    Callback = function(state) 
        bxsdkq = state
        if state then
            while bxsdkq do
                game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Snow City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local dysdkq = false
local dysd = TabHandles.Q:Toggle({
    Title = "自动刷速度",
    Desc = "岩浆城市内使用",
    Value = dysdkq,
    Callback = function(state) 
        dysdkq = state
        if state then
            while dysdkq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Magma City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local cqsdkq = false
local cqsd = TabHandles.Q:Toggle({
    Title = "自动刷速度",
    Desc = "传奇公路内使用",
    Value = cqsdkq,
    Callback = function(state) 
        cqsdkq = state
        if state then
            while cqsdkq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Red Orb","Legends Highway")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})
TabHandles.Q:Divider()

local cskq = false
local cs = TabHandles.Q:Toggle({
    Title = "自动重生",
    Desc = "可重生时将自动重生",
    Value = cskq,
    Callback = function(state) 
        cskq = state
        if state then
            while cskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("rebirthEvent"):FireServer("rebirthRequest")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动重生" or "已关闭自动重生",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})
TabHandles.Q:Divider()

local cszskq = false
local cszs = TabHandles.Q:Toggle({
    Title = "自动刷钻石",
    Desc = "城市内使用",
    Value = cszskq,
    Callback = function(state) 
        cszskq = state
        if state then
            while cszskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local bxzskq = false
local bxzs = TabHandles.Q:Toggle({
    Title = "自动刷钻石",
    Desc = "白雪城市内使用",
    Value = bxzskq,
    Callback = function(state) 
        bxzskq = state
        if state then
            while bxzskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Snow City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local yjzskq = false
local yjzs = TabHandles.Q:Toggle({
    Title = "自动刷钻石",
    Desc = "岩浆城市内使用",
    Value = yjzskq,
    Callback = function(state) 
        yjzskq = state
        if state then
            while yjzskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Magma City")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local cqzskq = false
local cqzs = TabHandles.Q:Toggle({
    Title = "自动刷钻石",
    Desc = "传奇公路内使用",
    Value = cqzskq,
    Callback = function(state) 
        cqzskq = state
        if state then
            while cqzskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("orbEvent"):FireServer("collectOrb","Gem","Legends Highway")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动刷钻石" or "已关闭自动刷钻石",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local q = {
    CFrame.new(-278.8976135253906, 66.09315490722656, -10946.564453125),
    CFrame.new(3980.05029296875, 159.91925048828125, 5589.21533203125),
    CFrame.new(137.6853485107422, 75.40111541748047, -5972.4873046875),
    CFrame.new(-15376.439453125, 412.2984619140625, 4475.322265625),
    CFrame.new(-489.440673828125, 98.277099609375, 2502.03564453125),
    CFrame.new(-15167.5068359375, 382.1965026855469, 4888.2900390625),
    CFrame.new(2094.217041015625, 251.98931884765625, 12877.951171875),
    CFrame.new(-1645.1728515625, 69.02545928955078, 5337.923828125),
    CFrame.new(-13254.447265625, 222.44158935546875, 4891.56005859375),
    CFrame.new(-533.439208984375, 58.4377326965332, 209.794921875),
    CFrame.new(473.2319641113281, 66.08084106445312, -10867.8388671875),
    CFrame.new(2333.369873046875, 161.6602325439453, 13369.1240234375),
    CFrame.new(5392.5322265625, 297.8348388671875, 5885.2138671875),
    CFrame.new(3806.247802734375, 299.41748046875, 7225.6806640625),
    CFrame.new(1664.3343505859375, 80.900390625, 12589.7109375),
    CFrame.new(1769.7236328125, 80.90105438232422, 12879.7958984375),
    CFrame.new(-11097.05859375, 200.84193420410156, 4465.34375),
    CFrame.new(-13140.974609375, 200.84193420410156, 4465.39599609375),
    CFrame.new(-536.3781127929688, 58.43798065185547, -133.1399688720703),
    CFrame.new(2485.461181640625, 135.55299377441406, 12384.6455078125),
    CFrame.new(1173.287109375, 92.03070831298828, -6024.24365234375),
    CFrame.new(-85.52466583251953, 115.9759750366211, -107.73560333251953),
    CFrame.new(1805.7076416015625, 90.94168853759766, 4617.30712890625),
    CFrame.new(-350.6163330078125, 66.06715393066406, -8732.2490234375),
    CFrame.new(5666.32861328125, 326.5240478515625, 6494.826171875),
    CFrame.new(4516.66845703125, 221.20545959472656, 7181.7421875),
    CFrame.new(-1746.5504150390625, 150.5835418701172, 5372.54248046875),
    CFrame.new(5361.96826171875, 297.8207092285156, 7025.44482421875),
    CFrame.new(4650.1669921875, 221.213134765625, 5608.54345703125),
    CFrame.new(-12993.1826171875, 200.82785034179688, 5222.71337890625),
    CFrame.new(355.5094299316406, 111.75679779052734, -10924.6923828125),
    CFrame.new(1942.0057373046875, 93.18344116210938, -2047.2164306640625),
    CFrame.new(-15156.52734375, 355.08978271484375, 4141.91357421875),
    CFrame.new(2062.114990234375, 159.88404846191406, 4374.28076171875),
    CFrame.new(230.04505920410156, 94.17676544189453, 80.71623229980469),
}

local sqkq = false
local sq = TabHandles.W:Toggle({
    Title = "自动刷圈",
    Desc = "传奇公路内使用",
    Value = sqkq,
    Callback = function(state) 
        sqkq = state
        if state then
            while sqkq do
                for _, zdsq in ipairs(q) do
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = zdsq
                    wait(0.0000000000000000000000000000000000000000000000000000000000000000000000001)
                end
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        else
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-568.6292114257812, 3.1723721027374268, 412.86492919921875)
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动刷圈" or "已关闭自动刷圈",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})


TabHandles.W:Button({
    Title = "传送至城市（出生点）",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-568.6292114257812, 3.1723721027374268, 412.86492919921875)
        WindUI:Notify({
            Title = "QJ：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

TabHandles.W:Button({
    Title = "传送至神秘洞穴",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-9683.048828125, 58.352359771728516, 3136.626953125)
        WindUI:Notify({
            Title = "QJ：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

TabHandles.W:Button({
    Title = "传送至白雪城市",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-866.3868408203125, 3.222372055053711, 2165.70654296875)
        WindUI:Notify({
            Title = "QJ：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

TabHandles.W:Button({
    Title = "传送至地狱洞穴",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-11041.357421875, 58.352359771728516, 4111.8251953125)
        WindUI:Notify({
            Title = "QJ：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

TabHandles.W:Button({
    Title = "传送至熔岩城市",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1616.8270263671875, 3.2723801136016846, 4330.65234375)
        WindUI:Notify({
            Title = "QJ：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

TabHandles.W:Button({
    Title = "传送至水手路线",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1618.4071044921875, 8.759234428405762, 4892.44091796875)
        WindUI:Notify({
            Title = "QJ：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

TabHandles.W:Button({
    Title = "传送至电光洞穴",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-13107.9892578125, 58.352359771728516, 4099.099609375)
        WindUI:Notify({
            Title = "QJ：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

TabHandles.W:Button({
    Title = "传送至传奇公路",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3673.601318359375, 70.75231170654297, 5588.7958984375)
        WindUI:Notify({
            Title = "QJ：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

TabHandles.W:Button({
    Title = "传送至丛林洞穴",
    Icon = "bell",
    Callback = function()
game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-15266.7880859375, 239.7072296142578, 3769.77490234375)
        WindUI:Notify({
            Title = "QJ：",
            Content = "传送成功",
            Icon = "bell",
            Duration = 3
        })
    end
})

local zdbskq = false
local zdbs = TabHandles.E:Toggle({
    Title = "自动比赛",
    Desc = "当有比赛时自动参加比赛",
    Value = zdbskq,
    Callback = function(state) 
        zdbskq = state
        if state then
            while zdbskq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("raceEvent"):FireServer("joinRace")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动比赛" or "已关闭自动比赛",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})
local zdsdkq = false
local zdsd = TabHandles.E:Toggle({
    Title = "自动刷速度V2",
    Desc = "可在任意地方使用（不稳定）",
    Value = zdsdkq,
    Callback = function(state) 
        zdsdkq = state
        if state then
            while zdsdkq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("questsEvent"):FireServer("collectQuest",Instance.new("Folder", nil))
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动刷速度" or "已关闭自动刷速度",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local mcwkq = false
local mcw = TabHandles.E:Toggle({
    Title = "自动买宠物",
    Desc = "快速获得宠物，消耗钻石",
    Value = mcwkq,
    Callback = function(state) 
        mcwkq = state
        if state then
            while mcwkq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer("openCrystal","Jungle Crystal")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动买宠物" or "已关闭自动买宠物",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})

local mwjkq = false
local mwj = TabHandles.E:Toggle({
    Title = "自动买尾迹",
    Desc = "快速获得尾迹，消耗钻石",
    Value = mwjkq,
    Callback = function(state) 
        mwjkq = state
        if state then
            while mwjkq do
game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer("openCrystal","Inferno Crystal")
            wait(0.000000000000000000000000000000000000000000000000000000000000000000000000001)
            end
        end
        WindUI:Notify({
            Title = "QJ：",
            Content = state and "已开启自动买尾迹" or "已关闭自动买尾迹",
            Icon = state and "check" or "x",
            Duration = 2
        })
    end
})