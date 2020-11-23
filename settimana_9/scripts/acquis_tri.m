clear all;

mini = Nucleo;
mini.apri_comunicazione("COM3");
mini.calibration();
correttore = CorrettoreADC;
correttore.carica("../../settimana_6/scripts/dati_calibrazione/luca_60MHz_12.5.mat");

PS = 2400;
N_onda = 0;
N_samples = 2000;

mini.setPrescaler(PS);
mini.setNSkip(1);
mini.setNSamples(N_samples);
mini.setWaveFun(@(x) 0, N_onda);

[t, y0, y1] = mini.DACADC();
[y0, dy0] = correttore.correggiA0(y0);
[y1, dy1] = correttore.correggiA0(y1);

figure;
hold on;
plot(t, y0, '.b-');
plot(t, y1, '.r-');
ylim([min(y0), max(y0)]);
xlabel("tempo [s]");
ylabel("letture [digit]");
legend("A0", "A1");
grid();
hold off;




