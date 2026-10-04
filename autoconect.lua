local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local autoReconnectEnabled = true

-- Mencegah duplikasi UI
if CoreGui:FindFirstChild("AutoReconnectUI") then
    CoreGui.AutoReconnectUI:Destroy()
end

-- ==========================================
-- MEMBUAT TAMPILAN UI (TOGGLE BUTTON)
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
-- LOGIKA AUTO RECONNECT (Support Error 279)
-- ==========================================
CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" and autoReconnectEnabled then
        -- Mengubah tombol untuk memberi tahu bahwa error terdeteksi
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Orange
        ToggleButton.Text = "Error 279/277 Detected!"
        
        print("Mendeteksi Error (seperti Code 279/277). Menunggu 5 detik untuk Reconnect...")
        
        task.wait(2)
        ToggleButton.Text = "Reconnecting..."
        
        task.wait(3) -- Sisa waktu tunggu (Total 5 detik)
        
        -- Proses Reconnect
        if #Players:GetPlayers() <= 1 then
            Players.LocalPlayer:Kick("\nRejoining Server...")
            task.wait()
            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
        end
    end
end)

print("Auto-Reconnect (Support Error 279) Aktif!")
