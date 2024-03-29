function FCTiePrefs_ValueTests_ItemNo1(prefs)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "AfterMultipleDots", true)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "AfterSingleDot", true)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "AvoidStaffLines", true)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "AvoidStaffLinesDistance", 8, 12)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "AvoidStaffLinesOnly", true)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "BeforeSingleAccidental", true)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "BreakForKeySigs", true)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "BreakForTimeSigs", true)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "ChordDirectionOpposingSeconds", true)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "ChordDirectionType", finale.TIECHORDDIR_STEMREVERSAL, finale.TIECHORDDIR_SPLITEVENLY)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "ExtraSystemStartSpace", -8, -12)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "FixedInsetStyle", false)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "KeySigLeftHorizontalOffset", 12, 24)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "KeySigRightHorizontalOffset", 12, 24)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "MixedStemDirectionType", finale.TIEMIXEDSTEM_OVER, finale.TIEMIXEDSTEM_OPPOSITEFIRSTSTEM)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "SecondsPlacement", finale.TIESECONDS_SHIFTBOTH, finale.TIESECONDS_SHIFTSTART)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "SystemLeftHorizontalOffset", -8, 4)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "SystemRightHorizontalOffset", 0, -4)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "ThicknessLeft", 6, 12)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "ThicknessRight", 6, 12)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "TimeSigLeftHorizontalOffset", 12, 24)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "TimeSigRightHorizontalOffset", 12, 24)
   NumberValuePropertyTest(prefs, "FCTiePrefs", "TipWidth", 10000, 14000)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "UseInterpolation", true)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "UseOuterPlacement", true)
   BoolValuePropertyTest(prefs, "FCTiePrefs", "UseTieEndStyle", false)
end

-- Call:
local prefs = finale.FCTiePrefs()
AssureTrue(prefs:Load(1))
FCTiePrefs_ValueTests_ItemNo1(prefs)
