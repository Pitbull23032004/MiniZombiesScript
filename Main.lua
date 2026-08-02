-- Painel Flutuante v2.9 - Versão Lite com Ícone de Caveira
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

if game.CoreGui:FindFirstChild("DK_PainelLite") then
    game.CoreGui.DK_PainelLite:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DK_PainelLite"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Janela Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -135)
MainFrame.Size = UDim2.new(0, 420, 0, 270)
MainFrame.Visible = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Borda RGB Animada
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(255, 0, 0)

-- Barra Superior
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local TopBarCover = Instance.new("Frame")
TopBarCover.Parent = TopBar
TopBarCover.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TopBarCover.BorderSizePixel = 0
TopBarCover.Position = UDim2.new(0, 0, 1, -5)
TopBarCover.Size = UDim2.new(1, 0, 0, 5)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "DK PAINEL <font color='#00FF55'>VERSÃO LITE v2.9</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Sistema de Arrastar Janela
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Botão de Minimizar (-)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Position = UDim2.new(1, -35, 0.5, -12)
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeBtn

-- Botão Flutuante Reabrir (Ícone de Caveira)
local OpenButton = Instance.new("ImageButton")
OpenButton.Name = "OpenButton"
OpenButton.Parent = ScreenGui
OpenButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OpenButton.Position = UDim2.new(0, 20, 0.5, -25)
OpenButton.Size = UDim2.new(0, 50, 0, 50)
OpenButton.Image = "rbxassetid://6031097225" -- Ícone de caveira simples
OpenButton.ImageColor3 = Color3.fromRGB(0, 255, 100)
OpenButton.Visible = false

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 12)
OpenCorner.Parent = OpenButton

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Parent = OpenButton
OpenStroke.Thickness = 2
OpenStroke.Color = Color3.fromRGB(0, 255, 100)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenButton.Visible = false
end)

-- Arrastar Botão Flutuante
local openDragging, openDragStart, openStartPos
OpenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openDragging = true
        openDragStart = input.Position
        openStartPos = OpenButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if openDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - openDragStart
        OpenButton.Position = UDim2.new(openStartPos.X.Scale, openStartPos.X.Offset + delta.X, openStartPos.Y.Scale, openStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        openDragging = false
    end
end)

-- Animação RGB
task.spawn(function()
    local hue = 0
    while true do
        hue = (hue + 1) % 360
        UIStroke.Color = Color3.fromHSV(hue / 360, 1, 1)
        task.wait(0.03)
    end
end)

-- Abas
local TabButtonsContainer = Instance.new("ScrollingFrame")
TabButtonsContainer.Parent = MainFrame
TabButtonsContainer.BackgroundTransparency = 1
TabButtonsContainer.Position = UDim2.new(0, 0, 0, 45)
TabButtonsContainer.Size = UDim2.new(0, 110, 1, -45)
TabButtonsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
TabButtonsContainer.ScrollBarThickness = 2

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabButtonsContainer
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Padding = UDim.new(0, 6)
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 120, 0, 50)
ContentContainer.Size = UDim2.new(1, -130, 1, -60)

local tabs = {}
local function createTab(name)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = TabButtonsContainer
    tabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    tabBtn.BorderSizePixel = 0
    tabBtn.Size = UDim2.new(0, 95, 0, 32)
    tabBtn.Font = Enum.Font.GothamSemibold
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
    tabBtn.TextSize = 12

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tabBtn

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Parent = ContentContainer
    tabContent.BackgroundTransparency = 1
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Visible = false
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 3

    local layout = Instance.new("UIListLayout")
    layout.Parent = tabContent
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.content.Visible = false
            t.btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        end
        tabContent.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end)

    table.insert(tabs, {btn = tabBtn, content = tabContent})
    if #tabs == 1 then
        tabContent.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    end

    return tabContent
end

local TabPrincipal = createTab("Principal")
local TabVisual = createTab("ESP Visual")
local TabCombate = createTab("Combate")

local function createToggle(parent, text, callback)
    local state = false
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.Font = Enum.Font.GothamMedium
    btn.Text = text .. ": [ OFF ]"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.Text = text .. ": [ ON ]"
            btn.TextColor3 = Color3.fromRGB(0, 255, 100)
            btn.BackgroundColor3 = Color3.fromRGB(30, 45, 30)
        else
            btn.Text = text .. ": [ OFF ]"
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        end
        callback(state)
    end)
    return btn
end

-- ==========================================
-- FUNÇÕES DO PAINEL
-- ==========================================

-- 1. Velocidade 2x
local speedActive = false
RunService.Heartbeat:Connect(function()
    if speedActive then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = 32
        end
    end
end)

createToggle(TabPrincipal, "Velocidade 2x", function(enabled)
    speedActive = enabled
    if not enabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
        end
    end
end)

-- 2. ESP Hologram Geral
local espActive = false
RunService.RenderStepped:Connect(function()
    if espActive then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                local humanoid = obj:FindFirstChildOfClass("Humanoid")
                if humanoid and obj:FindFirstChild("HumanoidRootPart") then
                    if not obj:FindFirstChild("DK_ESP") then
                        local hl = Instance.new("Highlight")
                        hl.Name = "DK_ESP"
                        hl.Adornee = obj
                        hl.FillColor = Color3.fromRGB(0, 170, 255)
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.Parent = obj
                    end
                end
            end
        end
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local hl = obj:FindFirstChild("DK_ESP")
                if hl then hl:Destroy() end
            end
        end
    end
end)

createToggle(TabPrincipal, "ESP Hologram", function(enabled)
    espActive = enabled
end)

-- 3. ESP Name Zumbis
local espZombiesActive = false
RunService.RenderStepped:Connect(function()
    if espZombiesActive then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    local nameLower = obj.Name:lower()
                    if (nameLower:find("zombie") or nameLower:find("shambler") or nameLower:find("dog") or nameLower:find("bomber") or nameLower:find("nurse") or nameLower:find("clown")) and not nameLower:find("crate") then
                        local billboard = hrp:FindFirstChild("DK_ZombiESP")
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "DK_ZombiESP"
                            billboard.Size = UDim2.new(0, 110, 0, 40)
                            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = hrp

                            local textLabel = Instance.new("TextLabel")
                            textLabel.Name = "Text"
                            textLabel.Parent = billboard
                            textLabel.BackgroundTransparency = 1
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.Font = Enum.Font.GothamBold
                            textLabel.TextSize = 11
                            textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                            textLabel.TextStrokeTransparency = 0
                            textLabel.Text = "[ZUMBI] " .. obj.Name
                        end
                    end
                end
            end
        end
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bb = hrp:FindFirstChild("DK_ZombiESP")
                    if bb then bb:Destroy() end
                end
            end
        end
    end
end)

createToggle(TabVisual, "ESP Name (Zumbis)", function(enabled)
    espZombiesActive = enabled
end)

-- 3.1. ESP Name Caixas
local espCratesActive = false
RunService.RenderStepped:Connect(function()
    if espCratesActive then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if hrp then
                    local nameLower = obj.Name:lower()
                    if nameLower:find("crate") or nameLower:find("box") then
                        local billboard = hrp:FindFirstChild("DK_CrateESP")
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "DK_CrateESP"
                            billboard.Size = UDim2.new(0, 110, 0, 40)
                            billboard.StudsOffset = Vector3.new(0, 2.0, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = hrp

                            local textLabel = Instance.new("TextLabel")
                            textLabel.Name = "Text"
                            textLabel.Parent = billboard
                            textLabel.BackgroundTransparency = 1
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.Font = Enum.Font.GothamBold
                            textLabel.TextSize = 12
                            textLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
                            textLabel.TextStrokeTransparency = 0
                            textLabel.Text = "[CAIXA] " .. obj.Name
                        end
                    end
                end
            end
        end
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                for _, part in pairs(obj:GetChildren()) do
                    if part:IsA("BasePart") then
                        local bb = part:FindFirstChild("DK_CrateESP")
                        if bb then bb:Destroy() end
                    end
                end
            end
        end
    end
end)

createToggle(TabVisual, "ESP Name (Caixas)", function(enabled)
    espCratesActive = enabled
end)

-- 4. ESP Name Boss
local espBossActive = false
RunService.RenderStepped:Connect(function()
    if espBossActive then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                if hum and hrp then
                    local nameLower = obj.Name:lower()
                    if nameLower:find("boss") or nameLower:find("goliath") or nameLower:find("tank") or hum.MaxHealth > 200 then
                        local billboard = hrp:FindFirstChild("DK_BossESP")
                        if not billboard then
                            billboard = Instance.new("BillboardGui")
                            billboard.Name = "DK_BossESP"
                            billboard.Size = UDim2.new(0, 130, 0, 50)
                            billboard.StudsOffset = Vector3.new(0, 3.2, 0)
                            billboard.AlwaysOnTop = true
                            billboard.Parent = hrp

                            local textLabel = Instance.new("TextLabel")
                            textLabel.Name = "Text"
                            textLabel.Parent = billboard
                            textLabel.BackgroundTransparency = 1
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.Font = Enum.Font.GothamBold
                            textLabel.TextSize = 13
                            textLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
                            textLabel.TextStrokeTransparency = 0
                            textLabel.Text = "⭐ [BOSS] " .. obj.Name
                        end
                    end
                end
            end
        end
    else
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") then
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bb = hrp:FindFirstChild("DK_BossESP")
                    if bb then bb:Destroy() end
                end
            end
        end
    end
end)

createToggle(TabVisual, "ESP Name (Boss)", function(enabled)
    espBossActive = enabled
end)

-- 5. Auto-KILL Boss
local autoKillActive = false
RunService.Heartbeat:Connect(function()
    if autoKillActive then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj ~= LocalPlayer.Character then
                local hum = obj:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    if obj.Name:lower():find("boss") or obj:FindFirstChild("Head") then
                        hum.Health = 0
                    end
                end
            end
        end
    end
end)

createToggle(TabCombate, "Auto-KILL Boss", function(enabled)
    autoKillActive = enabled
end)
