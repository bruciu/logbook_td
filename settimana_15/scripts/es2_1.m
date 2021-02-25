
[T, V, I] = readiv("data/CIUBRU/bassa_corrente/CIUBRU01.txt");

x0 = [1e-11, 1./0.052, 0]; 
f = @(A, B, C, x) A.*(exp(B.*x) - 1) + C;
fitfun = fittype(f);
[fitted_curve,gof] = fit(V,I,fitfun,'StartPoint',x0);

coeffvals = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
num2str(coeffvals, 5)
num2str(errors, 5)
set(gca, 'YScale', 'log');
fplot(@(V) f(coeffvals(1), coeffvals(2), coeffvals(3), V));
hold on;

plot(V, I, 'k.-');
title(sprintf("Grafico I-V per T = %.1f $\\pm %.1f ^{\\circ} C $", mean(T), (max(T) - min(T))/2),  'Interpreter', 'latex')
xlim([min(V) max(V)])
ylim([min(I) max(I)])
grid();
xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('I [$\mu$A]', 'Interpreter', 'latex');
hold off;
set(gca, 'YScale', 'log');
legend("fit", "data", 'Location', 'best');
figure;

x0 = [1e-11, 1./0.052, 0, 0]; 
f = @(A, B, C, G, x) A.*(exp(B.*x) - 1) + C + G.*x;
fitfun = fittype(f);
[fitted_curve,gof] = fit(V,I,fitfun,'StartPoint',x0);

coeffvals = coeffvalues(fitted_curve);
num2str(coeffvals, 5)
errors = confint(fitted_curve);
num2str(errors, 5)
set(gca, 'YScale', 'log');
fplot(@(V) f(coeffvals(1), coeffvals(2), coeffvals(3), coeffvals(4), V));
hold on;

plot(V, I, 'k.-');
xlim([min(V) max(V)])
ylim([min(I) max(I)])
grid();
title(sprintf("Grafico I-V per T = %.1f $\\pm %.1f ^{\\circ} C $", mean(T), (max(T) - min(T))/2),  'Interpreter', 'latex')
xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('I [$\mu$A]', 'Interpreter', 'latex');
hold off;
set(gca, 'YScale', 'log');
legend("fit", "data", 'Location', 'best');
figure;

x0 = coeffvals; 
derf = @(A, B, C, G, x) A.*B.*exp(B.*x) + G;
w = 1./sqrt((derf(coeffvals(1), coeffvals(2), coeffvals(3), coeffvals(4), V).* 0.0001).^2 + (0.0004).^2);
fitfun = fittype(f);
[fitted_curve,gof] = fit(V,I,fitfun,'StartPoint',x0, 'Weight', w);

coeffvals = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
num2str(coeffvals, 5)
num2str(errors, 5)
set(gca, 'YScale', 'log');
fplot(@(V) f(coeffvals(1), coeffvals(2), coeffvals(3), coeffvals(4), V));
hold on;

%plot(V, I, 'k.');
errorbar(V, I, 1./w, 'k.');
title(sprintf("Grafico I-V per T = %.1f $\\pm %.1f ^{\\circ} C $", mean(T), (max(T) - min(T))/2),  'Interpreter', 'latex')
xlim([min(V) max(V)])
ylim([min(I) max(I)])
grid();
xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('I [$\mu$A]', 'Interpreter', 'latex');
hold off;
set(gca, 'YScale', 'log');
legend("fit", "data", 'Location', 'best');
figure;
subplot(3, 1, [1,2]);
set(gca, 'YScale', 'log');
fplot(@(V) f(coeffvals(1), coeffvals(2), coeffvals(3), coeffvals(4), V));
hold on;
errorbar(V, I, 1./w, 'k.');
title(sprintf("Grafico I-V per T = %.1f $\\pm %.1f ^{\\circ} C $", mean(T), (max(T) - min(T))/2),  'Interpreter', 'latex')
xlim([min(V) max(V)])
ylim([min(I) max(I)])
grid();
xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('I [$\mu$A]', 'Interpreter', 'latex');
hold off;
set(gca, 'YScale', 'log');
legend("fit", "data", 'Location', 'best');

subplot(3, 1, 3);
residui = f(coeffvals(1), coeffvals(2), coeffvals(3), coeffvals(4), V) - I;
errorbar(V, residui.*w, 1 + residui.*0, 'k.')
xlim([min(V) max(V)])
grid();
xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('Residui normalizzati', 'Interpreter', 'latex');



CHI2 =  sum(((f(coeffvals(1), coeffvals(2), coeffvals(3), coeffvals(4), V) - I).*w).^2)
CHI2norm = CHI2/(numel(V)-4)

