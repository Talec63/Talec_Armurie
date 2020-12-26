print('^2Le script est bien start.')

RMenu.Add('armurerie', 'main', RageUI.CreateMenu("Armurerie", "Armes"))

Citizen.CreateThread(function()
    while true do
        local Open = false

        for _,k in pairs(Config.pPos) do
            
            if Vdist2(GetEntityCoords(PlayerPedId(), false), k[2]) < 4.5 then
                Open = true
                ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour parler a ~g~Gérard")
                if IsControlJustPressed(1, 51) then
                  RageUI.Visible(RMenu:Get('armurerie', 'main'), not RageUI.Visible(RMenu:Get('armurerie', 'main')))
                  drawCenterText('Bonjour, que puis-je faire pour vous ?', 2000)
                end
            end
        end

        RageUI.IsVisible(RMenu:Get('armurerie', 'main'), true, true, true, function()
            Open = true

            for _,k in pairs(Config.Menu) do
            RageUI.ButtonWithStyle(k[1], nil, { RightLabel = "~g~$"..k[3] }, true, function(_, _, s)
             if s then
                local id = GetPlayerServerId(PlayerId())
                local pPed = GetPlayerPed(-1)
                GiveWeaponToPed(pPed, GetHashKey(k[2]), k[4], false, false) 
                ShowNotification('Vous avez payé ~r~$'..k[3])
                --TriggerServerEvent("rFw:removemoney", id, k[3])
                print('ID : ^1' ..id.. '^0 prix : ^1'..k[3]..'^0 $')
                RageUI.CloseAll()
                end
            end)
        end
end)

       if Open then
        Wait(1)
       else
        Wait(250)
       end
    end
end)

Citizen.CreateThread(function()
    for _,k in pairs(Config.pPos) do

        local hash = GetHashKey(k[1])
        while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
        end
        pPed = CreatePed("PED_TYPE_CIVFEMALE", k[1], k[2], true, true)
        SetBlockingOfNonTemporaryEvents(pPed, true)
        FreezeEntityPosition(pPed, true)
        SetEntityInvincible(pPed, true)
    end
end)

Citizen.CreateThread(function()

    for _, info in pairs(Config.blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.7)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

function drawCenterText(msg, time)
	ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(msg)
	DrawSubtitleTimed(time and math.ceil(time) or 0, true)
end