clear all;

mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.calibration();

c = CorrettoreADC;
c.run(mini);
c.salva("dati_calibrazione/luca_120MHz_12.5.mat");
beep
[a, b] = c.correggiA0(c.A0_mean);
figure;
hold on;
errorbar(c.DAC_vals, a - c.DAC_vals*0, b, 'k.');
plot(c.DAC_vals, c.DAC_vals);
hold off
clear a b

%  30Mhz 2.5    83ns
%  30MHz 6.5   217ns
%  30MHz 12.5  417ns
%  60Mhz 2.5    42ns
%  60Mhz 6.5   108ns
%  60Mhz 12.5  208ns
%  120Mhz 2.5   21ns
%  120Mhz 6.5   54ns <- luca li ha sbagliato
%  120Mhz 12.5 104ns <- luca li ha sbagliato





