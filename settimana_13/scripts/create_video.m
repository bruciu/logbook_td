
fps = 30;

N = numel(acc(1, :));

% ================================
%     ROTAZIONE / accelerazione
% ================================
figure;

v = VideoWriter('tmp/rot', 'MPEG-4');
open(v); 

wb = waitbar(0, "rotazione");
tmp = [-1.5, 1.5];
for i = 1:floor(1000/fps):N
    waitbar(i/N, wb);
    rot_mat = quat2rotm(R(i));
    plot_pos_rot([0; 0; 0], rot_mat, 1);
    hold on;
    plot3([0, accworld(1, i)], [0, accworld(2, i)], [0, accworld(3, i)], "r");
    hold off;
    xlim(tmp);
    ylim(tmp);
    zlim(tmp);
    set(gcf,'Position',[200 200 800 800])
    grid();
    drawnow;
    frame = getframe (gcf);
    writeVideo (v, frame);
end
close(wb);
close(v);


% ================================
%     POSIZIONE / rotazione
% ================================
figure;
xlabel("pos x [m]");
xlabel("pos y [m]");
xlabel("pos z [m]");

v = VideoWriter('tmp/pos', 'MPEG-4');
open(v); 

wb = waitbar(0, "posizione");
tmp = [-1, 1]*0.05;
for i = 1:floor(1000/fps):N
    waitbar(i/N, wb);
    rot_mat = quat2rotm(R(i));
    plot_pos_rot(pos(:, i), rot_mat, 0.05);
    hold on;
    plot3(pos(1, 1:i), pos(2, 1:i), pos(3, 1:i));
    hold off;
    xlim(tmp);
    ylim(tmp);
    zlim(tmp);
    set(gcf,'Position',[200 200 800 800])
    grid();
    drawnow;
    frame = getframe (gcf);
    writeVideo (v, frame);
end
close(wb);
close(v);









