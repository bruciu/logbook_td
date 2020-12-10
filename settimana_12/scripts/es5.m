clear all

ig = Igrometro('COM3');

N = 10000;
uu = [];
tt = [];
tempi = [];

tic;
for i = 1:N
    [U, T] = ig.readValue();
    uu = [uu, U];
    tt = [tt, T];
    tempi = [tempi, toc];
    yyaxis left;
    plot(tempi, tt, '.');
    yyaxis right;
    plot(tempi, uu, '.');
end

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