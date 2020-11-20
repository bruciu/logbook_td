
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

[G, xx, yy_smooth] = fourier_disturbi(y0, t(2)-t(1), true, 20);

figure;
[f1, A1] = myFFT(y0 - mean(y0), t(2)-t(1));
[f2, A2] = myFFT(yy_smooth, xx(2)-xx(1));
hold on;
stem(f1, A1, 'rd')
stem(f2, A2, 'bd')
set(gca, "YScale", 'log');
xlim([0, 2.5e4])
currYlim = ylim;
currYlim(1) = 1e-3;
%currYlim(2) = 1e2;
xline(calcolaFmax(y0 - mean(y0), t(2)-t(1)), 'k');
ylim(currYlim)
hold off;

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
















