
[T, P, dP, chi2, chi2rid, fName, Imin] = fit_folder_alta("data/CIUBRU/alta_corrente");


[fid, mess] = fopen("data/CIUBRU/tabella_es_12.txt", 'w');

if fid <0
    error(mess);
end

for i = 1:numel(chi2)
    fprintf(fid, "%s %e %e %e %e %e %e %e %e %e\n",...
        fName(i), mean(T(i, :), 2), 1/P(i, 2), 1/dP(i, 2), P(i,1), dP(i, 1), P(i,3), dP(i, 3), chi2(i), Imin(i));
end


fclose(fid);