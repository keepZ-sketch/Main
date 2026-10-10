local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Membuat ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PelletTeleporterGUI"
ScreenGui.Parent = CoreGui 

-- 2. Membuat Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 140) 
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -70)
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
Title.Text = "Teleport Pellet & Feed"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- 4. Tombol Teleport & Auto Feed
local TpButton = Instance.new("TextButton")
TpButton.Size = UDim2.new(0, 160, 0, 40)
TpButton.Position = UDim2.new(0.5, -80, 0, 35)
TpButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200) 
TpButton.Text = "TP & Auto Feed"
TpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TpButton.Font = Enum.Font.GothamBold
TpButton.TextSize = 12
TpButton.Parent = MainFrame

local TpButtonCorner = Instance.new("UICorner")
TpButtonCorner.CornerRadius = UDim.new(0, 6)
TpButtonCorner.Parent = TpButton

-- 5. Tombol Kembali
local ReturnButton = Instance.new("TextButton")
ReturnButton.Size = UDim2.new(0, 160, 0, 40)
ReturnButton.Position = UDim2.new(0.5, -80, 0, 85)
ReturnButton.BackgroundColor3 = Color3.fromRGB(200, 150, 50) 
ReturnButton.Text = "Kembali ke Posisi Awal"
ReturnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReturnButton.Font = Enum.Font.GothamBold
ReturnButton.TextSize = 12
ReturnButton.Parent = MainFrame

local ReturnButtonCorner = Instance.new("UICorner")
ReturnButtonCorner.CornerRadius = UDim.new(0, 6)
ReturnButtonCorner.Parent = ReturnButton

local savedLocation = nil

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

-- Fungsi untuk mencari dan menekan tombol GUI "FEED MACHINE"
local function autoClickFeedMachine()
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    -- Mencari semua elemen di UI pemain
    for _, obj in pairs(playerGui:GetDescendants()) do
        -- Cek apakah teksnya mengandung FEED MACHINE
        local textStr = ""
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            textStr = string.upper(obj.Text)
        end

        if string.find(textStr, "FEED MACHINE") then
            -- Jika teks ada di TextLabel, tombolnya biasanya adalah Parent (ImageButton/TextButton)
            local targetButton = obj
            if obj:IsA("TextLabel") and obj.Parent and (obj.Parent:IsA("ImageButton") or obj.Parent:IsA("TextButton")) then
                targetButton = obj.Parent
            end

            -- Menggunakan fungsi eksploit untuk memicu klik
            if getconnections then
                for _, connection in pairs(getconnections(targetButton.MouseButton1Click)) do
                    connection:Fire()
                end
                for _, connection in pairs(getconnections(targetButton.Activated)) do
                    connection:Fire()
                end
            end
        end
    end
end

-- Logika Teleport & Feed
TpButton.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("ProximityPrompt") then
            -- Pengecekan teks khusus untuk Pellet Machine
            if string.find(string.upper(object.ObjectText), "PELLET MACHINE") then
                local targetLocation = getPromptLocation(object)
                
                if targetLocation then
                    savedLocation = hrp.CFrame
                    hrp.CFrame = targetLocation + Vector3.new(0, 3, 0)
                    
                    TpButton.Text = "Proses Feed..."
                    TpButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) 
                    
                    task.wait(0.5) -- Tunggu server memuat posisi
                    
                    -- 1. Buka Menu Mesin (Tekan Use)
                    if fireproximityprompt then
                        fireproximityprompt(object, 1, true)
                    end
                    
                    task.wait(1) -- Tunggu menu UI muncul di layar
                    
                    -- 2. Tekan tombol FEED MACHINE di GUI sebanyak 5 kali (bisa disesuaikan)
                    for i = 1, 5 do
                        autoClickFeedMachine()
                        task.wait(0.5) -- Jeda antar klik
                    end
                    
                    TpButton.Text = "Selesai!"
                    task.wait(1)
                    TpButton.Text = "TP & Auto Feed"
                    TpButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
                    
                    break
                end
            end
        end
    end
end)

ReturnButton.MouseButton1Click:Connect(function()
    if savedLocation then
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = savedLocation
            ReturnButton.Text = "Berhasil Kembali!"
            ReturnButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) 
            task.wait(1)
            ReturnButton.Text = "Kembali ke Posisi Awal"
            ReturnButton.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
        end
    end
end)
