function [T] = readiv(path)
[fid, mess] = fopen(path, 'r');
if rid<0
    error("no entry")
end

formatSpec = '%s %s %s %s %f %f';
sizeA = [6 1];
A = fscanf(fileID,formatSpec,sizeA)

end

