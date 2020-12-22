%prima esguire es7.m
x = rot;
t = tempo;
[freqs, As] = myFFT(x, (max(t)-min(t))/length(t));
freqs = freqs(2:end);
As = As(2:end);
hold on;
ylabel("Ampiezze PSD(\theta)");

plot(freqs, As.^2, 'k');
set(gca, "XScale", 'log');
set(gca, "YScale", 'log');


xlabel("frequenza [Hz]");
plot(freqs, 10.^(-10)./freqs.^2, 'r-')
xlim([min(freqs), max(freqs)]);
legend("PSD", "\sim 1/frequenza^2");
grid();
hold off;