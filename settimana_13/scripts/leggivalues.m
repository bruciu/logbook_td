function [ax, ay, az, omx, omy, omz, T] = leggivalues(ACCEL_CONFIG_val, GYRO_CONFIG_val, dev)
%LEGGIVALUES Summary of this function goes here
%   Detailed explanation goes here

%indirizzi su cui scrivere per avere i dati
GYRO_CONFIG = 0x1B;
ACCEL_CONFIG = 0x1C;

%acquisizione dati
dev.write(GYRO_CONFIG, GYRO_CONFIG_val);
dev.write(ACCEL_CONFIG, ACCEL_CONFIG_val);

%lettura dati
ACCELHL = dev.read(0x3B, 6);
GYROHL = dev.read(0x43, 6);
TEMPHL = dev.read(0x41, 2);

%concatenazione a vettore
ACCEL = 

ax = ACCEL(1:2)
ay = ACCEL(3:4)
az = ACCEL(5:6)
omx = GYRO(1:2)
omy = GYRO(3:4)
omz = GYRO(5:6)
T = TEMP
%concatenazione complemento a 2:

end

