tempi = 0;
frequenze = 0;
dfrequenze = 0;

for k = 1:10
    es_9;
    close all;
    
    tempi(k) = tempo_acquis;
    frequenze(k) = f;
    dfrequenze(k) = df;
    
    %pause(10);
    
end

save("tempi_freq.mat", 'tempi', 'frequenze', 'dfrequenze');

errorbar((tempi - tempi(1))* 24 * 60 * 60, frequenze, dfrequenze, '+k-')
grid()
xlabel("tempo di acquisizione [s]")
ylabel("frequenze principali [Hz]")
legend("dati")

