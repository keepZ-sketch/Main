-- Memuat Rayfield Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Pumpkin Auto Farmer",
   LoadingTitle = "Memuat GUI...",
   LoadingSubtitle = "Auto Collect",
   ConfigurationSaving = {
      Enabled = false,
   }
})

local Tab = Window:CreateTab("Auto Farm", 4483362458)

_G.AutoPumpkin = false

local function FarmPumpkins()
    while _G.AutoPumpkin do
        task.wait(0.1) -- Mencegah lag
        pcall(function()
            local player = game.Players.LocalPlayer
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end
            
            local hrp = character.HumanoidRootPart

            for _, obj in ipairs(workspace:GetDescendants()) do
                if not _G.AutoPumpkin then break end
                
                if obj.Name == "Pumpkin" then
                    -- Teleportasi
                    if obj:IsA("BasePart") then
                        hrp.CFrame = obj.CFrame
                    elseif obj:IsA("Model") and obj.PrimaryPart then
                        hrp.CFrame = obj.PrimaryPart.CFrame
                    end
                    
                    task.wait(0.2)
                    
                    -- Memicu ProximityPrompt (E)
                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        fireproximityprompt(prompt)
                    end
                end
            end
        end)
    end
end

Tab:CreateToggle({
   Name = "Enable Auto Collect & Teleport",
   CurrentValue = false,
   Flag = "AutoPumpkinToggle",
   Callback = function(Value)
        _G.AutoPumpkin = Value
        if Value then
            task.spawn(FarmPumpkins)
        end
   end,
})
