function [x,y,z]=leg_wavf3pars(name)
% [x,y,z]=leg_wavf(name)
% legge una vaweform prodotta da LabVIEW e restituisce due colonne (tempo,Y)

[fid, mess]=fopen(name,'r');
if fid<0
   disp(mess);
   return
end
fgets(fid);
freq =fscanf(fid,'%*s %*s %f\n',1);
fgets(fid);
A =fscanf(fid,'%*s %*s %f\n',1);
fgets(fid);
phi =fscanf(fid,'%*s %*s %f');
fclose(fid);
x=dt*(0:size(y)-1)';
return