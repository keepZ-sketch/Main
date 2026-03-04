--// LOW GRAPHIC EXTREME - CLEAN & SMALL TOGGLE

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

--==============================
-- LOW GRAPHIC FUNCTION (SAMA)
--==============================
local function LowGfx()
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.FogEnd = 9e9

    for _, v in pairs(workspace:GetDescendants()) do
        
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end
        
        if v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
        
        if v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Smoke")
        or v:IsA("Fire")
        or v:IsA("Sparkles") then
            v.Enabled = false
        end
    end
end

-- AUTO ON SAAT MASUK
LowGfx()

-- HAPUS GUI LAMA
if playerGui:FindFirstChild("LowGfxGui") then
    playerGui.LowGfxGui:Destroy()
end

--==============================
-- GUI (LEBIH KECIL & RAPI)
--==============================
local gui = Instance.new("ScreenGui")
gui.Name = "LowGfxGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,150,0,20) -- LEBIH KECIL
frame.Position = UDim2.new(0,50,0,200)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local button = Instance.new("TextButton")
button.Parent = frame
button.Size = UDim2.new(1,-6,1,-6)
button.Position = UDim2.new(0,3,0,3)
button.Text = "LOW: ON"
button.TextScaled = true
button.Font = Enum.Font.GothamBold
button.BackgroundColor3 = Color3.fromRGB(0,170,0)
button.TextColor3 = Color3.new(1,1,1)
button.BorderSizePixel = 0

--==============================
-- TOGGLE SYSTEM (TIDAK DIUBAH)
--==============================
local state = true

button.MouseButton1Click:Connect(function()
    state = not state
    
    if state then
        LowGfx()
        button.Text = "LOW: ON"
        button.BackgroundColor3 = Color3.fromRGB(0,170,0)
    else
        button.Text = "LOW: OFF"
        button.BackgroundColor3 = Color3.fromRGB(170,0,0)
    end
end)

