-- Загрузка GUI библиотеки (Rayfield UI)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Fake SG",
   LoadingTitle = "Загрузка Universal SG...",
   LoadingSubtitle = "Works in All Games",
   ConfigurationSaving = {
      Enabled = false,
   },
   -- Система ключа
   KeySystem = true,
   KeySettings = {
      Title = "Система ключа | Universal SG",
      Subtitle = "Введите ключ для активации",
      Note = "Введите ключ для доступа к меню",
      FileName = "UniversalSGKeyConfig",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"pro_292939"} -- Ключ активации
   }
})

-- Переменные
local GlitchPower = 150
local SGEnabled = false
local Connection = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Вкладка
local MainTab = Window:CreateTab("Universal SG", 4483362458)

-- Переключатель SpeedGlitch
local SGToggle = MainTab:CreateToggle({
   Name = "Включить Universal Fake SG",
   CurrentValue = false,
   Flag = "UniversalSGToggle",
   Callback = function(Value)
      SGEnabled = Value
      
      if SGEnabled then
         Connection = RunService.RenderStepped:Connect(function()
            if not SGEnabled then return end
            
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
               local hrp = char.HumanoidRootPart
               local hum = char.Humanoid
               local camera = Workspace.CurrentCamera
               
               -- Проверяем, находится ли персонаж в прыжке (в воздухе)
               local isJumping = hum.FloorMaterial == Enum.Material.Air
               
               -- При движении джойстиком В ПРЫЖКЕ
               if isJumping and hum.MoveDirection.Magnitude > 0 then
                  local moveDir = hum.MoveDirection
                  
                  -- 1. Эффект визуального дёргания (Fake Glitch Shake)
                  local shake = (math.random(-5, 5) / 100)
                  camera.CFrame = camera.CFrame * CFrame.Angles(shake, 0, shake)
                  
                  -- 2. Импульсное ускорение по направлению движения
                  hrp.AssemblyLinearVelocity = Vector3.new(
                     moveDir.X * GlitchPower,
                     hrp.AssemblyLinearVelocity.Y,
                     moveDir.Z * GlitchPower
                  )
               end
            end
         end)
      else
         if Connection then
            Connection:Disconnect()
            Connection = nil
         end
      end
   end,
})

-- Слайдер силы SG (50 - 1000)
local SGSlider = MainTab:CreateSlider({
   Name = "Сила Glitch (Скорость)",
   Range = {50, 1000},
   Increment = 10,
   Suffix = "Power",
   CurrentValue = 150,
   Flag = "SGSlider",
   Callback = function(Value)
      GlitchPower = Value
   end,
})

-- Кнопка закрытия скрипта
local DestroyButton = MainTab:CreateButton({
   Name = "Выключить и Закрыть Скрипт",
   Callback = function()
      SGEnabled = false
      if Connection then
         Connection:Disconnect()
         Connection = nil
      end
      Rayfield:Destroy()
   end,
})
