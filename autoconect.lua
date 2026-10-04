local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local autoReconnectEnabled = true

if CoreGui:FindFirstChild("AutoReconnectUI") then
    CoreGui.AutoReconnectUI:Destroy()
end

-- ==========================================
-- MEMBUAT TAMPILAN UI
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoReconnectUI"
ScreenGui.Parent = CoreGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 160, 0, 40)
ToggleButton.Position = UDim2.new(1, -170, 1, -50)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 16
ToggleButton.Text = "Auto Reconnect: ON"
ToggleButton.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    autoReconnectEnabled = not autoReconnectEnabled
    if autoReconnectEnabled then
        ToggleButton.Text = "Auto Reconnect: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        ToggleButton.Text = "Auto Reconnect: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)

-- ==========================================
-- LOGIKA AUTO RECONNECT DENGAN RETRY LOOP
-- ==========================================
CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" and autoReconnectEnabled then
        print("Disconnect terdeteksi! Memulai sistem auto-retry...")
        
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Orange
        ToggleButton.Text = "Menunggu Internet..."
        
        -- Menggunakan task.spawn agar loop tidak menghentikan proses lain
        task.spawn(function()
            local attempts = 0
            while autoReconnectEnabled do
                attempts = attempts + 1
                ToggleButton.Text = "Mencoba ke-" .. attempts
                
                -- Jeda 10 detik setiap kali mencoba agar internet punya waktu untuk stabil
                task.wait(10) 
                
                -- Coba Teleport
                pcall(function()
                    if #Players:GetPlayers() <= 1 then
                        TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
                    else
                        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
                    end
                end)
            end
        end)
    end
end)

print("Auto-Reconnect dengan Sistem Retry Aktif!")
