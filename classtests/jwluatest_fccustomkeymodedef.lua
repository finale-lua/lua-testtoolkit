function FCCustomKeyModeDef_PropertyTests(obj)
    TablePropertyTest(obj, "FCCustomKeyModeDef", "AccidentalAmounts", {{}, {-1, 2, 1, -10, 0, 0, 0},
            {4, 5, 4, 5, 4, 5, 4, [-7]=-4, [-6]=-5, [-5]=-4, [-4]=-5, [-3]=-4, [-2]=-5, [-1]=-4}})
    NumberPropertyTest(obj, "FCCustomKeyModeDef", "AccidentalFontID", {0, 1, 7, 11})
    TablePropertyTest(obj, "FCCustomKeyModeDef", "AccidentalOrder", {{}, {0, 2, 4, 0, 0, 0, 0}, {0, 5, 6, 1, 3, 2, 4},
            {1, 2, 3, 4, 5, 6, 0, [-7]=1, [-6]=2, [-5]=3, [-4]=4, [-3]=5, [-2]=6, [-1]=0}})
    NumberPropertyTest(obj, "FCCustomKeyModeDef", "BaseTonalCenter", {0, 1, 5, 6})
    TablePropertyTest(obj, "FCCustomKeyModeDef", "ClefAccidentalPlacements", {{}, {
                        {[-7]=0, [-6]=1, [-5]=0, [-4]=1, [-3]=0, [-2]=1, [-1]=0, [1]=1, [2]=1, [3]=1, [4]=1, [5]=0, [6]=1, [7]=0},
                        {[-7]=-1, [-6]=0, [-5]=-1, [-4]=0, [-3]=-1, [-2]=0, [-1]=-1, [1]=0, [2]=0, [3]=0, [4]=0, [5]=-1, [6]=0, [7]=-1},
                        {[-7]=-1, [-6]=0, [-5]=-1, [-4]=0, [-3]=-1, [-2]=0, [-1]=-1, [1]=-1, [2]=0, [3]=-1, [4]=0, [5]=-1, [6]=0, [7]=-1},
                        {[-7]=-2, [-6]=-1, [-5]=-2, [-4]=-1, [-3]=-2, [-2]=-1, [-1]=-2, [1]=-1, [2]=-1, [3]=-1, [4]=-1, [5]=-2, [6]=-1, [7]=-2},
                        {[-7]=0, [-6]=1, [-5]=0, [-4]=1, [-3]=0, [-2]=1, [-1]=0, [1]=1, [2]=1, [3]=1, [4]=1, [5]=0, [6]=1, [7]=0},
                        {[-7]=-1, [-6]=0, [-5]=-1, [-4]=0, [-3]=-1, [-2]=0, [-1]=-1, [1]=0, [2]=0, [3]=0, [4]=0, [5]=-1, [6]=0, [7]=-1},
                        {[-7]=-3, [-6]=-2, [-5]=-3, [-4]=-2, [-3]=-3, [-2]=-2, [-1]=-3, [1]=-2, [2]=-2, [3]=-2, [4]=-2, [5]=-3, [6]=-2, [7]=-3},
                        {[-7]=-1, [-6]=-1, [-5]=-1, [-4]=-1, [-3]=-1, [-2]=-1, [-1]=-1, [1]=-1, [2]=-1, [3]=-1, [4]=-1, [5]=-1, [6]=-1, [7]=-1},
                        {[-7]=0, [-6]=1, [-5]=0, [-4]=1, [-3]=0, [-2]=1, [-1]=0, [1]=1, [2]=1, [3]=1, [4]=1, [5]=0, [6]=1, [7]=0},
                        {[-7]=-1, [-6]=-1, [-5]=-1, [-4]=-1, [-3]=-1, [-2]=-1, [-1]=-1, [1]=-1, [2]=-1, [3]=-1, [4]=-1, [5]=-1, [6]=-1, [7]=-1},
                        {[-7]=0, [-6]=0, [-5]=0, [-4]=0, [-3]=0, [-2]=0, [-1]=0, [1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0},
                        {[-7]=0, [-6]=0, [-5]=0, [-4]=0, [-3]=0, [-2]=0, [-1]=0, [1]=0, [2]=0, [3]=0, [4]=0, [5]=0, [6]=0, [7]=0},
                        {[-7]=0, [-6]=1, [-5]=0, [-4]=1, [-3]=0, [-2]=1, [-1]=0, [1]=1, [2]=1, [3]=1, [4]=1, [5]=0, [6]=1, [7]=0},
                        {[-7]=1, [-6]=2, [-5]=1, [-4]=2, [-3]=1, [-2]=2, [-1]=1, [1]=2, [2]=2, [3]=2, [4]=2, [5]=1, [6]=2, [7]=1},
                        {[-7]=-1, [-6]=0, [-5]=-1, [-4]=0, [-3]=-1, [-2]=0, [-1]=-1, [1]=0, [2]=0, [3]=0, [4]=0, [5]=-1, [6]=0, [7]=-1},
                        {[-7]=0, [-6]=1, [-5]=0, [-4]=1, [-3]=0, [-2]=1, [-1]=0, [1]=1, [2]=1, [3]=1, [4]=1, [5]=0, [6]=1, [7]=0},
                        {[-7]=0, [-6]=1, [-5]=0, [-4]=1, [-3]=0, [-2]=1, [-1]=0, [1]=1, [2]=1, [3]=1, [4]=1, [5]=0, [6]=1, [7]=0},
                        {[-7]=0, [-6]=1, [-5]=0, [-4]=1, [-3]=0, [-2]=1, [-1]=0, [1]=1, [2]=1, [3]=1, [4]=1, [5]=0, [6]=1, [7]=0}}})
    TablePropertyTest(obj, "FCCustomKeyModeDef", "DiatonicStepsMap", {{}, {0, 2, 4, 5, 7, 9, 11}, {0, 5, 6, 7, 8, 10}, {0, 2, 4, 7, 9}})
    NumberPropertyTest(obj, "FCCustomKeyModeDef", "GoToKeyUnit", {1, 2, 4})
    NumberPropertyTest(obj, "FCCustomKeyModeDef", "HarmonicReference", {0, 1, 3, 7})
    BoolPropertyTest(obj, "FCCustomKeyModeDef", "HasClefAccidentalPlacements")
    NumberPropertyTest(obj, "FCCustomKeyModeDef", "MiddleKeyNumber", {48, 64, 125})
    NumberPropertyTest(obj, "FCCustomKeyModeDef", "SymbolListID", {0, 1, 3, 37})
    TablePropertyTest(obj, "FCCustomKeyModeDef", "TonalCenters", {{},
                {[0]=1, [1]=2, [2]=2, [3]=3, [4]=4, [5]=5, [6]=6, [7]=0},
                {[-1]=1, [-2]=2,[-3]=3, [-4]=4, [-5]=5, [-6]=6, [-7]=0},
                {[-1]=1, [-2]=2,[-3]=3, [-4]=4, [-5]=5, [-6]=6, [-7]=0, [0]=1, [1]=2, [2]=2, [3]=3, [4]=4, [5]=5, [6]=6, [7]=0}
            })
    NumberPropertyTest(obj, "FCCustomKeyModeDef", "TotalChromaticSteps", {0, 12, 31, 96, 192})
end


-- Call:
local obj = finale.FCCustomKeyModeDef()
AssureTrue(obj:Load(0x4000), "FCCustomKeyModeDef:Load(0x4000)") -- 0x4000 because has a non-zero tonal center
FCCustomKeyModeDef_PropertyTests(obj)

-- Call:
local obj = finale.FCCustomKeyModeDef()
AssureTrue(obj:Load(2), "FCCustomKeyModeDef:Load(2)") -- 2 because it is not 12-EDO
FCCustomKeyModeDef_PropertyTests(obj)
