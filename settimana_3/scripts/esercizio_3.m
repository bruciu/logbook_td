% tempo totale
T = 1; % secondi

% frequenza del segnale
f_s = 2; % Hz

% lunghezza del vettore (numero di punti)
n = 10;
L = 2^n;

% array dei tempi:
%t = linspace(0, T, L) + randn(1, L) * T/(L)*0;
t = (0:(L-1)) * T/L + 0.25 * 0;
% array del segnale:
%y = cos(f_s * 2 * pi * t) + randn(1, L) * 0;
%y = chirp(f_s * 2 * pi * t);
%y = gauspuls(t, f_s, 0.2);
%y = gauspuls(t - 0.5, f_s, 0.01);
%y = gauspuls(t - 0.5, f_s, 1);
y = tripuls(t - 0.5, 1/f_s, 0); 

[freqs, Ampiezze, fase] = myFFT(y, T/L) ;
[A_max, i_max] = max(Ampiezze);

subplot(2, 1, 1);
plot(t, y, '-')
title(sprintf("L = %d  freq. sig. = %.2f, T_{tot} = %.2f", L, f_s, T));
xlabel("tempo [s]");
ylabel("valore [u]");

subplot(2, 1, 2);
f_max = freqs(i_max);
interessanti = [max(0, floor(f_max - 5 / T)), min(L, floor(f_max + 5 / T))];
%interessanti = [0, max(f)];
if (0)
    stem(freqs, Ampiezze, 'dred')
else
    g = area(freqs, Ampiezze);
    g.FaceColor = 'b';
    g.EdgeColor = 'b';
    g.FaceAlpha = 0.5;
end
xlim(interessanti);
xlim([0, max(freqs)]);
set(gca, "YScale", 'log');
%set(gca, "XScale", 'log');

grid();

fprintf("massima ampiezza = %f", max(Ampiezze));

if (0)
    % ZERO PADDING
    M = 8;
    [freqs, Ampiezze, fase] = myFFT([y, zeros(1, numel(y) * (M - 1))], T/L);
    hold on
    stem(freqs, Ampiezze * M, '.b')
    hold off
    
    legend("abs(FFT)", sprintf("abs(FFT) + ZP (M = %d)", M))
    title("spettro");
    xlabel("frequenze [Hz]");
    ylabel("ampiezza [u]");
    
    numel(y)
    [f, df] = calcolaFmax(y, T/L);
    fprintf("%f +- %f\n", f, df)
    
%     figure;
%     ft = fft([cos(f_s * 2 * pi * t), zeros(1, numel(y) * (15 - 1))]) / L;
%     fs = ((1:numel(ft)) - 1) / T;
%     hold off
%     plot(fs(1:100), real(ft(1:100)), 'b-.');
%     hold on
%     plot(fs(1:100), imag(ft(1:100)), 'b--');
%     plot(fs(1:100), abs(ft(1:100)), 'b-');
%     %plot(ft(1:100), 'b--');
%    
%     ft = fft([sin(f_s * 2 * pi * t), zeros(1, numel(y) * (15 - 1))]) / L;
%     fs = ((1:numel(ft)) - 1) / T;
%     plot(fs(1:100), real(ft(1:100)), 'r-.');
%     plot(fs(1:100), imag(ft(1:100)), 'r--');
%     plot(fs(1:100), abs(ft(1:100)), 'r-');
%     %plot(ft(1:100), 'r--');
end

% figure;
% hold on;
% plot(exp(1i * 2 * pi * t));
% y_s = (cos(f_s * 2 * pi * t) + 3).* (exp(1i * 2 * t)) / 3;
% plot(y_s, 'b');
% plot(mean(y_s), 'b.');
% y_s = (cos(f_s * 2 * pi * t) + 3).* (exp(-1i * 2 * t)) / 3;
% plot(y_s, 'b-.');
% plot(mean(y_s), 'b.');
% 
% y_s = (sin(f_s * 2 * pi * t) + 3).* (exp(1i * 2 * t)) / 3;
% plot(y_s, 'r');
% plot(mean(y_s), 'r.');
% y_s = (sin(f_s * 2 * pi * t) + 3).* (exp(-1i * 2 * t)) / 3;
% plot(y_s, 'r-.');
% plot(mean(y_s), 'r.');

saveas(gcf,'tmp/prova.png')







