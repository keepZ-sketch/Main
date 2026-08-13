local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

-- 1. Membuat ScreenGui
local MyGui = Instance.new("ScreenGui")
MyGui.Name = "UtilityGuiMAX"
local success = pcall(function()
    MyGui.Parent = CoreGui
end)
if not success then
    MyGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- 2. Tombol Toggle (Hide/Show Menu)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 40)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "MENU"
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 18
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.BorderSizePixel = 2
ToggleBtn.Parent = MyGui

-- 3. Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 170)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -85)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.BorderSizePixel = 2
MainFrame.Parent = MyGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Utility Hub (MAX)"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

-- 4. Tombol Anti-AFK
local AfkBtn = Instance.new("TextButton")
AfkBtn.Size = UDim2.new(0, 180, 0, 40)
AfkBtn.Position = UDim2.new(0, 20, 0, 50)
AfkBtn.Text = "Anti-AFK: OFF"
AfkBtn.Font = Enum.Font.SourceSansBold
AfkBtn.TextSize = 16
AfkBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
AfkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AfkBtn.Parent = MainFrame

-- 5. Tombol FPS Boost MAX
local BoostBtn = Instance.new("TextButton")
BoostBtn.Size = UDim2.new(0, 180, 0, 40)
BoostBtn.Position = UDim2.new(0, 20, 0, 105)
BoostBtn.Text = "Reduce Map (MAX)"
BoostBtn.Font = Enum.Font.SourceSansBold
BoostBtn.TextSize = 16
BoostBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
BoostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BoostBtn.Parent = MainFrame

-- ==========================================
-- LOGIC SCRIPT
-- ==========================================

-- Toggle Hide/Show
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Anti-AFK
local antiAfkEnabled = false
AfkBtn.MouseButton1Click:Connect(function()
    antiAfkEnabled = not antiAfkEnabled
    if antiAfkEnabled then
        AfkBtn.Text = "Anti-AFK: ON"
        AfkBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
    else
        AfkBtn.Text = "Anti-AFK: OFF"
        AfkBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
    end
end)

Players.LocalPlayer.Idled:Connect(function()
    if antiAfkEnabled then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- Reduce Map MAX Extreme
local mapReduced = false
BoostBtn.MouseButton1Click:Connect(function()
    if mapReduced then return end
    mapReduced = true
    
    BoostBtn.Text = "Map Reduced! (MAX)"
    BoostBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
    
    -- 1. Paksa Grafik ke Level 1 dari sistem Engine
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
    end)
    
    -- 2. Hancurkan semua efek visual Lighting & Langit
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    for _, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
            v:Destroy()
        end
    end
    
    -- 3. Hapus Rumput & Efek Air dari Terrain
    local Terrain = workspace:FindFirstChildOfClass('Terrain')
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1
        Terrain.Decoration = false -- Menghilangkan rumput 3D
    end
    
    -- 4. Fungsi Utama Penghancur Lag
    local function optimizePart(v)
        -- Ubah Part biasa
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
        end
        -- Hapus tekstur dari model 3D (Mesh)
        if v:IsA("MeshPart") then
            v.TextureID = ""
        end
        if v:IsA("SpecialMesh") then
            v.TextureId = ""
        end
        -- Hapus total dari memori (bukan sekadar diubah transparansinya)
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v:Destroy()
        end
    end
    
    -- 5. Terapkan ke semua yang ada di map saat ini
    for _, v in pairs(workspace:GetDescendants()) do
        optimizePart(v)
    end
    
    -- 6. Terapkan ke map yang baru muncul (Auto-optimize untuk game berat / besar)
    workspace.DescendantAdded:Connect(function(v)
        task.wait() -- Tunggu sepersekian detik agar game mendata objeknya dulu
        optimizePart(v)
    end)
end)
