local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 1. Membuat ScreenGui Utama (dengan perlindungan gethui jika executor mendukung)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeleportGuiList"
ScreenGui.ResetOnSpawn = false

local success, err = pcall(function()
    ScreenGui.Parent = (gethui and gethui()) or game.CoreGui
end)
if not success then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- 2. Membuat Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 350)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- 3. Membuat Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = " Player List Teleport"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BorderSizePixel = 0
Title.Parent = MainFrame

-- Tombol X (Close)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 4. Tombol Refresh
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, -20, 0, 30)
RefreshBtn.Position = UDim2.new(0, 10, 1, -40)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Text = "REFRESH LIST"
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 12
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Parent = MainFrame

-- 5. Membuat Scrolling Frame untuk Daftar Pemain
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -95)
ScrollFrame.Position = UDim2.new(0, 10, 0, 45)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.Parent = MainFrame

-- UIListLayout untuk menyusun tombol secara otomatis dari atas ke bawah
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- 6. Fungsi Teleport
local function teleportTo(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            -- Teleport dengan jarak 3 stud agar tidak stuck di dalam badan target
            myChar.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
    end
end

-- 7. Fungsi untuk Memperbarui Daftar Pemain
local function refreshList()
    -- Hapus tombol pemain lama
    for _, child in pairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local ySize = 0
    -- Ambil semua player di game
    for _, player in pairs(Players:GetPlayers()) do
        -- Jangan masukkan diri sendiri ke dalam list
        if player ~= LocalPlayer then
            local PlayerBtn = Instance.new("TextButton")
            PlayerBtn.Size = UDim2.new(1, -10, 0, 30)
            PlayerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            PlayerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            -- Format teks: DisplayName (@Username)
            PlayerBtn.Text = player.DisplayName .. " (@" .. player.Name .. ")"
            PlayerBtn.Font = Enum.Font.Gotham
            PlayerBtn.TextSize = 12
            PlayerBtn.BorderSizePixel = 0
            PlayerBtn.Parent = ScrollFrame

            -- Efek hover
            PlayerBtn.MouseEnter:Connect(function()
                PlayerBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            end)
            PlayerBtn.MouseLeave:Connect(function()
                PlayerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end)

            -- Event saat nama ditekan
            PlayerBtn.MouseButton1Click:Connect(function()
                teleportTo(player)
                PlayerBtn.Text = "Teleported!"
                PlayerBtn.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
                task.wait(0.5)
                PlayerBtn.Text = player.DisplayName .. " (@" .. player.Name .. ")"
                PlayerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end)

            -- Tambahkan ukuran Canvas untuk scroll
            ySize = ySize + 35
        end
    end
    -- Sesuaikan tinggi area scroll berdasarkan jumlah pemain
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ySize)
end

-- Hubungkan tombol refresh dengan fungsinya
RefreshBtn.MouseButton1Click:Connect(function()
    RefreshBtn.Text = "REFRESHING..."
    refreshList()
    task.wait(0.2)
    RefreshBtn.Text = "REFRESH LIST"
end)

-- Jalankan fungsi refresh pertama kali saat GUI dibuka
refreshList()
