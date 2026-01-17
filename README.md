--// Dragon Rage Utility
--// Professional Lite Script
--// By: Kaua

if game.CoreGui:FindFirstChild("DragonRageUtility") then
    game.CoreGui.DragonRageUtility:Destroy()
end

--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer
local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

--// STATES
local State = {
    Fly = false,
    AutoCharge = false,
    AutoTrain = false,
    AutoDefense = false,
    GuiVisible = true
}

--// ENERGY FUNCTION
local function GetEnergy()
    local stats = LP:FindFirstChild("Stats") or LP:FindFirstChild("leaderstats")
    if stats then
        local energy = stats:FindFirstChild("Energy") or stats:FindFirstChild("Ki")
        if energy then
            return energy.Value, energy.MaxValue or 100
        end
    end
    return 0, 100
end

--// DEFENSE KEYS
local function HoldR()
    VIM:SendKeyEvent(true, Enum.KeyCode.R, false, game)
end

local function ReleaseR()
    VIM:SendKeyEvent(false, Enum.KeyCode.R, false, game)
end

--// GUI
local Gui = Instance.new("ScreenGui", game.CoreGui)
Gui.Name = "DragonRageUtility"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 520, 0, 400)
Main.Position = UDim2.new(0.5, -260, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(18, 8, 28)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "🟣 Dragon Rage Utility"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(190, 130, 255)
Title.BackgroundTransparency = 1

--// SECTION
local function Section(text, pos)
    local S = Instance.new("TextLabel", Main)
    S.Text = text
    S.Font = Enum.Font.GothamBold
    S.TextSize = 15
    S.TextColor3 = Color3.fromRGB(160, 90, 255)
    S.BackgroundTransparency = 1
    S.Position = pos
    S.Size = UDim2.new(0, 200, 0, 30)
end

--// TOGGLE
local function Toggle(text, pos, callback)
    local Btn = Instance.new("TextButton", Main)
    Btn.Size = UDim2.new(0, 200, 0, 34)
    Btn.Position = pos
    Btn.Text = text .. " : OFF"
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 14
    Btn.TextColor3 = Color3.fromRGB(230, 220, 255)
    Btn.BackgroundColor3 = Color3.fromRGB(70, 35, 110)
    Btn.BorderSizePixel = 0
    Instance.new("UICorner", Btn)

    local on = false
    Btn.MouseButton1Click:Connect(function()
        on = not on
        Btn.Text = text .. (on and " : ON" or " : OFF")
        Btn.BackgroundColor3 = on and Color3.fromRGB(120, 70, 200) or Color3.fromRGB(70, 35, 110)
        callback(on)
    end)
end

--// SECTIONS
Section("Movement", UDim2.new(0, 20, 0, 60))
Section("Farm / Training", UDim2.new(0, 280, 0, 60))

--// MOVEMENT
Toggle("Fly (Lite)", UDim2.new(0, 20, 0, 100), function(v)
    State.Fly = v
end)

Toggle("WalkSpeed 28", UDim2.new(0, 20, 0, 145), function(v)
    Hum.WalkSpeed = v and 28 or 16
end)

Toggle("JumpPower 65", UDim2.new(0, 20, 0, 190), function(v)
    Hum.JumpPower = v and 65 or 50
end)

--// FARM
Toggle("Auto Charge Ki", UDim2.new(0, 280, 0, 100), function(v)
    State.AutoCharge = v
    task.spawn(function()
        while State.AutoCharge do
            pcall(function()
                game:GetService("ReplicatedStorage").Events.Train:FireServer("Charge")
            end)
            task.wait(0.6)
        end
    end)
end)

Toggle("Auto Train", UDim2.new(0, 280, 0, 145), function(v)
    State.AutoTrain = v
    task.spawn(function()
        while State.AutoTrain do
            pcall(function()
                game:GetService("ReplicatedStorage").Events.Train:FireServer("Train")
            end)
            task.wait(0.7)
        end
    end)
end)

--// AUTO DEFENSE (INTELIGENTE)
Toggle("Auto Defense (R)", UDim2.new(0, 280, 0, 190), function(v)
    State.AutoDefense = v

    task.spawn(function()
        while State.AutoDefense do
            local energy, maxEnergy = GetEnergy()

            if energy > 10 then
                HoldR()
            else
                ReleaseR()
                pcall(function()
                    game:GetService("ReplicatedStorage").Events.Train:FireServer("Charge")
                end)

                repeat
                    task.wait(0.4)
                    energy = GetEnergy()
                until energy >= maxEnergy * 0.95 or not State.AutoDefense
            end

            task.wait(0.2)
        end
        ReleaseR()
    end)
end)

--// FLY LOOP
RunService.RenderStepped:Connect(function()
    if State.Fly then
        HRP.Velocity = Vector3.new(0, 32, 0)
    end
end)

--// FLOAT BUTTON (FORA DO GUI)
local FloatBtn = Instance.new("TextButton", Gui)
FloatBtn.Size = UDim2.new(0, 50, 0, 50)
FloatBtn.Position = UDim2.new(0, 20, 0.5, -25)
FloatBtn.Text = "🟣"
FloatBtn.Font = Enum.Font.GothamBold
FloatBtn.TextSize = 22
FloatBtn.TextColor3 = Color3.fromRGB(255,255,255)
FloatBtn.BackgroundColor3 = Color3.fromRGB(120, 70, 200)
FloatBtn.BorderSizePixel = 0
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(1,0)

FloatBtn.MouseButton1Click:Connect(function()
    State.GuiVisible = not State.GuiVisible
    Main.Visible = State.GuiVisible
end)

--// RIGHT SHIFT
UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        State.GuiVisible = not State.GuiVisible
        Main.Visible = State.GuiVisible
    end
end)
