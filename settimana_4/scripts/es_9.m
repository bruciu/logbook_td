clear all;

N_onda = 100;
N_samples = 600;
N = 100;
PSrange = [120, 120e2];
PSrange = linspace(PSrange(1), PSrange(2), N);
ftrig = 120e6 ./ PSrange; 
f = ftrig ./N_onda;
funz = @(x) sin(x*2*pi) * 2000 + 2050;

% crea l'oggetto che rappresenta la scheda
mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.setWaveFun(funz, N_onda);
mini.setNSkip(10);
mini.setNSamples(N_samples);
fasi = zeros(1,N);
dfasi = zeros(1,N);
ampli = zeros(1,N);
dampli = zeros(1,N);

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
    fasi(ii) = (mod((phis1(jmax)- phis0(jmax))*N_samples, 2*pi))/(2*pi);
    dfasi(ii) = sqrt((dphis1(jmax))^2 + (dphis0(jmax))^2)*N_samples/(2*pi);
    ampli(ii) = (maxA1- maxA0)/maxA0;
    dampli(ii) = sqrt( (dAs0(ii)*(2*maxA0 - maxA1)/maxA0^2)^2 + (dAs1(ii)/maxA0^2)^2 );
end

errorbar(PSrange, fasi, dfasi, 'r+');
grid()
xlabel("Prescaler")
ylabel("\Delta \phi [%]")
saveas(gcf,'tmp/graphphi100.png');
figure;
errorbar(PSrange, ampli, dampli, 'b+');
grid()
xlabel("Prescaler")
ylabel("Differenza relativa fra le ampiezze")
saveas(gcf,'tmp/graphampli100.png');

