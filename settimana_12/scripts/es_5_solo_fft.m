

[freqs, As] = myFFT(uu, (max(tempi) - min(tempi))/length(tempi));

plot(freqs, As.^2);
set(gca, "XScale", "log")
set(gca, "YScale", "log")
grid();
xlabel("frequenze [Hz]");
ylabel("ampiezze quadre");
