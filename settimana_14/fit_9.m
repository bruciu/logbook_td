
% D = distanze
% C = capacità

xx = D / 100;
yy = C;

% epsylon 0
E0 = 8.9e-12 * 1e+12;
S = pi * (2.5/2 * 0.01)^2;

ww = 1./(E0 .* S ./ xx.^2);

figure;
hold on;
plot(xx, yy, "d");
fplot(@(x) E0 .* S ./ x, [min(xx), max(xx)]);

xlabel("distanza [m]"); ylabel("capacità misurata [pF]");
grid();


x0 = [1e-11]; 
f = @(offset,x) E0 .* S ./ x + offset;
fitfun = fittype(f);
[fitted_curve,gof] = fit(xx',yy',fitfun,'StartPoint',x0,'Weight', ww);

% Save the coeffiecient values for a,b,c and d in a vector
coeffvals = coeffvalues(fitted_curve);
errors = confint(fitted_curve);


figure;
hold on;
plot(xx, yy, "d");
fplot(@(x) f(coeffvals(1), x), [min(xx), max(xx)]);
grid();


x0 = [1e-11, 1]; 
f = @(offset, A ,x) A * E0 .* S ./ x + offset;
fitfun = fittype(f);
[fitted_curve,gof] = fit(xx',yy',fitfun,'StartPoint',x0,'Weight', ww);

% Save the coeffiecient values for a,b,c and d in a vector
coeffvals = coeffvalues(fitted_curve)
errors = confint(fitted_curve);

figure;
hold on;
plot(xx, yy, "d");
fplot(@(x) f(coeffvals(1), coeffvals(2), x), [min(xx), max(xx)]);
grid();


