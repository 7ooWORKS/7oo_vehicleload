local vehicle, defaultPower, currentPower
local debug = Config.Debug
local reduction = Config.Reduction / 10

CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
			if vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
				if not defaultPower then
					defaultPower = GetVehicleCheatPowerIncrease(vehicle)
					if debug then print('^3DEBUG: ^0Your ped sits in the vehicle, original power recorded') end
				end
				local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
				if debug then print(('^3DEBUG: ^0You will transport a total %d passengers'):format(maxSeats)) end
				local passengers = 0
				for seat = 0, maxSeats do
					local pedInSeat = GetPedInVehicleSeat(vehicle, seat)
					if pedInSeat and pedInSeat ~= 0 then
						passengers += 1
					end
				end
				if debug then print(('^3DEBUG: ^0You are currently carrying %d'):format(passengers)) end
				if passengers > 0 then		
					currentPower = math.max(0.4, defaultPower - (passengers * reduction))
					if debug then print(('^3DEBUG: ^0Engine power adjusted to: %.1f, default was %.1f'):format(currentPower, defaultPower)) end
				else
					currentPower = nil
					if debug then print('^3DEBUG: ^0Engine power is not adjusted') end
				end
			end
		else
			defaultPower, currentPower = nil, nil
			if debug then print('^3DEBUG: ^0Your ped is not in the vehicle, there are no values') end
		end
		Wait(2000)
	end
end)

CreateThread(function()
	while true do
		if currentPower and vehicle ~= 0 then
			SetVehicleCheatPowerIncrease(vehicle, currentPower)
			Wait(0)
		else
			Wait(1000)
		end
	end
end)
