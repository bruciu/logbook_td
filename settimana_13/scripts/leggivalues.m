function [acc, omega, T] = leggivalues(dev, conva, convg)
%LEGGIVALUES Summary of this function goes here
%   Detailed explanation goes here
%lettura dati
ACCELHL = dev.read(0x3B, 6);
GYROHL = dev.read(0x43, 6);
TEMPHL = dev.read(0x41, 2);

%concatenazione a vettore e complemento a 2:
ACCEL = converti_vettore(ACCELHL);
GYRO = converti_vettore(GYROHL);
TEMP = unisci_bytes(TEMPHL(1), TEMPHL(2));
TEMP = comp2(TEMP);

%conversione accelerazione a m/s^2:
acc = ACCEL./conva; %a mano
acc = acc .* 9.8;

%conversione temperatura a gradi:
T = TEMP./340 + 36.53;

%conversione velocità angolare in rad/s:
omega = (GYRO.*pi)./(180.*convg);
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