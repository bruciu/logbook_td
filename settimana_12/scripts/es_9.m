

t1 = 15; rh1 = 75.61; drh1 = 0.18;
t2 = 20; rh2 = 75.47; drh2 = 0.14;

rh = @(x) rh1 + (x - t1).*(rh2 - rh1)./(t2-t1);
drh = @(x) drh1 + (x - t1).*(drh2 - drh1)./(t2-t1);

rh(t1/2 + t2/2)

rh(meant)
drh(meant)