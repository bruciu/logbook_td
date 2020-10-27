function [x,y1,y2,y3]=leg_wavf3(name)
% [x,y1,y2,y3]=leg_wavf3(name)
% legge una vaweform tripla prodotta da LabVIEW e restituisce quattro colonne (tempo,Y1, Y2,Y3)

[fid, mess]=fopen(name,'r');
if fid<0
   disp(mess);
   return
end
% toglie le prime due righe
fgetl(fid); fgetl(fid);
dt=fscanf(fid,'%*s %*s %*f %*f %f\n',1);
fgets(fid); 
a=fscanf(fid,'%*s %*s %f %f %f',[2 inf]);
fclose(fid);
a=a';
y1=a(:,1);
y2=a(:,2);
y3=a(:,3);
x=dt*(0:length(y1)-1)';
return