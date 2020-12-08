

% E:\

filename = 'data/datasett11_lunga_corretto.txt';
delimiterIn = '\t';
A = importdata(filename,delimiterIn);

hold on;
plot(A(:,2));
sm = smussaf(A(:,2), 0.01);
plot(sm);
hold off;

