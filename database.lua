module(..., package.seeall)

local _W = display.contentWidth
local _H = display.contentHeight
local sqlite3 = require ("sqlite3")

--Path to store the db file
local pathsql="recursos.sqlite"
local path = system.pathForFile(pathsql, system.DocumentsDirectory)

local jugadores = "jugadores"
local competencias = "competencias"
local rendimiento = "rendimiento"

function createDatabase( )
	--Open the DB to create tables
	 db = sqlite3.open( path ) 
	 -- creacion de tablas

	 local table1 = "create table if not exists " .. jugadores .. "(id_jugador integer PRIMARY KEY AUTOINCREMENT, name VARCHAR(50), score integer(60), avatar VARCHAR(50) );"
	 local table2 = "create table if not exists " .. competencias .. "(id_competencia integer PRIMARY KEY AUTOINCREMENT, name VARCHAR(50) );"
	 local table3 = "create table if not exists " .. rendimiento .. "(id_rendimiento integer PRIMARY KEY AUTOINCREMENT, id_competencia integer, id_jugador integer, score integer(4) );"

	 db:exec( table1)
	 db:exec( table2)
	 db:exec( table3)

	 db:close()
end

function addParticipante( params )
	db = sqlite3.open( path ) 
--	print(params)
	local query = "INSERT INTO " .. jugadores .. " (name, score, avatar) VALUES ('".. params.name .. "', " .. params.score .. ",'".. params.avatar.."');"
	db:exec(query)
--	print("executed")
	db:close()	
end


-- local participantes = {
-- 	{name="Benjamin Soto", score=0, avatar = 'benjamin.jpg' },
-- 	{name="Valeria Succi", score=0, avatar = 'vale.png'},
-- 	{name="Rosa Zambrana ", score=0,avatar = 'vale.png' },
-- 	{name="Sergio Perez", score=0, avatar = 'vale.png' },
-- 	{name="Sergio Bellot", score=0, avatar = 'vale.png'},
-- 	{name="Sergio Marzana", score=0, avatar = 'vale.png'},
-- 	{name="Paola Rivas", score=0, avatar = 'vale.png'},
-- 	{name="Luis Choque", score=0, avatar = 'vale.png'}
-- }

-- local alumnos = {
--     {name="MAURICIO A.", score=0, avatar = 'mauriA.png' },
-- 	{name="ROBERTO", score=0, avatar = 'roberto.png' },
-- 	{name="JORDI", score=0, avatar = 'jordi.jpg' },
-- 	{name="KEN", score=0, avatar = 'ken.png' },
-- 	{name="CESAR", score=0, avatar = 'cesar.png' },
-- 	{name="PAOLO", score=0, avatar = 'default.jpg' },
-- 	{name="SERGIO", score=0, avatar = 'default.jpg' },
-- 	{name="JORGE", score=0, avatar = 'default.jpg' },
-- 	{name="ENRIQUE", score=0, avatar = 'default.jpg' },
-- 	{name="FERNANDA", score=0, avatar = 'fernanda.jpg' },
-- 	{name="NURIA", score=0, avatar = 'nuria.jpg' },
-- 	{name="WEIMAR", score=0, avatar = 'default.jpg' },
-- 	{name="MAURICIO V.", score=0, avatar = 'default.jpg' },
-- 	{name="CHRISTOPHER", score=0, avatar = 'default.jpg' }
-- }

local alumnos = {
    {name="Erick A.", score=0, avatar = 'default.jpg' },
	{name="PATRICK", score=0, avatar = 'default.jpg' },
	{name="CAMILO", score=0, avatar = 'default.jpg' },
	{name="ERICK M.", score=0, avatar = 'default.jpg' },
	{name="LUCIANA", score=0, avatar = 'default.jpg' },
	{name="MICHAEL", score=0, avatar = 'default.jpg' },
	{name="KEVIN", score=0, avatar = 'default.jpg' },
	{name="RAISA", score=0, avatar = 'default.jpg' },
	{name="LIZZETH", score=0, avatar = 'default.jpg' }
}
local valoresCompetencias = {
	'Parcipacion',
	'Puntualidad',
	'Conocimientos Previos',
	'Conocimientos Nuevos',
	'Colaboracion',
	'Corregir al docente',
	'Ayudar compañero',
	'Curioso impaciente',
	"Mejor_Diseño",
	"Mejor Dcoumentacion",
	"Primero en entregar",
	"Validar detalles de tareas"
}


function insertarrCompetencias( param )
	db = sqlite3.open( path )
	--print(param)
	local sql =  "INSERT into " .. competencias .. " (name) VALUES ('" ..param .." ')"
	db:exec(sql)
	db:close()
end

function insertarrRendimiento( competencia, jugador )
	db = sqlite3.open( path )
--	print(competencia,jugador)
	local sql =  "INSERT into " .. rendimiento .. " (id_competencia, id_jugador,score) VALUES (" ..competencia ..",  " .. jugador .. ",0 )"
	db:exec(sql)
	db:close()
end


function cargarParticipantes(  )
	db = sqlite3.open( path ) 
	participantes = {}
	local query = "SELECT * FROM " .. jugadores .. ";"
	local k = 1
	print("starting look")
	for row in db:nrows(query) do
		participantes[k] = {id = row.id_jugador, name=row.name, score = row.score, avatar = row.avatar}
		k = k+1
	end

	db:close()	
	return participantes
end




function iniciarBaseDeDatos(  )
	for i=1,#alumnos do
		addParticipante(alumnos[i])
	end

	for i=1,#valoresCompetencias do
--		print(valoresCompetencias[i])
		insertarrCompetencias(valoresCompetencias[i])
	end

	for i=1,#alumnos do
		for j=1,#valoresCompetencias do
			insertarrRendimiento(j,i)
		end
	end


end

function obtenerJugador( id )

	db = sqlite3.open( path ) 
	jugador = {}	

	local query = "SELECT * FROM " .. jugadores .. " WHERE id_jugador = " .. id .. ""; 

	for x in db:nrows(query) do
		jugador = {id_jugador = x.id_jugador, name = x.name, score = x.score, avatar= x.avatar}
	end
		
	db:close()
	return jugador
end

function actualizarScoreJugador( params )

	id = params.id
	db = sqlite3.open( path ) 
	local new_score = params.score
	local query = "UPDATE " .. jugadores  .. " SET score = " ..new_score .. " WHERE id_jugador = " .. id ..";"  

	db:exec(query)

	db:close()
end

function aumentarScoreJugador( params )

	id = params.id
--	local jugador = obtenerJugador(id)
	db = sqlite3.open( path ) 
	local new_score = params.score + params.value

--	if params.score > 0 then
		local query = "UPDATE " .. rendimiento  .. " SET score = " ..new_score .. " WHERE id_jugador = " .. id .." AND id_competencia = ".. params.id_competencia .. ";"  
		db:exec(query)
	--end
	db:close()
end

function crearRendimiento(  )

	db = sqlite3.open( path ) 
		
	local query = "SELECT * FROM " .. jugadores ..";"	

	for row in db:nrows(query) do
		local id = row.id_jugador
		local query2 = "SELECT * FROM " .. competencias .. ""


	end


	db:close()

end


function getAchievements( jugador )
	
	db = sqlite3.open( path ) 
	achivements = {}
	local query = "SELECT * FROM " .. rendimiento .. " JOIN ".. competencias .. " WHERE id_jugador = " ..  jugador .. 
	" and rendimiento.id_competencia = competencias.id_competencia ;"
	local k = 1
	print("starting look")
	for row in db:nrows(query) do
		achivements[k] = {id_jugador = row.id_jugador, id_competencia=row.id_competencia, score = row.score, competencia=row.name}
		k = k+1
	end

	db:close()	
	return achivements
end

function updateGlobalScore(  )

	for i =1,#alumnos do
		local achivements = getAchievements(i)
		local newScore = 0
		for j=1, #achivements do
			newScore = newScore + achivements[j].score
		end
		db = sqlite3.open( path ) 
		local query = "UPDATE " .. jugadores  .. " SET score = " ..newScore .. " WHERE id_jugador = " .. i ..";"  

		db:exec(query)

		db:close()
	end


end





-- createDatabase()
-- iniciarBaseDeDatos()
