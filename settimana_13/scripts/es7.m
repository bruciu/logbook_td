
N = 20000;

acquisizione_calibrazione('COM3', "tmp/es7/", 1000, 10000)
A = letturahex("tmp/es7/calib_acc_data.txt", 250*pi/180, 8);

noisevarmedio = sqrt(var(A(:,6)));

fprintf("premi Enter per acquisire (durata stimata %f s)\n", N/ 1000);
pause

acquire('COM3', "tmp/es7/data.txt", N)
Ain = letturahex("tmp/es7/data.txt", 250*pi/180, 8);
[acc, gyro] = correggi_letture("tmp/es7/", Ain, 250*pi/180, 8);

curr_rot = 0;
rot = [];
dt = 0.001;
tempo = ((1:numel(acc(1,:))) - 1).*dt;
for i = 1:numel(gyro(3, :))
    curr_rot = curr_rot + gyro(3, i) * dt;
    rot(i) = curr_rot; 
end

plot(rot, '.-')



