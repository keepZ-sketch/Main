local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- 1. Membuat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoLifeMachineGUI"
ScreenGui.Parent = CoreGui 

-- 2. Membuat Frame Utama (Bisa didrag)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = MainFrame

-- 3. Membuat Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Auto Life Machine"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- 4. Membuat Tombol Toggle (ON/OFF)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 160, 0, 40)
ToggleButton.Position = UDim2.new(0.5, -80, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Text = "AUTO: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

-- 5. Logika Script
local autoFarming = false
local lastFiredTime = 0
local delayTime = 60 -- Delay dalam detik (60 detik = 1 menit)

ToggleButton.MouseButton1Click:Connect(function()
    autoFarming = not autoFarming
    
    if autoFarming then
        ToggleButton.Text = "AUTO: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) 
        lastFiredTime = 0 -- Reset waktu agar langsung berinteraksi saat dinyalakan
    else
        ToggleButton.Text = "AUTO: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) 
    end
end)

-- Loop pengecekan
task.spawn(function()
    while task.wait(1) do -- Loop berjalan setiap 1 detik agar UI tetap responsif
        if autoFarming then
            -- Cek apakah waktu saat ini dikurangi waktu terakhir klik sudah mencapai 60 detik
            if os.time() - lastFiredTime >= delayTime then
                
                -- Mencari dan menekan prompt
                for _, object in ipairs(Workspace:GetDescendants()) do
                    if object:IsA("ProximityPrompt") then
                        if object.ObjectText == "Life Machine" or object.ActionText == "Use" then
                            if fireproximityprompt then
                                fireproximityprompt(object, 1, true)
                            end
                        end
                    end
                end
                
                -- Catat waktu setelah berhasil menekan
                lastFiredTime = os.time()
            end
        end
    end
end)
