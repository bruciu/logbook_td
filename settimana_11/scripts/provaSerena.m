clear all;

SAD = 93;
dev = I2Cdevice('COM3',SAD);

CTRL_REG1 = 0x20;
CTRL_REG1_val = 0b10000000; % acensionie in modalità single shot
dev.write(CTRL_REG1,[CTRL_REG1_val]);

SUB = 0x2B + 0x80;
bytes = dev.read(SUB, 2);
TT = bytes(2)*256 + bytes(1);
if TT>2^15
    TT = TT-2^16;
end

fprintf('Temperatura: %fC\n',42.5+TT/480);

% 1 = 0x1 = 0b1;
% 0x43 = 67
% 0b10 = 2
