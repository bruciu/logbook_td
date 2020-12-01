% indirizzi = vettore dei SAD trovati
inidirizzi = [];

% crea l'oggetto mini
mini = Nucleo;
mini.apri_comunicazione('COM3');

for i = 0:127
     mini.writeline(sprintf('I2CWRITE %f,0', i))
     l = mini.readline();
     if (l(1) ~= 'E')
         indirizzi = [inidirizzi, i];
     end
end

fprintf("indirizzi trovati: "); disp(indirizzi);