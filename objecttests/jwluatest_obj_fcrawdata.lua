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

    obj:SetTargetAsOther("RD", 4321)
    AssureEqual(obj.TagChars, "RD", "FCRawData.TagChars from SetTargetAsOther")
    AssureEqual(obj.OtherCmper, 4321, "FCRawData.OtherCmper from SetTargetAsOther")
    AssureEqual(obj.OtherInci, 0, "FCRawData.OtherInci default from SetTargetAsOther")
    AssureEqual(obj.IncisPerStruct, 1, "FCRawData.IncisPerStruct default from SetTargetAsOther")
    AssureEqual(obj.TagDataType, bit32.rshift(obj.Tag, 16), "FCRawData.TagDataType from SetTargetAsOther")

    obj:SetTargetAsDetail("RD", 17, 29, 3, 4)
    AssureEqual(obj.TagChars, "RD", "FCRawData.TagChars from SetTargetAsDetail")
    AssureEqual(obj.DetailCmper1, 17, "FCRawData.DetailCmper1 from SetTargetAsDetail")
    AssureEqual(obj.DetailCmper2, 29, "FCRawData.DetailCmper2 from SetTargetAsDetail")
    AssureEqual(obj.DetailInci, 3, "FCRawData.DetailInci from SetTargetAsDetail")
    AssureEqual(obj.IncisPerStruct, 4, "FCRawData.IncisPerStruct from SetTargetAsDetail")
    AssureEqual(obj.TagDataType, bit32.rshift(obj.Tag, 16), "FCRawData.TagDataType from SetTargetAsDetail")

    obj:SetTargetAsEntryDetail("RD", 193, 5, 2)
    AssureEqual(obj.TagChars, "RD", "FCRawData.TagChars from SetTargetAsEntryDetail")
    AssureEqual(obj.EntryDetailEntryNumber, 193, "FCRawData.EntryDetailEntryNumber from SetTargetAsEntryDetail")
    AssureEqual(obj.EntryDetailInci, 5, "FCRawData.EntryDetailInci from SetTargetAsEntryDetail")
    AssureEqual(obj.IncisPerStruct, 2, "FCRawData.IncisPerStruct from SetTargetAsEntryDetail")
    AssureEqual(obj.TagDataType, bit32.rshift(obj.Tag, 16), "FCRawData.TagDataType from SetTargetAsEntryDetail")
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

function FCRawData_ValueTests_FourByteHelpers(obj)
    local values = {0, 1, -1, 2147483647, -2147483648}
    obj.FourByteTable = values
    AssureEqual(obj.FourByteTable, values, "FCRawData.FourByteTable roundtrip")
    AssureEqual(obj.ByteCount, 20, "FCRawData.FourByteTable byte count")

    AssureEqual(obj:GetFourByte(0), 0, "FCRawData:GetFourByte offset 0")
    AssureEqual(obj:GetFourByte(4), 1, "FCRawData:GetFourByte offset 4")
    AssureEqual(obj:GetFourByte(8), -1, "FCRawData:GetFourByte offset 8")
    AssureEqual(obj:GetFourByte(12), 2147483647, "FCRawData:GetFourByte offset 12")
    AssureEqual(obj:GetFourByte(16), -2147483648, "FCRawData:GetFourByte offset 16")

    AssureTrue(obj:SetFourByte(4, -42), "FCRawData:SetFourByte valid offset")
    AssureEqual(obj:GetFourByte(4), -42, "FCRawData:SetFourByte wrote value")
    AssureFalse(obj:SetFourByte(-1, 1), "FCRawData:SetFourByte rejects negative offset")
    AssureFalse(obj:SetFourByte(17, 1), "FCRawData:SetFourByte rejects out-of-range offset")
    AssureEqual(obj:GetFourByte(-1), 0, "FCRawData:GetFourByte returns 0 for negative offset")
    AssureEqual(obj:GetFourByte(17), 0, "FCRawData:GetFourByte returns 0 for out-of-range offset")
end

local function get_first_system_staff()
    local system_staves = finale.FCSystemStaves()
    if not AssureTrue(system_staves:LoadAllForItem(0) > 0, "FCSystemStaves:LoadAllForItem(0) for FCRawData tests") then
        return nil
    end
    for ss in each(system_staves) do
        return ss
    end
    return nil
end

function FCRawData_ValueTests_AssignAndIO(obj)
    local system_staff = get_first_system_staff()
    if not system_staff then
        return
    end
    AssureTrue(obj:AssignTarget(system_staff), "FCRawData:AssignTarget from FCSystemStaff")
    AssureTrue(obj.Tag ~= 0, "FCRawData.Tag is non-zero after AssignTarget")

    AssureTrue(obj:Load(), "FCRawData:Load from FCSystemStaff target")
    AssureTrue(obj.ByteCount > 0, "FCRawData loaded byte count > 0")

    local loaded_bytes = obj.ByteTable
    local loaded_size = obj.ByteCount
    AssureTrue(obj:Exists(), "FCRawData:Exists on loaded target")
    AssureTrue(obj:LoadWithSize(loaded_size), "FCRawData:LoadWithSize(existing size)")
    AssureEqual(obj.ByteCount, loaded_size, "FCRawData:LoadWithSize preserves byte count")
    AssureEqual(obj.ByteTable, loaded_bytes, "FCRawData:LoadWithSize preserves data")
    AssureTrue(obj:LoadWithExpectedSize(loaded_size), "FCRawData:LoadWithExpectedSize(existing size)")
    AssureFalse(obj:LoadWithExpectedSize(loaded_size + 1), "FCRawData:LoadWithExpectedSize detects mismatch")
    AssureTrue(obj:Load(), "FCRawData:Load after expected-size mismatch")

    obj.ByteTable = loaded_bytes
    AssureTrue(obj:Save(), "FCRawData:Save unchanged data")

    local empty = finale.FCRawData()
    AssureFalse(empty:Exists(), "FCRawData:Exists false for unassigned object")
    AssureFalse(empty:LoadNextInci(), "FCRawData:LoadNextInci false for unassigned object")
end

function FCBaseData_ValueTests_RawProperties()
    local system_staff = get_first_system_staff()
    if not AssureNonNil(system_staff, "FCSystemStaff available for __FCBaseData raw properties") then
        return
    end

    PropertyTest_RO(system_staff, "FCSystemStaff", "RawTag")
    PropertyTest_RO(system_staff, "FCSystemStaff", "RawOtherCmper")
    PropertyTest_RO(system_staff, "FCSystemStaff", "RawOtherInci")
    PropertyTest_RO(system_staff, "FCSystemStaff", "RawDetailCmper1")
    PropertyTest_RO(system_staff, "FCSystemStaff", "RawDetailCmper2")
    PropertyTest_RO(system_staff, "FCSystemStaff", "RawDetailInci")
    PropertyTest_RO(system_staff, "FCSystemStaff", "RawEntryDetailEntryNumber")
    PropertyTest_RO(system_staff, "FCSystemStaff", "RawEntryDetailInci")

    local raw_target = finale.FCRawData()
    AssureTrue(raw_target:AssignTarget(system_staff), "FCRawData:AssignTarget(FCSystemStaff) for RawTag compare")
    AssureEqual(system_staff.RawTag, raw_target.Tag, "__FCBaseData.RawTag matches AssignTarget tag from FCSystemStaff")
    AssureEqual(system_staff.RawOtherCmper, system_staff.ItemCmper, "__FCBaseData.RawOtherCmper equals FCSystemStaff.ItemCmper")
    AssureEqual(system_staff.RawOtherInci, system_staff.ItemInci, "__FCBaseData.RawOtherInci equals FCSystemStaff.ItemInci")
    AssureEqual(system_staff.RawDetailCmper1, system_staff.ItemCmper, "__FCBaseData.RawDetailCmper1 equals FCSystemStaff.ItemCmper")
    AssureEqual(system_staff.RawDetailCmper2, system_staff.ItemInci, "__FCBaseData.RawDetailCmper2 equals FCSystemStaff.ItemInci")

    local packed_u32 = bit32.bor(bit32.band(system_staff.ItemCmper, 0xFFFF), bit32.lshift(bit32.band(system_staff.ItemInci, 0xFFFF), 16))
    AssureEqual(bit32.band(system_staff.RawEntryDetailEntryNumber, 0xFFFFFFFF), packed_u32, "__FCBaseData.RawEntryDetailEntryNumber packed from FCSystemStaff cmper/inci")
    AssureEqual(system_staff.RawDetailInci, system_staff.RawEntryDetailInci, "__FCBaseData detail/entry-detail inci shared storage")
end

-- Call:
local obj = finale.FCRawData()
FCRawData_ValueTests_Setters(obj)
FCRawData_ValueTests_DataTables(obj)
FCRawData_ValueTests_StaticValidation()
FCRawData_ValueTests_FourByteHelpers(obj)
FCRawData_ValueTests_AssignAndIO(obj)
FCBaseData_ValueTests_RawProperties()
