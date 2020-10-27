function [A, dA, phi, dphi] = calcolaAmpiezzaFase(yy, dt, index)
%CALCOLAAMPIEZZAFASE Ampiezza, fase ed incertezza della FFT ad un certo
%indice
%   Detailed explanation goes here

N = numel(yy);

FT_completa = fft(yy) / N;

FT = FT_completa(1:N/2+1);

if (nargin < 3)
    [~, index] = max(abs(FT));
else
    % ok
end

% trova massimo e fase:
A = abs(FT(index));
phi = angle(FT(index));

% funzione degli scarti quadrati
S = @(A_, phi_) sum((yy - A_ * cos(2 * pi * (0:(N-1)) / N * index + phi_)).^2);

DELTA = (N - 2) / S(A, phi);

chi2 = @(A_, phi_) S(A_, phi_) * DELTA;

ddA = sqrt(sqrt(eps)) * A;
ddPhi = 0.001;

c1 = chi2(A - ddA, phi);
c2 = chi2(A, phi);
c3 = chi2(A + ddA, phi);

d2Chi2_dA2 = (2 * c2 - (c1 + c3)) / ddA^2;

dA = sqrt(-2 / d2Chi2_dA2);

c1 = chi2(A, phi - ddPhi);
c2 = chi2(A, phi);
c3 = chi2(A, phi + ddPhi);

d2Chi2_dPhi2 = (2 * c2 - (c1 + c3)) / ddPhi^2;
dphi = sqrt(-2 / d2Chi2_dPhi2);

end

