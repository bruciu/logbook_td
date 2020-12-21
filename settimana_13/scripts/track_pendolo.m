
Ain = letturahex("tmp/pendolo/dataì.txt", 250*pi/180, 4);

[acc, gyro] = correggi_letture("tmp/pendolo/", Ain, 250*pi/180, 4);
%gyro = gyro - mean(gyro(:, 1:5000), 2);

N = length(gyro(1,:));

acc = 9.8.*acc;

curr_R = quaternion(sqrt(2)/2, 0, sqrt(2)/2,0);
R = curr_R * zeros(N, 1);%dopo c'è da togliere il primo
dt = 0.001;
tempo = ((1:numel(acc(1,:))) - 1).*dt;
figure;
%hold on;



accworld = zeros(3, N);

wb = waitbar(0, "rotazione");
for ii = 1:length(gyro(1,:))
    norma = norm(gyro(:,ii));
    versor = gyro(:,ii)./norma;
    c = sin(norma*dt/2).*versor;
    quat = quaternion(cos(norma*dt/2), c(1), c(2), c(3));
    curr_R = curr_R .* quat;
    R(ii)  = curr_R;
    rot_mat = quat2rotm(curr_R);
    curr_accworld = rot_mat * acc(:, ii);
    accworld(:, ii) = curr_accworld;
    if mod(ii, 500) == 0
        waitbar(ii/N, wb);
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
close(wb);

curr_pos = [0; 0; 0];
curr_vel = [0; 0; 0];
pos = [];

wb = waitbar(0, "posizione");
acc_mean = mean(accworld(:, 1:2500), 2); 
for ii = 1:length(gyro(1,:))
    
    delta = exp(-1/(2*1000));
    acc_mean = acc_mean*delta + accworld(:, ii)*(1 - delta);
    
    curr_vel = curr_vel + (accworld(:, ii)-acc_mean).*dt;
    curr_pos = curr_pos + curr_vel.*dt;
    pos = [pos, curr_pos];
    
    curr_vel = curr_vel * exp(-1/(10*1000));
    curr_pos = curr_pos * exp(-1/(1*1000));
    
    if mod(ii, 20) == 0
        waitbar(ii/N, wb);
        plot_pos_rot(curr_pos, quat2rotm(R(ii)), 0.05);
        hold on
        %plot3([0, accworld(1, ii)-acc_mean(1)]*10, [0, accworld(2, ii)-acc_mean(2)]*10, [0, accworld(3, ii)-acc_mean(3)]*10, 'r', "linewidth", 2);
        plot3(pos(1,:), pos(2,:), pos(3,:));
        hold off;
        f = 0.2;
         xlim([-1 1]*f)
         ylim([-1 1]*f)
         zlim([-1 1]*f)
        correggi_dimensioni
        pause(0.01);
    end
end
close(wb);

%hold off;

