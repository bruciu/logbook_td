
clear device
device = serialport("COM3", 57600);
flush(device);


N = 100;

D = [];
C = [];
dC = [];

while (input("continua? "))
    
    D = [D, input("distanza? ")];
    w = waitbar(0, "h");
    misure = [];
    flush(device);
    for i = 1:10
        device.readline();
    end
    for i = 1:N
        s = device.readline();
        misure = [misure, str2num(s)];
        waitbar(i/N, w);
    end
    plot(misure);
    close(w);
    C = [C, mean(misure)];
    dC = [dC, sqrt(var(misure) / numel(misure))];
    
end

plot(D, C);



