function [acc, gyro] = correggi_letture(calib_folder, Ain, GFS, AFS, plot_bool)

if (nargin < 5)
    plot_bool = false;
end

% ================================
%           ACCELEROMETRO
% ================================

% leggi dati calibrazione
A = letturahex(calib_folder + "calib_acc_data.txt", GFS, AFS);

[ center, radii, evecs, v, chi2 ] = ellipsoid_fit(A(:, 1:3), '0');

% ricerca assi
for i = 1:3
    if (evecs(1, i) > 0.5)
        R(1) = radii(i);
    end
    if (evecs(2, i) > 0.5)
        R(2) = radii(i);
    end
    if (evecs(3, i) > 0.5)
        R(3) = radii(i);
    end
end

% come vettori colonna
acc = Ain(:, 1:3)';

% correzione centro e scalatura
for i = 1:3
    acc(i, :) = (acc(i, :) - center(i)) / R(i);
end

% ================================
%           GIROSCOPIO
% ================================

% leggi dati calibrazione
A = letturahex(calib_folder + "calib_gyro_data.txt", GFS, AFS);

% trova media delle letture
center(1) = mean(A(:, 4));
center(2) = mean(A(:, 5));
center(3) = mean(A(:, 6));

gyro = Ain(:, 4:6)';
% correzione centro
for i = 1:3
    gyro(i, :) = gyro(i, :) - center(i);
end

end


