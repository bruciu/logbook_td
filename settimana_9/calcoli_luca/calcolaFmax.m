function [f, df] = calcolaFmax(yy, dt, multiplier, plot_analsys)

if (nargin < 3)
    multiplier = 16;
end

if (nargin < 4)
    plot_analsys = false;
end

M = multiplier;
y_s = size(yy);
dp = 100;

% rendi yy un vettore riga
if (y_s(1) == 1)
    if (numel(y_s) <= 1)
        throw MException('yy deve essere un vetore o una matrice')
    end
else
    yy = yy';% trasponi
end

% numero di punti
N = numel(yy);

% estendi le yy per eseguire lo zero-padding
yy_ext = [yy, zeros(1, (M-1)*N)];

% trasformata discreta dui punti con lo zero_padding, divisa per N come se
% fosse la trasformata normale, cosi' e' equivalente ad un semplice "infittimento"
% della normale DFT
FT_ext = fft(yy_ext) / (N);

% considera il modulo quadro (solo prima meta')
FT2_ext = abs(FT_ext(1:(N * multiplier / 2))).^2;

% trova il massimo
[~, k_max] = max(FT2_ext);

if (k_max <= 1)
    throw MException('ricerca del massimo fallita')
end

% ora prendi tre punti li' intorno:
x1 = k_max - 1;
y1 = FT2_ext(k_max - 1);
x2 = k_max;
y2 = FT2_ext(k_max);
x3 = k_max + 1;
y3 = FT2_ext(k_max + 1);

if (plot_analsys)
    figure;
    interval = max(1, k_max - dp):min(N*M, k_max + dp);
    plot(interval - 1, FT2_ext(interval), '-+');
    hold on;
    
    interval = max(1, k_max - 1):min(N*M, k_max + 1);
    plot(interval - 1, FT2_ext(interval), 'dr');
end

% trova la parabola passente per questi tre punti:
A = [
    1, x1, x1^2;
    1, x2, x2^2;
    1, x3, x3^2
];
a = A\[y1; y2; y3]; % coefficienti della parabola a1 + a2*x + a3*x^2

DELTA = (N - 1)./(sum(abs(fft(yy)/N).^2) - 2 .* FT2_ext(k_max));

% migliora la stima di k_max
k_max = - a(2)/(2*a(3));

% trova la frequeza associata
f = (k_max - 1)/(dt * N * multiplier);

% trova l'incertezza sulla frequenza (in unita' di indici)
t = sqrt(-1/(DELTA*a(3)));

% calcola l'incertezza in frequenza
df = t/(dt * N * multiplier);

if (plot_analsys)
    xx = x1:0.01:x3;
    p = @(x) a(1) + a(2).*x + a(3).*x.^2;
    plot(xx - 1, p(xx), 'r');
    %plot([k_max, k_max] - 1, [p(k_max) * 0.98, p(k_max) * 1.02], 'r');
    plot(k_max - 1, p(k_max), '.r', 'MarkerSize',20);
    hold off;
end

end




