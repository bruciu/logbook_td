mini = Nucleo;
mini.apri_comunicazione('COM3');
mini.writeline('I2CWRITE 63,0');
mini.readline()
