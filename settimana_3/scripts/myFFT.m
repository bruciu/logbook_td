function [freqs, Ampiezze, fase] = myFFT(yy, dt)
%MYFFT Summary of this function goes here
%   Detailed explanation goes here

    L = numel(yy);
    
    P3 = fft(yy);
    P2 = abs(P3)/L;
    X = P2(1:L/2+1);
    X(2:end-1)=2*X(2:end-1);
    f = 1/dt*(0:(L/2))/L;
    fase=angle(P3(1:L/2+1));
    freqs = f;
    Ampiezze = X;
end

