load("Sere_es5_1");

session = "Sere1";

%figura accx
image(accelerazioni(1, :), tempo, "Accelerazione x", "m/s^2");
name = 'tmp/Accelerazione_x_'+ session + '.png';
saveas(gcf,name);

%figura accy
image(accelerazioni(2, :), tempo, "Accelerazione y", "m/s^2");
name = 'tmp/Accelerazione_y_'+ session + '.png';
saveas(gcf,name);

%figura accz
image(accelerazioni(3, :), tempo, "Accelerazione z", "m/s^2");
name = 'tmp/Accelerazione_z_'+ session + '.png';
saveas(gcf,name);

%figura wx
image(pulsazioni(1, :), tempo, "Velocità angolare x", "rad/s");
name = 'tmp/wx'+ session + '.png';
saveas(gcf,name);

%figura wy
image(pulsazioni(2, :), tempo, "Velocità angolare y", "rad/s");
name = 'tmp/wy'+ session + '.png';
saveas(gcf,name);

%figura wx
image(pulsazioni(3, :), tempo, "Velocità angolare z", "rad/s");
name = 'tmp/wz'+ session + '.png';
saveas(gcf,name);

%figura temperatura
image(temperature, tempo, "Temperatura", "°C");
name = 'tmp/temp'+ session + '.png';
saveas(gcf,name);


function image(x, t, namey, unit)
    [freqs, As] = myFFT(x, (max(t)-min(t))/length(t));
    freqs = freqs(2:end);
    As = As(2:end);
    subplot(2, 1, 1);
    plot(t, x, 'k.-');
    grid();
    xlabel("Tempo [s]");
    namey1 = namey + " [" + unit + "]";
    ylabel(namey1);
    xlim([min(t), max(t)])

    subplot(2, 1, 2);
    plot(freqs, As.^2);
    set(gca, "XScale", 'log');
    set(gca, "YScale", 'log');

    grid();
    xlabel("frequenza [Hz]");
    namey2 = "PSD " + namey;
    ylabel(namey2);
    xlim([min(freqs), max(freqs)]) 
end
