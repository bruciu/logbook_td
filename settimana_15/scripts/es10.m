%scala biliniare dei dati

[T, V, I] = readiv("data/CIUBRU/alta_corrente/CIUBRU50.txt");

plot(V, I, 'k.-');
xlim([min(V) max(V)])
ylim([min(I) max(I)])
grid();
xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('I [$\mu$A]', 'Interpreter', 'latex');
% set(gca, 'YScale', 'log');
% set(gca, 'XScale', 'log');

%%%%%%%FIT
x0 = [0, 1./0.052, 1e-3]; 
f = @(R, B, Is, x) R.*x + (1./B).*log(x/Is);
derf = @(R, B, Is, x) R + (1./(B.*x));
w = 1.0 + V.*0;

for ii = 1:4
    fitfun = fittype(f);
    [fitted_curve,gof] = fit(I, V,fitfun,'StartPoint',x0, 'Weight', w, 'Lower', [-Inf, -Inf, sqrt(eps)*2]);
    coeffvals = coeffvalues(fitted_curve);
    w = 1./sqrt((derf(coeffvals(1), coeffvals(2), coeffvals(3), V).* 0.0004).^2 + (0.0001).^2);
end

errors = confint(fitted_curve);
coef = num2str(coeffvals, 5)
er = num2str((errors(2,:) - errors(1,:))/2, 5)

subplot(3, 1, [1,2]);
hold on;
set(gca, 'YScale', 'log');
fplot(@(I) f(coeffvals(1), coeffvals(2), coeffvals(3), I));
errorbar(I, V, 1./w, 'k.');
title(sprintf("Grafico V-I per T = %.1f $\\pm %.1f ^{\\circ} C $", mean(T), max(0.1, (max(T) - min(T))/2)),  'Interpreter', 'latex')
%ylim([min(V) max(V)])
%xlim([min(I) max(I)])
grid();
ylabel("d.d.p. [V]",  'Interpreter', 'latex')
xlabel('I [$\mu$A]', 'Interpreter', 'latex');
hold off;
set(gca, 'YScale', 'log');
legend("fit", "data", 'Location', 'best');

subplot(3, 1, 3);
residui = f(coeffvals(1), coeffvals(2), coeffvals(3), I) - V;
errorbar(I, residui.*w, 1 + residui.*0, 'k.')
xlim([min(I) max(I)])
grid();
xlabel('I [$\mu$A]', 'Interpreter', 'latex');
ylabel('Residui normalizzati', 'Interpreter', 'latex');



CHI2 =  sum(((f(coeffvals(1), coeffvals(2), coeffvals(3), V) - I).*w).^2)
CHI2norm = CHI2/(numel(V)-4)