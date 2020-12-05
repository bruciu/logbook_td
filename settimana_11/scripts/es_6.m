
clear all;

barometro = Barometro("COM3");

CTRL_REG1 = 0x20;
CTRL_REG1_val = 0b11100000; % acensionie in modalità 12.5Hz
barometro.write(CTRL_REG1,[CTRL_REG1_val]);
dec2bin(barometro.read(CTRL_REG1,1))

RES_CONF = 0x10;
RES_CONF_val = 0b0;
%RES_CONF_val = 0x71;
barometro.write(RES_CONF,[RES_CONF_val]);
dec2bin(barometro.read(RES_CONF,1))

tempi = [];
pressioni = [];
temperature = [];

for i = 1:200
    disp(i);
    [p, t] = barometro.readValue();
    tempi = [tempi, now];
    pressioni = [pressioni, p];
    temperature = [temperature, t];    
end
tempi = (tempi - tempi(1))* 24 * 60 * 60;


