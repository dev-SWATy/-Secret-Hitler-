swatScore = {}
check_string = '✓'
swatEnabled = false

--[[

Playerlist in order of when they joined
made by 55tremine

I thought this would be harder since I didnt know the getplayers
went by join order. (or the server id for players)

]]--

parameters = {
	click_function="nilFunction", 
	function_owner=self,
	rotation={0,0,0},
	height=0, 
	width=0,
	font_size = 350,
	scale = {0.212, 0, 0.1169},--{0.2,0,0.33},
	font_color = stringColorToRGB("White")
}


function onLoad()
	makeDisplay()
end

function onPlayerConnect(person)
	updateOnJoin()

end

function onPlayerDisconnect()
	updateOnJoin()
end

--this is needed only because onPlayerConnect is broken
function updateOnJoin()
	Timer.destroy(self.getGUID().."ReDisplay")
	local parameters = {}
	
	parameters.identifier = self.getGUID().."ReDisplay"
	parameters.function_name = 'makeDisplay'
	parameters.delay = 1
	Timer.create(parameters)
end

function onDestroy()
	Timer.destroy(self.getGUID().."ReDisplay")
end

function onPlayerChangeColor(color)
	makeDisplay()
end




function makeDisplay()
	self.clearButtons()

	parameters.font_color = stringColorToRGB("White")
	parameters.label="Players" --Players
	parameters.font_size = 350
	parameters.position={0, 0.55, -0.42}
	self.createButton(parameters)

	makeSquareButtonLabel(self, swatEnabled, check_string, '', "Enable Swat Buttons", "swatFlip", { .4, 0.55, -0.42 } , .41, true)
	if swatEnabled then 
		makeSquareButtonLabel(self, '', '', '', "Reset", "swatReset", { .4, 0.55, -0.42 + .05} , .15, true)
	end

	parameters.font_size = 150
	onNum = 0
	for i, playerObj in pairs(Player.getPlayers()) do
		--Player["Blue"].broadcast(i)
		parameters.label= i..". "..playerObj.steam_name --Players
		parameters.position={0, 0.55, -0.32+onNum*0.045}
		if (playerObj.seated) then
			parameters.font_color = stringColorToRGB(playerObj.color)
		else
			parameters.font_color = stringColorToRGB("Grey")
		end
		self.createButton(parameters)
		if swatEnabled then
			newFuncName = "click" .. playerObj.steam_id
			_G[newFuncName] = function(o, p, a) swatScoreClick(o, p, a, playerObj.steam_id) end
			--_G[function_name] = function(o, p, a) my_click(o, p, a, button_data.extra_info) end
			if not swatScore[playerObj.steam_id] then
				swatScore[playerObj.steam_id] = 0
			end
			makeSquareButtonLabel(self, '', '', '', swatScore[playerObj.steam_id], newFuncName, { .4, .55, -0.32+onNum*0.045 } , .075, true)
		end
		
		onNum = onNum + 1
	end
end

function nilFunction()
	return false
end

function swatFlip(obj, color, alt_click)
	if Player[color].admin then
		swatEnabled = not swatEnabled
		makeDisplay()
	end
end

function swatScoreClick(obj, color, alt_click, playerClicked)
	if Player[color].admin then
		if not alt_click then
			swatScore[playerClicked] = swatScore[playerClicked] + 1
		else
			swatScore[playerClicked] = swatScore[playerClicked] - 1
		end
		makeDisplay()
	end
end

function swatReset(obj, color, alt_click)
	if Player[color].admin then
		for k in pairs(swatScore) do
			swatScore[k] = nil
		end
		makeDisplay()
	end

end

function makeSquareButtonLabel(objectIn, valueIn, trueButtonTextIn, falseButtonTextIn, labelTextIn, clickFunctionIn, buttonPositionIn, textOffsetIn, enabledIn, toolTip)
	local buttonParam = {
		rotation = {0, 0, 0},
		width = 200,
		height = 200,
		font_size = 350,
        scale = {0.15, 0, 0.1169},
		function_owner = self,
		click_function = clickFunctionIn,
		position = buttonPositionIn
	}

	
	local textParam = {
		label = labelTextIn,
		font_color = stringColorToRGB("White"),
		rotation = {0, 0, 0},
		width = 0,
		height = 0,
		font_size = 250,
        scale = {0.15, 0, 0.1169},
		function_owner = self,
		click_function = 'nullFunction',
		position = {buttonPositionIn[1] + textOffsetIn, buttonPositionIn[2], buttonPositionIn[3]}
	}
	if valueIn then
		buttonParam.label = trueButtonTextIn
	else
		buttonParam.label = falseButtonTextIn
	end
	if not enabledIn then
		--buttonParam.click_function = 'nullFunction'
		buttonParam.color = stringColorToRGB('Grey')
		buttonParam.font_color = {0.3, 0.3, 0.3}
		textParam.font_color = {0.3, 0.3, 0.3}
	end
	objectIn.createButton(buttonParam)
	objectIn.createButton(textParam)
end