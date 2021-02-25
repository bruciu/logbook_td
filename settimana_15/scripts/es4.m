
[T, V, I] = readiv("data/CIUBRU/bassa_corrente/CIUBRU16.txt");

x0 = [1e-11, 1./0.052, 0]; 
f = @(A, B, C, x) A.*(exp(B.*x)) + C;
derf = @(A, B, C, x) A.*B.*exp(B.*x);
w = 1.0 + V.*0;

for ii = 1:4
    fitfun = fittype(f);
    [fitted_curve,gof] = fit(V,I,fitfun,'StartPoint',x0, 'Weight', w);
    coeffvals = coeffvalues(fitted_curve);
    w = 1./sqrt((derf(coeffvals(1), coeffvals(2), coeffvals(3), V).* 0.0001).^2 + (0.0004).^2);
end

errors = confint(fitted_curve);
coef = num2str(coeffvals, 5)
er = num2str(errors, 5)

subplot(3, 1, [1,2]);
hold on;
set(gca, 'YScale', 'log');
fplot(@(V) f(coeffvals(1), coeffvals(2), coeffvals(3), V));
errorbar(V, I, 1./w, 'k.');
title(sprintf("Grafico I-V per T = %.1f $\\pm %.1f ^{\\circ} C $", mean(T), max(0.1, (max(T) - min(T))/2)),  'Interpreter', 'latex')
xlim([min(V) max(V)])
ylim([min(I) max(I)])
grid();
xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('I [$\mu$A]', 'Interpreter', 'latex');
hold off;
set(gca, 'YScale', 'log');
legend("fit", "data", 'Location', 'best');

subplot(3, 1, 3);
residui = f(coeffvals(1), coeffvals(2), coeffvals(3), V) - I;
errorbar(V, residui.*w, 1 + residui.*0, 'k.')
xlim([min(V) max(V)])
grid();
xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('Residui normalizzati', 'Interpreter', 'latex');



CHI2 =  sum(((f(coeffvals(1), coeffvals(2), coeffvals(3), V) - I).*w).^2)
CHI2norm = CHI2/(numel(V)-4)

