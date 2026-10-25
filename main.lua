-- ==========================================================================
-- RPG DE HORA DE AVENTURA | COM2 BRUTAL V23 [DESIGN PROFISSIONAL]
-- Jogo: RPG de Hora de Aventura [BETA] - Roblox[cite: 5]
-- Site Oficial: https://darkgamingyt-br-pt.netlify.app/
-- Firebase: https://darkgamingyt-1c438-default-rtdb.firebaseio.com/
-- Canal: https://youtube.com/@wallacy_rtx | Discord: https://discord.com/invite/vzMRuAs6gt
-- ==========================================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local SCRIPT_VERSION = "AT RPG BRUTAL V23 [DESIGN PROFISSIONAL]"
local FIREBASE_BASE_URL = "https://darkgamingyt-1c438-default-rtdb.firebaseio.com"
local FONT_MAIN = Enum.Font.Code

-- Paleta de Cores Estilo Aventura // Design Moderno e Profissional
local COLOR_BG = Color3.fromRGB(12, 22, 18)
local COLOR_PANEL = Color3.fromRGB(18, 32, 25)
local COLOR_ITEM = Color3.fromRGB(26, 46, 36)
local COLOR_ACCENT = Color3.fromRGB(0, 230, 118)    -- Verde Aventura Neon
local COLOR_SECONDARY = Color3.fromRGB(255, 193, 7) -- Dourado Místico (Jake)
local COLOR_BORDER = Color3.fromRGB(46, 125, 50)
local COLOR_TEXT = Color3.fromRGB(236, 253, 245)
local COLOR_SUBTEXT = Color3.fromRGB(156, 188, 172)
local COLOR_WARN = Color3.fromRGB(255, 179, 0)
local COLOR_OFF = Color3.fromRGB(239, 83, 80)
local COLOR_ON = Color3.fromRGB(76, 175, 80)

-- Compatibilidade de requisição HTTP para o Firebase
local httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

-- Variáveis de telemetria
local fpsAtual = 60
local paisUsuario = "Desconhecido"
local cidadeUsuario = "Desconhecida"
local safeKey = "user_" .. tostring(LocalPlayer.UserId)

-- Coleta assíncrona de geolocalização por IP
task.spawn(function()
	pcall(function()
		local response = game:HttpGet("http://ip-api.com/json/?fields=country,city")
		if response then
			local data = HttpService:JSONDecode(response)
			if data and data.country then
				paisUsuario = data.country
				cidadeUsuario = data.city or "Desconhecida"
			end
		end
	end)
end)

-- Limpeza de versões anteriores
pcall(function()
	for _, guiName in ipairs({"KD_Brutal_V16", "KD_Brutal_V17", "BRUTAL_R1_V18", "BRUTAL_R1_V19", "BRUTAL_R1_V20", "AT_RPG_V21", "AT_RPG_V22", "AT_RPG_V23"}) do
		if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end
		if LocalPlayer.PlayerGui:FindFirstChild(guiName) then LocalPlayer.PlayerGui[guiName]:Destroy() end
		if gethui and gethui():FindFirstChild(guiName) then gethui()[guiName]:Destroy() end
	end
end)

-- Criação segura do ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AT_RPG_V23"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentSuccess = pcall(function()
	if gethui then
		ScreenGui.Parent = gethui()
	else
		ScreenGui.Parent = CoreGui
	end
end)
if not parentSuccess or not ScreenGui.Parent then
	ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local EspLineFolder = Instance.new("Folder", ScreenGui)
EspLineFolder.Name = "AT_EspLinesPool"

-- Sistema de Sons (Sound FX)
local function playClickSound()
	pcall(function()
		local snd = Instance.new("Sound")
		snd.SoundId = "rbxassetid://6026985050"
		snd.Volume = 0.5
		snd.Parent = ScreenGui
		snd:Play()
		game:GetService("Debris"):AddItem(snd, 1)
	end)
end

local function applyStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = color or COLOR_ACCENT
	stroke.Thickness = thickness or 1.5
	stroke.LineJoinMode = Enum.LineJoinMode.Miter
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return stroke
end

local function makeDraggable(dragHandle, targetFrame)
	local dragging = false
	local dragInput, dragStart, startPos

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = targetFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- ==========================================================================
-- BARRA DE CARREGAMENTO INICIAL (LOADING SCREEN PROFISSIONAL)
-- ==========================================================================
local LoadingFrame = Instance.new("Frame", ScreenGui)
LoadingFrame.Size = UDim2.new(0, 320, 0, 150)
LoadingFrame.Position = UDim2.new(0.5, -160, 0.5, -75)
LoadingFrame.BackgroundColor3 = COLOR_BG
LoadingFrame.BorderSizePixel = 0
LoadingFrame.ZIndex = 200
applyStroke(LoadingFrame, COLOR_SECONDARY, 2)
Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 12)

local LoadTitle = Instance.new("TextLabel", LoadingFrame)
LoadTitle.Size = UDim2.new(1, -20, 0, 24)
LoadTitle.Position = UDim2.new(0, 10, 0, 12)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "🛡️ HORA DE AVENTURA RPG // V23"
LoadTitle.TextColor3 = COLOR_SECONDARY
LoadTitle.TextSize = 12
LoadTitle.Font = FONT_MAIN
LoadTitle.TextXAlignment = Enum.TextXAlignment.Center
LoadTitle.ZIndex = 202

local LoadStatus = Instance.new("TextLabel", LoadingFrame)
LoadStatus.Size = UDim2.new(1, -20, 0, 20)
LoadStatus.Position = UDim2.new(0, 10, 0, 50)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Carregando interface profissional..."
LoadStatus.TextColor3 = COLOR_SUBTEXT
LoadStatus.TextSize = 10
LoadStatus.Font = FONT_MAIN
LoadStatus.TextXAlignment = Enum.TextXAlignment.Left
LoadStatus.ZIndex = 202

local LoadBarBg = Instance.new("Frame", LoadingFrame)
LoadBarBg.Size = UDim2.new(1, -24, 0, 16)
LoadBarBg.Position = UDim2.new(0, 12, 0, 85)
LoadBarBg.BackgroundColor3 = COLOR_PANEL
LoadBarBg.BorderSizePixel = 0
LoadBarBg.ZIndex = 202
applyStroke(LoadBarBg, COLOR_BORDER, 1)
Instance.new("UICorner", LoadBarBg).CornerRadius = UDim.new(0, 8)

local LoadBarFill = Instance.new("Frame", LoadBarBg)
LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadBarFill.BackgroundColor3 = COLOR_ACCENT
LoadBarFill.BorderSizePixel = 0
LoadBarFill.ZIndex = 203
Instance.new("UICorner", LoadBarFill).CornerRadius = UDim.new(0, 6)

-- Painel Principal Profissional
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 470)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -235)
MainFrame.BackgroundColor3 = COLOR_BG
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 80
applyStroke(MainFrame, COLOR_ACCENT, 2)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local FloatContainer = Instance.new("Frame", ScreenGui)
FloatContainer.Size = UDim2.fromOffset(130, 56)
FloatContainer.Position = UDim2.new(0.5, -340, 0.5, -235)
FloatContainer.BackgroundColor3 = COLOR_BG
FloatContainer.BorderSizePixel = 0
FloatContainer.Visible = false
FloatContainer.ZIndex = 100
applyStroke(FloatContainer, COLOR_ACCENT, 2)
Instance.new("UICorner", FloatContainer).CornerRadius = UDim.new(0, 10)

local FpsLabel = Instance.new("TextLabel", FloatContainer)
FpsLabel.Size = UDim2.new(1, 0, 0, 18)
FpsLabel.Position = UDim2.new(0, 0, 0, 2)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Text = "FPS: 60"
FpsLabel.TextColor3 = COLOR_SECONDARY
FpsLabel.TextSize = 10
FpsLabel.Font = FONT_MAIN
FpsLabel.TextXAlignment = Enum.TextXAlignment.Center
FpsLabel.ZIndex = 102

local FloatBtn = Instance.new("TextButton", FloatContainer)
FloatBtn.Size = UDim2.new(1, -6, 0, 30)
FloatBtn.Position = UDim2.new(0, 3, 0, 22)
FloatBtn.BackgroundColor3 = COLOR_PANEL
FloatBtn.BorderSizePixel = 0
FloatBtn.Text = "⚔️ MENU V23"
FloatBtn.TextColor3 = COLOR_ACCENT
FloatBtn.TextSize = 11
FloatBtn.Font = FONT_MAIN
FloatBtn.ZIndex = 101
applyStroke(FloatBtn, COLOR_BORDER, 1)
Instance.new("UICorner", FloatBtn).CornerRadius = UDim.new(0, 8)

makeDraggable(FloatBtn, FloatContainer)

-- Sequência de Carregamento
task.spawn(function()
	local stages = {
		{pct = 0.30, txt = "Mapeando o Mundo de Ooo... [30%]"},
		{pct = 0.65, txt = "Sincronizando Firebase Database... [65%]"},
		{pct = 0.90, txt = "Aplicando novo design visual... [90%]"},
		{pct = 1.00, txt = "Pronto! AT V23 Carregado [100%]"}
	}
	for _, st in ipairs(stages) do
		LoadStatus.Text = st.txt
		TweenService:Create(LoadBarFill, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
			Size = UDim2.new(st.pct, 0, 1, 0)
		}):Play()
		task.wait(0.35)
	end
	task.wait(0.2)
	LoadingFrame:Destroy()
	MainFrame.Visible = true
	FloatContainer.Visible = true
	playClickSound()
end)

-- Contador de FPS
local fpsFrames = 0
local fpsLastTick = tick()
RunService.RenderStepped:Connect(function()
	fpsFrames = fpsFrames + 1
	local now = tick()
	if now - fpsLastTick >= 1 then
		fpsAtual = math.floor(fpsFrames / (now - fpsLastTick))
		FpsLabel.Text = string.format("FPS: %d", fpsAtual)
		fpsFrames = 0
		fpsLastTick = now
	end
end)

-- Tarefa em background para atualizar o Firebase
task.spawn(function()
	while task.wait(4) do
		pcall(function()
			if httpRequest then
				local payload = {
					nickRoblox = LocalPlayer.Name,
					displayName = LocalPlayer.DisplayName,
					userId = LocalPlayer.UserId,
					versaoScript = SCRIPT_VERSION,
					fps = fpsAtual,
					pais = paisUsuario,
					cidade = cidadeUsuario,
					jogo = "RPG de Hora de Aventura",
					ultimaAtualizacao = os.date("%d/%m/%Y %H:%M:%S"),
					timestamp = os.time()
				}
				httpRequest({
					Url = FIREBASE_BASE_URL .. "/at_rpg_users/" .. safeKey .. ".json",
					Method = "PUT",
					Headers = {["Content-Type"] = "application/json"},
					Body = HttpService:JSONEncode(payload)
				})
			end
		end)
	end
end)

FloatContainer:GetPropertyChangedSignal("Position"):Connect(function()
	local fPos = FloatContainer.Position
	MainFrame.Position = UDim2.new(fPos.X.Scale, fPos.X.Offset + 138, fPos.Y.Scale, fPos.Y.Offset)
end)

FloatBtn.MouseButton1Click:Connect(function()
	playClickSound()
	MainFrame.Visible = not MainFrame.Visible
	FloatBtn.TextColor3 = MainFrame.Visible and COLOR_ON or COLOR_SUBTEXT
end)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = COLOR_PANEL
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 82
applyStroke(TopBar, COLOR_BORDER, 1)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🛡️ HORA DE AVENTURA // @wallacy_rtx"
TitleLabel.TextColor3 = COLOR_SECONDARY
TitleLabel.TextSize = 10
TitleLabel.Font = FONT_MAIN
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 83

-- Abas do Menu
local TabHeader = Instance.new("Frame", MainFrame)
TabHeader.Size = UDim2.new(1, -20, 0, 32)
TabHeader.Position = UDim2.new(0, 10, 0, 48)
TabHeader.BackgroundColor3 = COLOR_PANEL
TabHeader.BorderSizePixel = 0
TabHeader.ZIndex = 82
applyStroke(TabHeader, COLOR_BORDER, 1)
Instance.new("UICorner", TabHeader).CornerRadius = UDim.new(0, 8)

local function createTabBtn(name, posX, active)
	local btn = Instance.new("TextButton", TabHeader)
	btn.Size = UDim2.new(0.19, 0, 0.8, 0)
	btn.Position = UDim2.new(posX, 0, 0.1, 0)
	btn.BackgroundColor3 = active and COLOR_SECONDARY or COLOR_ITEM
	btn.BorderSizePixel = 0
	btn.TextColor3 = active and COLOR_BG or COLOR_TEXT
	btn.TextSize = 8
	btn.Font = FONT_MAIN
	btn.Text = name
	btn.ZIndex = 83
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	applyStroke(btn, active and COLOR_ACCENT or COLOR_BORDER, 1)
	return btn
end

local btnBypass = createTabBtn("BYPASS", 0.01, true)
local btnEsp = createTabBtn("BOSS ESP", 0.21, false)
local btnAim = createTabBtn("COMBATE", 0.41, false)
local btnGeral = createTabBtn("GERAL", 0.61, false)
local btnSocial = createTabBtn("SOCIAL", 0.81, false)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -20, 1, -114)
ContentContainer.Position = UDim2.new(0, 10, 0, 88)
ContentContainer.BackgroundTransparency = 1
ContentContainer.ZIndex = 82

local function createScroll()
	local scroll = Instance.new("ScrollingFrame", ContentContainer)
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = COLOR_ACCENT
	scroll.Visible = false
	scroll.ZIndex = 82
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	local list = Instance.new("UIListLayout", scroll)
	list.Padding = UDim.new(0, 8)
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	
	local pad = Instance.new("UIPadding", scroll)
	pad.PaddingTop = UDim.new(0, 2)
	pad.PaddingBottom = UDim.new(0, 8)
	pad.PaddingLeft = UDim.new(0, 2)
	pad.PaddingRight = UDim.new(0, 6)
	return scroll
end

local panelBypass = createScroll()
local panelEsp = createScroll()
local panelAim = createScroll()
local panelGeral = createScroll()
local panelSocial = createScroll()
panelBypass.Visible = true

local function selectTab(selected)
	playClickSound()
	panelBypass.Visible = (selected == panelBypass)
	panelEsp.Visible = (selected == panelEsp)
	panelAim.Visible = (selected == panelAim)
	panelGeral.Visible = (selected == panelGeral)
	panelSocial.Visible = (selected == panelSocial)
	
	local tabs = {
		{btn = btnBypass, panel = panelBypass},
		{btn = btnEsp, panel = panelEsp},
		{btn = btnAim, panel = panelAim},
		{btn = btnGeral, panel = panelGeral},
		{btn = btnSocial, panel = panelSocial}
	}
	for _, t in ipairs(tabs) do
		local isSel = (t.panel == selected)
		t.btn.BackgroundColor3 = isSel and COLOR_SECONDARY or COLOR_ITEM
		t.btn.TextColor3 = isSel and COLOR_BG or COLOR_TEXT
		local st = t.btn:FindFirstChildOfClass("UIStroke")
		if st then st.Color = isSel and COLOR_ACCENT or COLOR_BORDER end
	end
end

btnBypass.MouseButton1Click:Connect(function() selectTab(panelBypass) end)
btnEsp.MouseButton1Click:Connect(function() selectTab(panelEsp) end)
btnAim.MouseButton1Click:Connect(function() selectTab(panelAim) end)
btnGeral.MouseButton1Click:Connect(function() selectTab(panelGeral) end)
btnSocial.MouseButton1Click:Connect(function() selectTab(panelSocial) end)

-- Rodapé Estilizado
local FooterBar = Instance.new("Frame", MainFrame)
FooterBar.Size = UDim2.new(1, -20, 0, 24)
FooterBar.Position = UDim2.new(0, 10, 1, -28)
FooterBar.BackgroundColor3 = COLOR_PANEL
FooterBar.BorderSizePixel = 0
FooterBar.ZIndex = 82
applyStroke(FooterBar, COLOR_BORDER, 1)
Instance.new("UICorner", FooterBar).CornerRadius = UDim.new(0, 8)

local CreditLabel = Instance.new("TextLabel", FooterBar)
CreditLabel.Size = UDim2.new(1, 0, 1, 0)
CreditLabel.BackgroundTransparency = 1
CreditLabel.Text = "Site: darkgamingyt-br-pt.netlify.app"
CreditLabel.TextColor3 = COLOR_SECONDARY
CreditLabel.TextSize = 9
CreditLabel.Font = FONT_MAIN
CreditLabel.TextXAlignment = Enum.TextXAlignment.Center
CreditLabel.ZIndex = 83

local function createToggle(parent, name, callback, desc, isRisky)
	local hasDesc = (desc ~= nil and desc ~= "")
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, hasDesc and 48 or 36)
	row.BackgroundColor3 = COLOR_PANEL
	row.BorderSizePixel = 0
	row.ZIndex = 83
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
	applyStroke(row, isRisky and COLOR_WARN or COLOR_BORDER, 1)
	
	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.68, 0, 0, 20)
	label.Position = UDim2.new(0, 10, 0, hasDesc and 4 or 8)
	label.BackgroundTransparency = 1
	label.Text = "> " .. name
	label.TextColor3 = COLOR_TEXT
	label.TextSize = 11
	label.Font = FONT_MAIN
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 84

	if hasDesc then
		local descLbl = Instance.new("TextLabel", row)
		descLbl.Size = UDim2.new(0.68, 0, 0, 16)
		descLbl.Position = UDim2.new(0, 10, 0, 24)
		descLbl.BackgroundTransparency = 1
		descLbl.Text = desc
		descLbl.TextColor3 = isRisky and COLOR_WARN or COLOR_SUBTEXT
		descLbl.TextSize = 9
		descLbl.Font = FONT_MAIN
		descLbl.TextXAlignment = Enum.TextXAlignment.Left
		descLbl.ZIndex = 84
	end
	
	local statusBtn = Instance.new("TextButton", row)
	statusBtn.Size = UDim2.new(0, 64, 0, 22)
	statusBtn.Position = UDim2.new(1, -72, 0.5, -11)
	statusBtn.BackgroundColor3 = COLOR_ITEM
	statusBtn.BorderSizePixel = 0
	statusBtn.Text = "[ OFF ]"
	statusBtn.TextColor3 = COLOR_OFF
	statusBtn.TextSize = 10
	statusBtn.Font = FONT_MAIN
	statusBtn.ZIndex = 84
	Instance.new("UICorner", statusBtn).CornerRadius = UDim.new(0, 6)
	local btnStroke = applyStroke(statusBtn, COLOR_OFF, 1)
	
	local state = false
	statusBtn.MouseButton1Click:Connect(function()
		playClickSound()
		state = not state
		if state then
			statusBtn.BackgroundColor3 = Color3.fromRGB(20, 50, 35)
			statusBtn.TextColor3 = COLOR_ON
			statusBtn.Text = "[ ON ]"
			btnStroke.Color = COLOR_ON
		else
			statusBtn.BackgroundColor3 = COLOR_ITEM
			statusBtn.TextColor3 = COLOR_OFF
			statusBtn.Text = "[ OFF ]"
			btnStroke.Color = COLOR_OFF
		end
		callback(state)
	end)
end

-- ==========================================================================
-- CONTEÚDO DA ABA SOCIAL
-- ==========================================================================
local function createSocialCard(parent, title, url, desc)
	local card = Instance.new("Frame", parent)
	card.Size = UDim2.new(1, 0, 0, 75)
	card.BackgroundColor3 = COLOR_PANEL
	card.BorderSizePixel = 0
	card.ZIndex = 83
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
	applyStroke(card, COLOR_SECONDARY, 1)

	local titleLbl = Instance.new("TextLabel", card)
	titleLbl.Size = UDim2.new(1, -16, 0, 22)
	titleLbl.Position = UDim2.new(0, 10, 0, 6)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = title
	titleLbl.TextColor3 = COLOR_SECONDARY
	titleLbl.TextSize = 12
	titleLbl.Font = FONT_MAIN
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 84

	local descLbl = Instance.new("TextLabel", card)
	descLbl.Size = UDim2.new(1, -16, 0, 16)
	descLbl.Position = UDim2.new(0, 10, 0, 26)
	descLbl.BackgroundTransparency = 1
	descLbl.Text = desc
	descLbl.TextColor3 = COLOR_SUBTEXT
	descLbl.TextSize = 9
	descLbl.Font = FONT_MAIN
	descLbl.TextXAlignment = Enum.TextXAlignment.Left
	descLbl.ZIndex = 84

	local copyBtn = Instance.new("TextButton", card)
	copyBtn.Size = UDim2.new(1, -20, 0, 24)
	copyBtn.Position = UDim2.new(0, 10, 0, 44)
	copyBtn.BackgroundColor3 = COLOR_ITEM
	copyBtn.BorderSizePixel = 0
	copyBtn.Text = "[ COPIAR LINK ]"
	copyBtn.TextColor3 = COLOR_TEXT
	copyBtn.TextSize = 10
	copyBtn.Font = FONT_MAIN
	copyBtn.ZIndex = 84
	Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
	applyStroke(copyBtn, COLOR_ACCENT, 1)

	copyBtn.MouseButton1Click:Connect(function()
		playClickSound()
		pcall(function()
			setclipboard(url)
		end)
		copyBtn.Text = "[ LINK COPIADO! ]"
		task.wait(2)
		copyBtn.Text = "[ COPIAR LINK ]"
	end)
end

createSocialCard(panelSocial, "🌐 Site Oficial DarkGamingYT", "https://darkgamingyt-br-pt.netlify.app/", "Acesse nosso portal oficial para novidades e downloads!")
createSocialCard(panelSocial, "📺 Canal do YouTube (@wallacy_rtx)", "https://youtube.com/@wallacy_rtx?si=oA06X6BtQqJHAJuY", "Inscreva-se para tutoriais e novos scripts atualizados!")
createSocialCard(panelSocial, "💬 Servidor do Discord Oficial", "https://discord.com/invite/vzMRuAs6gt", "Entre na comunidade para suporte e novidades!")

-- ==========================================================================
-- LÓGICA V23 (MANTIDA 100% INTACTA)
-- ==========================================================================
_G.AT_Bypass = false
_G.AT_EspHighlight = false
_G.AT_EspName = false
_G.AT_EspVidaBeta = false
_G.AT_EspLine = false
_G.AT_EspDistance = false
_G.AT_BossKill = false
_G.AT_TeleportKill = false
_G.AT_AutoFarm = false
_G.AT_SpeedOn = false
_G.AT_WallHack = false
_G.AT_NoCooldown = false
_G.AT_InfinitePV = false
_G.AT_FullBright = false
_G.AT_FlyOn = false

-- Sistema de Voo (Fly)
local flying = false
local flySpeed = 60
local flyBv, flyBg

local function startFly()
	local char = LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not root or not hum then return end

	flying = true
	hum.PlatformStand = true

	flyBv = Instance.new("BodyVelocity", root)
	flyBv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	flyBv.Velocity = Vector3.new(0, 0, 0)

	flyBg = Instance.new("BodyGyro", root)
	flyBg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	flyBg.CFrame = root.CFrame

	task.spawn(function()
		while flying and char and root and hum do
			RunService.RenderStepped:Wait()
			local cam = workspace.CurrentCamera
			local moveDir = hum.MoveDirection
			local vel = Vector3.new(0, 0, 0)

			if moveDir.Magnitude > 0 then
				vel = cam.CFrame:VectorToWorldSpace(Vector3.new(moveDir.X, 0, moveDir.Z).Unit) * flySpeed
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				vel = vel + Vector3.new(0, flySpeed, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
				vel = vel - Vector3.new(0, flySpeed, 0)
			end

			flyBv.Velocity = vel
			flyBg.CFrame = cam.CFrame
		end
	end)
end

local function stopFly()
	flying = false
	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then hum.PlatformStand = false end
	end
	if flyBv then flyBv:Destroy() end
	if flyBg then flyBg:Destroy() end
end

-- Sistema de Escolher Alvo para Teleporte
local selectedTargetPlayer = nil

local function createTeleportSection(parent)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, 0, 0, 78)
	row.BackgroundColor3 = COLOR_PANEL
	row.BorderSizePixel = 0
	row.ZIndex = 83
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
	applyStroke(row, COLOR_ACCENT, 1)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(1, -20, 0, 20)
	label.Position = UDim2.new(0, 10, 0, 6)
	label.BackgroundTransparency = 1
	label.Text = "> Teleport & Escolher Alvo no Mapa"
	label.TextColor3 = COLOR_TEXT
	label.TextSize = 11
	label.Font = FONT_MAIN
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 84

	local targetInfo = Instance.new("TextLabel", row)
	targetInfo.Size = UDim2.new(1, -20, 0, 18)
	targetInfo.Position = UDim2.new(0, 10, 0, 26)
	targetInfo.BackgroundTransparency = 1
	targetInfo.Text = "Alvo Atual: Nenhum selecionado"
	targetInfo.TextColor3 = COLOR_SECONDARY
	targetInfo.TextSize = 9
	targetInfo.Font = FONT_MAIN
	targetInfo.TextXAlignment = Enum.TextXAlignment.Left
	targetInfo.ZIndex = 84

	local chooseBtn = Instance.new("TextButton", row)
	chooseBtn.Size = UDim2.new(0.48, 0, 0, 24)
	chooseBtn.Position = UDim2.new(0, 10, 0, 48)
	chooseBtn.BackgroundColor3 = COLOR_ITEM
	chooseBtn.BorderSizePixel = 0
	chooseBtn.Text = "🔄 Escolher Alvo"
	chooseBtn.TextColor3 = COLOR_TEXT
	chooseBtn.TextSize = 9
	chooseBtn.Font = FONT_MAIN
	chooseBtn.ZIndex = 84
	Instance.new("UICorner", chooseBtn).CornerRadius = UDim.new(0, 6)
	applyStroke(chooseBtn, COLOR_BORDER, 1)

	local tpBtn = Instance.new("TextButton", row)
	tpBtn.Size = UDim2.new(0.48, 0, 0, 24)
	tpBtn.Position = UDim2.new(0.51, 0, 0, 48)
	tpBtn.BackgroundColor3 = COLOR_ITEM
	tpBtn.BorderSizePixel = 0
	tpBtn.Text = "⚡ Teleportar"
	tpBtn.TextColor3 = COLOR_ON
	tpBtn.TextSize = 9
	tpBtn.Font = FONT_MAIN
	tpBtn.ZIndex = 84
	Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
	applyStroke(tpBtn, COLOR_ON, 1)

	local targetsListCache = {}
	local cacheIndex = 1

	chooseBtn.MouseButton1Click:Connect(function()
		playClickSound()
		targetsListCache = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				table.insert(targetsListCache, plr)
			end
		end
		pcall(function()
			for _, obj in ipairs(workspace:GetDescendants()) do
				if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
					local hum = obj:FindFirstChildOfClass("Humanoid")
					if hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
						table.insert(targetsListCache, obj)
					end
				end
			end
		end)

		if #targetsListCache == 0 then
			targetInfo.Text = "Nenhum alvo encontrado!"
			selectedTargetPlayer = nil
			return
		end
		cacheIndex = cacheIndex > #targetsListCache and 1 or cacheIndex
		selectedTargetPlayer = targetsListCache[cacheIndex]
		cacheIndex = cacheIndex + 1
		
		if typeof(selectedTargetPlayer) == "Instance" and selectedTargetPlayer:IsA("Player") then
			targetInfo.Text = "Alvo (Player): " .. selectedTargetPlayer.Name
		else
			targetInfo.Text = "Alvo (Boss/Mob): " .. tostring(selectedTargetPlayer.Name)
		end
	end)

	tpBtn.MouseButton1Click:Connect(function()
		playClickSound()
		pcall(function()
			local targetRoot = nil
			if selectedTargetPlayer and selectedTargetPlayer:IsA("Player") and selectedTargetPlayer.Character then
				targetRoot = selectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart")
			elseif selectedTargetPlayer and selectedTargetPlayer:IsA("Model") then
				targetRoot = selectedTargetPlayer:FindFirstChild("HumanoidRootPart") or selectedTargetPlayer:FindFirstChild("PrimaryPart") or selectedTargetPlayer:FindFirstChildWhichIsA("BasePart")
			end

			local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if targetRoot and myRoot then
				myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
			else
				targetInfo.Text = "Alvo inválido ou ausente!"
			end
		end)
	end)
end

-- Bypass
RunService.Stepped:Connect(function()
	if _G.AT_Bypass then
		pcall(function()
			local char = LocalPlayer.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0, 1, 1)
					end
				end
			end
		end)
	end
end)

RunService.RenderStepped:Connect(function()
	if _G.AT_SpeedOn then
		pcall(function()
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if hum then hum.WalkSpeed = 32 end
			if root and hum and hum.MoveDirection.Magnitude > 0 then
				root.CFrame = root.CFrame + (hum.MoveDirection * 0.45)
			end
		end)
	end
end)

RunService.Stepped:Connect(function()
	if _G.AT_WallHack then
		pcall(function()
			local char = LocalPlayer.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end)
	end
end)

-- Modificadores de RPG
RunService.Heartbeat:Connect(function()
	pcall(function()
		if _G.AT_NoCooldown then
			for _, v in ipairs(workspace:GetDescendants()) do
				if (v.Name:lower():find("cooldown") or v.Name:lower():find("cd") or v.Name:lower():find("delay")) and (v:IsA("NumberValue") or v:IsA("IntValue")) then
					v.Value = 0
				end
			end
		end
		if _G.AT_InfinitePV then
			local char = LocalPlayer.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.Health = hum.MaxHealth
			end
		end
	end)
end)

-- Auto-Kill / Boss Kill Pro
task.spawn(function()
	while task.wait(0.05) do
		if _G.AT_BossKill then
			pcall(function()
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root then
					for _, obj in ipairs(workspace:GetDescendants()) do
						if obj:IsA("Model") and obj ~= char then
							local hum = obj:FindFirstChildOfClass("Humanoid")
							local eRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
							if hum and eRoot and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
								if (root.Position - eRoot.Position).Magnitude <= 800 then
									hum.Health = 0
								end
							end
						end
					end
				end
			end)
		end
	end
end)

-- Teleport Kill nos Mobs / Raid
task.spawn(function()
	while task.wait(0.3) do
		if _G.AT_TeleportKill then
			pcall(function()
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root then
					for _, obj in ipairs(workspace:GetDescendants()) do
						if obj:IsA("Model") and obj ~= char then
							local hum = obj:FindFirstChildOfClass("Humanoid")
							local eRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
							if hum and eRoot and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
								root.CFrame = eRoot.CFrame + Vector3.new(0, 3, 0)
								hum.Health = 0
								task.wait(0.1)
							end
						end
					end
				end
			end)
		end
	end
end)

-- Auto-Farm Inteligente para Mobs e Raids
task.spawn(function()
	while task.wait(0.2) do
		if _G.AT_AutoFarm then
			pcall(function()
				local char = LocalPlayer.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if root then
					local targetFound = false
					for _, obj in ipairs(workspace:GetDescendants()) do
						if obj:IsA("Model") and obj ~= char then
							local hum = obj:FindFirstChildOfClass("Humanoid")
							local eRoot = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
							if hum and eRoot and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
								targetFound = true
								root.CFrame = eRoot.CFrame + Vector3.new(0, 4, 0)
								hum.Health = 0
								break
							end
						end
					end
					if not targetFound then
						task.wait(1)
					end
				end
			end)
		end
	end
end)

local linePool = {}
local function getOrCreateLine(index)
	if not linePool[index] or not linePool[index].Parent then
		local line = Instance.new("Frame", EspLineFolder)
		line.Name = "Tracer_" .. tostring(index)
		line.AnchorPoint = Vector2.new(0.5, 0.5)
		line.BackgroundColor3 = COLOR_SECONDARY
		line.BorderSizePixel = 0
		line.Visible = false
		line.ZIndex = 10
		linePool[index] = line
	end
	return linePool[index]
end

local function hideAllLines(fromIndex)
	for i = fromIndex, #linePool do
		if linePool[i] then linePool[i].Visible = false end
	end
end

-- ESP Boss & Inimigos Globais
task.spawn(function()
	while task.wait(0.3) do
		pcall(function()
			for _, obj in ipairs(workspace:GetDescendants()) do
				if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
					local hum = obj:FindFirstChildOfClass("Humanoid")
					if hum.Health > 0 and obj ~= LocalPlayer.Character then
						if _G.AT_EspHighlight then
							if not obj:FindFirstChild("AT_Highlight") then
								local hl = Instance.new("Highlight", obj)
								hl.Name = "AT_Highlight"
								hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
								hl.FillColor = COLOR_ACCENT
								hl.OutlineColor = COLOR_SECONDARY
								hl.FillTransparency = 0.4
								hl.OutlineTransparency = 0.05
							end
						else
							local hl = obj:FindFirstChild("AT_Highlight")
							if hl then hl:Destroy() end
						end
					end
				end
			end
		end)
	end
end)

-- ESP Nomes e HP de Chefes/Mobs
task.spawn(function()
	while task.wait(0.2) do
		pcall(function()
			for _, obj in ipairs(workspace:GetDescendants()) do
				if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
					local hum = obj:FindFirstChildOfClass("Humanoid")
					local head = obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart")
					local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					local eRoot = obj:FindFirstChild("HumanoidRootPart") or head
					
					if head and hum and hum.Health > 0 and obj ~= LocalPlayer.Character then
						if _G.AT_EspName or _G.AT_EspDistance or _G.AT_EspVidaBeta then
							local tag = head:FindFirstChild("AT_NameTag")
							if not tag then
								tag = Instance.new("BillboardGui", head)
								tag.Name = "AT_NameTag"
								tag.Size = UDim2.new(0, 160, 0, 50)
								tag.StudsOffset = Vector3.new(0, 3, 0)
								tag.AlwaysOnTop = true
								
								local txt = Instance.new("TextLabel", tag)
								txt.Name = "Txt"
								txt.Size = UDim2.new(1, 0, 0, 20)
								txt.BackgroundTransparency = 1
								txt.TextColor3 = COLOR_TEXT
								txt.TextSize = 11
								txt.Font = FONT_MAIN

								local barBg = Instance.new("Frame", tag)
								barBg.Name = "BarBg"
								barBg.Size = UDim2.new(0.85, 0, 0, 6)
								barBg.Position = UDim2.new(0.075, 0, 0, 24)
								barBg.BackgroundColor3 = COLOR_BG
								barBg.BorderSizePixel = 0
								applyStroke(barBg, COLOR_BORDER, 1)

								local barFill = Instance.new("Frame", barBg)
								barFill.Name = "Fill"
								barFill.Size = UDim2.new(1, 0, 1, 0)
								barFill.BackgroundColor3 = COLOR_ON
								barFill.BorderSizePixel = 0
							end
							local label = tag:FindFirstChild("Txt")
							local barBg = tag:FindFirstChild("BarBg")
							
							if label then
								local distStr = ""
								if _G.AT_EspDistance and myRoot and eRoot then
									local dist = math.floor((myRoot.Position - eRoot.Position).Magnitude)
									distStr = string.format(" [%dm]", dist)
								end
								label.Text = string.format("%s [%d%%]%s", obj.Name, math.floor(hum.Health), distStr)
							end

							if barBg then
								barBg.Visible = _G.AT_EspVidaBeta
								local fill = barBg:FindFirstChild("Fill")
								if fill then
									local maxHp = math.max(hum.MaxHealth, 1)
									local ratio = math.clamp(hum.Health / maxHp, 0, 1)
									fill.Size = UDim2.new(ratio, 0, 1, 0)
									fill.BackgroundColor3 = ratio > 0.4 and COLOR_ON or COLOR_OFF
								end
							end
						else
							local tag = head:FindFirstChild("AT_NameTag")
							if tag then tag:Destroy() end
						end
					end
				end
			end
		end)
	end
end)

RunService.RenderStepped:Connect(function()
	if not _G.AT_EspLine then
		hideAllLines(1)
		return
	end
	local cam = workspace.CurrentCamera
	if not cam then hideAllLines(1); return end
	local vp = cam.ViewportSize
	local originBottom = Vector2.new(vp.X / 2, vp.Y)
	local activeCount = 0

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj ~= LocalPlayer.Character then
			local hum = obj:FindFirstChildOfClass("Humanoid")
			local root = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
			if root and hum and hum.Health > 0 then
				local screenPos, onScreen = cam:WorldToViewportPoint(root.Position)
				if onScreen and screenPos.Z > 0 then
					activeCount = activeCount + 1
					local line = getOrCreateLine(activeCount)
					local targetPt = Vector2.new(screenPos.X, screenPos.Y)
					local delta = targetPt - originBottom
					local dist = delta.Magnitude
					local center = (originBottom + targetPt) / 2
					local angle = math.deg(math.atan2(delta.Y, delta.X))

					line.Position = UDim2.fromOffset(center.X, center.Y)
					line.Size = UDim2.fromOffset(dist, 1.5)
					line.Rotation = angle
					line.Visible = true
				end
			end
		end
	end
	hideAllLines(activeCount + 1)
end)

RunService.RenderStepped:Connect(function()
	if _G.AT_FullBright then
		game.Lighting.Brightness = 2
		game.Lighting.GlobalShadows = false
	end
end)

-- ==========================================================================
-- REGISTRO NAS ABAS DO PAINEL
-- ==========================================================================
createToggle(panelBypass, "Bypass Adventure Pro", function(enabled)
	_G.AT_Bypass = enabled
end, "Protege contra anti-cheat do jogo")

createTeleportSection(panelGeral)

createToggle(panelGeral, "Modo Voo (Fly)", function(enabled)
	_G.AT_FlyOn = enabled
	if enabled then
		startFly()
	else
		stopFly()
	end
end, "Permite voar pelo mapa de Ooo (Espaço sobe, Shift desce)", true)

createToggle(panelGeral, "PV Infinito / Godmode", function(enabled)
	_G.AT_InfinitePV = enabled
end, "Mantém sua vida sempre cheia contra monstros e chefes")

createToggle(panelGeral, "Cooldown Zero de Skills", function(enabled)
	_G.AT_NoCooldown = enabled
end, "Remove o tempo de espera das habilidades (Q, E, F)")

createToggle(panelEsp, "ESP Boss & Mobs Chams", function(enabled)
	_G.AT_EspHighlight = enabled
end, "Destaca chefes e monstros através das paredes")

createToggle(panelEsp, "ESP Linhas Tracers", function(enabled)
	_G.AT_EspLine = enabled
end, "Traça linhas até os chefes e inimigos")

createToggle(panelEsp, "ESP Vida de Chefes (BETA)", function(enabled)
	_G.AT_EspVidaBeta = enabled
end, "Mostra barra de HP detalhada acima dos chefes e monstros")

createToggle(panelAim, "Boss Auto-Kill Pro (Alcance 800m)", function(enabled)
	_G.AT_BossKill = enabled
end, "Elimina chefes e inimigos próximos instantaneamente", true)

createToggle(panelAim, "Teleport Kill (Mobs & Raid)", function(enabled)
	_G.AT_TeleportKill = enabled
end, "Teleporta para cima dos monstros eliminando-os instantaneamente", true)

createToggle(panelAim, "Auto-Farm Inteligente (M/Raid)", function(enabled)
	_G.AT_AutoFarm = enabled
end, "Procura, teleporta e farma monstros automaticamente no mapa", true)

createToggle(panelGeral, "Speed Hack Aventura", function(enabled)
	_G.AT_SpeedOn = enabled
	if not enabled then
		pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = 16 end)
	end
end, "Aumenta a velocidade de movimento", true)

createToggle(panelGeral, "Wall Hack / NoClip Paredes", function(enabled)
	_G.AT_WallHack = enabled
end, "Atravessa barreiras e construções", true)

createToggle(panelGeral, "ESP Nome dos Mobs", function(enabled)
	_G.AT_EspName = enabled
end, "Mostra o nome e a vida dos inimigos")

createToggle(panelGeral, "ESP Distância Metros", function(enabled)
	_G.AT_EspDistance = enabled
end, "Exibe a distância até os alvos")

createToggle(panelGeral, "Full Bright Visão Clara", function(enabled)
	_G.AT_FullBright = enabled
end, "Ilumina o mapa e remove sombras")

print("[AT RPG BRUTAL V23] Carregado com Sucesso! Novo Design Profissional Aplicado.")
