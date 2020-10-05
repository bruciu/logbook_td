[x2,y2,z2] = leg_wavf3pars("../dati_seconda_settimana/cortocirc/acquis2.txt");
[x5,y5,z5] = leg_wavf3pars("../dati_seconda_settimana/cortocirc/acquis5.txt");
%plot(x, y);
%figure;
%plot(x, z, '+')
f = @(m,x) m*x;
fitfun = fittype(f);
X0 = [0];
[fitted_curve, gof] = fit(x2, z2, fitfun, "StartPoint", X0);
coeffvals2 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("m2 = %.10f +- %.10f\n", coeffvals2(1), (errors(2) - errors(1))/2);
[fitted_curve, gof] = fit(x5, z5, fitfun, "StartPoint", X0);
coeffvals5 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("m5 = %.10f +- %.10f\n", coeffvals5(1), (errors(2) - errors(1))/2);

scatter(x2, z2, "+")
hold on;
scatter( x5, z5, "+")
plot(x2, f(coeffvals2(1),x2))
plot(x5, f(coeffvals5(1),x5))
hold off;