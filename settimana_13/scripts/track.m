
Ain = letturahex("tmp/track/data.txt", 250*pi/180, 2);

[acc, gyro] = correggi_letture("tmp/track/", Ain, 250*pi/180, 2);

acc = 9.8.*acc;

curr_R = quaternion(1, 0, 0,0);
R = curr_R;%dopo c'è da togliere il primo
dt = 0.001;
tempo = ((1:numel(acc(1,:))) - 1).*dt;
figure;
%hold on;



accworld = [];

for ii = 1:length(gyro(1,:))
    norma = norm(gyro(:,ii));
    versor = gyro(:,ii)./norma;
    c = sin(norma*dt/2).*versor;
    quat = quaternion(cos(norma*dt/2), c(1), c(2), c(3));
    curr_R = curr_R .* quat;
    R  = [R, curr_R];
    rot_mat = quat2rotm(curr_R);
    curr_accworld = rot_mat * acc(:, ii);
    accworld = [accworld, curr_accworld];
    if mod(ii, 50) == 0
        plot_pos_rot([0;0;0], rot_mat, 1)
        hold on
        plot3([0, curr_accworld(1)], [0, curr_accworld(2)], [0, curr_accworld(3)]);
        hold off;
        xlim([-2 2])
        ylim([-2 2])
        zlim([-2 2])
        correggi_dimensioni
        pause(0.01);
    end
end

curr_pos = [0; 0; 0];
curr_vel = [0; 0; 0];
pos = [];

acc_mean = mean(accworld, 2); 
for ii = 1:length(gyro(1,:))
    curr_vel = curr_vel + (accworld(:, ii)-acc_mean).*dt;
    curr_pos = curr_pos + curr_vel.*dt;
    pos = [pos, curr_pos];
    
    curr_vel = curr_vel * exp(-1/(5*1000));
    
    if mod(ii, 50) == 0
        plot_pos_rot(curr_pos, quat2rotm(R(ii)), 1);
        hold on
        plot3(pos(1,:), pos(2,:), pos(3,:));
        hold off;
         xlim([-2 2].*2)
         ylim([-2 2].*2)
         zlim([-2 2].*2)
        correggi_dimensioni
        pause(0.01);
    end
end

%hold off;

