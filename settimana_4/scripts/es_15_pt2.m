clear all;

PS = 120;
N_onda = 1024;
N_samples = N_onda*1;

f = 120e6/(PS*N_onda);
ftrig = 120e6/PS;
 
A = 1000;
offset = 2048;
ft = 3335;

% funzione da generare (deve essere definita con periododo 1)
% funz = @(x) sawtooth(x*2*pi, 1/2) * A + offset;
funz = @(x) square(x*2*pi) * A + offset;
funz_trasf = @(x)  1./(1 - 1j.*ft./x); 

% crea l'oggetto che rappresenta la scheda
mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.setWaveFun(funz, N_onda);
mini.setNSkip(10);
mini.setNSamples(N_samples);
%fasi0 = zeros(1,N);
mini.setPrescaler(PS);
[t, y0, y1]= mini.DACADC();
hold on;

plot(t, y0, 'r.-'); 
plot(t, y1, 'b.-');
hold off;
ylabel("letture [u.a.]")
xlabel("tempo [s]")
legend("A0", "A1")
grid()
hold off;
figure;

[freqs0, As0, dAs0, phis0, dphis0] = calcolaFFT_errori(y0 - mean(y0), 1, 1 ./ ftrig);
[freqs1, As1, dAs1, phis1, dphis1] = calcolaFFT_errori(y1 - mean(y1), 1, 1 ./ ftrig);
g = area(freqs0(2:end), As0(2:end));
g.FaceColor = 'b';
g.EdgeColor = 'b';
g.FaceAlpha = 0.5;
grid();
xlabel("Frequenza [Hz]");
ylabel("Ampiezze FFT [digit] (A0)");
set(gca, "YScale", "log");
%set(gca, "XScale", "log");

saveas(gcf, "tmp/es_15_pt2_fft0.png")
figure;
g = area(freqs1(2:end), As1(2:end));
g.FaceColor = 'b';
g.EdgeColor = 'b';
g.FaceAlpha = 0.5;
grid();
xlabel("Frequenza [Hz]");
ylabel("Ampiezze FFT [digit] (A1)");
set(gca, "YScale", "log");
%set(gca, "XScale", "log");

saveas(gcf, "tmp/es_15_pt2_fft1.png")
figure;

g = area(freqs0(2:end), As0(2:end));
g.FaceColor = 'b';
g.EdgeColor = 'b';
g.FaceAlpha = 0.5;
grid();
xlabel("Frequenza [Hz]");
ylabel("Ampiezze FFT [digit] (A0)");
set(gca, "YScale", "log");
set(gca, "XScale", "log");
saveas(gcf, "tmp/es_15_pt2_fft0_bilog.png")
figure;
g = area(freqs1(2:end), As1(2:end));
g.FaceColor = 'b';
g.EdgeColor = 'b';
g.FaceAlpha = 0.5;
grid();
xlabel("Frequenza [Hz]");
ylabel("Ampiezze FFT [digit] (A1)");
set(gca, "YScale", "log");
set(gca, "XScale", "log");
saveas(gcf, "tmp/es_15_pt2_fft1_bilog.png")
figure;
close all;
trasfAs0 = abs(funz_trasf(freqs0)) .* As0;
hold on;
%plot(freqs0, As0, 'r-d');
plot(freqs0, As1, 'bd');
plot(freqs0, trasfAs0, 'kd');
set(gca, "YScale", "log");
set(gca, "XScale", "log");
grid();
xlabel("Frequenza [Hz]");
ylabel("Ampiezze FFT [digit]")
legend("FFT A1", "T(w)* FFT(A0)");
hold off;
