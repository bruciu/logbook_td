function acquisizione_calibrazione(porta, folder, Nacc, Ngyro)

if (nargin < 3)
    Nacc = 30000;
end

if (nargin < 4)
    Ngyro = 5000;
end

fprintf("Acquisizione per la calibrazione giroscopio\n");
fprintf("premi Enter per acquisire (durata stimata %f s)\n", Nacc / 1000);
pause

acquire(porta, folder + "calib_acc_data.txt", Nacc);

fprintf("Acquisizione per la calibrazione giroscopio\n");
fprintf("premi Enter per acquisire (durata stimata %f s)\n", Ngyro / 1000);
pause

acquire(porta, folder + "calib_gyro_data.txt", Ngyro);

end