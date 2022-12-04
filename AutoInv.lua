local purp = "|cffb100cd"
local cyan = "|cff00ffff"

local loaded = false

-- Slash commands
local function startsWith(str, start)
   return str:sub(1, #start) == start
end

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function handleCommand(msg)
    if startsWith(msg, "set key") then
        AutoInvSettings["keyword"] = trim(msg:sub(8, #msg))
        print(purp .. "[AutoInv]: keyword now set to " .. cyan .. AutoInvSettings["keyword"])
    elseif startsWith(msg, "get key") then		
        print(purp .. "[AutoInv]: keyword is currently set to " .. cyan .. AutoInvSettings["keyword"])
    elseif startsWith(msg, "on") then
       AutoInvSettings["enabled"] = true
        print(purp .. "[AutoInv]: enabled now set to " .. cyan .. tostring(AutoInvSettings["enabled"]))
    elseif startsWith(msg, "off") then
        AutoInvSettings["enabled"] = false
        print(purp .. "[AutoInv]: enabled now set to " .. cyan .. tostring(AutoInvSettings["enabled"]))
    elseif startsWith(msg, "help") then
        print (purp .. "[AutoInv]: When whispered your keyword, automatically invites the player to your group.")
        print (purp .. "Command reference:")
        print (cyan .. "    set key <keyword> " .. purp .. " -- sets a new keyword or phrase")
        print (cyan .. "    get key " .. purp .. " -- prints the current key")
        print (cyan .. "    on " .. purp .. " -- enables automatic invites")
        print (cyan .. "    off " .. purp .. " -- disables automatic invites")
        print (cyan .. "    help " .. purp .. " -- prints this documentation")
	else
        print (purp .. "[AutoInv]:  keyword: " .. cyan .. AutoInvSettings["keyword"] .. purp .. "    enabled: " .. cyan .. tostring(AutoInvSettings["enabled"]) .. purp .. "    For usage enter  " .. cyan .. "/autoinv help")
    end	
end

SLASH_AUTOINV1 = "/autoinv"
SlashCmdList["AUTOINV"] = handleCommand


-- Main logic
local function loadSettings()
    if not loaded then
        if AutoInvSettings == nil then AutoInvSettings = { keyword="inv", enabled=true } end
        print (purp .. "[AutoInv]:  keyword: " .. cyan .. AutoInvSettings["keyword"] .. purp .. "    enabled: " .. cyan .. tostring(AutoInvSettings["enabled"]) .. purp .. "    For usage enter  " .. cyan .. "/autoinv help")
    end
    loaded = true
end

local function handleWhisper(message, author)
    if not AutoInvSettings["enabled"] then return end
    local theirName = string.match(author, "(.+)-")
    if string.find(string.lower(message), AutoInvSettings["keyword"]) then InviteUnit(theirName) end
end


-- Primary loop
local function autoInv(self, event, message, author)
    if (event == "ADDON_LOADED") then loadSettings() end
    if (event == "CHAT_MSG_WHISPER") then handleWhisper(message, author) end
end

local frame = CreateFrame("FRAME", "AutoInv")
frame:RegisterEvent("CHAT_MSG_WHISPER")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", autoInv)
