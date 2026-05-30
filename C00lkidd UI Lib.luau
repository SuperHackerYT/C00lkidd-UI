-- C00lkidd GUI Style UI Library
-- Recreated to match the original c00lkidd GUI aesthetic

local C00lkiddLib = {}
C00lkiddLib.__index = C00lkiddLib

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- C00lkidd Color Constants (matching original)
local COLORS = {
    Background = Color3.fromRGB(255, 255, 255),
    TopBar = Color3.fromRGB(255, 0, 0),
    TopBarText = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(255, 0, 0),
    ButtonHover = Color3.fromRGB(200, 0, 0),
    ButtonText = Color3.fromRGB(255, 255, 255),
    PageButton = Color3.fromRGB(255, 50, 50),
    PageButtonSelected = Color3.fromRGB(180, 0, 0),
    PageButtonText = Color3.fromRGB(255, 255, 255),
    Separator = Color3.fromRGB(255, 0, 0),
    ScrollBar = Color3.fromRGB(255, 0, 0),
    CloseButton = Color3.fromRGB(180, 0, 0),
    MinimizeButton = Color3.fromRGB(220, 0, 0),
    Border = Color3.fromRGB(255, 0, 0),
    PageBackground = Color3.fromRGB(245, 245, 245),
    TabBackground = Color3.fromRGB(255, 255, 255),
    Shadow = Color3.fromRGB(200, 0, 0),
}

-- Rainbow effect for title (c00lkidd style)
local function createRainbowEffect(textLabel)
    local hue = 0
    RunService.Heartbeat:Connect(function()
        hue = (hue + 0.005) % 1
        textLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
    end)
end

-- Dragging function
local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
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

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
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

-- Create the main GUI
function C00lkiddLib.new(title)
    local self = setmetatable({}, C00lkiddLib)
    
    self.Pages = {}
    self.CurrentPage = nil
    self.Title = title or "c00lkidd gui"
    self.Minimized = false
    
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "C00lkiddGui"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = PlayerGui
    
    -- Shadow frame (behind main)
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(0, 408, 0, 508)
    shadow.Position = UDim2.new(0.5, -200, 0.5, -248)
    shadow.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Parent = self.ScreenGui
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 400, 0, 500)
    self.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    self.MainFrame.BackgroundColor3 = COLORS.Background
    self.MainFrame.BorderSizePixel = 3
    self.MainFrame.BorderColor3 = COLORS.Border
    self.MainFrame.ZIndex = 1
    self.MainFrame.Parent = self.ScreenGui
    
    -- Keep shadow synced with main frame
    self.MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
        shadow.Position = UDim2.new(
            self.MainFrame.Position.X.Scale,
            self.MainFrame.Position.X.Offset + 8,
            self.MainFrame.Position.Y.Scale,
            self.MainFrame.Position.Y.Offset + 8
        )
    end)
    
    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 35)
    topBar.Position = UDim2.new(0, 0, 0, 0)
    topBar.BackgroundColor3 = COLORS.TopBar
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 2
    topBar.Parent = self.MainFrame
    self.TopBar = topBar
    
    -- Title Label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -80, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = self.Title
    titleLabel.TextColor3 = COLORS.TopBarText
    titleLabel.TextScaled = false
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 3
    titleLabel.Parent = topBar
    self.TitleLabel = titleLabel
    
    -- Minimize Button (-)
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 30, 0, 25)
    minimizeBtn.Position = UDim2.new(1, -65, 0, 5)
    minimizeBtn.BackgroundColor3 = COLORS.MinimizeButton
    minimizeBtn.BorderSizePixel = 2
    minimizeBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.ZIndex = 3
    minimizeBtn.Parent = topBar
    
    -- Close Button (X)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 30, 0, 25)
    closeBtn.Position = UDim2.new(1, -33, 0, 5)
    closeBtn.BackgroundColor3 = COLORS.CloseButton
    closeBtn.BorderSizePixel = 2
    closeBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 3
    closeBtn.Parent = topBar
    
    -- Close button functionality
    closeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    -- Minimize functionality
    minimizeBtn.MouseButton1Click:Connect(function()
        self.Minimized = not self.Minimized
        if self.Minimized then
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 400, 0, 35)
            }):Play()
            TweenService:Create(shadow, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 408, 0, 43)
            }):Play()
            minimizeBtn.Text = "+"
        else
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 400, 0, 500)
            }):Play()
            TweenService:Create(shadow, TweenInfo.new(0.3), {
                Size = UDim2.new(0, 408, 0, 508)
            }):Play()
            minimizeBtn.Text = "-"
        end
    end)
    
    -- Button hover effects for top bar buttons
    minimizeBtn.MouseEnter:Connect(function()
        TweenService:Create(minimizeBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        }):Play()
    end)
    minimizeBtn.MouseLeave:Connect(function()
        TweenService:Create(minimizeBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = COLORS.MinimizeButton
        }):Play()
    end)
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.1), {
            BackgroundColor3 = COLORS.CloseButton
        }):Play()
    end)
    
    -- Tab Bar (page selector)
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 30)
    tabBar.Position = UDim2.new(0, 0, 0, 35)
    tabBar.BackgroundColor3 = Color3.fromRGB(220, 0, 0)
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 2
    tabBar.Parent = self.MainFrame
    self.TabBar = tabBar
    
    local tabBarLayout = Instance.new("UIListLayout")
    tabBarLayout.FillDirection = Enum.FillDirection.Horizontal
    tabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabBarLayout.Padding = UDim.new(0, 1)
    tabBarLayout.Parent = tabBar
    
    -- Content Frame (below tab bar)
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -65)
    contentFrame.Position = UDim2.new(0, 0, 0, 65)
    contentFrame.BackgroundColor3 = COLORS.PageBackground
    contentFrame.BorderSizePixel = 0
    contentFrame.ZIndex = 1
    contentFrame.Parent = self.MainFrame
    self.ContentFrame = contentFrame
    
    -- Red bottom bar (c00lkidd style detail)
    local bottomBar = Instance.new("Frame")
    bottomBar.Name = "BottomBar"
    bottomBar.Size = UDim2.new(1, 0, 0, 5)
    bottomBar.Position = UDim2.new(0, 0, 1, -5)
    bottomBar.BackgroundColor3 = COLORS.TopBar
    bottomBar.BorderSizePixel = 0
    bottomBar.ZIndex = 2
    bottomBar.Parent = self.MainFrame
    
    -- Make draggable via top bar
    makeDraggable(self.MainFrame, topBar)
    
    -- Sync shadow position on start
    shadow.Position = UDim2.new(
        self.MainFrame.Position.X.Scale,
        self.MainFrame.Position.X.Offset + 8,
        self.MainFrame.Position.Y.Scale,
        self.MainFrame.Position.Y.Offset + 8
    )
    
    return self
end

-- Add a page
function C00lkiddLib:AddPage(pageName)
    local page = {}
    page.Name = pageName
    page.Buttons = {}
    
    -- Tab button in the tab bar
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = pageName .. "Tab"
    tabBtn.Size = UDim2.new(0, 0, 1, 0)  -- Will auto size
    tabBtn.AutomaticSize = Enum.AutomaticSize.X
    tabBtn.BackgroundColor3 = COLORS.PageButton
    tabBtn.BorderSizePixel = 0
    tabBtn.Text = "  " .. pageName .. "  "
    tabBtn.TextColor3 = COLORS.PageButtonText
    tabBtn.TextSize = 13
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.ZIndex = 3
    tabBtn.LayoutOrder = #self.Pages + 1
    tabBtn.Parent = self.TabBar
    page.TabButton = tabBtn
    
    -- Page Frame (scrolling content area)
    local pageFrame = Instance.new("Frame")
    pageFrame.Name = pageName .. "Page"
    pageFrame.Size = UDim2.new(1, 0, 1, 0)
    pageFrame.Position = UDim2.new(0, 0, 0, 0)
    pageFrame.BackgroundTransparency = 1
    pageFrame.Visible = false
    pageFrame.ZIndex = 1
    pageFrame.Parent = self.ContentFrame
    page.Frame = pageFrame
    
    -- ScrollingFrame inside page
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScrollFrame"
    scrollFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = COLORS.ScrollBar
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.ZIndex = 1
    scrollFrame.Parent = pageFrame
    page.ScrollFrame = scrollFrame
    
    -- Layout for buttons
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Parent = scrollFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = scrollFrame
    
    -- Tab click event
    tabBtn.MouseButton1Click:Connect(function()
        self:SelectPage(pageName)
    end)
    
    tabBtn.MouseEnter:Connect(function()
        if self.CurrentPage ~= pageName then
            TweenService:Create(tabBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            }):Play()
        end
    end)
    tabBtn.MouseLeave:Connect(function()
        if self.CurrentPage ~= pageName then
            TweenService:Create(tabBtn, TweenInfo.new(0.1), {
                BackgroundColor3 = COLORS.PageButton
            }):Play()
        end
    end)
    
    self.Pages[pageName] = page
    
    -- Auto select first page
    if not self.CurrentPage then
        self:SelectPage(pageName)
    end
    
    -- Return page object for chaining
    return setmetatable(page, {
        __index = function(t, k)
            if k == "AddButton" then
                return function(_, ...)
                    return C00lkiddLib.AddButton(self, pageName, ...)
                end
            elseif k == "AddSeparator" then
                return function(_, ...)
                    return C00lkiddLib.AddSeparator(self, pageName, ...)
                end
            elseif k == "AddLabel" then
                return function(_, ...)
                    return C00lkiddLib.AddLabel(self, pageName, ...)
                end
            end
        end
    })
end

-- Select a page
function C00lkiddLib:SelectPage(pageName)
    for name, page in pairs(self.Pages) do
        page.Frame.Visible = false
        TweenService:Create(page.TabButton, TweenInfo.new(0.1), {
            BackgroundColor3 = COLORS.PageButton
        }):Play()
    end
    
    if self.Pages[pageName] then
        self.Pages[pageName].Frame.Visible = true
        TweenService:Create(self.Pages[pageName].TabButton, TweenInfo.new(0.1), {
            BackgroundColor3 = COLORS.PageButtonSelected
        }):Play()
        self.CurrentPage = pageName
    end
end

-- Add a button to a page
function C00lkiddLib:AddButton(pageName, buttonText, callback)
    local page = self.Pages[pageName]
    if not page then return end
    
    callback = callback or function() end
    
    -- Button container
    local btnContainer = Instance.new("Frame")
    btnContainer.Name = buttonText .. "Container"
    btnContainer.Size = UDim2.new(1, -16, 0, 32)
    btnContainer.BackgroundTransparency = 1
    btnContainer.LayoutOrder = #page.Buttons + 1
    btnContainer.ZIndex = 2
    btnContainer.Parent = page.ScrollFrame
    
    -- Shadow for button
    local btnShadow = Instance.new("Frame")
    btnShadow.Name = "BtnShadow"
    btnShadow.Size = UDim2.new(1, 2, 1, 2)
    btnShadow.Position = UDim2.new(0, 2, 0, 2)
    btnShadow.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    btnShadow.BorderSizePixel = 0
    btnShadow.ZIndex = 2
    btnShadow.Parent = btnContainer
    
    -- The actual button
    local btn = Instance.new("TextButton")
    btn.Name = buttonText
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.BackgroundColor3 = COLORS.Button
    btn.BorderSizePixel = 0
    btn.Text = buttonText
    btn.TextColor3 = COLORS.ButtonText
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    btn.Parent = btnContainer
    
    -- Rounded corners (slight, like original)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = btn
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 3)
    shadowCorner.Parent = btnShadow
    
    -- Left accent bar (c00lkidd style detail)
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Size = UDim2.new(0, 5, 1, 0)
    accent.Position = UDim2.new(0, 0, 0, 0)
    accent.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    accent.BorderSizePixel = 0
    accent.ZIndex = 4
    accent.Parent = btn
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 3)
    accentCorner.Parent = accent
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = COLORS.ButtonHover
        }):Play()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            Position = UDim2.new(0, -2, 0, -2)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            BackgroundColor3 = COLORS.Button
        }):Play()
        TweenService:Create(btn, TweenInfo.new(0.1), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
    end)
    
    -- Click effect
    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.05), {
            BackgroundColor3 = Color3.fromRGB(150, 0, 0),
            Position = UDim2.new(0, 2, 0, 2)
        }):Play()
    end)
    
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.05), {
            BackgroundColor3 = COLORS.ButtonHover,
            Position = UDim2.new(0, -2, 0, -2)
        }):Play()
    end)
    
    -- Click callback
    btn.MouseButton1Click:Connect(function()
        local success, err = pcall(callback)
        if not success then
            warn("C00lkidd GUI Button Error: " .. tostring(err))
        end
    end)
    
    table.insert(page.Buttons, btn)
    
    return btn
end

-- Add a separator/divider
function C00lkiddLib:AddSeparator(pageName, labelText)
    local page = self.Pages[pageName]
    if not page then return end
    
    -- Separator container
    local sepContainer = Instance.new("Frame")
    sepContainer.Name = "Separator"
    sepContainer.Size = UDim2.new(1, -16, 0, 20)
    sepContainer.BackgroundTransparency = 1
    sepContainer.LayoutOrder = #page.Buttons + 1
    sepContainer.ZIndex = 2
    sepContainer.Parent = page.ScrollFrame
    
    -- Left line
    local leftLine = Instance.new("Frame")
    leftLine.Size = UDim2.new(0.4, 0, 0, 2)
    leftLine.Position = UDim2.new(0, 0, 0.5, -1)
    leftLine.BackgroundColor3 = COLORS.Separator
    leftLine.BorderSizePixel = 0
    leftLine.ZIndex = 2
    leftLine.Parent = sepContainer
    
    if labelText and labelText ~= "" then
        -- Center text
        local sepLabel = Instance.new("TextLabel")
        sepLabel.Size = UDim2.new(0.2, 0, 1, 0)
        sepLabel.Position = UDim2.new(0.4, 0, 0, 0)
        sepLabel.BackgroundTransparency = 1
        sepLabel.Text = labelText
        sepLabel.TextColor3 = COLORS.Separator
        sepLabel.TextSize = 11
        sepLabel.Font = Enum.Font.GothamBold
        sepLabel.ZIndex = 2
        sepLabel.Parent = sepContainer
        
        -- Right line
        local rightLine = Instance.new("Frame")
        rightLine.Size = UDim2.new(0.4, 0, 0, 2)
        rightLine.Position = UDim2.new(0.6, 0, 0.5, -1)
        rightLine.BackgroundColor3 = COLORS.Separator
        rightLine.BorderSizePixel = 0
        rightLine.ZIndex = 2
        rightLine.Parent = sepContainer
    else
        leftLine.Size = UDim2.new(1, 0, 0, 2)
    end
    
    table.insert(page.Buttons, sepContainer)
end

-- Add a label
function C00lkiddLib:AddLabel(pageName, labelText)
    local page = self.Pages[pageName]
    if not page then return end
    
    local labelContainer = Instance.new("Frame")
    labelContainer.Name = "Label"
    labelContainer.Size = UDim2.new(1, -16, 0, 25)
    labelContainer.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    labelContainer.BorderSizePixel = 0
    labelContainer.LayoutOrder = #page.Buttons + 1
    labelContainer.ZIndex = 2
    labelContainer.Parent = page.ScrollFrame
    
    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 3)
    labelCorner.Parent = labelContainer
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = ">> " .. labelText .. " <<"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.ZIndex = 3
    label.Parent = labelContainer
    
    table.insert(page.Buttons, labelContainer)
end

-- Enable rainbow title (c00lkidd signature style)
function C00lkiddLib:EnableRainbowTitle()
    createRainbowEffect(self.TitleLabel)
end

-- Destroy the GUI
function C00lkiddLib:Destroy()
    self.ScreenGui:Destroy()
end

return C00lkiddLib
