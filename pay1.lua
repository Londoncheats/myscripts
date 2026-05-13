local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local playerGui = player:WaitForChild("PlayerGui")

local isRunning = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Pay1Gui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 80)
frame.Position = UDim2.new(0.5, -100, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Auto /pay 1 x4"
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.BorderSizePixel = 0
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 20)
status.Position = UDim2.new(0, 10, 0, 55)
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(180, 180, 180)
status.Text = "Click button to auto send"
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = frame

-- Function to send /pay 1 in chat
local function sendPayChat()
    local success1 = pcall(function()
        local TextChatService = game:GetService("TextChatService")
        local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync("/pay 1")
        end
    end)

    if not success1 then
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

-- Button click - auto sends 4 times
button.MouseButton1Click:Connect(function()
    if isRunning then return end
    isRunning = true
    button.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    button.Text = "Sending..."

    for i = 1, 4 do
        sendPayChat()
        status.Text = "Sent " .. i .. "/4..."
        task.wait(1) -- 1 second between each /pay 1
    end

    button.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    button.Text = "Done! ✓"
    status.Text = "/pay 1 sent 4 times!"
    status.TextColor3 = Color3.fromRGB(255, 215, 0)

    task.wait(2)
    button.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    button.Text = "Auto /pay 1 x4"
    status.Text = "Click button to auto send"
    status.TextColor3 = Color3.fromRGB(180, 180, 180)
    isRunning = false
end)

print("pay1 GUI loaded!")
