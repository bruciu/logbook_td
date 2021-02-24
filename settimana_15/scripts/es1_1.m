%scala biliniare dei dati
runs = read_folder("data/CIUBRU/bassa_corrente/");

T = [];
for ii = 1:numel(runs)
    V = runs(ii).V;
    I = runs(ii).I;
    T = [T, strcat(sprintf("%.1f", mean(runs(ii).T)), " °C")];
    hold on;
    plot(V, I, '.-', 'Color', [ii/numel(runs) 0 1-ii/numel(runs)]);
end

xlabel("d.d.p. [V]",  'Interpreter', 'latex')
ylabel('I [$\mu$A]', 'Interpreter', 'latex');
% set(gca, 'YScale', 'log');
% set(gca, 'XScale', 'log');
grid()
legend(T, 'Location', 'best');
hold off;
