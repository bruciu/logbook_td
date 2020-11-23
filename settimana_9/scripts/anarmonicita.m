clear all;

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

%tempo_acquis = now;

[t, y0, y1] = mini.DACADC();
[y0, dy0] = correttore.correggiA0(y0);

%ww1
wb = waitbar(0, "attendi");
N = 10;
for i = 1:N
    waitbar(i/N, wb, sprintf("attendi %d/%d", i, N));
%     y0 = sin(t *1.4603e+03 * 2 * pi ) * 100 + ...
%         sin(t *1.4603e+03 * 2 * pi * 3) * 10 + randn(1, numel(t))*1;
    [t, y0, y1] = mini.DACADC();
    [y0, dy0] = correttore.correggiA0(y0);
    [G, xx, yy_smooth] = fourier_disturbi(y0, t(2)-t(1));
    %fprintf("G = %f", G);
    tmp(i) = G;
end
close(wb);
fprintf("G = %.8f +- %.8f\n", mean(tmp), sqrt(var(tmp))/sqrt(N));

[f_max, df_max] = calcolaFmax(y0 - mean(y0), t(2)-t(1));
fprintf("f = %f +- %f\n", f_max, df_max);

figure;
hold on;
errorbar(t, y0, dy0, 'b.-')
hold off;
grid();
xlabel("tempo [s]")
ylabel("letture ADC")

[G, xx, yy_smooth, dG] = fourier_disturbi(y0, t(2)-t(1), true, 20);
% fprintf("G = %f; G_2 = %f\n", G, ((dG)));
% close all;

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
grid()
xlabel("Frequenze [Hz]")
ylabel("Ampiezze [digit]")
legend('FFT originale','FFT punti selezionati','Fmax', 'Location', 'NorthEast');
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

% 
% G = G_vero + |rumore|^2
% G_vero = G - |rumore|^2
% dG_vero = d|rumore|^2
% 
% 
% G = sum[(y - y_teorico)^2] = sum[(y_segnale + y_rumore - y_teorico)^2]
% E[G] = E[(Dy - y_r)^2] = E[Dy^2 + 2*Dy*y_r + y_r^2]
% = E[Dy^2] + 2*E[Dy*y_r] + E[y_r^2] = G_ver + |rumore|^2
% 
% E[x^2] = int(x^2*k*e^-(x^2)) = ... = x^2
% 
% var = - (E[G])^2 + E[G^2] = G_vero + |errore|^2 + E[(y_segnale + y_rumore - y_teorico)^4]
% 
% %G = sum[(y_segnale + y_rumore - y_teorico)^2] = sum[(y_segnale - y_teorico)^2]  + y_rumore 2* sum[(y_segnale - y_teorico)]...
%     %+ (1/2) y_rumore^2 * 2 * N_punti
% 
% yy = sin(x) + rnadn(1)
% 
% 
% 
% % G = sqrt(sum[(y_segnale + y_rumore - y_teorico)^2])
% 
% % E_G = E[sqrt(sum[(y_segnale + y_rumore - y_teorico)^2])] = sqrt(E[sum[(y_segnale + y_rumore - y_teorico)^2]])
% % = sqrt(E[Dy^2] + E[y_r^2])
% 
% %var_G = E(sum[(y_segnale + y_rumore - y_teorico)^2]) - E[Dy^2] - E[y_r^2] = 








