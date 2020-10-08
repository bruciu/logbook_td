function [x,y]=leg_wavf(name)
% [x,y]=leg_wavf(name)
% legge una vaweform prodotta da LabVIEW e restituisce due colonne (tempo,Y)

[fid, mess]=fopen(name,'r');
if fid<0
   disp(mess);
   return
end
fgets(fid);
dt=fscanf(fid,'%*s %*s %f\n',1);
fgets(fid);
y=fscanf(fid,'%*s %*s %f');
fclose(fid);
x=dt*(0:size(y)-1)';
return