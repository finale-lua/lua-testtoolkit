function FCSmartShapePrefs_ValueTests_ItemNo1(ssprefs)
   if Is26_2OrAbove() then
      NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "ArticulationAvoidSlursBy", 11)
   end
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "CustomLineDefID", 8)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurAccidentalSpace", 3)
   BoolValuePropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurAvoidAccidentals", true)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurMaxAngle", 4500)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurMaxLift", 1536)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurMaxStretchFixed", 1536)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurMaxStretchPercent", 1500)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurSpaceAround", 18)
   BoolValuePropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurStretchByPercent", true)
   BoolValuePropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurStretchFirst", true)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "EngraverSlurSymmetryPercent", 8500)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "GlissandoDefID", 1)
   BoolValuePropertyTest(ssprefs, "FCSmartShapePrefs", "GuitarBendAutoGenerateText", true)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "GuitarBendDefID", 3)
   BoolValuePropertyTest(ssprefs, "FCSmartShapePrefs", "GuitarBendHideNumber", true)
   BoolValuePropertyTest(ssprefs, "FCSmartShapePrefs", "GuitarBendParentheses", true)
   BoolValuePropertyTest(ssprefs, "FCSmartShapePrefs", "GuitarBendReplaceWithFull", true)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "HairpinDefaultOpening", 36)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "HairpinDefaultShortOpening", 36)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "HairpinLineWidth", 224)
   BoolValuePropertyTest(ssprefs, "FCSmartShapePrefs", "HairpinMakeHorizontal", true)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "HairpinMaxShortSpanLength", 250)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "HookLength", 12)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "LineDashLength", 18)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "LineDashSpace", 18)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "LineWidth", 224)
   BoolValuePropertyTest(ssprefs, "FCSmartShapePrefs", "OctavesAsText", false)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "SlurBreakSystemEnd", 0)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "SlurBreakSystemStart", -8)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "SlurBreakStaffLineAvoid", 8)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "SlurThicknessHorizontalLeft", 0)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "SlurThicknessHorizontalRight", 0)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "SlurThicknessVerticalLeft", 6)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "SlurThicknessVerticalRight", 6)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "SlurTipAvoidStaffAmount", 8)
   BoolValuePropertyTest(ssprefs, "FCSmartShapePrefs", "SlurTipAvoidStaffUse", true)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "SlurTipWidth", 0)
   NumberValuePropertyTest(ssprefs, "FCSmartShapePrefs", "TabSlideDefID", 2)
   BoolValuePropertyTest(ssprefs, "FCSmartShapePrefs", "UseEngraverSlurs", true)
end


-- Call:
local ssprefs = finale.FCSmartShapePrefs()
AssureTrue(ssprefs:Load(1), "FCSmartShapePrefs:Load(1)")
FCSmartShapePrefs_ValueTests_ItemNo1(ssprefs)
