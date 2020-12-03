% =========================================================================
%  Esempio I2Cdevice
% =========================================================================

clear all;

% Sintassi per la creazione dell'oggeto I2Cdevice
%
% oggetto = I2Cdevice(NOMECOM,indirizzochip);
%
SAD = 93;
dev = I2Cdevice('COM5',SAD);

% Sintassi per il metodo "write", che scrive dei valori sul dispositivo I2C
%
% oggetto.write(indirizzomemoria,[valori...]);
%

SUB = 0x20;
vals = [0xE0];
dev.write(SUB,vals);

% Sintassi per il metodo "write", che scrive dei valori sul dispositivo I2C
%
% oggetto.read(indirizzomemoria,#valori);
%

SUB = 0x2B+0x80;
bytes = dev.read(SUB,2);
TT = bytes(1) + bytes(2)*256;
if TT>2^15
    TT = TT-2^16;
end
fprintf('Temperatura: %fC\n',42.5+TT/480);