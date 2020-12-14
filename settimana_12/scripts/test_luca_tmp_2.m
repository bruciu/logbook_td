
KK = 20;
clear Ass
for k = 1:KK
    k
    es5;
    es_5_solo_fft;
    close all;
    
    Ass(k, :) = As;
end

figure;
hold on;
for i = 1:KK
    plot(freqs, Ass(i, :).^2);
end
set(gca, "XScale", "log")
set(gca, "YScale", "log")
fplot(@(x) (0.01./(0.06 + x) + 1e-3).^2, [1e-3, 100]);
hold off;

tmp = Ass(1, :) * 0;
for i = 1:KK
    tmp = tmp + Ass(i, :);
end 

