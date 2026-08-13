local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")

-- ==========================================
-- 1. PEMBUATAN GUI
-- ==========================================
local MyGui = Instance.new("ScreenGui")
MyGui.Name = "UtilityGuiMAX"
MyGui.ResetOnSpawn = false

-- Fallback jika CoreGui tidak bisa diakses
local success = pcall(function()
    MyGui.Parent = CoreGui
end)
if not success then
    MyGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Tombol Toggle (Hide/Show Menu)
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

-- Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 170)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -85)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser
MainFrame.BorderSizePixel = 2
MainFrame.Parent = MyGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Utility Hub (SUPER MAX)"
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = MainFrame

-- Tombol Anti-AFK
local AfkBtn = Instance.new("TextButton")
AfkBtn.Size = UDim2.new(0, 180, 0, 40)
AfkBtn.Position = UDim2.new(0, 20, 0, 50)
AfkBtn.Text = "Anti-AFK: OFF"
AfkBtn.Font = Enum.Font.SourceSansBold
AfkBtn.TextSize = 16
AfkBtn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
AfkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AfkBtn.Parent = MainFrame

-- Tombol FPS Boost MAX
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
-- 2. LOGIC SCRIPT
-- ==========================================

-- Toggle Hide/Show
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Anti-AFK Logic
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

-- Reduce Map SUPER MAX Extreme
local mapReduced = false
BoostBtn.MouseButton1Click:Connect(function()
    if mapReduced then return end
    mapReduced = true
    
    BoostBtn.Text = "Map Reduced! (MAX)"
    BoostBtn.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
    
    -- 1. Paksa Engine Grafik ke Level Terendah
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
    end)
    
    -- 2. Hancurkan Lighting, Efek Cuaca, dan Kabut
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    for _, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("PostEffect") or v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
            pcall(function() v:Destroy() end)
        end
    end
    
    -- 3. Hapus Rumput & Efek Air Asli
    local Terrain = workspace:FindFirstChildOfClass('Terrain')
    if Terrain then
        pcall(function()
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterReflectance = 0
            Terrain.WaterTransparency = 1
            Terrain.Decoration = false -- Hilangkan rumput
        end)
    end
    
    -- 4. FUNGSI UTAMA (Penghancur Objek Lag & Air Terjun)
    local function optimizePart(v)
        -- Daftar efek visual dan air terjun (Beam dll) untuk dihapus
        local toDestroy = {
            "ParticleEmitter", "Trail", "Smoke", "Fire", "Sparkles", 
            "Decal", "Texture", "Beam", "PointLight", "SpotLight", 
            "SurfaceGui", "BillboardGui"
        }
        
        for _, className in pairs(toDestroy) do
            if v:IsA(className) then
                pcall(function() v:Destroy() end)
            end
        end

        -- Hapus objek secara paksa jika namanya mengandung kata "water" atau "fall" (Biasanya untuk efek air buatan)
        if v:IsA("BasePart") then
            local name = string.lower(v.Name)
            if string.find(name, "water") or string.find(name, "fall") then
                pcall(function() v:Destroy() end)
                return -- Berhenti memproses part ini karena sudah hancur
            end
            
            -- Buat rata/kentang
            pcall(function()
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            end)
        end
        
        -- Hapus tekstur pada MeshPart (MeshId di MeshPart tidak bisa diubah via script, jadi kita hapus teksturnya saja)
        if v:IsA("MeshPart") then
            pcall(function() v.TextureID = "" end)
        end
        
        -- Hapus bentuk 3D rumit pada SpecialMesh
        if v:IsA("SpecialMesh") then
            pcall(function()
                v.TextureId = ""
                v.MeshId = ""
            end)
        end
    end
    
    -- 5. Eksekusi ke seluruh part yang sudah ada di map
    for _, v in pairs(workspace:GetDescendants()) do
        optimizePart(v)
    end
    
    -- 6. Eksekusi otomatis jika ada map/air terjun baru yang muncul saat kamu berjalan
    workspace.DescendantAdded:Connect(function(v)
        task.wait() -- Tunggu sebentar agar game meregistrasi objek
        optimizePart(v)
    end)
end)
