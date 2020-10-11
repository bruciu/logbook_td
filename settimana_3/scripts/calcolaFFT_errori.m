function [freqs, As, dAs, phis, dphis] = calcolaFFT_errori(yy, dyy, dt, M, plot_analsys)
%CALCOLAFFT_ERRORI Summary of this function goes here
%   Detailed explanation goes here

if (nargin < 1)
    yy = cos(5 * 2 * pi * (0:999) * 0.001);
end

if (nargin < 2)
    dyy = 0.1;
end

if (nargin < 3)
    dt = 1;
end

if (nargin < 4)
    M = 1000;
end

if (nargin < 5)
    plot_analsys = false;
end

%
N = numel(yy);
y_s = size(yy);

% rendi yy un vettore riga
if (y_s(1) == 1)
    if (numel(y_s) <= 1)
        throw MException('yy deve essere un vetore o una matrice')
    end
else
    yy = yy';% trasponi
end

if (numel(dyy) == 1)
    dyy = ones(1, N) * dyy;
end

L = N/2+1;

Ampiezze = zeros([M, L]); % il primo indice è l'indice della trasformata, il secondo della frequenza
Fasi = zeros([M, L]); % stesa cosa

% ora cicliamo M volte, ogni volta facendo la trasformata del segnale con
% del rumore aggiunto
if (plot_analsys)
    fig = figure;
end

wb = waitbar(0, "calcolo...");
for j = 1:M
    waitbar(j / M, wb);
    yy_tmp = yy + randn(1, N) .* dyy;
    
    % calcolo trasformata:
    [~, A, phi] = myFFT(yy_tmp, dt);
    
    Ampiezze(j, :) = A;
    Fasi(j, :) = phi;
    
    if (plot_analsys)
        %clf(fig);
        
        plot((0:N-1) * dt, yy_tmp);
        
        %pause(0.5);
    end
end
close(wb);

if (plot_analsys)
    close(fig);
end

[freqs, As_orig, phis_orig] = myFFT(yy, dt);

dAs = zeros(1, L);
dphis = zeros(1, L);

for j = 1:L
    As(j) = mean(Ampiezze(:, j));
    dAs(j) = sqrt(var(Ampiezze(:, j)));
    
    phis(j) = mean(Fasi(:, j));
    dphis(j) = sqrt(var(Fasi(:, j)));
end

% mostra contronto tra i due valori
if (plot_analsys)
    fig = figure;
    hold on;
    
    plot(freqs, As_orig, 'b');
    errorbar(freqs, As, dAs, '+r');
    
    pause(2);
    close(fig);
    
    fig2 = figure;
    hold on
    plot(freqs, phis_orig, 'b');
    %errorbar(freqs, phis, dphis, '+r-');
    plot(freqs, phis, '+r-');
    ylim([-1, 2]);
    
    hold off
    pause(2);
    close(fig2);
end

As = As_orig;
phis = phis_orig;

end
