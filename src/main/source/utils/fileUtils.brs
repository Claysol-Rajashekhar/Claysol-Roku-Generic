function readStringXmlFile(xmlFilename) as object
    list = {}
    matchedLine = []
    keyValue = []
    value = []
    key = []
    subString = ""
    lines = ""
    line = ""

    register = CreateObject("roRegex", "name=","")
    fileData = ReadASCIIFile(xmlFilename)
    lines = fileData.Tokenize(chr(10))

    for each line in lines
        subString = register.Match(line)
        if subString.count()<>0
            matchedLine =line.Tokenize("=")
            key = matchedLine[1].Tokenize(">")
            keyValue = key[0].Tokenize("""")
            value = key[1].Tokenize("<")
            list.addReplace(keyValue[0],value[0])
        end if
    end for
    return list
end function