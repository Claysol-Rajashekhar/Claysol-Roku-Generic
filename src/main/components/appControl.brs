 function screenInit()
	m.top.backgroundUri=""
	m.top.backgroundColor="0x000000ff"
	m.detailScreen = m.top.findNode("detail")
	m.button = m.top.findNode("detailpageButton")
	initSpinner()
end function

function initSpinner()
	?"startSpinner"
	loader = getLoader()
	m.top.appendChild(loader)

	m.timer = getTimer("0.1")
	m.timer.control = "start"
	m.timer.observefield("fire","spinnerUpdate")
	m.count = 0
	m.top.appendChild(m.timer)
end function

function spinnerUpdate()
	m.count = (m.count + 1) mod 12
	for i = 0 to m.top.getChildcount()-1
		if m.top.getChild(i).id = "spinner"
			index = i
			exit for
		end if
	end for
	if index <> invalid then
		m.top.getChild(index).uri = "pkg:/resources/images/common/loader/loading" + m.count.toStr() + ".png"
	end if
end function

function getLoader() as object
	spinner = createObject("roSGNode","Poster")
	spinner.id = "spinner"
	spinner.translation = [scale(900),scale(550)]
	spinner.uri = "pkg:/resources/images/common/loader/loading0.png"
	return spinner
end function

function getTimer(duration as object) as object
	timer = createObject("roSGNode","timer")
	timer.duration = duration
	timer.repeat = "true"
	return timer
end function

function stopSpinner()
	?"stopSpinner"
	for i = 0 to m.top.getChildcount()-1
		if m.top.getChild(i).id = "spinner"
			index = i
			exit for
		end if
	end for
	if index <> invalid then
		m.top.getChild(index).visible = false
	end if
end function

function startSpinner()
	?"startSpinner"
	for i = 0 to m.top.getChildcount()-1
		if m.top.getChild(i).id = "spinner"
			index = i
			exit for
		end if
	end for
	if index <> invalid then
		m.top.getChild(index).visible = true
	end if
end function

function showDetailPage()
	m.detailScreen.setFocus(true)
	m.detailScreen.visible = true
	m.top.setFocus(false)
	for i = 0 to m.detailScreen.getChildcount()-1
		if m.detailScreen.getChild(i).id = "playButton" then
			m.detailScreen.getChild(i).setFocus(true)
			exit for
		end if
	end for
	m.button.visible = false
end function


function getDeviceResolution() as object
    di = createObject("roDeviceInfo")
    resolution = di.GetDisplaySize()
    return resolution
end function

