clear all;
dev = I2Cdevice("com3", 0x68);

%impostazioni iniziali:
PWR_MGMT_1 = 0x6B;
PWR_MGMT_1_val = 0b00000000;
dev.write(PWR_MGMT_1, PWR_MGMT_1_val);

SMPRT_DIV = 0x19;
SMPRT_DIV_val = 0x4F;
dev.write(SMPRT_DIV, SMPRT_DIV_val);
%   scegliamo di dividere il sample rate di
%   80 (in scala decimale), così di avere una frequneza di campionamento di 100 Hz

[ax, ay, az, omx, omy, omz, T] = leggivalues(0b00010000 ,0b00011000, dev, 8192/2, 16.4)