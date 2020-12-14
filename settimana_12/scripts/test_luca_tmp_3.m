

figure;

yyaxis left;
plot(tempi, tt, '.');
ylabel("temperatura [°C]");

yyaxis right;
plot(tempi, uu, '.');
ylabel("umidità [%RH]");

xlabel("tempo [s]");
xlim([min(tempi), max(tempi)])
grid();


selezionati = 200:900;
tempi_tmp = tempi(selezionati);
uu_tmp = uu(selezionati);


funz = @(A, tau, u, x) A*exp(-x/tau) + u
fitfun = fittype(funz);
X0 = [-100, 10, 95];%
[fitted_curve, gof] = fit(tempi_tmp', uu_tmp', fitfun, "StartPoint", X0);
coeffvals = coeffvalues(fitted_curve);
errors = confint(fitted_curve);

figure;
hold on;
plot(tempi_tmp, uu_tmp, 'k.');
plot(tempi_tmp, funz(coeffvals(1), coeffvals(2), coeffvals(3), tempi_tmp), 'r-');
xlim([min(tempi_tmp), max(tempi_tmp)])
ylabel("umidità [%RH]");
xlabel("tempo [s]");
grid();
legend("dati", "funzione di fit", 'location', 'best');
hold off;

fprintf("A = %f +- %f\n", coeffvals(1), (errors(2, 1) - errors(1, 1))/2);
fprintf("tau = %f +- %f\n", coeffvals(2), (errors(2, 2) - errors(1, 2))/2);
fprintf("u = %f +- %f\n", coeffvals(3), (errors(2, 3) - errors(1, 3))/2);

fprintf("chi2 rid. = %f\n", sum(((funz(coeffvals(1), coeffvals(2), ...
    coeffvals(3), tempi_tmp) - uu_tmp)/0.02).^2) / length(uu_tmp));





