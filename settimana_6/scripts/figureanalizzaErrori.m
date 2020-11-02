clear all;

c = CorrettoreADC; 
c.carica("dati_calibrazione/serena_120MHz_6_5.mat")
[a, b] = c.correggiA0(c.A0_mean);
figure;
hold on;
errorbar(c.DAC_vals, a - c.DAC_vals, b, 'k.');
plot(c.DAC_vals, a - c.DAC_vals, 'r.-');
plot(c.DAC_vals, c.DAC_vals*0);
grid();
title("serena\_120MHz\_6_5.mat");
xlabel("valore DAC [digit]");
xlim([0, 4096]);
ylabel("media A0 corretto - valore DAC");
% ylabel("media A0 corretto [digit]");
legend("errori", "residui");
hold off
clear a b



