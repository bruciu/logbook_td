function [T, P, dP, chi2, chi2rid, fNames, Imin] = fit_folder_alta(folder, bool_plot)

if nargin < 2
    bool_plot = false;
end

T = [];
P = [];
dP = [];
chi2 = [];
chi2rid = [];
fNames = [];
Imin = [];

m_epsylon = sqrt(sqrt(eps));% doppia radice per avere numeri più grandi
epsylon = @(x) abs(x) .* m_epsylon + m_epsylon;

% funzione di fit:
f = @(Is, nVt, R, x) curr_G(x, Is, nVt, R, 0);
%derivata:
derf = @(Is, nVt, R, x)...
    (f(Is, nVt, R, x + epsylon(x)) - f(Is, nVt, R, x))./...
    epsylon(x);


fitfun = fittype(f);
X0 = [0.6e-3, 0.045, 1.95];
runs = read_folder(folder);


for i = 1:numel(runs)
    run = runs(i);
    
    selezionati = run.I > 2.0;
    V = run.V(selezionati);
    I = run.I(selezionati);
    T = [T; run.T'];
    Imin = [Imin, min(run.I)];
    fNames = [fNames; string(run.name)];
    
    dV = V * 0 + 0.1e-3;
    dI = I * 0 + 0.4;
    
    w = 1 + V * 0;
    
    for j = 1:3
        [fitted_curve] = fit(V, I,fitfun,'StartPoint',X0, 'Weight', w, 'Lower',[-Inf, -Inf, sqrt(eps)*2], 'Upper', [Inf, Inf, Inf]);
        params = coeffvalues(fitted_curve);
        w = 1./sqrt((derf(params(1), params(2), params(3), V).* dV(1)).^2 + (dI(1)).^2);
    end
    
    dparams = confint(fitted_curve);
    dparams = (dparams(2, :) - dparams(1, :)) ./ 2;
    
    P = [P; params];
    dP = [dP; dparams];
    
    tmp = f(params(1), params(2), params(3), V);
    
    CHI2 =  sum(((tmp - I).*w).^2);
    CHI2rid = CHI2/(numel(V)-3);
    
    chi2 = [chi2; CHI2];
    chi2rid = [chi2rid; CHI2rid];
    
    if (bool_plot)
        fig = figure;
        hold on
        plot(V, I, '.');
        plot(V, tmp);
        set(gca, 'YScale', 'log');
        pause(1);
        close(fig);
    end
end


end

