runs = read_folder("data/CIUBRU/bassa_corrente");

mean_i = 60; %uampere

t = []; 
dt = [];

I = []; V = []; T = []; dT = [];

for ii = 1:numel(runs)
    
    run = runs(ii);
    I_tmp = run.I;
    V_tmp = run.V;
    T0_tmp = run.T;
    T_tmp = mean(T0_tmp) + 273.15; %kelvin
    dT_tmp = sqrt(((T0_tmp(2) - T0_tmp(1))./2).^2 + 0.2.^2);
    
    for j = 1:(numel(I_tmp) - 1)
        if ((I_tmp(j) <= mean_i) && (I_tmp(j+1) >= mean_i))
            I = [I; mean_i];
            V = [V; V_tmp(j) + (mean_i - I_tmp(j)) / (I_tmp(j + 1) - I_tmp(j))...
                * (V_tmp(j+1) - V_tmp(j))];
            T = [T; T_tmp];
            
%             plot(V_tmp, I_tmp);
%             xline(V(end));
%             yline(mean_i);
%             pause(1);
        end
    end
    
end










