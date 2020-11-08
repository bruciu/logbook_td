err_rapp = @(a, b, da, db) sqrt((da/b)^2 + (db * a/(b^2))^2);

% crea l'oggetto che rappresenta la scheda
mini = Nucleo;
mini.apri_comunicazione('COM3');

% calibrazione del'ADC, probabilmente irrilevante per gli scopi dell'esercizio
mini.calibration();
correttore = CorrettoreADC;
correttore.carica("../../settimana_6/scripts/dati_calibrazione/luca_60MHz_6.5.mat");

N_onda = 100;
N_samples = N_onda * 10;

mini.setNSkip(10);
mini.setNSamples(N_samples);
%mini.setPrescaler(200);

N = 10;

PSrange = [80, 120e2];
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














