function FCLyricsBase_ValueTests_ItemNo1(obj)
    NumberValuePropertyTest_RO(obj, "FCVerseLyricsText", "BlockType", finale.RAWTEXTTYPE_VERSELYRIC)
    NumberValuePropertyTest_RO(obj, "FCVerseLyricsText", "ItemNo", 1)
    NumberValuePropertyTest_RO(obj, "FCVerseLyricsText", "NumChars", WinMac(80,78))
    if AssureNonNil(obj["NumChars"], "FCRawText_ValueTests_ItemNo1 NumChars exists.") then
        if AssureNonNil(obj["CreateString"], "FCRawText_ValueTests_ItemNo1 CreateString exists.") then
            local str = obj:CreateString()
            AssureEqual(obj.NumChars, str.Length, "FCLyricsBase raw text length equals created string length.")
        end
    end
end

-- Call:
local obj = finale.FCVerseLyricsText()
AssureTrue(obj:Load(1), "FCVerseLyricsText:Load(1)")
FCLyricsBase_ValueTests_ItemNo1(obj)

obj = finale.FCChorusLyricsText()
NumberValuePropertyTest_RO(obj, "FCChorusLyricsText", "BlockType", finale.RAWTEXTTYPE_CHORUSLYRIC)

obj = finale.FCSectionLyricsText()
NumberValuePropertyTest_RO(obj, "FCSectionLyricsText", "BlockType", finale.RAWTEXTTYPE_SECTIONLYRIC)
