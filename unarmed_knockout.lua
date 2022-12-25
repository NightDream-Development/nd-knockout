local QBCore = exports["qb-core"]:GetCoreObject()
local knockedOut = false
local wait = 15
local count = 60
local isdead = false

CreateThread(function()
        while true do
            Wait(1000)
            local ped = PlayerPedId()
            PlayerData = QBCore.Functions.GetPlayerData()
            if IsPedInMeleeCombat(ped) then
                --  csak kézzel üthet
                if (HasPedBeenDamagedByWeapon(ped, GetHashKey("WEAPON_UNARMED"), 0)) then
                    -- életerő ha kiütnek
                    if GetEntityHealth(ped) < 145 then
                        SetPlayerInvincible(ped, false)
                        -- Position taken by your Ped
                        SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
                        -- Time to wait
                        wait = 60
                        QBCore.Functions.Progressbar("knocked-out", "Eszméletlen...", 45000, false, false, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true
                            },
                            {},
                            {},
                            {},
                            function()
                                -- Done
                                ExecuteCommand('e c')
                                QBCore.Functions.Notify("Felkeltél!", "success", 5000)
                            end,
                            function()
                            end,
                            "fa-solid fa-face-dizzy")            
                      knockedOut = true
                        -- Az egészség a kiütés után lehetőleg ne legyen 150-nél (50%), mert az emberek visszaélnek vele {Nem kell kórházba menni}
                        SetEntityHealth(ped, 140)
                    end
                end
            end
            if knockedOut == true then
                --A játékos megbír halni
                local ped = PlayerPedId()
                SetPlayerInvincible(PlayerPedId(), false)
                DisablePlayerFiring(PlayerPedId(), true)
                ResetPedRagdollTimer(PlayerPedId())
                CreateThread(function()
                    while knockedOut == true do
                        ExecuteCommand('e passout')
                        Wait(500)
                    end
                end)
                if wait >= 0 then
                    count = count - 1
                    if count == 0 then
                        count = 60
                        wait = wait - 1
                        -- ha elbaszódna
                        if GetEntityHealth(PlayerPedId()) <= 50 then
                            -- Ped gyógyítása
                            SetEntityHealth(PlayerPedId(), GetEntityHealth(ped) + 2)
                        end
                    end
                else
                    ExecuteCommand('e c')
                    SetPlayerInvincible(PlayerPedId(), false)
                    knockedOut = false
                end
            end
            -- Ha halott lessz minden fasza legyen!
            if PlayerData['isdead']then
                 SetTimecycleModifier("")
                 ExecuteCommand('e c')
                 SetTransitionTimecycleModifier("")
                 knockedOut = false
             end
        end
    end
)


