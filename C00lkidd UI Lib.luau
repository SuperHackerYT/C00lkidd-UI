-- Retro C00lkidd-Style UI Library
local Library = {}

function Library:Create(title)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "C00lkiddGUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 450, 0, 300)
	Main.Position = UDim2.new(0.5, -225, 0.5, -150)
	Main.BackgroundColor3 = Color3.fromRGB(180,180,180)
	Main.BorderSizePixel = 2
	Main.Parent = ScreenGui

	local Title = Instance.new("TextLabel")
	Title.Size = UDim2.new(1,0,0,25)
	Title.BackgroundColor3 = Color3.fromRGB(120,120,120)
	Title.BorderSizePixel = 2
	Title.Text = title or "c00lkidd"
	Title.TextColor3 = Color3.new(0,0,0)
	Title.Font = Enum.Font.Legacy
	Title.TextSize = 14
	Title.Parent = Main

	local Tabs = Instance.new("Frame")
	Tabs.Size = UDim2.new(0,100,1,-25)
	Tabs.Position = UDim2.new(0,0,0,25)
	Tabs.BackgroundColor3 = Color3.fromRGB(160,160,160)
	Tabs.BorderSizePixel = 2
	Tabs.Parent = Main

	local Content = Instance.new("Frame")
	Content.Size = UDim2.new(1,-100,1,-25)
	Content.Position = UDim2.new(0,100,0,25)
	Content.BackgroundColor3 = Color3.fromRGB(200,200,200)
	Content.BorderSizePixel = 2
	Content.Parent = Main

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Parent = Tabs

	local Window = {}
	local FirstPage

	function Window:Page(name)
		local Page = Instance.new("Frame")
		Page.Size = UDim2.new(1,0,1,0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.Parent = Content

		local Layout = Instance.new("UIListLayout")
		Layout.Padding = UDim.new(0,2)
		Layout.Parent = Page

		local TabButton = Instance.new("TextButton")
		TabButton.Size = UDim2.new(1,0,0,25)
		TabButton.Text = name
		TabButton.Font = Enum.Font.Legacy
		TabButton.TextSize = 14
		TabButton.TextColor3 = Color3.new(0,0,0)
		TabButton.BackgroundColor3 = Color3.fromRGB(210,210,210)
		TabButton.BorderSizePixel = 2
		TabButton.Parent = Tabs

		if not FirstPage then
			FirstPage = Page
			Page.Visible = true
		end

		TabButton.MouseButton1Click:Connect(function()
			for _,v in pairs(Content:GetChildren()) do
				if v:IsA("Frame") then
					v.Visible = false
				end
			end
			Page.Visible = true
		end)

		local PageFunctions = {}

		function PageFunctions:Button(text, callback)
			local Button = Instance.new("TextButton")
			Button.Size = UDim2.new(1,-4,0,25)
			Button.Text = text
			Button.Font = Enum.Font.Legacy
			Button.TextSize = 14
			Button.TextColor3 = Color3.new(0,0,0)
			Button.BackgroundColor3 = Color3.fromRGB(230,230,230)
			Button.BorderSizePixel = 2
			Button.Parent = Page

			Button.MouseButton1Click:Connect(function()
				if callback then
					callback()
				end
			end)
		end

		return PageFunctions
	end

	return Window
end

return Library
