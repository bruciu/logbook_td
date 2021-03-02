[T, P, dP, chi2, chi2rid, fName, Imin] = fit_folder_alta("data/CIUBRU/alta_corrente");

T = T + 273.15;
Tm = mean(T,2);

E = 1.602176634e-19;
K = 1.380649e-23;

x = Tm;
y = P(:, 3);
dx = sqrt(0.2.^2 + ((T(:, 2) - T(:, 1))/2).^2);
dy = dP(:, 3);

errorbar(x, y, dy, dy, dx, dx, 'k.-');

grid();
xlabel("Temperatura [K]",  'Interpreter', 'latex')
ylabel('R [$\Omega$]', 'Interpreter', 'latex');

return;
f = @(eta, x) eta .* K./E .* x;
derf = @(eta, x) eta .* K./E;
fitfun = fittype(f);

X0 = [0];

x = Tm;
y = P(:, 2);
dx = sqrt(0.2.^2 + ((T(:, 2) - T(:, 1))/2).^2);
dy = dP(:, 2);

w = dy*0 + 1;

for j = 1:3
    [fitted_curve,gof] = fit(x,y,fitfun,'StartPoint',X0, 'Weight', w);
    %[fitted_curve,gof] = fit(x,y,fitfun,'StartPoint',X0);
    params = coeffvalues(fitted_curve);
    %         w = 1./sqrt((derf(params(1), params(2), params(3), x).* dx).^2 + (dy).^2);
    w = 1./sqrt((derf(params(1), x).* dx).^2 + (dy).^2);
end

params
dparams = confint(fitted_curve);
dparams = (dparams(2, :) - dparams(1, :)) ./ 2

figure;
hold on;
errorbar(x, y, dy, dy, dx, dx, 'k.');
plot(x, f(params(1), x), '-');
grid();
xlabel("Temperatura [K]",  'Interpreter', 'latex')
ylabel('$\eta V_t$ [V]', 'Interpreter', 'latex');
legend("data","fit");
hold off;

residui = f(params(1), x) - y;

CHI2 =  sum((residui.*w).^2);
CHI2rid = CHI2/(numel(residui)-1);
