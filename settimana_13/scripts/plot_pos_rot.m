function plot_pos_rot(pos, rot_mat, scale)
%PLOT_POS_ROT funzione per disegnare degli assi orientati nello spazio
%   pos è la posizione in cui disegnare gli assi
%   rot_mat è la matrice di rotazione del modello
%
%   le frecce sono disegnate coi colori R, G, B
    arguments
        pos (3,1) double
        rot_mat (3,3) double
        scale (1,1) double
    end

    % direzioni assi
    arr_x = [1; 0; 0] * scale; color_x = 'r';
    arr_y = [0; 1; 0] * scale; color_y = 'g';
    arr_z = [0; 0; 1] * scale; color_z = 'b';
    
    % rotazine
    arr_x = pos + rot_mat* arr_x;
    arr_y = pos + rot_mat* arr_y;
    arr_z = pos + rot_mat* arr_z;
    
    hold on;
    plot3([pos(1), arr_x(1)], [pos(2), arr_x(2)], [pos(3), arr_x(3)], color_x);
    plot3([pos(1), arr_y(1)], [pos(2), arr_y(2)], [pos(3), arr_y(3)], color_y);
    plot3([pos(1), arr_z(1)], [pos(2), arr_z(2)], [pos(3), arr_z(3)], color_z);
end

