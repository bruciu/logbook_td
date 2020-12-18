function [] = correggi_letture(calib_folder, Ain, GFS, AFS, plot_bool)

if (nargin < 5)
    plot_bool = false;
end

% ================================
%           ACCELEROMETRO
% ================================

% leggi dati calibrazione
A = letturahex(calib_folder + "calib_acc_data.txt", GFS, AFS);

[ center, radii, evecs, v, chi2 ] = ellipsoid_fit(A(:, 1:3), '0');




end


