%prima fare es7 e poi scegliere quelli fatti bene

f = @(A, Egap, x) A.*exp(-Egap./(2.*K.*(x + 273.15)));

derf = @(A, Egap, x) A.*Egap.*exp(-Egap./(2.*K.*(x + 273.15)));

X0 = [0.0011, 3e20];
X0_tmp = X0;

fitfun = fittype(f);

w = 1./dp;
    
    for j = 1:3
        [fitted_curve,gof] = fit(Tm,p,fitfun,'StartPoint',X0_tmp, 'Weight', w);
        X0_tmp = coeffvalues(fitted_curve);
        w = 1./sqrt((derf(X0_tmp(1), X0_tmp(2), Tm).* dTm).^2 + (dp).^2);
    end
    
params = X0_tmp;
dparams = confint(fitted_curve);
dparams = (dparams(2, :) - dparams(1, :)) ./ 2;

residui = f(params(1), params(2), Tm) - p;
CHI2 =  sum((residui.*w).^2);
CHI2rid = CHI2/(numel(residui)-2);

hold on;
%errorbar(Tmk, p, dp./2, dp./2, dTm/2, dTm/2, 'k.-');
fplot(@(Tmk) f(params(1), params(2), Tm));
%fplot(@(Tm) f(X0(1), X0(2), Tm));
grid();
xlabel("Temperatura [K]",  'Interpreter', 'latex')
ylabel('$I_{GR}$ $[\mu A]$', 'Interpreter', 'latex');
%legend("data","fit");
set(gca, 'YScale', 'log');
hold off;