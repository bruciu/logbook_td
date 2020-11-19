
mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.calibration();
correttore = CorrettoreADC;
correttore.carica("../../settimana_6/scripts/dati_calibrazione/serena_60MHz_12_5.mat");

PS = 800;

N_onda = 1024;
N_samples = 1024 * 8;

mini.setPrescaler(PS);
mini.setNSkip(10);
mini.setNSamples(N_samples);
mini.setWaveFun(@(x) 0, N_onda);

[t, y0] = mini.DACADC();
tempo_acquis = now;
[y0, dy0] = correttore.correggiA0(y0);

figure;
hold on;
errorbar(t, y0, dy0, 'b.-')
hold off;
grid();
xlabel("tempo [s]")
ylabel("letture ADC")

[G, xx, yy_smooth] = fourier_disturbi(y0, t(2)-t(1), true);

% [f, df] = calcolaFmax(y0 - mean(y0), t(2)-t(1));
% fprintf("%s : freq = %f +- %f\n", datestr(now,'HH:MM:SS.FFF'), f, df);
% 
% figure;
% [freqs, Ampiezze] = myFFT(y0, t(2)-t(1));
% g = area(freqs(2:end), Ampiezze(2:end));
% g.FaceColor = 'b';
% g.EdgeColor = 'b';
% g.FaceAlpha = 0.5;
% grid();
% xlabel("frequenza [Hz]");
% ylabel("Ampiezze [digit]");
% set(gca, "YScale", "log");
% saveas(gcf, "tmp/es_9_fft.png")
















