-- Core test tool functions for the JW Lua Test cases
-- Used by the test scripts

-- Show our running environment.
-- Putting this here means it gets shown no matter which test script initiates the test.
local os_string = " for macOS"
if finenv.UI():IsOnWindows() then
    os_string = " for Windows"
end
local fin_version = tostring((finenv.FinaleVersion > 10000) and (finenv.FinaleVersion - 10000) or finenv.FinaleVersion)
local minor_version = bit32.band(finenv.RawFinaleVersion, 0x00f00000)
if minor_version ~= 0 then
    fin_version = fin_version .. "." .. tostring(bit32.rshift(minor_version, 20))
end

LuaVersion_ = tonumber(string.match(_VERSION, "%d+%.%d+"))

local luavers_string = finenv.LuaReleaseVersion or _VERSION

local osutils = require("luaosutils")
local lfs = require("lfs")

print(luavers_string.." ("..tostring(LuaVersion_)..")")
print(finenv.LuaBridgeVersion or "LuaBridge Version Unknown")
print(osutils._VERSION)
print("Lua Plugin Version "..finenv.StringVersion)
print("Running on Finale "..fin_version..os_string)
print("Trusted mode "..tostring(finenv.TrustedMode))


_G.skip_finale_version = 0x1b200000 -- Finale 27.2 is the highest version to skip for pre-Fin26.3 unlinkable items
_G.staff_to_part = {3, 2, 1} -- The Part numbers are in reverse staff order
_G.skip_unlink_bugs_version = 0x1b400000 -- Finale 27.3 is the highest version tested for unlink bugs
_G.highest_playback_prefs_tested_version = 0x1b400000 -- Finale 27.3 is the highest version tested for EDTPlaybackPrefs26_2 bugs
_G.ignore_baselines_delete_version = 0x1b400000 -- Ignore default lyrics baselines delete problem in 27.4. Revisit with future Finale versions.
_G.do_playback_test = finenv.RawFinaleVersion > 0x1b400000 -- playback test not fixed as of 27.4
_G.playback_test_expected_to_succeed = finenv.UI():IsOnWindows()
_G.interdot_spacing_unlink_check = finenv.RawFinaleVersion <= 0x1b400000 -- Finale 27.4 is the highest version we've checked.
_G.set_staff_show_part_time_sigs_not_writable = finenv.RawFinaleVersion <= 0x1b400000 -- Finale 27.4 is the highest version we've checked.

local NoOfTests = 0
local NoOfTestErrors = 0

function PrintTestResult()
    print(NoOfTests, "tests made with", NoOfTestErrors, "test error(s).")
end

function Is2012OrAbove()
    return finenv.FinaleVersion >= 2012
end

function Is2014OrAbove()
    return finenv.FinaleVersion >= 2014
end

function Is2014BOrAbove()    
    return finenv.RawFinaleVersion >= 0x12020000
end

function Is25_2OrAbove()    
    return finenv.RawFinaleVersion >= 0x19200000
end

function Is26OrAbove()    
    return finenv.RawFinaleVersion >= 0x1a000000
end

function Is26_2OrAbove()    
    return finenv.RawFinaleVersion >= 0x1a200000
end

function Is27_1OrAbove()    
    return finenv.RawFinaleVersion >= 0x1b100000
end

function Is27_3OrAbove()    
    return finenv.RawFinaleVersion >= 0x1b300000
end

function Is27_4OrAbove()    
    return finenv.RawFinaleVersion >= 0x1b400000
end

-- A help method to assure a usable string value
function __StringVersion(expression)
    if expression == nil then return "(nil)" end
    if type(expression) == "boolean" then
        if expression then return "(true)" end
        return "(false)"
    end
    return "" .. expression
end

-- Increases the total test counter
function TestIncrease()
    NoOfTests = NoOfTests + 1
end

-- Report test error and increase error counter:
function TestError(errorstring)
    print("TEST ERROR: "..errorstring)
    NoOfTestErrors = NoOfTestErrors + 1
end

function AssureValue(testvalue, valueexpected, expression)
    TestIncrease()
    if testvalue == valueexpected then return true end
    TestError("Value test failed for " .. __StringVersion(expression) .. ". Value was " .. __StringVersion(testvalue) .. " but " ..  __StringVersion(valueexpected) .. " was expected.")
    return false
end

function AssureType(param, typestring, expression) 
    TestIncrease()
    if type(param) == typestring then return true end
    TestError("Type test failed for " .. expression .. ". Type was " .. type(param) .. " but " ..  typestring .. " was expected.")
    return false
end

-- Test that the value is true
function AssureTrue(value, expression)
    TestIncrease()
    if value == true then return true end
    TestError("Test for 'true' failed for " .. __StringVersion(expression))    
    return false
end


-- Test that the value is false
function AssureFalse(value, expression)
    TestIncrease()
    if value == false then return true end
    TestError("Test for 'false' failed for " .. __StringVersion(expression))
    return false
end


-- Tests that the value is non-nil
function AssureNonNil(value, testtext)
    testtext = testtext or "AssureNonNil"
    TestIncrease()
    if value ~= nil then return true end
    TestError(testtext .. " (Value is nil.)")
    return false
end

-- Tests that the value is nil
function AssureNil(value, testtext)
    testtext = testtext or "AssureNil"
    TestIncrease()
    if value == nil then return true end
    TestError(testtext .. " (Value is non-nil.)")
    return false
end

function ValueString(value)
    if type(value) ~= "table" then
        return tostring(value)
    end
    local retval = "{"
    local function vtostr(v)
        if type(v) == "string" then
            return '"' .. v .. '"'
        elseif type(v) == "table" then
            return ValueString(v)
        end
        return tostring(v)
    end    
    for k, v in pairsbykeys(value) do
        if #retval > 1 then
            retval = retval .. ", "
        end
        retval = retval .. "[" .. vtostr(k) .. "]=" .. vtostr(v)
    end
    retval = retval .. "}"
    return retval
end

function AssureEqualTable(table1, table2, testtext)
    local function get_table_count(t)
        local retval = 0
        for _, _ in pairs(t) do
            retval = retval + 1
        end
        return retval
    end
    if not AssureEqual(type(table1), "table", testtext .. " table1 is not a table.") then return false end
    if not AssureEqual(type(table2), "table", testtext .. " table2 is not a table.") then return false end
    if not AssureEqual(get_table_count(table1), get_table_count(table2), testtext .. " number of elements is not equal.") then return false end
    for k1, v1 in pairs(table1) do
        if not AssureEqual(v1, table2[k1], testtext .. " table values do not match.") then return false end
    end
    return true
end

function AssureEqual(value1, value2, testtext)
    local retval
    if type(value1) == "table" then
        retval = AssureEqualTable(value1, value2, testtext)
    else
        TestIncrease()
        retval =  value1 == value2
    end
    if retval then return true end
    TestError(testtext .. " (value1: " .. ValueString(value1) .. ", value2: " .. ValueString(value2) ..")")
    return false
end

function AssureStartsWith(value1, value2, testtext)
    if not AssureType(value1, "string", testtext) or not AssureType(value2, "string", testtext) then
        return false
    end
    TestIncrease()
    if value1:sub(1, #value2) == value2 then return true end
    TestError(testtext .. " (value1: " .. ValueString(value1) .. ", value2: " .. ValueString(value2) ..")")
    return false
end

function AssureEqualStrings(str1, str2, testtext)
    if not AssureEqual(type(str1), "string", testtext.." (str1 is not a string)") then return false end
    if not AssureEqual(type(str2), "string", testtext.." (str2 is not a string)") then return false end
    TestIncrease()
    local len1, len2 = #str1, #str2
    local len = math.min(len1, len2)
    local diffPos = nil

    for i = 1, len do
    local ch1 = str1:sub(i,i)
    local ch2 = str2:sub(i,i)
    if str1:sub(i,i) ~= str2:sub(i,i) then
        diffPos = i
        break
    end
    end

    if not diffPos and len1 == len2 then
        return true
    end

    if not diffPos then
        diffPos = len + 1
    end

    local str1Remainder = str1:sub(diffPos)
    local str2Remainder = str2:sub(diffPos)

    TestError(testtext.." (first difference is at position " .. diffPos .. ")")
    TestError("    str1: " .. str1Remainder)
    TestError("    str2: " .. str2Remainder)
end

-- Tests if the key name exists in the parent table.
function TestKeyInParentTable(classtable, keyname, indexname)
    local ptable = nil
    if finenv.IsRGPLua then
        ptable = classtable["__parent"]
        if type(ptable) == "table" then
            for k2, v2 in pairs(ptable) do
                classtable = _G.finale[k2]
                ptable = classtable
                if ptable and indexname == "" then
                    ptable = classtable.__class
                end
            end
        end
    else
        ptable = classtable.__class["__parent"]
    end
    if not ptable then
        return false
    end
    if not (indexname == "")  then
        ptable = ptable[indexname]
    end
    for k, v in pairs(ptable) do
        --print (k, keyname)
        if (k == keyname) then return true end
    end
    if finenv.MajorVersion == 0 and finenv.MinorVersion < 68 then
        -- do not recurse in JW Lua, because __FCBase crashes us
        -- do not recurse in RGP Lua before 0.68, because __FCBase causes infinite loop when
        --      function does not exist.
        return false
    end
    return TestKeyInParentTable(classtable, keyname, indexname)
end

-- Tests if the key name exists in the table
function AssureKeyInTable(classtable, keyname, indexname, testtext)
    TestIncrease()
    local testtable = classtable.__class
    if not (indexname == "")  then
        if finenv.MinorVersion <= 54 then
            testtable = testtable[indexname]
        else
            testtable = classtable[indexname]
        end
    end
    for k, v in pairs(testtable) do
        if k == keyname then return true end        
    end
    -- Test parent class info
    if TestKeyInParentTable(classtable, keyname, indexname) then
        return true
    end
    TestError(testtext .. keyname)    
    return false
end

function GetPropTable(classtable, key)
    if finenv.MinorVersion > 54 then
        return classtable[key]
    end
    return classtable.__class[key]
end

-- Tests that the property name exists
function TestPropertyName(classname, propertyname, testsetter, namespace)
    namespace = namespace or "finale"
    TestIncrease()
    for k,v in pairs(_G[namespace]) do
        if k == classname and TestKVIsClass(namespace, v) then
            -- Class name found
            if not AssureNonNil(GetPropTable(v, "__propget"),  "Internal error: __propget wasn't found for class " .. classname) then return false end
            if not AssureNonNil(GetPropTable(v, "__propset"), "Internal error: __propset wasn't found for class " .. classname) then return false end
            local retval = true
            if not AssureKeyInTable(v, propertyname, "__propget", "Getter property not found for class " .. classname .. ": ") then
                retval = false
            end
            local methodname = "Get" .. propertyname
            if not AssureKeyInTable(v, methodname, "", "Getter method not found for class " .. classname .. ": ") then
                retval = false
            end
            if testsetter then
                if not AssureKeyInTable(v, propertyname, "__propset", "Setter property not found for " .. classname .. ": ") then
                    retval = false
                end
                methodname = "Set" .. propertyname
                if not AssureKeyInTable(v, methodname, "", "Setter method not found for " .. classname .. ": ") then
                    retval = false
                end
            end
            return retval
        end
    end
    TestError("Class name not found: " .. classname)
    return false
end

function TestKVIsClass(namespace, classstable)
    return (namespace == "finale") and classstable.__class or true
end

-- Tests that the function name exists
function TestFunctionName(classname, functionname)
    TestIncrease()
    for k,v in pairs(_G.finale) do
        if k == classname and TestKVIsClass(namespace, v) then
            -- Class name found
            return AssureKeyInTable(v, functionname, "", "Function not found for class " .. classname .. ": ")
        end
    end
    TestError("Class name not found: " .. classname)
    return false
end

-- Test the availability of the class and that the ClassName() method returns the correct string
function TestClassName(obj, classname, namespace)
    namespace = namespace or "finale"
    TestIncrease()
    if (obj == nil) then
        TestError("'obj' is nil in TestClassName() when testing for classname " .. classname)
        return false
    end
    TestIncrease()
    for k,v in pairs(_G[namespace]) do
        if k == classname and TestKVIsClass(namespace, v) then
            -- Class name found - test the Class name method in the object
            TestIncrease()
            if AssureNonNil(obj.ClassName, "ClassName method for class "..classname) then
                if obj:ClassName() ~= classname then
                    TestError("ClassName() method for class " .. classname .. " returns " .. obj:ClassName())
                end
            end
            return true -- Class found, so that's considered a success
        end
    end
    TestError("Class name not found: " .. classname)
    return false
end

-- Read-only test for properties
function PropertyTest_RO(obj, classname, propertyname, namespace)
    if not TestClassName(obj, classname, namespace) then return end
    TestPropertyName(classname, propertyname, false, namespace)
end

-- Test for read/write properties
function PropertyTest(obj, classname, propertyname, namespace)
    if not TestClassName(obj, classname, namespace) then return false end
    return TestPropertyName(classname, propertyname, true, namespace)
end

-- Test for class methods
function FunctionTest(obj, classname, functionname)
    if not TestClassName(obj, classname) then return false end
    return TestFunctionName(classname, functionname)
end

-- Test for static function existence
function StaticFunctionTest(classname, functionname)
    TestIncrease()
    if (_G.finale[classname] == nil) then
        TestError("Classname not found in StaticFunctionTest() when testing for classname " ..
        classname .. "." .. functionname)
        return false
    end
    TestIncrease()
    if (_G.finale[classname][functionname] == nil) then
        TestError("Function is nil in StaticFunctionTest() when testing for classname " ..
        classname .. "." .. functionname)
        return false
    end
end

-- Test for number properties
function TypedPropertyTest(obj, classname, propertyname, expected_type, value_table, savefunction, reloadfunction, reload_replaces_obj)
    if not AssureNonNil(obj, classname.."."..propertyname.. " instance.") then return obj end
    PropertyTest(obj, classname, propertyname)
    if not AssureType(obj[propertyname], expected_type, "property " .. classname .. "." .. propertyname) then return end
    -- Test to set each number in the number table
    if value_table == nil and expected_type == "boolean" then
        value_table = {not obj[propertyname]}
    end
    if value_table == nil then
        TestIncrease()
        TestError("Internal error - Value test table for property " .. classname .. "." .. propertyname .. " test is nil.")
        return obj
    end
    
    savefunction = savefunction or obj["Save"]
    if reload_replaces_obj == nil then
        reload_replaces_obj = (reloadfunction ~= nil)
    end
    reloadfunction = reloadfunction or obj["Reload"]
    

    local oldvalue = obj[propertyname]
    table.insert(value_table, 1, oldvalue) -- make sure we can save and reload the current value
    for k, v in pairs(value_table) do        
        local success, message = pcall(function() obj[propertyname] = v end)
        if not AssureTrue(success, "Writing to property " .. classname .. "." .. propertyname .. ": " .. tostring(message)) then
            return obj
        end
        TestIncrease()
        if savefunction and reloadfunction then  
            AssureTrue(savefunction(obj), classname .. "::Save()")
            obj[propertyname] = oldvalue
            if reload_replaces_obj then
                local new_obj = reloadfunction(obj)
                if AssureNonNil(new_obj, classname .. " reloadfunction") then
                    obj = new_obj
                end
            else
                AssureTrue(reloadfunction(obj), classname .. "::Reload()")
            end
        end
        if not AssureEqual(obj[propertyname], v, "Setting property " .. classname .. "." .. propertyname .. " to value.") then
            TestError("Value test failure while trying to set/save " .. classname .. "." .. propertyname .. " to " .. ValueString(v) .. " (received ".. ValueString(obj[propertyname]) .. ")" )
        end        
    end
    -- Restore the previous value
    obj[propertyname] = oldvalue
    if savefunction then AssureTrue(savefunction(obj), classname .. "::Save()") end
    return obj
end


-- Test for boolean properties
function BoolPropertyTest(obj, classname, propertyname)
    return TypedPropertyTest(obj, classname, propertyname, "boolean")
end

-- Test for read-only boolean properties
function BoolPropertyTest_RO(obj, classname, propertyname)
    PropertyTest_RO(obj, classname, propertyname)
    if not AssureType(obj[propertyname], "boolean", "property " .. classname .. "." .. propertyname) then return end
end

-- Test for number properties
function NumberPropertyTest(obj, classname, propertyname, numbertable, savefunction, reloadfunction, reload_replaces_obj)
    return TypedPropertyTest(obj, classname, propertyname, "number", numbertable, savefunction, reloadfunction, reload_replaces_obj)
end

-- Test for number properties read-only)
function NumberPropertyTest_RO(obj, classname, propertyname)
    PropertyTest_RO(obj, classname, propertyname)
    if not AssureType(obj[propertyname], "number", "property " .. classname .. "." .. propertyname) then return end    
end

-- Test for string properties
function StringPropertyTest(obj, classname, propertyname, stringtable)
    return TypedPropertyTest(obj, classname, propertyname, "string", stringtable)
end

-- Test for table properties
function TablePropertyTest(obj, classname, propertyname, tablestable, savefunction, reloadfunction)
    return TypedPropertyTest(obj, classname, propertyname, "table", tablestable, savefunction, reloadfunction)
end

-- Test for indexed function pairs
function NumberIndexedFunctionPairsTest(obj, classname, gettername, settername, index, numbertable, savefunction, reloadfunction)
    if not AssureNonNil(obj, "nil passed to NumberIndexedFunctionPairsTest for " .. classname .. "." .. gettername .. " index " .. index) then return nil end
    if not savefunction and obj.Save then
        savefunction = function() return obj:Save() end
    end
    if not reloadfunction and obj.Reload then
        reloadfunction = function()
            if not obj:Reload() then return nil end
            return obj
        end
    end    
    FunctionTest(obj, classname, gettername)
    if not obj[gettername] then
        return obj
    end
    FunctionTest(obj, classname, settername)
    if savefunction and not obj[settername] then
        return obj
    end
    -- Test to set each number in the number table
    if numbertable == nil then
        TestIncrease()
        TestError("Internal error - Number test table for getter function " .. classname .. "." .. gettername .. " test is nil.")
        return obj
    end

    local oldvalue = obj[gettername](obj, index)
    for k, v in pairs(numbertable) do        
        obj[settername](obj, index, v)        
        TestIncrease()
        if savefunction and reloadfunction then    
            AssureTrue(savefunction(), classname .. " save function")
            obj[settername](obj, index, oldvalue)
            obj = reloadfunction() -- the reload function can replace the obj pointer with a new value, including nil
            if not AssureNonNil(obj, classname .. " reload function") then
                break
            end
        end
        if obj[gettername](obj, index) ~= v then
            TestError("Number test failure while trying to set/save " .. classname .. ":" .. settername .. " to " .. v .. " with index " .. index .. " (received ".. obj[gettername](obj, index) .. ")" )
        end        
    end
    -- Restore the previous value, if reloadfunction didn't kill it
    if obj then
        obj[settername](obj, index, oldvalue)
        if savefunction then AssureTrue(savefunction(), classname .. " save function") end
    end
    return obj
end

-- Test for indexed function pairs
function BoolIndexedFunctionPairsTest(obj, classname, gettername, settername, index, savefunction, reloadfunction)
    if not AssureNonNil(index, "nil index passed to BoolIndexedFunctionPairsTest for " .. classname .. "." .. gettername) then return nil end
    if not AssureNonNil(obj, "nil passed to BoolIndexedFunctionPairsTest for " .. classname .. "." .. gettername .. " index " .. index) then return nil end
    if not savefunction and obj.Save then
        savefunction = function() return obj:Save() end
    end
    if not reloadfunction and obj.Reload then
        reloadfunction = function()
            if not obj:Reload() then return nil end
            return obj
        end
    end    
    FunctionTest(obj, classname, gettername)
    FunctionTest(obj, classname, settername)

    local oldvalue = obj[gettername](obj, index)
    for k, v in pairs({true, false}) do        
        obj[settername](obj, index, v)        
        TestIncrease()
        if savefunction and reloadfunction then    
            AssureTrue(savefunction(), classname .. " save function")
            obj[settername](obj, index, oldvalue)
            obj = reloadfunction() -- the reload function can replace the obj pointer with a new value, including nil
            if not AssureNonNil(obj, classname .. " reload function") then
                break
            end
        end
        if obj[gettername](obj, index) ~= v then
            TestError("Boolean test failure while trying to set/save " .. classname .. ":" .. settername .. " to " .. ValueString(v) .. " with index " .. ValueString(index) .. " (received ".. ValueString(obj[gettername](obj, index)) .. ")" )
        end        
    end
    -- Restore the previous value, if reloadfunction didn't kill it
    if obj then
        obj[settername](obj, index, oldvalue)
        if savefunction then AssureTrue(savefunction(), classname .. " save function") end
    end
    return obj
end

-- This function is used to with certain records because a particular property is supposed to unlink but doesn't.
-- This allows the test scripts to pre-unlink the records so that the test can run without errors.
-- It can be changed to do nothing so that we can discover which properties still need to be fixed.
function UnlinkWithProperty(obj, classname, updater, loadfunction, loadargument, increment, partnumber, skipfinaleversion)
    if finenv.RawFinaleVersion > skip_unlink_bugs_version then -- skip_unlink_bugs_version is the top version number we check for this
        return
    end
    skipfinaleversion = skipfinaleversion or 0 -- skipfinaleversion is optional
    if finenv.RawFinaleVersion <= skipfinaleversion then return end
    if not AssureNonNil(obj, "nil passed to UnlinkWithProperty for " .. classname .. "." .. tostring(updater) .. " partnumber " .. partnumber) then return end
        local updater_is_function = type(updater) == "function"
    if not updater_is_function then
        if not AssureTrue(type(updater) == "string", "UnlinkWithProperty updater is string. ("..classname..")") then return end
        PropertyTest(obj, classname, updater)
        if not AssureNonNil(obj[updater], "UnlinkWithProperty "..classname.."."..updater..".") then return end
    end
    if not AssureTrue(increment ~= 0, "UnlinkWithProperty Internal error: zero passed for increment. ("..classname..")") then return end
    if not AssureTrue(partnumber ~= finale.PARTID_SCORE, "UnlinkWithProperty Internal error: score passed instead of part. ("..classname..")") then return end
    local part = finale.FCPart(partnumber)
    if not AssureTrue(part:Load(partnumber), "UnlinkWithProperty Internal error: load partnumber. ("..classname..")") then return end
    
    local loadfunction_is_function = type(loadfunction) == "function"
    local obj_load = function()
        if loadfunction_is_function then
            return loadfunction()
        end
        return obj[loadfunction](obj, loadargument)
    end
    if not loadfunction_is_function then
        if not AssureNonNil(obj[loadfunction], classname.."."..loadfunction.." does not exist.") then return end
    end
    local loaded_in_score = obj_load()
    
    if not AssureNonNil(obj.Reload, classname..".".."Reload".." does not exist.") then return end
    if not AssureNonNil(obj.Save, classname..".".."Save".." does not exist.") then return end
    
    local obj_updater = function(value)
        if updater_is_function then return updater(value) end
        if value ~= nil then
            obj[updater] = value
        end
        return obj[updater]
    end
    
    local score_value = obj_updater()
    part:SwitchTo()
    local loaded_in_part = obj_load()
    local new_value
    if type(score_value) == "boolean" then
        new_value = not score_value
    else
        new_value = score_value + increment
    end
    obj_updater(new_value)
    AssureTrue(loaded_in_part and obj:Save() or obj.SaveNew and obj:SaveNew(), "UnlinkableNumberPropertyTest Internal error: save new value in part. ("..classname..")")
    obj_updater(score_value)
    AssureTrue(loaded_in_part and obj:Save() or obj.SaveNew and obj:SaveNew(), "UnlinkableNumberPropertyTest Internal error: restore old value in part. ("..classname..")")
    part:SwitchBack()
end    

-- Test for unlinkable property; assumes score in view to begin with
-- The updater parameter is either a function that is passed the increment or nil or a writable property name.
-- The load function is either a function or the name of a load method.
-- The unlinkproperty parameter is used to pre-unlink the property. It is only non-nil in rare bug cases,
-- and the bugs get flagged again with each new Finale version. (See UnlinkWithProperty function above.)
-- Here is a list of known tests that use the unlinkproperty to work around a bug:
--              jwluatest_unlink_fcbackwardrepeat
function UnlinkableNumberPropertyTest(obj, classname, updater, loadfunction, loadargument, increment, partnumber, skipfinaleversion, unlinkproperty)
    skipfinaleversion = skipfinaleversion or 0 -- skipfinaleversion is optional
    if finenv.RawFinaleVersion <= skipfinaleversion then return end
    if not AssureNonNil(obj, "nil passed to UnlinkableNumberPropertyTest for " .. classname .. "." .. tostring(updater) .. " partnumber " .. partnumber) then return end
    
    local updater_is_function = type(updater) == "function"
    if not updater_is_function then
        if not AssureTrue(type(updater) == "string", "UnlinkableNumberPropertyTest updater is string. ("..classname..")") then return end
        PropertyTest(obj, classname, updater)
        if not AssureNonNil(obj[updater], "UnlinkableNumberPropertyTest "..classname.."."..updater..".") then return end
    end
    if not AssureTrue(increment ~= 0, "UnlinkableNumberPropertyTest Internal error: zero passed for increment. ("..classname..")") then return end
    if not AssureTrue(partnumber ~= finale.PARTID_SCORE, "UnlinkableNumberPropertyTest Internal error: score passed instead of part. ("..classname..")") then return end
    local part = finale.FCPart(partnumber)
    if not AssureTrue(part:Load(partnumber), "UnlinkableNumberPropertyTest Internal error: load partnumber. ("..classname..")") then return end
    
    local loadfunction_is_function = type(loadfunction) == "function"
    local obj_load = function()
        if loadfunction_is_function then
            return loadfunction()
        end
        return obj[loadfunction](obj, loadargument)
    end
    if not loadfunction_is_function then
        if not AssureNonNil(obj[loadfunction], classname.."."..loadfunction.." does not exist.") then return end
    end
    local loaded_in_score = obj_load()
    
    if not AssureNonNil(obj.Reload, classname..".".."Reload".." does not exist.") then return end
    if not AssureNonNil(obj.Save, classname..".".."Save".." does not exist.") then return end
    if not AssureNonNil(obj.RelinkToCurrentView, classname..".".."RelinkToCurrentView".." does not exist.") then return end
    if not AssureNonNil(obj.RelinkToScore, classname..".".."RelinkToScore".." does not exist.") then return end
    if not loaded_in_score then
        if not AssureNonNil(obj.SaveNew, classname..".".."SaveNew".." does not exist.") then return end
        if not AssureNonNil(obj.DeleteData, classname..".".."DeleteData".." does not exist.") then return end
    end
    if loadfunction == "LoadAt" then
        if not AssureNonNil(obj.SaveAt, classname..".".."SaveAt".." does not exist.") then return end
    end
    
    local obj_save = function(loaded)
        if loadfunction == "LoadAt" then
            return obj:SaveAt(loadargument)
        end
        return loaded and obj:Save() or obj.SaveNew and obj:SaveNew()
    end
    
    local obj_updater = function(value)
        if updater_is_function then return updater(value) end
        if value ~= nil then
            obj[updater] = value
        end
        return obj[updater]
    end
    
    local get_loadargument = function()
        if type(loadargument) == "userdata" and loadargument.NoteID then
            return "NoteID ".. ValueString(loadargument.NoteID)
        end
        return ValueString(loadargument)
    end
    
    local score_value = obj_updater()
    local new_value
    if type(score_value) == "boolean" then
        new_value = not score_value
    else
        new_value = score_value + increment
    end
    if loaded_in_score and finenv.RawFinaleVersion > skip_unlink_bugs_version then
        -- check that modifying in score view does not cause an unlink
        AssureTrue(obj:RelinkToScore(), "UnlinkableNumberPropertyTest Internal error: relink to score before testing erroneous unlink. ("..classname..")")
        obj_updater(new_value)
        AssureTrue(obj:Save(), "UnlinkableNumberPropertyTest Internal error: save in score for testing erroneous unlink. ("..classname..")")
        part:SwitchTo()
        if AssureTrue(obj:Reload(), "UnlinkableNumberPropertyTest loading to see if changing in score erroneously unlinks. ("..classname..")") then
            AssureEqual(obj_updater(), new_value, classname.."."..tostring(updater).." unlinks erroneously when modified in score view.")
        end
        part:SwitchBack()
        AssureTrue(obj:Reload(), "UnlinkableNumberPropertyTest loading score after seeing if changing in score erroneously unlinks.")
        obj_updater(score_value)
        AssureTrue(obj:Save(), "UnlinkableNumberPropertyTest Internal error: save in score after testing erroneous unlink. ("..classname..")")
        AssureTrue(obj:RelinkToScore(), "UnlinkableNumberPropertyTest Internal error: relink to score after testing erroneous unlink. ("..classname..")")
    end
    if unlinkproperty then
        UnlinkWithProperty(obj, classname, unlinkproperty, loadfunction, loadargument, increment, partnumber, skipfinaleversion)
    end
    part:SwitchTo()
    local loaded_in_part = obj_load()
    obj_updater(new_value)
    AssureTrue(obj_save(loaded_in_part), "UnlinkableNumberPropertyTest Internal error: save in part. ("..classname..")")
    AssureTrue(obj:Reload(), "UnlinkableNumberPropertyTest Internal error: reload in part. ("..classname..")")
    AssureTrue(obj_updater() == new_value, "UnlinkableNumberPropertyTest Internal error: value for "..tostring(updater).." not retained in part after reload. ("..classname..")")
    part:SwitchBack()
    AssureTrue(obj:Reload(), "UnlinkableNumberPropertyTest Internal error: reload in score. ("..classname..")")
    local is_unlinkable = AssureTrue(obj_updater() == score_value, classname.."."..tostring(updater).." is unlinkable with load argument "..get_loadargument()..".")
    if is_unlinkable then
        --
        part:SwitchTo()
        AssureTrue(obj:Reload(), "UnlinkableNumberPropertyTest Internal error: reload in part for relink. ("..classname..")")
        AssureTrue(obj_updater() == new_value, classname.."."..tostring(updater).." did not retain value after switch-to-part.")
        AssureTrue(obj:RelinkToCurrentView(), "UnlinkableNumberPropertyTest Internal error: relink to current view. ("..classname..")")
        part:SwitchBack()
        AssureTrue(obj:Reload(), "UnlinkableNumberPropertyTest Internal error: reload in score for relink. ("..classname..")")
        AssureTrue(obj_updater() == new_value, classname.."."..tostring(updater).." was relinked.")
        obj_updater(score_value)
        AssureTrue(obj_save(loaded_in_part), "UnlinkableNumberPropertyTest Internal error: save for reverting score value after relink to current. ("..classname..")")
        --
        if unlinkproperty then
            UnlinkWithProperty(obj, classname, unlinkproperty, loadfunction, loadargument, increment, partnumber, skipfinaleversion)
        else
            part:SwitchTo()
            AssureTrue(obj:Reload(), "UnlinkableNumberPropertyTest Internal error: reload in part for relink to score 1. ("..classname..")")
            obj_updater(new_value)
            AssureTrue(obj_save(loaded_in_part), "UnlinkableNumberPropertyTest Internal error: save for relink to score. ("..classname..")")
            part:SwitchBack()
        end
        AssureTrue(obj:Reload(), "UnlinkableNumberPropertyTest Internal error: reload in score for relink to score. ("..classname..")")
        AssureTrue(obj_updater() == score_value, classname.."."..tostring(updater).." was unlinked for relink to score.")
        part:SwitchTo()
        AssureTrue(obj:Reload(), "UnlinkableNumberPropertyTest Internal error: reload in part for relink to score 2. ("..classname..")")
        AssureTrue(obj:RelinkToScore(), "UnlinkableNumberPropertyTest Internal error: relink to score. ("..classname..")")
        AssureTrue(obj_updater() == score_value, classname.."."..tostring(updater).." was relinked for relink to score.")
        part:SwitchBack()
    end
    if not loaded_in_score then
        obj:DeleteData()
    else
        obj_updater(score_value)
        obj:Save()
    end
end

-- Test for getter/setter pair that gets FCSring
function FCStringGetterSetterTest(obj, classname, gettername, settername, stringtable)
    if not FunctionTest(obj, classname, gettername) then return end
    if not FunctionTest(obj, classname, settername) then return end
    -- Test to set each value in the stringtable
    if stringtable == nil then
        TestIncrease()
        TestError("Internal error - String test table for getter " ..
            classname .. "." .. gettername .. " test is nil.")
        return
    end

    local oldvalue = finale.FCString()
    obj[gettername](obj, oldvalue)
    for k, v in pairs(stringtable) do
        local newvalue = finale.FCString()
        newvalue.LuaString = v
        obj[settername](obj, newvalue)
        TestIncrease()
        AssureTrue(obj:Save(), classname .. "::Save()")
        obj[settername](obj, oldvalue)
        AssureTrue(obj:Reload(), classname .. "::Reload()")
        local testvalue = finale.FCString()
        obj[gettername](obj, testvalue)
        if testvalue.LuaString ~= v then
            TestError("FCString test failure while trying to set/save " ..
                classname .. "." .. settername .. " to " .. v .. " (received " .. testvalue.LuaString .. ")")
            break
        end
    end
    -- Restore the previous value
    obj[settername](obj, oldvalue)
    AssureTrue(obj:Save(), classname .. "::Save()")
end


-- Test for creator/setter pair
function CreatorSetterTest(obj, classname, creatorname, settername, comparefunction, valuetable)
    if not FunctionTest(obj, classname, creatorname) then return end
    if not FunctionTest(obj, classname, settername) then return end
    if not AssureEqual(type(comparefunction), "function", "CreatorSetterTest compare function is not a function.") then
        return
    end
    -- Test to set each value in the stringtable
    if valuetable == nil then
        TestIncrease()
        TestError("Internal error - Value test table for creator " ..
            classname .. "." .. creatorname .. " test is nil.")
        return
    end

    local oldvalue = obj[creatorname](obj)
    table.insert(valuetable, 1, obj[creatorname](obj)) -- start with (a copy of) our current value
    for k, newvalue in pairs(valuetable) do
        AssureEqual(newvalue:ClassName(), oldvalue:ClassName(), "CreatorSetterTest value table item class mismatch.")
        obj[settername](obj, newvalue)
        TestIncrease()
        AssureTrue(obj:Save(), classname .. "::Save()")
        obj[settername](obj, oldvalue)
        AssureTrue(obj:Reload(), classname .. "::Reload()")
        local testvalue = obj[creatorname](obj)
        if not comparefunction(testvalue, newvalue) then
            TestError("CreatorSetterTest test failure while trying to set/save " ..
                classname .. "." .. settername .. " to " .. tostring(newvalue) .. " (received " .. tostring(testvalue) .. ")")
            break
        end
    end
    -- Restore the previous value
    obj[settername](obj, oldvalue)
    AssureTrue(obj:Save(), classname .. "::Save()")
end

function FCFontInfoCompare(font1, font2)
    if not AssureTrue(type(font1) == "userdata" and font1:ClassName() == "FCFontInfo", "FCFontInfoCompare font1 wrong type") then
        return false
    end
    if not AssureTrue(type(font2) == "userdata" and font2:ClassName() == "FCFontInfo", "FCFontInfoCompare font2 wrong type") then
        return false
    end
    if font1.FontID ~= font2.FontID then return false end
    if font1.Size ~= font2.Size then return false end
    if font1.EnigmaStyles ~= font2.EnigmaStyles then return false end
    return true
end


-- Test for object read-only properties
function ObjectPropertyTest_RO(obj, classname, propertyname, returnclass)
    PropertyTest_RO(obj, classname, propertyname)
    if not AssureType(obj[propertyname], "userdata", "property " .. classname .. "." .. propertyname) then return end
    -- Test that the class is correct (by looking at the ClassName() method)
    local returnvalue = obj[propertyname]    
    TestIncrease()
    if returnvalue:ClassName() ~= returnclass then
        TestError("Object class name for property " .. classname .. "." .. propertyname .. " was " .. returnvalue:ClassName() .. " instead of " .. returnclass)
    end
end

function BoolString(boolval)
    if boolval then return "true" end
    return "false"
end

function TypedValuePropertyTest(obj, classname, propertyname, expectedtype, expectedvalue, tryvalue)    
    PropertyTest(obj, classname, propertyname)
    if not AssureType(obj[propertyname], expectedtype, "property " .. classname .. "." .. propertyname) then return end
    AssureEqual(obj[propertyname], expectedvalue, "Loaded " .. expectedtype .. " value for " .. classname .. "." .. propertyname .." was not equal. expected value")
    if tryvalue ~= nil and obj["Set" .. propertyname] then
        obj[propertyname] = tryvalue
        AssureEqual(obj[propertyname], tryvalue, "Tried " .. expectedtype .. " value for " .. classname .. "." .. propertyname .. " was not equal.")
        obj[propertyname] = expectedvalue
    end
end

function BoolValuePropertyTest(obj, classname, propertyname, expectedvalue, read_only)
    local tryvalue
    if not read_only then
        tryvalue = not expectedvalue
    end
    TypedValuePropertyTest(obj, classname, propertyname, "boolean", expectedvalue, tryvalue)
end

function NumberValuePropertyTest(obj, classname, propertyname, expectedvalue, tryvalue)
    TypedValuePropertyTest(obj, classname, propertyname, "number", expectedvalue, tryvalue)
end

function StringValuePropertyTest(obj, classname, propertyname, expectedvalue)
    TypedValuePropertyTest(obj, classname, propertyname, "string", expectedvalue)
end

function TableValuePropertyTest(obj, classname, propertyname, expectedvalue)
    TypedValuePropertyTest(obj, classname, propertyname, "table", expectedvalue)
end

function BoolValuePropertyTest_RO(obj, classname, propertyname, expectedvalue)
    PropertyTest_RO(obj, classname, propertyname)
    if not AssureType(obj[propertyname], "boolean", "property " .. classname .. "." .. propertyname) then return end
    TestIncrease()
    if obj[propertyname] ~= expectedvalue then
        TestError("Loaded boolean value for " .. classname .. "." .. propertyname .. " was " .. BoolString(obj[propertyname]) .. " instead of " .. BoolString(expectedvalue))
    end
end

function NumberValuePropertyTest_RO(obj, classname, propertyname, expectedvalue)
    PropertyTest_RO(obj, classname, propertyname)
    if not AssureType(obj[propertyname], "number", "property " .. classname .. "." .. propertyname) then return end
    if obj[propertyname] ~= expectedvalue then
        TestError("Loaded number value for " .. classname .. "." .. propertyname .. " was " .. obj[propertyname] .. " instead of " .. expectedvalue)
    end
end

function NumberConstantTest(constobj, constname, expectedvalue)
    -- Test for nil
    TestIncrease()
    if not constobj then
        TestError("Constant " .. constname .. " doesn't exist.")
        return
    end
    -- Test type
    TestIncrease()
    if type(constobj) ~= "number" then
        TestError(constname .. " is not a number constant. Actual type: " .. type(constobj))
        return
    end
    -- Test expected value
    TestIncrease()
    if constobj ~= expectedvalue then
        TestError("Constant " .. constname .. " does not have the expected value. Expected: " .. ValueString(expectedvalue) .. "  Actual: " .. ValueString(constobj))
    end
end

function NumberIndexValueTest(obj, classname, numberfunction, index, expectedvalue)
    -- Test for nil
    TestIncrease()
    if not obj then
        TestError("Class " .. classname .. " doesn't exist.")
        return
    end
    -- Test for method
    TestIncrease()
    if not obj[numberfunction] then
        TestError(numberfunction .. " is not a method in class " .. classname)
        return
    end
    local val = obj[numberfunction](obj, index)
    -- Test type
    TestIncrease()
    if type(val) ~= "number" then
        TestError(classname .. ":" .. numberfunction .. " does not return a number constant. It returns type: " .. type(val))
        return
    end
    -- Test expected value
    TestIncrease()
    if val ~= expectedvalue then
        TestError(classname .. ":" .. numberfunction .. " does not have the expected value. Expected: " .. ValueString(expectedvalue) .. "  Actual: " .. ValueString(val))
    end
end

function StringConstantTest(constobj, constname, expectedvalue)
    -- Test for nil
    TestIncrease()
    if not constobj then
        TestError("Constant " .. constname .. " doesn't exist.")
        return
    end
    -- Test type
    TestIncrease()
    if type(constobj) ~= "string" then
        TestError(constname .. " is not a string constant. Actual type: " .. type(constobj))
        return
    end
    -- Test expected value
    TestIncrease()
    if constobj ~= expectedvalue then
        TestError("Constant " .. constname .. " does not have the expected value. Expected: ", expectedvalue .. "  Actual: " .. constobj)
    end
end


function LoadMeasureEntryLocal(measureno, staffno, entryid)
    local notecell = finale.FCNoteEntryCell(measureno, staffno)
    AssureTrue(notecell:Load(), "LME_notecell:Load() in LoadMeasureEntryLocal")
    return notecell:FindEntryNumber(entryid), notecell
end
        
-- Tries to find a specific note entry in the file. At each call, it clears the old loaded frames.
function LoadMeasureEntry(measureno, staffno, entryid)
    if LME_notecell then LME_notecell:ClearFrame() end
    LME_notecell = finale.FCNoteEntryCell(measureno, staffno)
    AssureTrue(LME_notecell:Load(), "LME_notecell:Load() in LoadMeasureEntry")
    return LME_notecell:FindEntryNumber(entryid)    
end

function CheckForOfficialTestTemplate()
    local fileinfotext = finale.FCFileInfoText()
    fileinfotext:LoadDescription()
    local str = fileinfotext:CreateString()
    str:TrimEnigmaTags()
    str:TrimWhitespace()
    if str.LuaString ~= "This is the official JW Lua test template." then
        print ("Wrong file is used for the test. Please load the official Lua test file (testtemplate/testtemplate-fin2011format.musx).")
        return false
    end
    return true
end

function GetRunningFolderPath()
    if finenv.RunningLuaFolderPath then
        return finenv.RunningLuaFolderPath()
    end
    local str = finale.FCString()
    str:SetRunningLuaFolderPath()
    return str.LuaString
end

function WinMac(winval, macval)
    if finenv.UI():IsOnWindows() then
        return winval
    else
        return macval
    end
end

function DoRequire(str)
    -- this function allows for require to fail gracefully with a test error
    local success, lib = pcall(function() return require(str) end)
    if not AssureTrue(success, "require('"..str.."'): "..tostring(lib)) then
        return nil
    end
    return lib
end

function CreateMusicRegion(startmeas, startstaff, startpos, endmeas, endstaff, endpos)
    local region = finale.FCMusicRegion()
    region.StartMeasure = startmeas
    region.StartStaff = startstaff
    region.StartMeasurePos = startpos
    region.EndMeasure = endmeas
    region.EndStaff = endstaff
    region.EndMeasurePos = endpos
    return region
end

function CopyFileToScratch(source_path)
    local base_dir = GetRunningFolderPath()
    local scratch_dir = base_dir .. "/scratch"

    local filename = tostring(source_path):match("([^/\\]+)$")
    if not AssureNonNil(filename, "Invalid source path: " .. tostring(source_path)) then
        return nil
    end

    local scratch_path = scratch_dir .. "/" .. filename

    -- ensure ./scratch exists
    local attr = lfs.attributes(scratch_dir)
    if not attr then
        if not AssureNonNil(lfs.mkdir(scratch_dir), "unable to create scratch directory") then
            return nil
        end
    elseif not AssureEqual(attr.mode, "directory", scratch_dir .. " exists but is not a directory") then
        return nil
    end

    -- capture source mtime before copy
    local src_attr = assert(lfs.attributes(source_path))
    local mtime = src_attr.modification

    -- copy file (binary-safe)
    local in_f  = assert(io.open(source_path, "rb"))
    local out_f = assert(io.open(scratch_path, "wb"))

    for chunk in function() return in_f:read(8192) end do
        out_f:write(chunk)
    end

    in_f:close()
    out_f:close()

    -- preserve modification time
    lfs.touch(scratch_path, mtime)

    return scratch_path
end



