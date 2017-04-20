
'******************************************************
' @return The MD5 hash of the specified text
'******************************************************
function getMD5Hash(text As string) as string
    digest = createObject("roEVPDigest")
    digest.Setup("md5")
    ba = createObject("roByteArray")
    ba.FromAsciiString(text)
    digest.Update(ba)
    return LCase(digest.Final())
end function

function hexChar(code as integer) as string
    if (code < 10)
        return Chr(48 + code)
    else
        return Chr(65 + (code - 10))
    end if
end function

function getBase64Encoding(fromStr as Dynamic) as String
    ba = CreateObject("roByteArray")
    ba.FromAsciiString(fromStr)
    return ba.ToBase64String()
end function

function modulo(dividend, divisor)
    mod = dividend - (divisor*int(dividend/divisor))
    return mod
end function

'round up the input according to the unit
'e.g   roundUp (10, 25) = 30
'e.g   roundUp (10, 24) = 20
function roundUp (unit as integer,  inputValue as integer)  as integer
     remain = inputValue MOD unit
     if  remain >= unit/2 then
            inputValue = inputValue + unit - remain
     else
            inputValue = input - remain
     end if
     return inputValue
end function

function arccos(x) as Float
    MathPI = 3.141592653589793
    return (MathPI / 2) - (2 * atn( (1 - sqr(1 - x*x)) / (x) ))
end function

function getDistanceByLatLong(myLat as float, myLon as float, lat as float, lon as float)
    ' Set all values to absolute numbers
    MathPI = 3.14159265358979323846264338327950288419716939937510582

    radlat1 =  MathPI * myLat/180
    radlat2 =  MathPI * lat/180
    radlon1 =  MathPI * myLon/180
    radlon2 =  MathPI * lon/180
    theta = myLon - lon
    radthetha = MathPI * theta/180
    distance = sin(radlat1) * sin(radlat2) + cos(radlat1) * cos(radlat2) * cos(radthetha)
    distance = arccos(distance)
    distance = distance * 180/MathPI
    distance = distance * 60 * 1.1515
    distance = distance * 1.609344
    return distance
end Function