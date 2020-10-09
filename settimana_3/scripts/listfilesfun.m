function [tensore] = listfilesfun(Name_folder)
%LISTFILESFUN Summary of this function goes here
%   Detailed explanation goes here
lista = dir(Name_folder);
%listaName = strsplit(num2str(1:numel(Name_folder)));
%for i = 1:numel(lista)
%    listaName(i) = lista(i).name;
    %display(lista(i).name);
%end
%display(lista)
for i = 3:numel(lista)
    name = strcat(strcat(Name_folder, '/') , lista(i).name);
    %display(name);
    Titolo1 = strrep(lista(i).name,'.txt','');
    Titolo2 = strcat(Titolo1, ' completo')
%     Titolo = name(1:numel(name)-4);
%     display(Titolo);
    %Titolo = strsplit(num2str(1:(numel(Name_folder)-4)));
%     for j = 1:numel(Titolo)
%         Titolo(j) = name(j);
%     end
%     display(Titolo);
    [xx, yy] = leg_wavf(name);
    vector = [xx, yy];
    %display(vector);
    [f, A, phi] = myFFT(yy, ((xx(3) - xx(2))/2));
    [fmax, dfmax] = calcolaFmax(yy, ((xx(3) - xx(2))/2));
    hold on
    grid on
    plot(f, A, 'black.', 'LineWidth', 0.5)
    plot(f, A, 'yellow-', 'LineWidth', 0.5)
    minx = max(0, fmax - 10^(3));
    maxx = fmax+10^(3);
    axis([minx  maxx  min(A)-0.1 max(A)+0.1])
    %xlabel('-\pi \leq \itt \leq \pi')
    %xlabel(strcat(strcat(sprintf('%d', minx), 'Hz \leq  frequenza  \leq '),sprintf('%d Hz',maxx)))
    xlabel("Frequenza [Hz]")
    ylabel('Ampiezza FFT')
    title(Titolo1)
    hold off;
    figure;
    hold on
    grid on
    plot(f, A, 'black.', 'LineWidth', 0.5)
    plot(f, A, 'yellow-', 'LineWidth', 0.5)
    axis([0 max(f) min(A)-0.1 max(A)+0.1])
    hold off;
    %plot(vector(:,1), vector(:,2), 'green.-', 'LineWidth', 0.5)%, '.-')%, 'LineWidth', 2, '.-')
    %axis([min(vector(:,1)) max(vector(:,1)) min(vector(:,2)) max(vector(:,2))]);
%, '.-');
    figure;
end
%vector = zeros(1, 3);
tensore = 0;
end

