function init()
	?"Inside detail page"
	m.response = {
		"image":"pkg:/resources/images/common/image1.jpg"
		"title":"Baahubali 2"
		"description":"Baahubali 2: The Conclusion (English: The One with Strong Arms) is an upcoming Indian epic historical fiction film directed by S. S. Rajamouli. It is the continuation of Baahubali: The Beginning. Initially, both parts were jointly produced on a budget of 250 crore (2.5 billion), however the budget of the second part was increased later. Baahubali 2: The Conclusion has made a business of 500 crore (5 billion) before release. The film is scheduled for a worldwide release on 28 April 2017. Baahubali 2 will be the first Telugu film to be released in 4K High Definition format. It is estimated that close to 200 screens are being upgraded to 4K projectors before the release date of the movie."
		"year":"2017"
		"duration":"120 min"
		"rating":"5"
		"value": "Drama"
		"cast":"Director, Actor"
		"rating": "4.3"
		"url" : "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4" 
		}
	design = "type2"
	m.coordinates = getCoordinates(design)
	loadDetailScreen()
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
	
	handled = false
	if press
		?"inside detail page key"
		if key = "OK" then
			contentNode = createObject("roSGNode", "ContentNode")
			contentNode.streamFormat = "mp4"
			contentNode.title = m.response.title
			contentNode.url = m.response.url

			video = m.top.getParent().findNode("video")
			video.content = contentNode
			video.visible = true
			video.setFocus(true)
			m.top.setFocus(false)
			m.top.visible = false
			video.control = "Play"
			handled = true
		else if key = "down" then
			
		else if key = "up" then

		else if key = "back" then
			
		end if
	end if
	return handled
end function

function loadDetailScreen()

	for i = 0 to m.top.getChildCount()-1
		if m.top.getChild(i).id = "image" then
			image = m.top.getChild(i)
			if valid(m.response.image) then
				image.uri = m.response.image
			end if
			image.width = m.coordinates.image.width
			image.height = m.coordinates.image.height
			image.translation = [m.coordinates.image.x, m.coordinates.image.y]
		else if m.top.getChild(i).id = "playButton" then
			playButton = m.top.getChild(i)
			playButton.uri = "pkg:/resources/images/common/play.png"
			playButton.translation = [m.coordinates.play.x, m.coordinates.play.y]
		else if m.top.getChild(i).id = "title" then
			title = m.top.getChild(i)
			if valid(m.response.title) then
				title.text = m.response.title
			end if
			title.translation = [m.coordinates.title.x, m.coordinates.title.y]
		else if m.top.getChild(i).id = "description" then
			description = m.top.getChild(i)
			if valid(m.response.description) then
				description.text = m.response.description
			end if
			description.wrap = true
			description.maxLines = 4
			description.width = m.coordinates.description.width
			description.translation = [m.coordinates.description.x, m.coordinates.description.y]
		else if m.top.getChild(i).id = "cast" then
			cast = m.top.getChild(i)
			cast.translation = [m.coordinates.cast.x, m.coordinates.cast.y]
			if valid(m.response.cast) then
				cast.text = m.response.cast
			end if
		else if m.top.getChild(i).id = "type" then
			value = m.top.getChild(i)
			if valid(m.response.value) then
				value.text = m.response.value + "   |"
				value.translation = [m.coordinates.value.x, m.coordinates.value.y]
			end if
		else if m.top.getChild(i).id = "year" then
			year = m.top.getChild(i)
			if valid(m.response.year) then
				year.text = m.response.year + "   |"
				year.translation = [m.coordinates.year.x, m.coordinates.year.y]
			end if
		else if m.top.getChild(i).id = "duration" then
			duration = m.top.getChild(i)
			if valid(m.response.duration) then
				duration.text = m.response.duration + "  |"
			end if
			duration.translation = [m.coordinates.duration.x, m.coordinates.duration.y]
		else if m.top.getChild(i).id = "rating" then
			rating = m.top.getChild(i)
			if valid(m.response.rating) then
				rating.text = m.response.rating
			end if
			rating.translation = [m.coordinates.rating.x, m.coordinates.rating.y]
		else if m.top.getChild(i).id = "focused" then
			focused = m.top.getChild(i)
			focused.translation = [m.coordinates.focused.x, m.coordinates.focused.y]
		end if

	end for
end function

function getCoordinates(design="" as string) as object

	if design <> "" and design = "type1" then
		coordinates = {
			image : {
				x: scale(20)
				y: scale(20)
				width: scale(1900)
				height: scale(1050)
			}
			title : {
				x: scale(100)
				y: scale(520)
			}
			description : {
				x: scale(100)
				y: scale(650)
				width: scale(900)
			}
			value : {
				x: scale(100)
				y: scale(580)
			}
			year : {
				x: scale(390)
				y: scale(580)
			}
			duration : {
				x: scale(250)
				y: scale(580)
			}
			cast : {
				x: scale(100)
				y: scale(610)
			}
			rating : {
				x: scale(500)
				y: scale(580)
			}
			focused : {
				x : scale(100)
				y : scale(850)
			}
			play : {
				x : scale(100)
				y : scale(850)
			}
		}
	else if design = "type2" then
		coordinates = {
			image : {
				x: scale(100)
				y: scale(100)
				width: scale(800)
				height: scale(550)
			}
			title : {
				x: scale(100)
				y: scale(700)
			}
			description : {
				x: scale(100)
				y: scale(850)
				width: scale(1700)
			}
			value : {
				x: scale(100)
				y: scale(750)
			}
			year : {
				x: scale(300)
				y: scale(750)
			}
			duration : {
				x: scale(420)
				y: scale(750)
			}
			cast : {
				x: scale(100)
				y: scale(800)
			}
			rating : {
				x: scale(550)
				y: scale(750)
			}
			focused : {
				x : scale(1100)
				y : scale(200)
			}
			play : {
				x : scale(1100)
				y : scale(200)
			}
		}
	else
		coordinates = {
			image : {
				x: scale(100)
				y: scale(100)
				width: scale(800)
				height: scale(600)
			}
			title : {
				x: scale(1000)
				y: scale(100)
			}
			description : {
				x: scale(1000)
				y: scale(300)
				width: scale(600)
			}
			value : {
				x: scale(1000)
				y: scale(200)
			}
			year : {
				x: scale(1150)
				y: scale(200)
			}
			duration : {
				x: scale(1250)
				y: scale(200)
			}
			cast : {
				x: scale(1000)
				y: scale(250)
			}
			rating : {
				x: scale(1400)
				y: scale(200)
			}
			focused : {
				x : scale(1000)
				y : scale(500)
			}
			play : {
				x : scale(1000)
				y : scale(500)
			}
		}
	end if
	return coordinates
end function