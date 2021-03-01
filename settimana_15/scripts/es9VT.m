f = @(A,B, x) - A + B.*x;

plot(T, V, '.');

x0 = [1.0, -355.6]; 

for ii = 1:4
    fitfun = fittype(f);
    [fitted_curve,gof] = fit(V,T,fitfun,'StartPoint',x0);
    coeffvals = coeffvalues(fitted_curve);
end

errors = confint(fitted_curve);
coef = num2str(coeffvals, 5);
er = num2str(errors, 5);

hold on;
set(gca, 'YScale', 'log');
fplot(@(V) f(coeffvals(1), coeffvals(2), V), 'r');
plot(V, T, 'k.');
title(sprintf("Grafico T-V per I = %.1f $\\mu A$", I(1)),  'Interpreter', 'latex');
xlim([min(V) max(V)])
ylim([min(T) max(T)])
grid();
xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('T [K]', 'Interpreter', 'latex');
hold off;
legend("fit", "data", 'Location', 'best');

