
[T, V, I] = readiv("data/CIUBRU/bassa_corrente/CIUBRU16.txt");

x0 = [1e-11, 1./0.052, 0]; 
f = @(A, B, C, x) A.*(exp(B.*x) - 1) + C;
fitfun = fittype(f);
[fitted_curve,gof] = fit(V,I,fitfun,'StartPoint',x0);

% Save the coeffiecient values for a,b,c and d in a vector
coeffvals = coeffvalues(fitted_curve)
errors = confint(fitted_curve);
set(gca, 'YScale', 'log');
fplot(@(V) f(coeffvals(1), coeffvals(2), coeffvals(3), V));
hold on;

plot(V, I, 'k.-');
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

% Save the coeffiecient values for a,b,c and d in a vector
coeffvals = coeffvalues(fitted_curve)
errors = confint(fitted_curve);
set(gca, 'YScale', 'log');
fplot(@(V) f(coeffvals(1), coeffvals(2), coeffvals(3), coeffvals(4), V));
hold on;

plot(V, I, 'k.-');
xlim([min(V) max(V)])
ylim([min(I) max(I)])
grid();
xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('I [$\mu$A]', 'Interpreter', 'latex');
hold off;
set(gca, 'YScale', 'log');
legend("fit", "data", 'Location', 'best');
