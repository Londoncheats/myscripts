local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local isRunning = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Pay1Gui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Status label
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 8)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.Text = "Ready"
status.Font = Enum.Font.GothamBold
status.TextSize = 13
status.Parent = frame

-- Start button
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.5, -15, 0, 40)
startBtn.Position = UDim2.new(0, 10, 0, 35)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.Text = "▶ Start"
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 15
startBtn.BorderSizePixel = 0
startBtn.Parent = frame

local sc1 = Instance.new("UICorner")
sc1.CornerRadius = UDim.new(0, 8)
sc1.Parent = startBtn

-- Stop button
local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.5, -15, 0, 40)
stopBtn.Position = UDim2.new(0.5, 5, 0, 35)
stopBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "■ Stop"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 15
stopBtn.BorderSizePixel = 0
stopBtn.Parent = frame

local sc2 = Instance.new("UICorner")
sc2.CornerRadius = UDim.new(0, 8)
sc2.Parent = stopBtn

-- Count label
local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, -20, 0, 20)
countLabel.Position = UDim2.new(0, 10, 0, 90)
countLabel.BackgroundTransparency = 1
countLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
countLabel.Text = "Total sent: 0"
countLabel.Font = Enum.Font.Gotham
countLabel.TextSize = 12
countLabel.Parent = frame

-- Send /pay 1 function
local function sendPayChat()
    local success = pcall(function()
        local TextChatService = game:GetService("TextChatService")
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync("/pay 1")
        end
    end)

    if not success then
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
end

-- Start button
local totalSent = 0
startBtn.MouseButton1Click:Connect(function()
    if isRunning then return end
    isRunning = true
    startBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    status.Text = "Sending..."
    status.TextColor3 = Color3.fromRGB(0, 255, 128)

    task.spawn(function()
        while isRunning do
            sendPayChat()
            totalSent = totalSent + 1
            countLabel.Text = "Total sent: " .. totalSent
            task.wait(0.1) -- as fast as possible without getting kicked
        end
    end)
end)

-- Stop button
stopBtn.MouseButton1Click:Connect(function()
    isRunning = false
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    status.Text = "Stopped"
    status.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

print("pay1 GUI loaded!")
