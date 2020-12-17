path = "tmp/";

A  = letturahex('tmp/Sere_2_velocissima_6bw.txt', 2000.*pi./180, 8);


accelerazioni = [];
accelerazioni(1, :) = A(:,1)';
accelerazioni(2, :) = A(:,2)';
accelerazioni(3, :) = A(:,3)';
pulsazioni(1,:) = A(:,4);
pulsazioni(2,:) = A(:,5);
pulsazioni(3,:) = A(:,6);

% ax = A(:,1);
% ay = A(:,2);
% az = A(:,3);
% wx = A(:,1);
% wy = A(:,1);
% wz = A(:,1);

tempo = 1e-3 .* ((1:numel(ax))-1); 

save("dataSere_2_velocissima_6bw.mat", "accelerazioni", "pulsazioni", "tempo");
