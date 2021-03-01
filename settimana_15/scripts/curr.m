function [I] = curr(V, Is, nVt, R, Nstep)
    if nargin < 5
        Nstep = 20;
    end
    v = V;
    for i = 1:Nstep
        a = deriv_errFun(v, Is, nVt, R);
        v = v - errFun(v, V, Is, nVt, R) ./a;
    end
    I = (V-v)./R;
end

function [df] = deriv_errFun(V, Is, nVt, R)
    df = Is ./ nVt .* pylab.exp(V./nVt) + 1./R;
end

function [dI] = errFun(V, V0, Is, nVt, R)
   dI = sck(V, Is, nVt) + (V - V0)./R;
end

function [I] = sck(V, Is, nVt)
    I = Is.*(exp(V./nVt) - 1);
end


