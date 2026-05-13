local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RS = game:GetService("ReplicatedStorage")
local Events = RS:WaitForChild("Events")
local userId = tostring(player.UserId)

local isRunning = false
local totalCycles = 0

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrapNBangGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.5, -110, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Text = "🏦 Trap N Bang Auto Farm"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 30)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.Text = "Ready"
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.Parent = frame

local cycleLabel = Instance.new("TextLabel")
cycleLabel.Size = UDim2.new(1, -20, 0, 20)
cycleLabel.Position = UDim2.new(0, 10, 0, 50)
cycleLabel.BackgroundTransparency = 1
cycleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
cycleLabel.Text = "Cycles: 0"
cycleLabel.Font = Enum.Font.GothamBold
cycleLabel.TextSize = 12
cycleLabel.Parent = frame

local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(1, -20, 0, 40)
startBtn.Position = UDim2.new(0, 10, 0, 80)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Text = "▶ START AUTO FARM"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 15
startBtn.BorderSizePixel = 0
startBtn.Parent = frame
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, -20, 0, 40)
stopBtn.Position = UDim2.new(0, 10, 0, 130)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "■ STOP"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 15
stopBtn.BorderSizePixel = 0
stopBtn.Parent = frame
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

local function sendPayChat()
    pcall(function()
        local TextChatService = game:GetService("TextChatService")
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync("/pay 1")
        end
    end)
    pcall(function()
        local chatService = RS:FindFirstChild("DefaultChatSystemChatEvents")
        if chatService then
            local sayMessage = chatService:FindFirstChild("SayMessageRequest")
            if sayMessage then
                sayMessage:FireServer("/pay 1", "All")
            end
        end
    end)
end

local function openSafe()
    status.Text = "🔓 Opening safe..."
    status.TextColor3 = Color3.fromRGB(0, 255, 128)
    pcall(function()
        local prompt = workspace:WaitForChild("Safes")
            :WaitForChild("Safe")
            :WaitForChild("PlrPosition")
            :WaitForChild("ProximityPrompt")
        Events:WaitForChild("OpenSafe"):FireServer(prompt)
    end)
    task.wait(2)
end

local function depositMoney()
    status.Text = "💰 Putting money in safe..."
    status.TextColor3 = Color3.fromRGB(0, 120, 255)
    pcall(function()
        Events:WaitForChild("Safe"):FireServer("Small Cash", userId, "In")
    end)
    task.wait(1)
end

local function withdrawMoney()
    status.Text = "💸 Taking money out..."
    status.TextColor3 = Color3.fromRGB(255, 100, 0)
    pcall(function()
        Events:WaitForChild("Safe"):FireServer("Small Cash", userId, "Out")
    end)
    task.wait(1)
end

startBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    isRunning = true
    startBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    startBtn.Text = "Running..."

    task.spawn(function()
        while isRunning do
            withdrawMoney() -- STEP 1: take money out
            openSafe()      -- STEP 2: open safe (waits 2s)
            depositMoney()  -- STEP 3: put money in safe (waits 1s)
            withdrawMoney() -- STEP 4: take money out (waits 1s)
            -- STEP 5: repeat (loop continues)

            totalCycles = totalCycles + 1
            cycleLabel.Text = "Cycles: " .. totalCycles
        end
    end)
end)

stopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    startBtn.Text = "▶ START AUTO FARM"
    status.Text = "Stopped"
    status.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

print("Trap N Bang Auto Farm loaded!")
