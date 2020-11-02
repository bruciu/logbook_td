load('lunga')

x2 = DAC';
z2 = A0_medio';

x5 = DAC';
z5 = A1_medio';

f = @(m, q, x) m*x + q;
fitfun = fittype(f);
X0 = [0, 0];
[fitted_curve, gof] = fit(x2, z2, fitfun, "StartPoint", X0);
coeffvals2 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("m2 = %.10f +- %.10f\n", coeffvals2(1), (errors(2) - errors(1))/2);
[fitted_curve, gof] = fit(x5, z5, fitfun, "StartPoint", X0);
coeffvals5 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("m5 = %.10f +- %.10f\n", coeffvals5(1), (errors(2) - errors(1))/2);
xlim([0, 4095])

subplot(3, 1, [1, 2])

scatter(x2, z2, ".r")
hold on;
scatter( x5, z5, ".b")
ylim([0, 4095])
xlim([0, 4095])
plot(x2, f(coeffvals2(1), coeffvals2(2),x2), 'r')
plot(x5, f(coeffvals5(1), coeffvals5(2),x5), 'b')
hold off;

ylabel('letture ADC [u.a.]')
legend("media letture ADC0", "media letture ADC1", "best fit modello ADC0", "best fit modello ADC1")
grid()
subplot(3, 1, 3)

hold on
scatter(x2, z2 - f(coeffvals2(1), coeffvals2(2),x2), ".r")
scatter(x5, z5 - f(coeffvals5(1), coeffvals5(2),x5), ".b")
plot(x2, f(coeffvals2(1), coeffvals2(2),x2)*0, 'r')
plot(x5, f(coeffvals5(1), coeffvals5(2),x5)*0, 'b')
ylim([-70, 70])
xlim([0, 4095])

ylabel('residui [u.a.]')
xlabel('valodi DAC [u.a.]')
grid()
hold off


