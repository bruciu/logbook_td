
[T, P, dP, chi2, chi2rid, fName] = fit_folder_bassa('a', "data/CIUBRU/bassa_corrente");


[fid, mess] = fopen("data/CIUBRU/tabella_es_5.txt", 'w');

if fid <0
    error(mess);
end

for i = 1:numel(chi2)
    fprintf(fid, "%s %e %e %e %e %e %e\n",...
        fName(i), mean(T(i, :), 2), P(i,1), dP(i, 1), P(i, 2), dP(i, 2), chi2(i));
end


fclose(fid);
