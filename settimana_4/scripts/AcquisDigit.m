clear all;

f = 1000;

N_onda = 100;
N_samples = 100;

ftrig = N_onda * f;

% funzione da generare (deve essere definita con periododo 1)
%funz = @(x) gauspuls((x-0.5)*2*pi, 10, 0.05) * 1000 + 2050;
funz = @(x) sin(x*2*pi) * 100 + 2050;

PS = 120e6/(f*N_onda);
PS = round(PS);

% crea l'oggetto che rappresenta la scheda
mini = Nucleo;

mini.apri_comunicazione('COM3');

mini.setWaveFun(funz, N_onda);

mini.setNSkip(10);

mini.setNSamples(N_samples);

mini.setPrescaler(PS);

for i = 1:1
[t, y0, y1]= mini.DACADC();

%[t, y0, y1] = mini.getValues();

plot(t, y0, 'r.-'); 

hold on; 

plot(t, y1, 'b.-');
hold off;
ylabel("letture [u.a.]")
xlabel("tempo [s]")
legend("ADC0", "ADC1")
saveas(gcf,'tmp/prova.png');
%print("tmp/prova", '-dpdf');
end
% mini.setDAC(false);
% 
% mini.setADC(false);


%


