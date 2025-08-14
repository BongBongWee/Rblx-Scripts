local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = " Hood Stars Timmyhub GUI ⭐️",
    LoadingTitle = "Hood Stars GUI ⭐️",
    LoadingSubtitle = "by Tinmmy",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "HoodStarsConfig"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
    Theme = "Amethyst",
    ToggleUIKeybind = "X"
})

-- Create tabs
local MainTab = Window:CreateTab("Main", "play-circle")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local TeleportsTab = Window:CreateTab("Teleports", "map-pin")
local ModsTab = Window:CreateTab("Fun / Mods", "settings-2")

-- Create sections in each tab (empty sections)
MainTab:CreateSection("Main Section")
VisualsTab:CreateSection("Visuals / Esp Section")
TeleportsTab:CreateSection("Teleport Section")
ModsTab:CreateSection("Fun / Mods Section")

-- MAIN TAB

local circle
local loop
local lockedTarget = nil

MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "StickyAimbotToggle",
    Callback = function(enabled)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local Camera = workspace.CurrentCamera

        local FOV = 200
        local AimStrength = 1
        local AimBone = "Head"

        local function lerp(a, b, t)
            return a + (b - a) * t
        end

        local function getClosest()
            local closestPart = nil
            local shortestDist = FOV + 1000

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer then
                    local character = player.Character
                    local targetPart = character and character:FindFirstChild(AimBone)
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    if targetPart and humanoid and humanoid.Health > 0 then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                            if dist < shortestDist and dist <= FOV then
                                shortestDist = dist
                                closestPart = targetPart
                            end
                        end
                    end
                end
            end

            return closestPart, shortestDist
        end

        if enabled then
            if not circle then
                circle = Drawing.new("Circle")
                circle.Color = Color3.new(1, 1, 1)
                circle.Thickness = 1
                circle.NumSides = 100
                circle.Radius = FOV
                circle.Transparency = 1
                circle.Filled = false
                circle.Visible = true
            end

            loop = RunService.RenderStepped:Connect(function()
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                circle.Position = screenCenter

                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    if not lockedTarget or not lockedTarget.Parent or lockedTarget.Parent:FindFirstChild("Humanoid") == nil or lockedTarget.Parent.Humanoid.Health <= 0 then
                        lockedTarget = getClosest()
                    end
                else
                    lockedTarget = nil
                end

                if lockedTarget and lockedTarget.Parent and lockedTarget.Parent:FindFirstChild("Humanoid") and lockedTarget.Parent.Humanoid.Health > 0 then
                    local direction = (lockedTarget.Position - Camera.CFrame.Position).Unit
                    local goal = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
                    Camera.CFrame = Camera.CFrame:Lerp(goal, AimStrength)

                    local screenPos, _ = Camera:WorldToViewportPoint(lockedTarget.Position)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude

                    local shrinkRadius = math.max(dist, 20)
                    circle.Radius = lerp(circle.Radius, shrinkRadius, 0.3)
                    circle.Color = Color3.new(1, 0, 0)
                else
                    circle.Radius = lerp(circle.Radius, FOV, 0.15)
                    circle.Color = Color3.new(1, 1, 1)
                    lockedTarget = nil
                end
            end)
        else
            if loop then
                loop:Disconnect()
                loop = nil
            end
            if circle then
                circle:Remove()
                circle = nil
            end
            lockedTarget = nil
        end
    end,
})

local circleIgnoreFriends
local loopIgnoreFriends
local lockedTargetIgnoreFriends = nil

MainTab:CreateToggle({
    Name = "Aimbot {ignore friends}",
    CurrentValue = false,
    Flag = "StickyAimbotIgnoreFriendsToggle",
    Callback = function(enabled)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local Camera = workspace.CurrentCamera

        local FOV = 200
        local AimStrength = 1
        local AimBone = "Head"

        local function lerp(a, b, t)
            return a + (b - a) * t
        end

        local function getClosest()
            local closestPart = nil
            local shortestDist = FOV + 1000

            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and not Players.LocalPlayer:IsFriendsWith(player.UserId) then
                    local character = player.Character
                    local targetPart = character and character:FindFirstChild(AimBone)
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    if targetPart and humanoid and humanoid.Health > 0 then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                            if dist < shortestDist and dist <= FOV then
                                shortestDist = dist
                                closestPart = targetPart
                            end
                        end
                    end
                end
            end

            return closestPart, shortestDist
        end

        if enabled then
            if not circleIgnoreFriends then
                circleIgnoreFriends = Drawing.new("Circle")
                circleIgnoreFriends.Color = Color3.new(1, 1, 1)
                circleIgnoreFriends.Thickness = 1
                circleIgnoreFriends.NumSides = 100
                circleIgnoreFriends.Radius = FOV
                circleIgnoreFriends.Transparency = 1
                circleIgnoreFriends.Filled = false
                circleIgnoreFriends.Visible = true
            end

            loopIgnoreFriends = RunService.RenderStepped:Connect(function()
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                circleIgnoreFriends.Position = screenCenter

                if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    if not lockedTargetIgnoreFriends or not lockedTargetIgnoreFriends.Parent or lockedTargetIgnoreFriends.Parent:FindFirstChild("Humanoid") == nil or lockedTargetIgnoreFriends.Parent.Humanoid.Health <= 0 then
                        lockedTargetIgnoreFriends = getClosest()
                    end
                else
                    lockedTargetIgnoreFriends = nil
                end

                if lockedTargetIgnoreFriends and lockedTargetIgnoreFriends.Parent and lockedTargetIgnoreFriends.Parent:FindFirstChild("Humanoid") and lockedTargetIgnoreFriends.Parent.Humanoid.Health > 0 then
                    local direction = (lockedTargetIgnoreFriends.Position - Camera.CFrame.Position).Unit
                    local goal = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
                    Camera.CFrame = Camera.CFrame:Lerp(goal, AimStrength)

                    local screenPos, _ = Camera:WorldToViewportPoint(lockedTargetIgnoreFriends.Position)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude

                    local shrinkRadius = math.max(dist, 20)
                    circleIgnoreFriends.Radius = lerp(circleIgnoreFriends.Radius, shrinkRadius, 0.3)
                    circleIgnoreFriends.Color = Color3.new(1, 0, 0)
                else
                    circleIgnoreFriends.Radius = lerp(circleIgnoreFriends.Radius, FOV, 0.15)
                    circleIgnoreFriends.Color = Color3.new(1, 1, 1)
                    lockedTargetIgnoreFriends = nil
                end
            end)
        else
            if loopIgnoreFriends then
                loopIgnoreFriends:Disconnect()
                loopIgnoreFriends = nil
            end
            if circleIgnoreFriends then
                circleIgnoreFriends:Remove()
                circleIgnoreFriends = nil
            end
            lockedTargetIgnoreFriends = nil
        end
    end,
})


MainTab:CreateToggle({
    Name = "Instant Interact",
    CurrentValue = false,
    Flag = "InstantInteractToggle",
    Callback = function(enabled)
        local originalDurations = {}
        local descendantConn

        local function makeInstant(prompt)
            if prompt and prompt:IsA("ProximityPrompt") then
                if originalDurations[prompt] == nil then
                    originalDurations[prompt] = prompt.HoldDuration
                end
                prompt.HoldDuration = 0
            end
        end

        if enabled then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    makeInstant(obj)
                end
            end

            descendantConn = workspace.DescendantAdded:Connect(function(obj)
                if obj:IsA("ProximityPrompt") then
                    makeInstant(obj)
                end
            end)

            Rayfield.Flags.InstantInteractToggle.Connection = descendantConn
            Rayfield.Flags.InstantInteractToggle.OriginalDurations = originalDurations
        else
            if Rayfield.Flags.InstantInteractToggle.Connection then
                Rayfield.Flags.InstantInteractToggle.Connection:Disconnect()
                Rayfield.Flags.InstantInteractToggle.Connection = nil
            end

            for prompt, duration in pairs(originalDurations) do
                if prompt and prompt.Parent then
                    prompt.HoldDuration = duration
                end
            end

            Rayfield.Flags.InstantInteractToggle.OriginalDurations = nil
        end
    end
})





-- VISUALS TAB

local P,G,S,D=game:GetService("Players"),game:GetService("RunService"),game:GetService("LogService"),Drawing
local L,C,E,R,A=P.LocalPlayer,workspace.CurrentCamera,{},nil,nil
local CharacterAddedConnections = {}

local B={
    {"Head","UpperTorso"},
    {"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},
    {"LeftUpperArm","LeftLowerArm"},
    {"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},
    {"RightUpperArm","RightLowerArm"},
    {"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},
    {"LeftUpperLeg","LeftLowerLeg"},
    {"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},
    {"RightUpperLeg","RightLowerLeg"},
    {"RightLowerLeg","RightFoot"},
}

local function createLine()
    local l=D.new("Line")
    l.Thickness=2
    l.Transparency=1
    return l
end

local function createSkeleton()
    local t={}
    for _,c in pairs(B) do
        local l=createLine()
        table.insert(t,{line=l,partA=c[1],partB=c[2]})
    end
    return t
end

local function removeSkeleton(skeleton)
    for _,v in pairs(skeleton) do
        if v.line then
            v.line.Visible = false
            v.line:Remove()
            v.line = nil
        end
    end
end

local function onCharacterAdded(player, character)
    if not E[player] then
        E[player] = createSkeleton()
    end
end

local function onPlayerAdded(player)
    CharacterAddedConnections[player] = player.CharacterAdded:Connect(function(character)
        onCharacterAdded(player, character)
    end)
    if player.Character then
        onCharacterAdded(player, player.Character)
    end
end

local function onPlayerRemoving(player)
    if E[player] then
        removeSkeleton(E[player])
        E[player] = nil
    end
    if CharacterAddedConnections[player] then
        CharacterAddedConnections[player]:Disconnect()
        CharacterAddedConnections[player] = nil
    end
end

local function disconnectAll()
    if R then
        R:Disconnect()
        R = nil
    end
    if A then
        A:Disconnect()
        A = nil
    end
    for player, skeleton in pairs(E) do
        for _, seg in pairs(skeleton) do
            if seg.line then
                seg.line.Visible = false
            end
        end
    end
    task.wait(0.1) -- wait a moment before removing lines fully
    for player, skeleton in pairs(E) do
        removeSkeleton(skeleton)
    end
    E = {}
    for player, conn in pairs(CharacterAddedConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    CharacterAddedConnections = {}
end

VisualsTab:CreateToggle({
    Name = "Skeleton ESP",
    CurrentValue = false,
    Flag = "ChamsESPToggle",
    Callback = function(enabled)
        if enabled then
            for _,player in pairs(P:GetPlayers()) do
                if player ~= L then
                    onPlayerAdded(player)
                end
            end
            P.PlayerAdded:Connect(onPlayerAdded)
            P.PlayerRemoving:Connect(onPlayerRemoving)

            R = G.RenderStepped:Connect(function()
                for player,skeleton in pairs(E) do
                    local char = player.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if char and humanoid and humanoid.Health > 0 then
                        local color = nil
                        if L:IsFriendsWith(player.UserId) then
                            color = Color3.fromRGB(0,255,0) -- green for friends
                        else
                            color = player.Team and player.TeamColor.Color or Color3.new(1,1,1) -- team color or white
                        end

                        for _, seg in pairs(skeleton) do
                            local partA = char:FindFirstChild(seg.partA)
                            local partB = char:FindFirstChild(seg.partB)
                            if partA and partB then
                                local aPos, aOnScreen = C:WorldToViewportPoint(partA.Position)
                                local bPos, bOnScreen = C:WorldToViewportPoint(partB.Position)
                                if aOnScreen and bOnScreen then
                                    seg.line.Visible = true
                                    seg.line.Color = color
                                    seg.line.From = Vector2.new(aPos.X, aPos.Y)
                                    seg.line.To = Vector2.new(bPos.X, bPos.Y)
                                else
                                    seg.line.Visible = false
                                end
                            else
                                seg.line.Visible = false
                            end
                        end
                    else
                        for _, seg in pairs(skeleton) do
                            seg.line.Visible = false
                        end
                    end
                end
            end)

        else
            disconnectAll()
        end
    end,
})


local P, G, D = game:GetService("Players"), game:GetService("RunService"), Drawing
local L, C = P.LocalPlayer, workspace.CurrentCamera
local E, R = {}, nil
local CharacterAddedConnections = {}

local function createBox()
    local box = D.new("Square")
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    box.Visible = false
    return box
end

local function getCharacterScreenBounds(character)
    local parts = {
        "Head", "UpperTorso", "LowerTorso",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
        "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
        "RightUpperLeg", "RightLowerLeg", "RightFoot"
    }

    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local onScreen = false

    for _, partName in ipairs(parts) do
        local part = character:FindFirstChild(partName)
        if part then
            local screenPos, visible = C:WorldToViewportPoint(part.Position)
            if visible then
                onScreen = true
                minX = math.min(minX, screenPos.X)
                minY = math.min(minY, screenPos.Y)
                maxX = math.max(maxX, screenPos.X)
                maxY = math.max(maxY, screenPos.Y)
            end
        end
    end

    if onScreen then
        return Vector2.new(minX, minY), Vector2.new(maxX, maxY)
    else
        return nil, nil
    end
end

local function onCharacterAdded(player, character)
    if not E[player] then
        E[player] = createBox()
    end
end

local function onPlayerAdded(player)
    CharacterAddedConnections[player] = player.CharacterAdded:Connect(function(character)
        onCharacterAdded(player, character)
    end)
    if player.Character then
        onCharacterAdded(player, player.Character)
    end
end

local function onPlayerRemoving(player)
    if E[player] then
        E[player].Visible = false
        E[player]:Remove()
        E[player] = nil
    end
    if CharacterAddedConnections[player] then
        CharacterAddedConnections[player]:Disconnect()
        CharacterAddedConnections[player] = nil
    end
end

local function disconnectAll()
    if R then
        R:Disconnect()
        R = nil
    end
    for player, box in pairs(E) do
        box.Visible = false
        box:Remove()
    end
    E = {}
    for player, conn in pairs(CharacterAddedConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    CharacterAddedConnections = {}
end

VisualsTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = false,
    Flag = "BoxESPToggle",
    Callback = function(enabled)
        if enabled then
            for _, player in pairs(P:GetPlayers()) do
                if player ~= L then
                    onPlayerAdded(player)
                end
            end
            P.PlayerAdded:Connect(onPlayerAdded)
            P.PlayerRemoving:Connect(onPlayerRemoving)

            R = G.RenderStepped:Connect(function()
                for player, box in pairs(E) do
                    local char = player.Character
                    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                    if char and humanoid and humanoid.Health > 0 then
                        local topLeft, bottomRight = getCharacterScreenBounds(char)
                        if topLeft and bottomRight then
                            local color
                            if L:IsFriendsWith(player.UserId) then
                                color = Color3.fromRGB(0, 255, 0)
                            else
                                color = player.Team and player.TeamColor.Color or Color3.new(1, 1, 1)
                            end

                            box.Visible = true
                            box.Color = color
                            box.Position = topLeft
                            box.Size = Vector2.new(bottomRight.X - topLeft.X, bottomRight.Y - topLeft.Y)
                        else
                            box.Visible = false
                        end
                    else
                        box.Visible = false
                    end
                end
            end)

        else
            disconnectAll()
        end
    end,
})



-- TELEPORTS TAB



TeleportsTab:CreateButton({
    Name = "Car Dealership",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(211.40, 4.10, 781.58)
        else
            warn("Tp Failed")
        end
    end
})

TeleportsTab:CreateButton({
    Name = "Gunshop",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(475.93, 4.08, 454.75)
        else
            warn("Tp Failed")
        end
    end
})

TeleportsTab:CreateButton({
    Name = "Blackmarket",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(748.23, 4.40, 684.13)
        else
            warn("Tp Failed")
        end
    end
})


TeleportsTab:CreateButton({
    Name = "Bank",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(-132.70, 4.30, 140.51)
        else
            warn("Tp Failed")
        end
    end
})

TeleportsTab:CreateButton({
    Name = "Bank Vault",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(-82.83, 4.30, 152.11)
        else
            warn("Tp Failed")
        end
    end
})

TeleportsTab:CreateButton({
    Name = "Studio",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(403.79, 413, 775.74)
        else
            warn("Tp Failed")
        end
    end
})

TeleportsTab:CreateButton({
    Name = "Box Delivery",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(580.53, 3.88, 735.17)
        else
            warn("Tp Failed")
        end
    end
})

TeleportsTab:CreateButton({
    Name = "Swiping",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(-60.85, 4.12, 671.44)
        else
            warn("Tp Failed")
        end
    end
})

TeleportsTab:CreateButton({
    Name = "Zaza Job",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(90.71, 4.10, 411.32)
        else
            warn("Tp Failed")
        end
    end
})


-- MODS TAB



ModsTab:CreateToggle({
    Name = "Open All Doors",
    CurrentValue = false,
    Flag = "OpenAllDoorsToggle",
    Callback = function(enabled)
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Name == "asD" then
                if enabled then
                    part.CanCollide = false
                    part.Transparency = 1
                else
                    part.CanCollide = true
                    part.Transparency = 0
                end
            end
        end
    end
})


ModsTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(enabled)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local humanoid = character:WaitForChild("Humanoid")

        if enabled then
            humanoid.PlatformStand = true
            spawn(function()
                local UserInputService = game:GetService("UserInputService")
                local RunService = game:GetService("RunService")

                local flying = true
                local speed = 50
                local keys = {}

                local function getMoveDirection()
                    local cam = workspace.CurrentCamera
                    local dir = Vector3.new()
                    if keys["W"] then dir += cam.CFrame.LookVector end
                    if keys["S"] then dir -= cam.CFrame.LookVector end
                    if keys["A"] then dir -= cam.CFrame.RightVector end
                    if keys["D"] then dir += cam.CFrame.RightVector end
                    if keys["Space"] then dir += Vector3.new(0,1,0) end
                    if keys["LeftControl"] then dir -= Vector3.new(0,1,0) end
                    return dir.Magnitude > 0 and dir.Unit or Vector3.new()
                end

                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        keys[input.KeyCode.Name] = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        keys[input.KeyCode.Name] = false
                    end
                end)

                while flying and Rayfield.Flags.FlyToggle.CurrentValue do
                    local moveDir = getMoveDirection()
                    rootPart.Velocity = rootPart.Velocity:Lerp(moveDir * speed, 0.25)
                    rootPart.AssemblyAngularVelocity = Vector3.new()
                    RunService.Heartbeat:Wait()
                end

                humanoid.PlatformStand = false
                rootPart.Velocity = Vector3.new()
            end)
        else
            humanoid.PlatformStand = false
            rootPart.Velocity = Vector3.new()
        end
    end
})


ModsTab:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(enabled)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        if enabled then
            spawn(function()
                while Rayfield.Flags.SpeedToggle.CurrentValue do
                    if humanoid then
                        humanoid.WalkSpeed = 150
                    end
                    wait(0) 
                end
            end)
        else
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
})

ModsTab:CreateToggle({
    Name = "Anti Death",
    CurrentValue = false,
    Flag = "AntiDeathToggle",
    Callback = function(enabled)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local safePos = CFrame.new(-329.00, 100.09, 834.08)
        local originalPos

        local connection
        if enabled then
            originalPos = character.HumanoidRootPart.CFrame
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if humanoid.Health / humanoid.MaxHealth <= 0.32 then
                    character.HumanoidRootPart.CFrame = safePos
                elseif humanoid.Health / humanoid.MaxHealth >= 0.85 then
                    if originalPos then
                        character.HumanoidRootPart.CFrame = originalPos
                        originalPos = nil 
                    end
                end
            end)
            Rayfield.Flags.AntiDeathToggle.Connection = connection
        else
            if Rayfield.Flags.AntiDeathToggle.Connection then
                Rayfield.Flags.AntiDeathToggle.Connection:Disconnect()
                Rayfield.Flags.AntiDeathToggle.Connection = nil
            end
        end
    end
})

local Button = ModsTab:CreateButton({
    Name = "Spawn Draco",
    Callback = function()
        local rs = game:GetService("ReplicatedStorage")
        local remote = rs:FindFirstChild("PlaytimeRewards") and rs.PlaytimeRewards:FindFirstChild("2")
        local amount = 999999

        if remote then
            pcall(function()
                remote:FireServer(amount)
            end)
            
            Rayfield:Notify({
                Title = "Draco Spawnned",
                Content = "Draco claimed!",
                Duration = 5,
                Image = "rewind", 
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Draco Spawner remote not found",
                Duration = 5,
                Image = "alert-circle", 
            })
        end
    end
})

ModsTab:CreateButton({
    Name = "Give C4",
    Callback = function()
        local rs = game:GetService("ReplicatedStorage")
        local purchaseC4Remote = rs:FindFirstChild("PURCHASEC4")
        if purchaseC4Remote then
            pcall(function()
                purchaseC4Remote:FireServer()
            end)
            Rayfield:Notify({
                Title = "Item Granted",
                Content = "You were given C4!",
                Duration = 5,
                Image = "rewind"
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "PURCHASEC4 remote not found",
                Duration = 5,
                Image = "alert-circle"
            })
        end
    end
})


local Button = ModsTab:CreateButton({
    Name = "Give Money",
    Callback = function()
        local rs = game:GetService("ReplicatedStorage")
        local rewardIndexes = {"8","7","5","3","1"}
        local amount = 999999 

        for _, index in ipairs(rewardIndexes) do
            local remote = rs:FindFirstChild("PlaytimeRewards") and rs.PlaytimeRewards:FindFirstChild(index)
            if remote then
                pcall(function()
                    remote:FireServer(amount)
                end)
            end
        end

      
        Rayfield:Notify({
            Title = "Money Given",
            Content = "You were given 33,500!",
            Duration = 5,
            Image = "rewind", 
        })
    end
})


Rayfield:LoadConfiguration()
