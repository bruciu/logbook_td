%eseguire dopo rotazione terrestre o perlomeno dopo aver salvato i dati
%%rivedi
wy = zeros(M,N);

hold on;
for ii = 1:M
    string = sprintf("%f", ii);
    Ain = letturahex("tmp/rotazione_terra/data" + string +".txt",250, 4);
    
    gyroy = Ain(:, 5); 
    for jj = 1:numel(gyroy)
        wy(ii, jj) = wy(ii, jj) + gyroy(jj);
    end
end

wy2 = zeros(2,N*M/2);
cnt1 = 1;
cnt2 = 1;

for ii = 1:M
    if mod(ii, 2) == 0
        for jj = 0:numel(wy(ii,:))-1
            wy2(1, cnt1 +jj) = wy(ii,jj+1);
            cnt1 = cnt1 + numel(wy(ii,:));
        end
    else
        for jj = 0:numel(wy(ii,:))-1
            wy2(2, cnt2 + jj) = wy(ii,jj+1);
            cnt2 = cnt2 + numel(wy(ii,:));
        end
    end
end

plot(wy2(1));
plot(wy2(2));
hold off;