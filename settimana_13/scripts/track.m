
Ain = letturahex("tmp/track/data_ang.txt", 250*pi/180, 4);

[acc, gyro] = correggi_letture("tmp/track/", Ain, 250*pi/180, 4);
gyro = gyro - mean(gyro(:, 1:5000), 2);

acc = 9.8.*acc;

curr_R = quaternion(0, 1, 0,0);
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
    if mod(ii, 500) == 0
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

acc_mean = mean(accworld(:, 1:5000), 2); 
for ii = 1:length(gyro(1,:))
    
    delta = exp(-1/(2*1000));
    %acc_mean = acc_mean*delta + accworld(:, ii)*(1 - delta);
    
    curr_vel = curr_vel + (accworld(:, ii)-acc_mean).*dt;
    curr_pos = curr_pos + curr_vel.*dt;
    pos = [pos, curr_pos];
    
    curr_vel = curr_vel * exp(-1/(0.5*1000));
    curr_pos = curr_pos * exp(-1/(0.1*1000));
    
    if mod(ii, 20) == 0
        plot_pos_rot(curr_pos, quat2rotm(R(ii)), 0.05);
        hold on
        %plot3([0, accworld(1, ii)-acc_mean(1)]*10, [0, accworld(2, ii)-acc_mean(2)]*10, [0, accworld(3, ii)-acc_mean(3)]*10, 'r', "linewidth", 2);
        plot3(pos(1,:), pos(2,:), pos(3,:));
        hold off;
        f = 0.1;
         xlim([-1 1]*f)
         ylim([-1 1]*f)
         zlim([-1 1]*f)
        correggi_dimensioni
        pause(0.01);
    end
end

%hold off;

