

[freqs, Ampiezze, fase] = myFFT(temperature - mean(temperature),...
    (max(tempi)-min(tempi))/length(tempi));

g = area(freqs(2:end), Ampiezze(2:end).^2);
g.FaceColor = 'b';
g.EdgeColor = 'b';
g.FaceAlpha = 0.5;

set(gca, "XScale", 'log')
set(gca, "YScale", 'log')
xlim([freqs(2), freqs(end)])

xlabel("frequenza [Hz]")
ylabel("intensità")

