'******************************************************
'Get our device version as single string
'******************************************************
function getDeviceVersion() as string
    if m.softwareVersion = invalid OR m.softwareVersion = "" then
        m.softwareVersion = createObject("roDeviceInfo").getVersion()
    end if
    return m.softwareVersion
end function

'******************************************************
'Get our device version as parsed associative array
'******************************************************
function getDeviceVersionAA() as object
    if m.softwareVersionAA = invalid then
        version = GetDeviceVersion()
        m.softwareVersionAA = {
            FullVersion: version
            Major: version.Mid(2, 1).ToInt()
            Minor: version.Mid(4, 2).ToInt()
            Build: version.Mid(7, 5).ToInt()
        }
    end if
    return m.softwareVersionAA
end function

'******************************************************
'Compare current device firmware version vs version supplied with parameters
'
'function returns
'    1 - if current version is greater than supplied
'    0 - if current version is equal to supplied
'   -1 - if current version is smaller than supplied
'******************************************************
function checkDeviceVersion(major as dynamic, minor = invalid as dynamic, build = invalid as dynamic) as integer
    version = getDeviceVersionAA()
    if version.Major > major then
        return 1
    else if version.Major < major then
        return -1
    else
        if minor <> invalid then
            if version.Minor > minor then
                return 1
            else if version.Minor < minor then
                return -1
            else
                if build <> invalid then
                    if version.Build > build then
                        return 1
                    else if version.Build < build then
                        return -1
                    else
                        return 0
                    end if
                else
                    return 0
                end if
            end if
        else
            return 0
        end if
    end if
end function

'******************************************************
'Get our device closed captions mode
'(only for fimware 5.3 or greater, returns invalid otherwise)
'******************************************************
function getDeviceCaptionsMode() as dynamic
    if CheckDeviceVersion(5, 3) >= 0 then
        if m.deviceCaptionsMode = invalid then
            deviceInfo = createObject("roDeviceInfo")
            m.deviceCaptionsMode = deviceInfo.GetCaptionsMode()
        end if
        return m.deviceCaptionsMode
    else
        return invalid
    end if
end function

'******************************************************
'Get our serial number
'******************************************************
function getDeviceESN() as dynamic
    if m.serialNumber = invalid OR m.serialNumber = "" then
        m.serialNumber = createObject("roDeviceInfo").getDeviceUniqueId()
    end if
    return m.serialNumber
end function

'******************************************************
'Get our hardware model number
'******************************************************
function getHardwareModel() as dynamic
    if m.hardwareModel = invalid OR m.hModel = "" then
        m.hardwareModel = createObject("roDeviceInfo").GetModel()
    end if
    return m.hardwareModel
end function

'******************************************************
'Determine if the UI is displayed in SD or HD mode
'******************************************************
function isHD() as boolean
    di = createObject("roDeviceInfo")
    if di.GetDisplayMode() = "720p" then return true
    return false
end function


' Writes a value to local storage
sub storePersistentValue(key as string, value as string) as dynamic
    registry = createObject("roRegistrySection", "appLoginDetails")
    registry.write(key, value)
    registry.flush()
end sub

' Reads a value from local storage
function readPersistantValue(key as string) as dynamic
    registry= createObject("roRegistrySection", "appLoginDetails")
    if registry.exists(key) then
        return registry.read(key)
    end if
    return invalid
end function

' Deletes a value from local storage
sub deletePersistentValue(key as string) as dynamic
    registry = createObject("roRegistrySection", "appLoginDetails")
    if registry.exists(key) then
        registry.delete(key)
        registry.flush()
    end if
end sub

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''' Registry CRUD '''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Methods for working with Roku's registry system that allows for persistent data to be stored
' as serialized string data.
' Every registry editing session must begin with BeginRegistryEdit. This is essentially a batching method
' to improve performance when mutliple edits are required.
'   params
'       section: is a string that indicates what registry section is to be worked with. "Default" is set
'       if this parameter is not passed.
'   returns
'       An associative array containing the state for the current editing session
function BeginRegistryEdit(section = "Default" as string)
    m.registryEditorState = CreateRegistryEditorState(section)
    return m.registryEditorState
end function

' All registry editing sessions must end with a call to EndRegistryEdit. Passing the
' associative array state obstained with BeginRegistryEdit must be passed in to this method.
'   params
'       registryState: must be passed the associative array you obtained when opening the editing
'       session.
function EndRegistryEdit(registryState as dynamic)
        registryState.CommitChanges()
        m.registryEditorState = invalid
end function

' Method used internally for creating the registry editing state.
'   return
'       top: current contexts top
'       registrySection: the "raw" registry section used to perform the edits internally
'       GetRegistryEntry : exposes a method for getting a registry entry
'       SetRegistryEntry : exposes a method for setting a registry entry
'       DeleteRegistryEntry : exposes a method for deleting a registry entry
'       CommitChanges : exposes a method for commiting current changes
function CreateRegistryEditorState(section as string)
    this = {}
    rSection = CreateObject("roRegistrySection", section)
    this.top                = m.top
    this.registrySection    = rSection

    ' functions
    this.GetRegistryEntry = Registry_GetEntry
    this.SetRegistryEntry = Registry_SetEntry
    this.DeleteRegistryEntry = Registry_DeleteEntry
    this.GetKeys = Registry_GetKeys
    this.CommitChanges = Registry_Commit
    return this
end function

' Method that uses key to return an entry from the registry
'   params
'       key: is a string used to identify which entry to return from the registry
function Registry_GetEntry(key as string)
    if m = invalid then return invalid
    value =invalid
    if m.registrySection.Exists(key)
       raLog("DEBUG","Utilities","Registry_GetEntry valid call")
       value = m.registrySection.Read(key)
    end if
    return value
end function

' Method that takes a key and a value to add/replace an entry in the current
' registry editing context. Values will not be saved to the registry until
' EndRegistryEdit or CommitChanges is called.
'   params
'       key: string used to identify the registry entry to add/replace.
'       value: string that is the value to be added or replaced in the registry
function Registry_SetEntry(key as string, value as string)
    if m = invalid then return invalid
    raLog("DEBUG","Utilities","Registry_SetEntry valid call")
    m.registrySection.Write(key,value)
end function

' Method used to delete an entry from the registry identified by the key.
'   params
'       key: is a string that identifies the the entry to be deleted
function Registry_DeleteEntry(key as string)
    if m = invalid then return invalid
    raLog("DEBUG","Utilities","Registry_DeleteEntry valid call")
    m.registrySection.Delete(key)
end function

' Method used to save any pending changes in the current registry editing context
' NOTE: This method is provided to allow committing of changes for interstitial edits.
' Calling EndRegistryEdit calls this method, so is not required to call this method if all
' edits can be batched together.
function Registry_Commit()
    if m = invalid then return invalid
    raLog("DEBUG","Utilities","Registry_Commit valid call")
    m.registrySection.Flush()
end function

function Registry_GetKeys()
    if m = invalid then return invalid
    raLog("DEBUG", "Utilities", "Registry_GetKeys valid call")
    return m.registrySection.GetKeyList()
end function

'Scaling is based on FHD mode'
function scale(fromVal = 1 as Integer, isX = false as Boolean) as Dynamic
    dInfo = CreateObject("roDeviceInfo")
    mode = getDisplayMode()
    if mode = "FHD" then
        return fromVal
    else if mode = "HD" then 'FHD->HD:720/1080'
        return (fromVal * 0.66667)
    else if mode = "SD" then 'FHD->SD:480/1080'
        if isX then
            return (fromVal * 0.375)
        else
            return (fromVal * 0.444)
        end if
    end if
end function

function getDisplayMode() as String
    gaa = getGlobalAA()
    if gaa.displayMode = Invalid then
        deviceinfo = CreateObject("roDeviceInfo")
        displaySize = deviceinfo.getDisplaySize()
        if displaySize.h = 1080
            gaa.displayMode = "FHD"
        else if displaySize.h = 720
            gaa.displayMode = "HD"
        else if displaySize.h = 480
            gaa.displayMode = "SD"
        end if
        return gaa.displayMode
    else
        return gaa.displayMode
    end if
end function
