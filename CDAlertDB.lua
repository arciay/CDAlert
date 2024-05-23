local addon, ns = ...

CDAlertDefaultDB = {
	cdcall = true,
	tipid = false,
	
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

-------SomePrepare Tools(Jobs) ---------

function ns.table_copy(table)
	local NewTable = {}
	if table then
		for k, v in pairs(table) do
			NewTable[k] = v 
		end
	end
	return NewTable;
end

function ns.table_same(table1, table2)
	local leng1, leng2 = ns.table_leng(table1), ns.table_leng(table2)
	if leng1 ~= leng2 then return false end 

	if table1 and table2 then
		for k, v in pairs(table1) do
			-- print '-----'
			-- print (table2[k])
			-- print (v)
			if not (table2[k] == v) then
				-- print '!!!!!!!!'
				-- print ("不符合的是"..v.."...."..table2[k])
				return false
			end
		end
	end
	return true
end

function ns.table_keys(t)
	local tbKeys = {}
	local i = 1
	for k, v in pairs(t) do
		tbKeys[i] = k
		i = i + 1
	end	
	return tbKeys;
end

function ns.table_leng(t)
  local leng=0
  for k, v in pairs(t) do
    leng=leng+1
  end
  return leng;  --return int
end

function ns.GetTrueNum(table)
	local i = 0
	for k, v in pairs(table) do 
		if v then 
			i = i + 1
		end 
	end 
	return i
end 
