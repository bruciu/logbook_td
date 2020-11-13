tempi = 0;
frequenze = 0;
dfrequenze = 0;

for k = 1:100
    es_9;
    close all;
    
    tempi(k) = tempo_acquis;
    frequenze(k) = f;
    dfrequenze(k) = df;
    
    %pause(10);
    
end

save("tempi_freq_2.mat", 'tempi', 'frequenze', 'dfrequenze');
