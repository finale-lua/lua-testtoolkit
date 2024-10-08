function FCMusicSpacingPrefs_ValueTests_ItemNo1(prefs)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "AccidentalsGutter", 0)
   BoolValuePropertyTest(prefs, "FCMusicSpacingPrefs", "AvoidArticulations", false)
   BoolValuePropertyTest(prefs, "FCMusicSpacingPrefs", "AvoidChords", false)
   BoolValuePropertyTest(prefs, "FCMusicSpacingPrefs", "AvoidClefs", true)
   BoolValuePropertyTest(prefs, "FCMusicSpacingPrefs", "AvoidHiddenNotes", true)
   BoolValuePropertyTest(prefs, "FCMusicSpacingPrefs", "AvoidLedgerLines", true)
   BoolValuePropertyTest(prefs, "FCMusicSpacingPrefs", "AvoidLyrics", true)
   BoolValuePropertyTest(prefs, "FCMusicSpacingPrefs", "AvoidNoteAndAccidentals", true)
   BoolValuePropertyTest(prefs, "FCMusicSpacingPrefs", "AvoidSeconds", true)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "GraceNoteMinDistance", 12)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "GraceNoteSpacingMode", finale.GRACESPMODE_AUTOMATIC)
   BoolValuePropertyTest(prefs, "FCMusicSpacingPrefs", "InterpolateAllotments", true)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "ManualPositioning", finale.MANUALPOS_IGNORE)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "MaxMeasureWidth", 1800)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "MinMeasureWidth", 0)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "MinimumDistanceWithTies", 48)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "MinimumItemDistance", 12)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "ScalingFactor", 1.6179)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "ScalingReferenceDuration", 1024)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "ScalingReferenceWidth", 84)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "ScalingValue", 16179)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "TiesGutter", 8)
   NumberValuePropertyTest(prefs, "FCMusicSpacingPrefs", "UnisonsMode", finale.UNISSPACE_DIFFERENTNOTEHEADS)
   BoolValuePropertyTest(prefs, "FCMusicSpacingPrefs", "UseAllotmentMode", false)
   BoolValuePropertyTest(prefs, "FCMusicSpacingPrefs", "UsePrinterMetrics", false, finenv.UI():IsOnMac())
end


-- Call:
local prefs = finale.FCMusicSpacingPrefs()
AssureTrue(prefs:Load(1), "FCMusicSpacingPrefs:Load(1)")
FCMusicSpacingPrefs_ValueTests_ItemNo1(prefs)
