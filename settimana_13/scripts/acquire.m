function acquire(porta, fileName, Nmisure)
%ACQUIRE Summary of this function goes here
%   Detailed explanation goes here

% righe da saltare all'inizio
nSkip = 10;

% file
fileID = fopen(fileName,'w');

wb = waitbar(0, "presa dati");

sp = serialport(porta, 2000000);

% nSkip
for i = 1:nSkip
    sp.readline();
end

tic;
for i = 1:Nmisure
    line = sp.readline();
    fprintf(fileID, line);
    
    if (mod(i, 100) == 0)
        disp(line)
    end
    
    if (mod(i, 2000) == 0)
        waitbar(i/Nmisure, wb);
    end
end
toc;

fclose(fileID);
close(wb);

end

