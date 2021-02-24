function [runs] = read_folder(path)

if (path(end) ~= '/')
    path = strcat(path, '/');
end

lista = dir(path);

runs = [];

for i = 1:numel(lista)
    
    f = lista(i);
    
    if (f.isdir)
        continue
    end
    
    [tmp_T, tmp_V, tmp_I] = readiv(strcat(path, f.name));
    
    run.name = f.name;
    run.T = tmp_T;
    run.V = tmp_V;
    run.I = tmp_I;
    
    runs = [runs; run];
end

end

