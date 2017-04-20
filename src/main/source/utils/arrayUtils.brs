'**********************************************************************
'  Checks if array contains given element value
'  Returns: index if element exist, -1 if no such element
'********************************************************************** 
function indexInArray(arr as dynamic, elem as dynamic) as integer
    if arr <> invalid AND type(arr) = "roArray" then
        for i = 0 to arr.count() - 1
            if arr[i] = elem then
                return i
            end if
        end for
    end if
    return -1
end function

' Filters an array based on the condition provided as a function
' Example:
' list = ["apple", "banana", "pear", "pineapple"]
' result = filter(list, function(item)
'     return item.right(5) = "apple"
' end function)
' print result
' >>> ["apple", "pineapple"]
function filter(list, condition, opts = {}) as Object
    res = []
    if valid(list) and isArray(list) and valid(condition) and isFunction(condition) then
        for i = 0 to list.count() - 1
            if condition(list[i], opts) then
                res.push(list[i])
            end if
        end for
    end if
    return res
end function

function group(list, condition) as Object
    grouped = {}
    for i = 0 to list.count() - 1
        itemCondition = condition(list[i])
        if not valid(grouped[itemCondition]) then
            grouped[itemCondition] = []
        end if
        grouped[itemCondition].push(list[i])
    end for
    return grouped
end function

function groupToArray(list, condition, key, value) as Object
    groupedToArr = []
    grouped = group(list, condition)
    for each i in grouped
        obj = {}
        obj[key] = i
        obj[value] = grouped[i]
        groupedToArr.push(obj)
    end for
    return groupedToArr
end function

' Same as group, but allows the condition to return an array of
' grouping points instead of just one grouping point.
' Can be used where items in the list can belong to many groups, like:
' {
'     id: 44
'     title: "Cool Movie"
'     genres: ["Action", "Drama", "Thriller"]
' }
function groupMany(list, condition, opts) as Object
    grouped = {}
    for i = 0 to list.count() - 1
        itemConditions = condition(list[i], opts)
        for x = 0 to itemConditions.count() -1
            if not valid(grouped[itemConditions[x]]) then
                grouped[itemConditions[x]] = []
            end if
            grouped[itemConditions[x]].push(list[i])
        end for
    end for
    return grouped
end function

' Iterate over a list of items and apply a function to them
function withEach(items, func)
    for i = 0 to items.count() - 1
        func(items[i])
    end for
end function

' Iterate over a list of items and put items that match a certain condition into a new array
function collectEach(items, condition)
    collection = []
    for i = 0 to items.count() - 1
        if condition(items[i]) then
            collection.push(items[i])
        end if
    end for
    return collection
end function

function getUnique(items)
    u = {}
    a = []
    for i = 0 to items.count() - 1
        if valid(u.lookup(items[i])) = FALSE then
            a.push(items[i])
            u[items[i]] = 1
        end if
    end for
    return a
end function

function getUniqueByAttr(items, attr)
    u = {}
    a = []
    for i = 0 to items.count() - 1
        if valid(items[i][attr]) and items[i][attr] <> "" then
            if valid(u.lookup(items[i][attr])) = FALSE then
                a.push(items[i][attr])
                u[items[i][attr]] = 1
            end if
        end if
    end for
    return a
end function
' Clone an object like array or associative array by converting it to JSON and back
' Warning! Don't use this in heavy loops. It is expensive!
function clone(obj)
    clonedObject = clonedObject
    if valid(obj) then
        tmpClone = toJSON(obj)
        clonedObject = ParseJson(tmpClone)
    end if
    return clonedObject
end function

function rdDeepCopy(v as object) as object
    v = box(v)
    vType = type(v)
    if vType = "roArray"
        n = CreateObject(vType, v.count(), true)
        for each sv in v
            n.push(rdDeepCopy(sv))
        end for
    elseif vType = "roList"
        n = CreateObject(vType)
        for each sv in v
            n.push(rdDeepCopy(sv))
        end for
    elseif vType = "roAssociativeArray"
        n = CreateObject(vType)
        for each k in v
            n[k] = rdDeepCopy(v[k])
        end for
    elseif vType = "roByteArray"
        n = CreateObject(vType)
        n.fromHexString( v.toHexString() )
    elseif vType = "roXMLElement"
        n = CreateObject(vType)
        n.parse( v.genXML(true) )
    elseif vType = "roInt" or vType = "roFloat" or vType = "roString" or vType = "roBoolean" or vType = "roFunction" or vType = "roInvalid"
        n = v
    else
        print "skipping deep copy of component type "+vType
        n = invalid
        'n = v
    end if
    return n
end function

' Checks if an item is in an array
function inArray(list, item) as Boolean
    res = false
    if valid(list) and isArray(list) then
        for i = 0 to list.count() - 1
            if list[i] = item then
                return true
            end if
        end for
    end if
    return res
end function

function reverseArrayOrder(roArray as Object) as Object
    reversedArray = []
    for i=0 to roArray.Count()-1
        reversedArray.Push(roArray.Pop())
    end for
    return reversedArray
end function


function shuffle(array as Object)
    currentIndex = array.count()
    temporaryValue = invalid
    randomIndex = invalid

    ' While there remain elements to shuffle...
    while (0 <> currentIndex)
        ' Pick a remaining element...
        randomIndex = fix((rnd(1000) / 1000) * currentIndex)
        currentIndex = currentIndex - 1
        ' And swap it with the current element.
        temporaryValue = array[currentIndex]
        array[currentIndex] = array[randomIndex]
        array[randomIndex] = temporaryValue
    end while
    return array
end function

'Join the elements of an array into a string:
'Example:
'fruits = ["Banana", "Orange", "Apple", "Mango"];
'energy = joinArray(fruits);
'The result of energy will be:
'Banana,Orange,Apple,Mango
function joinArray(arr = []) as String
    s = ""
    for each item in arr
        if isString(item) then
            s = s + item + ","
        else
            s = s + str(item).trim() + ","
        end if
    end for
    ' Remove the last ","
    if s.len() > 0 then
        s = s.left(s.len() - 1)
    end if
    return s
end function