% tempo totale
T = sqrt(2)*1e5 + gamma(10); % secondi

% frequenza del segnale
f_s = 5000; % Hz

% lunghezza del vettore (numero di punti)
n = 10;
L = 2^n;

T = T*L;

% array dei tempi:
%t = linspace(0, T, L) + randn(1, L) * T/(L)*0;
t = (0:(L-1)) * T/L + 0.25 * 0;

%t_ritardo
tr = 2e-5;
display(f_s * 2 * pi*tr)

% array del segnale:
y = cos(f_s * 2 * pi * t);
yr = cos(f_s * 2 * pi * (t - tr));

[freqs, Ampiezze, fase] = myFFT(y, T/L) ;
[A_max, i_max] = max(Ampiezze);
[freqs_r, Ampiezze_r, fase_r] = myFFT(yr, T/L);
[A_maxr, i_maxr] = max(Ampiezze_r);

subplot(2, 1, 1);
stem(freqs, fase, 'dred')
% plot(t, y, '-')
title(sprintf("Fasi", L, f_s, T));
xlabel("Frequenza [Hz]");
ylabel("FFT [u]");
xlim([0, max(freqs)]);

subplot(2, 1, 2);
f_max = freqs(i_max);
ylabel("FFT [u]");
%interessanti = [max(0, floor(f_max - 5 / T)), min(L, floor(f_max + 5 / T))];
%interessanti = [0, max(f)];
stem(freqs_r, fase - fase_r, 'dblue')
if (0)
    g = area(freqs, Ampiezze);
    g.FaceColor = 'b';
    g.EdgeColor = 'b';
    g.FaceAlpha = 0.5;
end
%xlim(interessanti);
xlim([0, max(freqs)]);
%set(gca, "YScale", 'log');
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

display(fase(i_max) - fase_r(i_max))
display((fase(i_max) - fase_r(i_max))/(f_s * 2 * pi))

saveas(gcf,'tmp/prova.png')







