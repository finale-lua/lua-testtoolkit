local function AssureISODate(value, caption)
    if not AssureType(value, "string", caption .. " type") then
        return
    end
    AssureTrue(string.match(value, "^%d%d%d%d%-%d%d%-%d%d$") ~= nil, caption .. " ISO-8601 format")
end

local function FCDocument_PropertyTests(doc)
    NumberPropertyTest_RO(doc, "FCDocument", "ID")
    PropertyTest_RO(doc, "FCDocument", "CreatedDate")
    PropertyTest_RO(doc, "FCDocument", "ModifiedDate")
    NumberPropertyTest_RO(doc, "FCDocument", "CreatedVersion")
    NumberPropertyTest_RO(doc, "FCDocument", "ModifiedVersion")

    AssureISODate(doc.CreatedDate, "FCDocument.CreatedDate")
    AssureISODate(doc.ModifiedDate, "FCDocument.ModifiedDate")
    AssureEqual(doc.CreatedDate, "2014-08-05", "FCDocument.CreatedDate expected value")
    AssureEqual(doc.ModifiedDate, "2024-04-15", "FCDocument.ModifiedDate expected value")
    AssureEqual(doc.CreatedVersion, 0x10020401, "FCDocument.CreatedVersion expected value")
    AssureEqual(doc.ModifiedVersion, 0x1B400000, "FCDocument.ModifiedVersion expected value")
end

-- Call:
local doc = finale.FCDocument()
AssureTrue(doc:IsCurrent(), "FCDocument class test expects current document.")
FCDocument_PropertyTests(doc)
