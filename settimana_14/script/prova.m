clear all;

% indirizzo del sensore
SAD = 0b1010000; % = 80
CONF_MEAS1 = 0x08;
CONF_MEAS2 = 0x09;
CONF_MEAS3 = 0x0A;
CONF_MEAS4 = 0x0B;
FDC_CONF = 0x0C;
MEAS1_MSB = 0x00;
MEAS1_LSB = 0x01;
MEAS2_MSB = 0x02;
MEAS2_LSB = 0x03;
MEAS3_MSB = 0x04;
MEAS3_LSB = 0x05;
MEAS4_MSB = 0x06;
MEAS4_LSB = 0x07;

N = 1000;

dev = I2Cdevice("com3", SAD);

% impostiamo la configurazione delle letture da far fare,
% usiamo solo la configurazione 1
scrivi_registro(dev, CONF_MEAS1, 0b0001110000000000);

%impostiamo l'FDC, impostiamo solo la misura 1, non ripetuta a 100S/s
scrivi_registro(dev, FDC_CONF,   0b0000010110000000);

%acquisizione

misure = [];
for i = 1:N
    misure = [misure, leggi_misura(dev, 1)];
    plot(misure, '.-')
end
plot(misure, '.-')

media = mean(misure);
dev = sqrt(var(misure)./N);

% =============================== funzioni

% leggi misura
function [result] = leggi_misura(dev, n)
    SUB = 0x00 + (n - 1) * 2;
    
    % attendi che la misura sia pronta
    mask = 2^(4-n);
%     while (~bitand(leggi_registro(dev, 0x0C), mask))
%     end
    
    MSB_result = leggi_registro(dev, SUB);
    LSB_result = leggi_registro(dev, SUB + 1);
    result = unisci_bytes(MSB_result*256, LSB_result);
    result = result / 256;
    result = comp2(result) ./ 2.^19;
end

function [result] = leggi_registro(dev, SUB)
    bytes = dev.read(SUB, 2);
    result = unisci_bytes(bytes(1), bytes(2));
end

function [val] = unisci_bytes(H, L)
    val = double(H) * 256 + double(L);
end

function [val] = comp2(val)
    if val>2^23
        val = val-2^24;
    end 
end

function scrivi_registro(dev, SUB, valore)
    bytes = [floor(double(valore) / 2^8), mod(valore, 2^8)];
    dev.write(SUB, bytes);
end