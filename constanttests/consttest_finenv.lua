function TestConstants_Finenv_()
    if AssureNonNil(finenv.MessageResultType, "finenv.MessageResultType") then
        NumberConstantTest(finenv.MessageResultType.SCRIPT_RESULT, "SCRIPT_RESULT", 0)
        NumberConstantTest(finenv.MessageResultType.DOCUMENT_REQUIRED, "DOCUMENT_REQUIRED", 1)
        NumberConstantTest(finenv.MessageResultType.SELECTION_REQUIRED, "SELECTION_REQUIRED", 2)
        NumberConstantTest(finenv.MessageResultType.SCORE_REQUIRED, "SCORE_REQUIRED", 3)
        NumberConstantTest(finenv.MessageResultType.FINALE_VERSION_MISMATCH, "FINALE_VERSION_MISMATCH", 4)
        NumberConstantTest(finenv.MessageResultType.LUA_PLUGIN_VERSION_MISMATCH, "LUA_PLUGIN_VERSION_MISMATCH", 5)
    end
end

-- Test the constants:
TestConstants_Finenv_()