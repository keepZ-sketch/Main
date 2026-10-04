local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

print("Auto-Reconnect Script Aktif!")

-- Mendeteksi bila ada prompt UI baru yang muncul di layar
CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    -- Memastikan yang muncul adalah pesan Error/Disconnect
    if child.Name == "ErrorPrompt" then
        print("Koneksi terputus! Mencoba menghubungkan kembali dalam 5 detik...")
        
        -- Jeda 5 detik agar tidak terkena rate limit atau crash
        task.wait(5) 
        
        -- Teleport kembali ke game dan server (JobId) yang sama
        if #Players:GetPlayers() <= 1 then
            Players.LocalPlayer:Kick("\nRejoining...")
            task.wait()
            TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
        end
    end
end)
