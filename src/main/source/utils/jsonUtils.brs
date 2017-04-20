'******************************************************
' Convert AA to JSON string
'******************************************************
function aAToJSON(aa as object) as string
    return aAToJSONHelper(aa, 0)
end function

function aAToJSONHelper(aa as object, indent as integer) as string
    result = ""
    if aa <> invalid then
        result = result + chr(10)
        for index = 1 to indent step 1
            result = result + chr(9)    ' tab
        end for

        result = result + "{"
        leadingComma = false
        for each e in aa
            if leadingComma then
                result = result + "," + chr(10)
                for index = 1 to indent step 1
                    result = result + chr(9)    ' tab
                end for
            else
                leadingComma = true
            end if

            REM - chr(34) = "
            result = result + chr(34) + e + chr(34) + ":"
            x = aa[e]
            if (x = invalid)
	        result = result + "null"
            else if (type(x) = "roAssociativeArray")
                result = result + AAToJSONHelper(x, indent + 1)
            else if (isint(x))
                result = result + itostr(x)
            else if (isfloat(x))
                result = result + Str(x).Trim()
            else if (isstr(x))
                result = result + chr(34) + x + chr(34)
            else if (type(x) = "roArray")
                result = result + "["
                leadingArrayComma = false
                for each item in x
                    if (leadingArrayComma)
                        result = result + "," + chr(10)
                        for index = 1 to indent step 1
                            result = result + chr(9)    ' tab
                        end for
                    else
                        leadingArrayComma = true
                    end if
                    result = result + AAToJSONHelper(item, indent + 1)
                end for
                result = result + "]"
            else if (type(x) = "roBoolean")
                if (x)
                    result = result + "true"
                else
                    result = result + "false"
                end if
            else
                result = result + "invalid type"
            end if
        next
        result = result + "}"
    end if
    return result
end function

function copyAA(source as object) as object
    dest = {}
    for each key in source
        dest.addReplace(key, source.lookup(key))
    next
    return dest
end function

'******************************************************
'Print an associativearray
'******************************************************
Sub PrintAnyAA(depth As Integer, aa as Object)
    for each e in aa
        x = aa[e]
        PrintAny(depth, e + ": ", aa[e])
    next
End Sub