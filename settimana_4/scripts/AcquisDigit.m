clear all;

f = 1000;

N_onda = 100;
N_samples = 600;

funz = @(x) sawtooth(x*2*pi) * 1000 + 2050;

ftrig = N_onda * f;

PS = 120e6/(f*N_onda);

PS = round(PS);

mini = Nucleo;

mini.apri_comunicazione('COM3');

mini.setWaveFun(funz, N_onda);

mini.setNSkip(10);

mini.setNSamples(N_samples);

mini.setPrescaler(PS);

[t, y0, y1]= mini.DACADC();

%[t, y0, y1] = mini.getValues();

plot(t, y0, 'r.-'); 

hold on; 

plot(t, y1, 'b.-');

% mini.setDAC(false);
% 
% mini.setADC(false);


%


