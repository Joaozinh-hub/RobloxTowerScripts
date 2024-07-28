-- Script para subir a torre com controle de ativação via GUI

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local jumpHeight = 50 -- Altura do pulo em cada nível (ajuste conforme necessário)
local jumpEnabled = false -- Variável para controle do pulo

-- Função para detectar se o jogador está no chão
local function isGrounded()
    local rayOrigin = character.HumanoidRootPart.Position
    local rayDirection = Vector3.new(0, -1, 0) * 3 -- Comprimento do raio para detectar o chão
    local ray = Ray.new(rayOrigin, rayDirection)

    local hit, position = workspace:FindPartOnRay(ray, character)

    return hit ~= nil
end

-- Função para pular para o próximo nível
local function jumpToNextLevel()
    if jumpEnabled and isGrounded() then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        humanoid.JumpPower = jumpHeight
        humanoid:MoveTo(character.HumanoidRootPart.Position + Vector3.new(0, jumpHeight, 0))
    end
end

-- Conectando à tecla de espaço para ativar o pulo
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Space and not gameProcessed then
        jumpToNextLevel()
    end
end)

-- Atualizar a altura do pulo em tempo real
runService.RenderStepped:Connect(function()
    humanoid.JumpPower = jumpHeight
end)

-- Criar a GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 150, 0, 50)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)

local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(1, 0, 1, 0)
toggleButton.Text = "Ativar Pulo"
toggleButton.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18

-- Função para alternar o estado do pulo
toggleButton.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    toggleButton.Text = jumpEnabled and "Desativar Pulo" or "Ativar Pulo"
end)

-- Iniciar automaticamente ao tocar na base da torre
character.Touched:Connect(function(hit)
    if hit.Name == "BaseDaTorre" then
        jumpToNextLevel()
    end
end)
