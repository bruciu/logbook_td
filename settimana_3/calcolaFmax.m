function [f, df] = calcolaFmax(yy, dt, multiplier)
%CALCOLAFMAX Summary of this function goes here
%   Detailed explanation goes here
N = numel(yy);
yy = [yy zeros(1, (multiplier-1)*numel(yy))];
FT = fft(yy) / N;
FT2 = abs(FT).^2;
plot(FT2)
[ymax, kmax] = max(FT2);
x1 = kmax -1;
y1 = FT2(kmax - 1);
x2 = kmax + 1;
y2 = FT2(kmax + 1);
A = [1, x1, x1^2;
    1, x2, x2^2;
    1, kmax, kmax^2];
a = A\[y1; y2; ymax];
DELTA = (N - 1)./(sum(yy.^2) - FT2(kmax));
kmax/(dt * N * multiplier)
kmax = - a(2)/(2*a(3));
f = kmax/(dt * N * multiplier);
%t = sqrt(-1/(DELTA*a(3)));
t = sqrt(-1/(2 * DELTA*a(3)));
df = t/(dt * N * multiplier);

end

