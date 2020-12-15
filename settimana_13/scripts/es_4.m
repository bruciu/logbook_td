clear all;
dev = I2Cdevice("com3", 0x68);

PWR_MGMT_1 = 0x6B;
PWR_MGMT_1_val = 0b10000000;
dev.write(PWR_MGMT_1, PWR_MGMT_1_val);

SMPRT_DIV = 0x19;
SMPRT_DIV_val = 0x4F;
dev.write(SMPRT_DIV, SMPRT_DIV_val);
%scegliamo di dividere il sample rate di 80 (in scala decimale), così di avere una frequneza di campionamento di 100 Hz

CONFIG = 0x1A;
CONFIG_val = 0b00000000; % no DLPF
dev.write(CONFIG, CONFIG_val);

GYRO_CONFIG = 0x1B;
GYRO_CONFIG_val = 0x00011000;
dev.write(GYRO_CONFIG, GYRO_CONFIG_val);

ACCEL_CONFIG = 0x1C;
ACCEL_CONFIG_val = 0x00001000;
dev.write(ACCEL_CONFIG, ACCEL_CONFIG_val);

ACCEL_XOUT_H = 0x3B;
ACCEL_XOUT_L = 0x3C;
ACCEL_YOUT_H = 0x3D;
ACCEL_YOUT_L = 0x3E;
ACCEL_ZOUT_H = 0x3F;
ACCEL_ZOUT_L = 0x40;

ACCEL_XOUT_H_val = dev.read(ACCEL_XOUT_H, 1)
ACCEL_XOUT_L_val = dev.read(ACCEL_XOUT_L, 1)
