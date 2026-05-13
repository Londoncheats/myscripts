local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local payCount = 0
local REQUIRED = 4

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
button.Text = "Click to /pay1 (0/4)"
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
status.Text = "Press 4 times to trigger"
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.Parent = frame

-- Button click logic
button.MouseButton1Click:Connect(function()
    payCount = payCount + 1
    button.Text = "Click to /pay1 (" .. payCount .. "/4)"

    if payCount >= REQUIRED then
        payCount = 0
        button.Text = "Click to /pay1 (0/4)"
        button.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        status.Text = "Payment triggered!"
        status.TextColor3 = Color3.fromRGB(255, 215, 0)

        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = "[pay1] Payment triggered! (x4 reached)",
            Color = Color3.fromRGB(255, 215, 0),
            Font = Enum.Font.GothamBold,
            FontSize = Enum.FontSize.Size18
        })

        task.wait(1.5)
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        status.Text = "Press 4 times to trigger"
        status.TextColor3 = Color3.fromRGB(180, 180, 180)
    else
        status.Text = "Keep clicking! " .. (REQUIRED - payCount) .. " more to go"
    end
end)

print("pay1 GUI loaded!")
