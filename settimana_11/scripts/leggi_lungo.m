

% E:\

filename = 'data/datasett11_serena_corretto.txt';
delimiterIn = '\t';
A = importdata(filename,delimiterIn);
p = A(:, 2);
t = A(:, 1)/60000;
T = A(:, 3);

figure;
hold on;
plot(t, p, '.k');
sm = smussaf(p, 0.05);
plot(t, sm, "linewidth", 2);
hold off;
xlabel("tempo [min]");
ylabel("pressione [mbar]")
grid()
legend("letture", "smooth 5% armoniche", "location", "best");
xlim([min(t), max(t)]);

figure;
hold on;
plot(t, T, '.k');
sm = smussaf(T, 0.05);
plot(t, sm, "linewidth", 2);
hold off;
xlabel("tempo [min]");
ylabel("temperatura [°C]")
grid()
legend("letture", "smooth 5% armoniche", "location", "best");
xlim([min(t), max(t)]);

figure;
[freqs, A] = myFFT(T - mean(T), (max(p)-min(p)) / length(p));
plot(A.^2);
set(gca, "XScale", 'log');
set(gca, "YScale", 'log');
hold on;
fplot(@(x) 0.1/x.^2 + 1e-7, xlim);
fplot(@(x) 0.1/x + 1e-7, xlim);

hold off;

