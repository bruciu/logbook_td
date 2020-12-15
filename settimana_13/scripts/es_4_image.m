es_4_2;

N = 1000;

accelerazioni = [];
temperature = [];
pulsazioni = [];
tempo = [];

as = [];
ws = [];
for i = 1:200
    [a, w, T] = leggivalues(dev, 8192/2, 16.4);
    as = [as, a];
    ws = [ws, w];
end

tmp_a = mean(as, 2);
tmp_w = mean(ws, 2);

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






