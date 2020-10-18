clear all;

f = 1000;

N_onda = 100;

funz = @(x) sin(x*2*pi) * 4000 + 2050;
mini.setWaveFun(funz, N_onda);

ftrig = N_onda * f;

PS = 120e6/(f*N_onda);

PS = round(PS);

mini = Nucleo;

mini.apri_comunicazione('COM3');

mini.setNSkip(10);

mini.setNSamples(N_onda);

mini.setPrescaler(PS);

mini.setDAC(true);

mini.setADC(true);

pause(1);

[t, y0, y1] = mini.getValues();

plot(y0, 'r.-'); 

hold on; 

plot(y1, 'b.-');

mini.setDAC(false);

mini.setADC(false);


%


