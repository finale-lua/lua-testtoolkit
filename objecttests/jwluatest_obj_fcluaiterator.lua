local lfs = require("lfs")

function FCLuaIterator_ValueTests_Note2_1_271_2(note)
   BoolValuePropertyTest(note, "FCNote", "Accidental", false)
   BoolValuePropertyTest(note, "FCNote", "AccidentalFreeze", false)
   BoolValuePropertyTest(note, "FCNote", "AccidentalParentheses", false)
   BoolValuePropertyTest(note, "FCNote", "CrossStaff", false)
   NumberValuePropertyTest(note, "FCNote", "Displacement", 5)
   BoolValuePropertyTest_RO(note, "FCNote", "Downstem2nd", false)
   ObjectPropertyTest_RO(note, "FCNote", "Entry", "FCNoteEntry")
   BoolValuePropertyTest(note, "FCNote", "Legality", true)
   NumberValuePropertyTest(note, "FCNote", "NoteID", 2)
   NumberValuePropertyTest_RO(note, "FCNote", "NoteIndex", 1)
   BoolValuePropertyTest(note, "FCNote", "Playback", true)
   NumberValuePropertyTest(note, "FCNote", "RaiseLower", 0)
   BoolValuePropertyTest(note, "FCNote", "Spacing", true)
   BoolValuePropertyTest(note, "FCNote", "Tie", false)
   BoolValuePropertyTest(note, "FCNote", "TieBackwards", false)
   BoolValuePropertyTest_RO(note, "FCNote", "Upstem2nd", false)
   BoolValuePropertyTest(note, "FCNote", "UpstemSplit", false)
end


-- Call:
local region = finale.FCMusicRegion()
region.StartMeasure = 2
region.StartStaff = 1
region.StartMeasurePos = 0
region.EndMeasure = 2
region.EndStaff = 1
region.EndMeasurePos = 1535

local iterator = finale.FCLuaIterator()
if not AssureNonNil(iterator, "finale.FCLuaIterator is non nil") then return end

local got1 = false
local count = iterator:ForEachEntry(region, function(entry)
        for note in each(entry) do
            if note.NoteID == 2 then
                got1 = true
                FCLuaIterator_ValueTests_Note2_1_271_2(note)
            end
        end
        -- intentionally omit return value
    end)
AssureTrue(got1, "FCLuaIterator ForEachEntry note processed.") 
AssureEqual(count, 1, "FCLuaIterator processed 1 entry.")

got1 = false
count = iterator:ForEachNote(region, function(note)
        if note.NoteID == 2 then
            got1 = true
            FCLuaIterator_ValueTests_Note2_1_271_2(note)
        end
        -- intentionally omit return value
    end)
AssureTrue(got1, "FCLuaIterator ForEachNote note processed.") 
AssureEqual(count, 3, "FCLuaIterator processed 3 notes.")

local measures = finale.FCMeasures()
local meascount = measures:LoadAll()

got1 = false
count = iterator:ForEach(measures, function(measure)
        AssureEqual(measure:ClassName(), "FCMeasure", "FCLuaIterator ForEach sent in correct type.")
        got1 = true
        return true
    end)
AssureTrue(got1, "FCLuaIterator ForEach measure processed.") 
AssureEqual(count, meascount, "FCLuaIterator ForEach processed "..count.." measures.")

got1 = false
count = iterator:ForEachCell(region, function(measure, staff)
        AssureEqual(measure, 2, "FCLuaIterator ForEachCell sent in measure 2.")
        AssureEqual(staff, 1, "FCLuaIterator ForEachCell sent in measure 1.")
        got1 = true
        -- intentionally omit return value
    end)
AssureTrue(got1, "FCLuaIterator ForEachCell cell processed.") 
AssureEqual(count, 1, "FCLuaIterator ForEachCell processed 1 cell.")

got1 = false
currval = 10
count = iterator:ForEachInteger(10, 1, function(value)
        AssureEqual(value, currval, "FCLuaIterator ForEachInteger got expected value.")
        currval = currval - 1
        got1 = true
        return value > 7 -- test if we can abort the loop (7 gets processed but returns false, hence 4 values processed)
    end)
AssureTrue(got1, "FCLuaIterator ForEachInteger value processed.") 
AssureEqual(count, 4, "FCLuaIterator ForEachInteger processed "..count.." values.")

local source_file = GetRunningFolderPath() .. "/tools/scratch.musx"
local scratch_file = CopyFileToScratch(source_file)
local filename = finale.FCStrings()
filename:AddCopy(finale.FCString(scratch_file))
got1 = false
count = iterator:ForEachFileSaved(filename, function(doc, filename)
        if not AssureNonNil(doc, "Finale document not provided for FCLuaIterator.ForEachFileSaved") then
            return
        end
        local path = filename.LuaString
        local base = tostring(path):match("([^/\\]+)$")
        if not AssureEqual(base, "scratch.musx", "Expected scratch.musx, got: " .. tostring(base)) then
            return false
        end
        got1 = true
        return true
    end)
AssureTrue(got1, "FCLuaIterator ForEachFileSaved value processed.") 
AssureEqual(count, 1, "FCLuaIterator ForEachFileSaved processed "..count.." values.")

