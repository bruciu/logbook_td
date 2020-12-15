clear all;
dev = I2Cdevice("com3", 0x68);

PWR_MGMT_1 = 0x6B;
PWR_MGMT_1_val = 0b10000000;

dev.write(PWR_MGMT_1, PWR_MGMT_1_val);

for i = 1:10
    plot_pos_rot(rand(1, 3), axang2rotm(rand(1, 4)' * 10), 0.1);
end
correggi_dimensioni;