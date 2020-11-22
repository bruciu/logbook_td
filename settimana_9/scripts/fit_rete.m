R1_val = 11e3;
C1_val = 10e-9;

funz_orig = @(tau, x) (1i.*2.*pi.*x.*tau)./(3.*1i.*2.*pi.*x.*tau + 1 - (2.*pi.*x.*tau).^2);
funz = @(tau, x) abs(funz_orig(tau, x));

fitfun = fittype(funz);
X0 = [R1_val*C1_val];
[fitted_curve, gof] = fit(f', guad', fitfun, "StartPoint", X0, 'Weight', 1./(dguad'));
coeffvals2 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("p11 = %.10f +- %.10f\n", coeffvals2(1), (errors(2, 1) - errors(1, 1))/2);

hold on;
errorbar(f, guad, dguad, 'k.');
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
plot(f, funz(coeffvals2(1), f), 'r');
plot(f, funz(X0(1), f), 'b');
hold off
grid()
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
grid()
xlabel("Frequenza [Hz]")
ylabel("Guadagno")
legend('dati', 'fit', 'atteso', 'Location', 'SouthEast')
grid()
saveas(gcf,'tmp/provaes_fit_rete.png');
hold off;



%plot(f, funz(R1.*C1, f));
%set(gca, 'XScale', 'log');
%set(gca, 'YScale', 'log');