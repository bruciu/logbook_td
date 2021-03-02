function [T, Tensioni, Correnti] = readiv(path)

[fid, mess] = fopen(path, 'r');

if fid<0
    error("no entry");
end

cs = fgets(fid);
T = sscanf(cs(20:end), '%f %f');

%formatSpec = '%s %s %s %s %f %f';
%sizeA = [6 1];
%A = fscanf(fid,formatSpec,sizeA)

formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fid,formatSpec,sizeA);

Tensioni = (A(1, :))'; % in mA
Correnti = (A(2, :))'; % in V

end

