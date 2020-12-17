path = "tmp/";

A  = letturahex('tmp/Sere_1_velocissima.txt', 2000.*pi./180, 8);

ax = A(:,1);
ay = A(:,2);
az = A(:,3);
wx = A(:,1);
wy = A(:,1);
wz = A(:,1);

tempi = 1e-3 .* ((1:numel(ax))-1); 