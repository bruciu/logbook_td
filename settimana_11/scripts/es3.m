% indirizzi = vettore dei SAD trovati
inidirizzi = [];

% crea l'oggetto mini
mini = Nucleo;
mini.apri_comunicazione('COM3');


mini.writeline(sprintf('I2CREAD? 93,%d,1', 0x0F))
l = mini.readline();
%if (l(1) ~= 'E')
%indirizzi = [inidirizzi, i];


fprintf("indirizzi trovati: "); disp(indirizzi);