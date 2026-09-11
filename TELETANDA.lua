-- Memuat layanan yang dibutuhkan
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Cek apakah GUI sebelumnya sudah ada agar tidak menumpuk
if CoreGui:FindFirstChild("AutoWaypointUI") then
    CoreGui.AutoWaypointUI:Destroy()
end

-- Membuat ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoWaypointUI"
ScreenGui.ResetOnSpawn = false

-- Fallback jika dijalankan di executor vs Studio
local success, err = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Membuat Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser di layar
MainFrame.Parent = ScreenGui

-- Judul GUI
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 40)
Title.Text = " Multi Waypoint GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BorderSizePixel = 0
Title.Parent = MainFrame

-- Tombol Tutup (Close GUI)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 40)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = MainFrame

-- Tombol Tandai (Langsung klik tanpa ngetik)
local SaveBtn = Instance.new("TextButton")
SaveBtn.Size = UDim2.new(1, -20, 0, 35)
SaveBtn.Position = UDim2.new(0, 10, 0, 50)
SaveBtn.Text = "+ Tandai Lokasi Saat Ini"
SaveBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveBtn.Font = Enum.Font.GothamBold
SaveBtn.TextSize = 14
SaveBtn.BorderSizePixel = 0
SaveBtn.Parent = MainFrame

-- Tempat List Waypoint
local ListFrame = Instance.new("ScrollingFrame")
ListFrame.Size = UDim2.new(1, -20, 1, -100)
ListFrame.Position = UDim2.new(0, 10, 0, 95)
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ListFrame.ScrollBarThickness = 6
ListFrame.BorderSizePixel = 0
ListFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ListFrame
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Variabel untuk menyimpan data
local waypoints = {}
local markerCount = 0 -- Penghitung otomatis

-- Fungsi untuk memperbarui tampilan daftar waypoint
local function refreshList()
    -- Hapus item lama yang tampil
    for _, child in ipairs(ListFrame:GetChildren()) do
        if child:IsA("Frame") then 
            child:Destroy() 
        end
    end

    local ySize = 0
    -- Buat UI untuk setiap waypoint yang ada di tabel
    for name, cf in pairs(waypoints) do
        local ItemFrame = Instance.new("Frame")
        ItemFrame.Size = UDim2.new(1, -10, 0, 40)
        ItemFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        ItemFrame.BorderSizePixel = 0
        ItemFrame.Parent = ListFrame

        local ItemName = Instance.new("TextLabel")
        ItemName.Size = UDim2.new(0, 120, 1, 0)
        ItemName.Position = UDim2.new(0, 10, 0, 0)
        ItemName.Text = name
        ItemName.TextColor3 = Color3.fromRGB(255, 255, 255)
        ItemName.BackgroundTransparency = 1
        ItemName.TextXAlignment = Enum.TextXAlignment.Left
        ItemName.Font = Enum.Font.GothamBold
        ItemName.TextSize = 14
        ItemName.Parent = ItemFrame

        -- Tombol Teleport ke tanda
        local TPBtn = Instance.new("TextButton")
        TPBtn.Size = UDim2.new(0, 60, 0, 30)
        TPBtn.Position = UDim2.new(0, 140, 0, 5)
        TPBtn.Text = "Teleport"
        TPBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
        TPBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TPBtn.Font = Enum.Font.GothamBold
        TPBtn.TextSize = 12
        TPBtn.BorderSizePixel = 0
        TPBtn.Parent = ItemFrame

        -- Tombol Hapus tanda
        local DelBtn = Instance.new("TextButton")
        DelBtn.Size = UDim2.new(0, 60, 0, 30)
        DelBtn.Position = UDim2.new(0, 210, 0, 5)
        DelBtn.Text = "Hapus"
        DelBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        DelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        DelBtn.Font = Enum.Font.GothamBold
        DelBtn.TextSize = 12
        DelBtn.BorderSizePixel = 0
        DelBtn.Parent = ItemFrame

        -- Logika Teleport
        TPBtn.MouseButton1Click:Connect(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = cf
            end
        end)

        -- Logika Hapus
        DelBtn.MouseButton1Click:Connect(function()
            waypoints[name] = nil
            refreshList()
        end)

        ySize = ySize + 45
    end
    -- Sesuaikan ukuran scroll
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, ySize)
end

-- Logika Tombol Tandai Otomatis
SaveBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        markerCount = markerCount + 1 -- Tambah nomor urut
        local autoName = "Tanda " .. tostring(markerCount)
        
        -- Menyimpan posisi
        waypoints[autoName] = char.HumanoidRootPart.CFrame
        refreshList()
    end
end)

-- Logika Tutup GUI
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
