mini = Nucleo;
mini.apri_comunicazione('COM3');
%mini.writeline('I2CWRITE 63,8');
 for ii = 0:127
     mini.writeline(sprintf('I2CWRITE %f,0', ii))
     %pause(1);
     l = mini.readline();
     mini.writeline("I2CREAD?");
     l2 = mini.readline();
     if (l(1) ~= 'E')
         ii
         disp(l)
         %disp(l2)
     end
     %pause(1);
     %ii
 end
