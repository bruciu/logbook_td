R1 = 10e3; 
R2 = 100;
A = linspace(10^3, 10^5, 1000);
y = GuadagnoG(beta(R1, R2), A);

plot(A, y)
%ylim([min(y), max(y)]);
xlabel("Open Loop Gain A")
ylabel("Loop Gain G")
legend('$G = \frac{A}{1 + A \beta}$', 'Interpreter', 'Latex', 'Fontsize', 12)
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
grid()
saveas(gcf,'tmp/provaes2.png');