clear dev

SAD = 0x44;
dev = I2Cdevice('COM3',SAD);
dev.write(0x27, 0x37);

NBYTES = 6;
bytes = dev.read(0xE000,NBYTES);
St = bytes(1)*256 + bytes(2);
Su = bytes(4)*256 + bytes(5);

U = 100*Su/(2^16 - 1);
T = -45 + 175*St/(2^16 - 1);

fprintf("Temperatura: %fC\n", T);
fprintf("Umidità: %f RH\n", U);

tt = [];
uu = [];
for i = 1:1000
    pause(0.110);
    
    bytes = dev.read(0xE000,NBYTES);
    St = bytes(1)*256 + bytes(2);
    Su = bytes(4)*256 + bytes(5);
    
    U = 100*Su/(2^16 - 1);
    T = -45 + 175*St/(2^16 - 1);
    tt = [tt, T];
    uu = [uu, U];
    
    yyaxis left;
    plot(tt);
    yyaxis right;
    plot(uu);
end

xlabel("numero di lettura");
yyaxis left;
ylabel("temperatura [°C]");
yyaxis right;
ylabel("umidità [PS*100]");
grid();




