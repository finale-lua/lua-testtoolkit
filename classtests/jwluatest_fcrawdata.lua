if not AssureNonNil(finale.FCRawData, "This version of the Lua plugin lacks FCRawData. Tests skipped.") then
    return
end

function FCRawData_PropertyTests(obj)
    NumberPropertyTest(obj, "FCRawData", "Tag", {
        finale.FCRawData.MakeOtherTag("RD"),
        finale.FCRawData.MakeDetailTag("RD"),
        finale.FCRawData.MakeEntryDetailTag("RD")
    })
    NumberPropertyTest(obj, "FCRawData", "Version", {0, finenv.RawFinaleVersion})

    StringPropertyTest(obj, "FCRawData", "Data", {"", "abc", string.char(0, 1, 2, 255)})
    TablePropertyTest(obj, "FCRawData", "ByteTable", {{}, {0, 1, 255}, {4, 8, 16, 32}})
    TablePropertyTest(obj, "FCRawData", "TwoByteTable", {{}, {0, 1, 65535}, {0x1234, 0xabcd}})

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
FunctionTest(obj, "FCRawData", "ClearData")
FunctionTest(obj, "FCRawData", "Load")
FunctionTest(obj, "FCRawData", "LoadWithSize")
FunctionTest(obj, "FCRawData", "Save")
FunctionTest(obj, "FCRawData", "Create")
FunctionTest(obj, "FCRawData", "Delete")

FCRawData_PropertyTests(obj)

