local QBCore = exports["qb-core"]:GetCoreObject()
local knockedOut = false
local wait = 15
local count = 60

CreateThread(function()
    while true do
        Wait(1000)
        PlayerData = QBCore.Functions.GetPlayerData()
        if IsPedInMeleeCombat(cache.ped) then
            if HasPedBeenDamagedByWeapon(cache.ped, GetHashKey("WEAPON_UNARMED"), 0) then
                if GetEntityHealth(cache.ped) < 145 then
                    SetPlayerInvincible(cache.ped, false)
                    if Config.scully then
                        exports.scully_emotemenu:playEmoteByCommand('passout2')
                    else
                        TriggerEvent('animations:client:EmoteCommandStart', {"passout2"})  
                    end
                    wait = 60
                    QBCore.Functions.Progressbar("knocked-out", "Unconscious...", 45000, false, false, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true
                    },
                    {},
                    {},
                    {},
                    function()
                        if Config.debug then
                            lib.print.debug("Progressbar Done")
                            ExecuteCommand('e c')
                            QBCore.Functions.Notify("You got up!", "success", 5000)
                        else
                            ExecuteCommand('e c')
                            QBCore.Functions.Notify("You got up!", "success", 5000)
                        end
                    end,
                    function()
                    end,
                    "fa-solid fa-face-dizzy")
                    knockedOut = true
                    SetEntityHealth(cache.ped, 140)
                end
            end
        end
        if knockedOut then
            SetPlayerInvincible(cache.ped, false)
            DisablePlayerFiring(cache.ped, true)
            ResetPedRagdollTimer(cache.ped)
            if wait >= 0 then
                count = count - 1
                if count == 0 then
                    count = 60
                    wait = wait - 1
                    if GetEntityHealth(cache.ped) <= 50 then
                        SetEntityHealth(cache.ped, GetEntityHealth(cache.ped) + 2)
                    end
                end
            else
                if Config.scully then
                    exports.scully_emotemenu:cancelEmote()
                else
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                end
                SetPlayerInvincible(cache.ped, false)
                knockedOut = false
            end
        end
        if PlayerData['isdead'] then
            if Config.debug then
                lib.print.debug("Progressbar Done")
                SetTimecycleModifier("")
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                SetTransitionTimecycleModifier("")
                knockedOut = false
            else
                SetTimecycleModifier("")
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                SetTransitionTimecycleModifier("")
                knockedOut = false
            end
        end
    end
end)