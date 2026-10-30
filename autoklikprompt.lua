-- Memuat Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Pumpkin Auto Farmer", HidePremium = false, SaveConfig = false, IntroText = "Auto Pumpkin"})

local Tab = Window:MakeTab({
	Name = "Auto Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

_G.AutoPumpkin = false

local function FarmPumpkins()
    while _G.AutoPumpkin do
        task.wait(0.1) -- Jeda singkat untuk mencegah lag/crash
        pcall(function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = character.HumanoidRootPart

            -- Mencari semua objek di Workspace
            for _, obj in ipairs(workspace:GetDescendants()) do
                if not _G.AutoPumpkin then break end
                
                -- Pastikan nama objek sesuai dengan target (Ganti "Pumpkin" jika nama di game berbeda)
                if obj.Name == "Pumpkin" then
                    -- Teleportasi
                    if obj:IsA("BasePart") then
                        hrp.CFrame = obj.CFrame
                    elseif obj:IsA("Model") and obj.PrimaryPart then
                        hrp.CFrame = obj.PrimaryPart.CFrame
                    end
                    
                    task.wait(0.2) -- Jeda saat teleport
                    
                    -- Memicu ProximityPrompt (E untuk collect) jika ada
                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end)
    end
end

Tab:AddToggle({
	Name = "Enable Auto Collect & Teleport",
	Default = false,
	Callback = function(Value)
		_G.AutoPumpkin = Value
		if Value then
			task.spawn(FarmPumpkins)
		end
	end    
})

-- Inisialisasi GUI
OrionLib:Init()
