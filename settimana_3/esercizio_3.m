
% tempo totale
T = 5; % secondi

% frequenza del segnale
f_s = 15.7; % Hz

% lunghezza del vettore (numero di punti)
n = 14;
L = 2^n;

% array dei tempi:
t = linspace(0, T, L) + randn(1, L) * T/(L)*50;

% array del segnale:
y = cos(f_s * 2 * pi * t);

[freqs, Ampiezze, fase] = myFFT(y, T/L);

subplot(2, 1, 1);
plot(t, y, '+')

subplot(2, 1, 2);
%Delta_f = 
interessanti = [1:100];
plot(freqs(interessanti), Ampiezze(interessanti), '-d')
%plot(freqs(interessanti), fase(interessanti), '-d');
%set(gca, "YScale", 'log');

fprintf("massima ampiezza = %f", max(Ampiezze));











