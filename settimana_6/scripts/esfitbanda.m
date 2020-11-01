%c'è da fare prima es.5 per farlo funzionare
clear i;
guad = A;
dguad = dA;
f = freqs;

R2_val = (10e3 / 2);
R1_val = (1e3);
C1_val = (10e-9);
C2_val = (68e-9);

funz = @(p11, p12, p22, x)abs((1./(1 + 1./(2.*pi.*x.*1i.*p22))).*(1./(1 + 1i.*x.*p11.*2.*pi + (1i.*2.*pi.*x.*p12)./(1+1j.*2.*pi.*x.*p22))));

fitfun = fittype(funz);
X0 = [R1_val*C1_val, R1_val*C2_val, R2_val * C2_val];
[fitted_curve, gof] = fit(f', guad', fitfun, "StartPoint", X0, 'Weight', 1./(dguad'));
coeffvals2 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("p11 = %.10f +- %.10f\n", coeffvals2(1), (errors(2, 1) - errors(1, 1))/2);
fprintf("p12 = %.10f +- %.10f\n", coeffvals2(2), (errors(2, 2) - errors(1, 2))/2);
fprintf("p22 = %.10f +- %.10f\n", coeffvals2(3), (errors(2, 3) - errors(1, 3))/2);
figure;
hold on;
errorbar(f, guad, dguad, 'k.');
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
plot(f, funz(coeffvals2(1), coeffvals2(2), coeffvals2(3), f), 'r');
%plot(f, funz(X0(1), X0(2), X0(3), X0(4), X0(5), X0(6), f), 'b');
hold off
grid()
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
grid()
xlabel("Frequenza [Hz]")
ylabel("Guadagno")
saveas(gcf,'tmp/provaes15.png');
legend('dati', 'fit')
grid()
hold off;










































% %load('tmp/Bode_guadagno_es14.mat')
% %c'è da fare prima es.5 per farlo funzionare
% guad = A;
% dguad = dA;
% f = freqs;
% 
% R2_val = 10e3 / 2;
% R1_val = 1e3;
% C1_val = 10e-9;
% C2_val = 68e-9;
% 
% %p11 = (R1 + rint) * C1;
% %p12 = (R1 + rint) * C2;
% %p22 = R2*C2
% 
% funztrasf =@(p11, p12, p22, x)(1./(1 + 1./(2.*pi.*x.*1i.*p22))).*(1./(1 + 1i.*x.*p11.*2.*pi + (1i.*2.*pi.*p12)./(1+1j.*2.*pi.*x.*p22)));
% 
% %funz = @(ft, b, q, x) sqrt((1./sqrt((1 + q)^2 + (ft./x).^2)).^2 + b^2);
% 
% funz_orig = @(p11, p12, p22, x) abs(funztrasf(p11, p12, p22, x));
% funz = @(p11, p12, p22, b, alpha, x) sqrt(funz_orig(p11, p12, p22, x).^2 + b.^2 + 2 .* b .* funz_orig(p11, p12, p22, x) .* cos(alpha));
% %funz = @(ft, b, r_int, alpha, x) 1./ sqrt(1 + (ft./x).^2) + b*0 + r_int * 0 + alpha * 0
% 
% fitfun = fittype(funz_orig);
% X0 = [(R1_val+10)*C1_val, (R1_val+10)*C2_val, R2_val*C2_val];%, +0.004, 0.01];
% [fitted_curve, gof] = fit(f', guad', fitfun, "StartPoint", X0, 'Weight', 1./(dguad'));
% coeffvals2 = coeffvalues(fitted_curve);
% errors = confint(fitted_curve);
% fprintf("ft = %.10f +- %.10f\n", coeffvals2(1), (errors(2) - errors(1))/2);
% fprintf("b = %.10f\n", coeffvals2(2));
% fprintf("q = %.10f\n", coeffvals2(3));
% %plot(f, funz(coeffvals2(1), f), 'b', 'LineWidth', 2);
% figure;
% hold on;
% errorbar(f, guad, dguad, 'k.');
% set(gca, 'XScale', 'log')
% set(gca, 'YScale', 'log')
% plot(f, funz(coeffvals2(1), coeffvals2(2), coeffvals2(3), coeffvals2(4), coeffvals2(5), f), 'r');
% plot(f, funz(X0(1), X0(2), X0(3), X0(4), X0(5), f), 'b');
% hold off
% grid()
% set(gca, 'XScale', 'log')
% set(gca, 'YScale', 'log')
% grid()
% xlabel("Frequenza [Hz]")
% ylabel("Guadagno")
% saveas(gcf,'tmp/provaes15.png');
% legend('dati', 'fit')
% grid()
% hold off;
% 
