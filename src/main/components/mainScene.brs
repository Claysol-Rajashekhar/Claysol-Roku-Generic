function init()
	print "Inside main Scene"
	screenInit()
	m.top.setFocus(true)
	
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
	handled = false
	if press then
	?"key pressed = " key
		if key = "down" then
			
		else if key = "up" then
			
		else if key = "OK" then
			stopSpinner()
			button = m.top.findNode("detailpageButton")
			button.setFocus(true)
			button.observefield("buttonSelected","showDetailPage")
			'handled = true
		else if key = "back" then
			m.detailScreen.setFocus(false)
			m.detailScreen.visible = false
			m.button.visible = true
			m.button.setFocus(true)
			handled = true
		end if
	end if
	return handled
end function