R1 = 10e3; 
R2 = 100;
GBP = 2.8e6;
w = linspace(10^4, 10^8, 1000);
A0 = 10^(110/20);
tau = A0/(2*pi*GBP)
Guad = @(x) GuadagnoG(beta(R1, R2), A0./(1 + 1i.*x.*tau));
y = abs(Guad(w));
plot(w, y)
ylim([min(y), max(y)]);
xlabel("$\omega$ [$rad^{-1}$]", 'Interpreter', 'Latex')
ylabel("Loop Gain G")
legend('$G(\omega) = \frac{A(\omega)}{1 + A(\omega) \beta}$', 'Interpreter', 'Latex', 'Fontsize', 12)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
grid()
saveas(gcf,'tmp/provaes3.png');