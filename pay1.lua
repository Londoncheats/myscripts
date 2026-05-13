local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local VALID_KEY = "test"
local highlightEnabled = false
local highlights = {}
local billboards = {}
local espColor = Color3.fromRGB(255, 0, 0)
local dragging = false
local dragStart, startPos

-- Clean up old GUI
if playerGui:FindFirstChild("MainGui") then
    playerGui.MainGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- ========================
-- LOGIN GUI
-- ========================
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(0, 300, 0, 180)
loginFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
loginFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
loginFrame.BackgroundTransparency = 0.2
loginFrame.BorderSizePixel = 0
loginFrame.Parent = screenGui
Instance.new("UICorner", loginFrame).CornerRadius = UDim.new(0, 12)

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 40)
loginTitle.Position = UDim2.new(0, 0, 0, 5)
loginTitle.BackgroundTransparency = 1
loginTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
loginTitle.Text = "🔐 Trap N Bang Hub"
loginTitle.Font = Enum.Font.GothamBold
loginTitle.TextSize = 18
loginTitle.Parent = loginFrame

local loginSub = Instance.new("TextLabel")
loginSub.Size = UDim2.new(1, 0, 0, 20)
loginSub.Position = UDim2.new(0, 0, 0, 45)
loginSub.BackgroundTransparency = 1
loginSub.TextColor3 = Color3.fromRGB(180, 180, 180)
loginSub.Text = "Enter your key to continue"
loginSub.Font = Enum.Font.Gotham
loginSub.TextSize = 13
loginSub.Parent = loginFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -30, 0, 35)
keyBox.Position = UDim2.new(0, 15, 0, 75)
keyBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.PlaceholderText = "Enter key here..."
keyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.BorderSizePixel = 0
keyBox.Parent = loginFrame
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 8)

local loginBtn = Instance.new("TextButton")
loginBtn.Size = UDim2.new(1, -30, 0, 35)
loginBtn.Position = UDim2.new(0, 15, 0, 120)
loginBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
loginBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
loginBtn.Text = "UNLOCK"
loginBtn.Font = Enum.Font.GothamBold
loginBtn.TextSize = 15
loginBtn.BorderSizePixel = 0
loginBtn.Parent = loginFrame
Instance.new("UICorner", loginBtn).CornerRadius = UDim.new(0, 8)

local loginError = Instance.new("TextLabel")
loginError.Size = UDim2.new(1, 0, 0, 20)
loginError.Position = UDim2.new(0, 0, 1, 5)
loginError.BackgroundTransparency = 1
loginError.TextColor3 = Color3.fromRGB(255, 50, 50)
loginError.Text = ""
loginError.Font = Enum.Font.GothamBold
loginError.TextSize = 13
loginError.Parent = loginFrame

-- ========================
-- MAIN GUI (hidden until login)
-- ========================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 280)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

-- Drag bar
local dragBar = Instance.new("TextLabel")
dragBar.Size = UDim2.new(1, 0, 0, 35)
dragBar.Position = UDim2.new(0, 0, 0, 0)
dragBar.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
dragBar.TextColor3 = Color3.fromRGB(0, 0, 0)
dragBar.Text = "🏦 Trap N Bang Hub"
dragBar.Font = Enum.Font.GothamBold
dragBar.TextSize = 14
dragBar.BorderSizePixel = 0
dragBar.Parent = mainFrame
Instance.new("UICorner", dragBar).CornerRadius = UDim.new(0, 12)

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 30, 0, 25)
minBtn.Position = UDim2.new(1, -35, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 14
minBtn.BorderSizePixel = 0
minBtn.Parent = mainFrame
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

-- ESP Toggle
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(1, -20, 0, 40)
espBtn.Position = UDim2.new(0, 10, 0, 45)
espBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Text = "ESP — OFF"
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 15
espBtn.BorderSizePixel = 0
espBtn.Parent = mainFrame
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 8)

-- Color label
local colorLabel = Instance.new("TextLabel")
colorLabel.Size = UDim2.new(1, -20, 0, 20)
colorLabel.Position = UDim2.new(0, 10, 0, 95)
colorLabel.BackgroundTransparency = 1
colorLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
colorLabel.Text = "ESP Color:"
colorLabel.Font = Enum.Font.GothamBold
colorLabel.TextSize = 13
colorLabel.TextXAlignment = Enum.TextXAlignment.Left
colorLabel.Parent = mainFrame

-- Color buttons
local colors = {
    {name = "Red",    color = Color3.fromRGB(255, 0, 0)},
    {name = "Blue",   color = Color3.fromRGB(0, 100, 255)},
    {name = "Green",  color = Color3.fromRGB(0, 255, 0)},
    {name = "Pink",   color = Color3.fromRGB(255, 0, 200)},
    {name = "White",  color = Color3.fromRGB(255, 255, 255)},
    {name = "Yellow", color = Color3.fromRGB(255, 215, 0)},
}

local colorGrid = Instance.new("Frame")
colorGrid.Size = UDim2.new(1, -20, 0, 110)
colorGrid.Position = UDim2.new(0, 10, 0, 118)
colorGrid.BackgroundTransparency = 1
colorGrid.Parent = mainFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 65, 0, 45)
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.Parent = colorGrid

for _, c in ipairs(colors) do
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = c.color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = c.name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.Parent = colorGrid
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local col = c.color
    btn.MouseButton1Click:Connect(function()
        espColor = col
        -- Update existing highlights
        for _, h in pairs(highlights) do
            h.FillColor = espColor
            h.OutlineColor = espColor
        end
    end)
end

-- Nametag label
local nametagLabel = Instance.new("TextLabel")
nametagLabel.Size = UDim2.new(1, -20, 0, 20)
nametagLabel.Position = UDim2.new(0, 10, 0, 235)
nametagLabel.BackgroundTransparency = 1
nametagLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
nametagLabel.Text = 'Nametag: "Good Boy"'
nametagLabel.Font = Enum.Font.Gotham
nametagLabel.TextSize = 12
nametagLabel.Parent = mainFrame

-- ========================
-- ESP FUNCTIONS
-- ========================
local function addNametag(otherPlayer)
    local character = otherPlayer.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    if billboards[otherPlayer.Name] then billboards[otherPlayer.Name]:Destroy() end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "Good Boy"
    label.TextColor3 = espColor
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    billboards[otherPlayer.Name] = billboard
end

local function removeNametag(otherPlayer)
    if billboards[otherPlayer.Name] then
        billboards[otherPlayer.Name]:Destroy()
        billboards[otherPlayer.Name] = nil
    end
end

local function addHighlights()
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local character = otherPlayer.Character
            if character then
                if not highlights[otherPlayer.Name] then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = espColor
                    highlight.OutlineColor = espColor
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Adornee = character
                    highlight.Parent = character
                    highlights[otherPlayer.Name] = highlight
                end
                addNametag(otherPlayer)
            end
        end
    end
end

local function removeHighlights()
    for name, highlight in pairs(highlights) do
        highlight:Destroy()
        highlights[name] = nil
    end
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        removeNametag(otherPlayer)
    end
end

-- ========================
-- DRAG LOGIC
-- ========================
dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ========================
-- MINIMIZE
-- ========================
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame.Size = UDim2.new(0, 250, 0, 35)
        minBtn.Text = "+"
    else
        mainFrame.Size = UDim2.new(0, 250, 0, 280)
        minBtn.Text = "—"
    end
end)

-- ========================
-- ESP TOGGLE
-- ========================
espBtn.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    if highlightEnabled then
        addHighlights()
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        espBtn.Text = "ESP — ON"
    else
        removeHighlights()
        espBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        espBtn.Text = "ESP — OFF"
    end
end)

Players.PlayerAdded:Connect(function(otherPlayer)
    otherPlayer.CharacterAdded:Connect(function(character)
        if highlightEnabled then
            task.wait(1)
            local highlight = Instance.new("Highlight")
            highlight.FillColor = espColor
            highlight.OutlineColor = espColor
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Adornee = character
            highlight.Parent = character
            highlights[otherPlayer.Name] = highlight
            addNametag(otherPlayer)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(otherPlayer)
    if highlights[otherPlayer.Name] then
        highlights[otherPlayer.Name]:Destroy()
        highlights[otherPlayer.Name] = nil
    end
    removeNametag(otherPlayer)
end)

-- ========================
-- LOGIN
-- ========================
loginBtn.MouseButton1Click:Connect(function()
    if keyBox.Text:lower() == VALID_KEY then
        loginFrame.Visible = false
        mainFrame.Visible = true
    else
        loginError.Text = "❌ Wrong key! Try again."
        keyBox.Text = ""
    end
end)

print("Trap N Bang Hub loaded!")
