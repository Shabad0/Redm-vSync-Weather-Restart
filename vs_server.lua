VorpCore = {}

TriggerEvent("getCore",function(core)
    VorpCore = core
end)

admins = {
    'steam:11000013f707c7f',
    'steam:11000013e40159a',
    'steam:110000140c93f64',
}

-- Set this to false if you don't want the weather to change automatically every 10 minutes.
DynamicWeather = true

--------------------------------------------------
debugprint = false -- don't touch this unless you know what you're doing or you're being asked by Vespura to turn this on.
--------------------------------------------------
-------------------- DON'T CHANGE THIS --------------------
AvailableWeatherTypes = {
    "BLIZZARD", 
    "CLOUDS", 
    "DRIZZLE", 
    "FOG", 
    "GROUNDBLIZZARD", 
    "HAIL", 
    "HIGHPRESSURE", 
    "HURRICANE", 
    "MISTY", 
    "OVERCAST", 
    "OVERCASTDARK", 
    "RAIN", 
    "SANDSTORM", 
    "SHOWER", 
    "SLEET", 
    "SNOW", 
    "SNOWCLEARING", 
    "SNOWLIGHT", 
    "SUNNY", 
    "THUNDER", 
    "THUNDERSTORM", 
    "WHITEOUT",
}
CurrentWeather = "EXTRASUNNY"
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false
local newWeatherTimer = 30

RegisterServerEvent('vSync:requestSync')
AddEventHandler('vSync:requestSync', function()
    TriggerClientEvent('vSync:updateWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('vSync:updateTime', -1, baseTime, timeOffset, freezeTime)
end)

function isAllowedToChange(player)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if debugprint then print('admin id: ' .. id .. '\nplayer id:' .. pid) end
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

RegisterCommand('freezetime', function(source, args)
    if source ~= 0 then
        if isAllowedToChange(source) then
            freezeTime = not freezeTime
            if freezeTime then
                TriggerClientEvent('vSync:notify', source, 'Time is now ~b~frozen~s~.')
            else
                TriggerClientEvent('vSync:notify', source, 'Time is ~y~no longer frozen~s~.')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You are not allowed to use this command.')
        end
    else
        freezeTime = not freezeTime
        if freezeTime then
            print("Time is now frozen.")
        else
            print("Time is no longer frozen.")
        end
    end
end)

RegisterCommand('freezeweather', function(source, args)
    if source ~= 0 then
        if isAllowedToChange(source) then
            DynamicWeather = not DynamicWeather
            if not DynamicWeather then
                TriggerClientEvent('vSync:notify', source, 'Dynamic weather changes are now ~r~disabled~s~.')
            else
                TriggerClientEvent('vSync:notify', source, 'Dynamic weather changes are now ~b~enabled~s~.')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You are not allowed to use this command.')
        end
    else
        DynamicWeather = not DynamicWeather
        if not DynamicWeather then
            print("Weather is now frozen.")
        else
            print("Weather is no longer frozen.")
        end
    end
end)

RegisterCommand('weather', function(source, args)
    if source == 0 then
        local validWeatherType = false
        if args[1] == nil then
            print("Invalid syntax, correct syntax is: /weather <weathertype> ")
            return
        else
            for i,wtype in ipairs(AvailableWeatherTypes) do
                if wtype == string.upper(args[1]) then
                    validWeatherType = true
                end
            end
            if validWeatherType then
                print("Weather has been updated.")
                CurrentWeather = string.upper(args[1])
                newWeatherTimer = 10
                TriggerEvent('vSync:requestSync')
            else
                print("Invalid weather type, valid weather types are: \nBlizzard, Clouds, Drizzle, Fog, GroundBlizzard, Hail, HighPressure, Hurricane, Misty, Overcast, OvercastDark, Rain, Sandstorm, shower, sleet, snow, snowclearing, snowlight, sunny, thunder, thunderstorm, and whiteout. ")
            end
        end
    else
        if isAllowedToChange(source) then
            local validWeatherType = false
            if args[1] == nil then
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax, use ^0/weather <weatherType> ^1instead!')
            else
                for i,wtype in ipairs(AvailableWeatherTypes) do
                    if wtype == string.upper(args[1]) then
                        validWeatherType = true
                    end
                end
                if validWeatherType then
                    TriggerClientEvent('vSync:notify', source, 'Weather will change to: ~y~' .. string.lower(args[1]) .. "~s~.")
                    CurrentWeather = string.upper(args[1])
                    newWeatherTimer = 10
                    TriggerEvent('vSync:requestSync')
                else
                    TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid weather type, valid weather types are: ^0\n\nBlizzard, Clouds, Drizzle, Fog, GroundBlizzard, Hail, HighPressure, Hurricane, Misty, Overcast, OvercastDark, Rain, Sandstorm, shower, sleet, snow, snowclearing, snowlight, sunny, thunder, thunderstorm, and whiteout.')
                end
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
            print('Access for command /weather denied.')
        end
    end
end, false)


RegisterCommand('morning', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(9)
        TriggerClientEvent('vSync:notify', source, 'Time set to ~y~morning~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)
RegisterCommand('noon', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(12)
        TriggerClientEvent('vSync:notify', source, 'Time set to ~y~noon~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)
RegisterCommand('evening', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(18)
        TriggerClientEvent('vSync:notify', source, 'Time set to ~y~evening~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)
RegisterCommand('night', function(source)
    if source == 0 then
        print("For console, use the \"/time <hh> <mm>\" command instead!")
        return
    end
    if isAllowedToChange(source) then
        ShiftToMinute(0)
        ShiftToHour(23)
        TriggerClientEvent('vSync:notify', source, 'Time set to ~y~night~s~.')
        TriggerEvent('vSync:requestSync')
    end
end)

function ShiftToMinute(minute)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minute )
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hour ) * 60
end

RegisterCommand('time', function(source, args, rawCommand)
    if source == 0 then
        if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
            local argh = tonumber(args[1])
            local argm = tonumber(args[2])
            if argh < 24 then
                ShiftToHour(argh)
            else
                ShiftToHour(0)
            end
            if argm < 60 then
                ShiftToMinute(argm)
            else
                ShiftToMinute(0)
            end
            print("Time has changed to " .. argh .. ":" .. argm .. ".")
            TriggerEvent('vSync:requestSync')
        else
            print("Invalid syntax, correct syntax is: time <hour> <minute> !")
        end
    elseif source ~= 0 then
        if isAllowedToChange(source) then
            if tonumber(args[1]) ~= nil and tonumber(args[2]) ~= nil then
                local argh = tonumber(args[1])
                local argm = tonumber(args[2])
                if argh < 24 then
                    ShiftToHour(argh)
                else
                    ShiftToHour(0)
                end
                if argm < 60 then
                    ShiftToMinute(argm)
                else
                    ShiftToMinute(0)
                end
                local newtime = math.floor(((baseTime+timeOffset)/60)%24) .. ":"
				local minute = math.floor((baseTime+timeOffset)%60)
                if minute < 10 then
                    newtime = newtime .. "0" .. minute
                else
                    newtime = newtime .. minute
                end
                TriggerClientEvent('vSync:notify', source, 'Time was changed to: ~y~' .. newtime .. "~s~!")
                TriggerEvent('vSync:requestSync')
            else
                TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1Invalid syntax. Use ^0/time <hour> <minute> ^1instead!')
            end
        else
            TriggerClientEvent('chatMessage', source, '', {255,255,255}, '^8Error: ^1You do not have access to that command.')
            print('Access for command /time denied.')
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local newBaseTime = os.time(os.date("!*t"))/2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime			
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerClientEvent('vSync:updateTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('vSync:updateWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Citizen.Wait(60000)
        if newWeatherTimer == 0 then
            if DynamicWeather then
                NextWeatherStage()
            end
            newWeatherTimer = 10
        end
    end
end)

function NextWeatherStage()
    if CurrentWeather == "SUINNY" or CurrentWeather == "CLOUDS"  then
        local new = math.random(1,2)
        if new == 1 then
            CurrentWeather = "OVERCASTDARK"
        else
            CurrentWeather = "OVERCAST"
        end
    elseif CurrentWeather == "HighPressure" or CurrentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
            if CurrentWeather == "HighPressure" then CurrentWeather = "MISTY" else CurrentWeather = "RAIN" end
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "Hail"
        elseif new == 4 then
            CurrentWeather = "SUNNY"
        elseif new == 5 then
            CurrentWeather = "Fog"
        else
            CurrentWeather = "Fog"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" or "Thunderstrom" then
        CurrentWeather = "drizzle"
    elseif CurrentWeather == "Fog" or CurrentWeather == "Drizzle" then
        CurrentWeather = "Overcast"
    end
    TriggerEvent("vSync:requestSync")
    if debugprint then
        print("[vSync] New random weather type has been generated: " .. CurrentWeather .. ".\n")
        print("[vSync] Resetting timer to 10 minutes.\n")
    end
end


RegisterNetEvent('vSync:ChangeWeather')
AddEventHandler('vSync:ChangeWeather', function(weather, doBlackout) 
    for i,wtype in ipairs(AvailableWeatherTypes) do
        if wtype == string.upper(weather) then
            validWeatherType = true
        end
    end
    if validWeatherType then
        CurrentWeather = string.upper(weather)
        newWeatherTimer = 10
    else
        print("Invalid weather type, valid weather types are: ^0\n\nBlizzard, Clouds, Drizzle, Fog, GroundBlizzard, Hail, HighPressure, Hurricane, Misty, Overcast, OvercastDark, Rain, Sandstorm, shower, sleet, snow, snowclearing, snowlight, sunny, thunder, thunderstorm, and whiteout.")
    end

    if doBlackout then
        blackout = true
    else
        blackout = false
    end
    TriggerEvent('vSync:requestSync')
end)

--------------30MINS TILL RESTART-------------
AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 1800 then
                print("30 Mins till Storm")
            TriggerEvent('vSync:ChangeWeather',"OVERCASTDARK",false)
        TriggerClientEvent("vorp:TipBottom", -1, "Those are some nasty clouds. 30 MINS TILL RESTART", 9000)
		Citizen.Wait(9000)
        end
    end)
--------------10MINS TILL RESTART-------------
AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 600 then
                print("10 Mins till Storm")
            TriggerEvent('vSync:ChangeWeather',"HURRICANE",false)
        TriggerClientEvent("vorp:TipBottom", -1, "Wow this wind is getting crazy. 10 MINS TILL RESTART", 9000)
		Citizen.Wait(9000)
        end
    end)

--------------5MIN TILL RESTART-------------
AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 300 then
                print("5 Min till Storm")
            TriggerEvent('vSync:ChangeWeather',"THUNDERSTORM",false)
        TriggerClientEvent("vorp:TipBottom", -1, "This Weather is getting bad i better take shelter. 5MIN TILL RESTART", 9000)
		Citizen.Wait(9000)
        end
    end)


print("$$")
print("$$       VSYNC")
print("$$        WAS")
print("$$     Created by")
print("$$")
print("$$      Vespura")
print("$$")
print("$$     Modified by")
print("$$")
print("$$      Shabado")
print("$$")

