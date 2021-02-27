[T, P, dP, chi2, chi2rid] = fit_folder_bassa('f', "data/CIUBRU/bassa_corrente", true);

T = T + 273.15;
Tm = mean(T,2);
dTm = sqrt(((T(:,2) - T(:,1))./2).^2 + 0.2.^2);
%e_nk = P(:,2).*Tm;
%de_nk = sqrt((dP(:,2).*Tm).^2 + (P(:,2).*dTm).^2);

E = 1.602176634e-19;
K = 1.380649e-23;

%n = E./(e_nk.*K);

%dn = E./(e_nk.^2 .*K) .*de_nk;

n = P(:,1);
dn = dP(:,1);

errorbar(Tm, n, dn./2, dn./2, dTm/2, dTm/2, 'k.-');

grid();
xlabel("Temperatura [K]",  'Interpreter', 'latex')
ylabel('$\eta$', 'Interpreter', 'latex');

Tm = [Tm(1); Tm(3:end)]; dTm = [dTm(1); dTm(3:end)]; p = [P(1, 1); P(3:end,1)]; dp = [dP(1, 1); dP(3:end,1)];
n = p;
dn = dp;

errorbar(Tm, n, dn./2, dn./2, dTm/2, dTm/2, 'k.-');

grid();
xlabel("Temperatura [K]",  'Interpreter', 'latex')
ylabel('$\eta$', 'Interpreter', 'latex');
