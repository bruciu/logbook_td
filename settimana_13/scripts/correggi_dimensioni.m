function correggi_dimensioni()

xlim_tmp = xlim;
ylim_tmp = ylim;
zlim_tmp = zlim;

mean_x = mean(xlim_tmp);
range_x = xlim_tmp(2) - xlim_tmp(1);

mean_y = mean(ylim_tmp);
range_y = ylim_tmp(2) - ylim_tmp(1);

mean_z = mean(zlim_tmp);
range_z = zlim_tmp(2) - zlim_tmp(1);

range = max([range_x, range_y, range_z]);
range = range / 2;

xlim([mean_x - range, mean_x + range]);
ylim([mean_y - range, mean_y + range]);
zlim([mean_z - range, mean_z + range]);

set(gcf,'Position',[100 100 800 800])
grid()
end

