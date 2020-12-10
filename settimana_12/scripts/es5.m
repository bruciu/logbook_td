clear all

ig = Igrometro('COM3');

N = 1000;
uu = [];
tt = [];

for i = 1:N
    [U, T] = ig.readValue();
    uu = [uu, U];
    tt = [tt, T];
    yyaxis left;
    plot(tt, '.');
    yyaxis right;
    plot(uu, '.');
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