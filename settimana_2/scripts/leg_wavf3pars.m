function [freq, A, phi]=leg_wavf3pars(name)
% [x,y,z]=leg_wavf(name)
% legge una vaweform prodotta da LabVIEW e restituisce due colonne (tempo,Y)

[fid, mess]=fopen(name,'r');
if fid<0
   disp(mess);
   return
end

%fgets(fid); % legge una linea

tmp = fscanf(fid,'%f %f %f\n', [3 Inf]);
freq = tmp(1,:);
A = tmp(2,:);
phi = tmp(3,:);

fclose(fid);
return