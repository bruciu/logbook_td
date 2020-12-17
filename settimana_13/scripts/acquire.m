function acquire(porta, fileName, Nmisure)
%ACQUIRE Summary of this function goes here
%   Detailed explanation goes here
    
% righe da saltare all'inizio
nSkip = 10;
sp = serialport(porta, 2000000);

% file
fileID = fopen(fileName,'w');

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
end
toc;

fclose(fileID);

end

