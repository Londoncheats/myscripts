local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local RS = game:GetService("ReplicatedStorage")
local Events = RS:WaitForChild("Events")

local isRunning = false

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrapNBangGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.5, -110, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Text = "Trap N Bang Auto"
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
status.TextSize = 12
status.Parent = frame

-- Open Safe button
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(1, -20, 0, 35)
openBtn.Position = UDim2.new(0, 10, 0, 55)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Text = "🔓 Auto Open Safe"
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 14
openBtn.BorderSizePixel = 0
openBtn.Parent = frame
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)

-- Deposit button
local depositBtn = Instance.new("TextButton")
depositBtn.Size = UDim2.new(0.5, -15, 0, 35)
depositBtn.Position = UDim2.new(0, 10, 0, 100)
depositBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
depositBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
depositBtn.Text = "💰 Deposit"
depositBtn.Font = Enum.Font.GothamBold
depositBtn.TextSize = 13
depositBtn.BorderSizePixel = 0
depositBtn.Parent = frame
Instance.new("UICorner", depositBtn).CornerRadius = UDim.new(0, 8)

-- Withdraw button
local withdrawBtn = Instance.new("TextButton")
withdrawBtn.Size = UDim2.new(0.5, -15, 0, 35)
withdrawBtn.Position = UDim2.new(0.5, 5, 0, 100)
withdrawBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
withdrawBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
withdrawBtn.Text = "💸 Withdraw"
withdrawBtn.Font = Enum.Font.GothamBold
withdrawBtn.TextSize = 13
withdrawBtn.BorderSizePixel = 0
withdrawBtn.Parent = frame
Instance.new("UICorner", withdrawBtn).CornerRadius = UDim.new(0, 8)

-- Send /pay 1 button
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.5, -15, 0, 35)
startBtn.Position = UDim2.new(0, 10, 0, 145)
startBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Text = "▶ Auto Pay"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 13
startBtn.BorderSizePixel = 0
startBtn.Parent = frame
Instance.new("UICorner", startBtn).CornerRadius = UDim.new(0, 8)

-- Stop button
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.5, -15, 0, 35)
stopBtn.Position = UDim2.new(0.5, 5, 0, 145)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "■ Stop"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 13
stopBtn.BorderSizePixel = 0
stopBtn.Parent = frame
Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0, 8)

-- Functions
local function sendPayChat()
    pcall(function()
        local TextChatService = game:GetService("TextChatService")
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync("/pay 1")
        end
    end)
    pcall(function()
        local chatService = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chatService then
            local sayMessage = chatService:FindFirstChild("SayMessageRequest")
            if sayMessage then
                sayMessage:FireServer("/pay 1", "All")
            end
        end
    end)
end

-- Open Safe (holds E for 4 seconds)
openBtn.MouseButton1Click:Connect(function()
    status.Text = "Opening safe..."
    status.TextColor3 = Color3.fromRGB(0, 255, 128)
    pcall(function()
        -- Try firing the remote directly
        Events.OpenSafe:FireServer()
    end)
    -- Also simulate holding E
    local uis = game:GetService("UserInputService")
    local inputBeganEvent = game:GetService("VirtualInputManager")
    task.spawn(function()
        pcall(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(4)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
        end)
    end)
    task.wait(4)
    status.Text = "Safe opened!"
end)

-- Deposit
depositBtn.MouseButton1Click:Connect(function()
    status.Text = "Depositing..."
    pcall(function()
        Events:WaitForChild("DepositMoney"):FireServer()
    end)
    pcall(function()
        Events:WaitForChild("Deposit"):FireServer()
    end)
    pcall(function()
        Events:WaitForChild("SafeDeposit"):FireServer()
    end)
    status.Text = "Deposited!"
end)

-- Withdraw
withdrawBtn.MouseButton1Click:Connect(function()
    status.Text = "Withdrawing..."
    pcall(function()
        Events:WaitForChild("WithdrawMoney"):FireServer()
    end)
    pcall(function()
        Events:WaitForChild("Withdraw"):FireServer()
    end)
    pcall(function()
        Events:WaitForChild("SafeWithdraw"):FireServer()
    end)
    status.Text = "Withdrawn!"
end)

-- Auto Pay
startBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    isRunning = true
    startBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    status.Text = "Sending /pay 1..."
    status.TextColor3 = Color3.fromRGB(0, 255, 128)
    local totalSent = 0
    task.spawn(function()
        while isRunning do
            sendPayChat()
            totalSent = totalSent + 1
            status.Text = "Sent: " .. totalSent
            task.wait(0.1)
        end
    end)
end)

-- Stop
stopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    startBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    status.Text = "Stopped"
    status.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

print("Trap N Bang GUI loaded!")
