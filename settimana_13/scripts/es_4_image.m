es_4_2;

N = 1000;

accelerazioni = [];
temperature = [];
pulsazioni = [];
tempo = [];

as = [];
ws = [];
for i = 1:200
    if (mod(i, 20) == 0)
        waitbar(i/200)
    end
    [a, w, T] = leggivalues(dev, 8192*2, 16.4);
    as = [as, a];
    ws = [ws, w];
end

plot3(as(1, :), as(2, :), as(3, :));

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
    [a, w, T] = leggivalues(dev, 8192*2, 16.4);
    accelerazioni(:, ii) = a - tmp_a;
    temperature(:, ii) = T;
    pulsazioni(:, ii) = w - tmp_w;

    pos = pos + vel .* (tempo(ii)-prev_t) + ...
        1./2 .* accelerazioni(:, ii) .* (tempo(ii)-prev_t).^2;
    vel = vel + accelerazioni(:, ii) .* (tempo(ii)-prev_t);
    vel = vel * 0.9;
    pos = pos * 0.99;
    
    vs(:, ii) = vel;
    ps(:, ii) = pos;
    
    if (mod(ii, 1) == 0)
        plot3(ps(1, :), ps(2, :), ps(3, :));
    end
    
    prev_t = tempo(ii);
end

plot3(ps(1, :), ps(2, :), ps(3, :));
correggi_dimensioni




