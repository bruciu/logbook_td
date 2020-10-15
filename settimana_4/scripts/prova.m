%clear all

n = Nucleo;

n.apri_comunicazione('COM3');

n.sp.writeline('TIMER?');

str = n.readline();

str

%clear all; %chiude lo stesso la seriale
