guad = As;
dguad = dAs;
freqs = f;

R2_val = (10e3)/2;
R1_val = 1e3;
C1_val = 10e-9;
C2_val = 68e-9;

funz = @(fti, ftd, x) 1./sqrt((1 + (x./fti).^2).*(1 + (ftd./x).^2));
fitfun = fittype(funz);
X0 = [1./(2*pi*R1_val*C1_val), 1./(2*pi*R2_val*C2_val)];%
[fitted_curve, gof] = fit(freqs', guad', fitfun, "StartPoint", X0, 'Weight', 1./(dguad'));
coeffvals2 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("fti = %.10f +- %.10f\n", coeffvals2(1), (errors(2, 1) - errors(1, 1))/2);
fprintf("ftd = %.10f +- %.10f\n", coeffvals2(2), (errors(2, 2) - errors(1, 2))/2);
hold on;
errorbar(freqs, guad, dguad, 'k.');
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
plot(freqs, funz(coeffvals2(1), coeffvals2(2), freqs), 'r');
xlabel("Frequenza [Hz]")
ylabel("Guadagno")
legend('dati', 'fit', 'Location','northwest')
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
grid()
plot(freqs, funz(X0(1), X0(2), freqs), 'b');
hold off
saveas(gcf,'tmp/provaes10.png');
hold off;