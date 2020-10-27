function [tensore] = listfilesfun(Directory, Name_folder, boolgauss, boolparziale, boolcompleto, boolsave, booldoppio, boolsemilogy)
%LISTFILESFUN Summary of this function goes here
%   Detailed explanation goes here
lista = dir(strcat(Directory, Name_folder));
%listaName = strsplit(num2str(1:numel(Name_folder)));
%for i = 1:numel(lista)
%    listaName(i) = lista(i).name;
    %display(lista(i).name);
%end
%display(lista)
for i = 3:numel(lista)
    name = strcat(strcat(Name_folder, '/') , lista(i).name);
    name2 = strcat(Directory, name);
    %display(name);
    Titolo1 = strrep(lista(i).name,'.txt','');
    Titolo2 = strcat(Titolo1, ' completo');
    Titolo3 = 'FFT';
%     Titolo = name(1:numel(name)-4);
%     display(Titolo);
    %Titolo = strsplit(num2str(1:(numel(Name_folder)-4)));
%     for j = 1:numel(Titolo)
%         Titolo(j) = name(j);
%     end
%     display(Titolo);
    [xx, yy] = leg_wavf(name2);
    vector = [xx, yy];
    %display(vector);
    [f, A, phi] = myFFT(yy, ((xx(3) - xx(2))/2));
    %[fmax, dfmax] = calcolaFmax(yy, ((xx(3) - xx(2))/2));
    %display(fmax);
    %display(dfmax);
    [~, kmax] = max(A);
    fmax = f(kmax);
    if boolparziale == 1
%         hold on
%         grid on
        if booldoppio == 1
            subplot(2, 1, 1);
            hold on
            grid on
            q = plot(vector(:, 1), vector(:, 2), 'blue-');
            q.Color(4) = 0.3;
            xlabel("Tempo [s]")
            ylabel("Tensione [V]")
            minx = min(vector(:,1));
            maxx = max(vector(:,1));
            display(minx);
            display(maxx);
            %axis([minx  maxx  min(vector(2))-0.1 max(vector(2))+0.1])
            xlim([minx, maxx])
            ylim([min(vector(:,2))-1, max(vector(:,2))+1])
        end
        title(Titolo1)
        if booldoppio == 1
            subplot(2, 1, 2);
        end
        hold on
        grid on
        if boolsemilogy == 0
            stem(f, A, 'black.', 'LineWidth', 0.5)
        else
            plot(f, A, 'blue-', 'LineWidth', 0.5)
            a = area(f, A);
            a.FaceColor = 'blue';
            a.EdgeColor = 'blue';
            a.FaceAlpha = 0.6;
        end
        %plot(f, A, 'yellow-', 'LineWidth', 0.5)
        minx = max(0, fmax - 10^(3));
        maxx = min(fmax+10^(3), max(f));
        %axis([minx  maxx  min(A)-0.1 max(A)+0.1])
        xlim([minx  maxx])
        ylim([min(A)-0.1 max(A)+0.1])
        %xlabel('-\pi \leq \itt \leq \pi')
        %xlabel(strcat(strcat(sprintf('%d', minx), 'Hz \leq  frequenza  \leq '),sprintf('%d Hz',maxx)))
        xlabel("Frequenza [Hz]")
        ylabel('Ampiezza FFT')
        if boolsemilogy == 1
            %semilogy(f, A, 'black.', 'LineWidth', 0.5)
            set(gca, 'YScale', 'log');
        end
        hold off;
        if boolsave == 1
            if boolsemilogy == 1
            saveas(gcf,strcat(strcat('C:/Users/Serena/Desktop/immagini_listfiles/semilogy_', Titolo1), '.png'))
            else
            saveas(gcf,strcat(strcat('C:/Users/Serena/Desktop/immagini_listfiles/', Titolo1), '.png'))
            end
        end
        figure;
    end
    if boolcompleto == 1
%         hold on
%         grid on
        if booldoppio == 1
            subplot(2, 1, 1);
            hold on
            grid on
            q = plot(vector(:, 1), vector(:, 2), 'blue-');
            q.Color(4) = 0.3;
            xlabel("Tempo [s]")
            ylabel("Tensione [V]")
            minx = min(vector(:,1));
            maxx = max(vector(:,1));
            display(minx);
            display(maxx);
            %axis([minx  maxx  min(vector(2))-0.1 max(vector(2))+0.1])
            xlim([minx, maxx])
            ylim([min(vector(:,2))-1, max(vector(:,2))+1])
        end
        title(Titolo2)
        if booldoppio == 1
            subplot(2, 1, 2);
        end
        hold on
        grid on
        if boolsemilogy == 0
            stem(f, A, 'black.', 'LineWidth', 0.5)
        else
            plot(f, A, 'blue-', 'LineWidth', 0.5)
            a = area(f, A);
            a.FaceColor = 'blue';
            a.EdgeColor = 'blue';
            a.FaceAlpha = 0.6;
        end
        %plot(f, A, 'yellow-', 'LineWidth', 0.5)
        axis([0 max(f) min(A)-0.1 max(A)+0.1])
        xlabel("Frequenza [Hz]")
        ylabel('Ampiezza FFT')
        %title(Titolo2)
        if boolsemilogy == 1
            %semilogy(f, A, 'black.', 'LineWidth', 0.5)
            set(gca, 'YScale', 'log');
        end
        hold off;
        if boolsave == 1
            if boolsemilogy == 1
            saveas(gcf,strcat(strcat('C:/Users/Serena/Desktop/immagini_listfiles/semilogy_', Titolo2), '.png'))
            else
            saveas(gcf,strcat(strcat('C:/Users/Serena/Desktop/immagini_listfiles/', Titolo2), '.png'))
            end
        end
        figure;
    end
    if boolgauss==1
        z = complex(A.*cos(phi), A.*sin(phi));
        %plot(real(z), imag(z))
        compass(z)%, '-.');
        hold on
        grid on
        %stem(f, A, 'black.', 'LineWidth', 0.5)
        %plot(f, A, 'yellow-', 'LineWidth', 0.5)
        %minx = max(0, fmax - 10^(3));
        %maxx = fmax+10^(3);
        %axis([minx  maxx  min(A)-0.1 max(A)+0.1])
        %xlabel('-\pi \leq \itt \leq \pi')
        %xlabel(strcat(strcat(sprintf('%d', minx), 'Hz \leq  frequenza  \leq '),sprintf('%d Hz',maxx)))
        xlabel('Frequenza [Hz]')
        ylabel('Ampiezza FFT')
        title(Titolo3)
        hold off;
        figure;
    end
end
%vector = zeros(1, 3);
tensore = 0;
end

