[tt, yy] = leg_wavf("../data/rumore seno/sinusoidale con rumore 4.txt");

plot_N = 1000;

start = 1;

subplot(2, 1, 1);
p = plot(tt, yy, '-');
p.Color(4) = 0.1;
xlabel("tempo [s]");
ylabel("valore [u]");

subplot(2, 1, 2);
[freqs, Ampiezze, fase] = myFFT(yy, tt(2) - tt(1));
g = area(freqs, Ampiezze);
g.FaceColor = 'b';
g.EdgeColor = 'b';
g.FaceAlpha = 0.5;
set(gca, "YScale", 'log');
set(gca, "XScale", 'log');
xlabel("frequenze [Hz]");
ylabel("ampiezza [u]");
grid();

[f, df] = calcolaFmax(yy(start:end), tt(2) - tt(1));
fprintf("%f +- %f\n", f, df)
hold on
xline(f, 'r');
hold off

saveas(gcf,'tmp/prova.png')
