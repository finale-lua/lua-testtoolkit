function FCSmartShapePrefs_PropertyTests(ssprefs)
   if Is26_2OrAbove() then
      NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "ArticulationAvoidSlursBy", {-12, 0, 14})
   end
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "CustomLineDefID", {1, 10, 500})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurAccidentalSpace", {0, 10, 300} )
   BoolPropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurAvoidAccidentals")
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurMaxAngle", {200, 1000, 5000})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurMaxLift", {54, 104, 1004})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurMaxStretchFixed", {53, 103, 1003})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurMaxStretchPercent", {52, 102, 1002} )
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurSpaceAround", {55, 105, 1005})
   BoolPropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurStretchByPercent")
   BoolPropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurStretchFirst")
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurSymmetryPercent", {56, 106, 1006})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "GlissandoDefID", {3, 13, 503})
   BoolPropertyTest(ssprefs, "FCSmartShapePrefs", "GuitarBendAutoGenerateText")
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "GuitarBendDefID", {2, 12, 502})
   BoolPropertyTest(ssprefs, "FCSmartShapePrefs", "GuitarBendHideNumber")
   BoolPropertyTest(ssprefs, "FCSmartShapePrefs", "GuitarBendParentheses")
   BoolPropertyTest(ssprefs, "FCSmartShapePrefs", "GuitarBendReplaceWithFull")
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "HairpinDefaultOpening", {60, 110, 1010})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "HairpinDefaultShortOpening", {24, 48, 1010})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "HairpinLineWidth", {61, 111, 1011})
   BoolPropertyTest(ssprefs, "FCSmartShapePrefs", "HairpinMakeHorizontal")
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "HookLength", {62, 112, 1012})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "HairpinMaxShortSpanLength", {62, 112, 1012})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "LineDashLength", {63, 113, 1013})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "LineDashSpace", {64, 114, 1014})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "LineWidth", {65, 115, 1015})
   BoolPropertyTest(ssprefs, "FCSmartShapePrefs", "OctavesAsText")
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "SlurBreakStaffLineAvoid", {66, 116, 1016})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "SlurBreakSystemEnd", {67, 117, 1017})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "SlurBreakSystemStart", {68, 118, 1018})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "SlurThicknessHorizontalLeft", {69, 119, 1019})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "SlurThicknessHorizontalRight", {70, 120, 1020})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "SlurThicknessVerticalLeft", {71, 121, 1021})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "SlurThicknessVerticalRight", {72, 122, 1022})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "SlurTipAvoidStaffAmount", {73, 123, 1023})
   BoolPropertyTest(ssprefs, "FCSmartShapePrefs", "SlurTipAvoidStaffUse")
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "SlurTipWidth", {74, 124, 1024})
   NumberPropertyTest(ssprefs, "FCSmartShapePrefs", "TabSlideDefID", {4, 14, 504})
   BoolPropertyTest(ssprefs, "FCSmartShapePrefs", "UseEngraverSlurs")
end


-- Call:
local ssprefs = finale.FCSmartShapePrefs()
AssureTrue(ssprefs:Load(1), "FCSmartShapePrefs:Load(1)")
FCSmartShapePrefs_PropertyTests(ssprefs)
