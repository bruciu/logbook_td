filename = 'data/datasett11_serena_corretto.txt';
delimiterIn = '\t';
A = importdata(filename,delimiterIn);
hold on;
plot(A(:,2));
sm = smussaf(A(:,2), 0.01);
plot(sm);
hold off;
figure;

p = A(:,2);
t = A(:,1);
h(1) = 0;
h(2) = h(1) + 1.909;
h(3) = h(2) + 1.562;
h(4) = h(3) + 1.735;
h(5) = h(4) +1.215;
h(6) = h(5) + 1.562;
h(7) = h(6) + 1.735;

meanp(1) = mean(p(5519:6140));
meanp(2) = mean(p(4668:5194));
meanp(3) = mean(p(3527:4130));
meanp(4) = mean(p(2814:3221));
meanp(5) = mean(p(2001:2667));
meanp(6) = mean(p(1343:1801));
meanp(7) = mean(p(494:1122));

varp(1) = var(p(5519:6140))./sqrt(6140 - 5519 + 1);
varp(2) = var(p(4668:5194))./sqrt(5194 - 4668 + 1);
varp(3) = var(p(3527:4130))./sqrt(4130 - 3527 + 1);
varp(4) = var(p(2814:3221))./sqrt(3221 - 2814 + 1);
varp(5) = var(p(2001:2667))./sqrt(2667 - 2001 + 1);
varp(6) = var(p(1343:1801))./sqrt(1801 - 1343 + 1);
varp(7) = var(p(494:1122))./sqrt(1122 - 494 + 1);

dmeanp = sqrt(varp);

funz = @(a, b, x) - a .* x + b;
fitfun = fittype(funz);
X0 = [9.8 * 1.19, meanp(1).*100];
meanppascal = meanp .* 100;
dmeanppascal = dmeanp .* 100;
hmetri = h;
[fitted_curve, gof] = fit(hmetri', meanppascal', fitfun, "StartPoint", X0, 'Weight', 1./(dmeanppascal'));
coeffvals2 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("a = %.10f +- %.10f\n", coeffvals2(1), (errors(2, 1) - errors(1, 1))/2);
fprintf("b = %.10f +- %.10f\n", coeffvals2(2), (errors(2, 2) - errors(1, 2))/2);
hold on;
errorbar(hmetri, meanppascal./100, dmeanppascal./100, 'k.');
limits = xlim;
array = linspace(limits(1), limits(2), 1000);
plot(array, funz(coeffvals2(1), coeffvals2(2), array)./100, 'r');

grid();
xlabel("Altezze [m]");
ylabel("Pressioni medie [mbar]");
legend('dati', 'fit')
hold off;
