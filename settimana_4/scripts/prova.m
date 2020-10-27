%clear all

n = Nucleo;

n.apri_comunicazione('COM3');
% 
% n.sp.writeline('TIMER?');
% 
% str = n.readline();

% n.getInfo()
% 
% n.setDAC(true);
% n.isDAC_ON()
% n.setDAC(false);
% n.isDAC_ON()


n.setNSamples(100)

n.getNSamples()

n.setNSamples(10)

n.getNSamples()

%clear all; %chiude lo stesso la seriale
