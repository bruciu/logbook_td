

[freqs, As] = myFFT(uu - 64.04 - 0.0001379 * tempi, (max(tempi) - min(tempi))/length(tempi));

plot(freqs, As.^2, '.-');
set(gca, "XScale", "log")
set(gca, "YScale", "log")
grid();
xlabel("frequenze [Hz]", 'interpreter', 'latex');
ylabel("ampiezze$^2$", 'interpreter', 'latex');
xlim([min(freqs), max(freqs)])
hold on;
fplot(@(x) (0.00005./sqrt(0.1.^2 + x.^2)).^2 + 0*(1e-4).^2, [1e-3, 100]);