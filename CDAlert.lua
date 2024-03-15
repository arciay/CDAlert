local frame = CreateFrame("FRAME", "MyAddonFrame")
frame:RegisterEvent("UNIT_SPELLCAST_SENT")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local spells = {

}

local spellCooldowns = {}
local CDcalltimer

local function CheckCooldown(spellID)
    local start, duration, _ = GetSpellCooldown(spellID)
    local remainingTime = start + duration - GetTime()

    if remainingTime <= 0 and spellCooldowns[spellID] then
        local spellName = GetSpellInfo(spellID)
        local text = spellName .. "好了"
        C_VoiceChat.SpeakText(0, text, Enum.VoiceTtsDestination.LocalPlayback, 1, 100)
        spellCooldowns[spellID] = nil
    end
end

local function eventHandler(_, event, unit, _, _, spellID)
if not CDAlertDB.cdcall then return end
    if event == "UNIT_SPELLCAST_SENT" and unit == "player" then
        if CDAlertDB["cdcalls"][spellID] then
			C_Timer.After(1,function()
				local start, duration, _ = GetSpellCooldown(spellID)
				local remainingTime = start + duration - GetTime()
				if remainingTime > 0 then
					spellCooldowns[spellID] = true
				end
			end)
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
		C_Timer.After(2,function()
			for spellID, spelltrue in pairs(CDAlertDB["cdcalls"]) do
				if spelltrue then
					local start, duration, _ = GetSpellCooldown(spellID)
					local remainingTime = start + duration - GetTime()
					if remainingTime > 0 then
						spellCooldowns[spellID] = true
					end
				end
			end
		end)
    end
end

--定时器检测
CDcalltimer = C_Timer.NewTicker(0.2, function()
	if not CDAlertDB or not CDAlertDB.cdcall then return end
	for spellID, _ in pairs(spellCooldowns) do
		CheckCooldown(spellID)
	end
end)

frame:SetScript("OnEvent", eventHandler)