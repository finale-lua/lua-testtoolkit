function plugindef()
   -- This function and the 'finaleplugin' namespace
   -- are both reserved for the plug-in definition.
   finaleplugin.NoStore = true
   finaleplugin.Author = "Jari Williamsson"
   finaleplugin.CategoryTags = "Debug, Development, Diagnose, UI"
   return "Create Object Test", "Create Object Test", "Create a test for the properties found for a object."
end

if not finenv.ConsoleIsAvailable then
    require('mobdebug').start()
end

local TestOutput = ""
local TestOutputCount = 0


function FindInTable(t, keyname)
    for k, v in pairs(t) do
        if k == keyname then return true end
    end    
    return false
end

function CreateTableValue(t)
    local retval = "{"
    local function vtostr(v)
        if type(v) == "string" then
            return '"' .. v .. '"'
        elseif type(v) == "table" then
            return CreateTableValue(v)
        end
        return tostring(v)
    end    
    for k, v in pairsbykeys(t) do
        if #retval > 1 then
            retval = retval .. ", "
        end
        retval = retval .. "[" .. vtostr(k) .. "]=" .. vtostr(v)
    end
    retval = retval .. "}"
    return retval
end

function AddToTestOutput(ClassNameToFind, PassedArgument, propertyname, readonly, obj)
    local value = obj[propertyname]
    if value == nil then
        TestOutput = TestOutput .. "   AssureNil(" ..  PassedArgument .. "." .. propertyname .. ")\n"
        return
    end
    local prefix = "Number"
    if type(value) == "boolean" then
        prefix = "Bool"
        if value == true then
            value = "true"
        else
            value = "false"
        end
    elseif type(value) == "string" then
        prefix = "String"
        value = '"' .. value .. '"'
    elseif type(value) == "table" then
        prefix = "Table"
        value = CreateTableValue(value)
    elseif type(value) == "userdata" then
        TestOutput = TestOutput .. "   ObjectPropertyTest_RO("  .. PassedArgument .. ', "' .. ClassNameToFind .. '", "' .. propertyname .. '", "' .. value:ClassName() .. '")\n' 
        TestOutputCount = TestOutputCount + 1
        return
    end
    if readonly then        
        TestOutput = TestOutput .. "   " .. prefix .. "ValuePropertyTest_RO("  .. PassedArgument .. ', "' .. ClassNameToFind .. '", "' .. propertyname .. '", ' .. value .. ')\n' 
    else
        TestOutput = TestOutput .. "   " .. prefix .. "ValuePropertyTest("  .. PassedArgument .. ', "' .. ClassNameToFind .. '", "' .. propertyname .. '", ' .. value .. ')\n' 
    end
    TestOutputCount = TestOutputCount + 1
end

function DumpClassTable(t, ClassNameToFind, PassedArgument, obj, IncludeParents)
    if not t.__propget then return false end
    if not t.__propset then return false end
    for k, v in pairsbykeys(t.__propget) do
        local readonly = not FindInTable(t.__propset, k)
        AddToTestOutput(ClassNameToFind, PassedArgument, k, readonly, obj)
    end
    if IncludeParents and finenv.IsRGPLua and t.__parent then
        for k, _ in pairs(t.__parent) do
            DumpClassTable(finale[k], ClassNameToFind, PassedArgument, obj, IncludeParents)
        end
    end
    return true
end


function CreateCode(obj, ClassNameToFind, PassedArgument, continuing, id1, id2, IncludeParents) -- id1 and id2 may be omitted
    local processed = false
    
    local funcsuffix = ""
    local loadinfo = ""
    if id1 then
        if type(id1) ~= "string" then
            id1 = tostring(id1):gsub("-", "n")
        end
        if id2 and type(id2) ~= "string" then
            id2 = tostring(id2):gsub("-", "n")
        end
        funcsuffix = "_ItemNo" .. id1
        if id2 then
            funcsuffix  = funcsuffix .. "_" .. id2
        end
        loadinfo = id1 -- (won't be used in the final script)
    elseif obj.ItemNo then 
        funcsuffix = "_ItemNo" .. obj.ItemNo
        loadinfo = obj.ItemNo
    elseif obj.ItemCmper then
        funcsuffix = "_ItemNo" .. obj.ItemCmper .. "_" .. obj.ItemInci
        loadinfo = "" .. obj.ItemCmper  .. ", " .. obj.ItemInci
    elseif obj.Measure and obj.Staff then
        funcsuffix = "_Cell" .. obj.Measure .. "_" .. obj.Staff
        loadinfo = "" .. obj.Measure  .. ", " .. obj.Staff
    elseif obj.ItemEntryNumber then
        -- Note entry
        funcsuffix = "_Entry" .. obj:GetNoteEntry().Measure .. "_" .. obj:GetNoteEntry().Staff .. "_" .. obj.ItemEntryNumber
        loadinfo = "" .. obj:GetNoteEntry().Measure  .. ", " .. obj:GetNoteEntry().Staff .. ", " .. obj.ItemEntryNumber
    elseif obj.NoteID then
        -- Note
        funcsuffix = "_Note" .. obj:GetEntry().Measure .. "_" .. obj:GetEntry().Staff .. "_" .. obj:GetEntry().EntryNumber .. "_" .. obj.NoteID
        loadinfo = "" .. obj:GetEntry().Measure  .. ", " .. obj:GetEntry().Staff .. ", " .. obj:GetEntry().EntryNumber .. ", " .. obj.NoteID
    else
        print ("Need fix: Couldn't locate item locators (cmpers/incis/etc)")
        return
    end

    -- Create the function skeleton
    TestOutput = TestOutput .. "function " .. ClassNameToFind .. "_ValueTests" .. funcsuffix .. "(" .. PassedArgument .. ")\n"
    for k,v in pairs(_G.finale) do
        if k == ClassNameToFind then
            if not finenv.IsRGPLua then
                if v.__class then
                    -- JW Lua crashes on IncludeParents unless we enhance it mightily
                    if DumpClassTable(v.__class, ClassNameToFind, PassedArgument, obj) then processed = true end
                end
            else
                if DumpClassTable(v, ClassNameToFind, PassedArgument, obj, IncludeParents) then processed = true end
            end
        end
    end
    -- Create the function call
    if processed then
        if TestOutputCount > 0 then
            TestOutput = TestOutput .. "end\n\n\n"
            if not continuing then
                TestOutput = TestOutput .. "-- Call:\nlocal " .. PassedArgument .. " = finale." .. 
                        ClassNameToFind .. "()\nAssureTrue(" .. 
                        PassedArgument .. ":Load(" .. loadinfo .. "), \"" .. ClassNameToFind .. ":Load(" ..
                        loadinfo .. ")\")\n" .. 
                        ClassNameToFind .. "_ValueTests" .. funcsuffix .. "(" .. 
                        PassedArgument .. ")\n"
                if finenv.UI():TextToClipboard(TestOutput) then
                    --print (TestOutput)
                    finenv.UI():AlertInfo("Code has been copied to the clipboard.", "Test Created")
                end
            end
        else
            print("No properties found for class", ClassNameToFind)
        end
    else
        print("Error: No ", ClassNameToFind, "class found.")
    end
end

function ProcessObject(obj, passedname, continuing, id1, id2) -- continuing, id1, and id2 may be omitted
    CreateCode(obj, obj:ClassName(), passedname, continuing, id1, id2, false)
end

function ProcessObjectWithParents(obj, passedname, continuing, id1, id2) -- continuing, id1, and id2 may be omitted
    CreateCode(obj, obj:ClassName(), passedname, continuing, id1, id2, true)
end

-- Tries to find a specific note entry in the file
function LoadMeasureEntry(measureno, staffno, entryid)
    local notecell = finale.FCNoteEntryCell(measureno, staffno)
    notecell:Load()
    for e in each (notecell) do
        local entnum = e.entnum
        if e.EntryNumber == entryid then return e end
    end
    return nil
end


-- The actual code to process an object (modify as needed):

--[[
if finenv.IsRGPLua and not finenv.ConsoleIsAvailable then -- if new lua
    require('mobdebug').start()
end
]]

local staff = finale.FCStaffStyleDef()
staff:Load(30)
ProcessObjectWithParents(staff, "ssd")

--[[
local prefs = finale.FCMusicSpacingPrefs()
prefs:Load(1)
ProcessObject(prefs, "prefs")
]]

--[[
local obj = finale.FCStaffStyleDef()
obj:SetName(finale.FCString("Position Adjust Creator"))
obj:SaveNew()
local fn = obj:GetFullNamePosition()
local an = obj:GetAbbreviatedNamePosition()
obj:Save()
ProcessObject(an, "ssd_abbr")
]]

--[[
local group_item = finale.FCFretboardGroupItem()
group_item:Load(65534, 0, 11)
ProcessObject(group_item.FretBarreItems:GetItemAt(0), "obj", false, "65534_0_11_0")
]]

--[[
local font = finale.FCFontInfo("Times New Roman", 17, 32 + 3 + 64)
ProcessObject(font, "obj", false, "TimesNewRoman_17_efx")
]]

--[[
local obj = finale.FCFretboardStyleDef()
obj:Load(4)
ProcessObject(obj, "obj")
]]

--[[
local obj = finale.FCVerseLyricsText()
obj:Load(1)
CreateCode(obj, "FCRawText", "obj")
]]

--[[
local entry = LoadMeasureEntry(31, 2, 319)
local obj = finale.FCVerseSyllable()
obj:SetNoteEntry(entry)
obj:LoadFirst()
--ProcessObject(obj, "obj")
 CreateCode(obj, "FCSyllableBase", "obj")
]]

--[[
local prefs = finale.FCPlaybackPrefs()
prefs:LoadFirst()
--ProcessObject(prefs, "pref")

ProcessObject(prefs.ClickInfoForMidiNotesOnDownBeats, "obj", true, 1)
ProcessObject(prefs.ClickInfoForMidiNotesOnOtherBeats, "obj", true, 2)
ProcessObject(prefs.ClickInfoForMidiDataOnDownBeats, "obj", true, 3)
ProcessObject(prefs.ClickInfoForMidiDataOnOtherBeats, "obj", false, 4)
]]

--[[
local bookmarks = finale.FCBookmarks()
bookmarks:LoadAll()
for i = 0, bookmarks.Count-1 do
    local bookmark = bookmarks:GetItemAt(i)
    ProcessObject(bookmark, "bookmark", i < bookmarks.Count - 1)
end
]]

--[[
local entry = LoadMeasureEntry(30, 3, 312)
local obj = finale.FCSyllableEntryMod()
obj:SetNoteEntry(entry)
obj:LoadFirst()
ProcessObject(obj, "obj")
]]

--[[
local coll = finale.FCChords()
coll:LoadAllInCell(finale.FCCell(46,1))
for i = 0, coll.Count-1 do
    local chord = coll:GetItemAt(i)
    ProcessObject(chord, "chord", i < coll.Count - 1)
end
]]

--[[
local noteheadmod = finale.FCNoteheadMod()
local entry = LoadMeasureEntry(6, 2, 130)
    noteheadmod:SetNoteEntry(entry)
    local note = entry:GetItemAt(0)
    noteheadmod:LoadAt(note)
ProcessObject(noteheadmod, "noteheadmod")
]]

--[[
for entry in eachentry(finenv.Region()) do
    for note in each(entry) do
        if note.NoteID > 1 then
            ProcessObject(note, "note")
            break
        end
    end
end
]]

--[[
local elts = finale.FCBeatChartElements()
elts:LoadAllForItem(16)
ProcessObject(elts:GetItemAt(0), "header", true)
ProcessObject(elts:GetItemAt(7), "element", true)
ProcessObject(elts:GetItemAt(13), "element", false)
]]

--[[
local meas = finale.FCMeasure()
meas:Load(1)
ProcessObject(meas.TimeSignature, "time_sig", true, 1)
ProcessObject(meas.TimeSignatureForDisplay, "time_sig_disp", true, 2)
ProcessObject(meas.KeySignature, "key_sig", false, 3)
]]

--[[
local smartshape_prefs = finale.FCSmartShapePrefs()
smartshape_prefs:Load(1)
for _, style_type in pairs({finale.SSENTCNCTSTYLETYPE_SLURS, finale.SSENTCNCTSTYLETYPE_TAB_SLIDES, finale.SSENTCNCTSTYLETYPE_GLISSANDOS, finale.SSENTCNCTSTYLETYPE_BEND_CURVES}) do
    for index = 0, smartshape_prefs:GetEntryConnectStyleCount(style_type) - 1 do
        local prefs = smartshape_prefs:CreateEntryConnectStyle(style_type, index)
        ProcessObject(prefs, "prefs", true, style_type, index)
    end
end

if finenv.UI():TextToClipboard(TestOutput) then
    --print (TestOutput)
    finenv.UI():AlertInfo("Code has been copied to the clipboard.", "Test Created")
end
]]

--[[
function FCSeparatePlacement_Process(rpt, measure)
    rpt:Load(measure, 0)
    for _, separates in pairs({rpt:CreateSeparatePlacements(), rpt.CreateTextSeparatePlacements and rpt:CreateTextSeparatePlacements()}) do
        for sep in each(separates) do
            ProcessObject(sep, "sep", true, measure, sep.Mode)
        end
    end
end

FCSeparatePlacement_Process(finale.FCTextRepeat(), 3)
FCSeparatePlacement_Process(finale.FCEndingRepeat(), 6)
FCSeparatePlacement_Process(finale.FCBackwardRepeat(), 8)

if finenv.UI():TextToClipboard(TestOutput) then
    --print (TestOutput)
    finenv.UI():AlertInfo("Code has been copied to the clipboard.", "Test Created")
end
]]
