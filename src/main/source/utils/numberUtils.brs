'''''''''''''''''''''''''''''''''''''''''''''''''
'   Number Operators
'       a. cieling
'       b. floor
'       b. round
'''''''''''''''''''''''''''''''''''''''''''''''''
'   Round float up
'   @example
'       ceiling(2.2) -> 3

function ceiling(number as Float) as Integer
    if number - int(number) > 0 then
        return int(number) + 1
    else
        return int(number)
    end if
end function

'   Round float down
'   @example
'       floor(2.2) -> 2
function floor(number as Float) as Integer
    return int(number)
end function

'   Round Float to the nearest Integer
'   @example
'       round(2.2) -> 2
'       round(2.5) -> 3
'       round(2.8) -> 3

function round(number as Float) as Integer
    if number - int(number) >= 0.5 then
        return int(number) + 1
    else
        return int(number)
    end if
end function

'   returns the smaller of 2 integers
'   @example
'       min(2, 3) -> 2
'       min(1, 2) -> 1
'       min(1, 1) -> 1
'
function min(number1 as Integer,  number2 as Integer) as Integer
    if number1 <= number2 then return number1 else return number2
end function

function toTimeFormat(number as Integer) as String
    if number > 9 then
        return number.toStr()
    else
        return "0" + number.toStr()
    end if
end function

function HexToInteger(hex_in)
    bArr = createobject("roByteArray")
    if len(hex_in) mod 2 > 0 
        'fix for fromHexString() malicious silent failure on odd length
        hex_in = "0" + hex_in
    end if
    bArr.fromHexString(hex_in)    
    out = 0
    for i = 0 to bArr.count()-1
        out = 256 * out + bArr[i]
    end for
    return out
end function