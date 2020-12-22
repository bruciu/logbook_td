clear all;
dev = I2Cdevice("com3", 0x68);

%impostazioni iniziali:
PWR_MGMT_1 = 0x6B;
PWR_MGMT_1_val = 0b00000000;
dev.write(PWR_MGMT_1, PWR_MGMT_1_val);

SMPRT_DIV = 0x19;
SMPRT_DIV_val = 0x4F;
dev.write(SMPRT_DIV, SMPRT_DIV_val);
%   scegliamo di dividere il sample rate di
%   80 (in scala decimale), così di avere una frequneza di campionamento di 100 Hz

%indirizzi su cui scrivere per avere i dati
GYRO_CONFIG = 0x1B;
ACCEL_CONFIG = 0x1C;

%acquisizione dati
dev.write(GYRO_CONFIG, 0b00011000);
dev.write(ACCEL_CONFIG, 0b00000000);

CONFIG = 0x1A;
CONFIG_val = 0b00000000; % no DLPF
dev.write(CONFIG, CONFIG_val);

N = 10000;

tic;
prev_t = toc;
wb = waitbar(0, "atendi...");
for ii = 1:N
    if (mod(ii, 20) == 0)
        waitbar(ii/N, wb);
    end
    tempo(ii) = toc; %secondi
    [a, w, T] = leggivalues(dev, 8192*2, 16.4);
    accelerazioni(:, ii) = a;
    temperature(:, ii) = T;
    pulsazioni(:, ii) = w;
end
close(wb);

[freqs, As] = myFFT(accelerazioni(1, :), (max(tempo)-min(tempo))/length(tempo));

freqs = freqs(2:end);
As = As(2:end);

plot(freqs, As.^2);
set(gca, "XScale", 'log');
set(gca, "YScale", 'log');

grid();
xlabel("frequenza [Hz]");
ylabel("PSD accelerazione x");
xlim([min(freqs), max(freqs)])

%save("Sere_es5_2", "tempo", "accelerazioni", "pulsazioni", "temperature");