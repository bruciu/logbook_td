[tt, yy] = leg_wavf("../data_sinusoidale/acquisizione1.txt");

plot_N = 1000;

plot(tt(1:plot_N), yy(1:plot_N), '+')

[f, df] = calcolaFmax(yy, tt(2) - tt(1));
fprintf("%f +- %f\n", f, df)

