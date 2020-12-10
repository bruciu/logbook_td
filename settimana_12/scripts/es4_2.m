clear all

ig = Igrometro('COM3');

for i = 1:10
[U, T] = ig.readValue();
end


