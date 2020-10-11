[tt, v_in, v_out] = leg_wavf2g("../data/FFT2/data5.txt", false);

% varianza sulle y (scelta arbitrariamente = alla risoluzione)
dy = 10 / 4095;

% intervallo tra 2 misure
dt = tt(2) - tt(1);

% calcola le due trasformate con gli errori
[freqs_tmp, A_1, dA_1, phi_1, dphi_1] = calcolaFFT_errori(v_in, dy, dt);
[~        , A_2, dA_2, phi_2, dphi_2] = calcolaFFT_errori(v_out, dy, dt);

% calcola il guadagno
A_tmp = A_2 ./ A_1;
dA_tmp = sqrt((dA_2 ./ A_1).^2 + (A_2 .* dA_1 ./ A_1.^2).^2);

% calcola sfasamento
phi_tmp = mod(phi_2 - phi_1 + pi, 2 * pi) - pi;
dphi_tmp = sqrt(dphi_2.^2 + dphi_1.^2);

% seleziona i dati il cui errore relativo sul guadagno e' < 0.5
clear A dA phi dphi freqs
for i = 1:numel(freqs_tmp)
    if (dA_tmp(i) / A_tmp(i) < 0.5)
        freqs(i) = freqs_tmp(i);
        
        A(i) = A_tmp(i);
        dA(i) = dA_tmp(i);
        
        phi(i) = phi_tmp(i);
        dphi(i) = dphi_tmp(i);
    end
end

fig1 = figure;
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

fig2 = figure;
errorbar(freqs, phi, dphi, '+r');
ylim([-2, 2]);
set(gca, "XScale", 'log');
xlabel("frequenza [Hz]");
ylabel("differenza di fase [Rad]");
grid();

%errorba