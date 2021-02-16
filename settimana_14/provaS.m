clear all;
dev = I2Cdevice("com3", 0b1010000);

dev.read(0xFF, 2);
leggi_registro(dev, 0xFF)
dec2hex(ans)

function [result] = leggi_registro(dev, SUB)
    bytes = dev.read(SUB, 2);
    result = unisci_bytes(bytes(1), bytes(2));
end

function [val] = unisci_bytes(H, L)
    val = double(H) * 256 + double(L);
end

function [val] = comp2(val)
    if val>2^15
        val = val-2^16;
    end 
end