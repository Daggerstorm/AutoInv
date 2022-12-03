local purp = "|cffb100cd"
local cyan = "|cff00ffff"

local loaded = false

-- Slash commands
local function startsWith(str, start)
   return str:sub(1, #start) == start
end

local function split(input)
    local t={}
    for str in string.gmatch(input, "([^".."%s".."]+)") do
        table.insert(t, str)
    end
    return t
end

local function toggleGuildOnly()
    AutoInvSettings["guildOnly"] = not AutoInvSettings["guildOnly"]
    print(purp .. "[AutoInv]: guildOnly now set to " .. cyan .. tostring(AutoInvSettings["guildOnly"]))
end

-- TODO: write help docs
local function handleCommand(msg)
    print(purp .. "[AutoInv] handling command: " .. cyan .. msg)
    parts = split(msg)
    if startsWith(msg, "set key") then		
        AutoInvSettings["keyword"] = parts[#parts]
        print(purp .. "[AutoInv]: keyword now set to " .. cyan .. parts[#parts])
    elseif startsWith(msg, "get key") then		
        print(purp .. "[AutoInv]: keyword is currently set to " .. cyan .. AutoInvSettings["keyword"])
    elseif startsWith(msg, "guild only") then
        toggleGuildOnly()
    elseif startsWith(msg, "go") then
        toggleGuildOnly() 
    elseif startsWith(msg, "help") then
        print (purp .. "TODO: HELP DOCS")
	else
        print (purp .. "[AutoInv]:  keyword: " .. cyan .. AutoInvSettings["keyword"] .. purp .. "    guildOnly: " .. cyan .. tostring(AutoInvSettings["guildOnly"]) .. purp .. ". For usage enter  " .. cyan .. "/autoinv help")
    end	
end

SLASH_AUTOINV1 = "/autoinv"
SlashCmdList["AUTOINV"] = handleCommand


-- Main logic
local function loadSettings()
    if not loaded then
        if AutoInvSettings == nil then AutoInvSettings = { keyword="inv", guildOnly=false } end
        print (purp .. "[AutoInv]:  keyword: " .. cyan .. AutoInvSettings["keyword"] .. purp .. "    guildOnly: " .. cyan .. tostring(AutoInvSettings["guildOnly"]) .. purp .. ". For usage enter  " .. cyan .. "/autoinv help")
    end
    
    loaded = true
end

local function handleWhisper(message, author)
    print(purp .. "[AutoInv] is inspecting this message...|r")
    local theirName = string.match(author, "(.+)-")
    -- TODO: Respect guildOnly 
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