function plugindef()
	--an explicit setting of LoadAsString overrides FCLuaScriptItem's ability
	--to change it
	finaleplugin.LoadAsString = false
end

print("This is a test.")
local str = finale.FCString()
str:SetRunningLuaFilePath()
local infile = io.open(str.LuaString, "rb")
if (infile~= nil) then
    io.input(infile)		
    datainput=io.read("*a")		
    local pos=string.find(datainput,string.char(0)..string.char(0)..string.char(0)..string.char(0))
    local length=string.len(datainput)
    datainput=string.sub(datainput,pos+4,length)
    infile:close()	  		  
end
return datainput
    ee