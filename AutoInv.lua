local keyword = string.upper("sweep")

local frame = CreateFrame("FRAME", "AutoInv")
frame:RegisterEvent("CHAT_MSG_WHISPER")
 

local function autoInv(self, event, message, author)
    local theirName = string.match(author, "(.+)-")
    if string.find(string.upper(message), keyword) then InviteUnit(theirName) end
end

frame:SetScript("OnEvent", autoInv)