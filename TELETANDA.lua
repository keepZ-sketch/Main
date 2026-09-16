local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Cek apakah GUI sebelumnya sudah ada agar tidak menumpuk
if CoreGui:FindFirstChild("AutoWaypointUI") then
    -- Bersihkan marker fisik yang lama sebelum menghapus GUI
    local oldGui = CoreGui:FindFirstChild("AutoWaypointUI")
    if oldGui:FindFirstChild("MarkerFolder") then
        oldGui.MarkerFolder:Destroy()
    end
    oldGui:Destroy()
end

-- Membuat ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoWaypointUI"
ScreenGui.ResetOnSpawn = false

-- Folder untuk menampung marker fisik agar mudah dibersihkan
local MarkerFolder = Instance.new("Folder")
MarkerFolder.Name = "MarkerFolder"
MarkerFolder.Parent = ScreenGui

-- Fallback jika dijalankan di executor vs Studio
local success, err = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Tombol Open (Untuk memunculkan GUI kembali)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 120, 0, 35)
OpenBtn.Position = UDim2.new(0, 10, 0, 10)
OpenBtn.Text = "Open Waypoint"
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 12
OpenBtn.BorderSizePixel = 0
OpenBtn.Visible = false -- Sembunyikan saat menu utama terbuka
OpenBtn.Parent = ScreenGui

-- Membuat Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 400)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Judul GUI
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 0, 40)
Title.Text = " Multi Waypoint GUI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BorderSizePixel = 0
Title.Parent = MainFrame

-- Tombol Hide (Sembunyikan GUI, ganti jadi tombol Open)
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0, 30, 0, 40)
HideBtn.Position = UDim2.new(1, -60, 0, 0)
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 50)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 16
HideBtn.BorderSizePixel = 0
HideBtn.Parent = MainFrame

-- Tombol Tutup Total (Close & Destroy GUI)
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

-- Variabel untuk menyimpan data (sekarang menyimpan CFrame dan Marker Fisik)
local waypoints = {}
local markerCount = 0

-- Fungsi membuat penanda visual di dunia 3D
local function createVisualMarker(cframe, name)
    -- Membuat part di lantai
    local part = Instance.new("Part")
    part.Size = Vector3.new(4, 0.2, 4)
    part.Anchored = true
    part.CanCollide = false
    part.Shape = Enum.PartType.Cylinder
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(0, 255, 100)
    part.Transparency = 0.5
    -- Menempatkan marker sedikit di bawah karakter (di bagian kaki)
    part.CFrame = cframe * CFrame.new(0, -2.5, 0) * CFrame.Angles(0, 0, math.rad(90))
    part.Parent = workspace
    
    -- Membuat teks melayang di atas marker
    local bgui = Instance.new("BillboardGui")
    bgui.Size = UDim2.new(0, 100, 0, 40)
    bgui.StudsOffset = Vector3.new(0, 3, 0)
    bgui.AlwaysOnTop = true
    bgui.Parent = part
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = name
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.Parent = bgui
    
    -- Masukkan ke folder untuk manajemen memori
    local objValue = Instance.new("ObjectValue")
    objValue.Name = name
    objValue.Value = part
    objValue.Parent = MarkerFolder
    
    return part
end

-- Fungsi untuk memperbarui tampilan daftar waypoint
local function refreshList()
    for _, child in ipairs(ListFrame:GetChildren()) do
        if child:IsA("Frame") then 
            child:Destroy() 
        end
    end

    local ySize = 0
    for name, data in pairs(waypoints) do
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
                char.HumanoidRootPart.CFrame = data.cframe
            end
        end)

        -- Logika Hapus
        DelBtn.MouseButton1Click:Connect(function()
            -- Menghapus objek fisik di map terlebih dahulu
            if data.marker and data.marker.Parent then
                data.marker:Destroy()
            end
            waypoints[name] = nil
            refreshList()
        end)

        ySize = ySize + 45
    end
    ListFrame.CanvasSize = UDim2.new(0, 0, 0, ySize)
end

-- Logika Tombol Tandai Otomatis
SaveBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        markerCount = markerCount + 1
        local autoName = "Tanda " .. tostring(markerCount)
        local targetCFrame = char.HumanoidRootPart.CFrame
        
        -- Memanggil fungsi pembuatan visual marker
        local visualMarker = createVisualMarker(targetCFrame, autoName)
        
        -- Menyimpan posisi dan marker ke dalam tabel
        waypoints[autoName] = {
            cframe = targetCFrame,
            marker = visualMarker
        }
        refreshList()
    end
end)

-- Logika Sembunyikan GUI
HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

-- Logika Munculkan GUI
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- Logika Tutup & Hapus Semua
CloseBtn.MouseButton1Click:Connect(function()
    -- Hapus semua marker fisik sebelum GUI ditutup
    for _, data in pairs(waypoints) do
        if data.marker and data.marker.Parent then
            data.marker:Destroy()
        end
    end
    ScreenGui:Destroy()
end)
