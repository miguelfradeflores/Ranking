-----------------------------------------------------------------------------------------
--
-- title.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local database = require('database')
local emitterParams = require("emitter")
--------------------------------------------
local _W = display.contentWidth
local _H = display.contentHeight
-- forward declaration
local background, pageText,podioGroup,scoreGroup
local alumnos = {}
local imagePath = "src/assets/"
local casillas = {}
local first,second,third, first_mame, second_name, third_name
-- Touch listener function for background object



local function onBackgroundTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		-- go to page1.lua scene
		composer.gotoScene( "page1", "slideLeft", 800 )		
		return true	-- indicates successful touch
	end
end

local inicioTablaY = 150

function compare(a,b)
	if a.score > b.score then
	  return a['score'] > b['score']
	elseif b.score < a.score then
		return b.score < a.score 
	elseif a.score == b.score then
		return a.name < b.name
	end
end

function showAchievements( self,e )

	if e.phase =="ended" or e.phase == "cancelled" then
		print( self.id, self.name )
		composer.gotoScene( "scoreboard" , {
			effect = "fade",
			time = 500,
			params = {
				score = 0,
				name = self.name,
				id = self.id
				}
			} )
	end
	return true
end




function scene:create( event )
	local sceneGroup = self.view
	 podioGroup = display.newGroup( )
	 scoreGroup = display.newGroup()
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local gradient = {
    type="gradient",
    color1={ 1, 0.8, 1 }, color2={ 0.2, 0.1 , 0.2 }, direction="down"
	}
	-- display a background image
--	background = display.newImageRect( sceneGroup, "cover.jpg", display.contentWidth, display.contentHeight )
	background = display.newRect(0,0,_W,_H)
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	background:setFillColor(0.45,0.25,012,0.43)
--	background:setFillColor(gradient)
	sceneGroup:insert( background )

	local titulo = display.newText(sceneGroup, "INFOGRAFIA", _W/2,80,system.nativeFont, 50 ) 
	titulo:setTextColor(gradient)


	local id_num = display.newRect(scoreGroup, 10, inicioTablaY, 60,30)
	id_num.anchorX = 0
	id_num:setFillColor(0)
	id_num:setStrokeColor(1)
	id_num.strokeWidth=3

	local id_tex = display.newText( scoreGroup, "#", id_num.x + 15, inicioTablaY,"arial", 20 )
	id_tex:setFillColor( 1 )

	local encabezado = display.newRect(scoreGroup, 160,inicioTablaY ,220,30)
	encabezado:setFillColor(0)
	encabezado:setStrokeColor(1)
	encabezado.strokeWidth=3
	local texto = display.newText(scoreGroup,"ALUMNO", 160,inicioTablaY,"arial",20)
	texto:setFillColor(1,0,0)
	
	local box2 = display.newRect(scoreGroup, 160+encabezado.x, inicioTablaY ,80,30)
	box2.originX = 0
	box2:setFillColor(0)
	box2:setStrokeColor(1)
	box2.strokeWidth=3
	local score = display.newText(scoreGroup, "Puntaje", box2.x, inicioTablaY,"arial",20)
	score:setFillColor(1,0,0)

	local avatar_box = display.newRect( scoreGroup, box2.x+40, inicioTablaY, 80, 30 )
	avatar_box.anchorX=0
	avatar_box:setFillColor( 0 )
	avatar_box:setStrokeColor( 1 )
	avatar_box.strokeWidth = 3

	local avatar_tittle = display.newText( scoreGroup,"ICON", box2.x+60, inicioTablaY, "arial", 20 )
	avatar_tittle.anchorX=0
	avatar_tittle:setFillColor( 1 )




	local podio = display.newLine(podioGroup, _W/2 -50, _H/2+80, _W/2+100, _H/2+80)
	podio:append(_W/2+100,_H/2, _W/2+250,_H/2,_W/2+250,_H/2+100,_W/2+400,_H/2+100)
	podio:append(_W/2+400,_H/2+240,_W/2 - 50,_H/2+240,_W/2 -50,_H/2+80 )
	podio:setStrokeColor(1)
	podio.strokeWidth = 3

	first = display.newImageRect(podioGroup, imagePath.. "Oro.png", 150, 150)
	first.x = _W/2+ 175
	first.y = _H/2 + 80

	second = display.newImageRect(podioGroup, imagePath.. "Plata.png", 140, 140)
	second.x = _W/2+ 30
	second.y = _H/2 + 160


	third = display.newImageRect(podioGroup, imagePath.. "Bronce.png", 120, 120)
	third.x = _W/2+ 330
	third.y = _H/2 + 180



	podioGroup.x = 80
	sceneGroup:insert( scoreGroup )
	sceneGroup:insert( podioGroup )

		alumnos = database.cargarParticipantes()

		table.sort( alumnos, compare )
		for i = 1,#alumnos do
			--print(alumnos[i])

			casillas[i]  = display.newRect(scoreGroup, 160,inicioTablaY+(i*40) ,220,50)
			casillas[i]:setFillColor(0)
			casillas[i]:setStrokeColor(1)
			casillas[i].strokeWidth=3
			casillas[i].id = alumnos[i].id
			casillas[i].name = alumnos[i].name
			casillas[i].touch = showAchievements
			casillas[i]:addEventListener( "touch", casillas[i] )

			casillas[i].alumn_name = display.newText(scoreGroup,"".. alumnos[i].name, 160,inicioTablaY +(i*40),"arial",20)
			casillas[i].alumn_name:setFillColor(1,1,1)

			casillas[i].num_box = display.newRect(scoreGroup, 10,inicioTablaY+(i*40) ,60,50)
			casillas[i].num_box:setFillColor(0)
			casillas[i].num_box:setStrokeColor(1)
			casillas[i].num_box.strokeWidth=3
			casillas[i].num_box.anchorX = 0

			casillas[i].num_text = display.newText(scoreGroup,"".. i, casillas[i].num_box.x+18  ,inicioTablaY +(i*40)-2,"arial",20)
			casillas[i].num_text:setFillColor(1)

			local box2 = display.newRect(scoreGroup, 160+casillas[i].x,inicioTablaY+(i*40) ,80,50)
			box2.originX = 0
			box2:setFillColor(0)
			box2:setStrokeColor(1)
			box2.strokeWidth=3
			casillas[i].score = display.newText(scoreGroup,"".. alumnos[i].score, box2.x, inicioTablaY +(i*40),"arial",20)
			casillas[i].score:setFillColor(1,1,1)
			local avatar_box = display.newRect(scoreGroup, box2.x+80,inicioTablaY+(i*40) ,80,50)
			avatar_box.originX = 0
			avatar_box:setFillColor(0)
			avatar_box:setStrokeColor(1)
			avatar_box.strokeWidth=3

			local avatar = display.newImageRect(scoreGroup, alumnos[i].avatar, 45,45 )
			avatar.x = avatar_box.x
			avatar.originX = 0
			avatar.y = avatar_box.y
			

		end

		-- first_mame = display.newImageRect(podioGroup, alumnos[1].avatar, 100,100)
		-- first_mame.x = first.x; first_mame.y = first.y -150

		-- second_name = display.newImageRect(podioGroup, alumnos[2].avatar, 100,100)
		-- second_name.x = second.x; second_name.y = second.y -150
		
		-- third_name = display.newImageRect(podioGroup, alumnos[3].avatar, 100,100)
		-- third_name.x = third.x; third_name.y = third.y -150
		scoreGroup.x = 20
		scoreGroup.y = -20

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		table.remove( alumnos )

		alumnos = database.cargarParticipantes()
		print("Size of table ", #alumnos)

	elseif phase == "did" then

		if alumnos then
			table.sort( alumnos, compare )
		end

		for i = 1,#alumnos do
			casillas[i].score.text ="" .. alumnos[i].score
		end

		first_mame = display.newImageRect(podioGroup, alumnos[1].avatar, 100,100)
		first_mame.x = first.x; first_mame.y = first.y -150

		second_name = display.newImageRect(podioGroup, alumnos[2].avatar, 100,100)
		second_name.x = second.x; second_name.y = second.y -150
		
		third_name = display.newImageRect(podioGroup, alumnos[3].avatar, 100,100)
		third_name.x = third.x; third_name.y = third.y -150



	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		
	elseif phase == "did" then
		-- Called when the scene is now off screen

		display.remove( first_mame )
		display.remove( second_name )
		display.remove( third_name )

		table.remove( alumnos )

	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene