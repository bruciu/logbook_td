function [A] = letturahex(path, GFS, AFS)
%LETTURAHEX Summary of this function goes here
%   Detailed explanation goes here

%file = fopen(path, 'r');
% filename = path;
% delimiterIn = ' ';
% headerlinesIn = 1;
% A = importdata(filename,delimiterIn,headerlinesIn);

%A = importdata(path);

%filename = fopen(path, 'r');

%A = readlines(path)

%A = readmatrix(path, 'OutputType', 'uint16', 'Delimiter', '\t', 'LineEnding', '\n')

presetSize = 100000;
A = zeros(presetSize, 6);
counter = 0;

fid=fopen(path);
while ~feof(fid)
    riga = fgetl(fid);
    if numel(riga) < 35
        counter = counter + 1;
        riga = hex2dec(regexp(riga,'\t','split'));
        A(counter, :) = riga';
    end
end

A = A(1:counter, :);

for ii =1:6
    A(:, ii) = typecast(uint16(A(:, ii)),'int16');
end
A(:,1:3) = AFS*double(A(:,1:3))/2^15;
A(:,4:6) = GFS*double(A(:,4:6))/2^15;
%A = fscanf(filename, '%d') 

%fclose(filename);



%fclose(file);



end

