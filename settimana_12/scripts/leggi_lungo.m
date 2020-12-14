

% E:\

filename = 'data/datasett11_1_corretto.txt';
delimiterIn = '\t';
A = importdata(filename,delimiterIn);
u = A(:, 2);
t = A(:, 1)/1000;
T = A(:, 3);

figure;
yyaxis left
plot(t / 3600, T, '.');
ylabel("temperatura [°C]")
yyaxis right
plot(t / 3600, u, '.');
ylabel("umidità [%RH]")
xlabel("tempo [ore]");
grid()
xlim([min(t), max(t)] / 3600);


%close all;

figure;
[freqs, A] = myFFT(p - mean(p), (max(p)-min(p)) / length(p));
freqs(2:end);
A(2:end);
plot(freqs, A.^2);
xlim([min(freqs), max(freqs)]);
set(gca, "XScale", 'log');
set(gca, "YScale", 'log');
grid();
xlabel("frequenze [hz]");
ylabel("ampiezza (FFT^2) [mbar^2]");
hold on;
fplot(@(x) 1e-1./x, xlim, "linewidth", 2);
fplot(@(x) 1e-1./x.^2, xlim, "linewidth", 2);
legend("dati (FFT^2)", "andamento 1/f", "andamento 1/f^2", "Location", "Best");

hold off;

