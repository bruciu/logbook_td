clear all;

mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.calibration();

c = CorrettoreADC;
c.run(mini);
c.salva("dati_calibrazione/luca_30MHz_12.5.mat");

%  30Mhz 2.5
%  30MHz 6.5
%  30MHz 12.5
%  60Mhz 2.5
%  60Mhz 6.5
%  60Mhz 12.5
%  120Mhz 2.5
%  120Mhz 6.5
%  120Mhz 12.5