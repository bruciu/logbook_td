runs = read_folder("data/CIUBRU/bassa_corrente");

semi_s = 0.015; %uampere
mean_i = 0.4; %uampere

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
    
    for jj = 1:numel(I_tmp)
        if abs(I_tmp(jj) - mean_i) <= semi_s
            I = [I; I_tmp(jj)];
            V = [V; V_tmp(jj)];
            T = [T; T_tmp];
            dT = [dT; dT_tmp];
        end
    end
    
    
end










