
N = 100000;
fprintf("premi Enter per acquisire (durata stimata %f s)\n", N/ 1000);
pause

%acquire('COM3', "tmp/pendolo/data.txt", N);
Ain = letturahex("tmp/pendolo/dataì.txt", 250*pi/180, 4);

[acc, gyro] = correggi_letture("tmp/pendolo/", Ain, 250*pi/180, 4);

acc = 9.8.*acc;

dt = 0.001;
t = dt .* ((1:N) - 1);

% figure;
% plot(t, gyro(1, :), 'k');
% xlabel("Tempo [s]");
% ylabel("Velocità angolare x [rad/s]");
% grid();
% 
% 
% figure;
% plot(t, gyro(2, :), 'k');
% xlabel("Tempo [s]");
% ylabel("Velocità angolare y [rad/s]");
% grid();
% 
% 
% figure;
% plot(t, gyro(3, :), 'k');
% xlabel("Tempo [s]");
% ylabel("Velocità angolare z[rad/s]");
% grid();
% 




