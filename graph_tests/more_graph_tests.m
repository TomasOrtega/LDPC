clear; close all;
N = 20;
K = 10;
R = K / N;

ones_per_column = 3;

H = PEG_v2(N, K, ones_per_column);

girth_of_H(H)

spy(H)

A = H2adjacency(H);
G = graph(A);

figure
p = plot(G);

% Make it pretty
p.XData(1:N) = 1;
p.XData((N + 1):end) = 2;
p.YData(1:N) = flip(linspace(0, 1, N));
p.YData((N + 1):end) = flip(linspace(0, 1, N - K));
