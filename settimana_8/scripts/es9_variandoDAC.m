% tensioni = 0;
% frequenze = 0;
% dfrequenze = 0;
MA = 100;
Vplus = 0;
Vminus = 0;
dVrange = 0;
R1 = 1.1e3;
R2 = 1e3;
C1 = 10.9e-9;



for k = 1:MA
    %es_9_pervoltaggi;
    close all;
    
    tensioni(k) = (4095/(MA-1))*(k-1);
    %frequenze(k) = f;
    %dfrequenze(k) = df;
    
    Vplus(k) = R1/(R1 + R2)* (4095 - tensioni(k)/2) + tensioni(k) /2;
    Vminus(k) = R1/(R1 + R2)* tensioni(k)/2;
    dVrange(k) =  Vplus(k) - Vminus(k);
    %pause(10);
    
end

periodi = R2.*C1.*(log((4095 - Vminus)./(4095 - Vplus)) + log(Vplus./Vminus));

errorbar(tensioni, frequenze, dfrequenze, 'k.-');
xlabel('$\Delta V $ [digit]', 'Interpreter', 'Latex');
ylabel('Frequenza [Hz]')
grid()
figure;
hold on;
errorbar(tensioni, frequenze, dfrequenze, 'k.-');
plot(tensioni, 1./periodi, 'r.-');
xlabel('$\Delta V $ [digit]', 'Interpreter', 'Latex');
ylabel('Frequenza [Hz]')
legend("f (FFT)", "f aspettato", 'Location', 'northwest')
grid()
hold off;



%save("dV_freq_2.mat", 'tensioni', 'frequenze', 'dfrequenze', 'periodi');
