name = "data8";
[tt, v_in, v_out] = leg_wavf2g("../data/FFT2/" + name + ".txt", false);

% -f/f_T= - RCf
% 1/sqrt(1 + (f/ft)^2)

ft = 1 / (2.2e-3 * 2 * pi);
A_teorico_per_fit = @(ft, f) 1./sqrt(1 + (f./ft).^2);
sfasamento_teorico_per_fit = @(ft, f) atan(-f./ft);

% varianza sulle y (scelta arbitrariamente = alla risoluzione)
dy = 10 / 4095;

% intervallo tra 2 misure
dt = tt(2) - tt(1);

% Delta \phi = {​​​​{​​​​\pi  f}​​​​\over{​​​​SR}​​​​}​​​​
correzione_phi = @(f) pi.*f.*dt;

% calcola le due trasformate con gli errori
[freqs_tmp, A_1, dA_1, phi_1, dphi_1] = calcolaFFT_errori(v_in, dy, dt);
[~        , A_2, dA_2, phi_2, dphi_2] = calcolaFFT_errori(v_out, dy, dt);

% calcola il guadagno
A_tmp = A_2 ./ A_1;
dA_tmp = sqrt((dA_2 ./ A_1).^2 + (A_2 .* dA_1 ./ A_1.^2).^2);

% calcola sfasamento
phi_tmp = mod(phi_2 - phi_1 + pi, 2 * pi) - pi - correzione_phi(freqs_tmp);
dphi_tmp = sqrt(dphi_2.^2 + dphi_1.^2);

% seleziona i dati il cui errore relativo sul guadagno e' < 0.5
clear A dA phi dphi freqs
counter = 0;
for i = 1:numel(freqs_tmp)
    if (dA_tmp(i) / A_tmp(i) < 0.5)
        counter = counter + 1;
        c = counter;
        
        freqs(c) = freqs_tmp(i);
        
        A(c) = A_tmp(i);
        dA(c) = dA_tmp(i);
        
        phi(c) = phi_tmp(i);
        dphi(c) = dphi_tmp(i);
    end
end

f = @(ft, x) A_teorico_per_fit(ft, x);
fitfun = fittype(f);
X0 = [ft];
%[fitted_curve, gof] = fit(freqs, A, fitfun, "StartPoint", X0, 'Weights', 1./(dA));
[fitted_curve, gof] = fit(freqs', A', fitfun, "StartPoint", X0, 'Weights', 1./(dA));
coeffvals = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("ft " + name + " = %.10f +- %.10f\n", coeffvals(1), (errors(2) - errors(1))/2);
ft = coeffvals(1);
A_teorico = @(f) 1./sqrt(1 + (f./ft).^2);
sfasamento_teorico = @(f) atan(-f./ft);

fig1 = figure;
title(name)
hold on
p = errorbar(freqs, A, dA, '.k');
% Set transparency (undocumented)
p.CapSize = 0;
%p.MarkerSize = 3;
%set([p.Bar, p.Line], 'ColorType', 'truecoloralpha', 'ColorData', [p.Line.ColorData(1:3); 255*0.1])
ylim([0, 1.1]);
set(gca, "YScale", 'log');
set(gca, "XScale", 'log');
xlabel("frequenza [Hz]");
ylabel("guadagno");
grid();
fplot(A_teorico, 'r');
legend("data", "modello");
hold off
saveas(gcf,"tmp/guadagno_" + name + ".png")

fig2 = figure;
title(name)
hold on
p = errorbar(freqs, phi, dphi, '+k');
p.CapSize = 0;
ylim([-2, 2]);
set(gca, "XScale", 'log');
xlabel("frequenza [Hz]");
ylabel("differenza di fase [Rad]");
grid();
fplot(sfasamento_teorico, 'r');
legend("data", "modello");
hold off
saveas(gcf,"tmp/sfasamento_" + name + ".png")






