Function AnyToString(any As Dynamic) As dynamic
    if any = Invalid then
        return "Invalid"
    end if
    if isstr(any) then
        return any
    end if
    if isint(any) then
        return itostr(any)
    end if
    if isbool(any) then
        if any = true return "true"
        return "false"
    end if
    if isfloat(any) then
        return Str(any)
    end if
    if type(any) = "roTimespan" 
        return itostr(any.TotalMilliseconds()) + "ms"
    end if
    return Invalid
End Function

Function isstr(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifString") = invalid return false
    return true
End Function

'******************************************************
'Trim a string
'******************************************************
Function strTrim(str As String) As String
    st = CreateObject("roString")
    st.SetString(str)
    return st.Trim()
End Function

Function strTokenize(str As String, delim As String) As Object
    st = CreateObject("roString")
    st.SetString(str)
    return st.Tokenize(delim)
End Function


function splitTextToLine(text as String, font as Object, width = 200 as Integer, limit = 0 as Integer, token = "\\n") as Object
    if text = "" then
        return [text]
    end if
    reg = CreateObject("roRegex", token, "")
    paragraphs = reg.split(text)
    lines = []

    for i = 0 to paragraphs.count() - 1
        if limit = 0 OR lines.count() < limit Then
            words = paragraphs[i].tokenize(" ")

            if words.count() > 0 then
                line = words[0].getString()
                for j = 1 to words.Count() - 1
                    current = line + " " + words[j].getString()
                    if font.getOneLineWidth(current, width) < width and (lines.Count() < limit or limit = 0) Then
                        line = current
                    else if limit = 0 or lines.count() < limit then
                        lines.push(line)
                        line = words[j].getString()
                    else
                        exit for
                    end if
                end for

                if j <= words.count() - 1  Then
                    if font.getOneLineWidth(line + "...", width) = width Then
                        line = line.mid(0, line.len() - 4)
                    end if

                    line = line + "..."
                end if

                if lines.count() = limit and lines.count() > 0 then
                    if font.getOneLineWidth(lines[limit-1] + "...", width) = width Then
                        lines[limit-1] = lines[limit-1].mid(0, lines[limit-1].len() - 4)
                    end if
                    lines[limit-1] = lines[limit-1] + "..."
                else
                    lines.push(line)
                end if
            else
                lines.push(" ")
            end if
        else
            exit for
        end if
    end for
    if lines.count() = 0 then
        lines.push(" ")
    end if
    return lines
end function

'******************************************************
' validstr
'
' always return a valid string. if the argument is 
' invalid or not a string, return an empty string.
'******************************************************
function validStr(obj As object) As string
    if obj <> invalid and GetInterface(obj, "ifString") <> invalid
        return obj
    else
        return ""
    end if
end function

'try to convert an object to a string. return invalid if can't
'******************************************************
function anyToString(any as dynamic) as dynamic
    if any = invalid return "invalid"
    if isstr(any) return any
    if isint(any) return itostr(any)
    if isbool(any)
        if any = true return "true"
        return "false"
    endif
    if isfloat(any) return Str(any)
    if type(any) = "roTimespan" return itostr(any.totalMilliseconds()) + "ms"
    if type(any) = "roDateTime" return dateTimeToString(any)
    return invalid
end function

'******************************************************
'Convert anything to a string
'
'Always returns a string
'******************************************************
function tostr(any as dynamic) as dynamic
    ret = anyToString(any)
    if ret = invalid ret = type(any)
    if ret = invalid ret = "unknown" 'failsafe
    return ret
end function

'******************************************************
'Walk a list and print it
'******************************************************
sub printList(list as object) as dynamic
    printAnyList(0, list)
end sub

sub tooDeep(depth as integer) as boolean
    hitLimit = (depth >= 10)
    if hitLimit then  print "**** TOO DEEP "; depth
    return hitLimit
end sub

function zeroPad(i, width) as string
    ' This needs to be trimmed because str() on a number includes
    ' a leading space for a possible negative sign

    ' This little but may look a little strange. It's
    ' because  istr = str(i).Trim() leaks memory (or used to).
    s1 = createObject("roString")
    s1.SetString(str(i))
    istr = s1.Trim()
    
    istr_len = len(istr)
    if istr_len >= width then
        return istr
    end if
    return (string(width-istr_len,"0") + istr)
end function

'******************************************************
'Replace substrings in a string. Return new string
'******************************************************
Function strReplace(basestr As String, oldsub As String, newsub As String) As String
    newstr = ""
    i = 1
    while i <= Len(basestr)
        x = Instr(i, basestr, oldsub)
        if x = 0 then
            newstr = newstr + Mid(basestr, i)
            exit while
        endif
        if x > i then
            newstr = newstr + Mid(basestr, i, x-i)
            i = x
        endif
        newstr = newstr + newsub
        i = i + Len(oldsub)
    end while
    return newstr
End Function

' always return a valid string. if the argument is
' invalid or not a string, return an empty string
'******************************************************
Function validstr(obj As Dynamic) As String
    if isnonemptystr(obj) return obj
    return ""
End Function

function stringComparsion(FileData as string, text1 as string, streamUrlFileStatus as boolean) as object
    List = []
    field = []
    subString = ""
    line = ""
    lines = ""

    register = CreateObject("roRegex", text1,"")
    if streamUrlFileStatus = true
        lines = FileData.Tokenize(",")
        streamUrlFileStatus = false
    else
        lines = FileData.Tokenize(chr(10))
    end if

    for each line in lines
        subString = register.Match(line)
        if subString.count()<>0
            field = line.Tokenize("=")
            List.push(field[1])
        end if
    next 
    return List
end function

function removeMatchedLine(urlFileData as object, text as string) as object
    data = []
    subString = ""
    line = ""
    register = CreateObject("roRegex",text,"")
    for each line in urlFileData
        subString = register.Match(line)
        if subString.count()=0
            data.push(line)
        end if
    end for
    return data
end function

'Convert string to boolean safely. Don't crash
'Looks for certain string values
'******************************************************
Function strtobool(obj As dynamic) As Boolean
    if obj = invalid return false
    if type(obj) <> "roString" and type(obj) <> "String" return false
    o = strTrim(obj)
    o = Lcase(o)
    if o = "true" return true
    if o = "t" return true
    if o = "y" return true
    if o = "1" return true
    return false
End Function

'******************************************************
'Pluralize simple strings like "1 minute" or "2 minutes"
'******************************************************
Function Pluralize(val As Integer, str As String) As String
    ret = itostr(val) + " " + str
    if val <> 1 ret = ret + "s"
    return ret
End Function

'******************************************************
'*** Generate MD5 hash from string
'******************************************************
Function md5(str1 as string)
    ba1 = CreateObject("roByteArray")
    ba2 = CreateObject("roByteArray")
    ba1.FromAsciiString(str1)
    digest = CreateObject("roEVPDigest")
    digest.Setup("md5")
    digest.Update(ba1)
    digest.Update(ba2)
    result = digest.Final()
    return result
End Function

'******************************************************
' Removes encoded values.
'
' returns a string
function sanitize_node(str) as dynamic
    if type(str) = "String" or type(str) = "roString"
        str = strReplace(str,"&amp;",chr(38))
        str = strReplace(str,"&ndash;",chr(45))
        str = strReplace(str,"&mdash;",chr(45))
        str = strReplace(str,"&rdquo;",chr(39))
        str = strReplace(str,"&ldquo;",chr(39))
        str = strReplace(str,"&rsquo;",chr(39))
        str = strReplace(str,"&nbsp;","")
        str = strReplace(str,"&quot;",chr(34))
        str = strReplace(str,"&#039;",chr(39))
        str = strReplace(str,"&#o39;",chr(39))
        str = strReplace(str,"&#39;",chr(39))
        str = strReplace(str, "â€™", "‘")
        str = strReplace(str, "â€˜", "’")
        str = strReplace(str, "â€œ", "“")
        str = strReplace(str, "â€"+chr(157), "”")
        str = strReplace(str, "â€”", "–")
        str = strReplace(str, "â€“", "—")
        str = strReplace(str, "â€¢", "-")
        str = strReplace(str, "â€¦", "…")
        str = strReplace(str, "&#43;", "+")
        str = strReplace(str, "Â§", "§")
        str = strReplace(str, "<br />", chr(32))
        str = strReplace(str, "&reg;", chr(174))

        str = strReplace(str, "&agrave;", chr(224))
        str = strReplace(str, "&aacute;", chr(225))
        str = strReplace(str, "&acirc;", chr(226))
        str = strReplace(str, "&atilde;", chr(227))
        str = strReplace(str, "&auml;", chr(228))
        str = strReplace(str, "&aring;", chr(229))
        str = strReplace(str, "&aelig;", chr(230))
        str = strReplace(str, "&ccedil;", chr(231))
        str = strReplace(str, "&egrave;", chr(232))
        str = strReplace(str, "&eacute;", chr(233))
        str = strReplace(str, "&ecirc;", chr(234))
        str = strReplace(str, "&euml;", chr(235))

        str = strReplace(str, "â„¢", "™")
        str = strReplace(str, "Â©", "©")
        str = strReplace(str, "Ä©", "©")
    end if
    return str
end function

'   Format text so that (only) the first char is set to capital
'   @example
'       capitalizeString("ACCEDO") -> "Accedo"
'       capitalizeString("accedo") -> "Accedo"

function capitalizeString(text as String) as String
    if text.len() > 1 then
        firstChar = text.left(1)
        restChars = text.mid(1)
        return uCase(firstChar) + lCase(restChars)
    end if

    return text
end function

' Capitalizes first letter in each word in a sentence
' @example
'   "this is a sentence" -> "This Is A Sentence"
function capitalizeSentence(text as String) as String
    result = createObject("roString")
    textArray = text.tokenize(" ")
    for i = 0 to textArray.count() - 1
        subString = textArray[i]
        subString = ucase(subString.left(1)) + lcase(subString.mid(1))
        ' Only append space if we are not at the last word
        if i <> textArray.count() - 1 then
            subString = subString + " "
        end if
        result.appendString(subString, subString.len())
    end for
    return result
end function

'   Split a string into an array of strings.
'   @example
'       trim("One, Two, Three", ", ") -> ["One", "Two", "Three"]
function explode(str as String, delim as String) as Object
    regex = CreateObject("roRegex", delim, "")
    return regex.split(str)
end function

'   Format a text string to make sure it isn't overflowing your box. Ellipsis is added if it's too wide.
'   @param  {String} text, array of text strings
'   @param  {roFont} font
'   @param  {Integer} width - width in pixels, default 200px
'   @param  {Integer} limit - Maximum number of lines. Default is no limit.
'   @param  {String} token - Token that will force a new line
'   @return {array} reformatted text String
function splitTextToLine(text as String, font as Object, width = 200 as Integer, limit = 0 as Integer, token = "\\n", truncateMidWord = false) as Object
    if text = "" then
        return [text]
    end if
    reg = CreateObject("roRegex", token, "")
    paragraphs = reg.split(text)
    lines = []
    current = Invalid

    for i = 0 to paragraphs.count() - 1
        if limit = 0 OR lines.count() < limit then
            words = paragraphs[i].tokenize(" ")

            if words.count() > 0 then
                line = words[0].getString()
                if words.count() > 1
                    for j = 1 to words.count() - 1
                        current = line + " " + words[j].getString()

                        if font.getOneLineWidth(current, width) < width and (lines.count() < limit or limit = 0) then
                            line = current
                        else if limit = 0 or lines.count() < limit then
                            lines.push(line)
                            line = words[j].getString()
                            if truncateMidWord = true and lines.count() = limit then
                                exit for
                            end if
                        else
                            exit for
                        end if
                    end for
                else
                    j = Invalid
                end if

                if truncateMidWord = true and current <> Invalid and font.getOneLineWidth(current, width) = width then
                    lastWord = words[j]
                    lastLine = lines[limit-1] + " "
                    while font.getOneLineWidth(lastLine, width) < width
                        lastLine = lastLine + lastWord.left(1)
                        lastWord = lastWord.right(lastWord.len() - 1 )
                    end while
                    lines[limit-1] = lastLine + " "
                end if

                if j <> Invalid and j <= words.count() - 1  then
                    if font.getOneLineWidth(line + "...", width) = width then
                        line = line.mid(0, line.len() - 4)
                    end if

                    line = line + "..."
                end if

                if lines.count() = limit and lines.count() > 0 then
                    if font.getOneLineWidth(lines[limit-1] + "...", width) = width then
                        lines[limit-1] = lines[limit-1].mid(0, lines[limit-1].len() - 4)
                    end if
                    lines[limit-1] = lines[limit-1] + "..."
                else
                    lines.push(line)
                end if
            else
                lines.push(" ")
            end if
        else
            exit for
        end if
    end for
    if lines.count() = 0 then
        lines.push(" ")
    end if
    return lines
end function

' Check if a string is empty or invalid:
' @return {boolean}
' Invalid -> true
' "" -> true
' " " -> true
' "x" -> false
function isEmpty(text as Dynamic) as Boolean
    if text = Invalid then
        return true
    else if len(text.trim()) = 0 then
        return true
    else
        return false
    end if
end function

'Format a text string to make sure it isn't overflowing your box. Ellipsis is added if it's too wide.
'This function use char as unit instead of word, and should be accurate.
'
'@param {String} text - original text
'@param {Integer} width - line box width in px
function splitTextToSingleLine(text as String, width = 200 as Integer, font = Invalid as Dynamic) as String
    if font = Invalid then
        fontRegistry = createObject("roFontRegistry")
        font = fontRegistry.getDefaultFont(16, false, false)
    end if
    result = ""
    if not isString(text) then
        return result
    end if

    for i = 0 to text.len() - 1
        char = text.mid(i, 1)
        result = result + char

        if font.getOneLineWidth(result, width) = width then
            result = result.mid(0, result.len() - 3)
            result = result + "..."
            exit for
        end if
    end for
    return result
end function


'   Remove HTML tags from string
'   @example
'       "<h1>Title</h1>" -> "Title"
function stripHTML(text as String) as String
    parsedText = ""
    newline = chr(10)

    ' Replace space between tags
    regex = CreateObject("roRegex", "\>[ \s\t]+", "i")
    parsedText = regex.ReplaceAll(text, ">")

    ' Replace <br /> with newline
    regexStr = "<br />|<br>|</br>|<br/>|<p>|</p>"
    regex = CreateObject("roRegex", regexStr, "i")
    parsedText = regex.ReplaceAll(parsedText, newline)

    ' Remove all other tags
    regex = CreateObject("roRegex", "<[^<]+?>", "i")
    parsedText = regex.ReplaceAll(parsedText, "")

    return parsedText
end function

'   Convert an array to a string
'   @example
'       arrayToString(["foo", "bar"], ":") -> "foo:bar"
function arrayToString(array as Object, seperator = "," as String) as String
    result = ""

    for each item in array
        if result = ""
            result = toString(item)
        else
            result = result + seperator + toString(item)
        end if
    end for
    return result
end function


'   Convert an HTML style colour to RGBA format
'   @example
'   htmlColorToRGBA("#112233", 0) -> &h11223300
function htmlColorToRGBA(htmlColor as String, alpha = 255 as Integer)
    htmlColor = stringReplace(htmlColor, "#", "")
    rgb = createObject("roByteArray")
    rgb.fromHexString(htmlColor)
    return &h1000000*rgb[0] + &h10000*rgb[1] + &h100*rgb[2] + alpha
end function

'   Split a string into an array
'   @example
'       splitTextToSentences("Hi foo. Bar here.") -> ["Hi foo.", "Bar here."]
function splitTextToSentences(paragraphText as String) as Object
    if paragraphText <> Invalid then
        return paragraphText.tokenize(".")
    else
        return ""
    end if
end function

' Takes a string and removes all \n characters
function removeNewlines(text as String) as String
    regex = CreateObject("roRegEx", "\n", "")
    return regex.replaceAll(text, " ")
end function

' Takes a string and removes everything that is not a digit
function removeWords(text as String) as String
    regex = CreateObject("roRegEx", "[^\d+]", "")
    return regex.replaceAll(text, "")
end function

function getRandomHexString(length As Integer) As String
    hexChars = "0123456789ABCDEF"
    hexString = ""
    date = CreateObject("roDateTime").asSeconds()
    date = int(date / 16)
    for i = 1 to length-1
        rand = ((date + Rnd(16)) MOD 16) OR 0
        hexString = hexString + hexChars.Mid(rand, 1)
    end for
    return hexString
end function