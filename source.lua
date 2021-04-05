for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
	v:Disable()
end
local tools = {}

for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
	if v:IsA("Tool") then
		table.insert(tools, v.Name)
	end
end

local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local window = ui.CreateLib("Blox Fruits", getgenv().ThemeOption)
local customColors = {
    SchemeColor = Color3.fromRGB(0,255,255),
    Background = Color3.fromRGB(0, 0, 0),
    Header = Color3.fromRGB(0, 0, 0),
    TextColor = Color3.fromRGB(255,255,255),
    ElementColor = Color3.fromRGB(20, 20, 20)
}
--------------------
getgenv().AutoQuest = false
getgenv().AutoFarming = false
getgenv().CurrentQuest = "Bandit [Lv. 5]"
getgenv().GrabFruits = false

getgenv().SkillZ = false
getgenv().SkillC = false
getgenv().SkillX = false

getgenv().CurrentWeapon = "Combat"
getgenv().AutoWeapon = false
--------------------

local mainTab = window:NewTab("Main")
local plrTab = window:NewTab("Player")
local themeTab = window:NewTab("UI Settings")

local autoFarmSection = mainTab:NewSection("Auto Farm")
local skillSection = mainTab:NewSection("Auto Skills")
local weaponSection = mainTab:NewSection("Combat")
local fruitSection = mainTab:NewSection("Fruits")
local playerSection = plrTab:NewSection("LocalPlayer")
local themeSection = themeTab:NewSection("Theme")
local settingsSection = themeTab:NewSection("UI")

settingsSection:NewKeybind("Toggle UI", "Toggle UI off/on", Enum.KeyCode.F, function()
	ui:ToggleUI()
end)

for theme, color in pairs(customColors) do
    themeSection:NewColorPicker(theme, "Change your "..theme, Color3.fromRGB(255,255,255), function(color3)
        ui:ChangeColor(theme, color3)
    end)
end

autoFarmSection:NewToggle("Auto Farm", "Auto Farms and Completes quests!" , function(farming)
	getgenv().AutoFarming = farming
end)

skillSection:NewToggle("Auto Skill: C", "Auto Uses Skill: C" , function(skill)
	getgenv().SkillC = skill
end)

skillSection:NewToggle("Auto Skill: Z", "Auto Uses Skill: Z" , function(skill)
	getgenv().SkillZ = skill
end)

skillSection:NewToggle("Auto Skill: X", "Auto Uses Skill: X" , function(skill)
	getgenv().SkillX = skill
end)

fruitSection:NewToggle("Auto Grab Fruits", "Graps All Fruits For You", function(state)
	getgenv().GrabFruits = state
end)

playerSection:NewSlider("WalkSpeed", "Modifies your WalkSpeed", 500, 16, function(val)
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)
playerSection:NewSlider("JumpPower", "Modifies your JumpPower", 250, 50, function(val)
	game.Players.LocalPlayer.Character.Humanoid.JumpPower = val
end)


weaponSection:NewToggle("Auto Use Weapon", "Auto Equips Chosen Weapon", function(state)
	getgenv().AutoWeapon = state
end)
local toolDropdown = weaponSection:NewDropdown("Weapon", "Choose your tool to use!", tools, function(weapon)
	getgenv().CurrentWeapon = weapon
end)

game.Players.LocalPlayer.Backpack.DescendantAdded:Connect(function(tool)
	local toolName = tool.Name
	if tool:IsA("Tool") then
		table.insert(tools, toolName)
		toolDropdown:Refresh(tools)
	end
end)
game.Players.LocalPlayer.Backpack.DescendantRemoving:Connect(function(tool)
	local toolName = tool.Name
	if tool:IsA("Tool") then
		for i,v in pairs(tools) do
			if v == toolName then
				table.remove(tools, i)
			end
		end	
	end
	toolDropdown:Refresh(tools)
end)
local quests = {
	"Bandit [Lv. 5]",
	"Monkey [Lv. 14]", 
	"Gorilla [Lv. 20]",
	"Pirate [Lv. 35]", 
	"Brute [Lv. 45]", 
	"Desert Bandit [Lv. 60]", 
	"Desert Officer [Lv. 70]", 
	"Snow Bandit [Lv. 90]", 
	"Snowman [Lv. 100]",
	"Chief Petty Officer [Lv. 120]" ,
	"Sky Bandit [Lv. 150]", 
	"Toga Warrior [Lv. 225]", 
	"Gladiator [Lv. 275]", 
	"Military Soldier [Lv. 300]", 
	"Military Spy [Lv. 330]", 
	"God's Guard [Lv. 450]",
	"Shanda [Lv. 475]", 
	"Galley Pirate [Lv. 625]"
}
autoFarmSection:NewToggle("Auto Quest", "Auto Quest" , function(auto)
	getgenv().AutoQuest = auto
end)
autoFarmSection:NewDropdown("Quest", "Choose your quest to complete!", quests , function(quest)
	getgenv().CurrentQuest = quest
end)
coroutine.wrap(function()
	while wait() do
		if getgenv().GrabFruits then
			for i,v in pairs(game.Workspace:GetChildren()) do
				local string = v.Name
				if string:find("Fruit") then
					v.Handle.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
				end
			end
		end
		if getgenv().AutoFarming then
			if getgenv().SkillC then
				local vManager = game:GetService("VirtualInputManager")
				vManager:SendKeyEvent(true, "C", false, game)
			end
			if getgenv().SkillZ then
				local mouse = require(game.ReplicatedStorage.Mouse)
				local pos = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.p, Vector3.new(mouse.Hit.p.x, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.p.y, mouse.Hit.p.z)); 
				for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
					if v:IsA("Tool") and v.Name ~= "Fruit" then
						v.RemoteFunction:InvokeServer("Z", pos)
					end	
				end
			end
			if getgenv().SkillX then
				for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
					if v:IsA("Tool") and v.Name ~= "Fruit" then
							v.RemoteFunction:InvokeServer("X")
					end	
				end
			end
			for i,v in pairs(game.ReplicatedStorage:GetChildren()) do
				if v:IsA("Model") and v.Name ~= "BusoTemplate" then
					if v.Name == getgenv().CurrentQuest then
						if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
							repeat wait() 
								local vuser = game:GetService("VirtualUser")
								vuser:CaptureController()
								vuser:ClickButton1(Vector2.new())
								pcall(function()
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame 
								end)
							until not getgenv().AutoFarming or not v or v.Humanoid.Health == 0
						end
					end
				end
			end
			for i,v in pairs(game.workspace.Enemies:GetChildren()) do
				if v:IsA("Model") and v.Name ~= "BusoTemplate" then
					if v.Name == getgenv().CurrentQuest then
						if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
							repeat wait() 
								local vuser = game:GetService("VirtualUser")
								vuser:CaptureController()
								vuser:ClickButton1(Vector2.new())
								pcall(function()
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame 
								end)
							until not getgenv().AutoFarming or not v or v.Humanoid.Health == 0
						end
					end
				end
			end
		end
		if getgenv().AutoQuest then
			if getgenv().CurrentQuest == "Bandit [Lv. 5]" then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "BanditQuest1",1)
			end
			if getgenv().CurrentQuest == "Monkey [Lv. 14]" then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "JungleQuest",1)
			end
			if getgenv().CurrentQuest == "Gorilla [Lv. 20]" then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "JungleQuest",2)
			end
			if getgenv().CurrentQuest == "Pirate [Lv. 35]" then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "BuggyQuest1",1)
			end
			if getgenv().CurrentQuest == "Brute [Lv. 45]" then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "BuggyQuest1",2)
			end
			if getgenv().CurrentQuest == "Desert Bandit [Lv. 60]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "DesertQuest",1)
			end
			if getgenv().CurrentQuest == "Desert Officer [Lv. 70]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "DesertQuest",2)
			end
			if getgenv().CurrentQuest == "Snow Bandit [Lv. 90]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "SnowQuest",1)
			end
			if getgenv().CurrentQuest == "Snowman [Lv. 100]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "SnowQuest",2)
			end
			if getgenv().CurrentQuest == "Chief Petty Officer [Lv. 120]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "MarineQuest2",1)
			end
			if getgenv().CurrentQuest == "Sky Bandit [Lv. 150]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "SkyQuest",1)
			end
			if getgenv().CurrentQuest == "Toga Warrior [Lv. 225]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "ColosseumQuest",1)
			end
			if getgenv().CurrentQuest == "Gladiator [Lv. 275]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "ColosseumQuest",2)
			end
			if getgenv().CurrentQuest == "Military Soldier [Lv. 300]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "MagmaQuest",1)
			end
			if getgenv().CurrentQuest == "Military Spy [Lv. 330]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "MagmaQuest",2)
			end
			if getgenv().CurrentQuest == "God's Guard [Lv. 450]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "SkyExp1Quest",1)
			end
			if getgenv().CurrentQuest == "Shanda [Lv. 475]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "SkyExp1Quest",2)
			end
			if getgenv().CurrentQuest == "Galley Pirate [Lv. 625]"  then
				game.ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", "FountainQuest",1)
			end
		end
	end
end)()
