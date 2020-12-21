
N = 5000;

%acquisizione_calibrazione('COM3', "tmp/track/", 30000);

fprintf("premi Enter per acquisire (durata stimata %f s)\n", N/ 1000);
pause

acquire('COM3', "tmp/track/data.txt", N)


