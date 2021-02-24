%scala biliniare dei dati

[T, V, I] = readiv("data/CIUBRU/bassa_corrente/CIUBRU01.txt");

plot(V, I);
xlim([min(V) max(V)])
ylim([min(I) max(I)])
xlabel("d.d.p. [V]")
ylabel('I [mA]')
set(gca, 'YScale', 'log');
set(gca, 'XScale', 'log');