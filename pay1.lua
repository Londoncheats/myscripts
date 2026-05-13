local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
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

-- Utility function for smooth tweens
local function tweenButton(button, property, targetValue, duration, style)
    local tweenInfo = TweenInfo.new(duration or 0.1, Enum.EasingStyle[style or "Quad"], Enum.EasingDirection.Out)
    local tween = TweenService:Create(button, tweenInfo, {[property] = targetValue})
    tween:Play()
    return tween
end

-- ========================
-- LOGIN GUI (Enhanced)
-- ========================
local loginFrame = Instance.new("Frame")
loginFrame.Size = UDim2.new(0, 340, 0, 220)
loginFrame.Position = UDim2.new(0.5, -170, 0.5, -110)
loginFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
loginFrame.BackgroundTransparency = 0.1
loginFrame.BorderSizePixel = 0
loginFrame.Parent = screenGui

-- Glow border effect for login frame
local loginGlow = Instance.new("Frame")
loginGlow.Size = UDim2.new(1, 4, 1, 4)
loginGlow.Position = UDim2.new(0, -2, 0, -2)
loginGlow.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
loginGlow.BackgroundTransparency = 0.8
loginGlow.BorderSizePixel = 0
loginGlow.Parent = loginFrame
Instance.new("UICorner", loginGlow).CornerRadius = UDim.new(0, 14)

local loginCorner = Instance.new("UICorner")
loginCorner.CornerRadius = UDim.new(0, 12)
loginCorner.Parent = loginFrame

-- Gradient background for login
local loginGradient = Instance.new("UIGradient")
loginGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 35))
}
loginGradient.Parent = loginFrame

local loginTitle = Instance.new("TextLabel")
loginTitle.Size = UDim2.new(1, 0, 0, 45)
loginTitle.Position = UDim2.new(0, 0, 0, 10)
loginTitle.BackgroundTransparency = 1
loginTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
loginTitle.Text = "🔐 TRAP N BANG HUB"
loginTitle.Font = Enum.Font.GothamBold
loginTitle.TextSize = 22
loginTitle.TextStrokeTransparency = 0.5
loginTitle.TextStrokeColor3 = Color3.fromRGB(255, 100, 0)
loginTitle.Parent = loginFrame

local loginSub = Instance.new("TextLabel")
loginSub.Size = UDim2.new(1, 0, 0, 25)
loginSub.Position = UDim2.new(0, 0, 0, 55)
loginSub.BackgroundTransparency = 1
loginSub.TextColor3 = Color3.fromRGB(180, 180, 200)
loginSub.Text = "Enter your key to continue"
loginSub.Font = Enum.Font.Gotham
loginSub.TextSize = 14
loginSub.Parent = loginFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -40, 0, 40)
keyBox.Position = UDim2.new(0, 20, 0, 90)
keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.PlaceholderText = "Enter key here..."
keyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 130)
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 15
keyBox.BorderSizePixel = 0
keyBox.Parent = loginFrame
local keyBoxCorner = Instance.new("UICorner")
keyBoxCorner.CornerRadius = UDim.new(0, 10)
keyBoxCorner.Parent = keyBox
-- Add glow to textbox when focused
keyBox.Focused:Connect(function()
    tweenButton(keyBox, "BackgroundColor3", Color3.fromRGB(30, 30, 45), 0.15)
end)
keyBox.FocusLost:Connect(function()
    tweenButton(keyBox, "BackgroundColor3", Color3.fromRGB(20, 20, 30), 0.15)
end)

local loginBtn = Instance.new("TextButton")
loginBtn.Size = UDim2.new(1, -40, 0, 42)
loginBtn.Position = UDim2.new(0, 20, 0, 140)
loginBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
loginBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
loginBtn.Text = "⚡ UNLOCK ⚡"
loginBtn.Font = Enum.Font.GothamBold
loginBtn.TextSize = 16
loginBtn.BorderSizePixel = 0
loginBtn.Parent = loginFrame
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = loginBtn

-- Pulsing animation for login button
local pulseUp = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true)
local pulseScale = TweenService:Create(loginBtn, pulseUp, {BackgroundColor3 = Color3.fromRGB(255, 210, 80)})
pulseScale:Play()
loginBtn.MouseEnter:Connect(function() tweenButton(loginBtn, "BackgroundColor3", Color3.fromRGB(255, 220, 100), 0.1) end)
loginBtn.MouseLeave:Connect(function() tweenButton(loginBtn, "BackgroundColor3", Color3.fromRGB(255, 180, 0), 0.1) end)
loginBtn.MouseButton1Down:Connect(function() tweenButton(loginBtn, "Size", UDim2.new(1, -36, 0, 38), 0.05, "Quad") end)
loginBtn.MouseButton1Up:Connect(function() tweenButton(loginBtn, "Size", UDim2.new(1, -40, 0, 42), 0.05, "Quad") end)

local loginError = Instance.new("TextLabel")
loginError.Size = UDim2.new(1, 0, 0, 25)
loginError.Position = UDim2.new(0, 0, 1, -5)
loginError.BackgroundTransparency = 1
loginError.TextColor3 = Color3.fromRGB(255, 70, 70)
loginError.Text = ""
loginError.Font = Enum.Font.GothamBold
loginError.TextSize = 13
loginError.Parent = loginFrame

-- ========================
-- MAIN GUI (Enhanced with glow)
-- ========================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 320)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Outer glow for main frame
local mainGlow = Instance.new("Frame")
mainGlow.Size = UDim2.new(1, 6, 1, 6)
mainGlow.Position = UDim2.new(0, -3, 0, -3)
mainGlow.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
mainGlow.BackgroundTransparency = 0.85
mainGlow.BorderSizePixel = 0
mainGlow.Parent = mainFrame
Instance.new("UICorner", mainGlow).CornerRadius = UDim.new(0, 16)

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 35))
}
mainGradient.Parent = mainFrame

-- Drag Bar (Title bar)
local dragBar = Instance.new("TextLabel")
dragBar.Size = UDim2.new(1, 0, 0, 40)
dragBar.Position = UDim2.new(0, 0, 0, 0)
dragBar.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
dragBar.TextColor3 = Color3.fromRGB(0, 0, 0)
dragBar.Text = "🏆 TRAP N BANG HUB 🏆"
dragBar.Font = Enum.Font.GothamBold
dragBar.TextSize = 15
dragBar.BorderSizePixel = 0
dragBar.Parent = mainFrame
local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0, 14)
dragCorner.Parent = dragBar
-- Make only top corners rounded
local dragClip = Instance.new("UICorner")
dragClip.CornerRadius = UDim.new(0, 14)
dragClip.Parent = dragBar

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 32, 0, 28)
minBtn.Position = UDim2.new(1, -40, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Text = "—"
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.BorderSizePixel = 0
minBtn.Parent = mainFrame
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)
minBtn.MouseEnter:Connect(function() tweenButton(minBtn, "BackgroundColor3", Color3.fromRGB(220, 60, 60), 0.1) end)
minBtn.MouseLeave:Connect(function() tweenButton(minBtn, "BackgroundColor3", Color3.fromRGB(200, 50, 50), 0.1) end)

-- ESP Toggle Button with glow
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(1, -30, 0, 45)
espBtn.Position = UDim2.new(0, 15, 0, 55)
espBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Text = "🔮 ESP — OFF 🔮"
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 15
espBtn.BorderSizePixel = 0
espBtn.Parent = mainFrame
local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 10)
espCorner.Parent = espBtn
-- Add a glowing border effect
local espGlow = Instance.new("UIStroke")
espGlow.Color = Color3.fromRGB(255, 0, 0)
espGlow.Thickness = 2
espGlow.Transparency = 0.5
espGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
espGlow.Parent = espBtn

espBtn.MouseEnter:Connect(function() tweenButton(espBtn, "BackgroundColor3", Color3.fromRGB(200, 0, 0), 0.1) end)
espBtn.MouseLeave:Connect(function() 
    if not highlightEnabled then
        tweenButton(espBtn, "BackgroundColor3", Color3.fromRGB(180, 0, 0), 0.1)
    else
        tweenButton(espBtn, "BackgroundColor3", Color3.fromRGB(0, 160, 0), 0.1)
    end
end)

-- Color label
local colorLabel = Instance.new("TextLabel")
colorLabel.Size = UDim2.new(1, -30, 0, 25)
colorLabel.Position = UDim2.new(0, 15, 0, 110)
colorLabel.BackgroundTransparency = 1
colorLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
colorLabel.Text = "🎨 ESP COLOR:"
colorLabel.Font = Enum.Font.GothamBold
colorLabel.TextSize = 14
colorLabel.TextXAlignment = Enum.TextXAlignment.Left
colorLabel.Parent = mainFrame

-- Color buttons with glow effect
local colors = {
    {name = "🔴", color = Color3.fromRGB(255, 0, 0), fullName = "Red"},
    {name = "🔵", color = Color3.fromRGB(0, 100, 255), fullName = "Blue"},
    {name = "🟢", color = Color3.fromRGB(0, 255, 0), fullName = "Green"},
    {name = "🌸", color = Color3.fromRGB(255, 0, 200), fullName = "Pink"},
    {name = "⚪", color = Color3.fromRGB(255, 255, 255), fullName = "White"},
    {name = "🌟", color = Color3.fromRGB(255, 215, 0), fullName = "Yellow"},
}

local colorGrid = Instance.new("Frame")
colorGrid.Size = UDim2.new(1, -30, 0, 70)
colorGrid.Position = UDim2.new(0, 15, 0, 138)
colorGrid.BackgroundTransparency = 1
colorGrid.Parent = mainFrame

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 70, 0, 50)
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.Parent = colorGrid

for _, c in ipairs(colors) do
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = c.color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = c.name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.BorderSizePixel = 0
    btn.Parent = colorGrid
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    -- Add glow stroke to color buttons
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = c.color
    btnStroke.Thickness = 1.5
    btnStroke.Transparency = 0.4
    btnStroke.Parent = btn
    
    local col = c.color
    btn.MouseEnter:Connect(function()
        tweenButton(btn, "BackgroundColor3", col, 0.1)
        tweenButton(btnStroke, "Transparency", 0, 0.1)
    end)
    btn.MouseLeave:Connect(function()
        tweenButton(btnStroke, "Transparency", 0.4, 0.1)
    end)
    btn.MouseButton1Click:Connect(function()
        espColor = col
        -- Update existing highlights with tween effect
        for _, h in pairs(highlights) do
            tweenButton(h, "FillColor", espColor, 0.2)
            h.OutlineColor = espColor
        end
        -- Update nametag colors
        for _, bb in pairs(billboards) do
            if bb and bb:FindFirstChild("TextLabel") then
                local label = bb.TextLabel
                local textColorTween = TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = espColor})
                textColorTween:Play()
            end
        end
        -- Update the glow on ESP button to reflect new color
        espGlow.Color = espColor
    end)
end

-- Nametag label
local nametagLabel = Instance.new("TextLabel")
nametagLabel.Size = UDim2.new(1, -30, 0, 25)
nametagLabel.Position = UDim2.new(0, 15, 0, 220)
nametagLabel.BackgroundTransparency = 1
nametagLabel.TextColor3 = Color3.fromRGB(180, 180, 220)
nametagLabel.Text = '📛 Nametag: "Good Boy"'
nametagLabel.Font = Enum.Font.Gotham
nametagLabel.TextSize = 13
nametagLabel.Parent = mainFrame

-- Version text footer
local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 0, 25)
versionText.Position = UDim2.new(0, 0, 1, -25)
versionText.BackgroundTransparency = 1
versionText.TextColor3 = Color3.fromRGB(100, 100, 150)
versionText.Text = "VΞRSIӨN 2.0 • GLӨW ΞDITION"
versionText.Font = Enum.Font.Gotham
versionText.TextSize = 10
versionText.TextXAlignment = Enum.TextXAlignment.Center
versionText.Parent = mainFrame

-- ========================
-- ESP FUNCTIONS (Enhanced)
-- ========================
local function addNametag(otherPlayer)
    local character = otherPlayer.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    if billboards[otherPlayer.Name] then billboards[otherPlayer.Name]:Destroy() end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 45)
    billboard.StudsOffset = Vector3.new(0, 2.8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head
    
    -- Background frame for nametag
    local bgFrame = Instance.new("Frame")
    bgFrame.Size = UDim2.new(1, 0, 1, 0)
    bgFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bgFrame.BackgroundTransparency = 0.5
    bgFrame.BorderSizePixel = 0
    bgFrame.Parent = billboard
    Instance.new("UICorner", bgFrame).CornerRadius = UDim.new(1, 0)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🐕 Good Boy"
    label.TextColor3 = espColor
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextStrokeTransparency = 0.3
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
                    highlight.FillTransparency = 0.6
                    highlight.OutlineTransparency = 0.2
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

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ========================
-- MINIMIZE ANIMATION
-- ========================
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 280, 0, 40) or UDim2.new(0, 280, 0, 320)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = targetSize})
    tween:Play()
    minBtn.Text = minimized and "●" or "—"
    -- Hide/show content except title bar (just tween size, optional)
    if minimized then
        espBtn.Visible = false
        colorLabel.Visible = false
        colorGrid.Visible = false
        nametagLabel.Visible = false
        versionText.Visible = false
    else
        espBtn.Visible = true
        colorLabel.Visible = true
        colorGrid.Visible = true
        nametagLabel.Visible = true
        versionText.Visible = true
    end
end)

-- ========================
-- ESP TOGGLE WITH GLOW CHANGE
-- ========================
espBtn.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    if highlightEnabled then
        addHighlights()
        espBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
        espBtn.Text = "✨ ESP — ON ✨"
        espGlow.Color = Color3.fromRGB(0, 255, 0)
        espGlow.Transparency = 0.2
        tweenButton(espGlow, "Thickness", 3, 0.2)
    else
        removeHighlights()
        espBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        espBtn.Text = "🌑 ESP — OFF 🌑"
        espGlow.Color = Color3.fromRGB(255, 0, 0)
        espGlow.Transparency = 0.5
        tweenButton(espGlow, "Thickness", 2, 0.2)
    end
end)

-- Player join/leave handlers
Players.PlayerAdded:Connect(function(otherPlayer)
    otherPlayer.CharacterAdded:Connect(function(character)
        if highlightEnabled then
            task.wait(1)
            if not highlightEnabled then return end
            local highlight = Instance.new("Highlight")
            highlight.FillColor = espColor
            highlight.OutlineColor = espColor
            highlight.FillTransparency = 0.6
            highlight.OutlineTransparency = 0.2
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
-- LOGIN HANDLER WITH ANIMATION
-- ========================
loginBtn.MouseButton1Click:Connect(function()
    if keyBox.Text:lower() == VALID_KEY then
        -- Fade out login with tween
        local fadeOut = TweenService:Create(loginFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
        fadeOut:Play()
        for _, child in ipairs(loginFrame:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                TweenService:Create(child, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
            end
        end
        task.wait(0.3)
        loginFrame.Visible = false
        mainFrame.Visible = true
        -- Pop-in animation for main frame
        mainFrame.BackgroundTransparency = 0.2
        local popTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Elastic), {BackgroundTransparency = 0.05})
        popTween:Play()
    else
        loginError.Text = "❌ INVALID KEY! ACCESS DENIED ❌"
        keyBox.Text = ""
        -- Shake effect
        local originalPos = loginFrame.Position
        for i = 1, 3 do
            TweenService:Create(loginFrame, TweenInfo.new(0.05), {Position = UDim2.new(0.5, -170 + (i%2==0 and 5 or -5), 0.5, -110)}):Play()
            task.wait(0.05)
        end
        TweenService:Create(loginFrame, TweenInfo.new(0.05), {Position = originalPos}):Play()
    end
end)

print("✨ Trap N Bang Hub [GLOW EDITION] Loaded Successfully! ✨")
