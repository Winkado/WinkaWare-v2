-- Gui to Lua
-- Version: 3.2

-- Instances:
if game.PlaceId == 621129760 then

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")
local TextButton_2 = Instance.new("TextButton")

--Properties:

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(81, 81, 81)
Frame.Position = UDim2.new(0.598262668, 0, 0.778491199, 0)
Frame.Size = UDim2.new(0, 357, 0, 125)
Frame.Active = true
Frame.Draggable = true


UICorner.Parent = Frame

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 3.000
TextLabel.Position = UDim2.new(0.14845939, 0, 0, 0)
TextLabel.Size = UDim2.new(0, 251, 0, 50)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Golden Cheat's Kat Scripts"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
TextButton.BorderColor3 = Color3.fromRGB(85, 255, 127)
TextButton.Position = UDim2.new(0.0280112047, 0, 0.448000014, 0)
TextButton.Size = UDim2.new(0, 163, 0, 45)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Main Script Lime X"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextWrapped = true
TextButton.MouseButton1Down:connect(function()
	Frame.Visible = false
	game.StarterGui:SetCore("SendNotification", {
		Title = "Lime X";
		Text = "Imagine Using Real King's Script #LimeXTheBest";
		Duration = 5;
	})
	
	loadstring(game:HttpGet("https://paste.ee/r/qgfTX/0", true))()
	
	end)
	
TextButton_2.Parent = Frame
TextButton_2.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
TextButton_2.BorderColor3 = Color3.fromRGB(85, 255, 0)
TextButton_2.Position = UDim2.new(0.509803951, 0, 0.448000014, 0)
TextButton_2.Size = UDim2.new(0, 163, 0, 45)
TextButton_2.Font = Enum.Font.SourceSans
TextButton_2.Text = "Real king's Kat Script Remake"
TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton_2.TextScaled = true
TextButton_2.TextSize = 14.000
TextButton_2.TextWrapped = true
TextButton_2.MouseButton1Down:connect(function()
	Frame.Visible = false
	loadstring(game:HttpGet("https://pastebin.com/raw/Wb2b0WB6", true))()

	game.StarterGui:SetCore("SendNotification", {
		Title = "Real king's Script Remake";
		Text = "Shit Script Remake Made By Golden Cheats";
		Duration = 5;
	})
end)

end