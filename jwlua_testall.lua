function plugindef()   -- This function and the 'finaleplugin' namespace   -- are both reserved for the plug-in definition.   finaleplugin.NoStore = true   return "JW Lua - All Tests", "All Tests", "Run all the JW Lua tests. Requires the debug file template."end

if finenv.MinorVersion > 54 then -- if new lua
    require('mobdebug').start()
end

-- Load the toolkit  functions needed for the tests.
-- Make sure to run jwlua_filetests first, to assure that the file contents is intact.
require("jwlua_filetests")
require("jwlua_consttests")
require("jwlua_classtests")

finenv.StartNewUndoBlock("No updates", false) -- guarantee no updates, since pilot-project RGP Lua has not yet implemented finaleplugin namespace

-- No need to output the result, since that's already been done

