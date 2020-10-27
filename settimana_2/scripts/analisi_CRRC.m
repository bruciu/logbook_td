[freqs, As, phis] = leg_wavf3pars("../dati_seconda_settimana/passabanda/acquispassa2.txt");
[freqs, As, phis] = leg_wavf3pars("../../../../esp_2/prova_estremis_crrc/crrc_3.txt");

% m = 0.0000313944;
% dm = 0.0000000185;
m = 0.0000156965;
dm = 0.0000000029;

%matlabFunction(H_CRRC)

% C1 = C1_val;
% C2 = C2_val;
% R1 = R1_val;
% R2 = R2_val;

Zth_crrc = @(C1, C2, R1, R2, f) Rth_crrc_raw(R1, R2, f, 1/(2*pi*C1*R1), 1/(2*pi*C2*R2));
H_crrc = @(C1, C2, R1, R2, f) H_crrc_raw(C1, C2, f, 1/(2*pi*C1*R1), 1/(2*pi*C2*R2));

A_crrc_raw;
A_crrc = @(C1, C2, R1, R2, f) A_crrc_raw(C1, C2, f, 1/(2.*pi.*C1.*R1), 1/(2*pi.*C2.*R2));
A_crrc_mod = @(C1, C2, R1, R2, Rout, f) abs(H_crrc(C1, C2, R1, R2, f) .* Rout ./...
    (Rout + Zth_crrc(C1, C2, R1, R2, f)));
A_crrc_mod2 = @(C1, C2, R1, R2, Rout, Cout, f) A_crrc_mod(C1, C2, R1, R2, 1 ./ (1 / Rout + 1i .* 2.*pi .* f .* Cout), f);
%A_crrc(C1, C2, R1, R2, f) * Rout /...
 %   (Rout + Rth_crrc(C1, C2, R1, R2, f));

f = @(C1, C2, R1, R2, Rout, x) A_crrc_mod(C1 * 1e-9, C2 * 1e-9, R1 * 1e3, R2 * 1e3, Rout * 1e3, x);
f2 = @(C1, C2, R1, R2, Rout, Cout, x) A_crrc_mod2(C1 * 1e-9, C2 * 1e-9, R1 * 1e3, R2 * 1e3, Rout * 1e3, Cout * 1e-9, x);
fitfun = fittype(f);
fitfun2 = fittype(f2);
X0 = [C1_val / 1e-9, C2_val / 1e-9, R1_val / 1e3, R2_val / 1e3, 50e3 / 1e3];
X02 = [C1_val / 1e-9, C2_val / 1e-9, R1_val / 1e3, R2_val / 1e3, 50e3 / 1e3, 0.01];
[fitted_curve, gof] = fit(freqs, As, fitfun, "StartPoint", X0);
[fitted_curve2, gof2] = fit(freqs, As, fitfun2, "StartPoint", X02);
coeffvals = coeffvalues(fitted_curve);
coeffvals2 = coeffvalues(fitted_curve2);
errors = confint(fitted_curve);
for x = coeffvals
    x
end
 
plot(freqs, As, "+")
hold on;
plot(freqs, A_crrc(C1_val, C2_val, R1_val, R2_val, freqs))
plot(freqs, A_crrc_mod(C1_val, C2_val, R1_val, R2_val, 50e3, freqs))
c = coeffvals;
c2 = coeffvals2;
plot(freqs, f(c(1), c(2), c(3), c(4), c(5), freqs))
plot(freqs, f2(c2(1), c2(2), c2(3), c2(4), c2(5), c2(6), freqs))
c2

% phis = phis - m * freqs;
% plot(freqs, phis)

set(gca, "XScale", 'log');
