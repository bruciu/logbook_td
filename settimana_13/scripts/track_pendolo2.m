curr_pos = [0; 0; 0];
curr_vel = [0; 0; 0];
pos = [];

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

%hold off;

