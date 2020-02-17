local __request_util = class({
	PlayerEach	= function(callback)
		if not callback then print('Not Callback Function!')  return end
		for i = 0, DOTA_MAX_PLAYERS - 1 do
			if PlayerResource:IsValidPlayer(i) then
				callback(i)
			end
		end
	end,
	
	IsBot 		= function(pID)
		return PlayerResource:GetSteamAccountID(pID) < 1000
	end,

	RequestData	= function(url,data,callback)
		data = json.encode({
			data = data,
			__authKey = request.__authKey,
		})
	    local req = CreateHTTPRequestScriptVM('POST', request.__http .. url .. '.php')
		req:SetHTTPRequestGetOrPostParameter("Data", data )
		req:Send(function(response)
	        if response.StatusCode ~= 200 then  
	        	print("Error, Status code = ",response.StatusCode) 
	        	return 
	        end
	        print('request response')
			local obj, pos, err = json.decode(response.Body)
			if not obj or type(obj) ~= "table" or obj == '' then 
				print("Error, object not found, obj = '" .. tostring(obj) .. "' type = ",type(obj))
				PrintTable(response) 
				return 
			end
	        if callback and obj and type(obj) == "table" then
				callback(obj)
	        end
	    end)
	end,
})
request.__exports = __request_util
