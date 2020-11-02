mini = Nucleo;
mini.apri_comunicazione('COM3');
 mini.writeline('I2CWRITE 63,8');
% for ii = 117:128
%     mini.writeline(sprintf('I2CWRITE %f,8', ii-1))
%     pause(1);
     mini.readline()
%     pause(1);
%     ii
% end
