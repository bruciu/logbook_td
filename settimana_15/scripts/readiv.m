function [T] = readiv(path)

[fid, mess] = fopen(path, 'r');

if fid<0
    error("no entry")
end

formatSpec = '%s %s %s %s %f %f';
sizeA = [6 1];
A = fscanf(fid,formatSpec,sizeA)
formatSpec = '%f %f';
sizeA = [2 Inf];
A = fscanf(fid,formatSpec,sizeA)

T = 0;

end

