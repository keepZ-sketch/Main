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
MainFrame.Size = UDim2.new(0, 200, 0, 140) -- Ukuran ditinggikan untuk menampung 2 tombol
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
Title.Text = "Teleport Pellet"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- 4. Membuat Tombol Teleport ke Mesin
local TpButton = Instance.new("TextButton")
TpButton.Size = UDim2.new(0, 160, 0, 40)
TpButton.Position = UDim2.new(0.5, -80, 0, 35)
TpButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200) -- Warna Biru
TpButton.Text = "TP ke Pellet Machine"
TpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TpButton.Font = Enum.Font.GothamBold
TpButton.TextSize = 12
TpButton.Parent = MainFrame

local TpButtonCorner = Instance.new("UICorner")
TpButtonCorner.CornerRadius = UDim.new(0, 6)
TpButtonCorner.Parent = TpButton

-- 5. Membuat Tombol Kembali ke Posisi Awal
local ReturnButton = Instance.new("TextButton")
ReturnButton.Size = UDim2.new(0, 160, 0, 40)
ReturnButton.Position = UDim2.new(0.5, -80, 0, 85)
ReturnButton.BackgroundColor3 = Color3.fromRGB(200, 150, 50) -- Warna Oranye
ReturnButton.Text = "Kembali ke Posisi Awal"
ReturnButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ReturnButton.Font = Enum.Font.GothamBold
ReturnButton.TextSize = 12
ReturnButton.Parent = MainFrame

local ReturnButtonCorner = Instance.new("UICorner")
ReturnButtonCorner.CornerRadius = UDim.new(0, 6)
ReturnButtonCorner.Parent = ReturnButton

-- Variabel untuk menyimpan posisi sebelum teleport
local savedLocation = nil

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

-- Logika Tombol Teleport ke Mesin
TpButton.MouseButton1Click:Connect(function()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if not hrp then return end

    local foundMachine = false

    for _, object in ipairs(Workspace:GetDescendants()) do
        if object:IsA("ProximityPrompt") then
            -- Memastikan yang dicari adalah Pellet Machine
            if object.ObjectText == "Pellet Machine" and object.ActionText == "Use" then
                local targetLocation = getPromptLocation(object)
                
                if targetLocation then
                    -- 1. Simpan posisi pemain saat ini sebelum pindah
                    savedLocation = hrp.CFrame
                    
                    -- 2. Teleport ke mesin (ditambah jarak Y agar tidak tersangkut)
                    hrp.CFrame = targetLocation + Vector3.new(0, 3, 0)
                    foundMachine = true
                    
                    -- Efek visual sukses
                    local originalText = TpButton.Text
                    TpButton.Text = "Berhasil TP!"
                    TpButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Hijau
                    task.wait(1)
                    TpButton.Text = originalText
                    TpButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
                    
                    break
                end
            end
        end
    end
    
    if not foundMachine then
        -- Jika mesin belum dimuat di map
        local originalText = TpButton.Text
        TpButton.Text = "Mesin tidak ditemukan!"
        TpButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah
        task.wait(1)
        TpButton.Text = originalText
        TpButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
    end
end)

-- Logika Tombol Kembali
ReturnButton.MouseButton1Click:Connect(function()
    if savedLocation then
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            -- Teleport kembali ke lokasi yang disimpan
            hrp.CFrame = savedLocation
            
            -- Efek visual sukses
            local originalText = ReturnButton.Text
            ReturnButton.Text = "Berhasil Kembali!"
            ReturnButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Hijau
            task.wait(1)
            ReturnButton.Text = originalText
            ReturnButton.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
        end
    else
        -- Jika pemain memencet "Kembali" tapi belum pernah teleport sebelumnya
        local originalText = ReturnButton.Text
        ReturnButton.Text = "Belum ada posisi!"
        ReturnButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah
        task.wait(1)
        ReturnButton.Text = originalText
        ReturnButton.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    end
end)
