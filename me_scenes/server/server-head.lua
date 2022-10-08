local scenes = {}

RegisterServerEvent("darkk_ops_top:add")
AddEventHandler("darkk_ops_top:add", function(text)
    local _source = source
    local _text = tostring(text)
    local scene = {text = _text, serverid = _source}
    scenes[#scenes+1] = scene
    TriggerClientEvent("darkk_ops_top:sendscenes", -1, scenes)
end)

RegisterServerEvent("darkk_ops_top:getscenes")
AddEventHandler("darkk_ops_top:getscenes", function(text)
    local _source = source
    TriggerClientEvent("darkk_ops_top:sendscenes", _source, scenes)
end)

RegisterServerEvent("darkk_ops_top:delete")
AddEventHandler("darkk_ops_top:delete", function()
    local _source = source
    if scenes[1] ~= nil then
        for i,v in pairs(scenes) do
            if scenes[i].serverid == _source then
                table.remove(scenes, i)
                break
            end
        end
    end
    TriggerClientEvent("darkk_ops_top:sendscenes", -1, scenes)
end)