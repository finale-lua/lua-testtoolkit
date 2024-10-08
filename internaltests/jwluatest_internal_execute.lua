
local retvals = {12, "a string", false, function() end} -- this must match the list in tools/test_return_value.lua

if not AssureNonNil(finenv.CreateLuaScriptItemsFromFilePath, "finenv.CreateLuaScriptItemsFromFilePath exists.") then
    return
end

local function FCLuaScriptItem_TestReturnValue(item, expected_value, expected_success, expected_error_message)
    if AssureNonNil(item.AutomaticallyReportErrors) then 
        item.AutomaticallyReportErrors = false
    end
    if type(item.OptionalScriptText) == "string" then
        item.OptionalScriptText = item.OptionalScriptText:match("^%s*(.-)%s*$") -- trim whitespace, so that matching will work
    end
    local success, msg, msgtype = finenv.ExecuteLuaScriptItem(item)
    msgtype = msgtype or finenv.MessageResultType.SCRIPT_RESULT
    local expected_msgtype = expected_success and finenv.MessageResultType.SCRIPT_RESULT or finenv.MessageResultType.LUA_ERROR
    AssureEqual(msgtype, expected_msgtype, "finenv.ExecuteLuaScriptItem msgtype")
    if expected_success then
        AssureTrue(success, "finenv.ExecuteLuaScriptItem result: " .. tostring(msg))
        if expected_value and AssureNonNil(msg, "finenv.ExecuteLuaScriptItem msg") then
            if AssureType(expected_value, "string", "finenv.ExecuteLuaScriptItem expected value: " .. tostring(expected_value)) then
                AssureEqual(msg:sub(1, 8), expected_value:sub(1, 8), "finenv.ExecuteLuaScriptItem")
            end
        end
    else
        if AssureType(msg, "string", "finenv.ExecuteLuaScriptItem returned false, but message response was type "..type(msg)..".") then
            AssureTrue(#msg > 0,  "finenv.ExecuteLuaScriptItem returned false, but message was empty.")
            if expected_error_message then
                local _, end_index = msg:find(expected_error_message)
                AssureNonNil(end_index, "finenv.ExecuteLuaScriptItem returned false, but message was not the expected value. Message returned: "..msg)
            end
        end
        AssureFalse(success, "finenv.ExecuteLuaScriptItem result: " .. tostring(msg))
    end
end

local script_path
local items

-- Check return values from executed script
script_path = GetRunningFolderPath() .. "/tools/test_return_value.lua"
items = finenv.CreateLuaScriptItemsFromFilePath(script_path)
if AssureTrue(items.Count > 0, "CreateLuaScriptItemsFromFilePath for test_return_value.lua has no items") then
    -- test_return_value.lua uses a global variable (and RetainLuaState) to send the expected values back in succession
    for x = 1, 4 do
        FCLuaScriptItem_TestReturnValue(items:GetItemAt(0), tostring(retvals[x]), true)
    end
end

local binary_appendix_scripts =
{
    script_with_hidden_appendix2 = {succeed_false = false, succeed_true = true},
    script_with_hidden_appendix2_forcetrue = {succeed_false = true, succeed_true = true},
    script_with_hidden_appendix2_forcefalse = {succeed_false = false, succeed_true = false}
}

-- Check scripts with binary appendix
for name, attr in pairs(binary_appendix_scripts) do
    script_path = GetRunningFolderPath() .. "/tools/" .. name .. ".lua"
    items = finenv.CreateLuaScriptItemsFromFilePath(script_path)
    if AssureTrue(items.Count > 0, "CreateLuaScriptItemsFromFilePath for " .. name .. ".lua has no items") then
        local item = items:GetItemAt(0)
        AssureEqual(item.LoadAsString, attr.succeed_false, "Initial value for LoadString: " .. name .. ".lua")
        item.LoadAsString = false
        FCLuaScriptItem_TestReturnValue(item, "ee", attr.succeed_false)
        item.LoadAsString = true
        FCLuaScriptItem_TestReturnValue(item, "ee", attr.succeed_true)
    end
end

if not PropertyTest(items:GetItemAt(0), "FCLuaScriptItem", "OptionalScriptText") then
    return
end

-- Check script text
items = finenv.CreateLuaScriptItemsFromFilePath()
if AssureTrue(items.Count > 0, "CreateLuaScriptItemsFromFilePath for empty string has no items") then
    local item = items:GetItemAt(0)
    item.OptionalScriptText = "local function do_it() return 'ABCDE' end return do_it()"
    FCLuaScriptItem_TestReturnValue(item, "ABCDE", true)
end

-- Check print-back
local print_back_list = {3, 4.5, nil, false, "test", finale.FCString("A horse is a hoarse")}
local function print_back(...)
    local num_args = select("#", ...)
    AssureEqual(num_args, 6, "CreateLuaScriptItemsFromFilePath print_back_list unexpected number of arguments")
    local args = { ... }
    for i = 1, num_args do
        local v = args[i]
        local cmp = print_back_list[i]
        if type(cmp) == "userdata" then
            cmp = tostring(cmp)
        end
        AssureEqual(type(v), type(cmp), "CreateLuaScriptItemsFromFilePath type of print_back_list[" .. i .. "]")
        AssureEqual(v, cmp, "CreateLuaScriptItemsFromFilePath print_back_list[" .. i .. "]")
    end
end
items = finenv.CreateLuaScriptItemsFromFilePath()
if AssureTrue(items.Count > 0, "CreateLuaScriptItemsFromFilePath for emptry string has no items") then
    local item = items:GetItemAt(0)
    item.OptionalScriptText = [[
        -- the table in this string should match print_back_list above.
        local print_back_list = {3, 4.5, nil, false, "test", finale.FCString("A horse is a hoarse")}
        print(table.unpack(print_back_list))
        return "did it"
    ]]
    item:RegisterPrintFunction(print_back)
    FCLuaScriptItem_TestReturnValue(item, "did it", true)
end

-- Check on-complete values
items = finenv.CreateLuaScriptItemsFromFilePath()
if AssureTrue(items.Count > 0, "CreateLuaScriptItemsFromFilePath for empty string has no items") then
    local item = items:GetItemAt(0)
    if AssureNonNil(item.RegisterOnExecutionDidStop, "CreateLuaScriptItemsFromFilePath RegisterOnExecutionDidStop not defined (nil).") then
        local expected_linenum = 5
        local function run_script(item, expected_value, expected_success, expected_error_message)
            item:RegisterOnExecutionDidStop(function(item, success, msg, msgtype, line_number, source)
                local expected_msgtype = expected_success and finenv.MessageResultType.SCRIPT_RESULT or finenv.MessageResultType.LUA_ERROR
                AssureEqual(msgtype, expected_msgtype, "finenv.ExecuteLuaScriptItem OnExecutionDidStop msgtype")
                AssureEqual(success, expected_success, "CreateLuaScriptItemsFromFilePath OnExecutionDidStop result")
                if expected_success then
                    AssureNil(source, "CreateLuaScriptItemsFromFilePath OnExecutionDidStop returned source value")
                else                 
                    AssureStartsWith(source, item.OptionalScriptText, "CreateLuaScriptItemsFromFilePath OnExecutionDidStop returned source value")
                end
                AssureValue(line_number, expected_linenum, "CreateLuaScriptItemsFromFilePath OnExecutionDidStop returned line number")
            end)
            FCLuaScriptItem_TestReturnValue(item, expected_value, expected_success, expected_error_message)
        end
        item.OptionalScriptText = [[
            -- comment (line 1)
            -- comment (line 2)
            -- comment (line 3)
            local x = 23
            sdsd(sdsd) -- should cause runtime error at line 5
        ]]
        run_script(item, nil, false)
        expected_linenum = 4
        item.OptionalScriptText = [[
            local items = finenv.CreateLuaScriptItemsFromFilePath()
            item = items:GetItemAt(0)
            item:RegisterPrintFunction(function(...)
                asdsad(sdf) -- should cause runtime error at line 4
            end)
            item.AutomaticallyReportErrors = false
            item.OptionalScriptText = "print('Hello World!')"
            finenv.ExecuteLuaScriptItem(item)
        ]]
        run_script(item, nil, false)
        expected_linenum = 6
        item.OptionalScriptText = [[
            function plugindef()
                finaleplugin.ExecuteHttpsCalls = false
            end
            local internet = require('luaosutils').internet
            -- next line should cause runtime error
            local success, response = internet.get_sync("https://robertgpatterson.com/test space.txt", 0.001)
            assert(success, response)
        ]]
        run_script(item, nil, false, "current permissions environment")
        expected_linenum = 6
        item.OptionalScriptText = [[
            function plugindef()
                finaleplugin.ExecuteHttpsCalls = true
            end
            local internet = require('luaosutils').internet
            local success, response = internet.get_sync("https://robertgpatterson.com/test space.txt", 0.001)
            assert(success, response) -- should be a timeout error
        ]]
        run_script(item, nil, false, "Request timed out.")
        expected_linenum = 10
        item.OptionalScriptText = [[
            function plugindef()
                finaleplugin.ExecuteHttpsCalls = true
            end
            local internet = require('luaosutils').internet
            local process = require('luaosutils').process
            local success, response
            local function callback(cbsuccess, cbresponse)
                success = cbsuccess
                response = cbresponse
                assert(success, response) -- SHOULD FAIL HERE
            end
            local session = internet.get("https://robertgpatterson.com/test space.txt", callback)
            internet.report_errors(session, false)
            local timestamp = finale.FCUI.GetHiResTimer()
            while not response do
                process.run_event_loop(0.05)
                if finale.FCUI.GetHiResTimer() - timestamp > 10 then
                    success = false
                    data = "Callback was not called in time."
                end
            end
            session = internet.cancel_session(session)
            assert(success, response) -- SHOULD NOT FAIL HERE
        ]]
        run_script(item, nil, false, WinMac("Not Found", "unsupported URL"))
        expected_linenum = 2
        item.OptionalScriptText = [[
            function plugindef()
                os.execute("ls") -- should be disallowed
            end
        ]]
        run_script(item, nil, false, "current permissions environment")
        expected_linenum = 2
        item.OptionalScriptText = [[
            function plugindef()
                sdfsdfsd-!dfdsf -- should fail to even compile
            end
        ]]
        run_script(item, nil, false, "syntax error")
        item.Trusted = true
        expected_linenum = 4
        item.OptionalScriptText = [[
            function plugindef()
                finaleplugin.ExecuteExternalCode = false
            end
            os.execute("cd .") -- should get a permissions error, due to ExecuteExternalCode false
        ]]
        run_script(item, nil, false, "current permissions environment")
        expected_linenum = 0
        item.OptionalScriptText = [[
            function plugindef()
                finaleplugin.ExecuteExternalCode = true
            end
            os.execute("cd .") -- should work
        ]]
        expected_linenum = 0
        item.OptionalScriptText = [[
            function plugindef()
                finaleplugin.ExecuteExternalCode = true
            end
            local process = require('luaosutils').process
            process.execute("cd .") -- should work
        ]]
        run_script(item, nil, true)
        expected_linenum = 5
        item.OptionalScriptText = [[
            function plugindef()
                finaleplugin.ExecuteExternalCode = false
            end
            local process = require('luaosutils').process
            process.execute("cd .") -- should fail here, due to not not allowed by script
        ]]
        run_script(item, nil, false, "current permissions environment")
        expected_linenum = 4
        item.Trusted = false
        item.OptionalScriptText = [[
            function plugindef()
                finaleplugin.ExecuteExternalCode = false
            end
            os.execute("cd .") -- should get a permissions error, due to not trusted
        ]]
        run_script(item, nil, false, "current permissions environment")
        expected_linenum = 5
        item.OptionalScriptText = [[
            function plugindef()
                finaleplugin.ExecuteExternalCode = true
            end
            local process = require('luaosutils').process
            process.execute("cd .") -- should fail here, due to not trusted
        ]]
        run_script(item, nil, false, "current permissions environment")
        expected_linenum = 3
        item.OptionalScriptText = [[
            local iter = finale.FCLuaIterator()
            iter:ForEachInteger(1, 10, function(x)
                error("big mistake")
            end)
        ]]
        run_script(item, nil, false, "big mistake")
    end
end
