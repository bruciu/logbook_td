%load('tmp/Bode_guadagno_es14.mat')
%c'è da fare prima es.5 per farlo funzionare
clear i;
guad = A;
dguad = dA;
f = freqs;

R2_val = (10e3 / 2)*2;
R1_val = (1e3);
C1_val = (10e-9);
C2_val = (68e-9);

ZC1 = @(C1, x) - 1i ./(2.*pi.*x.*C1);
ZC2 = @(C2, x) - 1i ./(2.*pi.*x.*C2);
Z1a = @(C2, R2, x) ZC2(C2, x) + R2;
Z1b = @(R2) R2;
Z2a = @(C2, R2, x) 1./(1./(Z1a(C2, R2, x)) + 1./(Z1b(R2)));
Z2b = @(C1, x) ZC1(C1, x);
Z3a = @(C1, C2, R2, x) 1./(1./(Z2a(C2, R2, x)) + 1./(Z2b(C1)));
Zeq = @(R1, R2, C1, C2, x) Z3a(C1, C2, R2, x) + R1;
Z = @(Zreal, Zimag) Zreal + 1i.*Zimag;

para = @(R1, R2, C1, C2, Zimag, Zreal, x) abs(1 + (Zreal + 1i.*Zimag)./ ( (1./(1./(1./(1./(- 1i ./(2.*pi.*x.*C2) + R2) + 1./R2)) + 1./(- 1i ./(2.*pi.*x.*C1)))) + R1));

%p11 = (R1 + rint) * C1;
%p12 = (R1 + rint) * C2;
%p22 = R2*C2 = = p22real +1i* p22imag

%funztrasf =@(p11, p12, p22, x)(1./(1 + 1./(2.*pi.*x.*1i.*p22))).*(1./(1 + 1i.*x.*p11.*2.*pi + (1i.*2.*pi.*p12)./(1+1j.*2.*pi.*x.*p22)));
funztrasf0 =@(R1, R2, C1, C2, x)(1./(1 + 1./(2.*pi.*x.*1i.*R2.*C2))).*(1./(1 + 1i.*x.*R1.*C1.*2.*pi + (1i.*2.*pi.*x.*R1.*C2)./(1+1j.*2.*pi.*x.*R2.*C2)));
%funztrasf = @ (R1, R2, C1, C2, Zimag, Zreal, x) funztrasf0(R1, R2, C1, C2, x) .*(1 +  (Zreal + 1i.*Zimag)./ Zeq(R1, R2, C1, C2, x));
funztrasf = @ (R1, R2, C1, C2, Zimag, Zreal, x) abs(funztrasf0(R1, R2, C1, C2, x)) .*para(R1, R2, C1, C2,  Zimag, Zreal, x);
%funztrasf =@(p11, p12, p22real, p22imag, x)(1./(1 + 1./(2.*pi.*x.*1i.*(1./(1./p22real + 1./(1i*p22imag)))))).*(1./(1 + 1i.*x.*p11.*2.*pi + (1i.*2.*pi.*p12)./(1+1j.*2.*pi.*x.*(p22real./2 + 1./(1./p22real + 1./(1i * p22imag))))));
%funz = @(ft, b, q, x) sqrt((1./sqrt((1 + q)^2 + (ft./x).^2)).^2 + b^2);

%funz_orig = @(p11, p12, p22, x) abs(funztrasf(p11, p12, p22, x));
%funz = @(p11, p12, p22, b, alpha, x) sqrt(funz_orig(p11, p12, p22, x).^2 + b.^2 + 2 .* b .* funz_orig(p11, p12, p22, x) .* cos(alpha));
%funz = @(ft, b, r_int, alpha, x) 1./ sqrt(1 + (ft./x).^2) + b*0 + r_int * 0 + alpha * 0

funz = @(R1, R2, C1, C2, Zimag, Zreal, x) funztrasf(R1, R2, C1, C2, Zimag, Zreal, x);

fitfun = fittype(funz);
%X0 = [R1_val, R2_val, C1_val, C2_val, 0, 0];
%X0 = [0.9987e3, 9.9550e3, coeffvals2(3), coeffvals2(4), 300, 1e-9];
X0 = [0.9987e3, 9.9550e3, coeffvals2(3), coeffvals2(4), 400, 1e-9];
[fitted_curve, gof] = fit(f', guad', fitfun, "StartPoint", X0, 'Weight', 1./(dguad'));
coeffvals2 = coeffvalues(fitted_curve);
errors = confint(fitted_curve);
fprintf("p11 = %.10f +- %.10f\n", coeffvals2(1), (errors(2) - errors(1))/2);
fprintf("p12 = %.10f\n", coeffvals2(2));
fprintf("p22real = %.10f\n", coeffvals2(3));
fprintf("p22imag = %.10f\n", coeffvals2(3));
coeffvals2(4)
coeffvals2(5)
coeffvals2(6)
%plot(f, funz(coeffvals2(1), f), 'b', 'LineWidth', 2);
figure;
hold on;
errorbar(f, guad, dguad, 'k.');
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
plot(f, funz(coeffvals2(1), coeffvals2(2), coeffvals2(3), coeffvals2(4),  coeffvals2(5),  coeffvals2(6), f), 'r');
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

