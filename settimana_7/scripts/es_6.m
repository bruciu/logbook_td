% crea l'oggetto che rappresenta la scheda
mini = Nucleo;
mini.apri_comunicazione('COM3');

% calibrazione del'ADC, probabilmente irrilevante per gli scopi dell'esercizio
mini.calibration();
correttore = CorrettoreADC;
correttore.carica("../../settimana_6/scripts/dati_calibrazione/luca_30MHz_12.5.mat");

N_onda = 1000;
N_samples = N_onda * 5;

mini.setNSkip(10);
mini.setNSamples(N_samples);
mini.setPrescaler(200);

A = 100;

% imposta la funzione
mini.setWaveFun(@(x) sin(x * 2 * pi) * A + 2048, N_onda);

% esegui l'acquisizione
[t, y0, y1]= mini.DACADC();
[y0, dy0] = correttore.correggiA0(y0);
[y1, dy1] = correttore.correggiA1(y1);

[f, A0, dA0, phis0, dphis0] = calcolaFFT_errori(y0 - mean(y0), dy0, t(2) - t(1), 100);
[~, A1, dA1, phis1, dphis1] = calcolaFFT_errori(y1 - mean(y1), dy1, t(2) - t(1), 100);

[~, max_i] = max(A1);

fprintf("%f +- %f\n", A1(max_i) / A0(max_i), sqrt((dA1(max_i) / A0(max_i)).^2 + (dA0(max_i).*A1(max_i) / (A0(max_i)).^2).^2))

hold on
plot(t, y0, '.-')
plot(t, y1, '.-')
grid();
xlabel("tempo [s]");
ylabel("letture ADC [digit]");
legend("ingresso", "uscita");
xlim([min(t), max(t)]);
hold off

saveas(gcf, "tmp/es_6.png")





