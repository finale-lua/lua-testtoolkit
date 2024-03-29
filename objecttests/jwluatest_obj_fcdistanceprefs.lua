function FCDistancePrefs_ValueTests_ItemNo1(distanceprefs)
   BoolValuePropertyTest(distanceprefs, "FCDistancePrefs", "AccidentalCrossLayerPositioning", true)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "AccidentalMultiCharSpace", 4)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "AccidentalMultiSpace", 8, 12)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "AccidentalNoteSpace", 8, 12)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "AccidentalVertical", 6)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "AlternateBrevisDiamondVertical", -24)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "AlternateHalfDiamondVertical", -24)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "AlternateWholeDiamondVertical", -24)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "AugmentationDotNoteSpace", 8)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "AugmentationDotSpace", 8)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "AugmentationDotUpstemAdjust", 0)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "AugmentationDotVerticalAdjust", -2)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "BarlineDashSpace", 18)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "BarlineDoubleSpace", 768)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "BarlineFinalSpace", 768)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "BeamMaxDistance", 0)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "ClefChangeOffset", 8)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "ClefSpaceAfter", 0)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "ClefSpaceBefore", 24)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "GraceNoteSpacing", 24)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "KeySpaceAfter", 12)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "KeySpaceAfterCancel", 0)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "KeySpaceBefore", 24)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "KeySpaceBetweenAccidentals", 0)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "SecondaryBeamSpace", 18)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "SpaceAfter", 0)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "SpaceBefore", 32)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "StemVerticalNoteheadOffset", 256)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "TimeSigAbbreviatedVertical", 0)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "TimeSigBottomVertical", 0)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "TimeSigSpaceAfter", 12)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "TimeSigSpaceBefore", 24)
   NumberValuePropertyTest(distanceprefs, "FCDistancePrefs", "TimeSigTopVertical", 0)
end


-- Call:
local distanceprefs = finale.FCDistancePrefs()
AssureTrue(distanceprefs:Load(1), "FCDistancePrefs:Load(1)")
FCDistancePrefs_ValueTests_ItemNo1(distanceprefs)
