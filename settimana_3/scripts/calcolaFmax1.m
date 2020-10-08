function [f, df] = calcolaFmax1(yy, dt, multiplier)
%CALCOLAFMAX Summary of this function goes here
%   Detailed explanation goes here
N = numel(yy);
yy = [yy zeros(1, (multiplier-1)*numel(yy))];
FT = fft(yy) / N;
FT2 = abs(FT(1:(N * multiplier / 2))).^2;
plot(FT2(1:100 * multiplier), '-d')
[ymax, kmax] = max(FT2);
x1 = kmax -1;
y1 = FT2(kmax - 1);
x2 = kmax + 1;
y2 = FT2(kmax + 1);
A = [1, x1, x1^2;
    1, x2, x2^2;
    1, kmax, kmax^2];
a = A\[y1; y2; ymax];

hold on
plot([x1, x2, kmax], [y1, y2, ymax], 'd')

tmp = (x1-5):0.001:(x2 + 5);
plot(tmp, a(1) + a(2)*tmp + a(3) * tmp.^2)
plot([- a(2)/(2*a(3)), - a(2)/(2*a(3))], [0, 1])

DELTA = (N - 1)./(sum(yy.^2) - 2*FT2(kmax));
kmax/(dt * N * multiplier)
kmax = - a(2)/(2*a(3));
f = kmax/(dt * N * multiplier);
%t = sqrt(-1/(DELTA*a(3)));
t = sqrt(-1/(2 * DELTA*a(3)));
df = t/(dt * N * multiplier);

end



