--// LOW GRAPHIC EXTREME - 1-TOMBOL MINIMALIS

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local playerGui = player:WaitForChild("PlayerGui")

--==============================
-- LOW GRAPHIC FUNCTION
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
-- GUI 1-TOMBOL
--==============================
local gui = Instance.new("ScreenGui")
gui.Name = "LowGfxGui"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local button = Instance.new("TextButton")
button.Parent = gui
button.Size = UDim2.new(0,100,0,30)
button.Position = UDim2.new(0,50,0,200)
button.Text = "LOW: ON"
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(0,170,0)
button.TextColor3 = Color3.new(1,1,1)
button.BorderSizePixel = 0
button.Active = true
button.Draggable = true

local state = true
local hidden = false

-- Tombol toggle & hide/show
button.MouseButton1Click:Connect(function()
    -- Jika tombol sedang visible -> toggle LowGfx
    if not hidden then
        state = not state
        if state then
            LowGfx()
            button.Text = "LOW: ON"
            button.BackgroundColor3 = Color3.fromRGB(0,170,0)
        else
            button.Text = "LOW: OFF"
            button.BackgroundColor3 = Color3.fromRGB(170,0,0)
        end
    end
end)

-- Tombol right click untuk hide/show
button.MouseButton2Click:Connect(function()
    if not hidden then
        button.Visible = false
        hidden = true

        -- Tombol kecil show
        local showButton = Instance.new("TextButton")
        showButton.Name = "ShowButton"
        showButton.Parent = gui
        showButton.Size = UDim2.new(0,30,0,30)
        showButton.Position = UDim2.new(0,50,0,200)
        showButton.Text = "□"
        showButton.Font = Enum.Font.GothamBold
        showButton.TextScaled = true
        showButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
        showButton.TextColor3 = Color3.new(1,1,1)
        showButton.BorderSizePixel = 0
        showButton.Active = true
        showButton.Draggable = true

        showButton.MouseButton1Click:Connect(function()
            button.Visible = true
            hidden = false
            showButton:Destroy()
        end)
    end
end)
