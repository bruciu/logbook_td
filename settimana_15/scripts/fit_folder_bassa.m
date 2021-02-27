function [T, P, dP, chi2, chi2rid, fNames] = fit_folder_bassa(type, folder, bool_plot)
%FIT_FOLDER_BASSA Summary of this function goes here
%   type  : - 'a' -> I = p1 * [exp(p2 * V) - 1]
%           - 'b' -> I = p1 * [exp(p2 * V) - 1] + p3
%           - 'c' -> I = p1 * [exp(p2 * V) - 1] + p3 + p4 * V
%           - 'd' -> I = p1 * [exp(p2 * V) - 1] + p3 + p4 * V + p5 * [exp(p2 * V / 2) - 1]
%   folder: nome della cartella

if nargin < 3
    bool_plot = false;
end

T = [];
P = [];
dP = [];
chi2 = [];
chi2rid = [];
fNames = [];

% parametri iniziali e funzione di fit
derf = @(A, B, C, G, H, x) A.*B.*exp(B.*x) + G + H.*exp(B.*x/2).*B/2;
if (type == 'a')
    X0 = [1e-11, 1./0.052];
    f = @(A, B, x) A.*(exp(B.*x) - 1);
end
if (type == 'b')
    X0 = [1e-11, 1./0.052, 0];
    f = @(A, B, C, x) A.*(exp(B.*x) - 1) + C;
end
if (type == 'c')
    X0 = [1e-11, 1./0.052, 0, 0]; 
    f = @(A, B, C, G, x) A.*(exp(B.*x) - 1) + C + G.*x;
end
if (type == 'd')
    
    X0 = [1e-3, 1./0.052, 0, 0, 1];
    f = @(A, B, C, G, H, x) A.*(exp(B.*x) - 1) + C + G.*x + H.*(exp(B.*x/2)-1);
end

fitfun = fittype(f);

runs = read_folder(folder);

for i = 1:numel(runs)
    run = runs(i);
    
    V = run.V;
    I = run.I;
    T = [T; run.T'];
    fNames = [fNames; string(run.name)];
    
    X0_tmp = X0;
    
    w = 1 + V * 0;
    
    for j = 1:3
        [fitted_curve,gof] = fit(run.V,run.I,fitfun,'StartPoint',X0_tmp, 'Weight', w);
        X0_tmp = coeffvalues(fitted_curve);
        XX0 = [X0_tmp, zeros(1, 5 - numel(X0))];
        w = 1./sqrt((derf(XX0(1), XX0(2), XX0(3), XX0(4), XX0(5), V).* 0.0001).^2 + (0.0004).^2);
    end
    
    params = X0_tmp;
    dparams = confint(fitted_curve);
    dparams = (dparams(2, :) - dparams(1, :)) ./ 2;
    
    P = [P; params];
    dP = [dP; dparams];
    
    if type == 'a'
        tmp = f(params(1), params(2), V);
    end
    if type == 'b'
        tmp = f(params(1), params(2), params(3), V);
    end
    if type == 'c'
        tmp = f(params(1), params(2), params(3), params(4), V);
    end
    if type == 'd'
        tmp = f(params(1), params(2), params(3), params(4), params(5), V);
    end
    
    CHI2 =  sum(((tmp - I).*w).^2);
    CHI2rid = CHI2/(numel(V)-5);
    
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

