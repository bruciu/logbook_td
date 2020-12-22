N = 10000;
M = 20;

mean_wy = [];
dev_wy = [];
%prima verso nord poi sud

% for ii = 1:M
%     
%     fprintf("premi Enter per acquisire (durata stimata %f s)\n", N/ 1000);
%     pause
%     
%     pause(2);
%     string = sprintf("%f", ii);
%     acquire('COM4', "tmp/rotazione_terra/data" + string +".txt", N)
%     
% end

for ii = 1:M
    string = sprintf("%f", ii);
    Ain = letturahex("tmp/rotazione_terra/data" + string +".txt",250, 4);
    
    gyroy = Ain(:, 5); 
    mean_wy = [mean_wy, mean(gyroy)];
end
offs = [];

for ii = 1:M
    if mod(ii, 2) == 0
    else
        offs = [offs, mean_wy(ii) - mean_wy(ii+1)];
    end
end
plot(offs);
theta = (180./pi).*acos(mean(offs)./(2.*0.00417)) - 90 %gradi
%dtheta = (180./pi).*sqrt(var(offs).*2./M)./(1 - (mean(offs)./(2.*0.00417)).^2)



