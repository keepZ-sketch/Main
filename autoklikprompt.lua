local player = game.Players.LocalPlayer
local guiParent = game:GetService("CoreGui")

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

_G.AutoPumpkin = false

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
                    -- Teleportasi ke Pumpkin
                    if obj:IsA("BasePart") then
                        hrp.CFrame = obj.CFrame
                    elseif obj:IsA("Model") and obj.PrimaryPart then
                        hrp.CFrame = obj.PrimaryPart.CFrame
                    end
                    
                    -- Jeda 5 detik setelah teleport
                    task.wait(5) 
                    
                    -- Mencari dan mengeksekusi ProximityPrompt (Bypass Hold Duration)
                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        local originalDuration = prompt.HoldDuration
                        prompt.HoldDuration = 0 -- Paksa waktu tahan jadi 0 detik
                        fireproximityprompt(prompt)
                        task.wait(0.1)
                        prompt.HoldDuration = originalDuration -- Kembalikan normal
                    end
                end
            end
        end)
    end
end

toggleButton.MouseButton1Click:Connect(function()
    _G.AutoPumpkin = not _G.AutoPumpkin
    
    if _G.AutoPumpkin then
        toggleButton.Text = "Auto Pumpkin: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        task.spawn(FarmPumpkins)
    else
        toggleButton.Text = "Auto Pumpkin: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end)
