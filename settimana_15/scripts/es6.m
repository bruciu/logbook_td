
f = @(A, x)  A.*x;
derf = @(A, x) A;

[T, P, dP, chi2, chi2rid] = fit_folder_bassa('c', "data/CIUBRU/bassa_corrente");

y = P(:,2); %V^-1
dy = dP(:, 2);
x = 1./(mean(T, 2) + 273.15); %K^-1
dx = sqrt(0.2.^2 + ((T(:, 2) - T(:,1))./2).^2).*x.^2;

x0 = [1.0]; 
w = dy;

for ii = 1:3
    fitfun = fittype(f);
    [fitted_curve,gof] = fit(x,y,fitfun,'StartPoint',x0, 'Weight', w);
    coeffvals = coeffvalues(fitted_curve);
    w = 1./sqrt((derf(coeffvals(1), x).* dx).^2 + (dy).^2);
end

errors = confint(fitted_curve);
coef = num2str(coeffvals, 5)
er = num2str(errors, 5)

subplot(3, 1, [1,2]);
hold on;
fplot(@(x) f(coeffvals(1), x));
errorbar(x, y, dy./2, dy./2, dx./2, dx./2, 'k.');

xlim([min(x) max(x)])
ylim([min(y) max(y)])
grid();
xlabel("1/T [$K^{-1}$]",  'Interpreter', 'latex')
ylabel("$P_2$ [$V^{-1}$]", 'Interpreter', 'latex');
hold off;
legend("fit", "data", 'Location', 'best');

subplot(3, 1, 3);
hold on;
plot([min(x) max(x)], 0.*[min(x) max(x)], 'k')
residui = f(coeffvals(1), x) - y;
errorbar(x, residui.*w, 1 + residui.*0, 'k.')
xlim([min(x) max(x)])
grid();
xlabel("1/T [$K^{-1}$]",  'Interpreter', 'latex')
ylabel('Residui normalizzati', 'Interpreter', 'latex');
hold off;


CHI2 =  sum(((f(coeffvals(1), x) - y).*w).^2)
CHI2norm = CHI2/(numel(y)-1)



