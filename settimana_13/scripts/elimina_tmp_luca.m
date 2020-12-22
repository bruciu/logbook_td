
A = letturahex("tmp/" + "test_gyro_elimina.txt", 250/180*pi, 8);

[acc, gyro] = correggi_letture("tmp/test_acq/", A, 250/180*pi, 8);

curr_rot = 0;
rot = [];
dt = 0.001;
for i = 1:numel(gyro(3, :))
    curr_rot = curr_rot + gyro(3, i) * dt;
    rot(i) = curr_rot;
end

plot(rot, '.-')

