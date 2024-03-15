--界面部分抄自rsplate
------------------
local myGUI = {}

myGUI.frame1 = CreateFrame( "Frame", "CDCALLUI", InterfaceOptionsFrame); 
myGUI.frame1.name = "|cff3399FFCDAlert|r技能冷却提醒"

local function newFont(offx, offy, createframe, anchora, anchroframe, anchorb, text, fontsize)
	local font = createframe:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	font:SetPoint(anchora, anchroframe, anchorb, offx, offy)
	font:SetText(text)
	font:SetFont("fonts\\ARHei.ttf", fontsize, "OUTLINE")	
	return font
end

local function newCheckbox(x, y, fatherframe, label, description, anchroframe, varname)
	local check = CreateFrame("CheckButton", "CDAlertCheck" .. label, fatherframe, "InterfaceOptionsCheckButtonTemplate")
	check:SetPoint("TOPLEFT", anchroframe, "TOPLEFT", x, y)
	check.label = _G[check:GetName() .. "Text"]
	check.label:SetText(label)
	check:SetScript("OnEnter",function(self) 
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT") 
		GameTooltip:AddLine("|cffFFFFFF"..description.."|r") 

		GameTooltip:Show() 
		--self.anim:Play()
		--self.iconMini:Show()
	end)
	check:SetScript("OnLeave", function(self)    
		GameTooltip:Hide()
		--self.anim:Stop()
		--self.iconMini:Hide()
	end)

	
	local CheckStatus = CDAlertDB[varname]
	check:SetChecked(CheckStatus)

	check:SetScript("OnClick", function ( ... )
		CDAlertDB[varname] = check:GetChecked()
	end)
	-- check.tooltipRequirement = description
	return check
end


local cdcallIcon = {}
local cdcallInfo = {}

myGUI.frame1:SetScript("OnShow", function(frame)

	local clear = CreateFrame("Button", "CDAlertSaveButton", frame, "UIPanelButtonTemplate")
	clear:SetText("恢复默认并重载界面")
	clear:SetWidth(177)
	clear:SetHeight(24)
	clear:SetPoint("TOPLEFT", 450, 77)
	clear:SetScript("OnClick", function()
		CDAlertDB = CDAlertDefaultDB
		ReloadUI()
	end)
	local pcrl = CreateFrame("Button", "CDAlertrl", frame, "UIPanelButtonTemplate")
	pcrl:SetText("重载")
	pcrl:SetWidth(92)
	pcrl:SetHeight(22)
	pcrl:SetPoint("BOTTOMRIGHT", -132, -31)
	pcrl:SetScript("OnClick", function()
		 ReloadUI()
	end)

	local qqun = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	qqun:SetPoint("BOTTOMLEFT", -20, -30)
	qqun:SetText("简繁:斗鱼323075")
	qqun:SetJustifyH("RIGHT")
	
	cscdc= newCheckbox(25, -320, frame, "总开关","不想语音提示时关闭此项", frame, "cdcall")

	auraname = newFont(16, -15 , frame, "TOPLEFT", frame, "TOPLEFT", "|cff3399FFCDAlert|r技能冷却结束语音提醒", 30)
	if not frame.SecondText then 
		frame.SecondText = frame:CreateFontString(nil, "OVERLAY");
	end
	frame.SecondText:SetFontObject("GameFontHighlight");
	frame.SecondText:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -50 );   
	frame.SecondText:SetJustifyH("LEFT")
	frame.SecondText:SetText("添加技能法术ID,当CD结束时,会提示→|cff3399FF技能名字|r+|cff3399FF好了|r\n原理是利用自带的文本转语音做的提醒,所以语音包改不了\n几个技能同时冷却结束会依次播报");
	
	local cdcallSavedAura = CDAlertDB["cdcalls"]
	frame.cdcallDisplay = table_copy(cdcallSavedAura)

	if not frame.AuraText then 
		frame.AuraText = frame:CreateFontString(nil, "OVERLAY");
		frame.AuraText:SetFontObject("GameFontHighlight");
		frame.AuraText:SetPoint("TOPLEFT", frame, "TOPLEFT", 60, -120 );   
		frame.AuraText:SetParent(frame)
		frame.AuraText:SetFont("fonts\\ARHei.ttf", 20, "OUTLINE")
		frame.AuraText:SetText("|cff3399FF技能ID|r");
	end

	local cdcallEditText = nil 
	if not frame.EditBox then 
		frame.EditBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate");
		frame.EditBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 45 , -150);  
		frame.EditBox:SetSize(100,10);
		frame.EditBox:SetAutoFocus();
		frame.EditBox:SetMaxLetters(9);
		frame.EditBox:SetScript("OnEnterPressed", function(self)
			self:ClearFocus(); 
		    ChatFrame1EditBox:SetFocus(); 
		end);
		frame.EditBox:SetScript("OnChar", function (self, text)
			cdcallEditText = self:GetText()
		end);
	end


	local cdcallnilFrame = CreateFrame("Frame")

	local function cdcallClearAuraPanel()
		if cdcallIcon then 
			for k, v in pairs(cdcallIcon) do
				v:Hide()
				cdcallIcon[k]:Hide()
				cdcallIcon[k]:SetParent(cdcallnilFrame)
				cdcallIcon[k] = nil 
			end
		end
		if cdcallInfo then
			for k, v in pairs(cdcallInfo) do
				v:Hide()
				cdcallInfo[k]:Hide()
				cdcallInfo[k]:SetParent(cdcallnilFrame)
				cdcallInfo[k] = nil 
			end
		end
	end

	if not frame.AuraAdd then 
		frame.AuraAdd = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate");
		frame.AuraAdd:SetPoint("TOPLEFT", frame, "TOPLEFT", 33 , -170);  
		frame.AuraAdd:SetSize(120,40);
		frame.AuraAdd:SetText("添加-->")
		frame.AuraAdd:SetNormalFontObject("GameFontNormalLarge");
		frame.AuraAdd:SetHighlightFontObject("GameFontHighlightLarge");
		frame.AuraAdd:SetScript("OnClick", function(self, button, down)
			if GetTrueNum(frame.cdcallDisplay) >= 20 then return end 
			local cdcallSpellID = tonumber(cdcallEditText)
			if frame.cdcallDisplay[cdcallSpellID] then return end
			if not cdcallSpellID then return end 
			local SpellName, _ = GetSpellInfo(cdcallSpellID)
			if not SpellName then return end
			frame.cdcallDisplay[cdcallSpellID] = true
			CDAlertDB["cdcalls"] = frame.cdcallDisplay
			cdcallSetSpell(frame.cdcallDisplay)

			end)
	end

	if not frame.Auradel then 
		frame.Auradel = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate");
		frame.Auradel:SetPoint("TOPLEFT", frame, "TOPLEFT", 33 , -220);  
		frame.Auradel:SetSize(120,40);
		frame.Auradel:SetText("移除<--")
		frame.Auradel:SetNormalFontObject("GameFontNormalLarge");
		frame.Auradel:SetHighlightFontObject("GameFontHighlightLarge");
		frame.Auradel:SetScript("OnClick", function(self, button, down)
			local cdcallSpellID = tonumber(cdcallEditText)
			if not frame.cdcallDisplay[cdcallSpellID] then return end 
			frame.cdcallDisplay[cdcallSpellID] = false
			CDAlertDB["cdcalls"] = frame.cdcallDisplay
			cdcallSetSpell(frame.cdcallDisplay)
			end)
	end
		
	function cdcallSetSpell(cdcallTest)
		cdcallClearAuraPanel()
		cdcallIcon = {}
		cdcallInfo = {}
		local cdcallKeys = table_keys(cdcallTest)
		local cdcalliLeng = table_leng(cdcallTest)
		local cdcallt = 1
		local cdcallhor = 1 
		
		for i=1 , cdcalliLeng do
			local icdcallSpellID = cdcallKeys[i]  
			if cdcallTest[icdcallSpellID] then
				
				local name , _ , icon,_ ,_ ,_ ,_ = GetSpellInfo(icdcallSpellID)
				if icon == nil then icon = 237555 end
				if cdcallt >10 then
					cdcallhor = 2
					cdcallt = 1
				end
				frame.Spell = frame:CreateFontString('myarua', "OVERLAY");
				frame.Spell:SetFontObject("GameFontHighlight");
				frame.Spell:SetPoint("TOPLEFT", frame, "TOPLEFT", 200*cdcallhor, -40*cdcallt -90 );   --锚点, 位置, 偏移
				
				frame.Spell:SetParent(frame)    --todo 这写"SecondPage"和这个local 变量都可以,为什么在上面overlay后面写父会bug
				frame.Spell:SetText("|T"..icon ..":18|t "..name);
				
				--------------------
				
				frame.SpellMouseInfo = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate");
				frame.SpellMouseInfo:SetPoint("TOPLEFT", frame, "TOPLEFT", 200*cdcallhor , -40*cdcallt - 90);  
				frame.SpellMouseInfo.ID = icdcallSpellID
				
				cdcallt = cdcallt + 1;
				
				frame.SpellMouseInfo:SetSize(70,25);
				frame.SpellMouseInfo:SetText(nil)
				frame.SpellMouseInfo:SetAlpha(0);

				frame.SpellMouseInfo:SetScript("OnEnter", function(self, button, down)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetSpellByID(icdcallSpellID)
					GameTooltip:AppendText("   ".."|cff00FF7F".."技能ID:"..tostring(icdcallSpellID).."|r")
					GameTooltip:Show()
				end)
				
				frame.SpellMouseInfo:SetScript("OnLeave", function(self, button, down)
					GameTooltip:Hide()
				end)
		

				cdcallIcon[i] = frame.Spell
				cdcallInfo[i] = frame.SpellMouseInfo

			end
		
		
		end
	end

	cdcallSetSpell(frame.cdcallDisplay)

	if not frame.sInfo3 then 
	frame.sInfo3 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	end
	frame.sInfo3:SetPoint("BOTTOMRIGHT", -10, 10)
	frame.sInfo3:SetJustifyH("RIGHT")

frame:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(myGUI.frame1)

SLASH_CDAC1 = "/cda"
SLASH_CDAC2 = "/CDAlert"
SlashCmdList["CDAC"] = function() 
	InterfaceOptionsFrame_OpenToCategory(myGUI.frame1)
end
--[[10.0新api
local CDAlertoptions = Settings.RegisterCanvasLayoutCategory(myGUI.frame1, "CDAlert")
Settings.RegisterAddOnCategory(CDAlertoptions)

SLASH_CDAlertC1 = "/ad"
SLASH_CDAlertC2 = "/CDAlert"
SlashCmdList["CDAlertC"] = function() 
    --InterfaceOptionsFrame_OpenToCategory(CDAlertoptions)
	Settings.OpenToCategory(CDAlertoptions)
end
]]