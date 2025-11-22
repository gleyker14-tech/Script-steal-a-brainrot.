local Players = game:GetService("Players")
local p = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
-- Evitar duplicados
local guiName = "PersistentGalacticMenu"
if CoreGui:FindFirstChild(guiName) then
CoreGui:FindFirstChild(guiName):Destroy()
end
-- Crear GUI en CoreGui
local gui = Instance.new("ScreenGui")
gui.Name = guiName
gui.Parent = CoreGui
gui.ResetOnSpawn = false -- Muy importante, no se reinicia
-- Frame principal
local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0, 200, 0, 100)
f.Position = UDim2.new(0.05, 0, 0.3, 0)
f.Active = true
f.Draggable = true
f.BorderSizePixel = 0
-- Gradiente galáctico azul oscuro
local g = Instance.new("UIGradient", f)
g.Color = ColorSequence.new{
ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 50)),
ColorSequenceKeypoint.new(0.3, Color3.fromRGB(25, 25, 80)),
ColorSequenceKeypoint.new(0.6, Color3.fromRGB(50, 50, 120)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 70))
}
g.Rotation = 0
spawn(function()
while true do
g.Rotation = (g.Rotation + 1) % 360
wait(0.05)
end
end)
-- Título
local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1, 0, 0, 25)
t.Position = UDim2.new(0, 0, 0, 0)
t.Text = "Walk Silent"
t.TextColor3 = Color3.fromRGB(255, 255, 255)
t.BackgroundTransparency = 1
t.Font = Enum.Font.GothamBold
t.TextScaled = true
-- Botón ON/OFF
local b = Instance.new("TextButton", f)
b.Size = UDim2.new(1, -20, 0, 40)
b.Position = UDim2.new(0, 10, 0, 45)
b.Text = "OFF"
b.Font = Enum.Font.GothamBold
b.TextScaled = true
b.BackgroundColor3 = Color3.fromRGB(30, 30, 100)
b.TextColor3 = Color3.fromRGB(255, 255, 255)
b.BorderSizePixel = 1
-- Lógica Walk Silent
local silent = false
local connections = {}
local function getHum()
local char = p.Character
return char and char:FindFirstChild("Humanoid")
end
local function toggle(e)
silent = e
b.Text = silent and "ON" or "OFF"
local h = getHum()
if not h then return end
if silent then
for _, tr in pairs(h:GetPlayingAnimationTracks()) do tr:Stop() end
table.insert(connections, h.AnimationPlayed:Connect(function(tr)
if silent then tr:Stop() end
end))
else
for _, c in pairs(connections) do c:Disconnect() end
connections = {}
end
end
b.MouseButton1Click:Connect(function() toggle(not silent) end)
-- Reaplicar la lógica al respawnear
p.CharacterAdded:Connect(function(c)
c:WaitForChild("Humanoid")
if silent then toggle(true) end
end)
