clear all;

mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.calibration();

c = CorrettoreADC;
c.run(mini);
c.salva("dati_calibrazione/luca_30MHz_12.5.mat");