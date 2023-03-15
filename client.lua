local directions = { [0] = 'N', [1] = 'NW', [2] = 'W', [3] = 'SW', [4] = 'S', [5] = 'SE', [6] = 'E', [7] = 'NE', [8] = 'N' } 
local show = true
local speedMultipler = 3.6
local speedUnit = "KMH"

if Config.EnableCamCommand then
    RegisterCommand('cam', function()
        show = not show
        SendNUIMessage({
            process = 'toggleCinemaMode';
            state = show
        })
    end)
end

if Config.SpeedUnit == "MPH" then
    speedMultipler = 2.236936
    speedUnit = "MPH"
elseif Config.SpeedUnit == "KMH" then
    speedMultipler = 3.6
    speedUnit = "KMH"
else
    speedMultipler = 2.236936
    speedUnit = "MPH"
end

CreateThread(function()
	while true do
        local sleep = Config.TickOutsideVehicle
        if IsPauseMenuActive() then
            SendNUIMessage({
                process = 'hide';
            })
		elseif IsPedInAnyVehicle(PlayerPedId()) and show then
            sleep = Config.TickInVehicle
            local veh = GetVehiclePedIsUsing(PlayerPedId())
            local speed = (GetEntitySpeed(veh)*speedMultipler) -- mph - *2.236936, kmh - *3.6
            local rpm = GetVehicleCurrentRpm(veh)
            local rpmPercent = rpm * 100
            local fuel = GetVehicleFuelLevel(veh)

            local coords = GetEntityCoords(veh)
            local var = GetStreetNameAtCoord(coords.x, coords.y, coords.y)
            local street = GetStreetNameFromHashKey(var)
        
            local heading = directions[math.floor((GetEntityHeading(PlayerPedId()) + 22.5) / 45.0)]

            SendNUIMessage({
                process = 'show',
                unit = speedUnit,
                speedLevel = speed,
                rpmLevel = rpmPercent,
                fuel = fuel,
                streetName = street,
                heading = heading
            })
            DisplayRadar(true)
        else
            DisplayRadar(false)
            SendNUIMessage({
                process = 'hide';
            })
        end
        Wait(sleep)
	end
end)

RegisterNUICallback("getPlayerId", function(data, cb)
    cb(GetPlayerServerId(PlayerId()))
end)