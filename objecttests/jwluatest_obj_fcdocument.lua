local function AssureISODate(value, caption)
    if not AssureType(value, "string", caption .. " type") then
        return
    end
    AssureTrue(string.match(value, "^%d%d%d%d%-%d%d%-%d%d$") ~= nil, caption .. " ISO-8601 format")
end

local function FCDocument_ValueTests_Current(doc)
    local created_date = doc.CreatedDate
    local modified_date = doc.ModifiedDate
    local created_version = doc.CreatedVersion
    local modified_version = doc.ModifiedVersion

    AssureISODate(created_date, "FCDocument.CreatedDate")
    AssureISODate(modified_date, "FCDocument.ModifiedDate")
    AssureEqual(created_date, "2014-08-05", "FCDocument.CreatedDate expected value")
    AssureEqual(modified_date, "2024-04-15", "FCDocument.ModifiedDate expected value")
    AssureEqual(created_version, 0x10020401, "FCDocument.CreatedVersion expected value")
    AssureEqual(modified_version, 0x1B400000, "FCDocument.ModifiedVersion expected value")

    local same_doc = finale.FCDocument(doc.ID)
    AssureTrue(same_doc:IsCurrent(), "FCDocument(current ID) is current")
    AssureEqual(same_doc.CreatedDate, created_date, "FCDocument.CreatedDate stable for current ID")
    AssureEqual(same_doc.ModifiedDate, modified_date, "FCDocument.ModifiedDate stable for current ID")
    AssureEqual(same_doc.CreatedVersion, created_version, "FCDocument.CreatedVersion stable for current ID")
    AssureEqual(same_doc.ModifiedVersion, modified_version, "FCDocument.ModifiedVersion stable for current ID")
end

local function FCDocument_ValueTests_NonCurrent(doc)
    local other_doc = finale.FCDocument(doc.ID + 1000)
    AssureFalse(other_doc:IsCurrent(), "FCDocument(non-current ID) is not current")
    AssureEqual(other_doc.CreatedDate, "", "FCDocument.CreatedDate is empty for non-current document")
    AssureEqual(other_doc.ModifiedDate, "", "FCDocument.ModifiedDate is empty for non-current document")
    AssureEqual(other_doc.CreatedVersion, 0, "FCDocument.CreatedVersion is zero for non-current document")
    AssureEqual(other_doc.ModifiedVersion, 0, "FCDocument.ModifiedVersion is zero for non-current document")
end

-- Call:
local doc = finale.FCDocument()
AssureTrue(doc:IsCurrent(), "FCDocument object test expects current document.")
FCDocument_ValueTests_Current(doc)
FCDocument_ValueTests_NonCurrent(doc)
