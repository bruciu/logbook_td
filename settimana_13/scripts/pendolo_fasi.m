



[~, ~, theta, ~] = parts(R);

theta = asin(theta)*2;

plot(theta, gyro(2, :));
xlabel("$\theta$ [rad]", 'interpreter','latex', 'fontsize',14)

ylabel("$\dot{\theta}$ [rad]", 'interpreter','latex', 'fontsize',14)
grid

