filename = 'data/datasett11_luca_corretto.txt';
delimiterIn = '\t';
A = importdata(filename,delimiterIn);
% hold on;
% plot(A(:,2));
sm = smussaf(A(:,2), 0.01);
% plot(sm);
% hold off;

p = A(:,2);
t = A(:,1);
h = (1:7).*1.5 - 1.5;
meanp(1) = mean(p(4560:4969));
meanp(2) = mean(p(3952:4421));
meanp(3) = mean(p(3232:3734));
meanp(4) = mean(p(2624:3077));
meanp(5) = mean(p(1993:2469));
meanp(6) = mean(p(1332:1794));
meanp(7) = mean(p(570:1126));

varp(1) = var(p(4560:4969))./sqrt(4969 - 4560 + 1);
varp(2) = var(p(3952:4421))./sqrt(4421 - 3952 + 1);
varp(3) = var(p(3232:3734))./sqrt(3734 - 3232 + 1);
varp(4) = var(p(2624:3077))./sqrt(3077 - 2624 + 1);
varp(5) = var(p(1993:2469))./sqrt(2469 - 1993 + 1);
varp(6) = var(p(1332:1794))./sqrt(1794 - 1332 + 1);
varp(7) = var(p(570:1126))./sqrt(1126 - 570 + 1);

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
errorbar(hmetri, meanppascal./100, dmeanppascal./100, '-k.');
limits = xlim;
array = linspace(limits(1), limits(2), 1000);
plot(array, funz(coeffvals2(1), coeffvals2(2), array)./100, 'r');

grid();
xlabel("Altezze [m]");
ylabel("Pressioni medie [mbar]");
legend('dati', 'fit')
hold off;




% 
% 
% 
% 
% 
% load('es_11_Serena_hterra.mat')
% p1 = pressioni;
% tempe1 = temperature;
% tempi1 = tempi;
% load('es_11_Serena_h45.mat')
% p2 = pressioni;
% tempe2 = temperature;
% tempi2 = tempi;
% load('es_11_Serena_h88.mat')
% p3 = pressioni;
% tempe3 = temperature;
% tempi3 = tempi;
% load('es_11_Serena_h167.mat')
% p4 = pressioni;
% tempe4 = temperature;
% tempi4 = tempi;
% 
% ft1 = fft(p1);
% for i = 1:ceil(length(ft1)/2)
%     if (i/ceil(length(ft1)/2) > 0.01)
%         ft1(i+1) = 0;
%         ft1(end-i+1) = 0;
%     end
% end
% y_smooth1 = abs(ifft(ft1));
% 
% ft2 = fft(p2);
% for i = 1:ceil(length(ft2)/2)
%     if (i/ceil(length(ft2)/2) > 0.01)
%         ft2(i+1) = 0;
%         ft2(end-i+1) = 0;
%     end
% end
% y_smooth2 = abs(ifft(ft2));
% 
% ft3 = fft(p3);
% for i = 1:ceil(length(ft3)/2)
%     if (i/ceil(length(ft3)/2) > 0.01)
%         ft3(i+1) = 0;
%         ft3(end-i+1) = 0;
%     end
% end
% y_smooth3 = abs(ifft(ft3));
% 
% ft4 = fft(p4);
% for i = 1:ceil(length(ft4)/2)
%     if (i/ceil(length(ft4)/2) > 0.01)
%         ft4(i+1) = 0;
%         ft4(end-i+1) = 0;
%     end
% end
% y_smooth4 = abs(ifft(ft4));
% 
% hold on;
% %errorbar([0, 45, 88, 167.5],[mean(p1), mean(p2), mean(p3), mean(p4)], [sqrt(var(p1)/numel(p1)),sqrt(var(p2)/numel(p2)), sqrt(var(p3)/numel(p3)), sqrt(var(p4)/numel(p4))], 'kd-')
% h = [0, 45, 88, 167.5];
% meanp = [mean(p1), mean(p2), mean(p3), mean(p4)];
% dmeanp = [sqrt(var(p1)/numel(p1)),sqrt(var(p2)/numel(p2)), sqrt(var(p3)/numel(p3)), sqrt(var(p4)/numel(p4))];
% %errorbar(h, meanp, dmeanp/2,dmeanp/2, h.*0 + 1, h.*0 + 1, 'kd-');
% 
% funz = @(a, b, x) - a .* x + b;
% fitfun = fittype(funz);
% X0 = [9.8 * 1.19, meanp(1).*100];
% meanppascal = meanp .* 100;
% dmeanppascal = dmeanp .* 100;
% dhmetri = 2./100;
% hmetri = h./100;
% [fitted_curve, gof] = fit(hmetri', meanppascal', fitfun, "StartPoint", X0, 'Weight', 1./(dmeanppascal'));
% coeffvals2 = coeffvalues(fitted_curve);
% errors = confint(fitted_curve);
% fprintf("a = %.10f +- %.10f\n", coeffvals2(1), (errors(2, 1) - errors(1, 1))/2);
% fprintf("b = %.10f +- %.10f\n", coeffvals2(2), (errors(2, 2) - errors(1, 2))/2);
% 
% for ii = 1:10
%     err = sqrt(dmeanppascal.^2 + (funz(coeffvals2(1), coeffvals2(2), meanppascal) .*dhmetri).^2);
%     [fitted_curve, gof] = fit(hmetri', meanppascal', fitfun, "StartPoint", X0, 'Weight', 1./(err'));
%     coeffvals2 = coeffvalues(fitted_curve);
%     errors = confint(fitted_curve);
%     fprintf("a = %.10f +- %.10f\n", coeffvals2(1), (errors(2, 1) - errors(1, 1))/2);
%     fprintf("b = %.10f +- %.10f\n", coeffvals2(2), (errors(2, 2) - errors(1, 2))/2);
% end
% 
% errorbar(hmetri, meanppascal./100, dmeanppascal./(100.*2),dmeanppascal./(100.*2), h.*0 + 1./100, h.*0 + 1./100, 'k.');
% limits = xlim;
% array = linspace(limits(1), limits(2), 1000);
% plot(array, funz(coeffvals2(1), coeffvals2(2), array)./100, 'r');
% 
% grid();
% xlabel("Altezze [m]");
% ylabel("Pressioni medie [mbar]");
% legend('dati', 'fit')
% hold off;