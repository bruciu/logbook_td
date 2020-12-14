clear all

ig = Igrometro('COM3');

N = 20000;
uu = [];
tt = [];
tempi = [];

tic;
wb = waitbar(0, "aspetta");
for i = 1:N
    waitbar(i/N, wb);
    [U, T] = ig.readValue();
    uu = [uu, U];
    tt = [tt, T];
    tempi = [tempi, toc];
    yyaxis left;
    plot(tempi, tt, '.');
    yyaxis right;
    plot(tempi, uu, '.');
end
close(wb);

xlabel("numero di lettura");
yyaxis left;
ylabel("temperatura [°C]");
yyaxis right;
ylabel("umidità [PS*100]");
grid();
meanT = mean(tt);
sdvT = sqrt(var(tt));
meanU = mean(uu);
sdvU = sqrt(var(uu));
xlabel("Tempo [s]");
save("UTSeretazzina_termalizzata10.mat", "tempi", "tt", "uu");