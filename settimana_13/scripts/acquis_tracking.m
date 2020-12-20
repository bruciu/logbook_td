
N = 20000;

acquisizione_calibrazione('COM3', "tmp/track/");

fprintf("premi Enter per acquisire (durata stimata %f s)\n", N/ 1000);
pause

acquire('COM3', "tmp/track/data.txt", N)


