if not AssureNonNil(finale.FCRawData, "This version of the Lua plugin lacks FCRawData. Tests skipped.") then
    return
end

function FCRawData_ValueTests_Setters(obj)
    obj:SetTagAsOther("RD")
    AssureEqual(obj.Tag, finale.FCRawData.MakeOtherTag("RD"), "FCRawData:SetTagAsOther")
    obj:SetTagAsDetail("RD", 3)
    AssureEqual(obj.Tag, finale.FCRawData.MakeDetailTag("RD", 3), "FCRawData:SetTagAsDetail")
    obj:SetTagAsEntryDetail("RD", 2)
    AssureEqual(obj.Tag, finale.FCRawData.MakeEntryDetailTag("RD", 2), "FCRawData:SetTagAsEntryDetail")

    obj:SetDataIDAsOther(12345)
    AssureEqual(obj.OtherCmper, 12345, "FCRawData.OtherCmper from SetDataIDAsOther")
    AssureEqual(obj.OtherInci, 0, "FCRawData.OtherInci default from SetDataIDAsOther")
    obj:SetDataIDAsOther(12345, 23)
    AssureEqual(obj.OtherInci, 23, "FCRawData.OtherInci from SetDataIDAsOther")

    obj:SetDataIDAsDetail(17, 29)
    AssureEqual(obj.DetailCmper1, 17, "FCRawData.DetailCmper1 from SetDataIDAsDetail")
    AssureEqual(obj.DetailCmper2, 29, "FCRawData.DetailCmper2 from SetDataIDAsDetail")
    AssureEqual(obj.DetailInci, 0, "FCRawData.DetailInci default from SetDataIDAsDetail")
    obj:SetDataIDAsDetail(17, 29, 31)
    AssureEqual(obj.DetailInci, 31, "FCRawData.DetailInci from SetDataIDAsDetail")

    obj:SetDataIDAsEntryDetail(193)
    AssureEqual(obj.EntryDetailEntryNumber, 193, "FCRawData.EntryDetailEntryNumber from SetDataIDAsEntryDetail")
    AssureEqual(obj.EntryDetailInci, 0, "FCRawData.EntryDetailInci default from SetDataIDAsEntryDetail")
    obj:SetDataIDAsEntryDetail(193, 7)
    AssureEqual(obj.EntryDetailInci, 7, "FCRawData.EntryDetailInci from SetDataIDAsEntryDetail")
end

function FCRawData_ValueTests_DataTables(obj)
    obj.ByteTable = {1, 2, 3}
    AssureEqual(obj.Data, string.char(1, 2, 3), "FCRawData.ByteTable -> Data")
    AssureEqual(obj.TwoByteTable, {513, 3}, "FCRawData.ByteTable -> TwoByteTable")

    obj.Data = string.char(0, 127, 255)
    AssureEqual(obj.ByteTable, {0, 127, 255}, "FCRawData.Data -> ByteTable")
    AssureEqual(obj.TwoByteTable, {32512, 255}, "FCRawData.Data -> TwoByteTable")

    obj.TwoByteTable = {0, 258, 65535}
    AssureEqual(obj.ByteTable, {0, 0, 2, 1, 255, 255}, "FCRawData.TwoByteTable -> ByteTable")
    AssureEqual(obj.Data, string.char(0, 0, 2, 1, 255, 255), "FCRawData.TwoByteTable -> Data")

    local old_data = obj.Data
    local success = pcall(function() obj.ByteTable = {-1} end)
    AssureFalse(success, "FCRawData.ByteTable rejects value < 0")
    AssureEqual(obj.Data, old_data, "FCRawData.ByteTable remains unchanged after invalid write")

    success = pcall(function() obj.TwoByteTable = {70000} end)
    AssureFalse(success, "FCRawData.TwoByteTable rejects value > 65535")
    AssureEqual(obj.Data, old_data, "FCRawData.TwoByteTable remains unchanged after invalid write")

    obj:ClearData()
    AssureEqual(obj.ByteCount, 0, "FCRawData:ClearData resets ByteCount")
    AssureEqual(obj.Data, "", "FCRawData:ClearData resets Data")
end

function FCRawData_ValueTests_StaticValidation()
    local success = pcall(function() return finale.FCRawData.MakeOtherTag("R") end)
    AssureFalse(success, "FCRawData.MakeOtherTag rejects one-character tag")
    success = pcall(function() return finale.FCRawData.MakeDetailTag("RAW") end)
    AssureFalse(success, "FCRawData.MakeDetailTag rejects three-character tag")
    success = pcall(function() return finale.FCRawData.MakeEntryDetailTag("RD", 0) end)
    AssureFalse(success, "FCRawData.MakeEntryDetailTag rejects incisPerStruct < 1")
end

function FCRawData_ValueTests_AssignAndIO(obj)
    local exprdef = finale.FCTextExpressionDef()
    AssureTrue(exprdef:Load(1), "FCTextExpressionDef:Load(1) for FCRawData.AssignTarget")
    AssureTrue(obj:AssignTarget(exprdef), "FCRawData:AssignTarget")
    AssureTrue(obj.Tag ~= 0, "FCRawData.Tag is non-zero after AssignTarget")

    AssureTrue(obj:Load(), "FCRawData:Load from FCTextExpressionDef target")
    AssureTrue(obj.ByteCount > 0, "FCRawData loaded byte count > 0")

    local loaded_bytes = obj.ByteTable
    local loaded_size = obj.ByteCount
    AssureTrue(obj:LoadWithSize(loaded_size), "FCRawData:LoadWithSize(existing size)")
    AssureEqual(obj.ByteCount, loaded_size, "FCRawData:LoadWithSize preserves byte count")
    AssureEqual(obj.ByteTable, loaded_bytes, "FCRawData:LoadWithSize preserves data")

    obj.ByteTable = loaded_bytes
    AssureTrue(obj:Save(), "FCRawData:Save unchanged data")
end

-- Call:
local obj = finale.FCRawData()
FCRawData_ValueTests_Setters(obj)
FCRawData_ValueTests_DataTables(obj)
FCRawData_ValueTests_StaticValidation()
FCRawData_ValueTests_AssignAndIO(obj)
