function FCMiscDocPrefs_PropertyTests(miscdocprefs)    
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "AbbreviateCommonTimeSig")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "AbbreviateCutTimeSig")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "AdjustDotForMultiVoices")
   if Is27_4OrAbove() then
      BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "AlignMeasureNumbersWithBarline")
   end
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "AllowFloatingRests")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "AlwaysSlashGraceNote")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "AvoidSystemMarginCollisions")
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "BeamSlopeStyle", {finale.BEAMSLOPE_ENDNOTESONLY,            
            finale.BEAMSLOPE_FLATTENALL, finale.BEAMSLOPE_FLATTENSTANDARD, finale.BEAMSLOPE_FLATTENEXTREME})
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "BeamThreeEights")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "BeamedCommonTimeEights")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "ChordPlayback")
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "ClefResize", {30, 75, 100, 157})
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "CloseBarlineAtEnd")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "CloseBarlineAtSystem")
   if Is2014OrAbove() then
      BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "ConsolidateRestsAcrossLayers")
   end
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "CourtesyClefAtSystemEnd")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "CourtesyKeySigAtSystemEnd")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "CourtesyTimeSigAtSystemEnd")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "CrossStaffNotesInOriginal")
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "CurveResolution", {1, 67, 128})
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "DateFormat",  {finale.DATEFORMAT_SHORT, 
                finale.DATEFORMAT_LONG, finale.DATEFORMAT_MACLONG})
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "DefaultClefIndex", {0, 5, 14})
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "DisplayAllBarlines")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "DisplayPartExpressions")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "DisplayReverseStemming")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "ExtendBeamsOverRests")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "ExtendSecondaryBeamsOverRests")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "FinalBarlineAtEnd")
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "FretboardsResizeFraction", {129, 9999, 140000})
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "GraceNotePlaybackDuration", {2, 12, 129})
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "HalfStemsForBeamedRests")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "IncludeRestsInFour")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "ItalicizeCapoChords")
   if Is25_2OrAbove() then
      BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "KeepOctaveTransposition")
   end
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "KeySigCancelOutgoing")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "KeySigModeChange")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "KeySigNaturalsInC")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "KeySigOnlyFirstSystem")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "KeySigPreserveOctave")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "LeftBarlineDisplayMultipe")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "LeftBarlineDisplayMultiple")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "LeftBarlineDisplaySingle")
   if Is27_4OrAbove() then
      BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "LegacyDotPositionOnFlippedStems")
   end
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "MaxBeamSlope", {0, 16, 33})
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "NormalDefaultBarline")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "OnlyFirstSystemClef")
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "PageMarginScope", {finale.PAGEMARGINSCOPE_CURRENT,            
            finale.PAGEMARGINSCOPE_ALL, finale.PAGEMARGINSCOPE_LEFTORRIGHT, finale.PAGEMARGINSCOPE_RANGE})
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "PickupDuration", {0, 128, 2048})
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "PrimaryBeamWithinSpace")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "ScaleManualNotePositioning")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "SecondsInTimeStamp")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "ShowFretboards")
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "SpecialExtractionID", {3245, 36770, 65530})
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "TextTabCharacters", {0, 4, 9})
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "TimeSigCompositeDecimals", {0, 2, 3, 7})
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "UnderlineDepth", {0, 13, 101})
   NumberPropertyTest(miscdocprefs, "FCMiscDocPrefs", "UnderlineThickness", {0, 12, 100})
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "UseNoteShapes")
   BoolPropertyTest(miscdocprefs, "FCMiscDocPrefs", "UseStemConnections")
end


-- Call:
local miscdocprefs = finale.FCMiscDocPrefs()
AssureTrue(miscdocprefs:Load(1), "FCMiscDocPrefs:Load()")
FCMiscDocPrefs_PropertyTests(miscdocprefs)
