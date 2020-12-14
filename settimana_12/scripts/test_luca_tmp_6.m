

figure;
yyaxis left;
plot(tempi, tt);
ylabel("temperatura [°C]");
yyaxis right;
plot(tempi, uu);
ylabel("umidità [%RH]");
xlabel("tempo [s]");
grid();

xlim([min(tempi), max(tempi)])


figure;
plot(tempi, uu - 64.04 - 0.0001379 * tempi, '.k');
ylabel("umidità [%RH]");
xlabel("tempo [s]");
grid();


histogram(uu, 50);





