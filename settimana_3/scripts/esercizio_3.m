
% tempo totale
T = 1; % secondi

% frequenza del segnale
f_s = 1; % Hz

% lunghezza del vettore (numero di punti)
n = 10;
L = 2^n;

% array dei tempi:
%t = linspace(0, T, L) + randn(1, L) * T/(L)*0;
t = (0:(L-1)) * T/L;

% array del segnale:
y = cos(f_s * 2 * pi * t) + randn(1, L) * 0;

[freqs, Ampiezze, fase] = myFFT(y, T/L) ;
[A_max, i_max] = max(Ampiezze);

subplot(2, 1, 1);
plot(t, y, '-')
title(sprintf("L = %d  freq. sig. = %.2f, T_{tot} = %f", L, f_s, T));
xlabel("tempo [s]");
ylabel("valore [u]");

subplot(2, 1, 2);
f_max = freqs(i_max);
interessanti = [max(0, floor(f_max - max(10 / T, f_max / 4))), min(L, floor(f_max + max(10 / T, f_max / 4)))];
stem(freqs, Ampiezze, 'dr')
xlim(interessanti);
%set(gca, "YScale", 'log');

fprintf("massima ampiezza = %f", max(Ampiezze));


% ZERO PADDING
M = 8;
[freqs, Ampiezze, fase] = myFFT([y, zeros(1, numel(y) * (M - 1))], T/L);
hold on
stem(freqs, Ampiezze * M, '.b')
hold off

legend("abs(FFT)", sprintf("abs(FFT) + zero-padding (M = %d)", M))
title("spettro");
xlabel("frequenze [Hz]");
ylabel("ampiezza [u]");
grid();

numel(y)
[f, df] = calcolaFmax(y, T/L);
fprintf("%f +- %f\n", f, df)

saveas(gcf,'tmp/prova.png')







