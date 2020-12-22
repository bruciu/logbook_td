
fps = 30;

A = letturahex("tmp/track/" + "calib_acc_data.txt", 250/180*pi, 4);
N = numel(A(:, 1));


figure;

vid = VideoWriter('tmp/calib', 'MPEG-4');
open(vid);

wb = waitbar(0, "rotazione");
tmp = [-1.5, 1.5];
for i = 10:floor(1000/fps):N
    waitbar(i/N, wb);
    
    acc = A(1:i, 1:3)';
    x = acc(1, :)';
    y = acc(2, :)';
    z = acc(3, :)';
    [ center, radii, evecs, v, chi2 ] = ellipsoid_fit( [ x y z ], '0' );
    plot3( x, y, z, '.-');
    xlabel("acc x [g]")
    xlabel("acc y [g]")
    zlabel("acc z [g]")
    axis vis3d equal;
    view( -70, 40 );
    grid();
    hold on;
    
    %draw fit
    mind = [tmp(1), tmp(1), tmp(1)];
    maxd = [tmp(2), tmp(2), tmp(2)];
    nsteps = 50;
    step = ( maxd - mind ) / nsteps;
    [ x, y, z ] = meshgrid( linspace( mind(1) - step(1), maxd(1) + step(1), nsteps ), linspace( mind(2) - step(2), maxd(2) + step(2), nsteps ), linspace( mind(3) - step(3), maxd(3) + step(3), nsteps ) );
    
    Ellipsoid = v(1) *x.*x +   v(2) * y.*y + v(3) * z.*z + ...
        2*v(4) *x.*y + 2*v(5)*x.*z + 2*v(6) * y.*z + ...
        2*v(7) *x    + 2*v(8)*y    + 2*v(9) * z;
    p = patch( isosurface( x, y, z, Ellipsoid, -v(10) ) );
    hold off;
    set( p, 'FaceColor', 'g', 'EdgeColor', 'none' );
    view( -70, 40 );
    axis vis3d equal;
    camlight;
    lighting phong;
    
    xlim(tmp);
    ylim(tmp);
    zlim(tmp);
    set(gcf,'Position',[200 200 800 800])
    drawnow;
    frame = getframe (gcf);
    writeVideo (vid, frame);
end
close(wb);
close(vid);
