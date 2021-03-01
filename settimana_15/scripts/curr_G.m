function [I] = curr_G(V, Is, nVt, R, G, Nstep)

if nargin < 6
    Nstep = 20;
end

% diodo + resistenza in serie
I = curr(V, Is, nVt, R, Nstep);

% resistenza in parallelo
I = I + G .* R;
end

