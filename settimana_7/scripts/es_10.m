err_rapp = @(a, b, da, db) sqrt((da/b)^2 + (db * a/(b^2))^2);

% crea l'oggetto che rappresenta la scheda
mini = Nucleo;
mini.apri_comunicazione('COM3');

% calibrazione del'ADC, probabilmente irrilevante per gli scopi dell'esercizio
mini.calibration();
correttore = CorrettoreADC;
correttore.carica("../../settimana_6/scripts/dati_calibrazione/luca_60MHz_6.5.mat");
mini.freq = 60e6;

N_onda = 100;
N_samples = N_onda * 10;

mini.setNSkip(10);
mini.setNSamples(N_samples);
%mini.setPrescaler(200);

N = 50;

PSrange = [80, 200e2];
PSrange = linspace(PSrange(1), PSrange(2), N);
f = logspace(log10(60e6/(max(PSrange)*N_onda)), log10(120e6/(min(PSrange)*N_onda)), numel(PSrange));
PSrange = 60e6./(f*N_onda);
PSrange = round(PSrange);
PS_vals = PSrange;

ftrig = 60e6 ./ PSrange;
f = ftrig ./N_onda;

A = 500;
mini.setWaveFun(@(x) sin(x * 2 * pi)*A + 2048, N_onda);


clear As;
clear dAs;
As = 0;
dAs = 0;
for i = 1:N
    disp(i);
    mini.setPrescaler(PS_vals(i));
    
    % esegui l'acquisizione
    [t, y0, y1] = mini.DACADC();
    [y0, dy0] = correttore.correggiA0(y0);
    [y1, dy1] = correttore.correggiA1(y1);
    
    [~, A0, dA0, phis0, dphis0] = calcolaFFT_errori(y0 - mean(y0), dy0, t(2) - t(1), 100);
    [~, A1, dA1, phis1, dphis1] = calcolaFFT_errori(y1 - mean(y1), dy1, t(2) - t(1), 100);
    
    % trova massimo
    [~, max_i] = max(A0);
    
    As(i) = A1(max_i)/A0(max_i);
    dAs(i) = err_rapp(A1(max_i), A0(max_i), dA1(max_i), dA0(max_i));
end

errorbar(f, As, dAs, '.k');
set(gca, "XScale", 'log')
set(gca, "YScale", 'log')
grid();
figure;

guad = As(2:end);
dguad = dAs(2:end);
freqs = f(2:end);

R2_val = (10e3)/2;
R1_val = 1e3;
C1_val = 10e-9;
C2_val = 68e-9;

funz = @(fti, ftd, x) 1./sqrt((1 + (x./fti).^2).*(1 + (ftd./x).^2));
fitfun = fittype(funz);
X0 = [1./(2*pi*R1_val*C1_val), 1./(2*pi*R2_val*C2_val)];%
[fitted_curve, gof] = fit(freqs', guad', fitfun, "StartPoint", X0, 'Weight', 1./(dguad'));
coeffvals2 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("fti = %.10f +- %.10f\n", coeffvals2(1), (errors(2, 1) - errors(1, 1))/2);
fprintf("ftd = %.10f +- %.10f\n", coeffvals2(2), (errors(2, 2) - errors(1, 2))/2);
hold on;
errorbar(freqs, guad, dguad, 'k.');
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
plot(freqs, funz(coeffvals2(1), coeffvals2(2), freqs), 'r');
xlabel("Frequenza [Hz]")
ylabel("Guadagno")
legend('dati', 'fit')
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
grid()
plot(freqs, funz(X0(1), X0(2), freqs), 'b');
hold off
saveas(gcf,'tmp/provaes10.png');
hold off;






