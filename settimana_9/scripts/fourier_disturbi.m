function [G, xx, yy_smooth, dG] = fourier_disturbi(yy, dt, bool_grafico,  amplificazione)
%FOURIER_DISTURBI Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 3)
    bool_grafico = false;
end

if (nargin < 4)
    amplificazione = 5;
end



[mainFreq, dmainFreq] = calcolaFmax(yy - mean(yy), dt);
N_onde = floor(numel(yy) * dt * mainFreq);
N_punti = floor(min((N_onde / mainFreq) / dt, numel(yy)));
yy = yy(1:N_punti);
yy = yy - mean(yy);
[freqs, A, phi] = myFFT(yy, dt);
[~, max_index] = max(A);
mainFreq = freqs(max_index);
signal_fft = fft(yy);
for i = 1:ceil(numel(signal_fft)/2)
    if (mod(i-1, max_index-1) ~= 0)
        signal_fft(i) = 0;
        signal_fft(numel(signal_fft) - i + 2) = 0;
    end
end

Gv = sum(abs(signal_fft).^2) - 2*abs(signal_fft(max_index).^2);
G = sqrt(Gv / (2*abs(signal_fft(max_index)).^2));

% -----
yy_smooth = real(ifft(signal_fft));

tmp = 1:numel(signal_fft);
indici_pringipali = (tmp == max_index) | (tmp == (numel(signal_fft) - max_index + 2));
signal_fft_princ = signal_fft .* indici_pringipali;
sinusoide = ifft(signal_fft_princ);
dy = yy_smooth * 0 + 1;
Ga = sum((yy_smooth - sinusoide).^2) - sum(dy.^2)/N_onde;
Ga = Ga / sum(sum(sinusoide.^2));
dG = sqrt(Ga);
% -----



yy_smooth = ifft(signal_fft);

signal_fft(max_index) = signal_fft(max_index) ./ amplificazione;
signal_fft(numel(signal_fft) - max_index + 2) = ...
    signal_fft(numel(signal_fft) - max_index + 2) ./ amplificazione;
signal_fft = signal_fft .* amplificazione;

xx = (1:numel(yy_smooth)).*dt; 

if bool_grafico
    figure;
    hold on;
    title("Visualizzazione distorsioni x" + num2str(amplificazione))
    plot(xx, yy, '.k-')
    plot(xx, yy_smooth, 'b-')
    plot(xx, ifft(signal_fft), 'r-')
    grid()
    xlim([0, 1 / mainFreq * 3]);
    xlabel("Tempo [s]");
    ylabel("Valore [arb.un.]");
    legend("segnale originale", "mediato", "mediato & armoniche x" + ...
        num2str(amplificazione), "Location","SouthEast")
    hold off
end

end

