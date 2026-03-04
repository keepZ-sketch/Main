repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

--==============================
-- EXTREME LOW GRAPHIC FUNCTION
--==============================
local function SuperLowGfx()

    -- LIGHTING HARD RESET
    Lighting.GlobalShadows = false
    Lighting.Brightness = 0
    Lighting.FogEnd = 9e9
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    -- HAPUS SEMUA EFFECT DI LIGHTING
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") 
        or v:IsA("BloomEffect")
        or v:IsA("BlurEffect")
        or v:IsA("ColorCorrectionEffect")
        or v:IsA("SunRaysEffect")
        or v:IsA("DepthOfFieldEffect")
        or v:IsA("Atmosphere") then
            v:Destroy()
        end
    end

    -- TERRAIN SIMPLE
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1
    end

    -- WORKSPACE OPTIMIZE
    for _, v in pairs(workspace:GetDescendants()) do
        
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            v.CastShadow = false
        end

        if v:IsA("Decal") 
        or v:IsA("Texture") then
            v:Destroy()
        end

        if v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Smoke")
        or v:IsA("Fire")
        or v:IsA("Sparkles")
        or v:IsA("Explosion") then
            v:Destroy()
        end

        if v:IsA("Beam") then
            v.Enabled = false
        end

        if v:IsA("SpecialMesh") then
            v.TextureId = ""
        end
    end

    -- OPTIONAL: SET GRAPHIC LEVEL PALING RENDAH
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end

-- AUTO AKTIF
SuperLowGfx()

-- HAPUS GUI LAMA
if playerGui:FindFirstChild("LowGfxGui") then
    playerGui.LowGfxGui:Destroy()
end

--==============================
-- SIMPLE BUTTON
--==============================
local gui = Instance.new("ScreenGui")
gui.Name = "LowGfxGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0.18,0,0.06,0)
button.Position = UDim2.new(0.05,0,0.3,0)
button.Text = "SUPER LOW: ON"
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(0,150,0)
button.TextColor3 = Color3.new(1,1,1)
button.BorderSizePixel = 0
button.Active = true
button.Draggable = true

local state = true

button.MouseButton1Click:Connect(function()
    state = not state
    if state then
        SuperLowGfx()
        button.Text = "SUPER LOW: ON"
        button.BackgroundColor3 = Color3.fromRGB(0,150,0)
    else
        button.Text = "SUPER LOW: OFF"
        button.BackgroundColor3 = Color3.fromRGB(150,0,0)
    end
end)