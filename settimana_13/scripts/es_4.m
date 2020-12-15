clear all;
dev = I2Cdevice("com3", 0x68);

PWR_MGMT_1 = 0x6B;
PWR_MGMT_1_val = 0b00000000;
dev.write(PWR_MGMT_1, PWR_MGMT_1_val);

SMPRT_DIV = 0x19;
SMPRT_DIV_val = 0x4F;
dev.write(SMPRT_DIV, SMPRT_DIV_val);
%scegliamo di dividere il sample rate di 80 (in scala decimale), così di avere una frequneza di campionamento di 100 Hz

CONFIG = 0x1A;
CONFIG_val = 0b00000000; % no DLPF
dev.write(CONFIG, CONFIG_val);

GYRO_CONFIG = 0x1B;
GYRO_CONFIG_val = 0b00011000;
dev.write(GYRO_CONFIG, GYRO_CONFIG_val);

ACCEL_CONFIG = 0x1C;
ACCEL_CONFIG_val = 0b00010000;
dev.write(ACCEL_CONFIG, ACCEL_CONFIG_val);

ACCEL_XOUT_H = 0x3B;
ACCEL_XOUT_L = 0x3C;
ACCEL_YOUT_H = 0x3D;
ACCEL_YOUT_L = 0x3E;
ACCEL_ZOUT_H = 0x3F;
ACCEL_ZOUT_L = 0x40;

ACCEL_XOUT_H_val = double(dev.read(ACCEL_XOUT_H, 1));
ACCEL_XOUT_L_val = double(dev.read(ACCEL_XOUT_L, 1));
ACCEL_YOUT_H_val = double(dev.read(ACCEL_YOUT_H, 1));
ACCEL_YOUT_L_val = double(dev.read(ACCEL_YOUT_L, 1));
ACCEL_ZOUT_H_val = double(dev.read(ACCEL_ZOUT_H, 1));
ACCEL_ZOUT_L_val = double(dev.read(ACCEL_ZOUT_L, 1));

aXOUT = ACCEL_XOUT_H_val .* 256 + ACCEL_XOUT_L_val;
aYOUT = ACCEL_YOUT_H_val .* 256 + ACCEL_YOUT_L_val;
aZOUT = ACCEL_ZOUT_H_val .* 256 + ACCEL_ZOUT_L_val;

aXOUT = comp2(aXOUT);
aYOUT = comp2(aYOUT);
aZOUT = comp2(aZOUT);

%conversioni
acc = [aXOUT; aYOUT; aZOUT] / (8192/2)
acc_uni = acc .* 9.8 ;



%GIROSCOPIO
GYRO_XOUT_H = 0x43;
GYRO_XOUT_L = 0x44;
GYRO_YOUT_H = 0x45;
GYRO_YOUT_L = 0x46;
GYRO_ZOUT_H = 0x47;
GYRO_ZOUT_L = 0x48;

GYRO_XOUT_H_val = double(dev.read(GYRO_XOUT_H, 1));
GYRO_XOUT_L_val = double(dev.read(GYRO_XOUT_L, 1));
GYRO_YOUT_H_val = double(dev.read(GYRO_YOUT_H, 1));
GYRO_YOUT_L_val = double(dev.read(GYRO_YOUT_L, 1));
GYRO_ZOUT_H_val = double(dev.read(GYRO_ZOUT_H, 1));
GYRO_ZOUT_L_val = double(dev.read(GYRO_ZOUT_L, 1));

dev.read(GYRO_XOUT_H, 4)

gXOUT = GYRO_XOUT_H_val .* 256 + GYRO_XOUT_L_val;
gYOUT = GYRO_YOUT_H_val .* 256 + GYRO_YOUT_L_val;
gZOUT = GYRO_ZOUT_H_val .* 256 + GYRO_ZOUT_L_val;

gXOUT = comp2(gXOUT);
gYOUT = comp2(gYOUT);
gZOUT = comp2(gZOUT);

%conversioni
omega = [gXOUT; gYOUT; gZOUT] / (8192/2)%%
acc_uni = acc .* 9.8 ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% prova
% sto facendo delle fnzioni per farlo più compatto ma mi hanno chiamato
% subito
acc = leggi_valori(dev);
acc = acc / (2^14)

cum = [0; 0; 0];
for i = 1:1000
    [acc, rot] = leggi_valori(dev);
    cum = cum + rot;
    rots(:, i) = cum;
    
    plot(rots(1, :));
    hold on;
    plot(rots(2, :));
    plot(rots(3, :));
    hold off;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FUNZIONI

function [acc, rot] = leggi_valori(dev)
    ACCEL_XOUT_H = 0x3B;
    GYRO_XOUT_H = 0x43;
    
    bytes = dev.read(ACCEL_XOUT_H, 6);
    acc = converti_vettore(bytes);
    
    bytes = dev.read(GYRO_XOUT_H, 6);
    rot = converti_vettore(bytes);
end

function [vett] = converti_vettore(bytes)
    vett = [
        comp2(unisci_bytes(bytes(1), bytes(2)));
        comp2(unisci_bytes(bytes(3), bytes(4)));
        comp2(unisci_bytes(bytes(5), bytes(6)))
        ];
end

function [val] = unisci_bytes(H, L)
    val = double(H) * 256 + double(L);
end

function [val] = comp2(val)
    if val>2^15
        val = val-2^16;
    end 
end