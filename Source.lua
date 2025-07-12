--[[ 
Blox Fruits Mobile Script - GUI/AutoFarm/ESP/Teleport/Aimbot/WeaponSelect/Extras
Agora com Auto Gira Fruta, Auto Haki, Auto Attack.
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- Configs
local ICON_ID = "rbxassetid://13433967006"
local GUI_NAME = "BloxFruitsMobileGui"

-- Weapon select config
local WeaponTypes = {"Melee", "Sword", "Gun", "Blox Fruit"}
local SelectedWeaponType = "Melee"

-- Auto funções extras
local AutoAttack = false
local AutoHaki = false
local AutoSpin = false

-- Função para criar um botão flutuante (ícone ninja)
function CreateFloatingIcon()
    local sgui = Instance.new("ScreenGui", game.CoreGui)
    sgui.Name = GUI_NAME

    local icon = Instance.new("ImageButton")
    icon.Name = "NinjaIcon"
    icon.Parent = sgui
    icon.Size = UDim2.new(0,60,0,60)
    icon.Position = UDim2.new(0.04,0,0.5,-30)
    icon.Image = ICON_ID
    icon.BackgroundTransparency = 1
    icon.Draggable = true

    return icon, sgui
end

-- Função para criar a Janela Principal
function CreateMainWindow(parent)
    local frame = Instance.new("Frame", parent)
    frame.Name = "MainWindow"
    frame.Size = UDim2.new(0, 350, 0, 600)
    frame.Position = UDim2.new(0.12, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BackgroundTransparency = 0.2
    frame.Visible = false
    frame.Active = true
    frame.Draggable = true

    local uicorner = Instance.new("UICorner", frame)
    uicorner.CornerRadius = UDim.new(0, 15)

    local title = Instance.new("TextLabel", frame)
    title.Text = "Blox Fruits Mobile Hub"
    title.Size = UDim2.new(1, 0, 0, 36)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true

    return frame
end

-- Notificação
function Notify(msg)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Blox Fruits Mobile";
            Text = msg;
            Duration = 3;
        })
    end)
end

-- Mar e Ilhas
local Seas = {
    [1] = {"Starter Island","Jungle","Pirate Village","Desert","Middle Town","Frozen Village","Marine Fortress","Skylands","Prison","Colosseum","Magma Village","Underwater City","Fountain City","Shank's Room"},
    [2] = {"Cafe","Dark Arena","Usoap's Island","Kingdom of Rose","Green Zone","Graveyard","Dark Arena","Snow Mountain","Hot and Cold","Cursed Ship","Ice Castle","Forgotten Island"},
    [3] = {"Port Town","Great Tree","Castle on the Sea","Hydra Island","Floating Turtle","Haunted Castle","Sea of Treats"}
}
function GetCurrentSea()
    local placeId = game.PlaceId
    if placeId == 2753915549 then return 1 end
    if placeId == 4442272183 then return 2 end
    if placeId == 7449423635 then return 3 end
    return 1
end

function TeleportToIsland(islandName)
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Part") and v.Name:lower():find(islandName:lower()) then
            LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0,5,0)
            return true
        end
    end
    Notify("Ilha não encontrada!")
    return false
end

function ChangeSea(sea)
    local current = GetCurrentSea()
    if sea == current then
        Notify("Você já está neste mar!")
        return
    end
    local level = LocalPlayer.Data.Level.Value
    if sea == 2 and level < 700 then
        Notify("Você não tem esse mar ainda!")
        return
    elseif sea == 3 and level < 1500 then
        Notify("Você não tem esse mar ainda!")
        return
    end
    ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelMain")
    Notify("Mudando de mar... Se não funcionar, tente manualmente!")
end

-- Selecionar arma correta
function SelectWeapon()
    local backpack = LocalPlayer.Backpack
    local char = LocalPlayer.Character
    local weaponToEquip = nil
    for _,item in pairs(backpack:GetChildren()) do
        if SelectedWeaponType == "Melee" and item:IsA("Tool") and item.ToolTip:find("Melee") then
            weaponToEquip = item
            break
        elseif SelectedWeaponType == "Sword" and item:IsA("Tool") and item.ToolTip:find("Sword") then
            weaponToEquip = item
            break
        elseif SelectedWeaponType == "Gun" and item:IsA("Tool") and item.ToolTip:find("Gun") then
            weaponToEquip = item
            break
        elseif SelectedWeaponType == "Blox Fruit" and item:IsA("Tool") and item.ToolTip:find("Blox Fruit") then
            weaponToEquip = item
            break
        end
    end
    if weaponToEquip then
        LocalPlayer.Character.Humanoid:EquipTool(weaponToEquip)
    else
        for _,item in pairs(char:GetChildren()) do
            if SelectedWeaponType == "Melee" and item:IsA("Tool") and item.ToolTip:find("Melee") then
                weaponToEquip = item
                break
            elseif SelectedWeaponType == "Sword" and item:IsA("Tool") and item.ToolTip:find("Sword") then
                weaponToEquip = item
                break
            elseif SelectedWeaponType == "Gun" and item:IsA("Tool") and item.ToolTip:find("Gun") then
                weaponToEquip = item
                break
            elseif SelectedWeaponType == "Blox Fruit" and item:IsA("Tool") and item.ToolTip:find("Blox Fruit") then
                weaponToEquip = item
                break
            end
        end
    end
    return weaponToEquip
end

-- Auto Farm
local Autofarm = false
function StartAutofarm()
    Autofarm = true
    spawn(function()
        while Autofarm do
            local level = LocalPlayer.Data.Level.Value
            local enemy = nil
            for _,v in pairs(Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    enemy = v
                    break
                end
            end
            if enemy and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                SelectWeapon()
                LocalPlayer.Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                if AutoAttack then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack", enemy.Name)
                end
            end
            wait(1)
        end
    end)
end

function StopAutofarm()
    Autofarm = false
end

-- Auto coletar baús
local AutoChest = false
function StartAutoChest()
    AutoChest = true
    spawn(function()
        while AutoChest do
            for _, v in pairs(Workspace:GetChildren()) do
                if v.Name:find("Chest") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame + Vector3.new(0,3,0)
                    wait(0.7)
                end
            end
            wait(3)
        end
    end)
end
function StopAutoChest() AutoChest = false end

-- ESP
function ToggleESP(type, state)
    for _, obj in pairs(Workspace:GetChildren()) do
        if (type == "Player" and Players:FindFirstChild(obj.Name)) or (type == "Fruit" and obj.Name:find("Fruit")) then
            if state then
                if not obj:FindFirstChild("ESP") then
                    local bill = Instance.new("BillboardGui", obj)
                    bill.Name = "ESP"
                    bill.Size = UDim2.new(0,100,0,40)
                    bill.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bill)
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.BackgroundTransparency = 1
                    txt.Text = obj.Name
                    txt.TextColor3 = type == "Player" and Color3.new(1,1,0) or Color3.new(1,0,0)
                    txt.TextScaled = true
                end
            else
                if obj:FindFirstChild("ESP") then
                    obj.ESP:Destroy()
                end
            end
        end
    end
end

-- Aimbot para jogadores
local AimbotActive = false
function GetClosestPlayerToCursor()
    local camera = Workspace.CurrentCamera
    local closest, shortest = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 then
            local pos, onscreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onscreen then
                local mouse = UserInputService:GetMouseLocation()
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = plr
                end
            end
        end
    end
    return closest
end

function StartAimbot()
    AimbotActive = true
    spawn(function()
        while AimbotActive do
            local target = GetClosestPlayerToCursor()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Workspace.CurrentCamera.CFrame = CFrame.new(
                    Workspace.CurrentCamera.CFrame.Position,
                    target.Character.HumanoidRootPart.Position
                )
            end
            wait(0.02)
        end
    end)
end
function StopAimbot() AimbotActive = false end

-- AUTO HAKI
function StartAutoHaki()
    AutoHaki = true
    spawn(function()
        while AutoHaki do
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local haki = char:FindFirstChild("HasBuso")
                if not haki or haki.Value == false then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Buso")
                end
            end
            wait(2)
        end
    end)
end
function StopAutoHaki() AutoHaki = false end

-- AUTO ATTACK
function StartAutoAttack()
    AutoAttack = true
    spawn(function()
        while AutoAttack do
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                for _,v in pairs(getconnections(LocalPlayer.PlayerGui.Main.SwordButton.MouseButton1Click)) do
                    v:Fire()
                end
            end
            wait(0.2)
        end
    end)
end
function StopAutoAttack() AutoAttack = false end

-- AUTO GIRAR FRUTA
function StartAutoSpin()
    AutoSpin = true
    spawn(function()
        while AutoSpin do
            ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin","Buy")
            wait(3600) -- Girar a cada hora (ajuste se quiser girar mais rápido)
        end
    end)
end
function StopAutoSpin() AutoSpin = false end

-- GUI e toggles
local icon, gui = CreateFloatingIcon()
local mainWin = CreateMainWindow(gui)
icon.MouseButton1Click:Connect(function() mainWin.Visible = not mainWin.Visible end)

-- Spinner "Select Weapon to Farm"
local spinnerFrame = Instance.new("Frame", mainWin)
spinnerFrame.Size = UDim2.new(0.9, 0, 0, 36)
spinnerFrame.Position = UDim2.new(0.05,0,0,45)
spinnerFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
spinnerFrame.BackgroundTransparency = 0.2
local spinnerCorner = Instance.new("UICorner", spinnerFrame)
spinnerCorner.CornerRadius = UDim.new(0, 6)

local spinnerLeft = Instance.new("TextButton", spinnerFrame)
spinnerLeft.Text = "<"
spinnerLeft.Size = UDim2.new(0,36,1,0)
spinnerLeft.Font = Enum.Font.GothamBold
spinnerLeft.TextColor3 = Color3.new(1,1,1)
spinnerLeft.BackgroundTransparency = 1

local spinnerRight = Instance.new("TextButton", spinnerFrame)
spinnerRight.Text = ">"
spinnerRight.Size = UDim2.new(0,36,1,0)
spinnerRight.Position = UDim2.new(1,-36,0,0)
spinnerRight.Font = Enum.Font.GothamBold
spinnerRight.TextColor3 = Color3.new(1,1,1)
spinnerRight.BackgroundTransparency = 1

local spinnerLabel = Instance.new("TextLabel", spinnerFrame)
spinnerLabel.Text = "Select Weapon: "..SelectedWeaponType
spinnerLabel.Size = UDim2.new(1,-72,1,0)
spinnerLabel.Position = UDim2.new(0,36,0,0)
spinnerLabel.Font = Enum.Font.Gotham
spinnerLabel.TextColor3 = Color3.new(1,1,1)
spinnerLabel.BackgroundTransparency = 1
spinnerLabel.TextScaled = true

local weaponIndex = 1
local function UpdateSpinner()
    SelectedWeaponType = WeaponTypes[weaponIndex]
    spinnerLabel.Text = "Select Weapon: "..SelectedWeaponType
end
spinnerLeft.MouseButton1Click:Connect(function()
    weaponIndex = weaponIndex - 1
    if weaponIndex < 1 then weaponIndex = #WeaponTypes end
    UpdateSpinner()
end)
spinnerRight.MouseButton1Click:Connect(function()
    weaponIndex = weaponIndex + 1
    if weaponIndex > #WeaponTypes then weaponIndex = 1 end
    UpdateSpinner()
end)
UpdateSpinner()

-- Adiciona botões e funções à GUI
local function AddToggle(name, parent, yPos, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9,0,0,36)
    btn.Position = UDim2.new(0.05,0,0,yPos)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.new(1,1,1)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0,120,255) or Color3.fromRGB(30,30,30)
        callback(state)
    end)
    return btn
end

AddToggle("Auto Farm", mainWin, 90, function(state)
    if state then StartAutofarm() else StopAutofarm() end
end)
AddToggle("Auto Chest", mainWin, 140, function(state)
    if state then StartAutoChest() else StopAutoChest() end
end)
AddToggle("ESP Players", mainWin, 190, function(state)
    ToggleESP("Player", state)
end)
AddToggle("ESP Frutas", mainWin, 240, function(state)
    ToggleESP("Fruit", state)
end)
AddToggle("Aimbot Players", mainWin, 290, function(state)
    if state then StartAimbot() else StopAimbot() end
end)
AddToggle("Auto Haki", mainWin, 340, function(state)
    if state then StartAutoHaki() else StopAutoHaki() end
end)
AddToggle("Auto Attack", mainWin, 390, function(state)
    if state then StartAutoAttack() else StopAutoAttack() end
end)
AddToggle("Auto Gira Fruta", mainWin, 440, function(state)
    if state then StartAutoSpin() else StopAutoSpin() end
end)

-- Dropdown de ilhas para teleporte
local drop = Instance.new("TextBox", mainWin)
drop.Size = UDim2.new(0.9,0,0,32)
drop.Position = UDim2.new(0.05,0,0,490)
drop.PlaceholderText = "Digite o nome da ilha para teleportar"
drop.Font = Enum.Font.Gotham
drop.TextColor3 = Color3.new(1,1,1)
drop.BackgroundColor3 = Color3.fromRGB(30,30,30)
drop.FocusLost:Connect(function()
    local sea = GetCurrentSea()
    local found = false
    for _, isl in ipairs(Seas[sea]) do
        if isl:lower():find(drop.Text:lower()) then
            TeleportToIsland(isl)
            found = true
            break
        end
    end
    if not found then
        Notify("Ilha não encontrada neste mar!")
    end
end)

-- Dropdown para trocar de mar
local changeSeaBox = Instance.new("TextBox", mainWin)
changeSeaBox.Size = UDim2.new(0.9,0,0,32)
changeSeaBox.Position = UDim2.new(0.05,0,0,530)
changeSeaBox.PlaceholderText = "Digite 1, 2 ou 3 para trocar de mar"
changeSeaBox.Font = Enum.Font.Gotham
changeSeaBox.TextColor3 = Color3.new(1,1,1)
changeSeaBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
changeSeaBox.FocusLost:Connect(function()
    local num = tonumber(changeSeaBox.Text)
    if num and num >= 1 and num <= 3 then
        ChangeSea(num)
    else
        Notify("Digite apenas 1, 2 ou 3!")
    end
end)

-- Funções extras: teleport para player
local tpPlayerBox = Instance.new("TextBox", mainWin)
tpPlayerBox.Size = UDim2.new(0.9,0,0,32)
tpPlayerBox.Position = UDim2.new(0.05,0,0,570)
tpPlayerBox.PlaceholderText = "Digite nick para teleportar até player"
tpPlayerBox.Font = Enum.Font.Gotham
tpPlayerBox.TextColor3 = Color3.new(1,1,1)
tpPlayerBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
tpPlayerBox.FocusLost:Connect(function()
    local target = Players:FindFirstChild(tpPlayerBox.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
        Notify("Teleportado até "..tpPlayerBox.Text)
    else
        Notify("Player não encontrado!")
    end
end)

-- Créditos
local credit = Instance.new("TextLabel", mainWin)
credit.Size = UDim2.new(1,0,0,30)
credit.Position = UDim2.new(0,0,1,-30)
credit.Text = "Feito por Copilot/FakeTsyo - github.com"
credit.Font = Enum.Font.Gotham
credit.TextColor3 = Color3.fromRGB(180,180,180)
credit.BackgroundTransparency = 1
credit.TextScaled = true

Notify("Script Blox Fruits Mobile carregado!")
