%R = 1e3;
R1 = 10e3;
R =  R1/ 2;
dR1 = R1/100;
dR = dR1/(2*sqrt(2));%Dopo riveditelo
%C = 10e-9;
C = 68e-9;
%dR = R/100;
dC = C * 5/100;
a = R*C;
da = sqrt( (R * dC)^2 + (dR * C)^2 );
ft = 1./(2*pi*a);
dft = ft*da/a;
%fprintf("%f +- %f", ft, dft);
fprintf("%.10f +- %.10f", a*10^6, da*10^6);