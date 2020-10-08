function [tensore] = listfilesfun(Name_folder)
%LISTFILESFUN Summary of this function goes here
%   Detailed explanation goes here
lista = dir(Name_folder);
%listaName = strsplit(num2str(1:numel(Name_folder)));
%for i = 1:numel(lista)
%    listaName(i) = lista(i).name;
    %display(lista(i).name);
%end
%display(lista)
for i = 3:numel(lista)
    name = strcat(strcat(Name_folder, "/") , lista(i).name);
    %display(name);
    [xx, yy] = leg_wavf(name);
    vector = [xx, yy];
    display(vector);
    plot(vector(:,1), vector(:,2), '.-');
    figure;
end
%vector = zeros(1, 3);
tensore = 0;
end

