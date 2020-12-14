

[freqs, As] = myFFT(uu - 64.04 - 0.0001379 * tempi, (max(tempi) - min(tempi))/length(tempi));
%[freqs, As] = myFFT(uu, (max(tempi) - min(tempi))/length(tempi));
freqs = freqs(2:end);
As = As(2:end);

plot(freqs, As.^2, '.-');
set(gca, "XScale", "log")
set(gca, "YScale", "log")
grid();
xlabel("frequenze [Hz]", 'interpreter', 'latex');
ylabel("ampiezze$^2$", 'interpreter', 'latex');
xlim([min(freqs), max(freqs)])
hold on;
fplot(@(x) (0.00005./sqrt(0.1.^2 + (x * 2 * pi).^2)).^2 + 0*(1e-4).^2, [1e-3, 100]);
legend("FFT dati", "andamento browniano")
ylim([10e-11, 10e-6]);