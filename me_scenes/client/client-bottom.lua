local Scenes = {}
local defaultScale = 0.30 -- Text scale
local color = { r = 255, g = 255, b = 255, a = 235 } -- Text color
local font = 11 --Text font

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local str = CreateVarString(10, "LITERAL_STRING", "* " .. text .. " *", Citizen.ResultAsLong())
    if onScreen then
        SetTextScale(defaultScale, defaultScale)
        SetTextFontForCurrentCommand(font)
        SetTextColor(color.r, color.g, color.b, color.a)
        SetTextCentre(1)
        DisplayText(str, _x, _y)
        local factor = (string.len(text)) / 225
        DrawSprite("feeds", "hud_menu_4a", _x, _y + 0.0125, 0.035 + factor, 0.03, 0.1, 35, 35, 35, 190, 0)
    end
end

Citizen.CreateThread(function()
    TriggerServerEvent("darkk_ops_bottom:getscenes")
    while true do
        Citizen.Wait(1)
        if Scenes[1] ~= nil then
            for i,v in pairs(Scenes) do
                local cc = GetEntityCoords(PlayerPedId())
                local sc =  GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(Scenes[i].serverid)))
                local dist = Vdist(cc.x,cc.y,cc.z,sc.x,sc.y,sc.z, 1)
                if dist < Config.ViewDistance then
                    DrawText3D(sc.x,sc.y,sc.z - 0.7,Scenes[i].text)
                end
            end
        end
    end
end)

RegisterCommand('scenebottom', function(source, args, raw)
    TriggerServerEvent("darkk_ops_bottom:delete")
    TriggerEvent("darkk_ops_bottom:start")
 end)

RegisterCommand('cscenebottom', function(source, args, raw)
    TriggerServerEvent("darkk_ops_bottom:delete")
 end)

RegisterNetEvent('darkk_ops_bottom:sendscenes')
AddEventHandler('darkk_ops_bottom:sendscenes', function(scenes)
    Scenes = scenes
end)

RegisterNetEvent('darkk_ops_bottom:start')
AddEventHandler('darkk_ops_bottom:start', function()
    local scenetext = ""
    Citizen.CreateThread(function()
        AddTextEntry('FMMC_MPM_NA', "Add Scene Details")
        DisplayOnscreenKeyboard(0, "FMMC_MPM_NA", "", "", "", "", "", 50)
        while (UpdateOnscreenKeyboard() == 0) do
            DisableAllControlActions(0);
            Citizen.Wait(5);
        end
        if (GetOnscreenKeyboardResult()) then
            scenetext = GetOnscreenKeyboardResult()
            TriggerServerEvent("darkk_ops_bottom:add", scenetext)
            CancelOnscreenKeyboard()
        end
    end)
end)
