' This Google Analysisc library use Measurement Protocol
'  Usage
'  1. call gaInit set GA info
'  2. Call gaTrackScreenView to Track screenView
'  3. Call gaTrackEvent to Track Event

'Reference  https://developers.google.com/analytics/devguides/collection/protocol/v1/parameters
'------------------------------------------------ private function ----------------------------------------------------------
Function getGoogleAnalytics() as Object
    m = getGlobalAA()
    if not valid(m.ga) then
        m.ga = {
            gaConfig:{}
            requests:[]
            maxRequest: 10  ' max request to be store

            debug: false 'for debugging, enable server return response, but result will not shown in report

            '------------------------------------------------ public function ----------------------------------------------------------
            gaInit: Function (accountInfo as Object)
               url = "http://www.google-analytics.com"
               If accountInfo <> invalid And accountInfo.useSSL=true Then url = "https://ssl.google-analytics.com"

               m.gaConfig = {
                   apiMethod: accountInfo.apiMethod,  '"POST"'or "GET"
                   baseUrl: url,
                   hostname: accountInfo.hostname,
                   version: accountInfo.version,
                   trackingId: accountInfo.trackingId,
                   clientId: accountInfo.clientId,
                   appName: accountInfo.appName
                   appVersion: accountInfo.appVersion
                   cacheBusting: accountInfo.cacheBusting   'If caching ocurr, turn this to true
                   defaultCds: accountInfo.cds
               }
               m.gaResetCustom()
            End Function

            'call this to track a screenView
            '@param screenName [Screen name]
            '@param cds {"1": "XXX",
            '            "2": "XXX"}   [Array of custom dimensions]

            gaTrackScreenView: Function (screenName="" As dynamic, cds=invalid As Object)
                if isString(screenName) then
                    path = m.gaCreateBasePayload() + m.gaScreenViewTrackingPL(screenName)
                    path = path + m.gaArrayCustomDimensionTrackingPL(cds)
                    path = path + m.gaArrayCustomDimensionTrackingPL(m.gaConfig.defaultCds)
                    m.gaApiCall(path)
                else
                    print "Warning, Invalid GA input!!"
                end if
            End Function

            'call this to track a page
            '@param hostname [Page name]
            '@param pTitle [Page Title]
            gaTrackPage: Function (page="" As dynamic, pTitle="" As dynamic)
                if isString(page) and isString(pTitle) then
                    m.gaApiCall( m.gaCreateBasePayload() + m.gaPageTrackingPL(m.gaConfig.hostname, page, pTitle))
                else
                    print "Warning, Invalid GA input!!"
                end if
            End Function

            'call this to track a Event
            '@param Category [String]
            '@param Action [String]
            '@param label [String]  optional
            '@param value [integer]   optional
            '@param cds {"1": "XXX",
            '            "2": "XXX"}   [Array of custom dimensions]
            gaTrackEvent: Function (category="" As dynamic, action="" As dynamic, label="" As dynamic, value="" As dynamic,  cds=invalid As Object)
                if isString(category) and isString(action)  and isString(label)  and isString(value) then
                    path =  m.gaCreateBasePayload() + m.gaEventTrackingPL(category, action, label, value)
                    path = path + m.gaArrayCustomDimensionTrackingPL(cds)
                    path = path + m.gaArrayCustomDimensionTrackingPL(m.gaConfig.defaultCds)
                    m.gaApiCall(path)
                else
                    print "Warning, Invalid GA input!!"
                end if
            End Function

            'call this to track a custom Event
            '@param CustomDimension [String]
            '@param CustomMetric [String]
            gaTrackCustomDimension: Function (CustomDimension="" As String, value="" As String )
                m.gaCustom.dimension[CustomDimension] = value
            End Function

            'call this to track a custom Event
            '@param CustomDimension [String]
            '@param CustomMetric [String]
            gaTrackCustomMetric: Function  (CustomMetric=""  As String, value=0 As Integer)
                m.gaCustom.metric[CustomMetric] = value
            End Function

            '-------------------------------------private function -----------------------------------------------------------------------
            'create a base payload
            'v=1             // Version.
            '&tid=UA-XXXX-Y  // Tracking ID / Property ID.
            '&cid=555        // Anonymous Client ID.
            '&t=             // Hit Type.
            '&cd{x} =        // any default custom dimension
            gaCreateBasePayload: Function() As String
                base = "v=" + AnyToString( m.gaConfig.version) + "&tid=" + AnyToString(m.gaConfig.trackingId) + "&cid=" + AnyToString(m.gaConfig.clientId)
                if isString(m.gaConfig.appName) then
                    base = base + "&an=" + HttpEncode(m.gaConfig.appName)
                end if

                if isString(m.gaConfig.appVersion) then
                    base = base + "&av=" + HttpEncode(m.gaConfig.appVersion)
                end if

                if isArray(m.gaConfig.cds) then
                    base = base + gaArrayCustomDimensionTrackingPL(m.gaConfig.cds)
                end if
                return base
            End Function

            gaCombineArgs: Function(path="" As String, prefix="" As String,  input="" As String) As String
                 If  input <> ""  And prefix<>"" Then
                    return path + prefix + HttpEncode(input)
                else
                    return path
                end if
            End Function

            'create a payload for ScreenView Tracking
            '&cd=Log in  // screenName.
            gaScreenViewTrackingPL: Function(screenName="" As String) As String
                path = m.gaCombineArgs("&t=screenview",  "&cd=", screenName)
                return path
            End Function

            'create a payload for page Tracking
            '&dh=mydemo.com  // Document hostname.
            '&dp=/home       // Page.
            '&dt=homepage    // Title.
           gaPageTrackingPL: Function(hostname="" As String, page="" As String, pTitle="" As String) As String
                path = m.gaCombineArgs("&t=pageview",  "&dh=", hostname)
                path = m.gaCombineArgs(path,  "&dp=", "/"+page)
                path = m.gaCombineArgs(path,  "&dt=", pTitle)
                return path
            End Function

            'create a payload for Event Tracking
            '&ec=video       // Event Category. Required.
            '&ea=play        // Event Action. Required.
            '&el=holiday     // Event label.
            '&ev=300         // Event value.
            gaEventTrackingPL: Function (category="" As String, action="" As String, label="" As String, value="" As String) As String
                path = m.gaCombineArgs("&t=event",  "&ec=", category)
                path = m.gaCombineArgs(path,  "&ea=", action)
                path = m.gaCombineArgs(path,  "&el=", label)
                path = m.gaCombineArgs(path,  "&ev=", value)
                return path
            End Function

            'Create a customDimension payload,  a maximum of 20 custom dimensions (200 for Premium ]
            'cd<dimensionIndex>=Sports
            gaCustomDimensionTrackingPL: Function( dimensionIndex="" As string, value="" As dynamic) As String
                value = AnytoString(value)
                if isString(dimensionIndex) and isString(value) then
                    return  "&" + dimensionIndex +"=" + HttpEncode(value)
                end if
                return ""
            End Function

            'Create a customDMetric payload, a maximum of 20 custom metrics (200 for Premium accounts).
            'cm<metricIndex>=47
            gaCustomMetricTrackingPL: Function (metricIndex="" As string, value="" As dynamic) As String
                if isString(metricIndex) and isInteger(value) then
                    return "&" + metricIndex +"=" + AnyToString(value)
                end if
                return ""
            End Function

            'Create an array of payload into string,
            gaArrayCustomDimensionTrackingPL: Function(cds as Object) as String
                path = ""
                if valid(cds) then
                    for each index in  cds
                        path = path + m.gaCustomDimensionTrackingPL(index, cds[index])
                    End for
                end if
                return path
            end function

            'return all customs as payload and reset the custom buffer
            gaFlushCustoms: Function() As String
                path = ""

                for each index in  m.gaCustom.dimension
                    path = path + m.gaCustomDimensionTrackingPL(index, m.gaCustom.dimension[index])
                End for

                for each index in  m.gaCustom.metric
                    path = path + m.gaCustomMetricTrackingPL(index, m.gaCustom.metric[index])
                End for

                m.gaResetCustom()

                return path
            End Function


            'Prepare the param and send Post or Get Api call
            gaApiCall: Function(payLoad="" As String) As Object

                If m.gaConfig.cacheBusting = true then
                    payLoad =  payLoad + "&z=" + AnyToString(Rnd(999999))
                End If

                'attach custom varables If exist
                If not m.gaCustom.dimension.IsEmpty() OR not m.gaCustom.metric.IsEmpty() then
                    payLoad = payLoad + m.gaFlushCustoms()
                End If

                'debug Mode
                if m.debug then
                    baseUrl = m.gaConfig.baseUrl + "/debug/collect"
                else
                    baseUrl = m.gaConfig.baseUrl + "/collect"
                end if

                'print payLoad
                If  m.gaConfig.apiMethod = "GET" then
                    path = baseUrl + "?" + payLoad
                    return m.gaRequest(path, m.gaConfig.apiMethod)
                else
                    path = baseUrl
                    return m.gaRequest(path, m.gaConfig.apiMethod, payLoad)
                End If

            End Function

            'request the event
            gaRequest: function (url as String, method as String, body=invalid as Object) as object
                print method; " "; url
                request = getHttpService().request(url, {
                    method: method
                    postBody: body
                }).done()
                m.requests.push(request)
            end function

            'reset the custom varables
            gaResetCustom: Function() as void
                m.gaCustom = {
                    dimension : {} 'for storing custom dimension,
                    metric : {} 'for storing custom metrics,
                }
            End Function
        }
    end if
    return m.ga
end Function
