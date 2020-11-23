clear all;

mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.calibration();
correttore = CorrettoreADC;
correttore.carica("../../settimana_6/scripts/dati_calibrazione/serena_60MHz_12_5.mat");

PS = 101;

N_onda = 1024;
N_samples = 1024 * 8;

mini.setPrescaler(PS);
mini.setNSkip(10);
mini.setNSamples(N_samples);
mini.setWaveFun(@(x) 0, N_onda);

%tempo_acquis = now;

[t, y0, y1] = mini.DACADC();
[y0, dy0] = correttore.correggiA0(y0);
[y1, dy1] = correttore.correggiA1(y1);

%ww1
wb = waitbar(0, "attendi");
N = 10;
for i = 1:N
    waitbar(i/N, wb, sprintf("attendi %d/%d", i, N));
%     y0 = sin(t *1.4603e+03 * 2 * pi ) * 100 + ...
%         sin(t *1.4603e+03 * 2 * pi * 3) * 10 + randn(1, numel(t))*1;
    [t, y0, y1] = mini.DACADC();
    [y0, dy0] = correttore.correggiA0(y0);
    [y1, dy1] = correttore.correggiA0(y1);
    [G0, xx0, yy_smooth0] = fourier_disturbi(y0, t(2)-t(1));
    [G1, xx1, yy_smooth1] = fourier_disturbi(y1, t(2)-t(1));
    %fprintf("G = %f", G);
    tmp(i) = G0;
    tmp2(i) = G1;
end
close(wb);
fprintf("G0 = %.8f +- %.8f\n", mean(tmp), sqrt(var(tmp))/sqrt(N));
fprintf("G1 = %.8f +- %.8f\n", mean(tmp2), sqrt(var(tmp2))/sqrt(N));

[f_max0, df_max0] = calcolaFmax(y0 - mean(y0), t(2)-t(1));
[f_max1, df_max1] = calcolaFmax(y1 - mean(y1), t(2)-t(1));

fprintf("f0 = %f +- %f\n", f_max0, df_max0);
fprintf("f1 = %f +- %f\n", f_max1, df_max1);

figure;
hold on;
errorbar(t, y0, dy0, 'b.-')
hold off;
grid();
xlabel("tempo [s]")
ylabel("letture A0")

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


hold on;
errorbar(t, y1, dy1, 'b.-')
grid();
xlabel("tempo [s]")
ylabel("letture A1")
hold off;

[G, xx, yy_smooth, dG] = fourier_disturbi(y1, t(2)-t(1), true, 5);
% fprintf("G = %f; G_2 = %f\n", G, ((dG)));
% close all;

figure;
[f1, A1] = myFFT(y1 - mean(y1), t(2)-t(1));
[f2, A2] = myFFT(yy_smooth, xx(2)-xx(1));
hold on;
stem(f1, A1, 'rd')
stem(f2, A2, 'bd')
set(gca, "YScale", 'log');
xlim([0, 2.5e4])
currYlim = ylim;
currYlim(1) = 1e-3;
%currYlim(2) = 1e2;
xline(calcolaFmax(y1 - mean(y1), t(2)-t(1)), 'k');
ylim(currYlim)
grid()
xlabel("Frequenze [Hz]")
ylabel("Ampiezze [digit]")
legend('FFT originale','FFT punti selezionati','Fmax', 'Location', 'NorthEast');
hold off;

