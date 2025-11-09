function plugindef()
   -- This function and the 'finaleplugin' namespace
   -- are both reserved for the plug-in definition.
   finaleplugin.NoStore = true
   finaleplugin.Author = "Jari Williamsson"
   finaleplugin.CategoryTags = "Debug, Development, Diagnose, UI"
   return "Create Property Test", "Create Property Test", "Create a test for the properties found for a class."
end

if finenv.IsRGPLua and not finenv.ConsoleIsAvailable then -- if new lua
    require('mobdebug').start()
end

-- Show dialog
if not finenv.IsRGPLua then
    local dialog = finenv.UserValueInput()
    dialog.Title = "Create Property Test"
    dialog:SetTypes("String", "String")
    dialog:SetDescriptions("Class name:", "Passed argument name to function:")

    local returnvalues = dialog:Execute()
    if returnvalues == nil then return end

    ClassNameToFind = returnvalues[1]
    PassedArgument = returnvalues[2]
else
    ClassNameToFind = "FCExpression"
    PassedArgument = "obj"
end

local TestOutput = ""
local TestOutputCount = 0


function FindInTable(t, keyname)
    for k, v in pairs(t) do
        if k == keyname then return true end
    end    
    return false
end

function AddToTestOutput(instance, propertyname, readonly)
    local testname = "PropertyTest"
    local args = ""
    if readonly then
        testname = testname .. "_RO"
    end
    if instance then
        if type(instance[propertyname]) == "boolean" then
            testname = "Bool" .. testname
        elseif type(instance[propertyname]) == "number" then
            testname = "Number" .. testname
            args = ", {-144, 0, 144}" -- this is a placeholder and should be manually customized per property
        end
    end
    TestOutput = TestOutput .. "   " .. testname .. "("  .. PassedArgument .. ', "' .. ClassNameToFind .. '", "' .. propertyname .. '"' .. args .. ")\n"
    TestOutputCount = TestOutputCount + 1
end

function DumpClassTable(classname, t)
    if not t.__propget then return false end
    if not t.__propset then return false end
    local success, instance = pcall(finale[classname])
    if not success then
        instance = nil
    end
    for k, v in pairsbykeys(t.__propget) do
        local readonly = not FindInTable(t.__propset, k)
        AddToTestOutput(instance, k, readonly)
    end
    return true
end

local processed = false
TestOutput = "function " .. ClassNameToFind .. "_PropertyTests(" .. PassedArgument .. ")\n"
for k,v in pairs(_G.finale) do
    if k == ClassNameToFind then  
        if not finenv.IsRGPLua then
            if v.__class then
                if DumpClassTable(k, v.__class) then processed = true end
            end
        else
            if DumpClassTable(k, v) then processed = true end
        end
        if DumpClassTable(k, v.__class) then processed = true end       
    end
end
if processed then
    if TestOutputCount > 0 then
        TestOutput = TestOutput .. "end\n\n\n-- Call:\nlocal " .. PassedArgument .. " = finale." .. 
                    ClassNameToFind .. "()\nAssureTrue(" .. 
                    PassedArgument .. ":Load(somearg), \"".. ClassNameToFind .. ":Load()\")\n" .. 
                    ClassNameToFind .. "_PropertyTests(" .. 
                    PassedArgument .. ")\n"
        if finenv.UI():TextToClipboard(TestOutput) then
            finenv.UI():AlertInfo("Code has been copied to the clipboard.", "Test Created")
        end
    else
        finenv.UI():AlertInfo("No properties found for class"..ClassNameToFind, "Test Not Created")
    end
else
    finenv.UI():AlertInfo("Error: No "..ClassNameToFind.." class found.", "Test Not Created")
end

-- Present sorted result:








