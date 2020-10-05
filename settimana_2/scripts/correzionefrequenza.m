clear all;
%[x,y,z] = leg_wavf3pars("../dati_seconda_settimana/cortocirc/acquis5.txt");
[x,y,z] = leg_wavf3pars("../dati_seconda_settimana/passabanda/acquispassa2.txt");
%f_campionamento = 100 kHz: 
m = 0.0000313944;
dm = 0.0000000185;
SR = 10^5
%f_campionamento = 200 kHz: (commenta se vuoi usare l'altro)
%m = 0.0000156965;
%dm = 0.0000000029;
%SR = (2 * 10^5);
zcentr = z - m*x;
zmin = z - (m + dm)*x;
zmax = z - (m - dm)*x;
plot(x, zcentr, '.');
hold on;
plot(x, zmax, '.');
plot(x, zmin, '.');
deltaphi = (pi * x)/SR;
%deltaphi = 2 *pi * x * 5 *10^-6;
zatteso = z - deltaphi;
plot(x, zatteso);
legend('valori centrali','sfasamento massimo', 'sfasamento minimo', 'sfasamento atteso');
set(gca, "XScale", 'log');
hold off;
%figure;
%plot(x, y, '+');


