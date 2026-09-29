local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Membuat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoLifeMachineGUI"
ScreenGui.Parent = CoreGui 

-- 2. Membuat Frame Utama
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

-- 4. Membuat Tombol Toggle
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
local delayTime = 60 -- Jeda 1 menit untuk siklus pencarian

ToggleButton.MouseButton1Click:Connect(function()
    autoFarming = not autoFarming
    
    if autoFarming then
        ToggleButton.Text = "AUTO: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) 
        lastFiredTime = 0 
    else
        ToggleButton.Text = "AUTO: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) 
    end
end)

-- Fungsi untuk mendapatkan lokasi asli prompt
local function getPromptLocation(prompt)
    local parent = prompt.Parent
    if not parent then return nil end
    
    if parent:IsA("Attachment") then
        return parent.WorldCFrame 
    elseif parent:IsA("BasePart") then
        return parent.CFrame
    elseif parent:IsA("Model") then
        return parent:GetPivot()
    end
    return nil
end

-- Loop pengecekan
task.spawn(function()
    while task.wait(1) do 
        if autoFarming then
            if os.time() - lastFiredTime >= delayTime then
                
                for _, object in ipairs(Workspace:GetDescendants()) do
                    if object:IsA("ProximityPrompt") then
                        -- Memastikan hanya Life Machine yang dieksekusi
                        if object.ObjectText == "Life Machine" and object.ActionText == "Use" then
                            
                            local character = LocalPlayer.Character
                            local hrp = character and character:FindFirstChild("HumanoidRootPart")
                            local targetLocation = getPromptLocation(object)
                            
                            if hrp and targetLocation then
                                -- 1. Simpan posisi asli pemain
                                local originalCFrame = hrp.CFrame
                                
                                -- 2. Teleport ke mesin
                                hrp.CFrame = targetLocation + Vector3.new(0, 3, 0)
                                
                                -- Jeda agar server memuat posisi baru
                                task.wait(0.5) 
                                
                                -- 3. Tekan prompt 10x dengan jeda 1 detik
                                for i = 1, 10 do
                                    if not autoFarming then break end -- Berhenti jika tombol dimatikan di tengah jalan
                                    
                                    if fireproximityprompt then
                                        fireproximityprompt(object, 1, true)
                                    end
                                    task.wait(1) -- Jeda 1 detik setiap kali menekan
                                end
                                
                                -- Jeda sebentar sebelum kembali
                                task.wait(0.5)
                                
                                -- 4. Teleport kembali ke posisi semula
                                hrp.CFrame = originalCFrame
                                
                                break -- Selesai mengeksekusi mesin ini
                            end
                        end
                    end
                end
                
                -- Catat waktu siklus selesai
                lastFiredTime = os.time()
            end
        end
    end
end)
