if not AssureNonNil(finale.FCRawData, "This version of the Lua plugin lacks FCRawData. Tests skipped.") then
    return
end

local function get_first_system_staff()
    local system_staves = finale.FCSystemStaves()
    if not AssureTrue(system_staves:LoadAllForItem(0) > 0, "FCSystemStaves:LoadAllForItem(0) for FCRawData payload tests") then
        return nil
    end
    for ss in each(system_staves) do
        return ss
    end
    return nil
end

function FCRawData_PropertyTests(obj)
    local savefunction = function(_) return true end
    local fullsavefunction = function(o) return o:Save() end
    local fullreloadfunction = function(o) return o:Load() end

    NumberPropertyTest(obj, "FCRawData", "Tag", {
        finale.FCRawData.MakeOtherTag("RD"),
        finale.FCRawData.MakeDetailTag("RD"),
        finale.FCRawData.MakeEntryDetailTag("RD")
    }, savefunction)
    NumberPropertyTest(obj, "FCRawData", "Version", {0, finenv.RawFinaleVersion}, savefunction)
    NumberPropertyTest_RO(obj, "FCRawData", "TagDataType")
    NumberPropertyTest_RO(obj, "FCRawData", "IncisPerStruct")
    PropertyTest_RO(obj, "FCRawData", "TagChars")
    if AssureType(obj.TagChars, "string", "FCRawData.TagChars type") then
        AssureTrue(#obj.TagChars == 2, "FCRawData.TagChars length is 2")
    end
    PropertyTest(obj, "FCRawData", "FourByteTable")

    -- Use an existing FCSystemStaff (inci-based other) for payload save+reload tests.
    local system_staff = get_first_system_staff()
    if system_staff
            and AssureTrue(obj:AssignTarget(system_staff), "FCRawData:AssignTarget for payload tests")
            and AssureTrue(obj:Load(), "FCRawData:Load for payload tests") then
        local function clone_array(source)
            local result = {}
            for i = 1, #source do
                result[i] = source[i]
            end
            return result
        end

        -- EData payloads may be padded with trailing zeroes up to inci boundaries.
        -- For roundtrip checks, require exact prefix match and allow only zero-valued padding at the tail.
        local function assure_table_prefix_with_zero_padding(actual, expected, caption)
            if not AssureTrue(#actual >= #expected, caption .. " length check") then
                return false
            end
            for i = 1, #expected do
                if not AssureEqual(actual[i], expected[i], caption .. " value at index " .. tostring(i)) then
                    return false
                end
            end
            for i = #expected + 1, #actual do
                if not AssureEqual(actual[i], 0, caption .. " zero padding at index " .. tostring(i)) then
                    return false
                end
            end
            return true
        end

        local function assure_string_prefix_with_zero_padding(actual, expected, caption)
            if not AssureTrue(#actual >= #expected, caption .. " length check") then
                return false
            end
            if not AssureEqual(string.sub(actual, 1, #expected), expected, caption .. " prefix") then
                return false
            end
            for i = #expected + 1, #actual do
                if not AssureEqual(string.byte(actual, i), 0, caption .. " zero padding at index " .. tostring(i)) then
                    return false
                end
            end
            return true
        end

        local old_data = obj.Data
        if #old_data > 2 then
            local data_values = {}
            local mid = math.floor(#old_data / 2)
            local bend = #old_data - 1
            data_values[1] = string.sub(old_data, 1, mid - 1) .. string.char((string.byte(old_data, mid) + 1) % 256) .. string.sub(old_data, mid + 1)
            data_values[2] = string.sub(old_data, 1, bend - 1) .. string.char((string.byte(old_data, bend) + 1) % 256) .. string.sub(old_data, bend + 1)
            for _, v in ipairs(data_values) do
                obj.Data = v
                AssureTrue(fullsavefunction(obj), "FCRawData::Save() for Data")
                AssureTrue(fullreloadfunction(obj), "FCRawData::Reload() for Data")
                assure_string_prefix_with_zero_padding(obj.Data, v, "FCRawData.Data roundtrip")
            end
            obj.Data = old_data
            AssureTrue(fullsavefunction(obj), "FCRawData::Save() restore Data")
            AssureTrue(fullreloadfunction(obj), "FCRawData::Reload() restore Data")
        end

        local old_bytes = obj.ByteTable
        if #old_bytes > 0 then
            local byte_values = {}
            byte_values[1] = clone_array(old_bytes)
            byte_values[1][math.max(1, #byte_values[1] - 1)] = (byte_values[1][math.max(1, #byte_values[1] - 1)] + 1) % 256
            if #old_bytes > 1 then
                byte_values[2] = clone_array(old_bytes)
                local idx = math.max(1, #byte_values[2] - 2)
                byte_values[2][idx] = (byte_values[2][idx] + 1) % 256
            end
            for _, v in ipairs(byte_values) do
                obj.ByteTable = v
                AssureTrue(fullsavefunction(obj), "FCRawData::Save() for ByteTable")
                AssureTrue(fullreloadfunction(obj), "FCRawData::Reload() for ByteTable")
                assure_table_prefix_with_zero_padding(obj.ByteTable, v, "FCRawData.ByteTable roundtrip")
            end
            obj.ByteTable = old_bytes
            AssureTrue(fullsavefunction(obj), "FCRawData::Save() restore ByteTable")
            AssureTrue(fullreloadfunction(obj), "FCRawData::Reload() restore ByteTable")
        end

        local old_twobytes = obj.TwoByteTable
        if #old_twobytes > 0 then
            local twobyte_values = {}
            twobyte_values[1] = clone_array(old_twobytes)
            twobyte_values[1][math.max(1, #twobyte_values[1] - 1)] = (twobyte_values[1][math.max(1, #twobyte_values[1] - 1)] + 1) % 65536
            if #old_twobytes > 1 then
                twobyte_values[2] = clone_array(old_twobytes)
                local idx = math.max(1, #twobyte_values[2] - 2)
                twobyte_values[2][idx] = (twobyte_values[2][idx] + 1) % 65536
            end
            for _, v in ipairs(twobyte_values) do
                obj.TwoByteTable = v
                AssureTrue(fullsavefunction(obj), "FCRawData::Save() for TwoByteTable")
                AssureTrue(fullreloadfunction(obj), "FCRawData::Reload() for TwoByteTable")
                assure_table_prefix_with_zero_padding(obj.TwoByteTable, v, "FCRawData.TwoByteTable roundtrip")
            end
            obj.TwoByteTable = old_twobytes
            AssureTrue(fullsavefunction(obj), "FCRawData::Save() restore TwoByteTable")
            AssureTrue(fullreloadfunction(obj), "FCRawData::Reload() restore TwoByteTable")
        end
    end

    NumberPropertyTest_RO(obj, "FCRawData", "OtherCmper")
    NumberPropertyTest_RO(obj, "FCRawData", "OtherInci")
    NumberPropertyTest_RO(obj, "FCRawData", "DetailCmper1")
    NumberPropertyTest_RO(obj, "FCRawData", "DetailCmper2")
    NumberPropertyTest_RO(obj, "FCRawData", "DetailInci")
    NumberPropertyTest_RO(obj, "FCRawData", "EntryDetailEntryNumber")
    NumberPropertyTest_RO(obj, "FCRawData", "EntryDetailInci")
    NumberPropertyTest_RO(obj, "FCRawData", "ByteCount")
end

-- Call:
local obj = finale.FCRawData()

StaticFunctionTest("FCRawData", "MakeOtherTag")
StaticFunctionTest("FCRawData", "MakeDetailTag")
StaticFunctionTest("FCRawData", "MakeEntryDetailTag")

FunctionTest(obj, "FCRawData", "AssignTarget")
FunctionTest(obj, "FCRawData", "SetTagAsOther")
FunctionTest(obj, "FCRawData", "SetTagAsDetail")
FunctionTest(obj, "FCRawData", "SetTagAsEntryDetail")
FunctionTest(obj, "FCRawData", "SetDataIDAsOther")
FunctionTest(obj, "FCRawData", "SetDataIDAsDetail")
FunctionTest(obj, "FCRawData", "SetDataIDAsEntryDetail")
FunctionTest(obj, "FCRawData", "SetTargetAsOther")
FunctionTest(obj, "FCRawData", "SetTargetAsDetail")
FunctionTest(obj, "FCRawData", "SetTargetAsEntryDetail")
FunctionTest(obj, "FCRawData", "GetFourByte")
FunctionTest(obj, "FCRawData", "SetFourByte")
FunctionTest(obj, "FCRawData", "ClearData")
FunctionTest(obj, "FCRawData", "Load")
FunctionTest(obj, "FCRawData", "LoadWithSize")
FunctionTest(obj, "FCRawData", "LoadWithExpectedSize")
FunctionTest(obj, "FCRawData", "Exists")
FunctionTest(obj, "FCRawData", "LoadNextInci")
FunctionTest(obj, "FCRawData", "Save")
FunctionTest(obj, "FCRawData", "Create")
FunctionTest(obj, "FCRawData", "Delete")

FCRawData_PropertyTests(obj)
