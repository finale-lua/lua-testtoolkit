local function get_running_path()
    if finenv.RunningLuaFolderPath then
        return finenv.RunningLuaFolderPath()
    end
    local str = finale.FCString()
    str:SetRunningLuaFolderPath()
    return str.LuaString
end

local retvals = {12, "a string", false, function() end} -- this must match the list in tools/test_return_value.lua

local script_path = get_running_path() .. "/tools/test_return_value.lua"
local items = finenv.CreateLuaScriptItemsFromFilePath(script_path)
for x = 1, 4 do
    local success, errmsg, msgtype = finenv.ExecuteLuaScriptItem(items:GetItemAt(0))
    AssureTrue(success, "finenv.ExecuteLuaScriptItem result")
    AssureNonNil(errmsg, "finenv.ExecuteLuaScriptItem errmsg")
    AssureEqual(msgtype, finenv.MessageResultType.SCRIPT_RESULT, "finenv.ExecuteLuaScriptItem msgtype")
    AssureEqual(errmsg:sub(1, 8), tostring(retvals[x]):sub(1, 8), "finenv.ExecuteLuaScriptItem")
end
