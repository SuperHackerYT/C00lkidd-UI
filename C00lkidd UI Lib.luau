-- c00lkidd Style UI Library
-- Dark theme with red accents, classic executor look

local C00lLibrary = {}
C00lLibrary.__index = C00lLibrary

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Settings
local LibrarySettings = {
    Theme = {
        Background = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(200, 30, 30),
        AccentDark = Color3.fromRGB(150, 20, 20),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(45, 45, 45),
        Hover = Color3.fromRGB(35, 35, 35),
        Dropdown = Color3.fromRGB(30, 30, 30)
    },
    Font = Enum.Font.Gotham,
    TextSize = 14
}

-- Utility Functions
local function CreateShadow(parent, size)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.BackgroundTransparency = 1
    shadow.Size = size + UDim2.new(0, 10, 0, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.Parent = parent
    return shadow
end

local function CreateRoundedCorner(parent, cornerRadius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerRadius or 5)
    corner.Parent = parent
    return corner
end

local function MakeDraggable(frame, dragButton)
    local dragging = false
    local dragInput, dragStart, startPos
    
    dragButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Main Window Class
local Window = {}
Window.__index = Window

function C00lLibrary:CreateWindow(title, options)
    options = options or {}
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "C00lLibrary"
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = LibrarySettings.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    CreateShadow(mainFrame, mainFrame.Size)
    CreateRoundedCorner(mainFrame, 8)
    
    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 35)
    topBar.BackgroundColor3 = LibrarySettings.Theme.Accent
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    CreateRoundedCorner(topBar, 8)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "c00lkidd UI"
    titleLabel.TextColor3 = LibrarySettings.Theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = LibrarySettings.Font
    titleLabel.TextSize = 16
    titleLabel.TextStrokeTransparency = 0.5
    titleLabel.Parent = topBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = LibrarySettings.Theme.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = topBar
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)
    
    -- Minimize Button
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 1, 0)
    minBtn.Position = UDim2.new(1, -70, 0, 0)
    minBtn.BackgroundTransparency = 1
    minBtn.Text = "_"
    minBtn.TextColor3 = LibrarySettings.Theme.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 18
    minBtn.Parent = topBar
    minBtn.MouseButton1Click:Connect(function()
        mainFrame.Size = UDim2.new(0, 500, 0, 35)
        -- Hide content
        for _, child in pairs(mainFrame:GetChildren()) do
            if child ~= topBar then
                child.Visible = false
            end
        end
        minBtn.MouseButton1Click:Connect(function()
            mainFrame.Size = UDim2.new(0, 500, 0, 400)
            for _, child in pairs(mainFrame:GetChildren()) do
                if child ~= topBar then
                    child.Visible = true
                end
            end
        end)
    end)
    
    MakeDraggable(mainFrame, topBar)
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 120, 1, -35)
    tabContainer.Position = UDim2.new(0, 0, 0, 35)
    tabContainer.BackgroundColor3 = LibrarySettings.Theme.Background
    tabContainer.BackgroundTransparency = 0.2
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = mainFrame
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -125, 1, -40)
    contentContainer.Position = UDim2.new(0, 125, 0, 40)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = mainFrame
    
    local window = setmetatable({
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        TabContainer = tabContainer,
        ContentContainer = contentContainer,
        Tabs = {},
        CurrentTab = nil
    }, Window)
    
    return window
end

function Window:CreateTab(tabName)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.Position = UDim2.new(0, 5, 0, (#self.Tabs * 45) + 5)
    tabButton.BackgroundColor3 = LibrarySettings.Theme.Background
    tabButton.BackgroundTransparency = 0.3
    tabButton.Text = tabName
    tabButton.TextColor3 = LibrarySettings.Theme.Text
    tabButton.Font = LibrarySettings.Font
    tabButton.TextSize = LibrarySettings.TextSize
    tabButton.Parent = self.TabContainer
    CreateRoundedCorner(tabButton, 4)
    
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Size = UDim2.new(1, -20, 1, -10)
    tabContent.Position = UDim2.new(0, 10, 0, 5)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 8
    tabContent.ScrollBarImageColor3 = LibrarySettings.Theme.Accent
    tabContent.Parent = self.ContentContainer
    tabContent.Visible = false
    
    local canvasLayout = Instance.new("UIListLayout")
    canvasLayout.Padding = UDim.new(0, 8)
    canvasLayout.SortOrder = Enum.SortOrder.LayoutOrder
    canvasLayout.Parent = tabContent
    
    canvasLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContent.CanvasSize = UDim2.new(0, 0, 0, canvasLayout.AbsoluteContentSize.Y + 10)
    end)
    
    table.insert(self.Tabs, {Button = tabButton, Content = tabContent})
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = LibrarySettings.Theme.Background
            tab.Button.BackgroundTransparency = 0.3
        end
        tabContent.Visible = true
        tabButton.BackgroundColor3 = LibrarySettings.Theme.Accent
        tabButton.BackgroundTransparency = 0
        self.CurrentTab = tabContent
    end)
    
    if #self.Tabs == 1 then
        tabButton.MouseButton1Click:Fire()
    end
    
    return {
        AddButton = function(self, buttonText, callback)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -20, 0, 35)
            button.BackgroundColor3 = LibrarySettings.Theme.Dropdown
            button.Text = buttonText
            button.TextColor3 = LibrarySettings.Theme.Text
            button.Font = LibrarySettings.Font
            button.TextSize = LibrarySettings.TextSize
            button.Parent = tabContent
            CreateRoundedCorner(button, 4)
            
            button.MouseEnter:Connect(function()
                button.BackgroundColor3 = LibrarySettings.Theme.Hover
            end)
            button.MouseLeave:Connect(function()
                button.BackgroundColor3 = LibrarySettings.Theme.Dropdown
            end)
            button.MouseButton1Click:Connect(callback)
        end,
        
        AddToggle = function(self, toggleText, default, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, -20, 0, 35)
            toggleFrame.BackgroundColor3 = LibrarySettings.Theme.Dropdown
            toggleFrame.Parent = tabContent
            CreateRoundedCorner(toggleFrame, 4)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -50, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = toggleText
            label.TextColor3 = LibrarySettings.Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = LibrarySettings.Font
            label.TextSize = LibrarySettings.TextSize
            label.Parent = toggleFrame
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(0, 40, 0, 25)
            toggleBtn.Position = UDim2.new(1, -45, 0.5, -12.5)
            toggleBtn.BackgroundColor3 = default and LibrarySettings.Theme.Accent or LibrarySettings.Theme.Background
            toggleBtn.Text = default and "ON" or "OFF"
            toggleBtn.TextColor3 = LibrarySettings.Theme.Text
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.TextSize = 12
            toggleBtn.Parent = toggleFrame
            CreateRoundedCorner(toggleBtn, 4)
            
            local toggled = default or false
            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                toggleBtn.BackgroundColor3 = toggled and LibrarySettings.Theme.Accent or LibrarySettings.Theme.Background
                toggleBtn.Text = toggled and "ON" or "OFF"
                callback(toggled)
            end)
            
            callback(toggled)
        end,
        
        AddSlider = function(self, sliderText, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, -20, 0, 55)
            sliderFrame.BackgroundColor3 = LibrarySettings.Theme.Dropdown
            sliderFrame.Parent = tabContent
            CreateRoundedCorner(sliderFrame, 4)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -10, 0, 20)
            label.Position = UDim2.new(0, 5, 0, 5)
            label.BackgroundTransparency = 1
            label.Text = sliderText .. ": " .. tostring(default)
            label.TextColor3 = LibrarySettings.Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = LibrarySettings.Font
            label.TextSize = LibrarySettings.TextSize
            label.Parent = sliderFrame
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, -20, 0, 4)
            sliderBar.Position = UDim2.new(0, 10, 0, 30)
            sliderBar.BackgroundColor3 = LibrarySettings.Theme.Background
            sliderBar.Parent = sliderFrame
            CreateRoundedCorner(sliderBar, 2)
            
            local fillBar = Instance.new("Frame")
            fillBar.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fillBar.BackgroundColor3 = LibrarySettings.Theme.Accent
            fillBar.Parent = sliderBar
            CreateRoundedCorner(fillBar, 2)
            
            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Size = UDim2.new(0, 15, 0, 15)
            sliderBtn.Position = UDim2.new((default - min) / (max - min), -7.5, 0.5, -7.5)
            sliderBtn.BackgroundColor3 = LibrarySettings.Theme.Accent
            sliderBtn.Text = ""
            sliderBtn.Parent = sliderBar
            CreateRoundedCorner(sliderBtn, 7.5)
            
            local dragging = false
            local value = default
            
            sliderBtn.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation()
                    local barPos = sliderBar.AbsolutePosition
                    local barWidth = sliderBar.AbsoluteSize.X
                    local percent = math.clamp((mousePos.X - barPos.X) / barWidth, 0, 1)
                    value = math.floor(min + (max - min) * percent)
                    
                    fillBar.Size = UDim2.new(percent, 0, 1, 0)
                    sliderBtn.Position = UDim2.new(percent, -7.5, 0.5, -7.5)
                    label.Text = sliderText .. ": " .. tostring(value)
                    callback(value)
                end
            end)
            
            callback(value)
        end,
        
        AddDropdown = function(self, dropdownText, options, callback)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, -20, 0, 35)
            dropdownFrame.BackgroundColor3 = LibrarySettings.Theme.Dropdown
            dropdownFrame.Parent = tabContent
            CreateRoundedCorner(dropdownFrame, 4)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.6, -5, 1, 0)
            label.Position = UDim2.new(0, 5, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = dropdownText
            label.TextColor3 = LibrarySettings.Theme.Text
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Font = LibrarySettings.Font
            label.TextSize = LibrarySettings.TextSize
            label.Parent = dropdownFrame
            
            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Size = UDim2.new(0.4, -5, 0, 25)
            dropdownBtn.Position = UDim2.new(0.6, 5, 0.5, -12.5)
            dropdownBtn.BackgroundColor3 = LibrarySettings.Theme.Background
            dropdownBtn.Text = options[1] or "Select"
            dropdownBtn.TextColor3 = LibrarySettings.Theme.Text
            dropdownBtn.Font = LibrarySettings.Font
            dropdownBtn.TextSize = LibrarySettings.TextSize
            dropdownBtn.Parent = dropdownFrame
            CreateRoundedCorner(dropdownBtn, 4)
            
            local dropdownList = Instance.new("Frame")
            dropdownList.Size = UDim2.new(0, 150, 0, 100)
            dropdownList.Position = UDim2.new(0.6, 5, 0, 35)
            dropdownList.BackgroundColor3 = LibrarySettings.Theme.Dropdown
            dropdownList.Visible = false
            dropdownList.Parent = dropdownFrame
            CreateRoundedCorner(dropdownList, 4)
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 2)
            listLayout.Parent = dropdownList
            
            for _, option in pairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, -10, 0, 30)
                optBtn.Position = UDim2.new(0, 5, 0, 0)
                optBtn.BackgroundColor3 = LibrarySettings.Theme.Background
                optBtn.Text = option
                optBtn.TextColor3 = LibrarySettings.Theme.Text
                optBtn.Font = LibrarySettings.Font
                optBtn.TextSize = LibrarySettings.TextSize
                optBtn.Parent = dropdownList
                CreateRoundedCorner(optBtn, 4)
                
                optBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = option
                    dropdownList.Visible = false
                    callback(option)
                end)
            end
            
            dropdownList.Size = UDim2.new(0, 150, 0, listLayout.AbsoluteContentSize.Y + 10)
            
            dropdownBtn.MouseButton1Click:Connect(function()
                dropdownList.Visible = not dropdownList.Visible
            end)
        end
    }
end

function Window:Destroy()
    self.ScreenGui:Destroy()
end

return C00lLibrary
