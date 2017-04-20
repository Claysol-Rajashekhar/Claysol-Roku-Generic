'Convert int to string. This is necessary because
'the builtin Stri(x) prepends whitespace
'******************************************************
Function itostr(i As Integer) As String
    str = Stri(i)
    return strTrim(str)
End Function

' Checks if an item is a associative array
function isObject(item) as Boolean
    return type(item) = "Object" or type(item) = "roAssociativeArray"
end function

' Checks if an item is a string
function isString(item) as Boolean
    return type(item) = "String" or type(item) = "roString"
end function

'******************************************************
'Trim a string
'******************************************************
function strTrim(str As String) As String
    st=createObject("roString")
    st.SetString(str)
    return st.Trim()
end function

'******************************************************
'isnonemptystr
'Determine if the given object supports the ifString interface
'and returns a string of non zero length
'******************************************************
Function isnonemptystr(obj)
    if isnullorempty(obj) return false
    return true
End Function

'******************************************************
'isnullorempty
'Determine if the given object is invalid or supports
'the ifString interface and returns a string of non zero length
'******************************************************
Function isnullorempty(obj)
    if obj = invalid return true
    if not isstr(obj) return true
    if Len(obj) = 0 return true
    return false
End Function

function isLowerCase(asciiValue as Integer) as Boolean
    if asciiValue > 96 and asciiValue < 123 then
        return true
    end if 
        return false 
end function

function isUpperCase(asciiValue as Integer) as Boolean
    if asciiValue > 64 and asciiValue < 91 then
        return true
    end if
    return false
end function

function isNumbers(asciiValue as Integer) as Boolean  
     if asciiValue > 47 and asciiValue < 58 then
        return true
    end if
    return false
end function

'******************************************************
'islist
'
'Determine if the given object supports the ifList interface
'******************************************************
function islist(obj as dynamic) as boolean
    return obj <> invalid and GetInterface(obj, "ifArray") <> invalid
end function

'isfunc
'
'Determine if the given object supports the function interface
'******************************************************
function isfunc(obj as dynamic) as boolean
    tf = type(obj)
    return tf = "function" or tf = "rofunction"
end function

'******************************************************
' validint
'
' Always return a valid integer. If the argument is 
' invalid or not an integer, return zero.
'******************************************************
function validInt(obj As dynamic) as integer
    if obj <> invalid and GetInterface(obj, "ifInt") <> invalid
        return obj
    else
        return 0
    end if
end function

'******************************************************
'Validate parameter is the correct type
'******************************************************
function validateParam(param As object, paramType As string, functionName as string, allowInvalid = false) as boolean
    if paramType = "roString" or paramType = "String" then
        if type(param) = "roString" or type(param) = "String" then
            return true
        end if
    else if type(param) = paramType then
        return true
    endif

    if allowInvalid = true then
        if type(param) = invalid then
            return true
        endif
    endif
    print "invalid parameter of type "; type(param); " for "; paramType; " in function "; functionName 
    return false
end function

' Check if an item is assigned a value
function valid(item) as boolean
    return type(item) <> "Invalid" and type(item) <> "roInvalid" and type(item) <> "<uninitialized>"
end function