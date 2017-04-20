function processColor(standardColor)
    rokuColor = standardColor.replace("#","")
    rokuColor = "0x" + rokuColor
        if(rokuColor.Len() = 8)
            rokuColor = rokuColor + "FF"
        end if
    if(rokuColor.Len() = 0)
        rokuColor = "0x000000FF"
    end if
    return rokuColor
end function

function buildFont(fontName, fontSize)
    packagePrefix = "pkg:/locale/default/fonts/"
    translatePath = {
        "RobotoCondensed-BoldItalic" : "Roboto_Condensed/RobotoCondensed-BoldItalic.ttf"
        "RobotoCondensed-Italic" : "Roboto_Condensed/RobotoCondensed-Italic.ttf"
        "RobotoCondensed-Regular" : "Roboto_Condensed/RobotoCondensed-Regular.ttf"
        "Roboto-Regular" : "Roboto_Regular/Roboto-Regular.ttf"
        "Roboto-Bold" : "Roboto_Regular/Roboto-Bold.ttf"
        "Roboto-BoldItalic" : "Roboto_Regular/Roboto-BoldItalic.ttf"
        "Roboto-Light" : "Roboto_Regular/Roboto-Light.ttf"
    }
    if(isValid(fontName) and isValid(translatePath[fontName]))
        nodeFont = CreateObject("roSGNode", "Font")
        nodeFont.uri = packagePrefix + translatePath[fontName]
        nodeFont.size = fontSize
        return nodeFont
    else
        nodeFont = CreateObject("roSGNode", "Font")
        nodeFont.uri = packagePrefix + translatePath["Roboto-Regular"]
        nodeFont.size = fontSize
        return nodeFont
    end if
end function


function getLocalColors()
    darkFontColor = "0x222222FF"
    lightFontColor = "0xEBEBEBFF"
    return {
        "rowListTitle" : darkFontColor
        "rowListTitleLight" : lightFontColor
        "heroTitleDark" : darkFontColor
        "heroTitleLight" : lightFontColor
        "heroSubtitleDark" : darkFontColor
        "heroSubtitleLight" : lightFontColor
        "itemNonPlayableTitle" : lightFontColor
        "itemNonPlayableSubtitle" : lightFontColor
        "heroDescriptionDark" : "0x2222227F"
        "heroDescriptionLight" : "0xB2B2B2FF"
        "viewAllDefaultState" : "0x998EA3"
        "scheduleItemDefaultState" : "0xD1C1D3"
        "itemPlayableTitle" : darkFontColor
        "buttonLargeDark" : "0x222222FA"
        "buttonLargeLight" : "0xFF26EFFF"
        "backgroundDark" : "0x222222FA"
        "searchText" : darkFontColor
        "keyboardFocus" : "0xFF26EFFF"
        "overlayHeader" : lightFontColor
        "pageBackgroundDark" : "0x222222"
        "transparent" : "0x00000000"
         "activationBackground" : "#EBE7E9FF"
    }
end function

function getLocalFonts()
    return{
        "rowListTitle" : buildFont("Roboto-Regular",36)
        "overlayHeader" : buildFont("RobotoCondensed-Italic",66)
        "signoutTitle" : buildFont("RobotoCondensed-BoldItalic",57)
        "overlayListTitle" : buildFont("RobotoCondensed-BoldItalic",57)
    }
end function

function rgbaToInt(red As Integer, green As Integer, blue As Integer, opacity As Integer) As Integer
    base = &h100
    return opacity + blue * base + green * base ^ 2 + red * base ^ 3
end function

function intToRgba( rgba As integer) As Object
    red = rgba >> 24
    green = (rgba and &hFF0000) >> 16
    blue  = (rgba and &hFF00) >> 8
    opacity = rgba and &hFF

    return {
        r:  red
        g: green
        b: blue
        a: opacity
    }
end function