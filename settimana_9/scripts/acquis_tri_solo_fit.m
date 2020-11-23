% fit

fmax = calcolaFmax(y0 - mean(y0), t(2)-t(1));

funz = @(f, A, b, phi, d, x) sawtooth(x * f * 2 * pi + phi, d)*A + b;
fitfun = fittype(funz);
X0 = [fmax, 1800, 2048, 0, 0.5];%
[fitted_curve, gof] = fit(t', y0', fitfun, "StartPoint", X0, 'Weight', 1./(dy0'));
coeffvals = coeffvalues(fitted_curve);
errors = confint(fitted_curve);


figure;
% subplot(3, 1, [1, 2])
hold on;
errorbar(t, y0, dy0, '.k');
funz_vals = funz(coeffvals(1), coeffvals(2), coeffvals(3), coeffvals(4), ...
    coeffvals(5), t);
plot(t, funz_vals, 'r', "LineWidth", 2);
xlabel("tempo [s]");
ylabel("letture [digit]");
legend("A0", "fit (sawtooth)", "Location", "best");
fprintf("f = %f +- %f\n", coeffvals(1), (errors(2, 1) - errors(1, 1))/2);
fprintf("A = %f +- %f\n", coeffvals(2), (errors(2, 2) - errors(1, 2))/2);
fprintf("b = %f +- %f\n", coeffvals(3), (errors(2, 3) - errors(1, 3))/2);
fprintf("phi = %f +- %f\n", coeffvals(4), (errors(2, 4) - errors(1, 4))/2);
fprintf("duty = %f +- %f\n", coeffvals(5), (errors(2, 5) - errors(1, 5))/2);
ylim([min(y0), max(y0)]);
grid();

% subplot(3, 1, 3)
% errorbar(t, (y0 - funz_vals)./dy0, dy0 * 0 + 1, '.k');
% xlabel("tempo [s]");
% ylabel("residui normalizzati");
% ylim([-10, 10])
hold off;

% f = 49.266683 +- 0.002569
% A = 957.042229 +- 0.179080
% b = 2042.691833 +- 0.110958
% phi = 0.789916 +- 0.000530
% duty = 0.479644 +- 0.000099









