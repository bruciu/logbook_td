load('es_11_Serena_hterra.mat')
p1 = pressioni;
tempe1 = temperature;
tempi1 = tempi;
load('es_11_Serena_h45.mat')
p2 = pressioni;
tempe2 = temperature;
tempi2 = tempi;
load('es_11_Serena_h88.mat')
p3 = pressioni;
tempe3 = temperature;
tempi3 = tempi;
load('es_11_Serena_h167.mat')
p4 = pressioni;
tempe4 = temperature;
tempi4 = tempi;

hold on;
grid();
xlabel("Tempi [s]");
ylabel("Pressioni [mbar]");
ft1 = fft(p1);
for i = 1:ceil(length(ft1)/2)
    if (i/ceil(length(ft1)/2) > 0.01)
        ft1(i+1) = 0;
        ft1(end-i+1) = 0;
    end
end
y_smooth1 = abs(ifft(ft1));

plot(tempi1, p1, '.g');




ft2 = fft(p2);
for i = 1:ceil(length(ft2)/2)
    if (i/ceil(length(ft2)/2) > 0.01)
        ft2(i+1) = 0;
        ft2(end-i+1) = 0;
    end
end
y_smooth2 = abs(ifft(ft2));

plot(tempi2, p2, '.y');




ft3 = fft(p3);
for i = 1:ceil(length(ft3)/2)
    if (i/ceil(length(ft3)/2) > 0.01)
        ft3(i+1) = 0;
        ft3(end-i+1) = 0;
    end
end
y_smooth3 = abs(ifft(ft3));

plot(tempi3, p3, '.b');


ft4 = fft(p4);
for i = 1:ceil(length(ft4)/2)
    if (i/ceil(length(ft4)/2) > 0.01)
        ft4(i+1) = 0;
        ft4(end-i+1) = 0;
    end
end
y_smooth4 = abs(ifft(ft4));

plot(tempi4, p4, '.r');


maxi = max([tempi1, tempi2, tempi3,tempi4]);

xlim([0, maxi]);

legend("level 0", "level 45 cm", "level 88 cm", "level 1.675 m")
hold off;
figure;
hold on;
plot(tempi1, y_smooth1, 'g');
plot(tempi2, y_smooth2, 'k');
plot(tempi3, y_smooth3, 'b');
plot(tempi4, y_smooth4, 'r');
legend("level 0", "level 45 cm", "level 88 cm", "level 1.675 m")
max1 = max(tempi1);
max2 = max(tempi2);
max3 = max(tempi3);
max4 = max(tempi4);
maxi = min([max1, max2, max3, max4]);
xlim([0, maxi]);
grid();
xlabel("Tempi [s]");
ylabel("Pressioni [mbar]");
title("smooth (1% armoniche)")
hold off;
figure;
hold on;
%errorbar([0, 45, 88, 167.5],[mean(p1), mean(p2), mean(p3), mean(p4)], [sqrt(var(p1)/numel(p1)),sqrt(var(p2)/numel(p2)), sqrt(var(p3)/numel(p3)), sqrt(var(p4)/numel(p4))], 'kd-')
h = [0, 45, 88, 167.5];
meanp = [mean(p1), mean(p2), mean(p3), mean(p4)];
dmeanp = [sqrt(var(p1)/numel(p1)),sqrt(var(p2)/numel(p2)), sqrt(var(p3)/numel(p3)), sqrt(var(p4)/numel(p4))];
errorbar(h, meanp, dmeanp/2,dmeanp/2, h.*0 + 1, h.*0 + 1, 'kd-');

hold off;