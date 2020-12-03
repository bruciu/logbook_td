
clear all;

barometro = Barometro("COM3");

CTRL_REG1 = 0x20;
CTRL_REG1_val = 0b11100000; % acensionie in modalità 12.5Hz
barometro.write(CTRL_REG1,[CTRL_REG1_val]);

RES_CONF = 0x10;
RES_CONF_val = 0b0;
barometro.write(RES_CONF,[RES_CONF_val]);

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


