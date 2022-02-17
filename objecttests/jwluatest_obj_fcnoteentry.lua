function FCNoteEntry_ValueTests_Cell5_3(entry)
   NumberValuePropertyTest(entry, "FCNoteEntry", "ActualDuration", 1024)
   BoolValuePropertyTest(entry, "FCNoteEntry", "ArticulationFlag", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "BeamBeat", true)
   BoolValuePropertyTest(entry, "FCNoteEntry", "CheckAccidentals", false, true) -- true: read-only
   NumberValuePropertyTest(entry, "FCNoteEntry", "ClefIndex", 3)
   BoolValuePropertyTest(entry, "FCNoteEntry", "CombineRests", true)
   BoolValuePropertyTest(entry, "FCNoteEntry", "CrossStaff", false)
   NumberValuePropertyTest(entry, "FCNoteEntry", "Duration", 1024)
   NumberValuePropertyTest_RO(entry, "FCNoteEntry", "EntryNumber", 135)
   BoolValuePropertyTest(entry, "FCNoteEntry", "FlatBeam", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "FlipTie", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "FloatingRest", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "FreezeBeam", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "FreezeStem", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "GraceNote", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "GraceNoteSlash", false)
   NumberValuePropertyTest_RO(entry, "FCNoteEntry", "LayerNumber", 1)
   BoolValuePropertyTest(entry, "FCNoteEntry", "LedgerLines", true)
   BoolValuePropertyTest(entry, "FCNoteEntry", "Legality", true)
   BoolValuePropertyTest(entry, "FCNoteEntry", "LyricFlag", false)
   NumberValuePropertyTest(entry, "FCNoteEntry", "ManualPosition", 0)
   NumberValuePropertyTest_RO(entry, "FCNoteEntry", "Measure", 5)
   NumberValuePropertyTest(entry, "FCNoteEntry", "MeasurePos", 0)
   BoolValuePropertyTest(entry, "FCNoteEntry", "NoteDetailFlag", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "PerformanceDataFlag", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "Playback", true)
   BoolValuePropertyTest(entry, "FCNoteEntry", "SecondaryBeamFlag", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "SmartShapeFlag", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "Spacing", true)
   BoolValuePropertyTest(entry, "FCNoteEntry", "SpecialAltsFlag", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "SplitRest", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "SplitStem", false)
   NumberValuePropertyTest_RO(entry, "FCNoteEntry", "Staff", 3)
   BoolValuePropertyTest(entry, "FCNoteEntry", "StemDetailFlag", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "StemUp", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "TupletStartFlag", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "Visible", true)
   BoolValuePropertyTest(entry, "FCNoteEntry", "Voice2", false)
   BoolValuePropertyTest(entry, "FCNoteEntry", "Voice2Launch", false)
end

-- Call:
local region = finale.FCMusicRegion()
region.StartMeasure = 5
region.StartStaff = 3
region.StartMeasurePos = 0
region.EndMeasure = 5
region.EndStaff = 3
region.EndMeasurePos = 1023
local got1 = false
for entry in eachentry(region) do
    FCNoteEntry_ValueTests_Cell5_3(entry)
    got1 = true
    break
end
AssureTrue(got1, "FCNoteEntry at (5, 3, 0) not found.")
