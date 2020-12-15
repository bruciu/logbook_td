es_4_2;

N = 1000;

accelerazioni = [];
temperature = [];
pulsazioni = [];
tempo = [];

[a, w, T] = leggivalues(dev, 8192/2, 16.4);
tmp_a = a;
tmp_w = w;

vel = [0; 0; 0];
pos = [0; 0; 0];

vs = [];
ps = [];

tic;
prev_t = toc;
for ii = 1:N
    tempo(ii) = toc; %secondi
    [a, w, T] = leggivalues(dev, 8192/2, 16.4);
    accelerazioni(:, ii) = a - tmp_a;
    temperature(:, ii) = T;
    pulsazioni(:, ii) = w - tmp_w;

    pos = pos + vel .* (tempo(ii)-prev_t) + ...
        1./2 .* accelerazioni(:, ii) .* (tempo(ii)-prev_t).^2;
    vel = vel + accelerazioni(:, ii) .* (tempo(ii)-prev_t);
    
    vs(:, ii) = vel;
    ps(:, ii) = pos;
    
    plot3(ps(1, :), ps(2, :), ps(3, :));
    
    prev_t = tempo(ii);
end






