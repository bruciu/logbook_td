
% dati
[T, V, I] = readiv("data/CIUBRU/alta_corrente/CIUBRU55.txt");
dV = V * 0 + 0.1e-3;
dI = I * 0 + 0.4;

%I = I * 1e-6;
%dI = dI * 1e-6;

% funzione per calcolare un opportuno epsylon necessario nel calcolo della
% redivata
m_epsylon = sqrt(sqrt(eps));% doppia radice per avere numeri più grandi
epsylon = @(x) abs(x) .* m_epsylon + m_epsylon;
%epsylon = @(x) 0.1;

% funzione di fit
f = @(Is, nVt, R, G, x) curr_G(x, Is, nVt, R, G);

% derivata della funzione di fit
derf = @(Is, nVt, R, G, x)...
    (f(Is, nVt, R, G, x + epsylon(x)) - f(Is, nVt, R, G, x))./...
    epsylon(x);

% parametri iniziali
X0 = [0.6e-3, 0.045, 1.95, 0.9];

figure;
hold on;
errorbar(V, I, dI, dI, dV, dV, 'k.');
xlim([min(V), max(V)]);
m_xlim = xlim;
fplot(@(x) f(X0(1), X0(2), X0(3), X0(4), x), m_xlim);
xlim(m_xlim);
hold off;
set(gca, 'YScale', 'log');

w = 1.0 + V.*0;
for ii = 1:4
    fitfun = fittype(f);
    %[fitted_curve,gof] = fit(V, I,fitfun,'StartPoint',X0, 'Weight', w, 'Lower', [-Inf, -Inf, 0.1, 0], 'Upper', [Inf, Inf, 0.1, Inf]);
    [fitted_curve,gof] = fit(V, I,fitfun,'StartPoint',X0, 'Weight', w, 'Lower',[-Inf, -Inf, sqrt(eps)*2, 0.0]);%, 'Upper', [Inf, Inf, Inf, 0]);
    coeffvals = coeffvalues(fitted_curve);
    w = 1./sqrt((derf(coeffvals(1), coeffvals(2), coeffvals(3), coeffvals(4), V)...
       .* dV(1)).^2 + (dI(1)).^2);
end
X0 = coeffvals;

figure;
subplot(3, 1, [1,2]);
hold on;
errorbar(V, I, dI, dI, dV, dV, 'k.');
xlim([min(V), max(V)]);
m_xlim = xlim;
fplot(@(x) f(X0(1), X0(2), X0(3), X0(4), x), m_xlim);
xlim(m_xlim);
hold off;
set(gca, 'YScale', 'log');
grid();
xlabel("tensione [V]");
ylabel("intensità di corrente [$\mu A$]", "Interpreter", "latex");

subplot(3, 1, 3);
hold on;
model = @(x) f(X0(1), X0(2), X0(3), X0(4), x);
errorbar(V, (I - model(V)) .* w, w * 0+1);
xlim([min(V), max(V)]);
fplot(@(x) x*0)
hold off;
grid();
xlabel("tensione [V]");
xlabel("residui normalizzati [$\sigma$]", "Interpreter", "latex");

params = X0;
conf = confint(fitted_curve);
dparams = (conf(2,:) - conf(1,:))/2;

% num2str(params)
% num2str(dparams)

fprintf("I0 = %.5f +- %f nA\n", params(1)*1e3, dparams(1)*1e3);
fprintf("nVt = %.5f +- %f mV\n", params(2)*1e3, dparams(2)*1e3);
fprintf("R_serie = %.5f +- %f Ohm\n", params(3), dparams(3));
fprintf("R_parallelo = %.5f +- %f Ohm^-1\n", params(4), dparams(4));

return
figure;
hold on;
fplot(@(x) curr(x, 1e-3, 1, 10), [0, 5]);
fplot(@(x) 1e-3.*(exp(x./1) - 1), [0, 5]);
