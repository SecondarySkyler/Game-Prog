-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local missiles = {}

--Posizionamento Immagine di Background 
local background = display.newImageRect("img/background.png",960,540)
background.x = display.contentCenterX
background.y = display.contentCenterY

--Posizionamento prima immagine del terreno nel display
--per implementare effetto scrolling orizzontale
local ground = display.newImageRect("img/groundGrass.png",960,84)
ground.anchorX=0
ground.anchorY=0
ground.x = 0
ground.y = display.contentHeight-84

--Posizionamento seconda immagine del terreno (a destra del display)
--per implementare effetto scrolling orizzontale
local ground_next = display.newImageRect("img/groundGrass.png",960,84)
ground_next.anchorX=0
ground_next.anchorY=0
ground_next.x = display.contentWidth
ground_next.y = display.contentHeight-84

--Velocità di scrolling del terreno pari a 4 pixel per frame 
--(animazione frame-based)
local speed = 4


--Posizionamento prima immagine del soffitto nel display
--per implementare effetto scrolling orizzontale
local top = display.newImageRect("img/top.png",960,84)
top.anchorX=0
top.anchorY=0
top.x = -300
top.y = 0

--Posizionamento seconda immagine del soffitto nel display
--per implementare effetto scrolling orizzontale
local top_next = display.newImageRect("img/top.png",960,84)
top_next.anchorX=0
top_next.anchorY=0
top_next.x = display.contentWidth-300
top_next.y = 0

--Velocità di scrolling del terreno pari a 4 pixel per frame 
--(animazione frame-based)
local speed = 4

--Caricamento dell'image sheet relativo all'aereo
local opt = { width = 88, height = 73, numFrames = 3}
local planeSheet = graphics.newImageSheet("img/planeSheet.png", opt)

--Definizione della sequenza di animazione dell'aereo
local seqs ={{
	          name = "fly",
			  start = 1,
              count = 3,
              time = 300,
			  loopCount = 0,
			  loopDirection ="bounce"
	    	 }
			} 
			
--caricamento imageSheet relativo al missile
local missileOptions = {width = 44, height = 32, numFrames = 4}
local missileSheet = graphics.newImageSheet("img/missileSheet.png", missileOptions)

--definizione della sequenza del missile
local missileSeqs = {
	name = "missile",
    start = 1,
    count = 4,
    time = 100,
    loopCount = 4,
    loopDirection = "forward"
}
            
-- INIZIO INTRO DEL GIOCO

--Creazione dello sprite relativo all'aereo
--Lo sprite deve essere collocato nel punto di coordinate
--x = centro del display, y=-100 (pertanto lo sprite è inizialmente 
--non visibile in quanto è collocato  sopra il margine 
--superiore del display)
--AGGIUNGI QUI IL CODICE NECESSARIO	
local plane = display.newSprite(planeSheet, seqs)
plane.x = display.contentCenterX
plane.y = -100


--creazione bottone per sparare missile
--inizialmente si trova fuori dallo schermo
--vedi funzione planeEndIntro per transizione
local button = display.newImageRect("img/redButton.png", 280, 175)
button.x = 1080
button.y = display.contentHeight - 60


--Creare l'immagine tapLeft, la quale deve essere collocata nel punto di 
--coordinate x = 1060, y=centro del display (pertanto tapLeft è inizialmente 
--non visibile in quanto è collocata  a destra del margine 
--destro del display)
--AGGIUNGI QUI IL CODICE NECESSARIO
local tapLeft = display.newImageRect("img/tapLeft.png", 85, 42)
tapLeft.x = 1060
tapLeft.y = display.contentCenterY


--Creare l'immagine tapRight, la quale deve essere collocata nel punto di 
--coordinate x = -100, y=centro del display (pertanto tapRight è inizialmente 
--non visibile in quanto è collocata  a sinistra del margine 
--sinistro del display)
--AGGIUNGI QUI IL CODICE NECESSARIO
local tapRight = display.newImageRect("img/tapRight.png", 85, 42)
tapRight.x = -100
tapRight.y = display.contentCenterY

-- Generare la transizione planeEnter che in 300ms sposta l'aereo
-- nella posizione y=display.contentCenterY
--AGGIUNGI QUI IL CODICE NECESSARIO
local planeEnter = transition.to(plane, {time = 300, y = display.contentCenterY})



-- Generare la transizione tapLeftEnter che attende 600ms prima di
-- di far transire l'immagine tapLeft alla coordinata 
-- x="posizione x di plane + 90". Si usi la funzione di easing
-- easing.outBounce
--AGGIUNGI QUI IL CODICE NECESSARIO
local tapLeftEnter = transition.to(tapLeft, {delay = 600, x = plane.x + 90, transition = easing.outBounce})



-- Generare la transizione tapRightEnter che attende 600ms prima di
-- di far transire l'immagine tapright alla coordinata 
-- x="posizione x di plane - 90". Si usi la funzione di easing
-- easing.outBounce
--AGGIUNGI QUI IL CODICE NECESSARIO
local tapRightEnter = transition.to(tapRight, {delay = 600, x = plane.x - 90, transition = easing.outBounce})



-- Una volta cge le immagini tapLeft e tapRight sono visibili
-- al centro del display, farle lampeggiare usando la funzione
-- transition.blink con tempo di blinking pari a 1 secondo
--AGGIUNGI QUI IL CODICE NECESSARIO
transition.blink (tapLeft, {time = 1000})
transition.blink (tapRight, {time = 1000})




-- FINE INTRO DEL GIOCO



-- funzione startGame, eseguita dopo la visualizzazione
-- della intro del gioco
local function startGame()

	
	-- funzione scroll per lo scrolling orizzontale di terreno e soffitto
	local function scroll(self,event)
		if self.x<-(display.contentWidth-speed*2) then
			self.x = display.contentWidth
		else
			self.x =self.x - speed
		end	
	end	
	
	-- funzione movePlane per il controllo dell'aereo mediante 
	-- trascinamento (evento touch)
	local function movePlane(event)
		local plane = event.target
		if event.phase=="began" then
			plane.offset=event.y-plane.y
			display.currentStage:setFocus(plane)
		elseif event.phase=="moved" then
			plane.y=event.y-plane.offset
		elseif event.phase=="ended" or event.phase=="cancelled" then
					display.currentStage:setFocus(nil)
		end	
		return true		
	end	
	
	--funzione di shooting del missile controllata da evento tap sul bottone
	local function shoot (event)
		local missile = display.newSprite(missileSheet, missileSeqs)
		missile.x = 220
		missile.y = plane.y 
		--missile:toBack()
		missile:play()
		table.insert(missiles, missile)
		print(#missiles)
		local shoot = transition.to(missile, {x = 1080, time = 800})
		local missileAudio = audio.loadSound("sfx/shoot.wav")
		audio.play(missileAudio)

		--ciclo for per la rimozione dei missili fuori dal margine destro
		for i, thisMissile in ipairs(missiles) do 
			if (thisMissile.x >= 980) then
				display.remove(thisMissile)
				table.remove(missiles, i)
			end
		end
	end


	
	-- una volta terminata la intro rimuovere il table listener
	-- dell'oggetto grafico plane associato all'evento tap
	--AGGIUNGI QUI IL CODICE NECESSARIO
	plane:removeEventListener("tap", plane)
	
	-- aggiungere il function listener movePlane associato
	-- all'oggetto plane e relativo all'evento touch
	--AGGIUNGI QUI IL CODICE NECESSARIO
	plane:addEventListener("touch", movePlane)
	button:addEventListener("tap", shoot)
	-- aggiunge i table listener per lo scrolling orizzontale
	-- del soffitto (oggetti grafici top e top_next) 
	-- e del terreno (oggetti grafici ground e ground_next)
    --AGGIUNGI QUI IL CODICE NECESSARIO
    ground.enterFrame = scroll
    Runtime:addEventListener("enterFrame", ground)
    ground_next.enterFrame = scroll
    Runtime:addEventListener("enterFrame", ground_next)
    top.enterFrame = scroll
    Runtime:addEventListener("enterFrame", top)
    top_next.enterFrame = scroll
    Runtime:addEventListener("enterFrame", top_next)
	--riprodurre la musica di background in loop dopo 1 secondo (usare timer.performWithDelay)
	--AGGIUNGI QUI IL CODICE NECESSARIO

	
	
	
    local bg_audio = audio.loadStream("sfx/happy.mp3")
    timer.performWithDelay(1000, audio.play(bg_audio, {loops = -1}))
   
	--riprodurre planeEngine in loop dopo 1 secondo (usare timer.performWithDelay)
    --AGGIUNGI QUI IL CODICE NECESSARIO
    local engineAudio = audio.loadSound("sfx/planeEngine.mp3")
	timer.performWithDelay(1000, audio.play(engineAudio, {loops = -1}))
	
end

-- Funzione che implementa la terminazione
-- della intro e chiama la funzione
-- di inizio gioco startGame												
local function PlaneEndIntro(self,event)
	--Rimozione di tutte le transizioni caricate
	--AGGIUNGI QUI IL CODICE NECESSARIO
	transition.cancelAll()
	--Rimozione degli oggetti grafici tapRight e tapLeft
	--AGGIUNGI QUI IL CODICE NECESSARIO
    display.remove (tapLeft)
    display.remove (tapRight)
	
	--Animazione dello sprite dell'aero
	--AGGIUNGI QUI IL CODICE NECESSARIO
	plane:play()
	--Spostamento dell'aereo, mediante una transizione orizzontale,
	--alla coordinata x=220 in 300ms.
	--AGGIUNGI QUI IL CODICE NECESSARIO
	plane.x = transition.to(plane, {x = 220, time = 300})
	
	--sposstamento del bottone alle coordinate designate
	button.x = transition.to(button, {x = display.contentWidth - 100, time = 300})

    
    local clickAudio = audio.loadSound("sfx/click.wav")
    audio.play(clickAudio)
	
	--Chiamata alla funzione startGame()
	--AGGIUNGI QUI IL CODICE NECESSARIO
	startGame()
	
end

-- Associare il table listener PlaneEndIntro per l'evento
-- tap all'oggetto plane. 
--AGGIUNGI QUI IL CODICE NECESSARIO 
plane:addEventListener("tap", PlaneEndIntro)

