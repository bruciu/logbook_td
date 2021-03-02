%prima fare es7 e poi scegliere quelli fatti bene

close all;

f    = @(I0, Eg, x) I0 .* exp(-Eg .* E ./ (2.*K) .* x);
derf = @(I0, Eg, x) I0 .* (-Eg.* E ./ (2.*K)) .* exp(-Eg .* E ./ (2.*K) .* x);
fitfun = fittype(f);

% le nostre x
xx = 1.0./Tm;% ????????????????

X0 = [1, 1.5];
X0_tmp = X0;

w = 1 + xx * 0;

figure;
hold on;
errorbar(xx, p, dp, ".-");
plot(xx, f(X0(1),X0(2), xx));
set(gca, 'YScale', 'log');
%pause;
%[1 1] + [1;1];
    
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

figure;
hold on;
errorbar(xx, p, dp, ".-");
plot(xx, f(params(1),params(2), xx));
set(gca, 'YScale', 'log');
return;

close all;
figure;
hold on;
errorbar(xx, p, dp, 'k.-');
fplot(@(Tmk) f(params(1), params(2), Tmk));
fplot(@(Tm) f(X0(1), X0(2), Tm));
grid();
xlabel("Temperatura [K]",  'Interpreter', 'latex')
ylabel('$I_{GR}$ $[\mu A]$', 'Interpreter', 'latex');
%legend("data","fit");
%set(gca, 'YScale', 'log');
hold off;