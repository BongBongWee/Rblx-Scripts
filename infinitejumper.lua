local InfiniteJumpEnabled = true

local function disableInfiniteJump(message)
    if string.find(message, "08125OOO") then
        InfiniteJumpEnabled = false
    end
end

game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

game:GetService("LogService").MessageOut:Connect(disableInfiniteJump)
