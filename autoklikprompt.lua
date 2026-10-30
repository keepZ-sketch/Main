local player = game.Players.LocalPlayer
local guiParent = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Fallback jika executor tidak mendukung CoreGui
if not pcall(function() local _ = guiParent.Name end) then
    guiParent = player:WaitForChild("PlayerGui")
end

if guiParent:FindFirstChild("SimplePumpkinGUI") then
    guiParent.SimplePumpkinGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimplePumpkinGUI"
screenGui.Parent = guiParent

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0, 20) 
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextScaled = true
toggleButton.Text = "Auto Pumpkin: OFF"
toggleButton.Parent = screenGui

-- FITUR DRAGGABLE (Agar UI bisa digeser)
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    toggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = toggleButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

_G.AutoPumpkin = false
local noclipConnection

-- FUNGSI AUTO FARM
local function FarmPumpkins()
    while _G.AutoPumpkin do
        task.wait(0.1)
        pcall(function()
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = character.HumanoidRootPart

            for _, obj in ipairs(workspace:GetDescendants()) do
                if not _G.AutoPumpkin then break end
                
                if obj.Name == "Pumpkin" then
                    -- 1. Teleportasi ke Pumpkin
                    if obj:IsA("BasePart") then
                        hrp.CFrame = obj.CFrame
                    elseif obj:IsA("Model") and obj.PrimaryPart then
                        hrp.CFrame = obj.PrimaryPart.CFrame
                    end
                    
                    task.wait(0.5) 
                    
                    -- 2. Proses Hold Collect (Tahan E)
                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        prompt:InputHoldBegin()
                        
                        local holdTime = prompt.HoldDuration > 0 and prompt.HoldDuration or 5
                        task.wait(holdTime + 0.5)
                        
                        prompt:InputHoldEnd()
                        task.wait(0.5)
                    end
                end
            end
        end)
    end
end

-- LOGIKA KLIK TOMBOL & NOCLIP
toggleButton.MouseButton1Click:Connect(function()
    _G.AutoPumpkin = not _G.AutoPumpkin
    
    if _G.AutoPumpkin then
        toggleButton.Text = "Auto Pumpkin: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        
        -- Mengaktifkan Fitur Tembus Halangan (Noclip)
        if not noclipConnection then
            noclipConnection = RunService.Stepped:Connect(function()
                if player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
        
        task.spawn(FarmPumpkins)
    else
        toggleButton.Text = "Auto Pumpkin: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        
        -- Mematikan Noclip agar tubuh kembali normal
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end)
