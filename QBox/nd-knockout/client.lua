local knockedOut = false
local wait = 15
local count = 60

-- Function to wake up the player
local function WakeUpPlayer()
    SetPlayerInvincible(cache.ped, false)
    if Config.scully then
        exports.scully_emotemenu:cancelEmote()
    else
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end
    knockedOut = false
end

CreateThread(function()
    while true do
        Wait(1000)
        local pedHealth = GetEntityHealth(cache.ped)

        if IsPedInMeleeCombat(cache.ped) then
            local weaponHash = GetHashKey("WEAPON_UNARMED")
            if HasPedBeenDamagedByWeapon(cache.ped, weaponHash, 0) and pedHealth < 145 then
                SetPlayerInvincible(cache.ped, false)
                if Config.scully then
                    exports.scully_emotemenu:playEmoteByCommand('passout2')
                else
                    TriggerEvent('animations:client:EmoteCommandStart', {"passout2"})
                end
                wait = 60
                local progressBarResult = lib.progressCircle({
                    duration = 2500,
                    label = Config.label,
                    position = 'bottom',
                    useWhileDead = true,
                    canCancel = false,
                    disable = {
                        car = true,
                        move = true,
                        combat = true,
                    },
                })

                if progressBarResult then
                    lib.print.debug("Progressbar Done")
                    ExecuteCommand('e c')
                    exports.qbx_core:Notify("You got up!", "success", 5000)
                end

                knockedOut = true
                SetEntityHealth(cache.ped, 140)
            end
        end

        if knockedOut then
            SetPlayerInvincible(cache.ped, false)
            DisablePlayerFiring(cache.ped, true)
            ResetPedRagdollTimer(cache.ped)

            if wait > 0 then
                count = count - 1
                if count == 0 then
                    count = 60
                    wait = wait - 1

                    if pedHealth <= 50 then
                        SetEntityHealth(cache.ped, pedHealth + 2)
                    end
                end
            else
                WakeUpPlayer()
            end
        end

        if exports.qbx_medical:isDead() then
            if Config.debug then
                lib.print.debug("Player dead?")
            end
            SetTimecycleModifier("")
            WakeUpPlayer()
            SetTransitionTimecycleModifier("")
        end
    end
end)
