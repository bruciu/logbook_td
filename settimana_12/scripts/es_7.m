clear ig

ig = Igrometro('COM3');
ig.startReading(0x20, 0x32);

N = 500;
uu = [];
tt = [];
tempi = [];

figure;
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

xlabel("tempo [s]");
yyaxis left;
ylabel("temperatura [°C]");
yyaxis right;
ylabel("umidità [PS*100]");
grid();
meanT = mean(tt);
sdvT = sqrt(var(tt));
meanU = mean(uu);
sdvU = sqrt(var(uu));
fprintf("sdv T = %f\n", sdvT);
fprintf("sdv U = %f\n", sdvU);


figure;
histogram(uu, 100);
xlabel("umidità [%RH]")
ylabel("occorrenze")

