-- ==========================================
-- ANTI-JUMPSCARE V2 (NO EXTERNAL LIBRARY)
-- ==========================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Status Toggle
local antiVisual = false
local antiAudio = false

-- ==========================================
-- 1. MEMBUAT GUI MANUAL
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiJumpscareV2"
ScreenGui.ResetOnSpawn = false

-- Coba masukkan ke CoreGui agar tidak hilang saat mati. Jika gagal, ke PlayerGui.
local success = pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not success then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 150)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.Text = "👻 Anti-Jumpscare V2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame

-- Tombol Visual
local BtnVisual = Instance.new("TextButton")
BtnVisual.Size = UDim2.new(0.9, 0, 0, 40)
BtnVisual.Position = UDim2.new(0.05, 0, 0, 45)
BtnVisual.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah (Off)
BtnVisual.Text = "Anti-Visual: OFF"
BtnVisual.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnVisual.Font = Enum.Font.GothamBold
BtnVisual.TextSize = 14
BtnVisual.Parent = MainFrame

-- Tombol Audio
local BtnAudio = Instance.new("TextButton")
BtnAudio.Size = UDim2.new(0.9, 0, 0, 40)
BtnAudio.Position = UDim2.new(0.05, 0, 0, 95)
BtnAudio.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Merah (Off)
BtnAudio.Text = "Anti-Audio: OFF"
BtnAudio.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnAudio.Font = Enum.Font.GothamBold
BtnAudio.TextSize = 14
BtnAudio.Parent = MainFrame

-- Fungsi Tombol
BtnVisual.MouseButton1Click:Connect(function()
	antiVisual = not antiVisual
	if antiVisual then
		BtnVisual.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Hijau
		BtnVisual.Text = "Anti-Visual: ON"
	else
		BtnVisual.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		BtnVisual.Text = "Anti-Visual: OFF"
	end
end)

BtnAudio.MouseButton1Click:Connect(function()
	antiAudio = not antiAudio
	if antiAudio then
		BtnAudio.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Hijau
		BtnAudio.Text = "Anti-Audio: ON"
	else
		BtnAudio.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
		BtnAudio.Text = "Anti-Audio: OFF"
	end
end)

-- ==========================================
-- 2. LOGIKA ANTI-JUMPSCARE (LEBIH AKURAT)
-- ==========================================
task.spawn(function()
	while task.wait(0.1) do -- Scan setiap 0.1 detik untuk mencegah lag
		-- LOGIKA VISUAL (GAMBAR DI LAYAR & MODEL DI DEPAN KAMERA)
		if antiVisual then
			local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
			if playerGui then
				local viewport = Camera.ViewportSize
				-- 1. Hapus gambar 2D yang menutupi layar
				for _, gui in ipairs(playerGui:GetDescendants()) do
					if gui:IsA("ImageLabel") or gui:IsA("ImageButton") or gui:IsA("VideoFrame") then
						-- Jika elemen UI menutupi lebih dari 75% ukuran asli layar (AbsoluteSize)
						if gui.AbsoluteSize.X >= (viewport.X * 0.75) and gui.AbsoluteSize.Y >= (viewport.Y * 0.75) then
							if gui.Visible and gui.Transparency < 1 then
								gui.Visible = false
								-- gui:Destroy() -- Bisa diaktifkan jika jumpscare masih bandel
							end
						end
					end
				end
			end
			
			-- 2. Hapus Model 3D yang di-spawn langsung di wajah/kamera (Metode jumpscare modern)
			for _, camObj in ipairs(Camera:GetChildren()) do
				if camObj:IsA("Model") or camObj:IsA("BasePart") then
					camObj:Destroy()
				end
			end
		end

		-- LOGIKA AUDIO (SUARA KERAS)
		if antiAudio then
			-- Scan di Workspace
			for _, sound in ipairs(workspace:GetDescendants()) do
				if sound:IsA("Sound") and sound.Playing then
					if sound.Volume > 1.5 then sound.Volume = 0 end
				end
			end
			-- Scan di SoundService
			for _, sound in ipairs(SoundService:GetDescendants()) do
				if sound:IsA("Sound") and sound.Playing then
					if sound.Volume > 1.5 then sound.Volume = 0 end
				end
			end
		end
	end
end)
