% Genero una distribuzione di punti gaussiana
mu  = 0;
sig = 10;
NN  = 10000;
vals = normrnd(mu,sig,1,NN);

% Plotto la distribuzione dei punti
figure(1);
hold off;
[counts bins] = hist(vals,-40:4:40);
bar(bins,counts);

% Calcolo fit gaussiano
par0 = [max(counts) mu sig];
par = nlinfit(bins, counts, @gaussfit, par0);

% Plotto fit gaussiano
xv = mu+sig*(-4:0.1:4);
yv = gaussfit(par,xv);
hold on;
plot(xv,yv,'LineWidth',3);

function yy=gaussfit(pp,xx)
    tmp = (xx-pp(2))/pp(3);
    yy = pp(1)*exp(-tmp.^2/2);
end