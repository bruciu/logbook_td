clear all;

N_onda = 100;
N_samples = 1000 / 10;%8192;

PS = 1200;

% crea l'oggetto che rappresenta la scheda
mini = Nucleo;

mini.apri_comunicazione('COM3');

mini.setNSkip(2);
mini.setNSamples(N_samples);
mini.setPrescaler(PS);

% questi sono vetori dei valori medi e varianze per ogni punto sul
% partitore
% A0_medio;
% A0_var;
% A1_medio;
% A1_var;
N = 4096 / 4 / 8;
wb = waitbar(0);
for i = 1:N
    
    waitbar(i/N);
    disp(i);
    
    funz = @(x) 4095*(i-1)/(N-1) / 32;
    mini.setWaveFun(funz, N_onda);
    
    y0_tmp = 0;
    y1_tmp = 0;
    
    for j = 1:1
        [t, y0, y1]= mini.DACADC();
        y0_tmp = [y0_tmp; y0];
        y1_tmp = [y1_tmp; y1];
        
        %plot(t, y0, 'r.-');
%         plot(t, y1, 'b.-');        
%         ylabel("letture [u.a.]")
%         xlabel("tempo [s]")
%         hold off;
    end
    
    A0_medio(i) = mean(y0_tmp(2:end));
    A0_var(i) = var(y0_tmp(2:end));
    A1_medio(i) = mean(y1_tmp(2:end));
    A1_var(i) = var(y1_tmp(2:end));
end
close(wb);
DAC_values = (0:N-1)*4095 / (N-1);

subplot(3, 1, [1, 2]);
hold on;
plot(DAC_values, A0_medio, '.r');
plot(DAC_values, A1_medio, '.b');
grid();
ylabel("lettura media ADC [digit]");
legend("A0", "A1");
hold off;
subplot(3, 1, 3);
hold on;
plot(DAC_values, A0_medio - DAC_values, '.r');
plot(DAC_values, A1_medio - DAC_values, '.b');
grid();
xlabel("valore DAC [digit]");
ylabel("media ADC - DAC [digit]");
hold off;
saveas(gcf,'tmp/prova_retta.png');

figure;
hold on;

plot(A0_medio, A0_var, 'dr');

plot(A1_medio, A1_var, 'db');

hold off;

grid()

xlabel("lettura media [u.a.]")

ylabel("lettura media [u.a.]")

ylabel("varianza [u.a.^2]")

legend("var ADC0", "var ADC0")
ylim([0, 5])
saveas(gcf,'tmp/prova_var.png');
% hold on
% plot(A1_medio);
% hold off

% mini.setDAC(false);
% 
% mini.setADC(false);