-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- The content area of this project is 320x480 pixels, 
-- and the orientation is set to portrait (i.e. upright orientation).

-- carica nella variabile locale bar l'immagine green_bar.png e posizionala 
-- nel centro del display
-- AGGIUNGI IL CODICE QUI
local bar = display.newImageRect("img/green_bar.png", 190, 45)
bar.x = display.contentCenterX
bar.y = display.contentCenterY

-- carica nella variabile locale slider l'immagine red_slider.png e posizionala 
-- a meta' della barra bar
-- AGGIUNGI IL CODICE QUI
local slider = display.newImageRect("img/red_slider.png", 28, 42)
slider.x = bar.x 
slider.y = display.contentCenterY + 20

-- definisci e setta la proprieta' offsetX dello slider a 0.
-- la proprieta' offsetX modella la distanza del punto di contatto del touch
-- dal centro dello slider rispetto all'asse x. Inizialmente assumiamo che tale 
-- valore sia 0.
-- AGGIUNGI IL CODICE QUI
slider.offsetX = 0

-- definisci le variabili locali barLeftMargin e barRightMargin e inizializzale
-- rispettivamente alle coordinate x degli estremi della barra (cioe' 65 e 255).
-- AGGIUNGI IL CODICE QUI
local barLeftMargin = 65
local barRightMargin = 255

-- carica la colonna sonora Jazzy.mp3 nella variabile locale music 
-- e settail volume a 0.5. Riproduci in loop il file sonoro.
-- AGGIUNGI IL CODICE QUI
local OST = audio.loadSound("music/Jazzy.mp3")
audio.play (OST, {loops = -1, volume = 0.5})


-- moveSlider e' un function listener che muove lo slider lungo la barra green_bar.
-- Muovendo lo slider aumenta/diminuisce il volume della soundtrack memorizzata nella
-- variabile music. La tecnica di spostamento via touch dello slider e' simile a quella 
-- implementata nell'esempio DragObjects.
local function moveSlider(event)
    --all'inizio della fase di touch...
  	   -- calcola la distanza fra il punto di contatto rispetto a X e il centro dello
  	   -- slider
  	   -- setta il focus di tutti gli eventi touch futuri sullo slider
  	   -- (i.e. tutti i prossimi eventi touch saranno gestiti dall'oggetto 
  	   -- slider)
	   -- AGGIUNGI IL CODICE QUI
	if event.phase == "began" then
		slider.x = event.x - slider.offsetX 
		display.currentStage:setFocus(slider)
	   
	
    --durante lo spostamento dello slider...	
  	    -- cambia la coordinata x dello slider a quella corrente (event.x)
		-- diminuita dell'offsetX solo se lo slider è posizionato fra i margini
		-- barLeftMargin and barRightMargin
		-- se lo slider e' oltre il limite barLeftMargin, allora
		-- riposiziona lo slider alla coordinata x barLeftMargin.
		-- se lo slider e' oltre il limite barRightMargin, allora
		-- riposiziona lo slider alla coordinata x barRightMargin.
		-- AGGIUNGI IL CODICE QUI
	elseif event.phase == "moved" then
		if (slider.x <= barLeftMargin) then
			slider.x = barLeftMargin
		elseif (slider.x >= barRightMargin) then
			slider.x = barRightMargin
		else
			slider.x = event.x - slider.offsetX
		end
		vol = (slider.x - 65) / 190
		audio.setVolume (vol)
	elseif event.phase == "ended" or event.phase == "cancelled" then
			display.currentStage:setFocus(nil)
	end

				
		-- calcola il livello del volume in base alla posizione dello slider
		-- lungo la barra, usando la formula  vol =	(slider.x-65)/190
		-- e setta il nuovo volume a vol.
		-- Si noti che quando lo slider ha coordinata x = 65 
		-- (estremo sinistro della barra), il volume e' nullo.
		-- Invece, in posizione x=255 (estremo destro della barra) il volume e' 1. 
		-- AGGIUNGI IL CODICE QUI
  	    
    --quando termina la fase di touch		
  	  --elimina il focus dell'evento dallo slider
      -- AGGIUNGI IL CODICE QUI
	  
   
    -- il comando return true permette di far gestire l'evento touch da un singolo oggetto. In altre parole l'evento non è propagato ad altri oggetti o allo stage.
    return true
  end
  
  -- aggancia l'ascoltatore moveSlider all'evento touch dello slider
slider:addEventListener("touch", moveSlider)
		
	