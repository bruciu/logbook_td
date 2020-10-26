load('tmp/Bode_guadagno_es14.mat')

%funz = @(ft, b, q, x) sqrt((1./sqrt((1 + q)^2 + (ft./x).^2)).^2 + b^2);

funz_orig = @(ft, r_int, x) 1./sqrt((1 + r_int).^2 + (ft./x).^2);
funz = @(ft, b, r_int, alpha, x) sqrt(funz_orig(ft, r_int, x).^2 + b.^2 + 2 .* b .* funz_orig(ft, r_int, x) .* cos(alpha));

fitfun = fittype(funz);
X0 = [1/(2*pi*5e3*10e-9), 0, 0, 0];
[fitted_curve, gof] = fit(f', guad', fitfun, "StartPoint", X0, 'Weight', 1./(dguad'));
coeffvals2 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("ft = %.10f +- %.10f\n", coeffvals2(1), (errors(2) - errors(1))/2);
fprintf("b = %.10f\n", coeffvals2(2));
fprintf("q = %.10f\n", coeffvals2(3));
%plot(f, funz(coeffvals2(1), f), 'b', 'LineWidth', 2);
figure;
hold on;
errorbar(f, guad, dguad, 'k.');
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
plot(f, funz(coeffvals2(1), coeffvals2(2), coeffvals2(3), coeffvals2(4), f), 'r');
hold off
grid()
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
grid()
xlabel("Frequenza [Hz]")
ylabel("Guadagno")
saveas(gcf,'tmp/provaes15.png');
legend('fit', 'dati')
hold off;

