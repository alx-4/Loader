-- QuantumEdgeHub Loader System (main.lua)
local Players = game:GetService("Players")
local CAS = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- Arka planda loader.lua'yı önceden indirelim (vakit kaybetmemek için)
local loaderSource = ""
task.spawn(function()
    local success, result = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/QuantumEdgeHub/Loader/main/loader.lua")
    end)
    if success then
        loaderSource = result
    else
        warn("QuantumEdgeHub: loader.lua indirilemedi!")
    end
end)

-- UI GİZLEME (Agresif Mod)
task.spawn(function()
    for i = 1, 10 do -- Roblox'un geç yüklenen elemanları için birkaç kez tekrarla
        pcall(function()
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
            StarterGui:SetCore("TopbarEnabled", false)
        end)
        task.wait(0.2)
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "QuantumFinalLoading"
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.Parent = player:WaitForChild("PlayerGui")

-- GİRİŞ KİLİDİ
CAS:BindActionAtPriority("FullLock", function() return Enum.ContextActionResult.Sink end, false, 4000,
    unpack(Enum.KeyCode:GetEnumItems()), unpack(Enum.UserInputType:GetEnumItems()))

-- ARKA PLAN (Daha Açık Deniz Mavisi)
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1.2, 0, 1.2, 0)
bg.Position = UDim2.new(-0.1, 0, -0.1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 90, 160)
bg.BorderSizePixel = 0
bg.Active = true
bg.Parent = gui

-- BAŞLIK (Aynı stil)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.6, 0, 0.2, 0)
title.Position = UDim2.new(0.2, 0, 0.4, 0)
title.BackgroundTransparency = 1
title.Text = "QUANTUMEDGEHUB"
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.TextColor3 = Color3.fromRGB(0, 210, 255)
title.Parent = bg

local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(255, 255, 255)
titleStroke.Thickness = 10
titleStroke.Parent = title

-- BAR
local barFrame = Instance.new("Frame")
barFrame.Size = UDim2.new(0.3, 0, 0.015, 0)
barFrame.Position = UDim2.new(0.35, 0, 0.6, 0)
barFrame.BackgroundColor3 = Color3.fromRGB(0, 40, 80)
barFrame.BorderSizePixel = 0
barFrame.Parent = bg

local barStroke = Instance.new("UIStroke")
barStroke.Color = Color3.fromRGB(255, 255, 255)
barStroke.Thickness = 2.5
barStroke.Parent = barFrame

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0, 0, 1, 0)
bar.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
bar.BorderSizePixel = 0
bar.Parent = barFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(1, 0)
barCorner.Parent = bar

-- 60 SANİYE ANİMASYON (Hızlıdan yavaşa)
local info = TweenInfo.new(60, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local tween = TweenService:Create(bar, info, {Size = UDim2.new(1, 0, 1, 0)})

tween:Play()
tween.Completed:Wait()

-- BİTİŞ VE ASIL SCRIPTİ ÇALIŞTIRMA
CAS:UnbindAction("FullLock")
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
    StarterGui:SetCore("TopbarEnabled", true)
end)

gui:Destroy()

-- İndirilen içeriği çalıştır
if loaderSource ~= "" then
    local func, err = loadstring(loaderSource)
    if func then
        func()
    else
        warn("QuantumEdgeHub: loader.lua hatali: " .. tostring(err))
    end
else
    -- Eğer arka planda inmemişse (internet yavaşlığı vb.), tekrar denesin
    loadstring(game:HttpGet("https://raw.githubusercontent.com/QuantumEdgeHub/Loader/main/loader.lua"))()
end
