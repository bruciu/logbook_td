clear all;

mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.calibration();
correttore = CorrettoreADC;
correttore.carica("../../settimana_6/scripts/dati_calibrazione/luca_60MHz_12.5.mat");

PS = 101;

Div = 1;
N_onda = 1024 / Div;
N_samples = N_onda*8 * Div;

duty = 0.01 * Div;
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
errorbar(t, y0, dy0, 'b.-')
errorbar(t, y1, dy1, 'r.-')
hold off;
grid();
xlabel("tempo [s]")
ylabel("letture ADC")
legend("A0 (V_{in})", "A1 (V_{out})");
saveas(gcf, "tmp/es_5_sig.png")

[f, A0, dA0, phi0, dphi0] = calcolaFFT_errori(y0 - mean(y0), dy0, t(2)-t(1));
[~, A1, dA1, phi1, dphi1] = calcolaFFT_errori(y1 - mean(y1), dy1, t(2)-t(1));

err_rapp = @(a, b, da, db) sqrt((da./b).^2 + (db .* a./(b.^2)).^2);
Guad = A1 ./ A0;
dGuad = err_rapp(A1, A0, dA1, dA0);
Phi = phi1 - phi0;
dPhi = sqrt(dphi0.^2 + dphi1.^2);

cond_tmp = dGuad ./ Guad < 0.1;
f = f(cond_tmp);
Guad = Guad(cond_tmp);
dGuad = dGuad(cond_tmp);
Phi = Phi(cond_tmp);
dPhi = dPhi(cond_tmp);

figure;
subplot(2, 1, 1);
hold on;
errorbar(f(2:end), Guad(2:end), dGuad(2:end), 'k.');
%plot(f(2:end), Guad(2:end));
hold off;
set(gca, "YScale", 'log')
set(gca, "XScale", 'log')
yline(91.91, 'r');
grid()
xlabel("frequenza [Hz]")
ylabel("Guadagno")
legend("dati (da FFT)", "guadagno ideale")
subplot(2, 1, 2);
hold on;
errorbar(f(2:end), Phi(2:end), dPhi(2:end), 'k.');
hold off;
set(gca, "XScale", 'log')
yline(0, 'r');
grid()
xlabel("frequenza [Hz]")
ylabel("sfasamento [Rad]")
legend("dati (da FFT)", "sfasamento ideale")
ylim([-pi/2, 0.1])
saveas(gcf, "tmp/es_5_bode_sfas.png")


funz = @(G, fti, x) G./sqrt(1 + (x./fti).^2);
fitfun = fittype(funz);
X0 = [91, 10e4];
[fitted_curve, gof] = fit(f', Guad', fitfun, "StartPoint", X0, 'Weight', 1./(dGuad'));

figure;
coeffvals2 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("G = %.10f +- %.10f\n", coeffvals2(1), (errors(2, 1) - errors(1, 1))/2);
fprintf("fti = %.10f +- %.10f\n", coeffvals2(2), (errors(2, 2) - errors(1, 2))/2);
hold on;
errorbar(f, Guad, dGuad, 'k.');
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
plot(f, funz(coeffvals2(1), coeffvals2(2), f), 'r');
xlabel("Frequenza [Hz]")
ylabel("Guadagno")
legend('dati', 'fit')
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
grid()
%plot(freqs, funz(X0(1), X0(2), freqs), 'b');
hold off
saveas(gcf,'tmp/es_5_fit.png');
hold off;








