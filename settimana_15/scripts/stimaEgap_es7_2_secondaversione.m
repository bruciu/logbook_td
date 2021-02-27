%prima fare es7 e poi scegliere quelli fatti bene

%Tm è in kelvin 

ITm = 1./Tm;
dITm = dTm./Tm.^2;


f = @(A, B, C, x) A - B.*x + C.*log10(x); 
derf = @(A, B, C, x) - B + C./x;

X0 = [1, 1, 0];

fitfun = fittype(f);

x = ITm; dx = dITm; y = log10(p.*10e-6); dy = dp./p; %la corrente l'ho messa in Ampere

w = 1./dy;

    for j = 1:3
        [fitted_curve,gof] = fit(x,y,fitfun,'StartPoint',X0, 'Weight', w);
        %[fitted_curve,gof] = fit(x,y,fitfun,'StartPoint',X0);
        params = coeffvalues(fitted_curve);
        w = 1./sqrt((derf(params(1), params(2), params(3), x).* dx).^2 + (dy).^2);
    end
    
params
dparams = confint(fitted_curve);
dparams = (dparams(2, :) - dparams(1, :)) ./ 2

residui = f(params(1), params(2), params(3), x) - y;
CHI2 =  sum((residui.*w).^2);
CHI2rid = CHI2/(numel(residui)-2);

hold on;

errorbar(x, y, dy, dy, dx, dx, 'k.-');
%plot(x, y, 'k.-');
plot(x, f(params(1), params(2), params(3), x), '-');
%errorbar(Tmk, p, dp./2, dp./2, dTm/2, dTm/2, 'k.-');
%plot(ITm, f(params(1), params(2), ITm), '-');
%fplot(@(Tmk) f(params(1), params(2), ITm));
%plot(ITm, f(X0(1), X0(2), ITm));
grid();
xlabel("Temperatura [K]",  'Interpreter', 'latex')
ylabel('$I_{GR}$ $[\mu A]$', 'Interpreter', 'latex');
%legend("data","fit");
%set(gca, 'YScale', 'log');
hold off;