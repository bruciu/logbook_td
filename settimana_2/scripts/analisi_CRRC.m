[freqs, As, phis] = leg_wavf3pars("../dati_seconda_settimana/passabanda/acquispassa2.txt");

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
%A_crrc(C1, C2, R1, R2, f) * Rout /...
 %   (Rout + Rth_crrc(C1, C2, R1, R2, f));

f = @(C1, C2, R1, R2, Rout, x) A_crrc_mod(C1, C2, R1, R2, Rout, x);
fitfun = fittype(f);
X0 = [C1_val, C2_val, R1_val, R2_val, 100e3];
[fitted_curve, gof] = fit(freqs, As, fitfun, "StartPoint", X0);
coeffvals = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
for x = coeffvals
    x
end
 
plot(freqs, As, "+")
hold on;
plot(freqs, A_crrc(C1_val, C2_val, R1_val, R2_val, freqs))
plot(freqs, A_crrc_mod(C1_val, C2_val, R1_val, R2_val, 50e3, freqs))
c = coeffvals;
plot(freqs, A_crrc_mod(c(1), c(2), c(3), c(4), c(5), freqs))

% phis = phis - m * freqs;
% plot(freqs, phis)

set(gca, "XScale", 'log');
