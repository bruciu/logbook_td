function [I] = curr(V, Is, nVt, R, Nstep)
    
    R = R * 1e-6;

    if nargin < 5
        Nstep = 20;
    end
    
    % check per resistenza nulla
    if (abs(R) <= sqrt(eps))
        I = sck(V, Is, nVt);
        return;
    end
    
    v = V;
    for i = 1:Nstep
        a = deriv_errFun(v, Is, nVt, R);
        v = v - errFun(v, V, Is, nVt, R) ./a;
    end
    I = (V-v)./R;
end

% funzione di errore secondo il metodo della "retta di carico"
function [dI] = errFun(V, V0, Is, nVt, R)
   dI = sck(V, Is, nVt) + (V - V0)./R;
end

% derivata di errFun, necessaria per il metodo di Newton
function [df] = deriv_errFun(V, Is, nVt, R)
    df = Is ./ nVt .* exp(V./nVt) + 1./R;
end

% legge di Shockley approssimata
function [I] = sck(V, Is, nVt)
    I = Is.*(exp(V./nVt) - 1);
end


