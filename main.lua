--// Dragon Rage Lite
--// Script leve para Dragon Ball Rage
--// By: You

if game.CoreGui:FindFirstChild("DragonRageLite") then
    game.CoreGui.DragonRageLite:Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Hum = Char:WaitForChild("Humanoid")

--// GUI
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "DragonRageLite"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 420, 0, 300)
Main.Position = UDim2.new(0.5, -210, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(20,10,30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1,0,0,40)
Title.Text = "🟣 Dragon Rage Lite"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(180,120,255)
Title.BackgroundTransparency = 1

--// Button creator
local function Button(text, y, callback)
    local B = Instance.new("TextButton", Main)
    B.Size = UDim2.new(0.9,0,0,36)
    B.Position = UDim2.new(0.05,0,0,y)
    B.Text = text
    B.Font = Enum.Font.Gotham
    B.TextSize = 14
    B.TextColor3 = Color3.fromRGB(230,220,255)
    B.BackgroundColor3 = Color3.fromRGB(90,45,140)
    B.BorderSizePixel = 0
    Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(callback)
end

--// STATES
local Fly = false
local AutoCharge = false
local AutoTrain = false

--// FLY (fraco)
Button("Toggle Fly (Lite)", 50, function()
    Fly = not Fly
end)

RunService.RenderStepped:Connect(function()
    if Fly then
        HRP.Velocity = Vector3.new(0, 35, 0)
    end
end)

--// AUTO CHARGE KI
Button("Auto Charge Ki", 100, function()
    AutoCharge = not AutoCharge
    task.spawn(function()
        while AutoCharge do
            pcall(function()
                game:GetService("ReplicatedStorage").Events.Train:FireServer("Charge")
            end)
            task.wait(0.6)
        end
    end)
end)

--// AUTO TRAIN
Button("Auto Train (Lite)", 150, function()
    AutoTrain = not AutoTrain
    task.spawn(function()
        while AutoTrain do
            pcall(function()
                game:GetService("ReplicatedStorage").Events.Train:FireServer("Train")
            end)
            task.wait(0.7)
        end
    end)
end)

--// WALKSPEED
Button("WalkSpeed 28", 200, function()
    Hum.WalkSpeed = 28
end)

--// JUMPPOWER
Button("JumpPower 65", 245, function()
    Hum.JumpPower = 65
end)

--// KEYBIND (RightShift)
UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)
