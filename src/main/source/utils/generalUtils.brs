function log(level = "OFF" as String, text = "" as String) as Void
    logLevel = 5
    ' [OFF, FATAL, ERROR, WARN, INFO, DEBUG, TRACE]
    levels = {
        OFF: 0
        FATAL: 1
        ERROR: 2
        WARN: 3
        INFO: 4
        DEBUG: 5
        TRACE: 6
    }

    separators = {
        OFF: ""
        FATAL: "//////////////////////////////////////////////////////////////////////////////////////////////////////////"
        ERROR: "::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::"
        WARN: ".........................................................................................................."
        INFO: ""
        DEBUG: ""
        TRACE: ""
    }

    if levels[level] <> levels.OFF and levels[level] <= logLevel then
        if separators[level] <> "" then print separators[level]
        print "[" + level + "] - "; text
        if separators[level] <> "" then print separators[level]
    end if
end function

function getLargestValue(firstValue as integer, secondValue as integer) as integer 
    if firstValue > secondValue
        return firstValue
    else if secondValue > firstValue
        return secondValue
    else
       return firstValue 
    end if
end function

' raLog provides a consistent method for printing output to debugging consoles.
'   pararms
'       logLevel: is the string passed in that indicates the level of verbosity the log statement belongs to.
'       Acceptable values are: INFO, DEBUG, WARN, ERROR. Note that they are all uppercase.
'       These values are matched against a global logging level in order to specify which
'       statements should be output to the debugging console.
'       sender: is the string name of the current component or rbs file.
'       message: this is the statement to be printed to the debugging console
'   sample console output:
'        DEBUG   Utilities           Registry_GetEntry valid call
'        INFO    RegistryTask        retrievedValue = 12
'        DEBUG   Utilities           Registry_Commit valid call
function raLog(logLevel,sender, message)
    ' Note - nodes seem to be created asynchronously in m.global.
    ' This means there is a delay between creation of the global child node
    ' and our ability to call it.
    ' To avoid issues, the m.global value should be set in the root node,
    ' overrides should only be set in child nodes. For example, do not use this pattern
    ' in the root node:
    '' globalData = m.global.createChild("GlobalData")
    '' globalData.id = "globalData"
    '' globalData.logLevel = "ERROR"
    '' m.logLevel = "DEBUG"  <-- This line will not work for the first ?? number of raLog calls.
    'return Void
    globalLogLevel = "DEBUG"
'    if(m.global <> invalid)
'        if(IsValid(m.global.globals))
'           if(IsValid(m.global.globals.logLevel))
'               globalLogLevel = m.global.globals.logLevel
'           end if
'        end if
'    end if
    ' Set a default logLevelLimit (ERROR)
    logLevelLimit = "ERROR"
    ' Set limit to global logLevel value
    if(NOT globalLogLevel = "")
        logLevelLimit = globalLogLevel
    end if
    ' Allow logLevelLimit to be overridden by component-set logLevel
    if isValid(m.logLevel) AND isString(m.logLevel)
        logLevelLimit = m.logLevel
    end if
    ' Checks validity of loglevel, then converts them to intigers for comparison
    ' Finally it prints the output to the contextual debugging console.
    if isString(logLevel) AND convertLogLevel(logLevelLimit) <= convertLogLevel(logLevel)
        ? logLevel; tab(8) sender; tab(28) message
    end if
end function

'******************************************************
'Print an object as a string for debugging. If it is
'very long print the first 500 chars.
'******************************************************
Sub Dbg(pre As Dynamic, o=invalid As Dynamic)
    p = AnyToString(pre)
    if p = invalid p = ""
    if o = invalid o = ""
    s = AnyToString(o)
    if s = invalid s = "???: " + type(o)
    if Len(s) > 4000
        s = Left(s, 4000)
    endif
    print p + s
End Sub

function getVersionString() as String
    version_string = ""
    manifest = readasciifile("pkg:/manifest")
    manifest_list = strtokenize(readasciifile("pkg:/manifest"),chr(10))
    for each line in manifest_list
        if lcase(Left(line, 5)) = lcase("major")
            major_line = strtokenize(line,"=")
            major_version = major_line[1].toint()
        end if
        if lcase(Left(line,5)) = lcase("minor")
            minor_line = strtokenize(line,"=")
            minor_version = minor_line[1].toint()
        end if
    end for

    if major_version <> invalid and minor_version <> invalid
        version_string = "v" + major_version.tostr() + "." + minor_version.tostr()
    end if
    return version_string
end function

' Validates that an e-mail address is properly formatted, requiring at least the following: *@*.**
function validEmail(email as String) as Boolean
    reg = CreateObject("roRegex", ".+@.+\..+", "")
    return reg.isMatch(email)
end function

'Compare all kind of input
function equal(input1 as dynamic, input2 as dynamic) as boolean
    if Not valid(input1) and Not valid(input2) then
        return true
    else if Not valid(input1) or Not valid(input2) then
        return false
    else if isObject(input1) or isObject(input2) then
        return false
    else if isInteger(input1) and isInteger(input2) then
        return input1 = input2
    else if isString(input1) and isString(input2) then
        return input1 = input2
    else if isFloat(input1) and isFloat(input2) then
        return input1 = input2
    else if isDouble(input1) and isDouble(input2) then
        return input1 = input2
    end if
    return false
end function