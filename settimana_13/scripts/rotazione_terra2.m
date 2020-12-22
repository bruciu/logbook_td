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
    dev_wy = [dev_wy, sqrt(var(gyroy)/numel(gyroy))];
end

wy2 = zeros(2,N*M/2);
cnt1 = 0;
cnt2 = 0;
dw3 = [];
dw4 = [];

for ii = 1:M
    if mod(ii, 2) == 0
        for jj = 1:N
            wy2(1, cnt1 +jj) = wy(ii, jj);
        end
        cnt1 = cnt1 + numel(wy(ii, :));
        dw3 = [dw3, dev_wy(ii)];
    else
        for jj = 1:N
            wy2(2, cnt2 + jj) = wy(ii,jj);
        end
        cnt2 = cnt2 + numel(wy(ii, :));
        dw4 = [dw4, dev_wy(ii)];
    end
end

wy3 = [];
wy4 = [];

for ii = 1:M
    if mod(ii, 2) ~= 0
        if wy2(1, ii) ~= 0
        wy3 = [wy3, wy2(1, ii)];
        end
    end
    if wy2(2, ii) ~= 0
        if mod(ii, 2) == 0
        wy4 = [wy4, wy2(2, ii)];
        end
    end
end

plot(wy3, 'd-');
plot(wy4, 'd-');
hold off;
plot(wy3 - wy4, 'd-');
mean(wy3 - wy4);
errore = sqrt(dw3.^2 + dw4.^2);
dtheta = (180./pi).*sqrt(mean(errore).*2./M)./(1 - (mean(offs)./(2.*0.00417)).^2)