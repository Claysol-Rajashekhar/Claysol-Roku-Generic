
'function that returns date which is 90 days behind current day'
function getStartDate() as object
    startDate = ""
    date = CreateObject("roDateTime")
    currentYear = date.getYear()
    currentMonth = date.getMonth()
    currentDay = date.GetDayOfMonth()
    days = [31,28,31,30,31,30,31,31,30,31,30,31]
    for i = 0 to 90
        currentDay = currentDay - 1
        if currentDay <= 0 then
            currentMonth = currentMonth - 1
            if currentMonth <= 0 then
                currentMonth = 12
                currentYear = currentYear - 1 
            end if
            if currentYear MOD 4 = 0 then 'leap year'
                days[1] = 29
            else
                days[1] = 28
            end if
            currentDay = days[currentMonth-1]
        end if
    end for
    startDate = currentDay.tostr() + "-" + currentMonth.tostr() + "-" + currentYear.tostr()
    return startDate
end function

'******************************************************
'Converts a roDateTime to a string
'******************************************************
function dateTimeToString(o as object) as string
    s = ""
    s = s + zeroPad(o.getMonth()        , 2) + "/"
    s = s + zeroPad(o.getDayOfMonth()   , 2) + "/" 
    s = s + zeroPad(o.getYear()         , 2) + " " 
    s = s + zeroPad(o.getHours()        , 2) + ":" 
    s = s + zeroPad(o.getMinutes()      , 2) + ":" 
    s = s + zeroPad(o.getSeconds()      , 2) + "." 
    s = s + zeroPad(o.getMilliseconds() , 3)
    return s
end function

function calculateDuration(length as integer) as string
    duration = ""
    sec = length/60
    remainingSec = length mod 60
    min% = sec/60
    hour = tostr(min%)
    remainingMinutes = tostr(remainingSec)
    duration = hour + "h " + remainingMinutes + "m"
    return duration
end function

function calculateNumberOfDays(date as string) as string
    addedDate = ""
    currentDate = ""
    currentDateFormat = ""
    day = -1

    currentDate = m.timer.ToISOString()
    currentDateFormat = strTokenize(currentDate,"T")
    addedDate = strTokenize(date,"T")
    currentDateInSecs = m.clock.GetSecondsToISO8601Date(currentDateFormat[0])
    addedDateInSecs = m.clock.GetSecondsToISO8601Date(addedDate[0])

    diffInSecs = addedDateInSecs - currentDateInSecs  'Calculate the difference in seconds between two dates
    resumedDays = (diffInSecs \ (24 * 60 * 60)) *day

    description = ""
    if resumedDays = 0
        description = "Added today"
    else if resumedDays = 1
        description = "Added 1 day ago"
    else
        description = "Added "+ AnytoString(resumedDays) +" days ago"
    end if
    return description
end function

function setFirstLetterUpperCase(text as string) as string
    textLength = len(text)
    textFirstCharacter = left(text, 1)
    textFirstCharacterUpperCase = uCase(textFirstCharacter)
    textRemainingCharacters = right(text, textLength-1)
    textTitle = textFirstCharacterUpperCase + textRemainingCharacters
    return textTitle
end function

function formatTime(seconds as string) as string
    resumedTimeInhours = ""
    resumedTimeInminutes = ""
    resumedTimeInSecs = ""
    resumePoint = 0
    displayTime = ""
    minutes = 0
    hours = 0
    secs = 0 
    remainder=0
    
    resumePoint=seconds.ToInt()
    if(resumePoint <> 0)

        hours =  resumePoint \ 3600
        resumedTimeInhours = AnytoString(hours)
        if len(resumedTimeInhours) = 1
            resumedTimeInhours = "0" + resumedTimeInhours
        end if
      
        remainder =  resumePoint - hours* 3600
        minutes = remainder \ 60
        resumedTimeInminutes = AnytoString(minutes)
        if len(resumedTimeInminutes) = 1
            resumedTimeInminutes = "0" + resumedTimeInminutes
        end if

        remainder = remainder - minutes * 60
        secs = remainder
        resumedTimeInSecs = AnytoString(secs)
        if len(resumedTimeInSecs) = 1
            resumedTimeInSecs = "0" + resumedTimeInSecs
        end if
        displayTime = resumedTimeInhours + ":" + resumedTimeInminutes + ":" + resumedTimeInSecs
    else
        displayTime = "00:00:00"
    end if
    return displayTime
end function

function monthStr(date as string) as string
    description = ""
    BillingDate = strTokenize(date,"T")
    year = left(BillingDate[0],4)
    addedYear = year.ToInt()
    temp = mid(BillingDate[0],6,7)
    month =left(temp,2)
    addedMonth = month.ToInt()
    day = right(BillingDate[0],2)
    addedDay = day.ToInt()

    ma = m.Num2Month
    if ma = invalid
        ma = ["January","February","March","April","May","June","July","August","September","October","November","December"]
        m.Num2Month = ma
    end if
    description = AnyToString(addedDay) + " " + AnyToString(ma[addedMonth-1]) + " " + AnyToString(addedYear)
    return description
end function

function getTimeStamp() as integer
    timeStamp = 0
    timer = CreateObject("roDateTime")
    currentDateFormat = []
    currentDate = timer.ToISOString()
    currentDateFormat = strTokenize(currentDate,"Z")

    currentDateTime = CreateObject("roDateTime")
    currentDateTime.FromISO8601String(currentDateFormat[0])
    timeStamp = currentDateTime.AsSeconds()*1000
    m.timeStamp = timeStamp 
end function

'******************************************************
'Get remaining hours from a total seconds
'******************************************************
Function hoursLeft(seconds As Integer) As Integer
    hours% = seconds / 3600
    return hours%
End Function

'******************************************************
'Get remaining minutes from a total seconds
'******************************************************
Function minutesLeft(seconds As Integer) As Integer
    hours% = seconds / 3600
    mins% = seconds - (hours% * 3600)
    mins% = mins% / 60
    return mins%
End Function

function formatDuration(duration as integer) as string

    hours_left = tostr((duration)/3600).toint()
    minutes_left = tostr((duration - 3600*hours_left) / 60).toint()
    seconds_left = tostr((duration - 3600*hours_left - minutes_left*60)).toint()

    durationText = ""
    if hours_left > 0
        if hours_left < 10
            durationText = "0" + itostr(hours_left) + ":"
        else
            durationText = itostr(hours_left) + ":"
        end if
    end if
    if minutes_left < 10
        durationText = durationText + "0" + itostr(minutes_left) + ":"
    else
        durationText = durationText + itostr(minutes_left) + ":"
    end if
    if seconds_left < 10
        durationText = durationText + "0" + itostr(seconds_left)
    else
        durationText = durationText + itostr(seconds_left)
    end if

    return durationText

end function

'*************************************************************************
'*** Gets current time in seconds as Unix epoch.
'*************************************************************************
Function GetUnixTime()
    datetime = CreateObject("roDateTime")
    return datetime.asSeconds()*1000 + datetime.getmilliseconds()
End Function

'*************************************************************************
'*** Gets current date & time.
'Format: Monday July 18, 2016 4:37:15
'*************************************************************************
Function getDateTimeAsString() as String
    dtObj = CreateObject("roDateTime")
    d = dtObj.asDateString("long-date")
    t = (dtObj.getHours()).toStr() + ":" + (dtObj.getMinutes()).toStr() + ":" + (dtObj.getSeconds()).toStr()
    return d + " " + t
End Function
'*************************************************************************
'Gets the index of latest date from the list of dates passed as argument.
'Format of date passed in dateList: "2015-01-27T13:21:58Z" (ISO8601String)
'*************************************************************************

Function getLatestDateIndex(dateList as object) as integer
    date = []
    dateInSeconds = []
    dateTime = CreateObject("roDateTime")
    for i = 0 to dateList.count()-1
        date = strTokenize(dateList[i],"Z")
        dateTime.FromISO8601String(date[0])
        timestamp = dateTime.AsSeconds()
        dateInSeconds.push(timestamp)
    end for

    latestDateIndex = dateInSeconds[0]
    index = 0
    for i = 1 to dateInSeconds.count()-1
        if dateInSeconds[i] > latestDateIndex
            latestDateIndex = dateInSeconds[i]
            index = i
        end if
    end for
    return index
end Function

'*************************************************************************
'*** Get Secs from GMT
'ip: Thu, 21 Jul 2016 07:49:07 GMT op: 1469087347
'*************************************************************************
function getSecsFromGMT(gmt = "" as String) as LongInteger
    roRegex = CreateObject("roRegex", "...,\s(\d{1,2})\s([\S]+)\s(\d{4})\s([\S]+)\s.*","")
    dateMatch = roRegex.Match(gmt)
    datetimeStr = ""
    if (dateMatch.Count() > 4) then
      datetimeStr = dateMatch[3] + "-" + getNumericMonth(dateMatch[2]) + "-" + dateMatch[1] + "T" + dateMatch[4] + "z"
    end if

    dt = CreateObject("roDateTime")
    dt.FromISO8601String(datetimeStr)
    return dt.AsSeconds()
end function

'*************************************************************************
'*** Get Numeric month
'ip:jan op: 01
'*************************************************************************
function getNumericMonth(month = "" as string) as String
    abbrvmonth = Lcase(month.Left(3))
    m = ""
    if (abbrvmonth = "jan") then
        m = "01"
    else if (abbrvmonth = "feb") then
        m = "02"
    else if (abbrvmonth = "mar") then
        m = "03"
    else if (abbrvmonth = "apr") then
        m = "04"
    else if (abbrvmonth = "may") then
        m = "05"
    else if (abbrvmonth = "jun") then
        m = "06"
    else if (abbrvmonth = "jul") then
        m = "07"
    else if (abbrvmonth = "aug") then
        m = "08"
    else if (abbrvmonth = "sep") then
        m = "09"
    else if (abbrvmonth = "oct") then
        m = "10"
    else if (abbrvmonth = "nov") then
        m = "11"
    else if (abbrvmonth = "dec") then
        m = "12"
    end if
    return m
end function

'*************************************************************************
'*** Get Time with AM/PM
'Format: 8:00 AM
'*************************************************************************
function getTimeWithAmPm(time as Dynamic, iso = false) as String
    dtObj = CreateObject("roDateTime")

    if iso then
        dtObj.FromISO8601String(time)
        dtObj.toLocalTime()
    end if
    hours = dtObj.GetHours()
    if hours > 11 then
        if hours > 12 then
            hours = hours - 12
        end if
        meridian = "PM"
    else
        if hours = 0 then
            hours = 12
        end if
        meridian = "AM"
    end if
    minutes = dtObj.GetMinutes()
    if minutes < 10 then
        minutesStr = "0" + minutes.toStr()
    else
        minutesStr = minutes.toStr()
    end if

    time = hours.toStr() + ":" + minutesStr
    return time + " " +meridian
end function

'*************************************************************************
'Duration should be in seconds
'*** Get Min & Sec
'Format: 1 Min 30 Sec
'*************************************************************************
Function getFormattedTimeInMinSec(duration as Integer) as String
    minSuffix = "MIN"
    secSuffix = "SEC"
    if duration > 0 then
        durationMin = FIX(duration/60)
        if durationMin < 10 then
            durationMinStr = "0" + durationMin.ToStr()
        else
            durationMinStr = durationMin.ToStr()
        end if
        durationMinStr = durationMinStr + " " + minSuffix

        durationSec = duration MOD 60
        if durationSec < 10 then
            durationSecStr = "0" + durationSec.ToStr()
        else
            durationSecStr = durationSec.ToStr()
        end if
        durationSecStr = durationSecStr + " " + secSuffix

        formattedDuration = durationMinStr + " " + durationSecStr
        return formattedDuration
    else
        return "0 " + minSuffix + " 0 " + secSuffix
    end if
End Function

function printTime(time as Integer) as String
   min = time MOD  60
   hour = time \  60
   return  hour.tostr() + ":" + min.tostr()
end function

' @return roDatetime
function parseDate(dateStr = "" as String) as Object
    dateObj = CreateObject("roDatetime")
    dateObj.FromISO8601String(dateStr)
    return dateObj
end function

function runtimeSecondsToPretty(sec as Integer) as String
    d = CreateObject("roDateTime")
    d.fromSeconds(sec)
    noHours = (d.getHours() = 0)
    return formatTime(d, noHours)
end function

function unixToYYYYMMDDHHMMSSFFFF(seconds, convertToLocalTime = false) as String
    dateObj = CreateObject("roDateTime")
    dateObj.fromSeconds(seconds)

    if convertToLocalTime then
        dateObj.ToLocalTime()
    end if

    yyyy = dateObj.getYear().toStr()
    month = dateObj.getMonth().toStr()
    dd = dateObj.getDayOfMonth().toStr()
    hh = dateObj.getHours().toStr()
    minutes = dateObj.getMinutes().toStr()
    ss = dateObj.getSeconds().toStr()
    fff = dateObj.getMilliseconds().toStr()
    if len(month) = 1 then
        month = "0" + month
    end if
    if len(dd) = 1 then
        dd = "0" + dd
    end if
    if len(hh) = 1 then
        hh = "0" + hh
    end if
    if len(minutes) = 1 then
        minutes = "0" + minutes
    end if
    if len(ss) = 1 then
        ss = "0" + ss
    end if
    if len(fff) = 2 then
        fff = "0" + fff
    end if
    if len(fff) = 1 then
        fff = "00" + fff
    end if
    return yyyy + month + dd + hh + minutes + ss + fff
end function

'Note the result is GMT time , seconds from  the Unix epoch 
function YYYYMMDDHHMMSSFFFFtoUnix (dateString  as String) as integer
    targetDate = CreateObject("roDateTime")
    targetString = dateString.mid(0 , 4) + "-" + dateString.mid(4 , 2) + "-" + dateString.mid(6 , 2) + "T" +  dateString.mid(8 , 2) + ":"  + dateString.mid(10 , 2)  + ":"  + dateString.mid(12 , 2)  + "0"
    targetDate.FromISO8601String(targetString)
    return targetDate.AsSeconds()
End function

' @param Stirng publishDate in UTC time
'    example: Mon, 10 Aug 2015 20:48:39 UTC
' @return String in local time
'    example: Aug 10
function dateToLocalTime(publishDate as string)
    dateObj = CreateObject("roDateTime")
    dateIn = publishDate
    ro = CreateObject ("roRegex", "(\d+)\s+([a-z]+)\s+(\d+)\s+(\d+:\d+:\d+)\D", "i")
    da = ro.Match (dateIn)
    ml = "JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC"
    mon% = (Instr (1, ml, Ucase (da [2])) - 1)/3 + 1
    dateOut = da[3] + "-" + mon%.ToStr () + "-" + da [1] + " " + da [4]
    dateObj.FromISO8601String(dateOut)
    dateObj.ToLocalTime()
    date = dateObj.AsDateString("short-month-no-weekday")
    publishedDate = right(date,6)
    return date.Replace(publishedDate,"")
end Function

' @param videoDateTime as datetime object
' @return String as HH:MM AM/PM
'    Example: 6:00 PM
function toAMPMTime(dt as Object)
    hr = dt.GetHours()
    sc = dt.GetSeconds()
    mer = ""

    if hr > 11 then
        if hr > 12 then
            hr = hr - 12
        end if
        mer = "PM"
    else
        if hr = 0 then
            hr = 12
        end if
        mer = "AM"
    end if
    hrStr = convertAllToString(hr)
    if hr < 10 then
        hrStr = "0" + hrStr
    end if
    secStr = convertAllToString(sc)
    if sc < 10 then
        secStr = "0" + secStr
    end if
    return hrStr + ":" + secStr + " " + mer
end Function