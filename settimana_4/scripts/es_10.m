clear all;

f = 1000;

N_onda = 100;
N_samples = 8192;

ftrig = N_onda * f;

funz = @(x) 2050;

PS = 120e6/(f*N_onda);
PS = round(PS);

% crea l'oggetto che rappresenta la scheda
mini = Nucleo;

mini.apri_comunicazione('COM3');

mini.setWaveFun(funz, N_onda);

mini.setNSkip(10);

mini.setNSamples(N_samples);

mini.setPrescaler(PS);

% questi sono vetori dei valori medi e varianze per ogni punto sul
% partitore
% A0_medio;
% A0_var;
% A1_medio;
% A1_var;

for i = 1:5
    pause();
    
   
    
    y0_tmp = 0;
    y1_tmp = 0;
    
    for j = 1:10
        [t, y0, y1]= mini.DACADC();
        y0_tmp = [y0_tmp; y0];
        y1_tmp = [y1_tmp; y1];
        
        plot(t, y0, 'r.-');
        hold on;
        plot(t, y1, 'b.-');
        hold off;
        
        ylabel("letture [u.a.]")
        xlabel("tempo [s]")
        legend("ADC0", "ADC1")
    end
    
    A0_medio(i) = mean(y0_tmp(2:end));
    A0_var(i) = var(y0_tmp(2:end));
    A1_medio(i) = mean(y1_tmp(2:end));
    A1_var(i) = var(y1_tmp(2:end));
end

plot(A0_medio, A0_var);
hold on;
plot(A1_medio, A1_var);
hold off;

figure;
plot(A0_medio, A1_medio);
% hold on
% plot(A1_medio);
% hold off

% mini.setDAC(false);
% 
% mini.setADC(false);