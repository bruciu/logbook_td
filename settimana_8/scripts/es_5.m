clear all;

mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.calibration();
correttore = CorrettoreADC;
correttore.carica("../../settimana_6/scripts/dati_calibrazione/luca_60MHz_12.5.mat");

PS = 1010;
N_onda = 1000;
N_samples = N_onda;

duty = 0.5;
A = 18;
offset = 2045;
funz = @(x) square((x-0.1)*2*pi, duty*100) * A + offset;

mini.setPrescaler(PS);
mini.setNSkip(10);
mini.setNSamples(N_samples);
mini.setWaveFun(funz, N_onda);


[t, y0, y1] = mini.DACADC();
[y0, dy0] = correttore.correggiA0(y0);
[y1, dy1] = correttore.correggiA1(y1);

figure;
hold on;
errorbar(t, y0, dy0)
errorbar(t, y1, dy1)
hold off;

[f, A0, dA0, phi0, dphi0] = calcolaFFT_errori(y0 - mean(y0), dy0, t(2)-t(1));
[~, A1, dA1, phi1, dphi1] = calcolaFFT_errori(y1 - mean(y1), dy1, t(2)-t(1));

err_rapp = @(a, b, da, db) sqrt((da./b).^2 + (db .* a./(b.^2)).^2);
Guad = A1 ./ A0;
dGuad = err_rapp(A1, A0, dA1, dA0);

figure;
hold on;
%errorbar(f(2:end), Guad(2:end), dGuad(2:end));
plot(f(2:end), Guad(2:end));
hold off;











