
clear all;

barometro = Barometro("COM3");

barometro.startReading();

tempi = [];
pressioni = [];
temperature = [];

for i = 1:200
    disp(i);
    [p, t] = barometro.readValue();
    tempi = [tempi, now];
    pressioni = [pressioni, p];
    temperature = [temperature, t];    
end
tempi = (tempi - tempi(1))* 24 * 60 * 60;

ft = fft(pressioni);
for i = 1:ceil(length(ft)/2)
    if (i/ceil(length(ft)/2) > 0.05)
        ft(i+1) = 0;
        ft(end-i+1) = 0;
    end
end
y_smooth = abs(ifft(ft));
hold on;
plot(tempi, pressioni, '.k-');
plot(tempi, y_smooth, 'r');
legend("letture", "smooth (5% armoniche)")
xlabel("tempo [s]")
ylabel("pressione [mbar]")
grid()
hold off;

save("es_9_Serena_topdown.mat", "tempi", "pressioni", "temperature");
