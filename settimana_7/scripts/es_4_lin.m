% crea l'oggetto che rappresenta la scheda
mini = Nucleo;
mini.apri_comunicazione('COM5');

% calibrazione del'ADC, probabilmente irrilevante per gli scopi dell'esercizio
mini.calibration();
correttore = CorrettoreADC;
correttore.carica("../../settimana_6/scripts/dati_calibrazione/serena_30MHz_12_5.mat");

N_onda = 4096;
N_samples = N_onda;

mini.setNSkip(10);
mini.setNSamples(N_samples);
mini.setPrescaler(1200);

% imposta la funzione
mini.setWaveFun(@(x) x * 4095 / 1 + 2048*0, N_onda);

% esegui l'acquisizione
[t, y0, y1]= mini.DACADC();
[y0, dy0] = correttore.correggiA0(y0);
[y1, dy1] = correttore.correggiA1(y1);

hold on
% plot(t, y0, '+b-')
% plot(t, y1, '+r-')
errorbar(y1, y0, dy0/2, dy0/2, dy1/2, dy1/2, '.k')
hold off

grid()
xlabel("lettura valore in ingresso [digit]")
ylabel("lettura in uscita [digit]")
saveas(gcf, "tmp/es_4_lin.png")





