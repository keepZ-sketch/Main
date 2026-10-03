-- Memuat Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Anti-Jumpscare Hub 👻🚫", HidePremium = false, SaveConfig = false})

local MainTab = Window:MakeTab({
	Name = "Features",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local antiJumpscareUI = false
local antiLoudSound = false

-- Toggle untuk menyembunyikan gambar jumpscare (ScreenGui)
MainTab:AddToggle({
	Name = "Anti GUI Jumpscare (Hides large images)",
	Default = false,
	Callback = function(Value)
		antiJumpscareUI = Value
	end    
})

-- Toggle untuk mematikan suara keras
MainTab:AddToggle({
	Name = "Anti Loud Sounds (Mutes jumpscare audio)",
	Default = false,
	Callback = function(Value)
		antiLoudSound = Value
	end    
})

-- Logika Utama
game:GetService("RunService").RenderStepped:Connect(function()
    -- Menyembunyikan UI Jumpscare
	if antiJumpscareUI then
		local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
		if playerGui then
			for _, gui in pairs(playerGui:GetDescendants()) do
				if gui:IsA("ImageLabel") or gui:IsA("ImageButton") then
                    -- Jika gambar menutupi lebih dari 80% layar, asumsikan itu jumpscare
					if gui.Size.X.Scale > 0.8 or gui.Size.Y.Scale > 0.8 then
						gui.Visible = false
					end
				end
			end
		end
	end

    -- Membisukan suara keras
	if antiLoudSound then
		for _, sound in pairs(workspace:GetDescendants()) do
			if sound:IsA("Sound") and sound.Playing then
                -- Jika volume lebih dari 1.5, paksa menjadi 0
				if sound.Volume > 1.5 then
					sound.Volume = 0
				end
			end
		end
	end
end)

-- Inisialisasi GUI
OrionLib:Init()
