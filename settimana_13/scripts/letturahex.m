function [A] = letturahex(path)
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

A = [];

fid=fopen(path);
while ~feof(fid)
    riga = fgetl(fid);
    riga = hex2dec(regexp(riga,'\t','split'));
    A = [A; riga'];
end


%A = fscanf(filename, '%d') 

%fclose(filename);



%fclose(file);



end

