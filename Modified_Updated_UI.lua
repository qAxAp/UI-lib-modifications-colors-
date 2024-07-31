
-- DrRayLibrary UI Library

local DrRayLibrary = {}

function DrRayLibrary:Load(title, theme)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.Name = title

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
    MainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0.1, 0)
    Title.Text = title
    Title.Parent = MainFrame

    local TabFrame = Instance.new("Frame")
    TabFrame.Size = UDim2.new(1, 0, 0.9, 0)
    TabFrame.Position = UDim2.new(0, 0, 0.1, 0)
    TabFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    TabFrame.Parent = MainFrame

    DrRayLibrary.MainFrame = MainFrame
    DrRayLibrary.TabFrame = TabFrame
    DrRayLibrary.Tabs = {}

    return DrRayLibrary
end

function DrRayLibrary.newTab(name, imageId)
    local tab = Instance.new("Frame")
    tab.Name = name
    tab.Size = UDim2.new(1, 0, 1, 0)
    tab.BackgroundTransparency = 1
    tab.Visible = false
    tab.Parent = DrRayLibrary.TabFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.2, 0, 0.1, 0)
    button.Text = name
    button.Parent = DrRayLibrary.MainFrame
    button.MouseButton1Click:Connect(function()
        for _, t in pairs(DrRayLibrary.Tabs) do
            t.Visible = false
        end
        tab.Visible = true
    end)

    table.insert(DrRayLibrary.Tabs, tab)

    return tab
end

function DrRayLibrary.newButton(tab, name, description, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0.1, 0)
    button.Position = UDim2.new(0.1, 0, 0.1 + (#tab:GetChildren() * 0.15), 0)
    button.Text = name
    button.Parent = tab
    button.MouseButton1Click:Connect(callback)
end

function DrRayLibrary.newSlider(tab, name, description, max, isInteger, callback)
    local slider = Instance.new("TextLabel")
    slider.Size = UDim2.new(0.8, 0, 0.1, 0)
    slider.Position = UDim2.new(0.1, 0, 0.1 + (#tab:GetChildren() * 0.15), 0)
    slider.Text = name
    slider.Parent = tab

    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(0.8, 0, 0.1, 0)
    sliderBar.Position = UDim2.new(0.1, 0, 0.25 + (#tab:GetChildren() * 0.15), 0)
    sliderBar.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    sliderBar.Parent = tab

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0.05, 0, 1, 0)
    sliderButton.BackgroundColor3 = Color3.new(1, 0, 0)
    sliderButton.Parent = sliderBar

    local function updateSlider(input)
        local position = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
        local value = (position / sliderBar.AbsoluteSize.X) * max
        if isInteger then value = math.floor(value) end
        sliderButton.Position = UDim2.new(position / sliderBar.AbsoluteSize.X, 0, 0, 0)
        callback(value)
    end

    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
            local moveConnection
            moveConnection = game:GetService("UserInputService").InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    updateSlider(input)
                end
            end)
            local releaseConnection
            releaseConnection = game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    moveConnection:Disconnect()
                    releaseConnection:Disconnect()
                end
            end)
        end
    end)
end

function DrRayLibrary.newTextBox(tab, name, placeholder, width, height)
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, width, 0, height)
    textBox.Position = UDim2.new(0.1, 0, 0.1 + (#tab:GetChildren() * 0.15), 0)
    textBox.PlaceholderText = placeholder
    textBox.Text = ""
    textBox.TextWrapped = true
    textBox.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
    textBox.Parent = tab

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.8, 0, 0.1, 0)
    label.Position = UDim2.new(0.1, 0, textBox.Position.Y.Scale - 0.1, 0)
    label.Text = name
    label.Parent = tab

    return textBox
end

return DrRayLibrary
