
clear device
device = serialport("COM3", 57600);
flush(device);

N = 300;

misure = [];

flush(device);
for i = 1:10
    device.readline();
end

for i = 1:N
    s = device.readline();
    misure = [misure, str2num(s)];
    plot(misure);
end


