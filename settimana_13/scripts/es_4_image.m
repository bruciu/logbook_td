es_4_2;

N = 10;

accelerazioni = [];
temperature = [];
pulsazioni = [];
tempo = [];

tic;
for ii = 1:N
    tempo = toc; %secondi
    [a, w, T] = leggivalues(dev, 8192/2, 16.4);
    accelerazioni(:, ii) = a;
    temperature(:, ii) = T;
    pulsazioni(:, ii) = w;

end


