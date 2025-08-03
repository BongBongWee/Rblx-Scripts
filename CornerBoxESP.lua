local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LogService = game:GetService("LogService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESP_Boxes = {}
local UpdateConnection
local DisableConnection

local function createCornerBox()
    local lines = {}
    for i = 1, 8 do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Transparency = 1
        line.Visible = false
        table.insert(lines, line)
    end
    return lines
end

local function createBox(player)
    if ESP_Boxes[player] then return end
    ESP_Boxes[player] = createCornerBox()
end

local function removeBox(player)
    if ESP_Boxes[player] then
        for _, line in ipairs(ESP_Boxes[player]) do
            line:Remove()
        end
        ESP_Boxes[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createBox(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then createBox(p) end
end)
Players.PlayerRemoving:Connect(removeBox)

UpdateConnection = RunService.RenderStepped:Connect(function()
    for player, lines in pairs(ESP_Boxes) do
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")

        if player.Team ~= LocalPlayer.Team and hrp and head then
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                local x = pos.X - width / 2
                local y = pos.Y - height / 2
                local corner = height * 0.2
                local color = player.TeamColor.Color

                lines[1].From = Vector2.new(x, y)
                lines[1].To = Vector2.new(x + corner, y)
                lines[2].From = Vector2.new(x, y)
                lines[2].To = Vector2.new(x, y + corner)

                lines[3].From = Vector2.new(x + width - corner, y)
                lines[3].To = Vector2.new(x + width, y)
                lines[4].From = Vector2.new(x + width, y)
                lines[4].To = Vector2.new(x + width, y + corner)

                lines[5].From = Vector2.new(x, y + height - corner)
                lines[5].To = Vector2.new(x, y + height)
                lines[6].From = Vector2.new(x, y + height)
                lines[6].To = Vector2.new(x + corner, y + height)

                lines[7].From = Vector2.new(x + width - corner, y + height)
                lines[7].To = Vector2.new(x + width, y + height)
                lines[8].From = Vector2.new(x + width, y + height - corner)
                lines[8].To = Vector2.new(x + width, y + height)

                for _, l in ipairs(lines) do
                    l.Color = color
                    l.Visible = true
                end
            else
                for _, l in ipairs(lines) do l.Visible = false end
            end
        else
            for _, l in ipairs(lines) do l.Visible = false end
        end
    end
end)

DisableConnection = LogService.MessageOut:Connect(function(message)
    if message == "disablecornerrounddedboxestest" then
        if UpdateConnection then UpdateConnection:Disconnect() end
        if DisableConnection then DisableConnection:Disconnect() end
        for _, lines in pairs(ESP_Boxes) do
            for _, l in ipairs(lines) do l:Remove() end
        end
        ESP_Boxes = {}
        print("[CornerBoxESP] Disabled.")
    end
end)
