
'
'   Initialise the application
'   Start the first screen
'   @param {AA} [args] - Information for deep-linking
'
sub main(args as Dynamic)
    ' Initialize the app
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    scene = screen.CreateScene("mainScene")
    screen.show()

    while(true)
        msg = wait(0, m.port)
		msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub
