
clear all;

barometro = Barometro("COM3");

barometro.startReading();

tempi = [];
pressioni = [];
temperature = [];

for i = 1:1000
    disp(i);
    [p, t] = barometro.readValue();
    tempi = [tempi, now];
    pressioni = [pressioni, p];
    temperature = [temperature, t];    
end
tempi = (tempi - tempi(1))* 24 * 60 * 60;

save("es_7.mat", "tempi", "pressioni", "temperature");
