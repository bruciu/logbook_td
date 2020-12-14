
mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.calibration();
correttore = CorrettoreADC;
correttore.carica("../../settimana_6/scripts/dati_calibrazione/luca_60MHz_12.5.mat");

PS = 800;

N_onda = 1024;
N_samples = 1024 * 8;

mini.setPrescaler(PS);
mini.setNSkip(10);
mini.setNSamples(N_samples);
mini.setWaveFun(@(x) 0, N_onda);

[t, y0, y1] = mini.DACADC();
tempo_acquis = now;
[y0, dy0] = correttore.correggiA0(y0);
%[y1, dy1] = correttore.correggiA1(y1);

% figure;
% hold on;
% errorbar(t, y0, dy0, 'b.-')
% errorbar(t, y1, dy1, 'r.-')
% hold off;
% grid();
% xlabel("tempo [s]")
% ylabel("letture ADC")
% legend("A0 (V_{in})", "A1 (V_{out})");
% saveas(gcf, "tmp/es_9_sig.png")

[f, df] = calcolaFmax(y0 - mean(y0), t(2)-t(1));
fprintf("%s : freq = %f +- %f\n", datestr(now,'HH:MM:SS.FFF'), f, df);

% figure;
[freqs, Ampiezze] = myFFT(y0, t(2)-t(1));
% g = area(freqs(2:end), Ampiezze(2:end));
% g.FaceColor = 'b';
% g.EdgeColor = 'b';
% g.FaceAlpha = 0.5;
% grid();
% xlabel("frequenza [Hz]");
% ylabel("Ampiezze [digit]");
% set(gca, "YScale", "log");
% saveas(gcf, "tmp/es_9_fft.png")















