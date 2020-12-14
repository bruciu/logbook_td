
pressioni = A(:,2);

hold on
plot(pressioni, '.');
plot(smussa(pressioni, 0.05), "linewidth", 2);
hold off


function [yy_smooth] = smussa(yy, K)
    ft = fft(yy);
    for i = 1:ceil(length(ft)/2)
        if (i/ceil(length(ft)/2) > K)
            ft(i+1) = 0;
            ft(end-i+1) = 0;
        end
    end
    yy_smooth = abs(ifft(ft));
end


