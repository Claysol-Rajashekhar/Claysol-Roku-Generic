'******************************************************
'Insertion Sort
'Will sort an array directly, or use a key function
'******************************************************
Sub Sort(A as Object, key=invalid as dynamic)
    if type(A)<>"roArray" then return
    if (key=invalid) then
        for i = 1 to A.Count()-1
            value = A[i]
            j = i-1
            while j>= 0 and A[j] > value
                A[j + 1] = A[j]
                j = j-1
            end while
            A[j+1] = value
        next
    else
        if type(key)<>"Function" then return
        for i = 1 to A.Count()-1
            valuekey = key(A[i])
            value = A[i]
            j = i-1
            while j>= 0 and key(A[j]) > valuekey
                A[j + 1] = A[j]
                j = j-1
            end while
            A[j+1] = value
        next
    end if
End Sub

function sortByComparer(array as Object, comparer as Function) as Object
    for x = 0 to array.count() - 1 step 1
        for y = 0 to array.count() - 2 step 1
            if comparer(array[y], array[y + 1]) then
                tmp = array[y + 1]
                array[y + 1] = array[y]
                array[y] = tmp
            end if
        end for
    end for
    return array
end function

'   Takes an array of items and sorts them based on based on the more than operator
'   @example
'       sortAtoZ(["C", "A", "H"]) -> ["A", "C", "H"]

function sortAtoZ(array) as Object
    return sort(array, function(a, b)
        return a > b
    end function)
end function

'search the inputArray alone with attrList and see if last object in attrList have the expectedValue
'if the attrList is used up, but array still exist as input, it will loop through on array to check the

'@param inputArray
'@param attrList
'@param expectedValue
function find(inputArray as Object, attrList as Object, expectedValue as dynamic) as dynamic
    if isArray(inputArray) and isArray(attrList) and attrList.count()>0 then
        attrName = attrList.shift()
        for each item in inputArray
            if attrList.count()<=0 then
                if validStr(expectedValue) or equal(item[attrName], expectedValue) or inArray(item[attrName], expectedValue) then
                    return item
                end if
            else
                item = find(item[attrName], rdDeepCopy(attrList), expectedValue)
                if item <> invalid then
                    return item
                end if
            end if
        end for
    end if
    return invalid
end function

'peek the inputArray alone with attrList and return if last element in attrList have valid element
'@param inputArray
'@param attrList
function peek(inputArray as Object, attrList as Object) as dynamic
   return find(inputArray, attrList, "valid")
end function