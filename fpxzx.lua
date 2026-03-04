repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

--==============================
-- LOW GRAPHIC FUNCTION
--==============================
local function LowGfx()
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.FogEnd = 9e9

    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end
        if v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
        if v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Smoke")
        or v:IsA("Fire")
        or v:IsA("Sparkles") then
            v.Enabled = false
        end
    end
end

-- AUTO ON SAAT MASUK
LowGfx()

-- HAPUS GUI LAMA
if playerGui:FindFirstChild("LowGfxGui") then
    playerGui.LowGfxGui:Destroy()
end

--==============================
-- GUI 1-TOMBOL DRAGGABLE
--==============================
local gui = Instance.new("ScreenGui")
gui.Name = "LowGfxGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0.2,0,0.07,0)
button.Position = UDim2.new(0.05,0,0.3,0)
button.Text = "LOW: ON"
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(0,170,0)
button.TextColor3 = Color3.new(1,1,1)
button.BorderSizePixel = 0
button.Active = true

local state = true
local hidden = false
local dragging = false
local dragStartPos, inputStartPos

-- Toggle LowGfx saat tap
button.MouseButton1Click:Connect(function()
    if not hidden and not dragging then
        state = not state
        if state then
            LowGfx()
            button.Text = "LOW: ON"
            button.BackgroundColor3 = Color3.fromRGB(0,170,0)
        else
            button.Text = "LOW: OFF"
            button.BackgroundColor3 = Color3.fromRGB(170,0,0)
        end
    end
end)

-- Drag & Touch support
button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        inputStartPos = input.Position
        dragStartPos = button.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - inputStartPos
        local newPos = UDim2.new(
            dragStartPos.X.Scale,
            dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale,
            dragStartPos.Y.Offset + delta.Y
        )
        button.Position = newPos
    end
end)

-- Long press untuk hide/show
local pressStart = 0
button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        pressStart = tick()
    end
end)

button.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local pressDuration = tick() - pressStart
        if pressDuration >= 1 then  -- tahan 1 detik untuk hide
            button.Visible = false
            hidden = true

            local showButton = Instance.new("TextButton")
            showButton.Name = "ShowButton"
            showButton.Parent = gui
            showButton.Size = UDim2.new(0.1,0,0.05,0)
            showButton.Position = button.Position
            showButton.Text = "□"
            showButton.Font = Enum.Font.GothamBold
            showButton.TextScaled = true
            showButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
            showButton.TextColor3 = Color3.new(1,1,1)
            showButton.BorderSizePixel = 0

            -- Drag support untuk showButton juga
            local showDragging = false
            local showDragStartPos, showInputStartPos

            showButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    showDragging = true
                    showInputStartPos = input.Position
                    showDragStartPos = showButton.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            showDragging = false
                        end
                    end)
                end
            end)

            showButton.InputChanged:Connect(function(input)
                if showDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                    local delta = input.Position - showInputStartPos
                    local newPos = UDim2.new(
                        showDragStartPos.X.Scale,
                        showDragStartPos.X.Offset + delta.X,
                        showDragStartPos.Y.Scale,
                        showDragStartPos.Y.Offset + delta.Y
                    )
                    showButton.Position = newPos
                end
            end)

            showButton.MouseButton1Click:Connect(function()
                button.Visible = true
                hidden = false
                showButton:Destroy()
            end)
        end
    end
end)
