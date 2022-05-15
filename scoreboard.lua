local composer = require( "composer" )
local scene = composer.newScene()
local database = require('database')
--------------------------------------------
local _W = display.contentWidth
local _H = display.contentHeight
-- forward declaration
local background, pageText,podioGroup,scoreGroup
local imagePath = "src/assets/"

local achievementsGroup
local playerAchievements

local logros = {}
local increaseButtons = {}
local decreaseButtons = {}
local baseH = 100

local distance = 50
local popup
local canTouch = true

function backToMenu( e )
	
	if e.phase == "ended" or e.phase == "cancelled" then
		composer.gotoScene( "title"  )
	end
	return true
end

function blinkPopUp(  )
	popup.alpha = 1
	canTouch = true
	transition.to(popup, {time = 2000, alpha =0})
end

function increaseValue( self,e )
	if (e.phase == "began") then

	elseif (e.phase == "ended" or e.phase == "cancelled") then
		print(self.id_competencia, self.id_jugador, self.score)
		if canTouch then
			canTouch = false
			database.aumentarScoreJugador({
				id = self.id_jugador,
				id_competencia = self.id_competencia,
				score = self.score,
				value = self.value
				})
			database.updateGlobalScore()
			blinkPopUp()
			self.score = self.score + self.value
			self.score_text.text = ""..self.score
		end
	end

	return true
end


function compare_achievements(a,b)
	if a.score > b.score then
	  return a['score'] > b['score']
	elseif b.score < a.score then
		return b.score < a.score 
	elseif a.score == b.score then
		return a.competencia > b.competencia
	end
end




function scene:create( event )
	local sceneGroup = self.view

	local background = display.newRect( sceneGroup, _W/2, _H/2, _W, _H )
	background:setFillColor( 0.42 )

	local backBbutton = display.newImage( sceneGroup,  imagePath.. "atras.png",50 ,50   )
	backBbutton.x = 60
	backBbutton:addEventListener( "touch", backToMenu )

	playerAchievements = display.newText( sceneGroup, "", _W/2, _H/10,"arial", 30  )
	playerAchievements:setFillColor( 0,24, 0.12, 0.86 )
	popup = display.newText( sceneGroup, "DONE", _W/2, _H/2, "arial black", 50 )
	popup.alpha = 0
	popup:setFillColor( 0,0.88,0.22 )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	


	if phase == "will" then
		for i, v in pairs(event.params) do
			print(i,v)
		end
		canTouch = true
		playerAchievements.text = "Achievements for " .. event.params.name
	elseif phase == "did" then


		logros = database.getAchievements(event.params.id)

		table.sort( logros, compare_achievements )

		for i=1,#logros do
			print( "logros de " .. event.params.name )
			-- for k,v in pairs(logros[i]) do
			-- 	print(k,v)
			-- end

			local competencia = display.newText( sceneGroup, "Competencia " .. logros[i].competencia .. ": " , _W/8, baseH + (distance *i), "arial", 20,"left" )
			competencia.anchorX = 0

			local actualScore = logros[i].score
			local trophy

			if actualScore == 0 then
				trophy = display.newImageRect( sceneGroup, imagePath .."Bronce.png", 45, 45 )
				trophy:setFillColor( 0.2 )
			elseif actualScore < 3 then 
				trophy = display.newImageRect( sceneGroup, imagePath .."Bronce.png", 45, 45 )

			elseif actualScore < 5 then
				trophy = display.newImageRect( sceneGroup, imagePath .."Plata.png", 45, 45 )

			elseif actualScore>=5 then
				trophy = display.newImageRect( sceneGroup, imagePath .."Oro.png", 45, 45 )

			end 

			trophy.x = _W/2; trophy.y = competencia.y

--			increaseButtons[i] = display.newRect(sceneGroup, _W*0.75, competencia.y, 50, 50  )
			increaseButtons[i] = display.newImageRect( sceneGroup, "plusButton.png", 45, 45 )
			increaseButtons[i].x = _W*0.75; increaseButtons[i].y = competencia.y
			--increaseButtons[i]:setFillColor( 0,1,0.22 )
			increaseButtons[i].id_jugador = logros[i].id_jugador; increaseButtons[i].id_competencia = logros[i].id_competencia
			increaseButtons[i].score = logros[i].score
			increaseButtons[i].score_text = display.newText( sceneGroup, "".. increaseButtons[i].score, _W*0.6, competencia.y, "arial", 30 )
			increaseButtons[i].touch = increaseValue
			increaseButtons[i].truphy = trophy
			increaseButtons[i].value = 1
			increaseButtons[i]:addEventListener( "touch", increaseButtons[i] )

			decreaseButtons[i] = display.newImageRect( sceneGroup, "lessButton.png", 45, 45 )
			decreaseButtons[i].id_jugador = logros[i].id_jugador; decreaseButtons[i].id_competencia = logros[i].id_competencia
			decreaseButtons[i].x = _W*0.85; decreaseButtons[i].y = competencia.y
			decreaseButtons[i].value = -1
			decreaseButtons[i].score_text = increaseButtons[i].score_text 
			decreaseButtons[i].score = logros[i].score
			decreaseButtons[i].touch = increaseValue
			decreaseButtons[i]:addEventListener( "touch", decreaseButtons[i] )


		end

	end


end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then

		
	elseif phase == "did" then

	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene

