function init()
	?"inside videoscreen"
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
	
	handled = false
	if press
		?"inside video key"
		if key = "OK" then
			handled =true
		else if key = "down" then
			
		else if key = "up" then

		else if key = "back" then
			detailScreen = m.top.getParent().findNode("detail")
			detailScreen.visible = true
			detailScreen.setFocus(true)
			m.top.setFocus(false)
			m.top.visible = false
			handled = true
		end if
	end if
	return handled
end function