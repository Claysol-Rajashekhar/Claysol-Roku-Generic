'******************************************************
'Get all XML subelements by name
'return list of 0 or more elements
'******************************************************
Function GetXMLElementsByName(xml As Object, name As String) As Object
    list = CreateObject("roArray", 100, true)
    if islist(xml.GetBody()) = false return list

    for each e in xml.GetBody()
        if e.GetName() = name then
            list.Push(e)
        endif
    next

    return list
End Function

'******************************************************
'Get all XML subelement's string bodies by name
'return list of 0 or more strings
'******************************************************
Function GetXMLElementBodiesByName(xml As Object, name As String) As Object
    list = CreateObject("roArray", 100, true)
    if islist(xml.GetBody()) = false return list
    for each e in xml.GetBody()
        if e.GetName() = name then
            b = e.GetBody()
            if type(b) = "roString" or type(b) = "String" list.Push(b)
        endif
    next
    return list
End Function

'******************************************************
'Get first XML subelement by name
'return invalid if not found, else the element
'******************************************************
Function GetFirstXMLElementByName(xml As Object, name As String) As dynamic
    if islist(xml.GetBody()) = false return invalid
    for each e in xml.GetBody()
        if e.GetName() = name return e
    next
    return invalid
End Function

'******************************************************
'Get first XML subelement's string body by name
'
'return invalid if not found, else the subelement's body string
'******************************************************
Function GetFirstXMLElementBodyStringByName(xml As Object, name As String) As dynamic
    e = GetFirstXMLElementByName(xml, name)
    if e = invalid return invalid
    if type(e.GetBody()) <> "roString" and type(e.GetBody()) <> "String" return invalid
    return e.GetBody()
End Function


'******************************************************
'Get the xml element as an integer
'return invalid if body not a string, else the integer as converted by strtoi
'******************************************************
Function GetXMLBodyAsInteger(xml As Object) As dynamic
    if type(xml.GetBody()) <> "roString" and type(xml.GetBody()) <> "String" return invalid
    return strtoi(xml.GetBody())
End Function


'******************************************************
'Parse a string into a roXMLElement
'return invalid on error, else the xml object
'******************************************************
Function ParseXML(str As String) As dynamic
    if str = invalid return invalid
    xml=CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
End Function

'return an empty AA if nothing found
'******************************************************
Sub GetXMLintoAA(xml As Object, aa As Object)
    for each e in xml.GetBody()
        body = e.GetBody()
        if type(body) = "roString" or type(body) = "String" then
            name = e.GetName()
            name = ODDstrReplace(name, ":", "_")
            aa.AddReplace(name, body)
        endif
    next
End Sub

'Determine if the given object supports the ifXMLElement interface
'******************************************************
function isxmlelement(obj as dynamic) as boolean
    return obj <> invalid and  GetInterface(obj, "ifXMLElement") <> invalid
end function

'Walk an XML tree and print it
'******************************************************
Sub PrintXML(element As Object, depth As Integer)
    print tab(depth*3);"Name: [" + element.GetName() + "]"
    if invalid <> element.GetAttributes() then
        print tab(depth*3);"Attributes: ";
        for each a in element.GetAttributes()
            print a;"=";left(element.GetAttributes()[a], 4000);
            if element.GetAttributes().IsNext() then print ", ";
        next
        print
    endif

    if element.GetBody()=invalid then
        ' print tab(depth*3);"No Body"
    else if type(element.GetBody())="roString" or type(element.GetBody())="String" then
        print tab(depth*3);"Contains string: [" + left(element.GetBody(), 4000) + "]"
    else
        print tab(depth*3);"Contains list:"
        for each e in element.GetBody()
            PrintXML(e, depth+1)
        next
    endif
    print
end sub

'  Decode html characters
'   @example
'   "&#003E;" -> ">" (greater than sign)
function decodeEscapedHTML(text as String) as String
    regex = createObject("roRegex", "&#[0-9]+;", "")
    while regex.match(text).count() > 0
        matches = regex.match(text)
        part = matches[0]
        partialRegex = createObject("roRegex", part, "")
        asciiNoAsString = mid(part, 3, len(part)-3)
        asciiNoAsInt = asciiNoAsString.toInt()
        text = partialRegex.replaceAll(text, chr(asciiNoAsInt))
    end while
    return text
end function