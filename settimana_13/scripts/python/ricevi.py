import serial

# riche da saltare all'inizio
nSkip = 10

def ricevi_e_salva(porta, boud, fileName, Nmisure):
	ser = serial.Serial(porta, 2000000)
	f = open(fileName, "w")
	
	for i in range(nSkip):
		line = ser.readline()
	
	for i in range(Nmisure):
		# leggi riga
		line = ser.readline()[:-2]
		
		# controllo lunghezza
		if len(line) > 30:
			continue;
		
		# decode non mi ricordo che è, forse corregge \t / \n
		line = line.decode()
		
		# scrivi su file
		#f.write(str(line))
		
		#f.write("\n")
		
		if (i % 100 == 0):
			print(line);
			#f.flush();
			
	f.flush();
	
