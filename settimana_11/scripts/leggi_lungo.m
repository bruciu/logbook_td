

% E:\

filename = 'data/datasett11_lunga_corretto.txt';
delimiterIn = '\t';
A = importdata(filename,delimiterIn);
p = A(:, 2);
t = A(:, 1);
T = A(:, 3);

figure;
hold on;
plot(t, p, '.k');
sm = smussaf(p, 0.01);
plot(t, sm, 'r', "linewidth", 1);
hold off;
xlabel("tempo [ore]");
ylabel("pressione [mbar]")
grid()
legend("letture", "smooth 1% armoniche", "location", "best");
xlim([min(t), max(t)]);

figure;
hold on;
plot(t, T, '.k');
sm = smussaf(T, 0.05);
plot(t, sm, 'r', "linewidth", 1);
hold off;
xlabel("tempo [ore]");
ylabel("temperatura [°C]")
grid()
legend("letture", "smooth 1% armoniche", "location", "best");
xlim([min(t), max(t)]);

close all;

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
fplot(@(x) 1e-1/x, xlim, "linewidth", 2);
fplot(@(x) 1e-1/x.^2, xlim, "linewidth", 2);
legend("dati (FFT^2)", "andamento 1/f", "andamento 1/f^2", "Location", "Best");

hold off;

