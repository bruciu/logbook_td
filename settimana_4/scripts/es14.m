clear all;

N_onda = 100;
N_samples = 600;
N = 10;
PSrange = [120, 120e2];
PSrange = linspace(PSrange(1), PSrange(2), N);
ftrig = 120e6 ./ PSrange; 
f = ftrig ./N_onda;
funz = @(x) sin(x*2*pi) * 1500 + 2050;

% crea l'oggetto che rappresenta la scheda
mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.setWaveFun(funz, N_onda);
mini.setNSkip(10);
mini.setNSamples(N_samples);
fasi0 = zeros(1,N);
dfasi0 = zeros(1,N);
ampli0 = zeros(1,N);
dampli0 = zeros(1,N);
fasi1 = zeros(1,N);
dfasi1 = zeros(1,N);
ampli1 = zeros(1,N);
dampli1 = zeros(1,N);

for ii = 1:N
    mini.setPrescaler(PSrange(ii));
    [t, y0, y1]= mini.DACADC();
    plot(t, y0, 'r.-'); 
    hold on; 
    plot(t, y1, 'b.-');
    hold off;
    ylabel("letture [u.a.]")
    xlabel("tempo [s]")
    legend("ADC0", "ADC1")
    %saveas(gcf,'tmp/prova.png');
    [freqs0, As0, dAs0, phis0, dphis0] = calcolaFFT_errori(y0 - mean(y0), 1, 1 ./ ftrig(ii));
    [freqs1, As1, dAs1, phis1, dphis1] = calcolaFFT_errori(y1 - mean(y1), 1, 1 ./ ftrig(ii));
    [maxA0, jmax] = max(As0);
    [maxA1, ~] = max(As1);
    fasi0(ii) = phis0(jmax);
    dfasi0(ii) = dphis0(jmax);
    ampli0(ii) = maxA0;
    dampli0(ii) = dAs0(jmax);
    fasi1(ii) = phis1(jmax);
    dfasi1(ii) = dphis1(jmax);
    ampli1(ii) = maxA1;
    dampli1(ii) = dAs1(jmax);
end

errorbar(f, fasi0, dfasi0, 'r+');
grid()
xlabel("Frequenza")
ylabel("\Delta \phi [%]")
saveas(gcf,'tmp/graph.png');
figure;
errorbar(PSrange, ampli0, dampli0, 'b+');
grid()
xlabel("Prescaler")
ylabel("---")

