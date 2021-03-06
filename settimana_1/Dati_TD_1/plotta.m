[x, y] = leg_wavf("acquisizione1.txt");
plot(x, y);
fprintf("massimo = %f\n", max(y));
fprintf("minimo = %f\n", min(y));

pause(2);

f = @(a, b, c, om, x) a * sin(x * om + c) + b;
fitfun = fittype(f);
X0 = [0.35, 0, 2, 1.5 * 10^4];
[fitted_curve, gof] = fit(x, y, fitfun, "StartPoint", X0);
coeffvals = coeffvalues(fitted_curve);
fprintf("periodo = %f\n", 2 * pi / coeffvals(4));

scatter(x, y, "+")
hold on;
plot(x, f(coeffvals(1), coeffvals(2), coeffvals(3), coeffvals(4), x))
hold off;