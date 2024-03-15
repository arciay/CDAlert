local AddonName, _ = ...
CDAlertDefaultDB = {
	cdcall = true,
	
	cdcalls = {	
		[80353] = true, 	--嗜血
		[342245] = true,	--操控时间
		[414660] = true,	--群体屏障
	},
}


----------ONLOAD EVENT---------
local loadFrame = CreateFrame("FRAME"); 
loadFrame:RegisterEvent("ADDON_LOADED"); 
loadFrame:RegisterEvent("PLAYER_LOGOUT"); 

function loadFrame:OnEvent(event, arg1)
	if not CDAlertDB then CDAlertDB = {} end
	for i, j in pairs(CDAlertDefaultDB) do
		if type(j) == "table" then
			if CDAlertDB[i] == nil then CDAlertDB[i] = {} end
			for k, v in pairs(j) do
				if CDAlertDB[i][k] == nil then
					CDAlertDB[i][k] = v
				end
			end
		else
			if CDAlertDB[i] == nil then CDAlertDB[i] = j end
		end
	end
end
loadFrame:SetScript("OnEvent", loadFrame.OnEvent);
----------------------------------