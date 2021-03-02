%scala biliniare dei dati

[T, V, I] = readiv("data/CIUBRU/bassa_corrente/CIUBRU01.txt");

plot(V, I, 'k.-');
xlim([min(V) max(V)])
ylim([min(I) max(I)])
grid();
xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('I [$\mu$A]', 'Interpreter', 'latex');
% set(gca, 'YScale', 'log');
% set(gca, 'XScale', 'log');