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
    
    d = abs(I_tmp - mean_i);
    [d_min, j_min] = min(d);
    if (d_min - mean_i)<0
        if (j_min ~= 1)&&(j_min ~= numel(I_tmp))
            I_tmpa = [I_tmp(j_min), I_tmp(j_min + 1)];
            V_tmpa = [V_tmp(j_min), V_tmp(j_min + 1)];
            flag = 2;
        else
            I_tmpa = I_tmp(j_min);
            V_tmpa = V_tmp(j_min);
            flag = 1;
        end
    else
        if (j_min ~= 1)&&(j_min ~= numel(I_tmp))
            I_tmpa = [I_tmp(j_min-1), I_tmp(j_min)];
            V_tmpa = [V_tmp(j_min-1), V_tmp(j_min)];
            flag = 2;
        else
            I_tmpa = I_tmp(j_min);
            V_tmpa = V_tmp(j_min);
            flag = 1;
        end
    end
    
    %f = @(A, B, x) A + x.*B;
    If = @(A, B, x) - A./B + x./B;
    
    if flag == 2
        B = (I_tmpa(2) - I_tmpa(1))/(V_tmpa(2) - V_tmpa(1));
        A = I_tmpa(2) - V_tmpa(2).*B;
        valuey = mean_i;
        valuex = If(A, B, mean_i);
    else
        valuey = mean_i;
        valuex = V_tmpa;
    end
    I = [I; valuey];
    V = [V; valuex];
    T = [T; T_tmp];
    dT = [dT; dT_tmp];
end









