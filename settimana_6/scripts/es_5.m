
N_onda = 1024;    % numero di punti per onda
N_samples = 1024; % numero di punti acquisiti
duty = 0.5;       % riferito all'onda quadra
amply = 800;      % ampiezza dell'onda

% funzione per il DAC
funz_orig = @(x, duty, amply) square(x * 2 * pi - 0.1, duty*100)*amply + 2048;

PS = 200;

% crea l'oggetto che rappresenta la scheda
mini = Nucleo;

mini.apri_comunicazione('COM3');

% calibrazione del'ADC, probabilmente irrilevante per gli scopi dell'esercizio
mini.calibration();
correttore = CorrettoreADC;
correttore.carica("dati_calibrazione/luca_120MHz_2.5.mat");

mini.setNSkip(10);
mini.setNSamples(N_samples);
mini.setPrescaler(PS);

% imposta la funzione
mini.setWaveFun(@(x) funz_orig(x, duty, amply), N_onda);

% esegui l'acquisizione
[t, y0, y1]= mini.DACADC();
[y0, dy0] = correttore.correggiA0(y0);
[y1, dy1] = correttore.correggiA1(y1);

% Fattore = 2;
% y1 = y1 - square((0:(N_samples-1))'/N_samples * 2 * pi, duty) * Fattore;

figure;
hold on
errorbar(t, y0, dy0, 'r.-');
errorbar(t, y1, dy1, 'b.-');
hold off
grid();
ylabel("letture [digit]");
xlabel("tempo [s]");
legend("A0", "A1");
saveas(gcf,'tmp/bode_0.png');

dyy = 1;
dt = t(2) - t(1);
[freqs, As0, dAs0, phis0, dphis0] = calcolaFFT_errori(y0, dy0, dt);
[~    , As1, dAs1, phis1, dphis1] = calcolaFFT_errori(y1, dy1, dt);

Guadagni = As1 ./ As0;
dGuadagni = sqrt((dAs1./As0).^2 + (As1 .* (dAs0./(As0.^2)).^2));
DeltaPhi = phis1 - phis0;
dDeltaPhi = sqrt(dphis0.^2 + dphis1.^2);

% Delta \phi = {​​​​{​​​​\pi  f}​​​​\over{​​​​SR}​​​​}​​​​
correzione_phi = @(f) pi.*f.*dt;
DeltaPhi = DeltaPhi - correzione_phi(freqs);

DeltaPhi = mod(DeltaPhi + pi/2, pi) - pi/2;

%threashold = 0.5;
%Guadagni = Guadagni - 1000 .* (dGuadagni ./ Guadagni > 0.5);

% seleziona i dati il cui errore relativo sul guadagno e' < 0.5
freqs_tmp = freqs;
A_tmp = Guadagni;
dA_tmp = dGuadagni;
phi_tmp = DeltaPhi;
dphi_tmp = dDeltaPhi;
clear A dA phi dphi freqs
counter = 0;
if (1)
    for i = 1:numel(freqs_tmp)
        if (dA_tmp(i) / A_tmp(i) < 0.1)
            counter = counter + 1;
            c = counter;
            
            freqs(c) = freqs_tmp(i);
            
            A(c) = A_tmp(i);
            dA(c) = dA_tmp(i);
            
            phi(c) = phi_tmp(i);
            dphi(c) = dphi_tmp(i);
        end
    end
else
    freqs = freqs_tmp;
    A = Guadagni;
    dA = dGuadagni;
    phi = DeltaPhi;
    dphi = dDeltaPhi;
end

figure;
errorbar(freqs, A, dA, 'k.');
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
grid();
ylabel("Gaudagno");
xlabel("frequenze [Hz]");

saveas(gcf,'tmp/bode_1.png');

figure;
errorbar(freqs, phi, dphi, 'k.');
set(gca, 'XScale', 'log');
grid();
ylabel("sfasamento [Rad]");
ylim([-1.5, 1.5]);
xlabel("frequenze [Hz]");

saveas(gcf,'tmp/bode_2.png');



